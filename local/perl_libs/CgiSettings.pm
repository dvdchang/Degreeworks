# CgiSettings.pl - Settings shared by IRISLink.cgi and app/scripts/authcas
#----------------------------------------------------------------------
# $Id: //Tuxedo/RELEASE/Product/release/webserver/CgiSettings.pm#5 $
#----------------------------------------------------------------------
# FILENAME    : /opt/perl_libs/CgiSettings.pm
# MPE FILENAME: 
# MPE DATE    : 
#
# PROVIDES:
#   CgiSettings
#
# DESCRIPTION:
#   Contains settings/configuration values shared by IRISLink.cgi and authcas.
#----------------------------------------------------------------------
# The package name used here must be the same as that in IRISLink.cgi.
package DgwWeb;

use vars qw( $FALSE $TRUE $DEF_PORTNUMBER $NUMBER_OF_PORTS $USE_PORT_RANGES 
             $DEF_SERVER_NAME @ALLOWED_URLS $REQUIRE_HTTP_REFERER $ACCEPTABLE_METHOD 
             $NOCACHE_OPTION $TIMEOUT_ERROR_MESSAGE $DEBUG_LEVEL $LogFile $DEF_TIMEOUT 
             $ALLOW_CHECKMODPERL $ENABLE_LUMINIS_INTEGRATION
             $CAS_Enabled $CAS_URL $CAS_CAFile $CAS_ID_Attribute_Name 
             $CAS_USER_CONTAINS_ID $DEFAULT_INPUT_ENABLED
             $DEFAULT_INPUT_VALUES $External_AuthAssertion_Name 
             $External_AuthAssertion_isCookie $External_AuthAssertion_isUdcId);

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# PROGRAM VARIABLES
#-------------------------------------------------------------------------------
$FALSE = 0;
$TRUE  = 1;

# SITE CONFIGURATION
#-------------------------------------------------------------------------------
# The port on which WEB08 is listening.
$DEF_PORTNUMBER = 8802;
$NUMBER_OF_PORTS = 50;    # 50 ports are supported
$USE_PORT_RANGES = $FALSE; # True=Use Ranges; False= use DEF_PORTNUMBER

# The machine where WEB08 is running.
# For example:     'YourUnixHost.edu' or '123.5.6.78'
$DEF_SERVER_NAME = 'localhost';

# An array of URLs that are allowed to access this CGI.
# For example:  ("YourWebserver.edu", "YourOtherWebserver.edu")
@ALLOWED_URLS = ("dwreporting.coloradomesa.edu", "dwreporting.coloradomesa.edu/prod","dwreporting.coloradomesa.edu:8443/prod/StudentPlanner");

# Check that the request came from a valid HTTP_REFERER or valid HTTP_ORIGIN
# Set this to $TRUE or $FALSE.
# When FALSE ALLOWED_URLS is ignored; when TRUE ALLOWED_URLS are obeyed
#does not work with CAS: $REQUIRE_HTTP_REFERER = $TRUE;
$REQUIRE_HTTP_REFERER = $FALSE;
# Set this to $TRUE if you are using Luminis integration
$ENABLE_LUMINIS_INTEGRATION = $FALSE;
# Restricts HTTP requests to "POST", "GET" or "BOTH".
$ACCEPTABLE_METHOD = "BOTH";

# Cach-control is for IE; Pragma is for Netscape
# For this to work in Netscape you must run with SSL
$NOCACHE_OPTION = "Cache-Control: no-cache\nPragma: no-cache\n";

# The NOCACHE option will prevent go-back from working.
# The GPA Calculator in DegreeWorks requires the use of
# go-back and thus the NOCACHE option should not be used.
# Comment out this line to enable the NOCACHE option.
$NOCACHE_OPTION = "";

$TIMEOUT_ERROR_MESSAGE = "A timeout occurred while waiting for a response. " .
                         "Please try your request again.";

# Set DEBUG_LEVEL=1 for brief debug or DEBUG_LEVEL=2 for extended debug.
$DEBUG_LEVEL = 0;

# Set the debug file name. The web server user must have write access to it.
# Never create this file in a public web server location. Doing so could
# expose a security risk.
$LogFile = '/tmp/cgi.log';

# ALLOW_CHECKMODPERL
#
# Setting this variable to $TRUE allows you to check whether or not
# IRISLink.cgi is running under mod_perl or not, and if so, what version
# of mod_perl. This is a security setting, in that you may not want
# others to be able to see this information. To use this feature, add 
# "?CheckModPerl" after the IRISLink.cgi link in your browser. E.g. 
# http://myhost.mycollege.edu/myPathTo/DegreeWorks/IRISLink.cgi?CheckModPerl

$ALLOW_CHECKMODPERL = $FALSE;

# Set the time in seconds to wait for WEB08 reply.
$DEF_TIMEOUT = 120;

# Set to $TRUE to enable CAS integration. 
# If this is set to true and if a GET/POST form parameter CAS=ENABLED,
# then every end-user will be redirected to the CAS server for login.
#orig: $CAS_Enabled = $FALSE;
$CAS_Enabled = $TRUE;

# Set $CAS_URL to the url for your CAS server. This url should begin with https://
# since CAS requires HTTPS/SSL.
$CAS_URL = 'https://cas.coloradomesa.edu/';

# Location of the certificate or certificate authority file for
# the CAS web server's SSL certificate.
#orig: $CAS_CAFile = "/usr/local/certificates/tomcatcert.pem";
$CAS_CAFile = "/etc/pki/tls/certs/CACerts.pem";

# In the unlikely scenario that the <cas:user> node contains the ID that
# DegreeWorks should use to identify the user internally, set $CAS_USER_CONTAINS_ID = $TRUE.
# Doing so will disable the ability to look for that ID in an attribute named by CAS_ID_Attribute_Name.
$CAS_USER_CONTAINS_ID = $FALSE;

# Set the CAS user ID attribute name, this must be the same value that is 
# configured in CAS attribRepository for the user ID attribute mapping.
$CAS_ID_Attribute_Name = 'studentid';

#For compatibility with Luminis and SEP drag-n-drop DEFAULT_INPUT_VALUES can be set
#in CgiSettings.pm instead of sending form input
$DEFAULT_INPUT_ENABLED = $TRUE;
$DEFAULT_INPUT_VALUES = "SERVICE=LOGON&SCRIPT=SD2WORKS";

# Cgi will always look for an input header or cookie with this name and will send it to web09 as "ASSERT_VALUE".
# The name must match the name which is configured in your external access manager.
# The name of the assertion itself is not used by web09 but it is sent as "ASSERT_NAME".
$External_AuthAssertion_Name = '';

# Cgi will look for an input cookie of name $External_AuthAssertion_Name if this is set to $TRUE.
# This must agree with configuration in your external access manager to determine whether the
# assertion should be sent as a cookie or header.
# If this is $FALSE, then the cgi will look for an input header for the external authentication assertion.
$External_AuthAssertion_isCookie = $TRUE;

# If this is $TRUE, then the web09 will be instructed to use the external assertion
# to find user by udc_id (shp_user_mst.shp_alt_id).
# If this is $FALSE, then the web09 will validate the asserted user ID by rad_id.
$External_AuthAssertion_isUdcId = $FALSE;

1;
