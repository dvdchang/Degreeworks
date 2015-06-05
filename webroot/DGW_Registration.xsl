<!-- 
 Copyright 1995-2012 Ellucian Company L.P. and its affiliates. 
 $Id: //Tuxedo/RELEASE/Product/webroot/DGW_Registration.xsl#10 $ -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<!--
TODO: The block radio button needs the req-id and node-id=0
TODO: The rule radio button needs the req-id in addition to its node-id
Colors:
000066 - darker blue
660000 - dark red
CCCC99 - dark beige
EE0000 - bright red
88bbff - light blue 2
F4F4F4 - light grey
&#160; - space
-->


<!-- Variables available for customizing -->
<xsl:variable name="DisclaimerDocument" select="document('AuditDisclaimer.xml')"/> 
<xsl:variable name="LabelStillNeeded">Still Needed:</xsl:variable>
<xsl:variable name="vShowTitleCreditsInHint">Y</xsl:variable>
<xsl:variable name="vGetCourseInfoFromServer">Y</xsl:variable>

<!-- CMU Localization === Changed format from 3 to 2 decimals 
<xsl:variable name="vCreditDecimals">0.###</xsl:variable> -->
<xsl:variable name="vCreditDecimals">0.##</xsl:variable>
<xsl:variable name="vGPADecimals">0.00</xsl:variable>
<!-- CMU Localization === End of Changed format from 3 to 2 decimals -->


<xsl:variable name="vShowToInsteadOfColon">Y</xsl:variable> <!-- ":" is replaced with " to " in classes/credits range -->

<xsl:key name="ClsKey"    match="Audit/Clsinfo/Class" use="@Id_num"/>
<xsl:key name="ClsCrdReq" match="Header/Qualifier" use="@Node_type"/>
<xsl:key name="BlockKey"  match="Audit/Block" use="@Req_id"/>

<!-- If we don't get an Audit tree we should get an Error node -->
<xsl:template match="Error">
<html>
	<link rel="stylesheet" href="DGW_Style.css" type="text/css" />
<body>
<form name="frmAudit" ID="frmAudit">
  <span class="ErrorMessage"> 
  <xsl:choose>
   <xsl:when test="@Status='1234'">	 
   </xsl:when>
   <xsl:otherwise>
    Status = <xsl:value-of select="@Status"/>
	<br />
    <xsl:value-of select="@WhatMessage"/>
	<br />
    <xsl:value-of select="@ActionMessage"/>
   </xsl:otherwise>
  </xsl:choose>
  </span>
<xsl:call-template name="tToggleButtons" />
</form>
</body>
</html>
</xsl:template> <!-- match=Error -->

<xsl:template match="Audit">
<html>
 <title>
 Advising Worksheet for <xsl:value-of select="/Report/@rptStudentName" /> 
 </title>
 <link rel="stylesheet" href="DGW_Style.css" type="text/css" />
<script language="JavaScript">
//////////////////////////////////////////////////////////////////////
// Get the information for this course when the user clicks on the course
// as part of AdviceLink
//////////////////////////////////////////////////////////////////////
function GetCourseInfo(sDisc, sNumber, sAttribute, sAttributeOp)
{
var sWindowParams = "width=600,height=300,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
var sWindowName = "wCourseInfo";
var wNew = window.open("", sWindowName, sWindowParams);

<xsl:choose>
  <xsl:when test="normalize-space(/Report/@rptCourseLeafURL)!=''">
   <!-- http://sungard.dev8.leepfrog.com/courseinfo/?list=ENGL:103&major=MATH,HIST&stylesheet=CourseLeaf.xsl -->
   sHref = "<xsl:copy-of select="normalize-space(/Report/@rptCourseLeafURL)" />" + "?";
   sHref = sHref + "list=" + sDisc + "-" + sNumber;
   <!-- Add the list of majors   -->
   sHref = sHref + "&amp;major=";
   <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='MAJOR']">
   sHref = sHref + "<xsl:value-of select="normalize-space(@Value)" />"; 
    <xsl:if test="position()!=last()">sHref = sHref + ",";</xsl:if>  <!-- add a comma -->
   </xsl:for-each>
    // Stylesheet needs to be stored on CourseLeaf server (not on DW server)
   sHref = sHref + "&amp;stylesheet=DegreeWorks-CourseLink-Description.xsl";
  //alert ("GetCourseInfo - CourseLeaf Href = " + sHref);
  wNew.location.href = sHref;
  </xsl:when>
  <xsl:otherwise>
   sThisAttribute = "";
   sThisAttributeOp = "";
   if (sAttribute != undefined)
   {
      sThisAttribute = sAttribute;
       if (sAttributeOp != undefined)
       {
        if (sAttributeOp == "&lt;&gt;")
         sThisAttributeOp = "&lt;&gt;";    // not-equals
        else if (sAttributeOp == "&lt;=")
         sThisAttributeOp = "&lt;=";       // less-than-equals
        else if (sAttributeOp == "&gt;=")
         sThisAttributeOp = "&gt;=";       // greater-than-equals
        else if (sAttributeOp == "&lt;")
         sThisAttributeOp = "&lt;";        // less-than
        else if (sAttributeOp == "&gt;")
         sThisAttributeOp = "&gt;";        //   greater-than
          else // default to equals
         sThisAttributeOp = "=";           // equsls
       }
   }
    // Do not use the frmCourseInfo form in frControl because SEP cannot make use of it
    // Instead both in classic and in SEP we will create a new form that we will use instead

    var method = "POST";
    // This --path-- will be replaced by a complete URL to IRISLink.cgi by the SEP Java code
    // If we are not w/in SEP then the path needs to be the name we find in frControl
    var pathToCgi = '--path--';

    // If we are not in SEP the frControl frame should exist - so get the action
    if (pathToCgi.substring(0,2) == "--" &amp;&amp; typeof(top.frControl) != "undefined")
      pathToCgi = top.frControl.document.frmCourseInfo.action;

    // Create a new form for the request
    var form = document.createElement("form");
    // Move the submit function to another variable so that it doesn't get overwritten
    form._submit_function_ = form.submit;

    form.setAttribute("method", method);
    form.setAttribute("action", pathToCgi);
    form.setAttribute("target", sWindowName);

    appendFormChild(form, "COURSEDISC",   '"' + sDisc   + '"');
    appendFormChild(form, "COURSENUMB",   '"' + sNumber + '"');
    appendFormChild(form, "SCRIPT",       "SD2COURSEINFO");
    appendFormChild(form, "COURSEATTR",   sThisAttribute);
    appendFormChild(form, "COURSEATTROP", sThisAttributeOp);
    appendFormChild(form, "REPORT",        '<xsl:value-of select="/Report/@rptReportCode" />');
    appendFormChild(form, "REPORTUCLASS",  '<xsl:value-of select="/Report/@rptReportCode" /><xsl:value-of select="/Report/@rptUserClass" />');
    
    appendFormChild(form, "ContentType", "xml");
    document.body.appendChild(form);
    form._submit_function_(); // call the renamed function
    wNew.focus(); <!--  needed in case window was already open -->
  </xsl:otherwise>
</xsl:choose>
}
//////////////////////////////////////////////////////////////////////
function appendFormChild(form, inputName, inputValue)
{
  var hiddenElement = document.createElement("input");
  hiddenElement.setAttribute("type", "hidden");
  hiddenElement.setAttribute("name", inputName);
  hiddenElement.setAttribute("value",inputValue);
 
  form.appendChild(hiddenElement);
}
</script>
<body style="margin: 5px;">
<form name="frmAudit" ID="frmAudit">

<!-- // Legend (Top) // -->
<xsl:if test="/Report/@rptShowLegend='Y'">
<!--<xsl:call-template name="tLegend"/>-->
</xsl:if>

<!-- // School Header // -->
<xsl:call-template name="tSchoolHeader"/>

<!-- // Student Header // -->
<xsl:if test="/Report/@rptShowStudentHeader='Y'">
<xsl:call-template name="tStudentHeader"/>
</xsl:if>

<!-- CMU Localization === Moved disclaimer to display at the top --> 
<xsl:if test="/Report/@rptShowDisclaimer='Y'">
	<xsl:call-template name="tDisclaimer"/>
</xsl:if> 
<!-- CMU Localization === End of Moved disclaimer to display at the top --> 

<!-- // Progress Bar // -->
<xsl:if test="/Report/@rptShowProgressBar='Y'">
<xsl:call-template name="tProgressBar"/>
</xsl:if>


<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- // Requirement Blocks (for-each one) // -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:for-each select="Block">
<!-- Create a very small amount of whitespace between blocks using this table-->
<table border="0" cellspacing="1" cellpadding="0" width="100%"><tr><td></td></tr></table>

<!-- Each requirement block is one big table.  Here is the beginning of it.  
     It is NOT nested within another table-->
<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">

<!--//////////////////////////////////////////////////// 
	// Block Header									-->
	<xsl:call-template name="tBlockHeaderChoose"/>

<!--//////////////////////////////////////////////////// 
	// Header Qualifier Advice						-->
	<xsl:if test="/Report/@rptShowQualifierAdvice='Y'">
	<xsl:if test="Header/Advice"> 
		<xsl:call-template name="tHeaderQualifierAdvice"/>
	</xsl:if>
	</xsl:if>  

<!--//////////////////////////////////////////////////// 
	// Block Remarks Rows							-->
	<xsl:if test="/Report/@rptShowBlockRemarks='Y'">
	<xsl:if test="Header/Remark"> 
		<xsl:call-template name="tBlockRemarks"/>
	</xsl:if> 
	</xsl:if>  

<!--//////////////////////////////////////////////////// 
	// Block Qualifier Rows							-->
	<xsl:if test="/Report/@rptShowQualifierText='Y'">
	<xsl:if test="Header/Qualifier"> 
		<xsl:call-template name="tBlockQualifiers"/>
	</xsl:if>
	</xsl:if>  

<!--//////////////////////////////////////////////////// 
	// Rule Rows									-->
	<xsl:for-each select=".//Rule">
	<xsl:if test="@RuleType != 'IfStmt'">
	<xsl:if test="@Per_complete != 'Not Used'">
	<xsl:if test="@Per_complete != 'Not Needed'">
	<xsl:if test="@Per_complete &lt; 100">
		<xsl:choose>
        <!-- When there is an ancestor node, check to see if any of them are 
              "Not Needed" If so, do not show the rule.  This happens in nested group rules. -->
        <xsl:when test="ancestor::Rule and ancestor::Rule[*]/@Per_complete  = 'Not Needed'"> 
          <!-- Do nothing -->
        </xsl:when>

        <xsl:when test="/Report/@rptShowRuleText='N' and
		                ancestor::Rule[*]/@RuleType  = 'Group' and 
                        ancestor::Rule[*]/@Per_complete = '98' and not(@Per_complete='100' or @Per_complete='98')">
          <!-- do not show the labels for the rules within the group that is already completed -->
        </xsl:when>

		<!-- block rule - block is missing -->
    <xsl:when test="Advice/BlockID/. = 'NOT_FOUND' and Requirement/Qualifier/@Name != 'HIDERULE' and Requirement/Qualifier/@Node_type != 'HideRule'"> 
  		  <xsl:call-template name="tRules"/>
		</xsl:when>
     <xsl:when test="Requirement/Qualifier/@Name = 'HIDERULE' or Requirement/Qualifier/@Node_type = 'HideRule' ">
        <xsl:choose>
          <xsl:when test="(@RuleType = 'Block' or @RuleType = 'Blocktype') and not (Advice)">
            <!-- hide the block or blocktype rule - there is no advice node - probably it is 100% complete -->
         </xsl:when>
         <xsl:when test="@RuleType = 'Block' and Advice/BlockID/. = 'NOT_FOUND'">
            <!-- Block is missing; it is important to see that the block is missing -->                          
            <xsl:call-template name="tRules"/>
         </xsl:when>
         <xsl:when test="@RuleType = 'Blocktype' and count(Advice/Title) = 0">
            <!-- Blocktype is missing; it is important to see that the block is missing -->                          
            <xsl:call-template name="tRules"/>
         </xsl:when>
         <xsl:when test="@RuleType = 'Block' and Advice/BlockID/. != 'NOT_FOUND'">
            <!-- hide the block rule - block was found; regardless of it being 0% or 50% complete -->
         </xsl:when>
         <xsl:when test="@RuleType = 'Blocktype' and Advice/Title">
            <!-- hide the blocktype rule - block was found; regardless of it being 0% or 50% complete -->
         </xsl:when>         
         <xsl:when test="/Report/@rptShowRuleText = 'Y' or @Per_complete &gt; 0">
            <xsl:call-template name="tRules"/>
         </xsl:when>
        </xsl:choose>
      </xsl:when>
		<!-- Check to see if this rule is within a group rule that has HideRule.
		     We check the parent group rule up to 4 levels deep (hence the 0, 1, 2, 3 numbers in Rule[x] -->
        <!-- hide the group rule options for hidden group rule that is 0% complete -->
        <xsl:when test="(ancestor::Rule[0]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[0]/Requirement/Qualifier/@Node_type = 'HideRule') and
                        ancestor::Rule[0]/@RuleType = 'Group' and 
                        ancestor::Rule[0]/@Per_complete = '0'">
          <!-- hide it -->
        </xsl:when>
        <!-- hide the group rule options for hidden group rule that is 0% complete -->
        <xsl:when test="(ancestor::Rule[1]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[1]/Requirement/Qualifier/@Node_type = 'HideRule') and
                        ancestor::Rule[1]/@RuleType = 'Group' and 
                        ancestor::Rule[1]/@Per_complete = '0'">
          <!-- hide it -->
        </xsl:when>
        <!-- hide the group rule options for hidden group rule that is 0% complete -->
        <xsl:when test="(ancestor::Rule[2]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[2]/Requirement/Qualifier/@Node_type = 'HideRule') and        
                        ancestor::Rule[2]/@RuleType = 'Group' and 
                        ancestor::Rule[2]/@Per_complete = '0'">
          <!-- hide it -->
        </xsl:when>
        <!-- hide the group rule options for hidden group rule that is 0% complete -->
        <xsl:when test="(ancestor::Rule[3]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[3]/Requirement/Qualifier/@Node_type = 'HideRule') and
                        ancestor::Rule[3]/@RuleType = 'Group' and 
                        ancestor::Rule[3]/@Per_complete = '0'">
          <!-- hide it -->
        </xsl:when>

		<xsl:otherwise>
			<xsl:call-template name="tRules"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:if> 
	</xsl:if> 
	</xsl:if> 
	</xsl:if> 
	</xsl:for-each> 

</table>

</xsl:for-each> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- // END Requirement Blocks (for-each one) // -->
<!-- //////////////////////////////////////////////////////////////////////// -->


<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Sections:  Fallthrough, Insufficient, Inprogress, OTL (Not Counted, aka Over-the-Limit) 
     (these are all tables that are not nested) -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<br/>

<!--//////////////////////////////////////////////////// 
	// Fallthrough Section							-->
	<xsl:if test="/Report/@rptShowFallThroughSection='Y'">
		<xsl:call-template name="tSectionFallthrough"/>
	</xsl:if> 

<!--//////////////////////////////////////////////////// 
	// Insufficient Section							-->
	<xsl:if test="/Report/@rptShowInsufficientSection='Y'">
		<xsl:call-template name="tSectionInsufficient"/>
	</xsl:if> 

<!--//////////////////////////////////////////////////// 
	// Inprogress Section (aka In-Progress)			-->
    <xsl:if test="/Report/@rptShowInProgressSection='Y'">
		<xsl:call-template name="tSectionInprogress"/>
    </xsl:if> 

<!--//////////////////////////////////////////////////// 
	// Not Counted Section (aka OTL, Over-the-limit) -->
    <xsl:if test="/Report/@rptShowOverTheLimitSection='Y'">
		<xsl:call-template name="tSectionOTL"/>
    </xsl:if> 

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- // END Sections -->
<!-- //////////////////////////////////////////////////////////////////////// -->

<br/>

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Exceptions -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:if test="/Report/@rptShowExceptionsSection='Y'">
<xsl:if test="ExceptionList/Exception">
	<xsl:call-template name="tSectionExceptions"/>
</xsl:if> 
</xsl:if> 

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Notes -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:if test="/Report/@rptShowNotesSection='Y'">
<xsl:if test="Notes/Note[@Note_type != 'PL']">
	<xsl:call-template name="tSectionNotes"/>
</xsl:if> 
</xsl:if> 

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Legend (Bottom) -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:if test="/Report/@rptShowLegend='Y'">
	<xsl:call-template name="tLegend"/>
</xsl:if> 

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Disclaimer (Bottom)-->
<!-- //////////////////////////////////////////////////////////////////////// -->

<!-- CMU Localization === Do not display disclaimer at the bottom 
<xsl:if test="/Report/@rptShowDisclaimer='Y'">
	<xsl:call-template name="tDisclaimer"/>
</xsl:if> 
-->

<!-- Enable audit buttons in SD2AUDCON -->
<xsl:call-template name="tToggleButtons" />

</form>

</body>
</html>
</xsl:template>

<xsl:template name="tToggleButtons">
<xsl:for-each select="/Report/ReloadButtons">
<script language="JavaScript">
try
{
	top.frSelection.ToggleButtons("on");	
}
catch (err)
{
	// this is fine -- it just means the top frame does not exist
}
</script>
</xsl:for-each>
</xsl:template>

<!-- tCourseAdvice - used for displaying courses in requirement advice -->
<xsl:template name="tCourseAdvice">
  <!-- AdviceLink: Link to a new browser when user clicks on class in advice -->
  <xsl:choose>

   <!-- <xsl:when test="/Report/@rptShowAdviceLink='Y' and (not(contains(@Disc,'@')) and not(contains(@Num,'@')))"> -->
   <!-- We will allow a wildcard in the course number if GetCourseInfo flag is Y -->
   <xsl:when test="/Report/@rptShowAdviceLink='Y' and not(contains(@Disc,'@')) and 
                   ($vGetCourseInfoFromServer='Y' or not(contains(@Num,'@'))) and 
                   count(child::*[@Code = 'ATTRIBUTE']) = 0">
           <!-- <a target="_blank"> -->
           <a>
         <xsl:choose>
              <xsl:when test="$vGetCourseInfoFromServer='Y'">
               <xsl:choose>
                 <xsl:when test="@Num_end">  <!-- if range exists send both pieces -->
                  <xsl:attribute name="href">javascript:GetCourseInfo('<xsl:value-of select="@Disc"/>','<xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>');</xsl:attribute>
                 </xsl:when>
                 <xsl:otherwise>
                  <xsl:attribute name="href">javascript:GetCourseInfo('<xsl:value-of select="@Disc"/>','<xsl:value-of select="@Num"/>');</xsl:attribute>
                 </xsl:otherwise>
                </xsl:choose>
           </xsl:when>
           
            </xsl:choose>
            <xsl:if test="@Title and $vShowTitleCreditsInHint='Y'">
              <xsl:attribute name="title">
               <xsl:value-of select="normalize-space(@Title)"/> - <xsl:value-of select="@Credits"/>&#160;<xsl:call-template name="tCreditsLiteral"/>
              </xsl:attribute> <!-- hint = title - 1.19 -->
            </xsl:if>
          <!-- Display the discipline only if the discipline isn't repeated --> 
          <xsl:if test="@NewDiscipline='Yes'">
               <b><xsl:value-of select="@Disc"/></b>
          <xsl:text>&#160;</xsl:text> <!-- space betweem disc and num --> 
          </xsl:if>
          <xsl:choose>
           <xsl:when test="@Num_end">  
            <xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>
           </xsl:when>
           <xsl:otherwise>
            <xsl:value-of select="@Num"/>
           </xsl:otherwise>
          </xsl:choose>
         </a>
   </xsl:when>

   <xsl:otherwise> <!-- ShowAdviceLink=N -->
     <span>                              
      <xsl:if test="@Title and $vShowTitleCreditsInHint='Y'"> <!-- 1.19 -->
        <xsl:attribute name="title">
         <xsl:value-of select="normalize-space(@Title)"/> - <xsl:value-of select="@Credits"/>&#160;<xsl:call-template name="tCreditsLiteral"/>
        </xsl:attribute> <!-- hint = title - 1.19 -->
      </xsl:if>
     <!-- Display the discipline only if the discipline isn't repeated --> 
     <xsl:if test="@NewDiscipline='Yes'">
       <b><xsl:value-of select="@Disc"/></b>
     <xsl:text>&#160;</xsl:text> <!-- space betweem disc and num --> 
     </xsl:if>
     <xsl:choose>
      <xsl:when test="@Num_end">  
       <xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="@Num"/>
      </xsl:otherwise>
     </xsl:choose>
     </span>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="@PrereqExists='Y' and /Report/@rptPrereqIndicator='Y'">*<!-- asterisk --></xsl:if>
  <xsl:if test="@With_advice">
   <xsl:choose>

   <xsl:when test="With[@Code='ATTRIBUTE'] and /Report/@rptShowAdviceLink='Y' and $vGetCourseInfoFromServer='Y'">
       &#160;
      <xsl:for-each select="With[@Code='ATTRIBUTE']">
      <xsl:for-each select="Value">
         <a>
            <xsl:choose>
               <xsl:when test="../../@Num_end">  <!-- if range exists send both pieces -->
               <xsl:attribute name="href">javascript:GetCourseInfo('<xsl:value-of select="../../@Disc"/>','<xsl:value-of select="../../@Num"/>:<xsl:value-of select="../../@Num_end"/>', '<xsl:value-of select="." />', '<xsl:value-of select="../@Operator"/>');</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
               <xsl:attribute name="href">javascript:GetCourseInfo('<xsl:value-of select="../../@Disc"/>','<xsl:value-of select="../../@Num"/>', '<xsl:value-of select="." />', '<xsl:value-of select="../@Operator"/>');</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$vShowTitleCreditsInHint='Y'">
               <xsl:attribute name="title">Click to see <xsl:value-of select="../../@Disc"/>&#160;<xsl:value-of select="../../@Num"/><xsl:if test="../../@Num_end">:<xsl:value-of select="../../@Num_end"/></xsl:if> with<xsl:if test="../@Operator = '&lt;&gt;' ">out</xsl:if> an Attribute of <xsl:value-of select="."/></xsl:attribute>
            </xsl:if>
            <xsl:choose>
            <xsl:when test="../@Operator = '='">with Attribute </xsl:when>
            <xsl:when test="../@Operator = '&lt;&gt;'">without Attribute </xsl:when>
            <xsl:otherwise>Attribute <xsl:value-of select="../@Operator"/>&#160;</xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="."/>
         </a>
         <xsl:if test="position()!=last()">&#160;<xsl:value-of select="@Connector" />&#160;</xsl:if>
      </xsl:for-each>
      </xsl:for-each>
   </xsl:when>
   <xsl:otherwise>
      <xsl:text>&#160;</xsl:text> <!-- space --> 
      <xsl:value-of select="@With_advice"/> 
   </xsl:otherwise>
   </xsl:choose>
  </xsl:if>

</xsl:template>

<!-- tCourseReq - used for displaying courses in requirement text -->
<xsl:template name="tCourseReq">
   <!-- Display the discipline only if the discipline isn't repeated --> 
   <xsl:if test="@NewDiscipline='Yes'">
    <xsl:value-of select="@Disc"/>
  <xsl:text>&#160;</xsl:text> <!-- space betweem disc and num --> 
  </xsl:if>     
  <xsl:choose>
   <xsl:when test="@Num_end">
    <xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="@Num"/>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="@HideFromAdvice"> 
    (HideFromAdvice)
  </xsl:if>
  <xsl:if test="With"> 
   <xsl:apply-templates select="With"/>
  </xsl:if>
</xsl:template>

<xsl:template match="With">
(WITH <xsl:value-of select="@Code"/> 
      <xsl:value-of select="@Operator"/> 
      <xsl:for-each select="Value">  <!-- FOR EACH WITH VALUE -->
       <xsl:value-of select="."/>, 
      </xsl:for-each> <!-- WITH/VALUE -->
)
</xsl:template>

<xsl:template name="tCondition">
  (
  <xsl:for-each select="LeftCondition"> 
   <xsl:call-template name="tCondition"/>
  </xsl:for-each>

  <xsl:value-of select="@Connector"/>

  <xsl:for-each select="RightCondition"> 
   <xsl:call-template name="tCondition"/>
  </xsl:for-each>

  <xsl:for-each select="Rop"> 
   <xsl:call-template name="tRop"/>
  </xsl:for-each>
  )
</xsl:template>

<xsl:template name="tRop">
  <xsl:value-of select="@Left"/> 
  <xsl:value-of select="@Operator"/> 
  <xsl:value-of select="@Right"/>
</xsl:template>

<!-- Place the @Credits in parens if the class is in-progress -->
<xsl:template name="CheckInProgress">	
  <xsl:variable name="InProgress" select="key('ClsKey',@Id_num)/@In_progress" />
  <xsl:if test="$InProgress='Y'">		<!-- in-progress -->
    (<xsl:value-of select="@Credits"/>)
  </xsl:if>
  <xsl:if test="$InProgress='N'">       <!-- not in-progress -->
    <xsl:value-of select="@Credits"/>
  </xsl:if>
</xsl:template>

<!-- Check to see if credits or classes are required on this block and show the value -->
<xsl:template name="CheckCreditsClasses-Required">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Header/Qualifier[@Node_type='4121']">
   <xsl:if test="not(@Pseudo)">
	 <xsl:choose>
     <xsl:when test="@Credits">	   
      <td class="BlockHeadSubTitle" align="right">
        <xsl:call-template name="tCreditsLiteral"/>
		Required:
      </td>
      <td class="BlockHeadSubData" align="left">
       &#160; <!-- space -->
       <xsl:value-of select="@Credits"/>
      </td>
     </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - must be classes -->
      <td class="BlockHeadSubTitle" align="right">
			<xsl:choose>
			<xsl:when test="@Credits &gt; 1">
				Classes
			</xsl:when>
			<xsl:otherwise>
				Class
			</xsl:otherwise>
			</xsl:choose>
		Required:
      </td>
      <td class="BlockHeadSubData" align="left">
       &#160; <!-- space -->
       <xsl:value-of select="@Classes"/>
      </td>
     </xsl:otherwise>
	 </xsl:choose>
   </xsl:if>
   </xsl:for-each>
</xsl:template>

<!-- Check to see if credits or classes are required and show the corresponding value applied -->
<xsl:template name="CheckCreditsClasses-Applied">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Header/Qualifier[@Node_type='4121']">
   <xsl:if test="not(@Pseudo)">
	 <xsl:choose>
     <xsl:when test="@Credits">	   
      <td class="BlockHeadSubTitle" align="right">
       <xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied:
      </td>
      <td class="BlockHeadSubData" align="left">
       &#160; <!-- space -->
       <xsl:value-of select="../../@Credits_applied"/>       <!-- get the value from the Block node -->
      </td>
     </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - must be classes -->
      <td class="BlockHeadSubTitle" align="right">
       Classes Applied:
      </td>
      <td class="BlockHeadSubData" align="left">
       &#160; <!-- space -->
       <xsl:value-of select="../../@Classes_applied"/>		 <!-- get the value from the Block node -->
      </td>
     </xsl:otherwise>
	 </xsl:choose>
   </xsl:if>
   </xsl:for-each>
</xsl:template>

<xsl:template name="tDisclaimer"> 
<br/>
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
		<tr>
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					&#160;Disclaimer
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr >
			<td class="DisclaimerText">
	<xsl:for-each select="$DisclaimerDocument/*"> 
        <xsl:value-of select="."/> 
    </xsl:for-each> 
			</td>
		</tr>

	</table>
</xsl:template> 


<xsl:template name="tSchoolHeader"> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- School Name: Using Text -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<table border="0" cellspacing="0" cellpadding="0" width="100%" class="SchoolName">												  
	<tr>
		<td align="left" valign="top">
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td align="center" valign="middle">
				<span class="SchoolName"><xsl:value-of select="/Report/@rptInstitutionName" />
				</span>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- FOR_CUSTOMIZING:SCHOOLNAME -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- School Name: To use an image, replace the <img src> tag below.
<table border="0" cellspacing="0" cellpadding="0" width="100%" class="SchoolName">												  
	<tr>
		<td align="left" valign="top">
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td align="center" valign="middle">
				<img src="Images_DG2/Icon_DegreeWorks.gif" ondragstart="window.event.returnValue=false;" />
				<br />
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table> -->
<!-- //////////////////////////////////////////////////////////////////////// -->
</xsl:template> 

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT HEADER -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:template name="tStudentHeader"> 

<xsl:for-each select="AuditHeader">
<table border="0" cellspacing="0" cellpadding="0" width="100%" class="AuditTable">

	<tr>
		<td class="AuditHeadBorderDark">
		</td>
	</tr>
	<tr>
		<td class="AuditHeadBorderLight">
		</td>
	</tr>

	<tr>                                                                          
		<td align="left" valign="top">                                               
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td align="left" valign="middle" class="StuHead">
				<span class="StuHeadTitle"> <xsl:value-of select="/Report/@rptReportName" /> </span>
				<span class="StuHeadCaption">&#160; &#160;<xsl:value-of select="@Audit_id" /> as of         
					<xsl:value-of select="@DateMonth" />/<xsl:value-of select="@DateDay"   />/<xsl:value-of select="@DateYear"  /> 
			        at <!-- Format the time as hh:mm --> <xsl:value-of select="@TimeHour" />:<xsl:value-of select="@TimeMinute" />
				</span>
				<br />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	
	<tr>
		<td class="AuditHeadBorderLight">
		</td>
	</tr>
	
	<tr>
		<td class="AuditHeadBorderDark">
		</td>
	</tr>
	
	<tr>
		<td>
		<table class="Inner" cellspacing="1" cellpadding="3" border="0" width="100%">

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle" >Student </td>
    <td class="StuTableData" ><xsl:value-of select="/Report/@rptStudentName" />  </td>
    <td class="StuTableTitle" >School </td>
    <td class="StuTableData" ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@SchoolLit" />  </td>
    <!--<td class="StuTableTitle" >School </td>
    <td class="StuTableData" ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@SchoolLit" />  </td>-->
  </tr>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle" >ID </td>
    <td class="StuTableData"  ><xsl:call-template name="tStudentID" /> </td>
    <td class="StuTableTitle" >College </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@CollegeLit" />&#160; <!-- space --> </td>
    <!--<td class="StuTableTitle" >College </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/MajorMinorData/@CollegeLit" /></td>-->
  </tr>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle"  >Advisor 1 </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/MajorMinorData/@Advisor_name" /> &#160; <!-- space -->  </td>
    <td class="StuTableTitle"  >Degree </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" /> &#160; <!-- space --> </td>
    <!--<td class="StuTableTitle"  >Degree </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" /></td>--> 
  </tr>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle" >Advisor 2</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/MajorMinorData">   
      <xsl:if test="position()=2">
	<xsl:value-of select="@Advisor_name" /> 
      </xsl:if>
    </xsl:for-each>
    </td>
    <td class="StuTableTitle" >Major </td>
    <td class="StuTableData"  >
      <xsl:value-of select="/Report/Audit/Deginfo/MajorMinorData/@MM_valueLit" /> &#160; <!-- space --> </td>
    <!--<td class="StuTableTitle"  >Degree </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" /> </td>-->
  </tr>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle" >Overall GPA </td>
    <xsl:choose>
      <xsl:when test="/Report/@rptShowStudentSystemGPA='Y'">
      <!-- If the SSGPA is empty then show the DWGPA value -->
        <xsl:choose>
	  <xsl:when test="normalize-space(@SSGPA)=''"> <!-- SSGPA is empty/blanks -->
	    <td class="StuTableData"  ><xsl:value-of select="@DWGPA" /></td>
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="StuTableData"  ><xsl:value-of select="@SSGPA" /></td>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> <!-- We always want to show the DWGPA -->
	<td class="StuTableData"  ><xsl:value-of select="@DWGPA" />  </td>
      </xsl:otherwise>
    </xsl:choose>
      <td class="StuTableTitle" >Level </td>
      <td class="StuTableData"  >
        <xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@Stu_levelLit" /> &#160; <!-- space --> 
      </td>
    <!--<td class="StuTableTitle"  >Degree </td>
    <td class="StuTableData"  ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" /> </td>-->
    </tr>
  </table>
	</td></tr>	
</table>
  </xsl:for-each> <!-- audit header -->
</xsl:template> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT HEADER END -->
<!-- //////////////////////////////////////////////////////////////////////// -->



<xsl:template name="tProgressBar"> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- PROGRESS BAR  -->
<!-- //////////////////////////////////////////////////////////////////////// -->
  <!-- -->
  <!-- /Report/Audit/AuditHeader/@Per_complete contains the percent complete -->
    <br />
    <center>
    <span class="ProgressTitle"> Degree Progress </span>
    <table cellpadding="0" cellspacing="0" class="ProgressTable">
       <tr>
          <td>
		  <xsl:attribute name="class">ProgressBar</xsl:attribute>
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete = 0">
			  <xsl:attribute name="width"> 5%
			  </xsl:attribute>
          </xsl:if>
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete = 100">
			  <xsl:attribute name="width"> 100%
			  </xsl:attribute>
	      </xsl:if>
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &gt; 0">
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &lt; 100">
              <xsl:attribute name="width">
				  <xsl:value-of select="/Report/Audit/AuditHeader/@Per_complete" />%
              </xsl:attribute>
          </xsl:if>
          </xsl:if>
			<center>
                   <xsl:value-of select='format-number(/Report/Audit/AuditHeader/@Per_complete, "#.0")' />%
			</center>
          </td>
		  <td>
       <xsl:if test="/Report/Audit/AuditHeader/@Per_complete = 100">
	   </xsl:if>
       <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &lt; 100">
              &#160;
	   </xsl:if>
          </td>
     </tr>
    </table>
    </center>
    <br />

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- PROGRESS BAR END -->
<!-- //////////////////////////////////////////////////////////////////////// -->
</xsl:template> 


<xsl:template name="tBlockHeaderChoose"> 

<!--// here are the different attributes you can use to locate a block or
	// group of blocks:
	//   @Req_id				@Title				@Cat_yr
	//	 @Req_type				@Per_complete		@Cat_yrLit
	//   @Req_value				@Cat_yr_start		
	//   @BS					@Cat_yr_stop		@GPA
	//   @Degree				@Major				@Gpa_credits
	//	 @Classes_applied		@Credits_applied	@Gpa_grade_pts
-->
	<xsl:choose>
		<xsl:when test="@Req_type = 'OTHER'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'GENED'">  
					<!-- OTHER GENED blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- OTHER blocks -->
					<xsl:call-template name="tBlockHeader_1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="@Req_type = 'DEGREE'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'BS'">  
					<!-- DEGREE BS blocks -->
					<xsl:call-template name="tBlockHeader_16"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- DEGREE blocks -->
					<xsl:call-template name="tBlockHeader_3"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="@Req_type = 'DEGREE'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'CS'">  
					<!-- MAJOR CS blocks -->
					<xsl:call-template name="tBlockHeader_4"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- MAJOR blocks -->
					<xsl:call-template name="tBlockHeader_5"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>




		<xsl:otherwise>
			<xsl:call-template name="tBlockHeader"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> 

<xsl:template name="tBlockHeader"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
						<!-- Check to see if credits or classes are required on this block and show the value -->
						<!-- This inserts a new <td></td> entry -->
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle" align="right">
							GPA:
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<!-- Check to see if credits or classes are required and show the corresponding value applied -->
						<!-- This inserts a new <td></td> entry -->
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #1 
     Requirement Title ONLY: block header height = constant -->
<xsl:template name="tBlockHeader_1"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				<td align="right">
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<td class="BlockHeadSubTitle"  align="right">
							&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
						</td>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle" align="right">
							&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
						</td>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #2 
     Requirement Title ONLY: block header height = shorter -->
<xsl:template name="tBlockHeader_2"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
						</td>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle" align="right">
						</td>
						<td class="BlockHeadSubData">
						</td>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #3 
     Requirement Title 
	 Catalog Year -->
<xsl:template name="tBlockHeader_3"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #4 
     Requirement Title 
	 GPA					-->
<xsl:template name="tBlockHeader_4"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #5 
     Requirement Title 
	 Credits/Classes Required			-->
<xsl:template name="tBlockHeader_5"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #6 
     Requirement Title 
	 Credits/Classes Applied			-->
<xsl:template name="tBlockHeader_6"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #7 
     Requirement Title 
	 Credits/Classes Required
	 Credits/Classes Applied			-->
<xsl:template name="tBlockHeader_7"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="70%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<xsl:call-template name="CheckCreditsClasses-Required"/>
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 


<!-- Block Header: alt #8
     Requirement Title 
	 Catalog Year
	 GPA							-->
<xsl:template name="tBlockHeader_8"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #9 
     Requirement Title 
	 Catalog Year
	 Credits/Classes Required				-->
<xsl:template name="tBlockHeader_9"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #10 
     Requirement Title 
	 Catalog Year
	 Credits/Classes Applied				-->
<xsl:template name="tBlockHeader_10"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #11 
     Requirement Title 
	 GPA
	 Credits/Classes Required				-->
<xsl:template name="tBlockHeader_11"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #12 
     Requirement Title 
	 GPA
	 Credits/Classes Applied				-->
<xsl:template name="tBlockHeader_12"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #13 
     Requirement Title 
	 Catalog Year
	 Credits/Classes Required
	 Credits/Classes Applied			-->
<xsl:template name="tBlockHeader_13"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="70%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
						<!-- Check to see if credits or classes are required on this block and show the value -->
						<!-- This inserts a new <td></td> entry -->
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle" align="right">
							&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
						</td>
						<!-- Check to see if credits or classes are required and show the corresponding value applied -->
						<!-- This inserts a new <td></td> entry -->
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #14
     Requirement Title 
	 GPA
	 Credits/Classes Required
	 Credits/Classes Applied			-->
<xsl:template name="tBlockHeader_14"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<!-- Check to see if credits or classes are required on this block and show the value -->
						<!-- This inserts a new <td></td> entry -->
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle" align="right">
							&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
						</td>
						<!-- Check to see if credits or classes are required and show the corresponding value applied -->
						<!-- This inserts a new <td></td> entry -->
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 



<!-- Block Header: alt #15 
     Requirement Title 
	 Catalog Year
	 GPA
	 Credits/Classes Applied				-->
<xsl:template name="tBlockHeader_15"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<td class="BlockHeadSubTitle"  align="right">
								&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
								&#160; <!-- space -->
						</td>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 

<!-- Block Header: alt #16 
     Requirement Title 
	 Catalog Year
	 GPA
	 Credits/Classes Required				-->
<xsl:template name="tBlockHeader_16"> 
<!-- BLOCK HEADER BEGIN -->
	<tr class="TableHead">
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>

			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					<img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
					<!-- BLOCK HEADER CHECKBOX BEGIN -->
					<xsl:choose>
						<xsl:when test="@Per_complete = 100">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 99">  
							<img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:when test="@Per_complete = 98">  
							<img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- BLOCK HEADER CHECKBOX END -->
				 </td>

				 <!-- BLOCK TITLE -->
				 <td width="100%" align="left" class="BlockHeadTitle">
					 <xsl:value-of select="@Title"/> 
				 </td>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="right">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
					<!-- cat-yr -->
						<td class="BlockHeadSubTitle"  align="right">
							Catalog Year: 
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
					<tr>
						<td class="BlockHeadSubTitle"  align="right">
							GPA: 
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@GPA"/> 
						</td>
						<td class="BlockHeadSubTitle"  align="right">
								&#160; <!-- space -->
						</td>
						<td class="BlockHeadSubData">
								&#160; <!-- space -->
						</td>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>

       </td>
     </tr>
<!-- BLOCK HEADER END -->
</xsl:template> 


<xsl:template name="tHeaderQualifierAdvice"> 
	<tr>
		<td colspan="30">
		<table border="0" class="BlockAdviceTable">
			<xsl:for-each select="Header/Advice/Text">	<!-- FOR EACH HEADER QUALIFIER -->
			<tr>
	        <!-- Put message on the left side with the actual qualifier advice on the right -->
				<xsl:if test="position()=1">
				<td class="BlockAdviceTitle" width="40%" rowspan="100" >
					Unmet conditions for this set of requirements:
				</td>
				</xsl:if>  
				<td class="BlockAdviceData" >
				<xsl:value-of select="."/> <!-- get Text data -->
				</td>
			</tr>
			</xsl:for-each>	<!-- END FOR EACH HEADER QUALIFIER -->
	    </table>
		</td>
	</tr>
</xsl:template> 

<xsl:template name="tBlockRemarks"> 
   <tr class="BlockRequirements">
      <td colspan="30" class="BlockRemarksTable">
      <table border="0" >
         <xsl:if test="Header/Remark"> 
         <tr class="BlockRemarksData">
            <td class="BlockRemarksData">
               <xsl:choose>
                <xsl:when test="Header/Qualifier[@Name='HEADERTAG']/@Code='RemarkJump' ">
                <a target="_newRemarkWindow">
                 <xsl:attribute name="href">
                  <xsl:for-each select="Header/Qualifier[@Name='HEADERTAG' and @Code='RemarkJump']">   <!-- FOR EACH REMARK LINK -->
                     <xsl:value-of select="@Value"/></xsl:for-each>  <!-- get the url -->
                 </xsl:attribute>
                 <xsl:attribute name="title">
                  <xsl:for-each select="Header/Qualifier[@Name='HEADERTAG' and @Code='RemarkHint']">   <!-- FOR EACH REMARK HINT -->
                     <xsl:value-of select="@Value"/></xsl:for-each>  <!-- get the url -->
                 </xsl:attribute>
               <xsl:for-each select="Header/Remark/Text"> <!-- FOR EACH RULE REMARK TEXT -->
                 <xsl:value-of select="."/>&#160;</xsl:for-each>  <!-- FOR EACH REMARK TEXT -->
                    </a>
               </xsl:when>
               <xsl:otherwise>
                <xsl:for-each select="Header/Remark/Text">   <!-- FOR EACH HEADER REMARK TEXT -->
                  <xsl:value-of select="."/>&#160;</xsl:for-each> <!-- FOR EACH REMARK TEXT -->
               </xsl:otherwise>
               </xsl:choose>
            </td>
         </tr>
         </xsl:if>
         <xsl:if test="Header/Display/Text"> 
         <tr class="BlockRemarksData">
            <td class="BlockRemarksData">
               <xsl:for-each select="Header/Display/Text">  <!-- FOR EACH HEADER DISPLAY TEXT -->
                 <xsl:for-each select="Line"><xsl:value-of select="."/>&#160;</xsl:for-each>
                 <br/>
               </xsl:for-each>
            </td>
         </tr>       
         </xsl:if>
      </table>
      </td>
   </tr>
</xsl:template> 

<xsl:template name="tBlockQualifiers"> 
	<tr class="BlockRequirements">
		<td colspan="30" class="RequirementTextTable">
		<table border="0" >
			<xsl:for-each select="Header/Qualifier">	<!-- FOR EACH HEADER QUALIFIER -->
			<tr>
                <!-- Put "Block Qualifiers" on the left side with the actual qualifiers on the right -->
				<xsl:if test="position()=1">
				<td class="RequirementTextTitle" width="40%" align="right" rowspan="100">
					Block Qualifiers:
				</td>
				</xsl:if>  
				<td class="RequirementText">
					<xsl:value-of select="Text"/>
					<xsl:for-each select="SubText">	
					<xsl:value-of select="."/>
					</xsl:for-each>	<!-- for each subtext -->
				</td>
			</tr>
			</xsl:for-each>	<!-- FOR EACH HEADER QUALIFIER -->
		</table>
	    </td>
	</tr>
</xsl:template> 

<xsl:template name="tRules">
	<tr >
		<!-- CLASSES + ADVICE -->
		<td class="xxxxRuleLabelData" width="100%">
		<table border="0" cellspacing="1" cellpadding="1" width="100%">

		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<!-- RULE ADVICE -->
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<xsl:if test="/Report/@rptShowRuleAdvice='Y'">
		<!-- If at least one Advice node exists -->
		<xsl:if test="Advice"> 
			<!-- If an ancestor has proxy-advice then don't show advice for this rule -->
			<!-- xsl:if test="ancestor::Rule[1]/@ProxyAdvice!='Yes'" -->
			<xsl:choose>
			<xsl:when test="ancestor::Rule[1]/@ProxyAdvice = 'Yes'">
			<!-- do nothing -->
			</xsl:when> <!-- proxyadvice = Yes -->
			<xsl:otherwise>
			<tr >
				<td class="RuleAdviceTitle" style="white-space:nowrap" colspan="1">
				    <!-- Suppress the StillNeeded label if we are within a group 1.06-->
					<xsl:choose>
					<xsl:when test="ancestor::Rule">
						<xsl:choose>
							<xsl:when test="ancestor::Rule[*]/@RuleType = 'Group'">
											<!-- Do nothing -->
							<xsl:text>
                            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
							</xsl:text> <!-- space --> 
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="$LabelStillNeeded" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$LabelStillNeeded" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="RuleAdviceData" >
                   <xsl:if test="ancestor::Rule[*]/@RuleType = 'Group'">
					<xsl:call-template name="tIndentLevel"/>
			       </xsl:if>
					<!-- Add an opening paren if this is rule is within a group -->
					<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
					(
					</xsl:if>
				<!-- /////////////////////////////////////////////// -->
				<!-- RULE-TYPE -->
				<!-- /////////////////////////////////////////////// -->
				<xsl:choose>
					<!-- GROUP RULE -->
         <xsl:when test="@RuleType = 'Group'">
              <xsl:if test="Advice/@NumGroupsNeeded >= 1">
                <!-- If there is a least 2 rules that don't have HideRule - then show this "Choose" text -->
                <xsl:if test="count(Rule[*]) - count(Rule[*]/Requirement/Qualifier[@Name = 'HIDERULE' or @Node_type='HideRule']) > 1 or
                              count(Rule[*]) = 1"> 
                 Choose from <xsl:value-of select="Advice/@NumGroupsNeeded"/> of the following: 
                </xsl:if>
              </xsl:if>
           </xsl:when> 
					<!-- END GROUP RULE -->

					<!-- NONCOURSE -->
					<xsl:when test="@RuleType = 'Noncourse'">
						One NonCourse 
						<xsl:value-of select="Advice/Code"/>
						<xsl:if test="Advice/Operator"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:value-of select="Advice/Operator"/> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:value-of select="Advice/Value"/>
					   </xsl:if> 
					</xsl:when>
					<!-- END NONCOURSE -->

					<!-- BLOCK RULE -->
					<xsl:when test="@RuleType = 'Block'">
						<xsl:if test="Advice/BlockID='NOT_FOUND'"> 
							<xsl:value-of select="Requirement/Type"/> = <xsl:value-of select="Requirement/Value"/> 
							block was not found but is required
						</xsl:if>
						<xsl:if test="Advice/BlockID!='NOT_FOUND'"> 
							See <xsl:value-of select="key('BlockKey',Advice/BlockID)/@Title" /> section
						</xsl:if>
					</xsl:when> 
					<!-- END BLOCK RULE -->

					<!-- BLOCKTYPE RULE -->
					<xsl:when test="@RuleType = 'Blocktype'">
						<xsl:choose>
							<xsl:when test="Advice/Title"> 
								<xsl:for-each select="Advice/Title"> <!-- most likely only one -->
									See <xsl:value-of select="." /> section <br/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<b><xsl:value-of select="Advice/Type" /> block was not found but is required</b>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- END BLOCKTYPE RULE -->

					<!-- COURSE RULE -->
					<xsl:when test="@RuleType = 'Course'">
					<xsl:for-each select="Advice"> <!-- most likely only one -->
						<xsl:if test="@Credits"> 
							<b>
                              <xsl:variable name="vFormattedCredits">
							  <xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@Credits"/>
								<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
							  </xsl:call-template>
                              </xsl:variable>
                            <xsl:choose>
                            <xsl:when test="$vShowToInsteadOfColon='Y' ">
                                <!-- Replace the colon with " to " -->
                                <xsl:call-template name="globalReplace">
                                  <xsl:with-param name="outputString" select="$vFormattedCredits" />
                                  <xsl:with-param name="target"       select="':'"      />
                                  <xsl:with-param name="replacement"  select="' to '"   />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise> <!-- show the credits with the colon (if present) -->
							    <xsl:value-of select="$vFormattedCredits"/>
                            </xsl:otherwise>
                            </xsl:choose>
							</b>
                                <xsl:text>&#160;</xsl:text> <!-- space --> 
								<xsl:choose>
								<xsl:when test="@Credits = 1">
									<xsl:value-of select="/Report/@rptCreditSingular" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="/Report/@rptCreditsLiteral" />
								</xsl:otherwise>
								</xsl:choose>
						</xsl:if> 
						<xsl:if test="@Class_cred_op='AND'"> 
                          and
						</xsl:if> 
						<xsl:if test="@Class_cred_op='OR'"> 
                          or
						</xsl:if> 
						<xsl:if test="@Classes"> 
							<b> 
                            <xsl:choose>
                            <xsl:when test="$vShowToInsteadOfColon='Y' ">
                                <!-- Replace the colon with " to " -->
                                <xsl:call-template name="globalReplace">
                                  <xsl:with-param name="outputString" select="@Classes" />
                                  <xsl:with-param name="target"       select="':'"      />
                                  <xsl:with-param name="replacement"  select="' to '"   />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise> <!-- show the classes with the colon (if present) -->
							    <xsl:value-of select="@Classes"/>
                            </xsl:otherwise>
                            </xsl:choose>
							</b> 
								<xsl:choose>
								<xsl:when test="@Classes = 1">
								Class
								</xsl:when>
								<xsl:otherwise>
								Classes
								</xsl:otherwise>
								</xsl:choose>
						</xsl:if> 
                        in 

						<!-- "+" Connector -->
						<xsl:if test="@Connector=' + '"> 
							<xsl:for-each select="Course">	<!-- FOR EACH COURSE -->
							<xsl:call-template name="tCourseAdvice"/>
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
									<xsl:if test="position()!=last()">
										and <!-- and -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
									<xsl:if test="position()!=last()">
										+   <!-- plus -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</xsl:if> 
						<!-- END "+" Connector -->

						<!-- "," Connector -->
						<xsl:if test="@Connector=', '"> 
							<xsl:for-each select="Course">  <!-- FOR EACH COURSE -->
							<xsl:call-template name="tCourseAdvice"/>
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
									<xsl:if test="position()!=last()">
										or       <!-- or -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
									<xsl:if test="position()!=last()">
										,        <!-- comma -->
									</xsl:if>
								</xsl:if> <!-- OR-ANDS=Y -->
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</xsl:if> <!-- CONNECTOR = , -->
						<!-- END "," Connector -->

						<!-- INCLUDING LIST -->
						<xsl:if test="Including"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<u>Including</u>
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:for-each select="Including/Course">	<!-- FOR EACH INCLUDING COURSE -->
							<xsl:call-template name="tCourseAdvice"/>
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
									<xsl:if test="position()!=last()">
										and           <!-- and -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
									<xsl:if test="position()!=last()">
										+             <!-- plus -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
								<xsl:text>&#160;</xsl:text> <!-- space --> 
								<xsl:value-of select="With_advice"/> 
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</xsl:if>
						<!-- END INCLUDING LIST -->

						<!-- EXCEPT LIST -->
						<xsl:if test="Except/Course"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<u>Except</u>
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:for-each select="Except/Course">	<!-- FOR EACH EXCEPT COURSE -->
							<xsl:call-template name="tCourseAdvice"/>
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
									<xsl:if test="position()!=last()">
										or                <!-- or -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
								<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
									<xsl:if test="position()!=last()">
										,                 <!-- comma -->
									</xsl:if>  
								</xsl:if> <!-- OR-ANDS=Y -->
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</xsl:if>
						<!-- END EXCEPT LIST -->

					</xsl:for-each> <!-- select="Advice" -->
					</xsl:when> <!-- course rule -->
					<!-- END COURSE RULE -->

					<xsl:otherwise>
						<!-- do nothing -->
					</xsl:otherwise>
				</xsl:choose> <!-- ruletype -->
				<!-- /////////////////////////////////////////////// -->
				<!-- RULE-TYPE -->
				<!-- /////////////////////////////////////////////// -->
<!--BKH Left off here 1-->
				<!-- Add a closing paren if this is rule is within a group -->
				<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
					) 
					<xsl:choose> <!--  -->
						<xsl:when test="@LastRuleInGroup='Yes'"> 
							<!-- do nothing -->
						</xsl:when>
						<xsl:otherwise>
					      <xsl:choose> <!-- AND or OR -->
						    <xsl:when test="ancestor::Rule[1]/Requirement/@NumGroups = ancestor::Rule[1]/Requirement/@NumRules">
							  and  <!-- group and - all rules are needed -->
						    </xsl:when>
							<!-- count how many following rules have HideRule - and compare to the number of rules -->
                <xsl:when test="(count(following-sibling::Rule[*]) =
                                 count(following-sibling::Rule[*]/Requirement/Qualifier[@Name = 'HIDERULE'])) or
                                (count(following-sibling::Rule[*]) =
                                 count(following-sibling::Rule[*]/Requirement/Qualifier[@Node_type = 'HideRule']))"> 
							  <!-- hide or  - because all following-rules have HideRule -->
						    </xsl:when>
						    <xsl:otherwise>
							  or  <!-- group or -->
						    </xsl:otherwise>
					       </xsl:choose> <!-- AND or OR -->
						</xsl:otherwise>
					</xsl:choose> <!--  -->
				</xsl:if>
			</td>
		</tr>
		</xsl:otherwise>
		</xsl:choose> <!-- ruletype -->
	</xsl:if> 
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<!-- END RULE ADVICE -->
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->

	<!-- PROXY-ADVICE -->
	<xsl:if test="ProxyAdvice"> 
		<tr>
			<td colspan="1" class="RuleAdviceTitle" style="white-space:nowrap">
				<!-- Suppress the StillNeeded label if we are within a group -->
				<xsl:choose>
				<xsl:when test="ancestor::Rule">
					<xsl:choose>
						<xsl:when test="ancestor::Rule[*]/@RuleType = 'Group'">
										&#160;&#160;&#160;&#160;&#160;
										&#160;&#160;&#160;&#160;&#160;
										&#160;&#160;&#160;&#160;&#160;
										<xsl:call-template name="tIndentLevel"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$LabelStillNeeded" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$LabelStillNeeded" />
				</xsl:otherwise>
				</xsl:choose>
			</td>
			<td colspan="9" class="RuleAdviceData">
					<!-- Add an opening paren if this is rule is within a group -->
					<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
					(
					</xsl:if>
				<xsl:choose>
					<xsl:when test="RuleTag/@Name='AdviceJump'">
					<!-- insert an html link to the AdviceJump value-->
						<a target="_blank">  
  						    <xsl:attribute name="href"><xsl:for-each select="RuleTag[@Name='AdviceJump']"><xsl:value-of select="@Value" /></xsl:for-each></xsl:attribute>
							<xsl:for-each select="ProxyAdvice/Text">
								<xsl:value-of select="."/>
								<xsl:text>&#160;</xsl:text> <!-- space --> 
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</a>
					</xsl:when> 
					<xsl:otherwise>
						<xsl:for-each select="ProxyAdvice/Text">
							<xsl:value-of select="."/>
							<xsl:text>&#160;</xsl:text> <!-- space --> 
						</xsl:for-each> <!-- ADVICE/COURSE-->
					</xsl:otherwise>
				</xsl:choose>
				<!-- Add a closing paren if this is rule is within a group -->
				<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
					) 
					<xsl:choose> <!--  -->
						<xsl:when test="@LastRuleInGroup='Yes'"> 
							<!-- do nothing -->
						</xsl:when>
						<xsl:otherwise>
					      <xsl:choose> <!-- AND or OR -->
						    <xsl:when test="ancestor::Rule[1]/Requirement/@NumGroups = ancestor::Rule[1]/Requirement/@NumRules">
							  and  <!-- group and - all rules are needed -->
						    </xsl:when>
						    <xsl:otherwise>
							  or  <!-- group or -->
						    </xsl:otherwise>
					       </xsl:choose> <!-- AND or OR -->
						</xsl:otherwise>
					</xsl:choose> <!--  -->
				</xsl:if>
			</td>
		</tr> <!-- proxy advice -->
	</xsl:if> <!-- PROXY-ADVICE -->

	</xsl:if>  <!-- show rule advice = Y -->
	<!-- /////////////////////////////////////////////// -->
	<!-- /////////////////////////////////////////////// -->
	<!-- END RULE ADVICE -->
	<!-- /////////////////////////////////////////////// -->
	<!-- /////////////////////////////////////////////// -->

	</table> <!-- end -->
	</td> 
       <!-- -->
       <!-- end cell for rule classes and advice in cell to the right of the label -->
       <!-- -->
     </tr>  <!-- end row for rule label and classes and advice -->

	<!-- RULE REMARKS -->
	<xsl:if test="/Report/@rptShowRuleRemarks='Y'">
	<xsl:if test="Remark"> 
	<tr >
		<td class="RuleRemarksTable" colspan="2">
		<table border="0">
			<tr >
				<td class="RuleRemarksData">
                  <xsl:choose>
                  <xsl:when test="RuleTag/@Name = 'RemarkJump' ">
				    <a target="_newRemarkWindow">
					  <xsl:attribute name="href">
					   <xsl:for-each select="RuleTag[@Name='RemarkJump']">	<!-- FOR EACH REMARK LINK -->
					      <xsl:value-of select="@Value"/></xsl:for-each>	<!-- get the url -->
					  </xsl:attribute>
					  <xsl:attribute name="title">
					   <xsl:for-each select="RuleTag[@Name='RemarkHint']">	<!-- FOR EACH REMARK HINT -->
					      <xsl:value-of select="@Value"/></xsl:for-each>	<!-- get the url -->
					  </xsl:attribute>
					<xsl:for-each select="Remark/Text">	<!-- FOR EACH RULE REMARK TEXT -->
					  <xsl:value-of select="."/>&#160;</xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
					<xsl:for-each select="Remark/Text">	<!-- FOR EACH RULE REMARK TEXT -->
					  <xsl:value-of select="."/>&#160;</xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
                  </xsl:otherwise>
                  </xsl:choose>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	</xsl:if> <!-- test="Remark" --> 
	</xsl:if>  <!-- show rule remarks -->
	<!-- END RULE REMARKS -->

	<!-- SHOW RULE TEXT -->
	<xsl:if test="/Report/@rptShowRuleText='Y'">
	<!-- REQUIREMENT -->
	<xsl:if test="Requirement"> 
		<tr>
			<td colspan="1" align="right"  class="RequirementTextTitle">
				Requirement:
			</td>
			<td class="RequirementText" colspan="1">
				<xsl:text>&#160;</xsl:text> <!-- space --> 
				<!-- RULE-TYPE -->
				<xsl:choose>
					<xsl:when test="@RuleType = 'Group'">
						<xsl:if test="Requirement/@NumGroups = 1"> 
							<xsl:value-of select="Requirement/@NumGroups"/> 
							Group in 
						</xsl:if>
						<xsl:if test="Requirement/NumGroups > 1"> 
							<xsl:value-of select="Requirement/@NumGroups"/> 
							Groups in 
						</xsl:if>
					</xsl:when>

					<xsl:when test="@RuleType = 'Noncourse'">
						<xsl:value-of select="Requirement/NumNoncourses"/>
						NonCourse (
						<xsl:value-of select="Requirement/Code"/> 
						<xsl:value-of select="Requirement/Operator"/> 
						<xsl:value-of select="Requirement/Value"/> 
								   )
					</xsl:when>

					<xsl:when test="@RuleType = 'Blocktype'">
						1 Blocktype (<xsl:value-of select="Requirement/Type"/>)
					</xsl:when>

					<xsl:when test="@RuleType = 'Block'">
						1 Block (<xsl:value-of select="Requirement/Type"/> =
						<xsl:value-of select="Requirement/Value"/>)
					</xsl:when>

					<xsl:when test="@RuleType = 'IfStmt'">
						<xsl:for-each select="Requirement/LeftCondition"> 
							<xsl:call-template name="tCondition"/>
						</xsl:for-each>
					</xsl:when>

					<!-- WHEN RULETYPE = COURSE -->
					<xsl:when test="@RuleType = 'Course'">
					<!-- FOR EACH COURSE REQUIREMENT -->
					<xsl:for-each select="Requirement">	

						 <!-- CREDITS -->
						<xsl:if test="@Credits_begin">          
							<xsl:value-of select="@Credits_begin"/> 
								<xsl:if test="@Credits_end"> 
								:
								<xsl:value-of select="@Credits_end"/> 
								</xsl:if> 
								<xsl:value-of select="/Report/@rptCreditsLiteral" />
						</xsl:if> 
						<!-- Only show the AND/OR if both classes and credits were specified -->
						<xsl:if test="@Credits_begin"> 
							<xsl:if test="@Classes_begin"> 
								<xsl:value-of select="@Class_cred_op"/> <!-- AND/OR -->
								<xsl:text>&#160;</xsl:text> <!-- space --> 
							</xsl:if> 
						</xsl:if> 
						<xsl:if test="@Classes_begin">           <!-- CLASSES -->
							<xsl:value-of select="@Classes_begin"/> 
							<xsl:if test="@Classes_end"> 
								:
								<xsl:value-of select="@Classes_end"/> 
							</xsl:if> 
							Classes
						</xsl:if> 
						in

						<!-- PLUS=AND -->
						<xsl:if test="@Connector = '+'"> 
							<xsl:for-each select="Course">	<!-- FOR EACH COURSE -->
								<xsl:call-template name="tCourseReq"/>
								<xsl:if test="position()!=last()">
									+                      <!-- plus -->
								</xsl:if>  
							</xsl:for-each> <!-- REQUIREMENT/COURSE-->
						</xsl:if> <!-- CONNECTOR = + -->

						<!-- COMMA=OR -->            
						<xsl:if test="@Connector = ','"> 
							<xsl:for-each select="Course">  <!-- FOR EACH COURSE -->
							<xsl:call-template name="tCourseReq"/>
								<xsl:if test="position()!=last()">
									,                      <!-- comma -->
								</xsl:if>  
							</xsl:for-each> <!-- REQUIREMENT/COURSE -->
						</xsl:if> <!-- CONNECTOR = , -->

						<xsl:if test="Including"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<u>Including</u>
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:for-each select="Including/Course">	<!-- FOR EACH INCLUDING COURSE -->
								<xsl:call-template name="tCourseReq"/>
									<xsl:if test="position()!=last()">
										+			      <!-- plus -->
									</xsl:if>  
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</xsl:if> <!-- INCLUDING -->

						<xsl:if test="Except"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<u>Except</u>
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:for-each select="Except/Course">	<!-- FOR EACH EXCEPT COURSE -->
								<xsl:call-template name="tCourseReq"/>
									<xsl:if test="position()!=last()">
										,                     <!-- comma -->
									</xsl:if>  
							</xsl:for-each> <!-- EXCEPT/COURSE-->
						</xsl:if> <!-- EXCEPT -->

					</xsl:for-each> <!-- select="Requirement" -->
					<!-- END FOR EACH COURSE REQUIREMENT -->
					</xsl:when> <!-- course rule -->
					<!-- END WHEN RULETYPE = COURSE -->

					<xsl:otherwise>
					<!-- do nothing -->
					</xsl:otherwise>
				</xsl:choose> <!-- ruletype -->

			<xsl:if test="HideRule"> 
			<br/>HideRule
			</xsl:if> <!-- HideRule -->

			<xsl:for-each select="Requirement/Qualifier">	<!-- FOR EACH QUALIFIER -->
				<br/>
				<img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
				<xsl:value-of select="Text"/>
				<xsl:for-each select="SubText">   
					<xsl:value-of select="."/>
				</xsl:for-each>	<!-- FOR EACH subtext -->
			</xsl:for-each>	<!-- FOR EACH QUALIFIER -->

			</td>
		</tr> 
	</xsl:if> 
	<!-- END REQUIREMENT -->
	</xsl:if> <!-- show rule text -->
	<!-- END SHOW RULE TEXT -->

</xsl:template>


<xsl:template name="tSectionFallthrough">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="Fallthrough">
<xsl:if test="@Classes &gt; 0">
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
		<tr>
			<td colspan="20">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>

			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					&#160;Electives
				</td>
				<td align="right" width="30%">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<td class="SectionTableSubTitle" align="right">
							<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
						</td>
						<td class="SectionTableSubData" align="right">
							<xsl:value-of select="@Credits"/>
						</td>
						<td class="SectionTableSubTitle">
							Classes Applied: 
						</td>
						<td class="SectionTableSubData" align="right">
							<xsl:value-of select="@Classes"/>
						</td>
					</tr>  
				</table>
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>
		</td>
	</tr>

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<tr >
		<td class="ClassesAppliedClasses" >
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</td>
	</tr>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
    <xsl:for-each select="key('ClsKey',@Id_num)">
    <xsl:if test="@Rec_type != 'G'">
		<tr >
			<td class="ClassesAppliedClasses"  >
				<xsl:value-of select="@Discipline"/>
				<xsl:text>&#160;</xsl:text> <!-- space --> 
				<xsl:value-of select="@Number"/>    
			</td>
			<td width="50%" class="SectionCourseTitle">
				<!-- Title: -->
				<!-- Use the Id_num attribute on this node to lookup the Class info
				on the Clsinfo/Cass node and get the Title -->     
				<xsl:value-of select="key('ClsKey',@Id_num)/@Course_title"/>
			</td>
			<td class="SectionCourseGrade">
				<xsl:value-of select="@Letter_grade"/> 
				<xsl:text>&#160;</xsl:text> <!-- space --> 
			</td>
			<td class="SectionCourseCredits">
				<xsl:value-of select="@Credits"/>  
			</td>
			<td class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
				<xsl:value-of select="key('ClsKey',@Id_num)/@TermLit"/>
			</td>
		</tr>

		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">
		<tr >
			<td class="SectionTransferLine"  colspan="5">
				<b>
				Satisfied by: &#160;
				</b>
      <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_course"/>
      <!-- Show the transfer course title and transfer school name - if they exist -->                        
      <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@TransferTitle) != ''"> 
        <xsl:text> - </xsl:text> <!-- hyphen --> 
        <xsl:value-of select="key('ClsKey',@Id_num)/@TransferTitle"/>
      </xsl:if>
      <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@Transfer_school) != ''"> 
        <xsl:text> - </xsl:text> <!-- hyphen --> 
        <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_school"/>
      </xsl:if>
			</td>
		</tr>
		</xsl:if>
	  </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</table>
</xsl:if>
</xsl:for-each> <!-- select="Fallthrough" -->
</xsl:template>

<xsl:template name="tSectionInsufficient">
<xsl:for-each select="Insufficient">
<xsl:if test="@Classes &gt; 0">
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
		<tr>
			<td colspan="20">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
				<tr>	
					<td class="AuditHeadBorderDark" colspan="4">
					</td>
				</tr>
				<tr>
					<td class="AuditHeadBorderLight" colspan="4">
					</td>
				</tr>

				<tr >
					<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
						&#160;Insufficient
					</td>
					<td align="right" width="30%">
					<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
					<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">

						<tr>
							<td class="SectionTableSubTitle" align="right">
								<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
							</td>
							<td class="SectionTableSubData" align="right">
								<xsl:value-of select="@Credits"/>
							</td>
							<td class="SectionTableSubTitle">
								Classes Applied: 
							</td>
							<td class="SectionTableSubData" align="right">
								<xsl:value-of select="@Classes"/>
							</td>
						</tr>  

					</table>
					</td>
				</tr>
				<tr>
					<td class="AuditHeadBorderDark" colspan="4">
					</td>
				</tr>
				<tr>
					<td class="AuditHeadBorderLight" colspan="4">
					</td>
				</tr>
			</table>
			</td>
		</tr>

		<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
		<tr >
			<td class="ClassesAppliedClasses" >
				<xsl:for-each select="Class">
					<xsl:value-of select="@Discipline"/>
					<xsl:text>&#160;</xsl:text> <!-- space --> 
					<xsl:value-of select="@Number"/> 
					<xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
					<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
					<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
				</xsl:for-each>
			</td>
		</tr>
		</xsl:if> <!-- show-course-keys-only = Y -->

		<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
		<xsl:for-each select="Class">
		<tr >
			<td class="ClassesAppliedClasses"  >
				<xsl:value-of select="@Discipline"/>
				<xsl:text>&#160;</xsl:text> <!-- space --> 
				<xsl:value-of select="@Number"/>    
			</td>
			<td width="50%" class="SectionCourseTitle">
				<!-- Title: -->
				<!-- Use the Id_num attribute on this node to lookup the Class info
				on the Clsinfo/Cass node and get the Title -->     
				<xsl:value-of select="key('ClsKey',@Id_num)/@Course_title"/>
			</td>
			<td class="SectionCourseGrade">
				<xsl:value-of select="@Letter_grade"/> 
				<xsl:text>&#160;</xsl:text> <!-- space --> 
			</td>
			<td class="SectionCourseCredits">
				<xsl:value-of select="@Credits"/>   
			</td>
			<td class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
				<xsl:value-of select="key('ClsKey',@Id_num)/@TermLit"/>
			</td>
		</tr>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">
		<tr >
			<td class="SectionTransferLine"  colspan="5">
				<b>
				Satisfied by: &#160;
				</b>
        <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_course"/>
        <!-- Show the transfer course title and transfer school name - if they exist -->                        
        <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@TransferTitle) != ''"> 
          <xsl:text> - </xsl:text> <!-- hyphen --> 
          <xsl:value-of select="key('ClsKey',@Id_num)/@TransferTitle"/>
        </xsl:if>
        <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@Transfer_school) != ''"> 
          <xsl:text> - </xsl:text> <!-- hyphen --> 
          <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_school"/>
        </xsl:if>
			</td>
		</tr>
		</xsl:if>
		</xsl:for-each>
		</xsl:if> <!-- show-course-keys-only = N -->


	</table>
</xsl:if>
</xsl:for-each> <!-- select="Insufficient" -->
</xsl:template>


<xsl:template name="tSectionInprogress">
    <!-- If there is at least 1 fallthrough class listed -->
    <xsl:for-each select="In_progress">
    <xsl:if test="@Classes &gt; 0">
  <table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
    <tr>
	<td colspan="20">
	  <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr><td class="AuditHeadBorderDark" colspan="4">
			</td></tr>

			<tr><td class="AuditHeadBorderLight" colspan="4">
			</td></tr>

		<tr >
              <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
        &#160;In Progress</td>
		     <td align="right" width="30%">
             <!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
               <table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">

			
			<tr>
                  <td class="SectionTableSubTitle" align="right">
                    <xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
                  </td>
                  <td class="SectionTableSubData" align="right">
					<xsl:value-of select="@Credits"/>
				  </td>
                <td class="SectionTableSubTitle">
                  Classes Applied: 
                  </td>
                  <td class="SectionTableSubData" align="right">
					<xsl:value-of select="@Classes"/>
				  </td>
	        </tr>  
		  
		  
		  </table>
	     </td>
	   </tr>
			<tr><td class="AuditHeadBorderDark" colspan="4">
			</td></tr>
			<tr><td class="AuditHeadBorderLight" colspan="4">
			</td></tr>
       </table>
       </td>
      </tr>



      <xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
      <tr >
        <td class="ClassesAppliedClasses" >
          <xsl:for-each select="Class">
            <xsl:value-of select="@Discipline"/>
		    <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
            <xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
         </xsl:for-each>
        </td>
      </tr>
      </xsl:if> <!-- show-course-keys-only = Y -->

      <xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
      <xsl:for-each select="Class">
      <tr >
           <td class="ClassesAppliedClasses"  >
            <xsl:value-of select="@Discipline"/>
		    <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:value-of select="@Number"/>    
			</td>
			<td width="50%" class="SectionCourseTitle">
              <!-- Title: -->
              <!-- Use the Id_num attribute on this node to lookup the Class info
                   on the Clsinfo/Cass node and get the Title -->     
              <xsl:value-of select="key('ClsKey',@Id_num)/@Course_title"/>
        </td>
        <td class="SectionCourseGrade"><xsl:value-of select="@Letter_grade"/> 
		    <xsl:text>&#160;</xsl:text> <!-- space --> </td>
        <td class="SectionCourseCredits"><xsl:value-of select="@Credits"/>   </td>
        <td class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
              <xsl:value-of select="key('ClsKey',@Id_num)/@TermLit"/>
         </td>
      </tr>
	  <!-- If this is a transfer class show more information -->
	  <xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">
      <tr >
		<td class="SectionTransferLine"  colspan="5">
		<b>
		Satisfied by: &#160;
		</b>
      <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_course"/>
      <!-- Show the transfer course title and transfer school name - if they exist -->                        
      <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@TransferTitle) != ''"> 
        <xsl:text> - </xsl:text> <!-- hyphen --> 
        <xsl:value-of select="key('ClsKey',@Id_num)/@TransferTitle"/>
      </xsl:if>
      <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@Transfer_school) != ''"> 
        <xsl:text> - </xsl:text> <!-- hyphen --> 
        <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_school"/>
      </xsl:if>
	    </td>
	  </tr>
	  </xsl:if>
      </xsl:for-each>
      </xsl:if> <!-- show-course-keys-only = N -->


    </table>
    </xsl:if>
    </xsl:for-each> <!-- select="In_progress" -->
</xsl:template>


<xsl:template name="tSectionOTL">
<!-- If there is at least 1 OTL class listed -->
	<xsl:for-each select="OTL">
	<xsl:if test="@Classes &gt; 0">
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
		<tr>
			<td colspan="20">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>	
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					&#160;Not Counted
				</td>
				<td align="right" width="30%">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
						<td class="SectionTableSubTitle" align="right">
							<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
						</td>
						<td class="SectionTableSubData" align="right">
							<xsl:value-of select="@Credits"/>
						</td>
						<td class="SectionTableSubTitle">
							Classes Applied: 
						</td>
						<td class="SectionTableSubData" align="right">
							<xsl:value-of select="@Classes"/>
						</td>
					</tr>  
				</table>
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>
		</td>
	</tr>

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<tr >
		<td class="ClassesAppliedClasses" >
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</td>
	</tr>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
	<tr >
		<td class="ClassesAppliedClasses"  >
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/>    
		</td>
		<td width="50%" class="SectionCourseTitle">
			<!-- Title: -->
			<!-- Use the Id_num attribute on this node to lookup the Class info
			on the Clsinfo/Cass node and get the Title -->     
			<xsl:value-of select="key('ClsKey',@Id_num)/@Course_title"/>
		</td>
		<td class="SectionCourseGrade"><xsl:value-of select="@Letter_grade"/> 
			<xsl:text>&#160;</xsl:text> <!-- space --> 
		</td>
		<td class="SectionCourseCredits">
			<xsl:value-of select="@Credits"/>   
		</td>
		<td class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
		<xsl:value-of select="key('ClsKey',@Id_num)/@TermLit"/>
		</td>
	</tr>
	<!-- If this is a transfer class show more information -->
	<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">
	<tr >
		<td class="SectionTransferLine"  colspan="5">
			<b>
			Satisfied by: &#160;
			</b>
      <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_course"/>
      <!-- Show the transfer course title and transfer school name - if they exist -->                        
      <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@TransferTitle) != ''"> 
        <xsl:text> - </xsl:text> <!-- hyphen --> 
        <xsl:value-of select="key('ClsKey',@Id_num)/@TransferTitle"/>
      </xsl:if>
      <xsl:if test="normalize-space(key('ClsKey',@Id_num)/@Transfer_school) != ''"> 
        <xsl:text> - </xsl:text> <!-- hyphen --> 
        <xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_school"/>
      </xsl:if>
		</td>
	</tr>
	</xsl:if>
	</xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->

</table>
</xsl:if>
</xsl:for-each> <!-- select="OTL" -->
</xsl:template>



<xsl:template name="tSectionExceptions">
<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
	<tr>
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					&#160;Exceptions
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr >
	<td class="ExceptionHeader">Type       </td>  
	<td class="ExceptionHeader">Description</td>  
	<td class="ExceptionHeader">Date       </td>  
	<td class="ExceptionHeader">Who        </td>  
	<td class="ExceptionHeader">Block      </td>  
	<td class="ExceptionHeader">Enforced   </td>  
	</tr>

	<xsl:for-each select="ExceptionList/Exception">
	<tr>
		<td class="AuditExceptionData">
			<xsl:call-template name="tExceptionType"/>
		</td>  
		<td class="AuditExceptionData">
         <!-- Label and Details -->
         <!-- Show the Details as a hint on the label - but only for non-students -->
         <xsl:choose> 
         <xsl:when test="/Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id and 
                         normalize-space(@Details) != '' "> 
         <a> 
          <xsl:attribute name="title"><xsl:value-of select="@Details"/></xsl:attribute>
          <xsl:attribute name="href">#Exception-<xsl:value-of select="@Req_id"/>-<xsl:value-of select="@Node_id"/></xsl:attribute>          
          <xsl:value-of select="@Label"/>
         </a>  
         </xsl:when> 
         <xsl:otherwise> <!-- don't show the details -->
         <a> 
          <xsl:attribute name="href">#Exception-<xsl:value-of select="@Req_id"/>-<xsl:value-of select="@Node_id"/></xsl:attribute>          
          <xsl:value-of select="@Label"/>
         </a>
         </xsl:otherwise> 
         </xsl:choose>
		</td>
		<td class="AuditExceptionData"><!-- xsl:value-of select="@Date"/ -->
			<xsl:call-template name="FormatXptDate"/>
		</td>
		<td class="AuditExceptionData">
			<xsl:value-of select="@Who"/>
		</td>
		<!-- <td><xsl:value-of select="Id_num"/></td>      -->
		<td class="AuditExceptionData">
			<xsl:value-of select="@Req_id"/>
		</td>
		<!-- <td><xsl:value-of select="Node_type"/></td>  -->
		<!-- <td><xsl:value-of select="Node_id"/></td>    -->
		<td class="AuditExceptionData">
			<xsl:value-of select="@Enforced"/>
		</td>
		<!-- <td><xsl:value-of select="School"/></td>     -->
		<!-- <td><xsl:value-of select="Degree"/></td>     -->
		<!-- <td><xsl:value-of select="Status"/></td>     -->
		<!-- <td><xsl:value-of select="Text"/></td>       -->

		<!-- <td><xsl:value-of select="Note_num"/></td> -->
		<!-- <td><xsl:value-of select="User_last"/></td> -->
	</tr>
	</xsl:for-each>
</table>
</xsl:template>



<xsl:template name="tSectionNotes">
	<br/>
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
		<tr>
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
					&#160;Notes
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderDark" colspan="4">
				</td>
			</tr>
			<tr>
				<td class="AuditHeadBorderLight" colspan="4">
				</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr>
			<td class="AuditNotesHeader"><b>Who </b></td>  
			<td class="AuditNotesHeader"><b>Date</b></td>  
			<td class="AuditNotesHeader"><b>Text</b></td>  
		</tr>

		<xsl:for-each select="Notes/Note[@Note_type != 'PL']">
		<tr>
			<td class="AuditNotesData" width="15%">
				<xsl:value-of select="@Note_who"/>
			</td>  
			<td class="AuditNotesData"  width="10%"><!-- xsl:value-of select="@Note_date"/ -->
				<xsl:call-template name="FormatNoteDate"/>
			</td>
			<td class="AuditNotesData"  width="75%">
			<xsl:for-each select="./Text"><xsl:value-of select="."/></xsl:for-each>
			</td>
		</tr>
		</xsl:for-each>
	</table>

</xsl:template>

<xsl:template name="tCreditsLiteral">  <!-- 1.07 -->
<xsl:choose>
 <xsl:when test="@Credits = 1">
  <xsl:value-of select="normalize-space(/Report/@rptCreditSingular)" />
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="normalize-space(/Report/@rptCreditsLiteral)" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tExceptionType">
           <xsl:choose>
            <xsl:when test="@Type = 'AH'">  
		      Apply Here
            </xsl:when>
            <xsl:when test="@Type = 'AA'">  
		      Also Allow
            </xsl:when>
            <xsl:when test="@Type = 'FC'">  
		      Force Complete
            </xsl:when>
            <xsl:when test="@Type = 'RR'">  
		      Substitution
            </xsl:when>
            <xsl:when test="@Type = 'NN'">  
		      Remove Course / Change the Limit
            </xsl:when>
            <xsl:otherwise>
		     Unknown
            </xsl:otherwise>
          </xsl:choose>
</xsl:template>

<xsl:template name="tIndentLevel">
 <!-- INDENT: invis1 has width=0 so nothing is indented really -->
  <xsl:choose>
    <xsl:when test="@IndentLevel = 1">  
    <img src="Images_DG2/dwinvis1.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 2">  
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 3">  
    <img src="Images_DG2/dwinvis3.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 4">  
    <img src="Images_DG2/dwinvis4.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 5">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 6">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 7">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 8">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 9">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 10">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 11">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 12">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 13">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 14">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 15">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>

    <xsl:otherwise>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tIndentLevel-Advice">
 <!-- INDENT: invis1 has width=0 so nothing is indented really -->
  <xsl:choose>
    <xsl:when test="@IndentLevel = 1">  
    <td width="0" ></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 2">  
    <td width="5"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 3">  
    <td width="10"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 4">  
    <td width="15"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 5">  
    <td width="20"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 6">  
    <td width="25"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 7">  
    <td width="30"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 8">  
    <td width="35"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 9">  
    <td width="40"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 10">  
    <td width="45"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 11">  
    <td width="50"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 12">  
    <td width="55"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 13">  
    <td width="60"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 14">  
    <td width="65"></td>
    </xsl:when>
    <xsl:when test="@IndentLevel = 15">  
    <td width="70"></td>
    </xsl:when>

    <xsl:otherwise>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tStudentID">	
<xsl:variable name="stu_id"           select="normalize-space(@Stu_id)"/>
<xsl:variable name="stu_id_length"    select="string-length(normalize-space(@Stu_id))"/>
<xsl:variable name="fill_asterisks"   select="$stu_id_length"/>
<xsl:variable name="bytes_to_remove"  select="/Report/@rptCFG020MaskStudentID"/>

<xsl:variable name="bytes_to_show"    select="$stu_id_length - $bytes_to_remove"/>
<xsl:variable name="myAsterisks">
<xsl:call-template name="tAsterisks" >
	<xsl:with-param name="bytes_to_remove" select="$bytes_to_remove" />
</xsl:call-template>
</xsl:variable>

<xsl:variable name="formatted_stu_id" />
<xsl:choose>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'A'">  
		<xsl:call-template name="tFillAsterisks" >
			<xsl:with-param name="string_length" select="$fill_asterisks" />
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'N'">  
		<xsl:value-of select="@Stu_id"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="concat($myAsterisks, substring($stu_id, $bytes_to_remove + 1, $bytes_to_show))" />
	</xsl:otherwise>
</xsl:choose>

</xsl:template>

<!-- tLegend template is in this included xsl; shared by athletic and academic audits -->
<xsl:include href="AuditLegend.xsl" />

<!-- FormatDate template is in this included xsl -->
<xsl:include href="FormatDate.xsl" />

<!-- Templates for general functionality -->
<xsl:include href="CommonTemplates.xsl" />

<xsl:template match="FreezeTypes">
<!-- do nothing; we need this so the codes in the UserClass nodes don't get displayed automatically -->
</xsl:template>

</xsl:stylesheet>
