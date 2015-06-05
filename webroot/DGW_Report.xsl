<!-- 
 Copyright 1995-2012 Ellucian Company L.P. and its affiliates. 
 $Id: //Tuxedo/RELEASE/Product/webroot/DGW_Report.xsl#19 $ -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 


<!-- Variables available for customizing -->
<!-- CMU Localization === Change text 
<xsl:variable name="LabelProgressBar">    Degree Progress </xsl:variable>
-->

<xsl:variable name="LabelProgressBar">    Estimated Degree Progress </xsl:variable>
<xsl:variable name="LabelStillNeeded">    Still Needed:  </xsl:variable>
<xsl:variable name="LabelAlertsReminders">  Alerts and Reminders </xsl:variable>

<!-- CMU Localization === Changed text
<xsl:variable name="LabelFallthrough">      Fallthrough Courses </xsl:variable>  -->
<xsl:variable name="LabelFallthrough">      Electives </xsl:variable>

<!-- CMU Localization === Changed text
<xsl:variable name="LabelInprogress">       In-progress </xsl:variable> -->
<xsl:variable name="LabelInprogress">       In-Progress (Current and Pre-Registered)</xsl:variable>

<!-- CMU Localization === Changed text
<xsl:variable name="LabelOTL">              Not Counted </xsl:variable> -->
<xsl:variable name="LabelOTL">              Not Usable Towards Degree </xsl:variable>

<!-- CMU Localization === Changed text
<xsl:variable name="LabelInsufficient">     Insufficient </xsl:variable> -->
<xsl:variable name="LabelInsufficient">     Insufficient (W/F/Repeated/or Excluded Courses) </xsl:variable> 

<!-- CMU Localization === Added variables to control display of Credits/Classes in Sections -->
<xsl:variable name="DisplayCreditClasses"> Y </xsl:variable> 
<xsl:variable name="DoNotDisplayCreditClasses"> N </xsl:variable> 

<xsl:variable name="LabelSplitCredits">     Split Credits </xsl:variable>
<xsl:variable name="LabelPlaceholders">     Planner Placeholders </xsl:variable>
<xsl:variable name="LabelIncludedBlocks">   Blocks included in this block</xsl:variable>
<xsl:variable name="vShowTitleCreditsInHint">Y</xsl:variable>
<xsl:variable name="vLabelSchool"     >Level</xsl:variable>
<xsl:variable name="vLabelDegree"     >Degree</xsl:variable>
<xsl:variable name="vLabelMajor"      >Major</xsl:variable>
<xsl:variable name="vLabelMinor"      >Minor</xsl:variable>
<xsl:variable name="vLabelCollege"    >College</xsl:variable>

<!-- CMU Localization === Changed variable text 
<xsl:variable name="vLabelLevel"      >Classification</xsl:variable> -->
<xsl:variable name="vLabelLevel"      >Class Standing</xsl:variable>

<xsl:variable name="vLabelAdvisor"    >Advisor</xsl:variable>

<!-- CMU Localization === Changed variable text 
<xsl:variable name="vLabelStudentID"  >ID</xsl:variable> -->
<xsl:variable name="vLabelStudentID"  >Student ID</xsl:variable>

<xsl:variable name="vLabelStudentName">Student</xsl:variable>

<!-- CMU Localization === Changed variable text
<xsl:variable name="vLabelOverallGPA" >Overall GPA</xsl:variable> -->
<xsl:variable name="vLabelOverallGPA" >Graduation GPA</xsl:variable> 

<xsl:variable name="vGetCourseInfoFromServer">Y</xsl:variable>

<!-- CMU Localization === Changed format from 3 decimal to 2 decimal
<xsl:variable name="vGPADecimals">0.000</xsl:variable>
<xsl:variable name="vCreditDecimals">0.###</xsl:variable>
-->
<xsl:variable name="vGPADecimals">0.00</xsl:variable>
<xsl:variable name="vCreditDecimals">0.##</xsl:variable>
<!-- CMU Localization === End of Changed format from 3 decimal to 2 decimal -->

<xsl:variable name="vProgressBarPercent">Y</xsl:variable>
<xsl:variable name="vProgressBarCredits">Y</xsl:variable>
<xsl:variable name="vProgressBarRulesText">Percentage of requirements completed</xsl:variable>
<xsl:variable name="vProgressBarCreditsText">Percentage of credits completed</xsl:variable>
<xsl:variable name="vShowPetitions">N</xsl:variable>
<xsl:variable name="vShowToInsteadOfColon">Y</xsl:variable> <!-- ":" is replaced with " to " in classes/credits range -->

<xsl:variable name="vShowCourseSignals">Y</xsl:variable>
<xsl:variable name="CourseSignalsHelpUrl">http://helpme.myschool.edu</xsl:variable>
<xsl:variable name="CourseSignalsRedLow"    >You are very much at risk of failing this class</xsl:variable>
<xsl:variable name="CourseSignalsRedHigh"   >You are at risk of failing this class</xsl:variable>
<xsl:variable name="CourseSignalsYellowLow" >You are doing okay but could do better</xsl:variable>
<xsl:variable name="CourseSignalsYellowHigh">You are doing okay but could do better</xsl:variable>
<xsl:variable name="CourseSignalsGreenLow"  >You are doing well - keep it up!</xsl:variable>
<xsl:variable name="CourseSignalsGreenHigh" >You are doing very well - keep it up!</xsl:variable>

<xsl:key name="XptKey"    match="Audit/ExceptionList/Exception" use="@Id_num"/>
<xsl:key name="ClsKey"    match="Audit/Clsinfo/Class" use="@Id_num"/>
<xsl:key name="NonKey"    match="Audit/Clsinfo/Noncourse" use="@Id_num"/>
<xsl:key name="BlockKey"  match="Audit/Block" use="@Req_id"/>
<xsl:key name="BlockKey2" match="Audit/Block" use="@Req_type"/>

<xsl:template match="Audit">
<html>
   <xsl:call-template name="tTitleForPrintedAudit"/>
   <link rel="stylesheet" href="DGW_Style.css" type="text/css" />
<script id="auditFormJs" language="JavaScript" type="text/javascript">
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
    if (pathToCgi.substring(0,2) == "--")
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

//////////////////////////////////////////////////////////////////////
// This is setup to link to LeepFrog's InstantRapport chat system.
// This can be modified to work with other systems however.
//////////////////////////////////////////////////////////////////////
function LinkToAdvisorChat(sAdvisorId)
{
var sWindowParams = "width=400,height=400,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
var sWindowName = "wAdvisorChat";
var wNew = window.open("", sWindowName, sWindowParams);
//wNew.resizeTo (iWidth, iHeight);
//wNew.moveTo   (iXPlace, iYPlace);

//alert ("LinkToAdvisorChat: " advisor-id=" + sAdvisorId);

sProfileInfo="xxxx";
// MAJORS
<xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='MAJOR']">
  sProfileInfo= sProfileInfo + "&amp;MAJOR" + "<xsl:value-of select="position()"/>" + "=" + "<xsl:value-of select="@ValueLit" />";
</xsl:for-each>

sProfileInfo= sProfileInfo + "&amp;MAJORLABEL=" + "<xsl:copy-of select="$vLabelMajor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='MAJOR'])>1">s</xsl:if>";
sProfileInfo= sProfileInfo + "&amp;CREDITSLABEL=" + "<xsl:copy-of select="normalize-space(/Report/@rptCreditsLiteral)"/>";

// ADVISORS
<xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='ADVISOR']">
  sProfileInfo= sProfileInfo + "&amp;ADVISOR<xsl:value-of select="position()"/>=<xsl:value-of select="@Advisor_name" />";
</xsl:for-each>
// LEVEL
sProfileInfo= sProfileInfo + "&amp;LEVEL=<xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@Stu_levelLit" />";
// DEGREE
sProfileInfo= sProfileInfo + "&amp;DEGREE=<xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" />";
sProfileInfo= sProfileInfo + "&amp;DEGREECODE=<xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@Degree" />";
// SCHOOL
sProfileInfo= sProfileInfo + "&amp;SCHOOLCODE=<xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@School" />";
// GPA
sProfileInfo= sProfileInfo + "&amp;GPA=<xsl:value-of select="/Report/Audit/AuditHeader/@SSGPA" />";
// CATALOG YEAR
sProfileInfo= sProfileInfo + "&amp;CATYR=<xsl:value-of select="/Report/Audit/Block/@Cat_yrLit" />";
// CLASSES APPLIED
sProfileInfo= sProfileInfo + "&amp;CLASSES=<xsl:value-of select="/Report/Audit/Block/@Classes_applied" />";
// CREDITS APPLIED
sProfileInfo= sProfileInfo + "&amp;CREDITS=<xsl:value-of select="/Report/Audit/Block/@Credits_applied" />";
// EMAIL ADDRESS
sProfileInfo= sProfileInfo + "&amp;EMAIL=<xsl:value-of select="/Report/Audit/AuditHeader/@Stu_email" />";

// The control frame has the form to submit
var frm = top.frControl.document.frmAdvisorChat; 
if (frm == "undefined") alert ("frmAdvisorChat was not found in control window");      
frm.target = sWindowName;
frm.ADVISORID.value   = sAdvisorId;
frm.PROFILEINFO.value = sProfileInfo; //+ '"'; // surround in quotes
frm.submit();
wNew.focus(); // needed in case window was already open
} // linktoadvisorchat

//////////////////////////////////////////////////////////////////////
// Update the audit with the status and description.
//////////////////////////////////////////////////////////////////////
function UpdateAudit()                                          
{
if (top.frControl == null) {alert ("frControl not defined - can't UpdateAudit"); return;}
//alert ("UpdateAudit enter");
var frmThis = document.frmAudit;
//  The control frame has the form to submit 
var frmSubmit = top.frControl.document.frmUpdateAudit;       
if (typeof(frmThis.selFreeze) != "undefined")
  frmSubmit.FREEZETYPE.value =  frmThis.selFreeze.options[frmThis.selFreeze.selectedIndex].value
if (typeof(frmThis.auditdescription) != "undefined")
  frmSubmit.AUDITDESC.value = '"' + frmThis.auditdescription.value + '"'; // put in dbl-quotes in case user entered a dbl-quote or ampersand
frmSubmit.AUDITID.value =  '<xsl:value-of select="/Report/Audit/AuditHeader/@Audit_id" />';
frmSubmit.STUID.value   =  '<xsl:value-of select="/Report/Audit/AuditHeader/@Stu_id" />';
frmSubmit.USERID.value  =  '<xsl:value-of select="/Report/@rptUsersId" />';
//alert ("UpdateAudit submit");
frmSubmit.target = "frHold"; // the hidden frame
frmSubmit.submit();
} // updateaudit

//////////////////////////////////////////////
function printForm()
{
   var prtContent = document.getElementById('frmAudit');
   ifrm=document.getElementById('printIframe');
   var oDoc = (ifrm.contentWindow || ifrm.contentDocument);
   if (oDoc.document) 
     oDoc = oDoc.document;
   
   oDoc.open();
   oDoc.write('&lt;link href="DGW_Style.css" rel="stylesheet" type="text/css""&gt;&lt;/link&gt;');
   oDoc.write('&lt;body onload="self.focus(); self.print();"&gt;');
   oDoc.write(prtContent.innerHTML + "&lt;/body&gt;");  
   oDoc.close();

}
</script>
<body style="margin: 5px;">
<!-- hidden iframe used to print contents -->
<iframe id="printIframe" style="height:0px;width:0px;border:0px;"></iframe>
<form name="frmAudit" ID="frmAudit" onSubmit="return false" target="">

<!-- Save changes to freeze status and description -->
<xsl:call-template name="tSaveChanges"/>

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

<!-- CMU Localization === Moved disclaimer to display at the top  -->
<xsl:if test="/Report/@rptShowDisclaimer='Y'">
   <xsl:call-template name="tDisclaimer"/>
</xsl:if> 
<!-- CMU Localization === End of Moved disclaimer to display at the top  -->

<!-- // Progress Bar // -->
<xsl:if test="/Report/@rptShowProgressBar='Y'">
<xsl:call-template name="tProgressBar"/>
<br />
</xsl:if>

<!-- // Student Alerts // -->
<xsl:if test="/Report/@rptShowStudentAlerts='Y'">
<xsl:call-template name="tStudentAlerts"/>
</xsl:if>

<xsl:if test="$vShowCourseSignals='Y'">
<xsl:call-template name="tCourseSignalsHelp" />
<br />
</xsl:if>

<!-- Output all the block/rule information -->
<xsl:call-template name="tBlocks" />

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Sections:  Fallthrough, Insufficient, Inprogress, OTL (Not Counted, aka Over-the-Limit) 
     (these are all tables that are not nested) -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<br/>

<!--//////////////////////////////////////////////////// 
   // Placeholder Section for planner audits    -->
   	<xsl:if test="/Report/Audit/Placeholders/Placeholder">
      <xsl:call-template name="tSectionPlaceholders"/>
   </xsl:if> 

<!--//////////////////////////////////////////////////// 
   // Fallthrough Section                    -->
   <xsl:if test="/Report/@rptShowFallThroughSection='Y'">
      <xsl:call-template name="tSectionTemplate">
      <xsl:with-param name="pSectionType" select="Fallthrough" />
      <xsl:with-param name="pSectionLabel" select="$LabelFallthrough" />
	  <!-- CMU Localization === Set flag to display Credits/Classes -->
	  <xsl:with-param name="pDisplayCreditClasses" select="$DisplayCreditClasses" />
      </xsl:call-template>
   </xsl:if> 

<!--//////////////////////////////////////////////////// 
   // Insufficient Section                   -->
   <xsl:if test="/Report/@rptShowInsufficientSection='Y'">
      <xsl:call-template name="tSectionTemplate">
      <xsl:with-param name="pSectionType" select="Insufficient" />
      <xsl:with-param name="pSectionLabel" select="$LabelInsufficient" />
	  <!-- CMU Localization === Set flag to NOT display Credits/Classes -->
	  <xsl:with-param name="pDisplayCreditClasses" select="$DoNotDisplayCreditClasses" />
      </xsl:call-template>
   </xsl:if> 

<!--//////////////////////////////////////////////////// 
   // Inprogress Section (aka In-Progress)         -->
    <xsl:if test="/Report/@rptShowInProgressSection='Y'">
      <xsl:call-template name="tSectionInprogress">
      </xsl:call-template>
   </xsl:if> 

<!--//////////////////////////////////////////////////// 
   // Not Counted Section (aka OTL, Over-the-limit) -->
    <xsl:if test="/Report/@rptShowOverTheLimitSection='Y'">
      <xsl:call-template name="tSectionTemplate">
      <xsl:with-param name="pSectionType" select="OTL" />
      <xsl:with-param name="pSectionLabel" select="$LabelOTL" />
	  <!-- CMU Localization === Set flag to display Credits/Classes -->
	  <xsl:with-param name="pDisplayCreditClasses" select="$DisplayCreditClasses" />
      </xsl:call-template>
    </xsl:if> 

<!--//////////////////////////////////////////////////// 
    // Split Credits Section                     1.15 -->
    <xsl:if test="/Report/@rptShowSplitCreditsSection='Y'">
      <xsl:call-template name="tSectionTemplate">
      <xsl:with-param name="pSectionType" select="SplitCredits" />
      <xsl:with-param name="pSectionLabel" select="$LabelSplitCredits" />
	  <!-- CMU Localization === Set flag to display Credits/Classes -->
	  <xsl:with-param name="pDisplayCreditClasses" select="$DisplayCreditClasses" />
      </xsl:call-template>
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

<!-- Refresh student context area with this data -->
<xsl:call-template name="tRefreshStudentData" />
<!-- Enable audit buttons in SD2AUDCON -->
<xsl:call-template name="tToggleButtons" />
</form>

</body>
</html>
</xsl:template> <!-- match=Audit -->

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

<xsl:template name="tToggleButtons">
<xsl:for-each select="/Report/ReloadButtons">
<script type="text/javascript" language="JavaScript">
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


<xsl:template name="tRefreshStudentData">
<xsl:for-each select="/Report/StudentData" >
<script  type="text/javascript" language="JavaScript">

function FindCode (sPicklistArray, sCodeToFind)
{
   var sReturnValue = sCodeToFind;

   for ( iSearchIndex = 0 ; iSearchIndex &lt; sPicklistArray.length ; iSearchIndex++ )
   {
      if (sPicklistArray[iSearchIndex].code == sCodeToFind)
      {
         sReturnValue = sPicklistArray[iSearchIndex].literal;
         break;
      }
   }
   return sReturnValue;
}

function Update_oViewClass (oStudentToUpdate, sMajors, sLevels, sDegrees)
{
   /*
      [0] = sort name
      [1] = name
      [3] = ID
      [4] = name
      [5] = degree short literal (list separated with space)
      [6] = major literal (list separated with space)
      [7] = school literal (list separated with space)
      [8] = level literal (list separated with space)
   */
      
   oStudentToUpdate[1] = "<xsl:value-of select='PrimaryMst/@Name' />";
   oStudentToUpdate[3] = "<xsl:value-of select='PrimaryMst/@Id' />";
   oStudentToUpdate[4] = "<xsl:value-of select='PrimaryMst/@Name' />";

      /*alert( "myPreviousDegree = " + oStudentToUpdate[5] + "\n" + 
            "myPreviousLevel  = " + oStudentToUpdate[8] + "\n" + 
            "myPreviousMajor  = " + oStudentToUpdate[6] + "\n");*/
   oStudentToUpdate[5] = '';
   oStudentToUpdate[6] = '';
   oStudentToUpdate[8] = '';

   <xsl:for-each select="GoalDtl">
      /* get the degree code, major code, school code, and level code. */     
      myDegree = FindCode (sDegrees, "<xsl:value-of select='@Degree' />");
      myLevel = FindCode (sLevels, "<xsl:value-of select='@StuLevel' />");
      thisDegree = "<xsl:value-of select='@Degree' />";
      myMajor = "";
      <xsl:for-each select="../GoalDataDtl[@GoalCode='MAJOR']">
         if (thisDegree == "<xsl:value-of select='@Degree' />" &amp;&amp; myMajor == "")
         {
            myMajor = FindCode (sMajors, "<xsl:value-of select='@GoalValue' />");
         }
      </xsl:for-each>
      oStudentToUpdate[5] += top.frControl.Trim(myDegree) + ' ';
      oStudentToUpdate[6] += top.frControl.Trim(myMajor)  + ' ';
      oStudentToUpdate[8] += top.frControl.Trim(myLevel)  + ' ';
      /*alert("Degree Info after:\n" + 
            "myPreviousDegree = " + oStudentToUpdate[5] + "\n" + 
            "myPreviousLevel  = " + oStudentToUpdate[8] + "\n" + 
            "myPreviousMajor  = " + oStudentToUpdate[6] + "\n");*/
   </xsl:for-each>
   /*
   oStudentToUpdate[5] = '';
   oStudentToUpdate[6] = '';
   oStudentToUpdate[7] = '';
   oStudentToUpdate[8] = '';
   */
   return oStudentToUpdate;

}
function Update_studentArray (aStudentToUpdate, sMajors, sLevels, sDegrees)
{
/*
   this.degree = Trim(degree);
   this.degreelit = Trim(degreelit);
   this.school = Trim(school);
   this.majorlit = Trim(majorlit);
   this.level = Trim(level);
   this.degreeinterest = Trim(degreeinterest);
*/
   aStudentToUpdate.name = "<xsl:value-of select='PrimaryMst/@Name' />";

   sRefreshDate = top.frControl.FormatRefreshDate("<xsl:value-of select='PrimaryMst/@BridgeDate' />");
   sRefreshTime = top.frControl.FormatRefreshTime("<xsl:value-of select='PrimaryMst/@BridgeTime' />");
   aStudentToUpdate.refreshdate = sRefreshDate + " at " + sRefreshTime;
   aStudentToUpdate.refreshdate.title = "";
   
   myAuditId = '<xsl:value-of select="/Report/Audit/AuditHeader/@Audit_id" />';
   if (myAuditId.substring(0,1) == "A") // if it is a real audit then update the auditdate otherwise do not.
   {
      aStudentToUpdate.auditdate = "Today";
   }
   
   aStudentToUpdate.degrees.length = 0;

   <xsl:for-each select="GoalDtl">
   myDegree = FindCode (sDegrees, "<xsl:value-of select='@Degree' />");
   myLevel  = FindCode (sLevels, "<xsl:value-of select='@StuLevel' />");
   thisDegree = "<xsl:value-of select='@Degree' />";
   myMajor = "";
   <xsl:for-each select="../GoalDataDtl[@GoalCode='MAJOR']">
      if (thisDegree == "<xsl:value-of select='@Degree' />" &amp;&amp; myMajor == "")
      {
         myMajor = FindCode (sMajors, "<xsl:value-of select='@GoalValue' />");
      }
   </xsl:for-each>
   aStudentToUpdate.degrees[aStudentToUpdate.degrees.length] = 
         new top.frControl.DegreeEntry("<xsl:value-of select='@Degree' />", 
                                myDegree, 
                                "<xsl:value-of select='@School' />", myMajor, myLevel, "");
   </xsl:for-each>
} // update_studentarray

<xsl:if test="PrimaryMst">
  //alert('"<xsl:value-of select="PrimaryMst/@Name" />" was successfully refreshed.');                                 
  var moz;
  moz = (typeof document.implementation != 'undefined') &amp;&amp; 
        (typeof document.implementation.createDocument != 'undefined');
/*
  if (moz)
    {
    thisForm   = top.frControl.document.getElementById("formCallScript");
    thisForm.elements['PRELOADEDPLAN'].value = "<xsl:value-of select="/Save/@PreloadedPlan" />"
    thisForm.elements['RELOADSEP'].value = "FALSE";
   }
  else // ie etc
    {
    top.frControl.frmCallScript.PRELOADEDPLAN.value = '<xsl:value-of select="/Save/@PreloadedPlan" />';
    top.frControl.frmCallScript.RELOADSEP.value = "FALSE";                      
    }
*/
   //alert("top.frControl.studentArray.length = " + top.frControl.studentArray.length);
  var sRefreshedStudentID   = '<xsl:value-of select="PrimaryMst/@Id" />';
  var sRefreshedStudentName = "<xsl:value-of select='PrimaryMst/@Name' />";

   //alert('Student just refreshed = ' + sRefreshedStudentID + '\n' + sRefreshedStudentName);

   //alert("top.frControl.sa.length = " + top.frControl.sa.length);

   var bOnlySimpleSearch = true;
   if (top.frControl.oViewClass != undefined)
   {
      bOnlySimpleSearch = false;
   }
   if (!bOnlySimpleSearch)
   {
      var oStudentList = top.frControl.oViewClass;
      var iStudentListLength = oStudentList.length;

      //alert("iStudentListLength = " + iStudentListLength);

      for ( iStudentArrayIndex = 0; iStudentArrayIndex &lt; iStudentListLength ; iStudentArrayIndex++ )
      {
         var bIsDefined = true;
         var i = 0;
         while (bIsDefined)
         {
            if (oStudentList[iStudentArrayIndex][i] != undefined)
            {
               if (oStudentList[iStudentArrayIndex][i] == sRefreshedStudentID)
               {
                  //alert("I found " + sRefreshedStudentID + " in my list!");
                  top.frControl.oViewClass[iStudentArrayIndex] = Update_oViewClass (
                                 top.frControl.oViewClass[iStudentArrayIndex],
                                 top.frControl.sMajorPicklist,
                                 top.frControl.sLevelPicklist,
                                 top.frControl.sDegreePicklist);
                  //bIsDefined = false;
               }
               //alert("oStudentList[" + iStudentArrayIndex + "][" + i + "] = " + oStudentList[iStudentArrayIndex][i]);
            }
            else
            {
               bIsDefined = false;
            }
            i++;
         }
      }
   }

   var aStudentArray = top.frControl.studentArray;
   var iStudentArrayLength = aStudentArray.length;
   var iCurrentDegreeIndex = top.frControl.oDegreeList.selectedIndex;

   //alert("iStudentArrayLength = " + iStudentArrayLength);
   for ( iStudentArrayIndex = 0; iStudentArrayIndex &lt; iStudentArrayLength ; iStudentArrayIndex++ )
   {
      if (aStudentArray[iStudentArrayIndex].id == sRefreshedStudentID)
      {
         //alert("I found " + sRefreshedStudentID + " in my second list!");
         Update_studentArray (top.frControl.studentArray[iStudentArrayIndex],
                     top.frControl.sMajorPicklist,
                     top.frControl.sLevelPicklist,
                     top.frControl.sDegreePicklist)
      }
      //alert("aStudentArray[" + iStudentArrayIndex + "].auditdate = " + aStudentArray[iStudentArrayIndex].auditdate);
   }
    // Set student context but do not reload body (reason for "false")
    // Keep the currently select degree as the one selected
    top.frControl.SetStudent(false, iCurrentDegreeIndex); 

</xsl:if>

</script>
</xsl:for-each > <!-- StudentData node -->

<script type="text/javascript" language="JavaScript">
<xsl:if test="not(/Report/StudentData/PrimaryMst)">
  if (typeof(top.frControl) != "undefined")
   {
   myAuditId = '<xsl:value-of select="/Report/Audit/AuditHeader/@Audit_id" />';
   // if it is a real audit then update the auditdate otherwise do not
   if (myAuditId.substring(0,1) == "A") 
    {
    sTodaysDate = top.frControl.GetCurrentDate(); // mm/dd/ccyy or whatever the format is
    sAuditDate = top.frControl.FormatDate ("<xsl:value-of select="concat(/Report/Audit/AuditHeader/@DateYear,/Report/Audit/AuditHeader/@DateMonth,/Report/Audit/AuditHeader/@DateDay)" />");
    //sAuditMonth = '<xsl:value-of select="/Report/Audit/AuditHeader/@DateMonth" />';
    //sAuditDay   = '<xsl:value-of select="/Report/Audit/AuditHeader/@DateDay"   />';
    //sAuditYear  = '<xsl:value-of select="/Report/Audit/AuditHeader/@DateYear"  />';
    //sAuditDate = sAuditMonth + '/' + sAuditDay + '/' + sAuditYear;
    // If this audit was run today then show its time; otherwise the date of the last
    // run audit should already be displaying and there is no reason to show this old date
    if (sAuditDate == sTodaysDate)
      {
      //sAuditHour  = '<xsl:value-of select="/Report/Audit/AuditHeader/@TimeHour"  />';
      //sAuditMin   = '<xsl:value-of select="/Report/Audit/AuditHeader/@TimeMinute"/>';
      //sDisplayDate = sAuditHour + ':' + sAuditMin;
      sDisplayDate = 'Today';
      // Update the display date at the top with this new date
      top.frControl.document.frmHoldFields.LastAudit.value = sDisplayDate;
      }
    }
   } // frcontrol != undefined
</xsl:if> <!-- not primarymst -->
</script>

</xsl:template>

<xsl:template name="tCreditsLiteral"> <!-- 1.19 -->
<xsl:choose>
 <xsl:when test="@Credits = 1">
  <xsl:value-of select="normalize-space(/Report/@rptCreditSingular)" />
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="normalize-space(/Report/@rptCreditsLiteral)" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tDisclaimer"> 
<br/>
   <table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
      <tr>
      <td colspan="20">
      <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;Disclaimer
            </td>
         </tr>
      </table>
      </td>
      </tr>
      <tr >
         <td class="DisclaimerText">
            <xsl:for-each select="document('AuditDisclaimer.xml')">
				<xsl:value-of select="."/>
			</xsl:for-each>
         </td>
      </tr>

   </table>
</xsl:template> 

<xsl:template name="tTitleForPrintedAudit">
<title>
   <xsl:choose>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='A'">
         Ellucian Degree Works 
      </xsl:when>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='B'">
         Degree Works <xsl:value-of select="/Report/@rptReportName" /> 
      </xsl:when>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='C'">
         <xsl:value-of select="/Report/@rptInstitutionName" />:
         <xsl:value-of select="/Report/@rptReportName" /> 
      </xsl:when>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='D'">
         <xsl:value-of select="/Report/@rptReportName" /> 
         for 
         <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" /> 
      </xsl:when>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='E'">
         <xsl:value-of select="/Report/@rptReportName" /> 
         for 
         <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" /> 
         -
         <xsl:call-template name="tStudentID" />
      </xsl:when>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='F'">
         <xsl:value-of select="/Report/@rptInstitutionName" />:
         <xsl:value-of select="/Report/@rptReportName" /> 
         for 
         <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" /> 
      </xsl:when>
      <xsl:when test="/Report/@rptCFG020AuditTitleStyle='G'">
         <xsl:value-of select="/Report/@rptInstitutionName" />:
         <xsl:value-of select="/Report/@rptReportName" /> 
         for 
         <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" /> 
         -
         <xsl:call-template name="tStudentID" />
      </xsl:when>
      <xsl:otherwise><!-- "E" is default -->
         <xsl:value-of select="/Report/@rptReportName" /> 
         for 
         <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" /> 
         -
         <xsl:call-template name="tStudentID" />
      </xsl:otherwise>
   </xsl:choose>
</title>
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
            <img src="Images_DG2/Icon_DegreeWorks.gif" />
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
<!-- STUDENT ALERTS -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:template name="tStudentAlerts"> 
<!-- If an ALERT1 Report node exists -->
<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT1'"> 
<br />
<table border="0" cellspacing="0" cellpadding="0" width="60%" align="center" class="AuditTable">

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
		<table border="0" cellspacing="1" cellpadding="2" width="100%">
			<tr>
				<td align="center" valign="middle" class="StuHead">
				<span class="StuHeadTitle"> 
					<xsl:copy-of select="$LabelAlertsReminders" />
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

			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT1'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT1']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT2'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT2']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT3'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT3']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT4'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT4']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT5'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT5']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT6'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT6']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT7'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT7']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT8'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT8']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT9'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT9']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT10'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif"  ondragstart="window.event.returnValue=false;"/>&#160;
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ALERT10']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</td>
			  </tr>
			</xsl:if>
	  </table>
	</td></tr>	
</table>
<br />
</xsl:if>
</xsl:template> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT ALERTS END -->
<!-- //////////////////////////////////////////////////////////////////////// -->

<xsl:template name="tProgressBar"> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- PROGRESS BAR  -->
<!-- //////////////////////////////////////////////////////////////////////// -->
  <!-- /Report/Audit/AuditHeader/@Per_complete contains the percent complete -->
    <br />
    <center>
    <span class="ProgressTitle"> 
      <xsl:copy-of select="$LabelProgressBar" />
    </span>
   <xsl:if test="$vProgressBarPercent='Y'">
    <table cellpadding="0" cellspacing="1" class="ProgressTable" >
    <xsl:attribute name="title"><xsl:value-of select="$vProgressBarRulesText" /></xsl:attribute>
       <tr>
         <td class="ProgressSubTitle">Requirements
        </td>
          <td>
		<!-- CMU Localization === Replaced logic so that 1% will display as 1% on bar-->
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
           <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &lt; 5">
           <xsl:attribute name="width"> 5%
           </xsl:attribute>
         </xsl:if>
         <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &lt; 100 and
                     /Report/Audit/AuditHeader/@Per_complete &gt;= 5">
              <xsl:attribute name="width">
              <xsl:value-of select="/Report/Audit/AuditHeader/@Per_complete" />%
              </xsl:attribute>
          </xsl:if>
          </xsl:if>
		  
       <!-- <xsl:attribute name="class">ProgressBar</xsl:attribute>
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete = 0">
           <xsl:attribute name="width"> 5%
           </xsl:attribute>
          </xsl:if>
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &gt; 99.99">
           <xsl:attribute name="width"> 100%
           </xsl:attribute>
         </xsl:if>
          <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &gt; 0">
           <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &lt; 5">
           <xsl:attribute name="width"> 5%
           </xsl:attribute>
         </xsl:if>
         <xsl:if test="/Report/Audit/AuditHeader/@Per_complete &lt; 100 and
                     /Report/Audit/AuditHeader/@Per_complete &gt;= 5">
              <xsl:attribute name="width">
              <xsl:copy-of select="/Report/Audit/AuditHeader/@Per_complete" />%
              </xsl:attribute>
          </xsl:if>
          </xsl:if>-->
		<!-- CMU Localization === Replaced logic so that 1% will display as 1% on bar -->
         <center>
                   <xsl:value-of select='format-number(/Report/Audit/AuditHeader/@Per_complete, "0")' />% <!-- was #.0 but Mike wants no decimals -->
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
    </xsl:if> <!-- vProgressBarPercent -->
    </center>

   <xsl:if test="$vProgressBarCredits='Y'">
    <xsl:choose>
     <xsl:when test="/Report/Audit/Block[1]/Header/Qualifier[@Node_type='4121']">

      <xsl:variable name="vOverallCreditsRequired">
       <xsl:call-template name="tCreditsRequired" />
      </xsl:variable>

      <xsl:variable name="vOverallCreditsApplied">
        <xsl:choose>
        <xsl:when test="/Report/Audit/Block[1]/Header/Qualifier/CREDITSAPPLIEDTOWARDSDEGREE">
         <xsl:value-of select="/Report/Audit/Block[1]/Header/Qualifier/CREDITSAPPLIEDTOWARDSDEGREE/@Credits" />
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="/Report/Audit/Block[1]/@Credits_applied" />
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="vOverallCreditsPercentComplete">
		<xsl:choose>
		<xsl:when test="100 * ($vOverallCreditsApplied div $vOverallCreditsRequired) &gt; 100">100</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="100 * ($vOverallCreditsApplied div $vOverallCreditsRequired)" />
		</xsl:otherwise>
		</xsl:choose>
      </xsl:variable>
      
      <br />
      <center>
      <table cellpadding="0" cellspacing="1" class="ProgressTable" >
       <xsl:attribute name="title"><xsl:value-of select="$vProgressBarCreditsText" />
         <xsl:if test="/Report/Audit/Block[1]/Header/Qualifier/CREDITSAPPLIEDTOWARDSDEGREE"> 
            (excluding excess electives)</xsl:if></xsl:attribute>
       <tr>
         <td class="ProgressSubTitle"><xsl:call-template name="tCreditsLiteral"/>
        </td>
          <td>
        <xsl:attribute name="class">ProgressBar</xsl:attribute>
		
		<!-- CMU Localization === Replaced logic so that 1% will display as 1% on bar
          <xsl:if test="$vOverallCreditsPercentComplete = 0">
           <xsl:attribute name="width"> 5%
           </xsl:attribute>
          </xsl:if>
          <xsl:if test="$vOverallCreditsPercentComplete &gt; 99.99">
           <xsl:attribute name="width"> 100%
           </xsl:attribute>
         </xsl:if>
          <xsl:if test="$vOverallCreditsPercentComplete &gt; 0">
          <xsl:if test="$vOverallCreditsPercentComplete &lt; 100">
              <xsl:attribute name="width">
              <xsl:copy-of select="$vOverallCreditsPercentComplete" />%
              </xsl:attribute>
          </xsl:if>
          </xsl:if>
		  -->
          <xsl:if test="$vOverallCreditsPercentComplete = 0">
           <xsl:attribute name="width"> 5%
           </xsl:attribute>
          </xsl:if>
          <xsl:if test="$vOverallCreditsPercentComplete &gt; 99.99">
           <xsl:attribute name="width"> 100%
           </xsl:attribute>
         </xsl:if>
          <xsl:if test="$vOverallCreditsPercentComplete &gt; 0">
           <xsl:if test="$vOverallCreditsPercentComplete &lt; 5">
           <xsl:attribute name="width"> 5%
           </xsl:attribute>
         </xsl:if>
         <xsl:if test="$vOverallCreditsPercentComplete &lt; 100 and
                     $vOverallCreditsPercentComplete &gt;= 5">
              <xsl:attribute name="width">
              <xsl:copy-of select="$vOverallCreditsPercentComplete" />%
              </xsl:attribute>
          </xsl:if>
          </xsl:if>
		  <!-- CMU Localization === End of Replaced logic so that 1% will display as 1% on bar -->
		  
         <center>
                   <xsl:copy-of select='format-number($vOverallCreditsPercentComplete, "0")' />% <!-- was #.0 but Mike wants no decimals -->
         </center>
          </td>
        <td>
       <xsl:if test="$vOverallCreditsPercentComplete = 100">
       </xsl:if>
       <xsl:if test="$vOverallCreditsPercentComplete &lt; 100">
              &#160;
      </xsl:if>
        </td>
     </tr>
    </table>
    </center>
   </xsl:when>
   <xsl:otherwise /> <!-- do nothing. No credits rule in the starter block so no data to use to calculate credits pct complete -->
   </xsl:choose>
   </xsl:if> <!-- vProgressBarCredits -->
      
    <!-- CMU Localization === Added Progress Bar disclaimer row ========================================================= -->
	<br />
	<center>
     <table cellpadding="0" cellspacing="1" width="80%" >    
     <tr>
	   <td class = "DisclaimerText">
			The percentages above are calculated from the number of check boxes completed not actual degree completion. 
			Completing 100% of the credits and/or requirements is not official notification of degree completion. You 
			must meet with your advisor to determine if all degree requirements have been met. Click on the Help link 
			in the top bar for more details.
	   </td>
     </tr>
     </table>
	 </center>
    <!-- CMU Localization === End of Added Progress Bar disclaimer row -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- PROGRESS BAR END -->
<!-- //////////////////////////////////////////////////////////////////////// -->
</xsl:template> 

<xsl:template name="tSectionPlaceholders">
   <table border="0" cellspacing="1" cellpadding="0" width="100%" class="xBlocks">
      <tr>
         <td colspan="20">
         <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;
               <xsl:copy-of select="$LabelPlaceholders" />
            </td>
         </tr>
      </table>
      </td>
   </tr>

   <xsl:for-each select="/Report/Audit/Placeholders/Placeholder">
   <tr>
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>

      <td class="SectionCourseTitle" >
        <xsl:value-of select="@Description"/> 
       </td>
      <td class="SectionCourseTitle" >
        <xsl:value-of select="@Value"/> 
       </td>
   </tr>
   </xsl:for-each>
   </table>
</xsl:template>

<xsl:template name="tSectionTemplate">
<xsl:param name="pSectionType" />
<xsl:param name="pSectionLabel" />
<!-- CMU Localization === Added parameter to flag whether to display Credits/Classes -->
<xsl:param name="pDisplayCreditClasses" />

<xsl:for-each select="$pSectionType">
<xsl:if test="@Classes &gt; 0 or count(Noncourse) &gt; 0 ">
   <table border="0" cellspacing="1" cellpadding="0" width="100%" class="xBlocks">
      <tr>

         <td colspan="20">
         <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">

         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;
               <xsl:copy-of select="$pSectionLabel" />
            </td>
            <td align="right" width="30%">
            <!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
            <table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
               <tr>
				<!-- CMU Localization === Conditional display for Credits Classes -->
				<xsl:if test="normalize-space($pDisplayCreditClasses)='Y'">
                  <td class="SectionTableSubTitle" align="right">
                            <xsl:call-template name="tCreditsLiteral"/>
                     Applied: 
                  </td>
                  <td class="SectionTableSubData" align="right">
                     <xsl:call-template name="tFormatNumber" >
                        <xsl:with-param name="iNumber" select="@Credits" />
                        <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
                        </xsl:call-template>
                  </td>
                  <td class="SectionTableSubTitle">
                     Classes Applied: 
                  </td>
                  <td class="SectionTableSubData" align="right">
                     <xsl:value-of select="@Classes"/>
                  </td>
				</xsl:if>
				<!-- CMU Localization === End of Conditional display for Credits Classes -->
               </tr>  
            </table>
            </td>
         </tr>
      </table>
      </td>
   </tr>

   <xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
   <tr >
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
      <td class="ClassesAppliedClassesKeyOnly" >
      <xsl:for-each select="Class">
         <xsl:choose>
          <xsl:when test="@Letter_grade = 'PLAN'"> 
            <font color="blue">
                     (<xsl:value-of select="@Discipline"/>        <!-- left paren + Discipline -->
                     <xsl:text>&#160;</xsl:text>                  <!-- space --> 
                     <xsl:value-of select="@Number"/>)            <!-- Number + right paren -->
            </font>
            <xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->
         </xsl:when> 
         <xsl:otherwise>
            <xsl:value-of select="@Discipline"/>
            <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:value-of select="@Number"/> 
            <xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
            <xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
            <xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
         </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      </td>
   </tr>
   </xsl:if> <!-- show-course-keys-only = Y -->

   <xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
   <xsl:for-each select="Class">
    <xsl:variable name="vRowColorClass">
      <xsl:if test="position() mod 2 = 0">CourseAppliedRowAlt</xsl:if>
      <xsl:if test="position() mod 2 = 1">CourseAppliedRowWhite</xsl:if>
    </xsl:variable>
   <xsl:variable name="tReason"><xsl:value-of select="@Reason"/></xsl:variable>
    <xsl:for-each select="key('ClsKey',@Id_num)">
      <xsl:if test="@Rec_type != 'G'"> 
      <tr>
        <xsl:attribute name="class"><xsl:value-of select="$vRowColorClass"/></xsl:attribute>
      <xsl:if test="@Letter_grade = 'PLAN'"> 
         <xsl:attribute name="style">
            color:blue;
         </xsl:attribute>
      </xsl:if>
         
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="ClassesAppliedClasses"  >                                            -->
	 <td width = "8%" class="ClassesAppliedClasses"  >
            <xsl:value-of select="@Discipline"/>
            <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:value-of select="@Number"/>    
         </td>
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td xxxwidth="50%" class="SectionCourseTitle">                                  -->
	 <td width="70%" class="SectionCourseTitle">
            <!-- Title: -->
            <!-- Use the Id_num attribute on this node to lookup the Class info
            on the Clsinfo/Cass node and get the Title -->     
            <xsl:value-of select="key('ClsKey',@Id_num)/@Course_title"/>
         </td>
         <!-- Show the reason the class is in the OTL list if this is the OTL list  -->
		
		<!-- CMU Localization === Remove reason OTL aka Maximum classes excedded
		<xsl:if test="@Reason">
			<td class="SectionCourseTitle">
                <a title="This is why this class was not counted">
                  <xsl:call-template name="globalReplace">
                    <xsl:with-param name="outputString" select="@Reason"/>
                    <xsl:with-param name="target"       select="'credits'"/>
                    <xsl:with-param name="replacement"  select="normalize-space(/Report/@rptCreditsLiteral)"/>
                  </xsl:call-template>
                </a>
            <xsl:text>&#160;</xsl:text> 
         </td>
            </xsl:if>
		-->
		
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="SectionCourseGrade">                                                 -->
	 <td width="6%" class="SectionCourseGrade">
              <xsl:call-template name="tCourseSignalsGrade"/>
         </td>
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="SectionCourseCredits">                                               -->
	 <td width="6%" class="SectionCourseCredits">
              <xsl:call-template name="CheckInProgressAndPolicy5"/>
         </td>
         <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="SectionCourseTerm">                                                  -->
	 <td width="10%" class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
            <xsl:value-of select="key('ClsKey',@Id_num)/@TermLit"/>
         </td>
      </tr>

      <!-- If this is a transfer class show more information -->
      <xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">
      <tr >
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
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
   
   <xsl:for-each select="Noncourse"> 
      <xsl:call-template name="tShowNoncourse"/> <!-- in AuditBlocks.xsl -->
   </xsl:for-each> 
   </table>
</xsl:if>
</xsl:for-each> 
</xsl:template>

<xsl:template name="tSectionInprogress">

<xsl:for-each select="In_progress">
<xsl:if test="@Classes &gt; 0">
   <table border="0" cellspacing="1" cellpadding="0" width="100%" class="xBlocks">
      <tr>

         <td colspan="20">
         <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">

         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;
               <xsl:copy-of select="$LabelInprogress" />
            </td>
            <td align="right" width="30%">
            <!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
            <table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
               <tr>
				  <!-- CMU Localization === Removed display of Credits Classes
                  <td class="SectionTableSubTitle" align="right">
                            <xsl:call-template name="tCreditsLiteral"/>
                     Applied: 
                  </td>
                  <td class="SectionTableSubData" align="right">
                     <xsl:call-template name="tFormatNumber" >
                        <xsl:with-param name="iNumber" select="@Credits" />
                        <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
                        </xsl:call-template>
                  </td>
                  <td class="SectionTableSubTitle">
                     Classes Applied: 
                  </td>
                  <td class="SectionTableSubData" align="right">
                     <xsl:value-of select="@Classes"/>
                  </td>
				  -->
				  <!-- CMU Localization === End of Removed display of Credits Classes -->
               </tr>  
            </table>
            </td>
         </tr>
      </table>
      </td>
   </tr>

   <xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
   <tr >
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
      <td class="ClassesAppliedClassesKeyOnly" >
      <xsl:for-each select="Class">
         <xsl:choose>
         <xsl:when test="@Letter_grade = 'PLAN'"> 
            <font color="blue">
                     (<xsl:value-of select="@Discipline"/>        <!-- left paren + Discipline -->
                     <xsl:text>&#160;</xsl:text>                  <!-- space --> 
                     <xsl:value-of select="@Number"/>)            <!-- Number + right paren -->
            </font>
            <xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->
         </xsl:when> 
         <xsl:otherwise>
            <xsl:value-of select="@Discipline"/>
            <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:value-of select="@Number"/> 
            <xsl:if test="key('ClsKey',@Id_num)[@In_progress='Y']/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
            <xsl:if test="key('ClsKey',@Id_num)[@In_progress='Y']/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
            <xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
         </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      </td>
   </tr>
   </xsl:if> <!-- show-course-keys-only = Y -->

   <xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
   <xsl:for-each select="Class">
      <tr >
      <xsl:if test="@Letter_grade = 'PLAN'"> 
         <xsl:attribute name="style">
            color:blue;
         </xsl:attribute>
      </xsl:if>
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
         <!-- COURSE KEY -->
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="ClassesAppliedClasses"  >                                            -->
	 <td width="8%" class="ClassesAppliedClasses"  >
            <xsl:value-of select="@Discipline"/>
            <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:value-of select="@Number"/>    
         </td>
         <!-- TITLE -->
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td width="50%" class="SectionCourseTitle">                                     -->
         <td width="70%" class="SectionCourseTitle">
	    <!-- Title: -->
            <!-- Use the Id_num attribute on this node to lookup the Class info
            on the Clsinfo/Cass node and get the Title -->     
            <xsl:value-of select="key('ClsKey',@Id_num)[@In_progress='Y']/@Course_title"/>
         </td>
         <!-- GRADE -->
         <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="SectionCourseGrade">                                                 -->
	 <td width="6%" class="SectionCourseGrade">
              <xsl:call-template name="tCourseSignalsGrade"/>
         </td>
         <!-- CREDITS -->
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="SectionCourseCredits">                                               -->
	 <td width="6%" class="SectionCourseCredits">
            <xsl:call-template name="tFormatNumber" >
                        <xsl:with-param name="iNumber" select="@Credits" />
                        <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
                        </xsl:call-template>
         </td>
         <!-- TERM -->
	 <!-- CMU Localization === Added width to align block columns ======================= -->
         <!-- <td class="SectionCourseTerm">                                                  -->
	 <td width="10%" class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
            <xsl:value-of select="key('ClsKey',@Id_num)[@In_progress='Y']/@TermLit"/>
         </td>
      </tr>

      <!-- If this is a transfer class show more information -->
      <xsl:if test="key('ClsKey',@Id_num)[@In_progress='Y']/@Transfer='T'">
      <tr >
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
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

    <xsl:if test="$vShowCourseSignals='Y'">
    <tr>
   <td colspan="20">
    <xsl:call-template name="tCourseSignalsHelp" />
   </td>
   </tr>
   </xsl:if>

   </table>
</xsl:if>
</xsl:for-each> 
</xsl:template>

<!-- CourseSignals grade or icon -->
<xsl:template name="tCourseSignalsGrade">
  <xsl:choose>
  <xsl:when test="$vShowCourseSignals='Y'">  <!-- CourseSignals -->
    <xsl:choose>
    <!-- Effort - contains both the color and the high/low value -->
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='SIGNALEFFORT' and @Value='6']">
     <img src="common/coursesignals-red.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsRedLow"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='SIGNALEFFORT' and @Value='5']">
     <img src="common/coursesignals-red.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsRedHigh"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='SIGNALEFFORT' and @Value='4']">
     <img src="common/coursesignals-yellow.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsYellowLow"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='SIGNALEFFORT' and @Value='3']">
     <img src="common/coursesignals-yellow.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsYellowHigh"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='SIGNALEFFORT' and @Value='2']">
     <img src="common/coursesignals-green.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsGreenLow"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='SIGNALEFFORT' and @Value='1']">
     <img src="common/coursesignals-green.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsGreenHigh"/></xsl:attribute>
     </img>
    </xsl:when>
    <!-- Effort is missing so just rely on the signal color -->
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='RED']">
     <img src="common/coursesignals-red.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsRedHigh"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='YELLOW']">
     <img src="common/coursesignals-yellow.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsYellowHigh"/></xsl:attribute>
     </img>
    </xsl:when>
    <xsl:when test="key('ClsKey',@Id_num)[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='GREEN']">
     <img src="common/coursesignals-green.png" ondragstart="window.event.returnValue=false;">
        <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsGreenHigh"/></xsl:attribute>
     </img>
    </xsl:when>

    <xsl:otherwise> <!-- no signal on this class - just show the grade -->
     <xsl:value-of select="@Letter_grade"/> 
     <xsl:text>&#160;</xsl:text> <!-- space --> 
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise> <!-- CourseSignals is turned off - just how the grade -->
    <xsl:value-of select="@Letter_grade"/> 
    <xsl:text>&#160;</xsl:text> <!-- space --> 
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- CourseSignals help link -->
<!-- Only appears if the student has at least one red signal for an in-progress class -->
<xsl:template name="tCourseSignalsHelp">
  <xsl:if test="$vShowCourseSignals='Y'">  <!-- CourseSignals -->
       <xsl:if test="/Report/Audit/Clsinfo/Class[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='RED']">
         <table border="0" cellspacing="0" cellpadding="0" width="80%" class="bgLight0" align="center">
          <tr>
           <td rowspan="20" colspan="20" align="center">
               <img src="common/coursesignals-red.png" title="You should seek help" ondragstart="window.event.returnValue=false;"/>
           </td>
          </tr>
         <tr >
            <td class="bgLight0" colspan="1" rowspan="2" valign="middle" xxnowrap="false" align="center">
               &#160;You are having trouble with your classes this semester. 
               We encourage you to make use of the services on campus to help you succeed.
               Please review the many ways we can help you by visiting 
               <a title="Get help" target="newCourseSignalsWindow">
                    <xsl:attribute name="href"><xsl:copy-of select="$CourseSignalsHelpUrl"/></xsl:attribute>
                    <xsl:copy-of select="$CourseSignalsHelpUrl"/>
               </a>
            </td>
            <!-- <td align="right" width="10%">          </td> -->
         </tr>
         </table>
      </xsl:if> <!-- help link -->
  </xsl:if> <!-- if-coursesignals -->
</xsl:template>

<xsl:template name="tSectionExceptions">
<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
   <tr>
      <td colspan="20">
      <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;Exceptions
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
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
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
          <xsl:if test="@Enforced = 'No'">
           <a> 
            <xsl:attribute name="title"><xsl:value-of select="@Reason"/></xsl:attribute>
            <xsl:value-of select="@Enforced"/>
          </a> 
          </xsl:if>
          <xsl:if test="@Enforced != 'No'">
            <xsl:value-of select="@Enforced"/>
          </xsl:if>
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
         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;Notes
            </td>
         </tr>
      </table>
      </td>
      </tr>
      <tr>
            <!-- If this school uses the internal-note checkbox and this is not a student reviewing their own audit -->
            <xsl:if test="(/Report/@rptShowNoteCheckbox) ='Y' and /Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id"> 
          <td class="AuditNotesHeader"><b>Internal</b></td>  
            </xsl:if>
         <td class="AuditNotesHeader" width="70%"><b> </b></td>  
         <td class="AuditNotesHeader"><b> Entered by  </b></td>  
         <td class="AuditNotesHeader"><b> Date </b></td>  
      </tr>

      <xsl:for-each select="Notes/Note[@Note_type != 'PL']">
        <xsl:choose>
      <xsl:when test="$vShowPetitions='N' and substring(@Note_status, 1, 1) = 'P'" >
          <!-- do not show this petition -->
       </xsl:when>
       <xsl:otherwise> <!-- show this normal note or petition -->
      <tr>
        <xsl:if test="position() mod 2 = 0">
         <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
        </xsl:if>
        <xsl:if test="position() mod 2 = 1">
         <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
        </xsl:if>
            <!-- Internal flag -->
            <xsl:if test="(/Report/@rptShowNoteCheckbox) ='Y' and /Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id"> 
          <td align="center">
              <xsl:choose>
              <xsl:when test="substring(@Note_type,2,1)='I'"> <!-- Internal -->
                <img src="common/internal-note-checkmark.gif" ondragstart="window.event.returnValue=false;"
                     title="This note is marked as 'Internal - not available to the student' " border="0"/>
              </xsl:when>
              <xsl:otherwise>
                &#160;
              </xsl:otherwise>
              </xsl:choose>
          </td>  
            </xsl:if>

         <td class="AuditNotesData">
         <xsl:for-each select="./Text"><xsl:value-of select="."/></xsl:for-each>          
         </td>  
         <td class="AuditNotesData"><!-- xsl:value-of select="@Note_date"/ -->
            <xsl:value-of select="@Note_who"/>
         </td>
         <td class="AuditNotesData">
            <xsl:call-template name="FormatNoteDate"/>
         </td>
      </tr>
       </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
   </table>

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

<!-- template tIndentLevel-Advice removed - not used 1.15 -->

<xsl:template name="tStudentID"> 
<xsl:variable name="stu_id"           select="normalize-space(AuditHeader/@Stu_id)"/>
<xsl:variable name="stu_id_length"    select="string-length(normalize-space(AuditHeader/@Stu_id))"/>
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
      <xsl:value-of select="AuditHeader/@Stu_id"/>
   </xsl:when>
   <xsl:otherwise>
      <xsl:value-of select="concat($myAsterisks, substring($stu_id, $bytes_to_remove + 1, $bytes_to_show))" />
   </xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template match="FreezeTypes">
<!-- do nothing; we need this so the codes in the UserClass nodes don't get displayed automatically -->
</xsl:template>

<!-- tBlocks template contains the block/rule templates -->
<xsl:include href="AuditBlocks.xsl" />

<!-- tLegend template is in this included xsl; shared by athletic and academic audits -->
<xsl:include href="AuditLegend.xsl" />

<!-- tStudentHeader template is in this included xsl; shared by athletic and fin-aid audits -->
<xsl:include href="AuditStudentHeader.xsl" />

<!-- FormatDate template is in this included xsl -->
<xsl:include href="FormatDate.xsl" />

<!--
<xsl:template name="tFormatNumber">
<xsl:template name="FormatRuleXptDate">   
<xsl:template name="FormatXptDate"> 
<xsl:template name="FormatNoteDate">   
<xsl:template name="globalReplace">
<xsl:template name="tFillAsterisks">
<xsl:template name="tAsterisks">
-->
<!-- Templates for general functionality -->
<xsl:include href="CommonTemplates.xsl" />

</xsl:stylesheet>
