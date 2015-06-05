#----------------------------------------------------------------------
# $Id: //Tuxedo/RELEASE/Product/release/webserver/CgiSettingsDir.pm#2 $
#----------------------------------------------------------------------
# The package name used here must be the same as that in IRISLink.cgi.
package DgwWeb;

# Export variables listed here
use vars qw( $ConfigDirectory);

# Depending on web server configuration it may be possible and/or desired
# to set this location to "./" to indicate that CgiSettings.pm exists in
# the same directory as IRISLink.cgi. One reason that may not be desirable
# is because the contents of CgiSettings.pm might be considered sensitive
# or a security risk.

# The best recommendation is to store CgiSettings.pm in $LOCAL_HOME/perl_libs
# because this location is outside of the web server's document root.
# This configuration ensures that the file can not be exposed to public web 
# end users. Some alternative locations are suggested, commented out below.

# If you are using CAS, then AuthCasDgw.pm should also exist in this directory
# or in one of the $ENV{PERL5LIB} directories. 

#perl_libs is the default location of CgiSettings.pm
#$ConfigDirectory = "../local/perl_libs";
#Other examples of places where CgiSettings.pm can be copied or located:
$ConfigDirectory = "../local/perl_libs";
#$ConfigDirectory = "../app/common";
#$ConfigDirectory = "../config";
#$ConfigDirectory = "./";

1;
