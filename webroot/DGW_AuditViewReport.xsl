<!-- 
 Copyright 1995-2014 Ellucian Company L.P. and its affiliates. 
 $Id: //Tuxedo/RELEASE/Product/webroot/DGW_AuditViewReport.xsl#1 $ -->
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
<xsl:variable name="LabelProgressBar">		Degree Progress  </xsl:variable>
<xsl:variable name="LabelStillNeeded">		Still Needed:	</xsl:variable>
<xsl:variable name="LabelAlertsReminders">  Alerts and Reminders </xsl:variable>
<xsl:variable name="LabelFallthrough">      Other Transferable Courses - These may be used toward electives or possibly a minor </xsl:variable>
<xsl:variable name="LabelInprogress">       In-progress </xsl:variable>
<xsl:variable name="LabelOTL">              Not Counted </xsl:variable>
<xsl:variable name="LabelInsufficient">     Insufficient </xsl:variable>
<xsl:variable name="LabelSplitCredits">     Split Credits </xsl:variable>
<xsl:variable name="LabelPlaceholders">     Planner Placeholders </xsl:variable>
<xsl:variable name="LabelIncludedBlocks">   Blocks included in this block</xsl:variable>
<xsl:variable name="vShowTitleCreditsInHint">Y</xsl:variable>
<xsl:variable name="vLabelSchool"     >Level</xsl:variable>
<xsl:variable name="vLabelDegree"     >Degree</xsl:variable>
<xsl:variable name="vLabelMajor"      >Major</xsl:variable>
<xsl:variable name="vLabelMinor"      >Minor</xsl:variable>
<xsl:variable name="vLabelCollege"    >College</xsl:variable>
<xsl:variable name="vLabelLevel"      >Classification</xsl:variable>
<xsl:variable name="vLabelAdvisor"    >Advisor</xsl:variable>
<xsl:variable name="vLabelStudentID"  >ID</xsl:variable>
<xsl:variable name="vLabelStudentName">Student</xsl:variable>
<xsl:variable name="vLabelOverallGPA" >Overall GPA</xsl:variable>
<xsl:variable name="vGetCourseInfoFromServer">Y</xsl:variable>
<xsl:variable name="vGPADecimals">0.000</xsl:variable>
<xsl:variable name="vCreditDecimals">0.###</xsl:variable>
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

<!-- Disclaimer text defined in AuditDisclaimer.xml -->
<xsl:variable name="DisclaimerDocument"  select="document('AuditDisclaimer.xml')"/> 

<xsl:key name="XptKey"    match="Audit/ExceptionList/Exception" use="@Id_num"/>
<xsl:key name="ClsKey"    match="Audit/Clsinfo/Class" use="@Id_num"/>
<xsl:key name="NonKey"    match="Audit/Clsinfo/Noncourse" use="@Id_num"/>
<xsl:key name="ClsCrdReq" match="Header/Qualifier" use="@Node_type"/>
<xsl:key name="BlockKey"  match="Audit/Block" use="@Req_id"/>
<xsl:key name="BlockKey2" match="Audit/Block" use="@Req_type"/>

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
	<xsl:call-template name="tTitleForPrintedAudit"/>
	<link rel="stylesheet" href="DGW_Style.css" type="text/css" />
<body style="margin: 5px;">

<form name="frmAudit" ID="frmAudit">

<!-- // Legend (Top) // -->
<xsl:if test="/Report/@rptShowLegend='Y'">
<!--<xsl:call-template name="tLegend"/>-->
</xsl:if>

<!-- // School Header // -->
<!-- <xsl:call-template name="tSchoolHeader"/>-->

<!-- // Student Header // -->
<xsl:if test="/Report/@rptShowStudentHeader='Y'">
<xsl:call-template name="tStudentHeader"/>
</xsl:if>

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

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- // Requirement Blocks (for-each one) // -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:for-each select="Block">
<a> <!-- insert a link to this block for the IncludedBlocks section 1.15 -->
<xsl:attribute name="name"><xsl:value-of select="@Req_type"/>-<xsl:value-of select="@Req_value"/></xsl:attribute>
</a>
<a> <!-- insert a link to this block for Block rules 1.15 -->
<xsl:attribute name="name">Block-<xsl:value-of select="@Req_id"/></xsl:attribute>
</a>
<a> <!-- insert a link to this block for Blocktype rules 1.15 -->
<xsl:attribute name="name">BlockTitle-<xsl:value-of select="normalize-space(@Title)"/></xsl:attribute>
</a>
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
  <!-- For qualifiers with labels, show a checkbox and the label along with the advice -->
  <xsl:call-template name="tHeaderQualifierLabels"/>

<!--//////////////////////////////////////////////////// 
	// Block Remarks Rows							-->
	<xsl:if test="/Report/@rptShowBlockRemarks='Y'">
		<xsl:call-template name="tBlockRemarks"/>
	</xsl:if>  

<!--//////////////////////////////////////////////////// 
  // Block Exceptions             -->
   <xsl:if test="/Report/@rptShowBlockExceptions='Y'">
      <xsl:call-template name="tBlockExceptions"/>
   </xsl:if>  
   
<!--//////////////////////////////////////////////////// 
	// Block Qualifier Rows							-->
	<xsl:if test="/Report/@rptShowQualifierText='Y'">
	<xsl:if test="Header/Qualifier"> 
		<xsl:call-template name="tBlockQualifiers"/>
	</xsl:if>
	</xsl:if>  

<!--//////////////////////////////////////////////////// 
	// Rule Rows                                          -->
	<xsl:for-each select=".//Rule">
	<xsl:if test="@RuleType != 'IfStmt'">
	<xsl:if test="@RuleType != 'IncludeBlocks'">   <!-- 1.15 -->
    <xsl:if test="@RuleType != 'Subset' or /Report/@rptHideSubsetLabels='N'"> <!-- 1.15 -->
	<xsl:if test="@Per_complete != 'Not Used'">
	<xsl:if test="@Per_complete != 'Not Needed'">
		<xsl:choose>
        <xsl:when test="/Report/@rptShowRuleText='N' and
                        ancestor::Rule[*]/@RuleType  = 'Group' and 
                        ancestor::Rule[*]/@Per_complete = '100' and @Per_complete='0'">
          <!-- do not show the labels for the rules within the group that is already completed -->
          <!-- However, if the group was forced complete and there are some subrules that are partially 
               complete we want to show them with their classes applied. For this reason we use Per_complete=0 so
               that only those rules that are not partially complete (have no classes) will be hidden. -->
        </xsl:when>

        <xsl:when test="/Report/@rptShowRuleText='N' and
		                ancestor::Rule[*]/@RuleType  = 'Group' and 
                        ancestor::Rule[*]/@Per_complete = '98' and not(@Per_complete='100' or @Per_complete='98')">
          <!-- do not show the labels for the rules within the group that is already completed -->
        </xsl:when>

        <!-- When there is an ancestor node, check to see if any of them are 
              "Not Needed" If so, do not show the rule.  This happens in nested group rules. -->
        <xsl:when test="ancestor::Rule and ancestor::Rule[*]/@Per_complete  = 'Not Needed'"> 
          <!-- Do nothing -->
        </xsl:when>

        <xsl:when test="/Report/@rptShowRuleText='N' and
		                ancestor::Rule[*]/@RuleType  = 'Subset' and 
                        ancestor::Rule[*]/@Per_complete = '100' and @Per_complete!='100'">
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
	</xsl:if> 
	</xsl:for-each>  <!-- Rule -->

<!--//////////////////////////////////////////////////// 
  // Included Blocks                             1.15 -->
  <xsl:if test="/Report/@rptIncludeBlocks='Y'">
   <xsl:call-template name="tIncludedBlocks"/>
  </xsl:if>  
  
  <xsl:call-template name="tEndOfBlock"/>

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
   // Placeholder Section for planner audits    -->
      <xsl:if test="/Report/Audit/Placeholders/Placeholder">
      <xsl:call-template name="tSectionPlaceholders"/>
   </xsl:if> 

<!--//////////////////////////////////////////////////// 
	// Fallthrough Section							-->
	<xsl:if test="/Report/@rptShowFallThroughSection='Y'">
		<xsl:call-template name="tSectionTemplate">
		<xsl:with-param name="pSectionType" select="Fallthrough" />
		<xsl:with-param name="pSectionLabel" select="$LabelFallthrough" />
		</xsl:call-template>
	</xsl:if> 

<!--//////////////////////////////////////////////////// 
	// Insufficient Section							-->
	<xsl:if test="/Report/@rptShowInsufficientSection='Y'">
		<xsl:call-template name="tSectionTemplate">
		<xsl:with-param name="pSectionType" select="Insufficient" />
		<xsl:with-param name="pSectionLabel" select="$LabelInsufficient" />
		</xsl:call-template>
	</xsl:if> 

<!--//////////////////////////////////////////////////// 
	// Inprogress Section (aka In-Progress)			-->
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
		</xsl:call-template>
    </xsl:if> 

<!--//////////////////////////////////////////////////// 
    // Split Credits Section                     1.15 -->
    <xsl:if test="/Report/@rptShowSplitCreditsSection='Y'">
 		<xsl:call-template name="tSectionTemplate">
		<xsl:with-param name="pSectionType" select="SplitCredits" />
		<xsl:with-param name="pSectionLabel" select="$LabelSplitCredits" />
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
<xsl:if test="/Report/@rptShowDisclaimer='Y'">
	<xsl:call-template name="tDisclaimer"/>
</xsl:if> 

<!-- Refresh student context area with this data -->
<xsl:call-template name="tRefreshStudentData" />
<!-- Enable audit buttons in SD2AUDCON -->
<xsl:call-template name="tToggleButtons" />
</form>

</body>
</html>
</xsl:template> <!-- match=Audit -->


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


<xsl:template name="tRefreshStudentData">
<xsl:for-each select="/Report/StudentData" >
<script language="JavaScript">

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

		/*alert(	"myPreviousDegree = " + oStudentToUpdate[5] + "\n" + 
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

<script language="JavaScript">
<xsl:if test="not(/Report/StudentData/PrimaryMst)">
  if (typeof(top.frControl) != "undefined")
   {
   myAuditId = '<xsl:value-of select="/Report/Audit/AuditHeader/@Audit_id" />';
   // if it is a real audit then update the auditdate otherwise do not
   if (myAuditId.substring(0,1) == "A") 
    {
    sTodaysDate = top.frControl.GetCurrentDate(); // mm/dd/ccyy
    sAuditMonth = '<xsl:value-of select="/Report/Audit/AuditHeader/@DateMonth" />';
    sAuditDay   = '<xsl:value-of select="/Report/Audit/AuditHeader/@DateDay"   />';
    sAuditYear  = '<xsl:value-of select="/Report/Audit/AuditHeader/@DateYear"  />';
    sAuditDate = sAuditMonth + '/' + sAuditDay + '/' + sAuditYear;
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


<!-- tCourseAdvice - used for displaying courses in requirement advice -->
<xsl:template name="tCourseAdvice">
  <!-- AdviceLink: Link to a new browser when user clicks on class in advice -->
  <xsl:choose>

   <!-- <xsl:when test="/Report/@rptShowAdviceLink='Y' and (not(contains(@Disc,'@')) and not(contains(@Num,'@')))"> -->
   <!-- We will allow a wildcard in the course number if we GetCourseInfo flag is Y -->
   <xsl:when test="/Report/@rptShowAdviceLink='Y' and not(contains(@Disc,'@')) and 
                   ($vGetCourseInfoFromServer='Y' or not(contains(@Num,'@'))) and 
                   count(child::*[@Code = 'ATTRIBUTE']) = 0">
      <!-- <a target="_blank"> -->
      <span>
         <xsl:if test="@Title and $vShowTitleCreditsInHint='Y'">
            <xsl:attribute name="title">
            <xsl:value-of select="normalize-space(@Title)"/> - <xsl:value-of select="@Credits"/>&#160;<xsl:call-template name="tCreditsLiteral"/>
            </xsl:attribute> <!-- hint = title - 1.19 -->
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$vGetCourseInfoFromServer='Y'">
               <xsl:choose>
                  <xsl:when test="@Num_end">  <!-- if range exists send both pieces -->
                     <dw-class>
                     <xsl:attribute name="dw-classobject">
                     {
                        courseDiscipline : '<xsl:value-of select="@Disc"/>',
                        courseNumber: '<xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>',
                        <!-- Display the discipline only if the discipline isn't repeated --> 
                        attribute:{description: null, code: null},
                        bShowDiscipline:'<xsl:choose><xsl:when test="@NewDiscipline='Yes'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>'  
                     }
                     </xsl:attribute>
                     </dw-class>
                  </xsl:when>
                  <xsl:otherwise>
                     <dw-class>
                     <xsl:attribute name="dw-classobject">
                     {
                        courseDiscipline : '<xsl:value-of select="@Disc"/>',
                        courseNumber: '<xsl:value-of select="@Num"/>',
                        attribute:{description: null, code: null},
                        <!-- Display the discipline only if the discipline isn't repeated --> 
                        bShowDiscipline:'<xsl:choose><xsl:when test="@NewDiscipline='Yes'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>'
                     }
                     </xsl:attribute>
                     <xsl:attribute name="draggable-item">
                     {
                        "courseDiscipline" : "<xsl:value-of select="@Disc"/>",
                        "courseNumber": "<xsl:value-of select="@Num"/><xsl:value-of select="@Num_end"/>",
                        "attribute":{"description": null, "code": null},
                        "bShowDiscipline":"true",
                        "credits": "<xsl:value-of select="@Credits"/>",
                        "attributeSummary": "<xsl:value-of select="normalize-space(@Title)"/>" 
                     }
                     </xsl:attribute>
                     <xsl:attribute name="draggable-datasource">
                        termObject.group.plannedClasses
                     </xsl:attribute>
                     </dw-class>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
         </xsl:choose>
      </span>
   </xsl:when>

   <xsl:otherwise> <!-- ShowAdviceLink=N -->
     <a>                              
      <xsl:if test="@Title and $vShowTitleCreditsInHint='Y'"> <!-- 1.19 -->
      <xsl:attribute name="href">#NULL</xsl:attribute>
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
   </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="@PrereqExists='Y' and /Report/@rptPrereqIndicator='Y'">*<!-- asterisk --></xsl:if>
  <xsl:if test="@With_advice">
   <xsl:choose>

	<xsl:when test="With[@Code='ATTRIBUTE'] and /Report/@rptShowAdviceLink='Y' and $vGetCourseInfoFromServer='Y'">
	    &#160;
		<xsl:for-each select="With[@Code='ATTRIBUTE']">
      <xsl:for-each select="Value">
         <span>
            <xsl:if test="$vShowTitleCreditsInHint='Y'">
               <xsl:attribute name="title">Click to see <xsl:value-of select="../../@Disc"/>&#160;<xsl:value-of select="../../@Num"/><xsl:if test="../../@Num_end">:<xsl:value-of select="../../@Num_end"/></xsl:if> with<xsl:if test="../@Operator = '&lt;&gt;' ">out</xsl:if> an Attribute of <xsl:value-of select="."/></xsl:attribute>
            </xsl:if>
            <!--  If the course link enabled, display a course-link to the attribute -->
            <ng-switch on="bCourseLinkEnabled">
               <a ng-switch-when="true">
                  <xsl:attribute name="ng-controller">CourseInfoController</xsl:attribute>
                  <xsl:attribute name="ng-click">
                     <xsl:choose>
                        <xsl:when test="../../@Num_end">  <!-- if range exists send both pieces -->
                           openCourseLink('<xsl:value-of select="../../@Disc"/>','<xsl:value-of select="../../@Num"/>:<xsl:value-of select="../../@Num_end"/>', '<xsl:value-of select="." />', '<xsl:value-of select="../@Operator"/>');
                        </xsl:when>
                        <xsl:otherwise>
                           openCourseLink('<xsl:value-of select="../../@Disc"/>','<xsl:value-of select="../../@Num"/>', '<xsl:value-of select="." />', '<xsl:value-of select="../@Operator"/>');
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:choose>
                  <xsl:when test="../@Operator = '='">with Attribute </xsl:when>
                  <xsl:when test="../@Operator = '&lt;&gt;'">without Attribute </xsl:when>
                  <xsl:otherwise>Attribute <xsl:value-of select="../@Operator"/>&#160;</xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="."/>
               </a>
            <!--  If the course link is not enabled, display a plain text to the attribute -->  
               <span ng-switch-when="false">
                  <xsl:choose>
                     <xsl:when test="../@Operator = '='">with Attribute </xsl:when>
                     <xsl:when test="../@Operator = '&lt;&gt;'">without Attribute </xsl:when>
                     <xsl:otherwise>Attribute <xsl:value-of select="../@Operator"/>&#160;</xsl:otherwise>
                  </xsl:choose>
               <xsl:value-of select="."/>
               </span>
            </ng-switch>
         </span>
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

  <xsl:if test="/Report/@rptShowPlannedClassesInAdvice='Y' and (not(contains(@Disc,'@')) and not(contains(@Num,'@')))">
  <xsl:call-template name="tPlannedClassesxxxx">
    <xsl:with-param name="pAdviceDisc"  select="@Disc"  />
    <xsl:with-param name="pAdviceNum"   select="@Num" />
  </xsl:call-template>
  </xsl:if>

</xsl:template>

<xsl:template name="tPlannedClassesxxxx">
<xsl:param name="pAdviceDisc"  />
<xsl:param name="pAdviceNum"   />
<xsl:for-each select="/Report/Plan/Term/Course">
  <xsl:if test="(@Discipline = $pAdviceDisc and @Number = $pAdviceNum)">
   <span style="font-weight:normal;font-size:8pt;color:#559999">
    (Planned for <xsl:value-of select="ancestor::Term/@Literal"/>)
   </span>
  </xsl:if> 
</xsl:for-each>
</xsl:template>

<xsl:template name="tPlannedClasses">
<xsl:param name="pAdviceDisc"  />
<xsl:param name="pAdviceNum"   />
<xsl:for-each select="/Report/Plan/Term/Course">
  <xsl:if test="(@Discipline = $pAdviceDisc and @Number = $pAdviceNum)">
   <span style="font-weight:normal;font-size:8pt;color:#559999">
    <xsl:value-of select="$pAdviceDisc"/> <xsl:value-of select="$pAdviceNum"/>
    is planned for <xsl:value-of select="ancestor::Term/@Literal"/><br/>
   </span>
  </xsl:if> 
</xsl:for-each>
</xsl:template>

<xsl:template name="tPlannedClassesSection">
<xsl:param name="pAdvice"  />
<xsl:param name="pAdviceNum"   />
 <xsl:for-each select="$pAdvice/Course">       <!-- FOR EACH COURSE -->
  <xsl:call-template name="tPlannedClasses">
    <xsl:with-param name="pAdviceDisc"  select="@Disc"  />
    <xsl:with-param name="pAdviceNum"   select="@Num" />
  </xsl:call-template>
 </xsl:for-each>
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
<!-- If this class is using repeat policy 5 then only show the credits for the
     class that was used for the Ghost record; for the other class(es) show 0 credits -->
<xsl:template name="CheckInProgressAndPolicy5">	
  <xsl:variable name="vLeftParen">
   <xsl:if test="@In_progress = 'Y'" >(</xsl:if>
  </xsl:variable>
  <xsl:variable name="vRightParen">
   <xsl:if test="@In_progress = 'Y'" >)</xsl:if>
  </xsl:variable>

  <xsl:variable name="vCredits">
  <xsl:choose>
  <xsl:when test="@Repeat_policy = '5'">
    <xsl:choose>
    <!-- If this was the class that was used for the Ghost record then use the real credits -->
	<xsl:when test="key('ClsKey',@Id_num)[@Rec_type='G']/@Term = @Term">
				<xsl:value-of select="@Credits"/>
    </xsl:when>
    <xsl:otherwise> <!-- we want to show 0 for this class since its credits were not counted in the rule -->
        0
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise> <!-- no policy 5 -->
	<xsl:value-of select="@Credits"/>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>

  <!-- Put parens (or blanks) around credits -->
  <xsl:copy-of select="$vLeftParen"/>
   <xsl:call-template name="tFormatNumber" >
		<xsl:with-param name="iNumber" select="$vCredits" />
		<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
	</xsl:call-template>
  <xsl:copy-of select="$vRightParen"/>

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
		<xsl:call-template name="tFormatNumber" >
			<xsl:with-param name="iNumber" select="@Credits" />
			<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
		</xsl:call-template>
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

<!-- Calculate the number of credits required -->
<xsl:template name="tCreditsRequired">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="/Report/Audit/Block[1]/Header/Qualifier[@Node_type='4121']">
     <!-- xsl:if test="@Credits &gt; 0" -->	   
	 <xsl:choose>
     <xsl:when test="@Credits">	   
		<xsl:call-template name="tFormatNumber" >
			<xsl:with-param name="iNumber" select="@Credits" />
			<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
		</xsl:call-template>
     </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - return 0 -->
		0
     </xsl:otherwise>
	 </xsl:choose>
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
       <xsl:call-template name="tCreditsLiteral"/>
       Applied:
      </td>
      <td class="BlockHeadSubData" align="left">
       &#160; <!-- space -->
		<xsl:call-template name="tFormatNumber" >
			<xsl:with-param name="iNumber" select="../../@Credits_applied" /><!-- get the value from the Block node -->
			<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
		</xsl:call-template>
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
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
			SunGard Higher Education DegreeWorks 
		</xsl:when>
		<xsl:when test="/Report/@rptCFG020AuditTitleStyle='B'">
			DegreeWorks <xsl:value-of select="/Report/@rptReportName" /> 
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
		<td align="left" valign="top">                                               
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td align="left" valign="middle" class="StuHead">
				<span class="StuHeadTitle"><h1> <xsl:value-of select="/Report/@rptReportName" /> </h1></span>
				<span class="StuHeadCaption">&#160; &#160;<xsl:value-of select="@Audit_id" /> as of mmm        
                    <xsl:call-template name="FormatDate">
	                	<xsl:with-param name="pDate" select="concat(@DateYear,@DateMonth,@DateDay)" />
                    </xsl:call-template>
			        at mmm <!-- Format the time as hh:mm --> <xsl:value-of select="@TimeHour" />:<xsl:value-of select="@TimeMinute" />
				</span>
				</td>
				<td align="right" valign="middle" class="StuHead">
				  <!-- This will be "What If Audit" or "Look Ahead Audit"; for normal audits this attribute will not exist -->
				  <span class="StuHeadTitle"> <xsl:value-of select="/Report/@rptAuditAction" /> </span>
				<br />
				</td>
			</tr>
		</table>
		</td>
	</tr>
		
	<tr>
		<td>
		<table class="Inner" cellspacing="1" cellpadding="3" border="0" width="100%">

  <!-- xxxxxxxxxxx 1st ROW 		Student name, Level, Class Standing     xxxxxxxxxxx -->
      <tr class="StuTableTitle">
        <td class="StuTableTitle" >
          <xsl:copy-of select="$vLabelStudentName"/>
        </td>
        <td class="StuTableData" >
          <xsl:if test="/Report/@rptUsersId = /Report/Audit/AuditHeader/@Stu_id">
            <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" />
          </xsl:if>
          <!-- Allow user to email the student if this is not the student -->
          <xsl:if test="/Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id">
            <a>
              <xsl:attribute name="href">
                mailto:<xsl:value-of select="/Report/Audit/AuditHeader/@Stu_email"
                 />&amp;subject=Advising Worksheet issue&amp;body=About your worksheet,
              </xsl:attribute>
              <xsl:attribute name="title">Email this student</xsl:attribute>
              <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" />
            </a>&#160; <!-- space -->
          </xsl:if>
        </td>
  </tr>
  <tr>
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelSchool"/></td>
    <td class="StuTableData" ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@SchoolLit" />  </td>
  </tr>
  <!-- xxxxxxxxxxx 2nd ROW   Student ID, Degree, Academic Standing    xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelStudentID"/></td>
    <td class="StuTableData"  >	<xsl:for-each select="/Report/Audit"><xsl:call-template name="tStudentID" /> </xsl:for-each></td>
  </tr>
  <tr>
    <td class="StuTableTitle"  ><xsl:copy-of select="$vLabelDegree"/> </td>
    <td class="StuTableData"   ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" /> &#160; <!-- space --> </td>
  </tr>
   <tr>
  	<!-- CMU Localization === Added Academic Standing -->
		<td class="StuTableTitle" >Academic Standing</td>
		<td class="StuTableData">  
			<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ACADSTAND']">
				<xsl:value-of select="@Value" /><xsl:if test="position()!=last()"><br /></xsl:if>
			</xsl:for-each>
		</td>
	<!-- CMU Localization === End of Added Academic Standing -->
 </tr>
  <!-- xxxxxxxxxxx 3rd ROW      Class Standing, College xxxxxxxxxxx -->
  <tr class="StuTableTitle">
      <td class="StuTableTitle" ><xsl:copy-of select="$vLabelLevel"/></td>
      <td class="StuTableData"  >
        <xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@Stu_levelLit" /> &#160; <!-- space --> 
      </td>
  </tr>
  <tr>
    <td class="StuTableTitle" >
		<xsl:copy-of select="$vLabelCollege"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='COLLEGE'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='COLLEGE']">
		<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>	
	</td>
  </tr>
  <!-- xxxxxxxxxxx 4th ROW 		Advisor,  Major, Graduation Application Status  xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle"  >
		<xsl:copy-of select="$vLabelAdvisor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='ADVISOR'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"   >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='ADVISOR']">
      <a>
        <xsl:attribute name="href">mailto:<xsl:value-of select="@Advisor_email" 
               />?cc=<xsl:value-of select="/Report/Audit/AuditHeader/@Stu_email" /> &amp;subject=Advising Worksheet question&amp;body=I have a question about my worksheet.</xsl:attribute>
        <xsl:attribute name="title">Email this advisor</xsl:attribute>
        <xsl:value-of select="@Advisor_name" />
      </a>&#160; <!-- space -->  
	<xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>
    </td>
  </tr>
  <tr>
    <td class="StuTableTitle" >
		<xsl:copy-of select="$vLabelMajor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='MAJOR'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='MAJOR']">
		<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>
	</td>
  </tr>
  <!-- xxxxxxxxxxx 5th ROW 		Graduation GPA, Minor    xxxxxxxxxxx -->
  <tr class="StuTableTitle">
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelOverallGPA"/></td>
    <xsl:choose>
      <xsl:when test="/Report/@rptShowStudentSystemGPA='Y'">
      <!-- If the SSGPA is empty then show the DWGPA value -->
        <xsl:choose>
	  <xsl:when test="normalize-space(@SSGPA)=''"> <!-- SSGPA is empty/blanks -->
	    <td class="StuTableData"  >
			<xsl:call-template name="tFormatNumber" >
				<xsl:with-param name="iNumber"         select="@DWGPA" />
				<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
			</xsl:call-template>
		</td>
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="StuTableData"  >
			<xsl:call-template name="tFormatNumber" >
				<xsl:with-param name="iNumber" select="@SSGPA" />
				<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
			</xsl:call-template>
		</td>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> <!-- We always want to show the DWGPA -->
	<td class="StuTableData"  >
			<xsl:call-template name="tFormatNumber" >
				<xsl:with-param name="iNumber" select="@DWGPA" />
				<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
			</xsl:call-template>
	</td>
      </xsl:otherwise>
    </xsl:choose>
  </tr>
  <tr>
    <td class="StuTableTitle" >
		<xsl:copy-of select="$vLabelMinor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='MINOR'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='MINOR']">
		<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>
	</td>
    </tr>
  </table>
	</td></tr>	
</table>
  </xsl:for-each> <!-- audit header -->
</xsl:template> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT HEADER END -->
<!-- //////////////////////////////////////////////////////////////////////// -->

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT ALERTS -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:template name="tStudentAlerts"> 
<!-- If an ALERT1 Report node exists -->
<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT1'"> 
<br />
<table border="0" cellspacing="0" cellpadding="0" width="60%" align="center" class="AuditTable">

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
		<td>
		<table class="Inner" cellspacing="1" cellpadding="3" border="0" width="100%">

			<xsl:if test="/Report/Audit/Deginfo/Report/@Code='ALERT1'"> 
			  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
			  <tr class="StuTableTitle">
				<td class="StuTableData" >
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
				<img src="Images_DG2/Arrow_Right.gif" ondragstart="window.event.returnValue=false;" />&#160;
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
	</xsl:if>
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
         <xsl:if test="/Report/Audit/Block[1]/Header/Qualifier/CREDITSAPPLIEDTOWARDSDEGREE"> (excluding excess electives)</xsl:if></xsl:attribute>
       <tr>
	      <td class="ProgressSubTitle"><xsl:call-template name="tCreditsLiteral"/>
		  </td>
          <td>
		  <xsl:attribute name="class">ProgressBar</xsl:attribute>
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
	</xsl:if>

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
					<xsl:call-template name="tBlockHeader"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="@Req_type = 'DEGREE'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'BS'">  
					<!-- DEGREE BS blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- DEGREE blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="@Req_type = 'DEGREE'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'CS'">  
					<!-- MAJOR CS blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- MAJOR blocks -->
					<xsl:call-template name="tBlockHeader"/>
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
        <td class="BlockHeader" colspan="1" valign="middle">
        <!-- Accessibility Adding Block Notice  -->
        <div class="element-invisible" >
           Block Start
        </div>
          <img src="Images_DG2/spacer.gif" ondragstart="window.event.returnValue=false;" width="5" alt="" />
          <!-- BLOCK HEADER CHECKBOX BEGIN -->
          <xsl:choose>
            <xsl:when test="@Per_complete = 100">
              <img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;" alt="Complete" />
            </xsl:when>
            <xsl:when test="@Per_complete = 99">
              <img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;" alt="Nearly complete - see advisor" />
            </xsl:when>
            <xsl:when test="@Per_complete = 98">
              <img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;" alt="Complete except for in-progress classes"/>
            </xsl:when>
            <xsl:otherwise>
              <img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;" alt="Not yet complete" />
            </xsl:otherwise>
          </xsl:choose>
          <!-- BLOCK HEADER CHECKBOX END -->
        </td>

        <!-- BLOCK TITLE -->
        <td width="100%" align="left" class="BlockHeadTitle">
          <xsl:value-of select="@Title"/>
        </td>
      </tr>
      <tr>

				 <!-- BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
				<td align="left" colspan="4">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%">
          <tr>
            <!-- cat-yr -->
            <td class="BlockHeadSubTitle"  align="right">
              <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
            </td>
            <td class="BlockHeadSubData">
              &#160; <!-- space -->
              <xsl:value-of select="@Cat_yrLit"/>
            </td>
            <!-- Check to see if credits or classes are required on this block and show the value -->
            <!-- This inserts a new <td></td> entry -->
          </tr>
					<tr>
						<td class="BlockHeadSubTitle" align="right">
							GPA:
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
						</td>
						<!-- Check to see if credits or classes are required and show the corresponding value applied -->
						<!-- This inserts a new <td></td> entry -->
          </tr>
          <tr>
            <xsl:call-template name="CheckCreditsClasses-Applied"/>
               </tr>
                 <tr>
                  <xsl:call-template name="CheckCreditsClasses-Required"/>
               </tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
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
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
						</td>
						<td class="BlockHeadSubData"  align="right">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
						</td>
					</tr>
				</table>
				</td>
			</tr><!-- END BLOCK HEADER ROW -->
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
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
						</td>
						<td class="BlockHeadSubTitle"  align="right">
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
						</td>
						<td class="BlockHeadSubData">
							&#160; <!-- space -->
							<xsl:value-of select="@Cat_yrLit"/> 
						</td>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
						</td>
						<xsl:call-template name="CheckCreditsClasses-Required"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
						</td>
						<xsl:call-template name="CheckCreditsClasses-Applied"/>
					</tr>
				</table><!-- END table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				</td><!-- END BLOCK INFO (CAT-YR, GPA, APPLIED, REQUIRED -->
			</tr><!-- END BLOCK HEADER ROW -->
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
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
					
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
                          <xsl:value-of select="normalize-space(/Report/@rptCatYrLit)" />:
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@GPA" />
								<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
							</xsl:call-template>
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
         <xsl:choose>
         <xsl:when test="../../Qualifier[@Node_id=@Node_id]/@Label" >
         <!-- do not show this qualifier's advice; the advice will be shown in tHeaderQualifierLabels -->
         </xsl:when>
         <xsl:otherwise>
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
         </xsl:otherwise>
         </xsl:choose>
			</xsl:for-each>	<!-- END FOR EACH HEADER QUALIFIER -->
	    </table>
		</td>
	</tr>
</xsl:template> 

<!-- For each block header qualifer that has a label - show a checkbox and label and advice -->
<xsl:template name="tHeaderQualifierLabels">
<xsl:for-each select="Header/Qualifier[@Label]">
	<tr >
		<!-- CHECKBOX + LABEL -->
		<td class="RuleLabelLine" >
		<table border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<!-- CHECKBOX -->
				<td nowrap="true">
					<xsl:choose>
						<xsl:when test="@Satisfied='Yes'">  
							<img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;" alt="Complete" valign="bottom"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;" alt="Not yet complete"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<!-- END CHECKBOX -->
				<!-- LABEL -->
				<td class="RuleLabelTitle">
					<xsl:choose>
						<xsl:when test="@Satisfied='Yes'">  
							<td class="RuleLabelTitleNotNeeded">
								<xsl:value-of select="@Label"/>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="RuleLabelTitleNeeded">
								<xsl:value-of select="@Label"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
		</td>
		<!-- END LABEL -->
		<td class="RuleLabelData">
		<table border="0" cellspacing="1" cellpadding="1" width="100%" class="ClassesApplied">
		<tr>
			<td colspan="10">
			<xsl:if test="@Satisfied='No'">
				<xsl:variable name="thisNode_id" select="@Node_id"/>
				<table>
				<tr>
					<td class="RuleAdviceTitleNew" >
						<xsl:copy-of select="$LabelStillNeeded" />
					</td>
					<td class="RuleAdviceData">
					<xsl:for-each select="../Advice/Text">
						<xsl:if test="$thisNode_id=@Node_id">
							<xsl:value-of select="." />
						</xsl:if>
					</xsl:for-each>
					</td>
				</tr>
				</table>
			</xsl:if>
			</td>
		</tr>
		</table>
		</td>
	</tr>
</xsl:for-each>
</xsl:template> 

<xsl:template name="tBlockExceptions"> 
     <xsl:for-each select="Header/Qualifier/Exception">  
         <tr class="ExceptionLabel">
            <td class="RuleExceptionTitle" >
            <table cellspacing="0" cellpadding="0">
               <tr>
                  <td class="RuleExceptionByTitle">
                          <a> <!-- 1.18 -->
                            <xsl:attribute name="name">Exception-<xsl:value-of select="key('XptKey',@Id_num)/@Req_id"/>-<xsl:value-of select="key('XptKey',@Id_num)/@Node_id"/></xsl:attribute>
                          </a> 
                     Exception By:
                  </td>
                  <td class="RuleExceptionByData">
                     <xsl:value-of select="key('XptKey',@Id_num)/@Who"/>
                  </td>
                  <td class="RuleExceptionOnTitle">
                     On:
                  </td>
                  <td class="RuleExceptionOnData">
                     <xsl:call-template name="FormatRuleXptDate"/>
                  </td>
               </tr>
            </table>
            </td>
            <td class="RuleExceptionTitle" >
            <table cellspacing="0" cellpadding="0">
               <tr>
                  <td class="RuleExceptionTextData">
                     <xsl:call-template name="tExceptionType"/>:
                     <xsl:text>&#160;</xsl:text> <!-- space --> 
                     <!-- Description: -->
                     <!-- Use the Id_num attribute on this node to lookup the Exception info
                     on the ExceptionList/Exception node and get the Label -->     
                     <xsl:value-of select="key('XptKey',@Id_num)/@Label"/>
                  </td>
               </tr>
            </table>
            </td>
         </tr>
      </xsl:for-each> <!-- course exception -->
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
					<xsl:for-each select="Header/Remark/Text">	<!-- FOR EACH HEADER REMARK TEXT -->
						<xsl:value-of select="."/>&#160;</xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
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
  <tr>
    <td style="height:1px; background-color:#888888" colspan="30"></td>
  </tr>
</xsl:template> 

<xsl:template name="tRules">
  
  <tr >
    <xsl:choose>
      <xsl:when test="@Per_complete = 100">
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight100'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@Per_complete = 99">
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight99'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@Per_complete = 98">
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight98'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight0'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <!-- CHECKBOX + LABEL -->
    <td class="RuleLabelLine" colspan="30">
      <xsl:choose>
        <xsl:when test="ancestor::Rule[1]/@RuleType  = 'Group' and 
                                          @RuleType != 'Group' and 
                        /Report/@rptHideInnerGroupLabels='Y'">
          <!-- do not show the labels for the rules within the group 1.15 -->
        </xsl:when>
        <xsl:otherwise>

          <table border="0" cellspacing="0" cellpadding="0" >
            <tr>

              <!-- CHECKBOX -->
              <td>
                <!--td style="white-space:nowrap" valign="bottom" width="10%"-->
                <xsl:call-template name="tIndentLevel"/>
                <xsl:choose>
                  <xsl:when test="@Per_complete = 100">
                    <img src="common/dwcheckyes.png" ondragstart="window.event.returnValue=false;" alt="Complete" valign="bottom"/>
                  </xsl:when>
                  <xsl:when test="@Per_complete = 99">
                    <img src="common/dwcheck99.png" ondragstart="window.event.returnValue=false;" alt="Nearly complete - see advisor"/>
                  </xsl:when>
                  <xsl:when test="@Per_complete = 98">
                    <img src="common/dwcheck98.png" ondragstart="window.event.returnValue=false;" alt="Complete except for in-progress classes"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <img src="common/dwcheckno.png" ondragstart="window.event.returnValue=false;" alt="Not yet complete"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <!-- END CHECKBOX -->
              <!-- LABEL -->
              <td class="RuleLabelTitle">
                <xsl:choose>
                  <xsl:when test="@Per_complete = 100">
                    <td class="RuleLabelTitleNotNeeded">
                      <xsl:value-of select="@Label"/>
                    </td>
                  </xsl:when>
                  <xsl:when test="@Per_complete = 99">
                    <td class="RuleLabelTitleNotNeeded">
                      <xsl:value-of select="@Label"/>
                    </td>
                  </xsl:when>
                  <xsl:when test="@Per_complete = 98">
                    <td class="RuleLabelTitleNotNeeded">
                      <xsl:value-of select="@Label"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="RuleLabelTitleNeeded">
                      <xsl:value-of select="@Label"/>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <!-- END LABEL -->
            </tr>
          </table>
        </xsl:otherwise>
        <!-- not a child of a group or hideinnergrouplabels=N -->
      </xsl:choose>
    </td>
    <!-- END CHECKBOX + LABEL -->

    <!-- CLASSES + ADVICE -->
  </tr>
  <tr>
    <xsl:choose>
      <xsl:when test="@Per_complete = 100">
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight100'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@Per_complete = 99">
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight99'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@Per_complete = 98">
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight98'"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:value-of select="'bgLight0'"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
		<td class="RuleLabelData" colspan="30">
		<table border="0" cellspacing="1" cellpadding="1" width="100%" class="ClassesApplied">
			<!-- Show a dummy space if no classes or advice should appear -->       
			<xsl:if test="/Report/@rptShowRuleClassesApplied='N'">
			<xsl:if test="/Report/@rptShowRuleAdvice='N'">
			<tr>
				<td colspan="10">
					&#160;  <!-- space -->  
				</td>
			</tr>
			</xsl:if> <!-- show-rule-advice=N -->
			</xsl:if> <!-- show-rule-classes-applied=N -->

		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<!-- CLASSES APPLIED -->
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<xsl:if test="@RuleType = 'Course'">    <!-- COURSE RULE -->
     	<!-- Show classes applied -->
		<xsl:if test="/Report/@rptShowRuleClassesApplied='Y'">
			<tr >
			<!-- /////////////////////////////////////////////// -->
			<!-- Course Keys ONLY -->
			<!-- /////////////////////////////////////////////// -->
			<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
			<xsl:if test="ClassesApplied/Class">  
				<td class="ClassesAppliedClassesKeyOnly" colspan="2" >
				<table border="0" cellspacing="0" cellpadding="0" width="100%" >
				<tr class="CourseAppliedRowWhite">
				<td class="CourseAppliedDataDiscNum">
				<xsl:for-each select="ClassesApplied/Class">
					<!-- Show planned classes in another color and within parens -->
					<xsl:if test="@Letter_grade = 'PLAN'">
                <!-- Accessibility Adding tag to blue color classes  -->
                <div class="element-invisible" >
                   Planned Class
                </div>
	     		        <span style="font-weight:normal;font-size:8pt;color:#0000FF">
							(<xsl:value-of select="@Discipline"/>		   <!-- left paren + Discipline -->
							<xsl:text>&#160;</xsl:text>					   <!-- space --> 
							<xsl:value-of select="@Number"/>)			   <!-- Number + right paren -->
							<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->
							</span>
					</xsl:if> 
					<!-- END Show planned classes in another color and within parens -->
					<!-- NOT Planned Class -->
					<xsl:if test="@Letter_grade != 'PLAN'"> 
							<span>
							<xsl:value-of select="@Discipline"/>			<!-- Discipline -->
							<xsl:text>&#160;</xsl:text> <!-- space -->		<!-- space -->
							<xsl:value-of select="@Number"/>				<!-- Number -->
							<xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
							<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
							<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->
							</span>
					</xsl:if>
					<!-- END NOT Planned Class -->
					<xsl:if test="string(number(@Id_num))='NaN'">
							<span>
							<xsl:value-of select="@Discipline"/>			<!-- Discipline -->
							<xsl:text>&#160;</xsl:text> <!-- space -->		<!-- space -->
							<xsl:value-of select="@Number"/>				<!-- Number -->
							<xsl:if test="key('ClsKey',@Id_num)/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
							<xsl:if test="key('ClsKey',@Id_num)/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
							<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->
							</span>
					</xsl:if>
				</xsl:for-each>
				</td>
				</tr>
				</table>
				</td>
			</xsl:if> <!-- classes-applied greater than 0 -->
			</xsl:if> <!-- show-course-keys-only -->
			<!-- /////////////////////////////////////////////// -->
			<!-- END Course Keys ONLY -->
			<!-- /////////////////////////////////////////////// -->

			<!-- /////////////////////////////////////////////// -->
			<!-- NOT Course Keys ONLY -->
			<!-- /////////////////////////////////////////////// -->
			<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
			<xsl:if test="ClassesApplied/Class">  
				<td class="RuleLabelData" colspan="1">
				<table border="0" cellspacing="0" cellpadding="1" width="100%" >
					<xsl:for-each select="ClassesApplied/Class">
					<!-- For each instance of the course in the clsinfo section that is not a Ghost record-->
					<!-- We have chosen not to do this when the Show Course keys only is Y because that 
					     would make the display confusing.  -->
					<xsl:for-each select="key('ClsKey',@Id_num)">
					<xsl:if test="@Rec_type != 'G'">
						<tr >
			             <!-- Show planned/look-ahead classes in another color -->
					     <xsl:if test="@Letter_grade = 'PLAN'"> 
		                  <xsl:attribute name="style">color:#0000FF</xsl:attribute>
						 </xsl:if>
						<xsl:if test="position() mod 2 = 0">
						 <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
						</xsl:if>
						<xsl:if test="position() mod 2 = 1">
						 <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
						</xsl:if>
							<td class="CourseAppliedDataDiscNum">
							<!-- Show planned classes in another color and within parens -->
							<xsl:if test="@Letter_grade = 'PLAN'"> 
                        <!-- Accessibility Adding tag to blue color classes  -->
                        <div class="element-invisible" >
                           Planned Class
                        </div>
								(<xsl:value-of select="@Discipline"/>	   <!-- left paren + Discipline -->
								<xsl:text>&#160;</xsl:text>				   <!-- space --> 
								<xsl:value-of select="@Number"/>)          <!-- Number + right paren -->
							</xsl:if>
							<!-- NOT Planned Class -->
							<xsl:if test="@Letter_grade != 'PLAN'"> 
								<xsl:value-of select="@Discipline"/>       <!-- Discipline -->
								<xsl:text> </xsl:text>                     <!-- space --> 
								<xsl:value-of select="@Number"/>           <!-- Number -->
							</xsl:if> 
							</td>

							<!-- TITLE -->
							<td class="CourseAppliedDataTitle">
								<!-- Use the Id_num attribute on this node to lookup the Class info
								on the Clsinfo/Class node and get the Title -->     
								<xsl:value-of select="@Course_title"/>
							</td>
							<!-- GRADE -->
							<td class="CourseAppliedDataGrade">
                              <xsl:call-template name="tCourseSignalsGrade"/>
							</td>
							<!-- CREDITS -->
							<td class="CourseAppliedDataCredits">
								<!-- Place the @Credits in parens if the class is in-progress -->
								<xsl:call-template name="CheckInProgressAndPolicy5"/>
							</td>
							<!-- TERM -->
							<td class="CourseAppliedDataTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
								<xsl:value-of select="@TermLit"/>
							</td>
						</tr>
						<!-- If this is a transfer class show more information -->
						<xsl:if test="@Transfer='T'">
						<tr>
						<xsl:if test="position() mod 2 = 0">
						 <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
						</xsl:if>
						<xsl:if test="position() mod 2 = 1">
						 <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
						</xsl:if>
							<td class="CourseAppliedDataSatisfiedBy">
								Satisfied by 
							</td>
							<td colspan="4" class="CourseTransferData">
								<xsl:value-of select="@Transfer_course"/>
                <!-- Show the transfer course title and transfer school name - if they exist -->                        
                <xsl:if test="normalize-space(@TransferTitle) != ''"> 
                  <xsl:text> - </xsl:text> <!-- hyphen --> 
                  <xsl:value-of select="@TransferTitle"/>
                </xsl:if>
                <xsl:if test="normalize-space(@Transfer_school) != ''"> 
								<xsl:text>-</xsl:text> <!-- hyphen --> 
								<xsl:value-of select="@Transfer_school"/>
                </xsl:if>
							</td>
						</tr>
						</xsl:if>

					</xsl:if>
					</xsl:for-each>
					</xsl:for-each>
				</table>
				</td>
			</xsl:if> <!-- classes-applied > 0 -->
			</xsl:if> <!-- show-course-keys-only = N -->
			<!-- /////////////////////////////////////////////// -->
			<!-- END NOT Course Keys ONLY -->
			<!-- /////////////////////////////////////////////// -->

			</tr>
		</xsl:if> <!-- show rule classes applied -->
		</xsl:if> <!-- ruletype=course -->
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<!-- END CLASSES APPLIED -->
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->


		<!-- /////////////////////////////////////////////// -->
		<!-- NONCOURSES APPLIED -->
		<!-- /////////////////////////////////////////////// -->
		<xsl:if test="@RuleType = 'Noncourse'"> <!-- NONCOURSE -->
		<xsl:if test="NoncoursesApplied/Noncourse"> <!-- see if there is a noncourse -->
		<xsl:if test="/Report/@rptShowRuleClassesApplied='Y'">
			<xsl:for-each select="NoncoursesApplied/Noncourse"> <!-- most likely only one -->
			<tr >
				<xsl:if test="position() mod 2 = 0">
				 <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
				</xsl:if>
				<xsl:if test="position() mod 2 = 1">
				 <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
				</xsl:if>
				<td colspan="10" class="CourseAppliedDataDiscNum">
					&#160; <!-- space -->  
					<xsl:value-of select="Code"/>
					<xsl:if test="Value != '' ">
					 <xsl:text>:&#160;</xsl:text> <!-- space --> 
					 <xsl:value-of select="Value"/>
					</xsl:if>
				</td>
			</tr>
			</xsl:for-each> <!-- NONCOURSES APPLIED-->
		</xsl:if> <!-- show rule classes applied -->
		</xsl:if> <!-- test noncourse -->
		</xsl:if> <!-- ruletype=noncourse -->
		<!-- /////////////////////////////////////////////// -->
		<!-- END NONCOURSES APPLIED -->
		<!-- /////////////////////////////////////////////// -->

		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<!-- RULE ADVICE -->
		<!-- /////////////////////////////////////////////// -->
		<!-- /////////////////////////////////////////////// -->
		<xsl:if test="/Report/@rptShowRuleAdvice='Y'">
		<!-- If at least one Advice node exists -->
		<xsl:if test="Advice"> 
			<!-- If an ancestor has proxy-advice then don't show advice for this rule 1.15 -->
			<xsl:choose>
			<xsl:when test="ancestor::Rule[*]/@ProxyAdvice = 'Yes'">
			<!-- do nothing -->
			</xsl:when> <!-- proxyadvice = Yes -->
			<xsl:otherwise>
			<tr >
				<td colspan="10">
				<table>
				<tr>
				<td class="RuleAdviceTitleNew" >
				    <!-- Suppress the StillNeeded label if we are within a group 1.15-->
					<xsl:choose>
					<xsl:when test="ancestor::Rule">
						<xsl:choose>
							<xsl:when test="ancestor::Rule[*]/@RuleType = 'Group'">
											<!-- Do nothing -->
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
				<!-- Indent the advice - very important for group rules 1.15 -->
                <xsl:if test="ancestor::Rule[*]/@RuleType = 'Group'">
				 <td class="RuleAdviceData">
					<xsl:call-template name="tIndentLevel"/>
				 </td>
			    </xsl:if>
				<td class="RuleAdviceData">
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

					<!-- SUBSET -->
					<xsl:when test="@RuleType = 'Subset'">
					   <!-- QUAL LIST -->
					   <xsl:for-each select="Advice"> <!-- most likely only one -->
                         <xsl:call-template name="tQualAdvice"/>
					   </xsl:for-each>
					</xsl:when> 

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
                         <a> <!-- 1.15 -->
                          <xsl:attribute name="href">#Block-<xsl:value-of select="Advice/BlockID"/></xsl:attribute>
                           See <b><xsl:value-of select="key('BlockKey',Advice/BlockID)/@Title" /></b> section
                         </a>
						</xsl:if>
					</xsl:when> 
					<!-- END BLOCK RULE -->

					<!-- BLOCKTYPE RULE -->
					<xsl:when test="@RuleType = 'Blocktype'">
						<xsl:choose>
							<xsl:when test="Advice/Title"> 
								<xsl:for-each select="Advice/Title"> <!-- most likely only one -->
                                  <a> <!-- 1.15 -->
                                   <xsl:attribute name="href">#BlockTitle-<xsl:value-of select="normalize-space(.)"/></xsl:attribute>
                                    See <b><xsl:value-of select="normalize-space(.)" /></b> section <br/>
                                  </a>
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
						<xsl:choose>
					    <xsl:when test="Course">
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
                                <xsl:call-template name="tCreditsLiteral"/>
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
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="@Credits"> 
								<b><xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@Credits" />
								<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
								</xsl:call-template></b> more 
                                <xsl:call-template name="tCreditsLiteral"/>
							</xsl:if> 
							<xsl:if test="@Classes"> 
								<b><xsl:value-of select="@Classes"/></b> more 
								<xsl:choose>
								<xsl:when test="@Classes &gt; 1">
									Classes
								</xsl:when>
								<xsl:otherwise>
									Class
								</xsl:otherwise>
								</xsl:choose>
							</xsl:if> 
						</xsl:otherwise>
						</xsl:choose>

						<!-- QUAL LIST -->
                        <xsl:call-template name="tQualAdvice"/>

					</xsl:for-each> <!-- select="Advice" -->

  <xsl:if test="/Report/@rptShowPlannedClassesInAdvice='Y'">
                    <br/>
                    <!-- PLANNED CLASSES -->
                    <xsl:call-template name="tPlannedClassesSection">
                     <xsl:with-param name="pAdvice"  select="Advice"  />
                    </xsl:call-template>
  </xsl:if>

					</xsl:when> <!-- course rule -->
					<!-- END COURSE RULE -->

					<xsl:otherwise>
						<!-- do nothing -->
					</xsl:otherwise>
				</xsl:choose> <!-- ruletype -->
				<!-- /////////////////////////////////////////////// -->
				<!-- RULE-TYPE -->
				<!-- /////////////////////////////////////////////// -->

				<!-- Add a closing paren if this is rule is within a group -->
				<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
					) 
					<xsl:choose> <!--  -->
						<xsl:when test="@LastRuleInGroup='Yes'"> 
							<!-- do nothing -->
						</xsl:when>
						<xsl:otherwise>
					      <xsl:choose> <!-- AND or OR -->
						    <xsl:when test="Advice/QualAdvice and not(Advice/Course)">
							  <!-- group but this rule has qualifier advice only - don't show AND or OR -->
						    </xsl:when>
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
			</table>
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
			<td colspan="10">
			<table>
			<tr>
			<!-- Indent the advice - very important for group rules -->
            <xsl:if test="ancestor::Rule[*]/@RuleType = 'Group'">
			 <td class="RuleAdviceData">
				<xsl:call-template name="tIndentLevel"/>
			 </td>
			</xsl:if>

			<td colspan="1" class="RuleAdviceTitleNew">

				    <!-- Suppress the StillNeeded label if we are within a group -->
					<xsl:choose>
					<xsl:when test="ancestor::Rule">
						<xsl:choose>
							<xsl:when test="ancestor::Rule[*]/@RuleType = 'Group'">
											<!-- Do nothing -->
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
			</tr>
			</table>
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
  <tr>
    <td style="height:1px; background-color:#888888" colspan="30"></td>
  </tr>
	<!-- RULE REMARKS -->
	<xsl:if test="/Report/@rptShowRuleRemarks='Y'">
	<xsl:if test="Remark"> 
	<tr >
		<td class="RuleRemarksTable" colspan="2">
		<table border="0">
			<tr >
				<td class="RuleRemarksData">
              <!-- Accessibility Adding tag to blue color classes  -->
              <div class="element-invisible" >
                 Rule Remark
              </div>
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
			<xsl:choose>
				<xsl:when test="@Per_complete = 100">
					<xsl:attribute name="class">
						<xsl:value-of select="'bgDark100'"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@Per_complete = 99">
					<xsl:attribute name="class">
						<xsl:value-of select="'bgDark99'"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@Per_complete = 98">
					<xsl:attribute name="class">
						<xsl:value-of select="'bgDark98'"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">
						<xsl:value-of select="'bgDark0'"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<td colspan="1" align="right" class="RequirementTextTitle">
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
							<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@Credits_begin" />
								<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
								</xsl:call-template>
								<xsl:if test="@Credits_end"> 
								:
								<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@Credits_end" />
								<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
								</xsl:call-template>
								</xsl:if> 
								Credits
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

	<!-- SHOW RULE EXCEPTIONS -->
	<xsl:if test="/Report/@rptShowRuleExceptions='Y'">
	<!-- FOR EACH COURSE EXCEPTION -->
		<xsl:for-each select="Requirement/Course/Exception">	
		<xsl:if test="@Id_num &gt; 0"> <!-- need to exclude RR -->
      <xsl:call-template name="tShowException"/>
		</xsl:if> <!-- need to exclude RR -->
		</xsl:for-each> <!-- course exception -->

		<xsl:for-each select="Requirement/Except/Course/Exception"> 
		<xsl:if test="@Id_num &gt; 0"> <!-- need to exclude RR -->
     <xsl:call-template name="tShowException"/>
		</xsl:if> <!-- need to exclude RR -->
		</xsl:for-each> <!-- course exception -->

    <xsl:for-each select="Requirement/Qualifier/Exception">
     <xsl:call-template name="tShowException"/>
		</xsl:for-each> 
    
		<xsl:for-each select="Exception">
     <xsl:call-template name="tShowException"/>
		</xsl:for-each> <!-- course exception -->

	</xsl:if> <!-- show rule exceptions -->
	<!-- END SHOW RULE EXCEPTIONS -->

</xsl:template>

<xsl:template name="tIncludedBlocks">  <!-- 1.15 -->
<!-- If there is at least 1 Block or Blockrule listed 
     Or if this is the starting block - we will show all blocks then -->
<xsl:if test="descendant::Rule/@RuleType = 'Block'          or 
              descendant::Rule/@RuleType = 'Blocktype'      or 
              descendant::Rule/@RuleType = 'IncludeBlocks'  or
              @Req_id    = /Report/Audit/Block[1]/@Req_id ">
  <table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
    <tr>
      <td class="RuleLabelLine" colspan="4">
         &#160; 
         <xsl:copy-of select="$LabelIncludedBlocks" />
      </td>
    </tr>
    <xsl:choose>
    <!-- If this is the starting block - just show all blocks - except this one -->
    <xsl:when test="@Req_id = /Report/Audit/Block[1]/@Req_id" >
      <xsl:for-each select="/Report/Audit/Block">
        <xsl:if test="@Req_id != /Report/Audit/Block[1]/@Req_id" >
          <tr>
            <td class="RuleLabelData">
               &#160;                &#160;                &#160; 
              <a>
              <xsl:attribute name="href">#<xsl:value-of select="@Req_type"/>-<xsl:value-of select="@Req_value"/></xsl:attribute>
               <xsl:value-of select="@Title"/> 
              </a>
           </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
   </xsl:when>

    <xsl:otherwise>
    <xsl:for-each select=".//Rule">
      <xsl:if test="@Per_complete != 'Not Used'">
      <xsl:if test="@Per_complete != 'Not Needed'">

      <xsl:if test="@RuleType = 'Block' ">
            <!-- <xsl:value-of select="Requirement/Type"/> = <xsl:value-of select="Requirement/Value"/> -->
            <xsl:call-template name="tGetMatchingBlocks">
              <xsl:with-param name="pBlockType"  select="Requirement/Type"  />
              <xsl:with-param name="pBlockValue" select="Requirement/Value" />
            </xsl:call-template>
      </xsl:if> <!-- block, blocktype or includedblock -->
      <xsl:if test="@RuleType = 'Blocktype' ">
          <xsl:choose>
          <xsl:when test="Advice/Title">
             <xsl:for-each select="Advice/Title">
               <tr>
                 <td class="RuleLabelData">
                 &#160;         &#160;          &#160; 
                 <a>
                 <xsl:attribute name="href">#BlockTitle-<xsl:value-of select="."/></xsl:attribute>
                  <xsl:value-of select="."/> 
                 </a>
                 </td>
               </tr>
             </xsl:for-each>
          </xsl:when> <!-- advice/title -->
          <xsl:otherwise> <!-- no advice - rule is complete -->
             <xsl:call-template name="tGetMatchingBlockType">
              <xsl:with-param name="pBlockType"  select="Requirement/Type"  />
            </xsl:call-template>
          </xsl:otherwise>
          </xsl:choose>

      </xsl:if> <!-- blocktype -->
      <xsl:if test="@RuleType = 'IncludeBlocks' ">
        <xsl:for-each select="Requirement/IncludedBlock">
            <xsl:call-template name="tGetMatchingBlocks">
              <xsl:with-param name="pBlockType"  select="@Type"  />
              <xsl:with-param name="pBlockValue" select="@Value" />
            </xsl:call-template>
        </xsl:for-each>
      </xsl:if> <!-- includeblocks -->

      </xsl:if> <!-- not needed -->
      </xsl:if> <!-- not used -->
    </xsl:for-each> <!-- Rule -->

    </xsl:otherwise>
    </xsl:choose>

  </table>
</xsl:if> <!-- block, blocktype or includedblock -->
</xsl:template>

<xsl:template name="tEndOfBlock">
<!-- Accessibility Adding Block End  -->
  <table class="element-invisible" > 
    <tr> <td> Block End </td> </tr>
  </table>
</xsl:template>

<xsl:template name="tGetMatchingBlocks">  <!-- 1.15 -->
<xsl:param name="pBlockType"  />
<xsl:param name="pBlockValue" />
<xsl:for-each select="/Report/Audit/Block">
  <xsl:if test="(@Req_type = $pBlockType and @Req_value = $pBlockValue)">
    <tr>
      <td class="RuleLabelData">
         &#160;         &#160;          &#160; 
      <a>
      <xsl:attribute name="href">#<xsl:value-of select="@Req_type"/>-<xsl:value-of select="@Req_value"/></xsl:attribute>
       <xsl:value-of select="@Title"/>
      </a>
     </td>
    </tr>
  </xsl:if> 
</xsl:for-each>
</xsl:template>

<xsl:template name="tGetMatchingBlockType">  <!-- 1.15 -->
<xsl:param name="pBlockType"  />
<xsl:for-each select="/Report/Audit/Block">
  <xsl:if test="(@Req_type = $pBlockType)">
    <tr>
      <td class="RuleLabelData">
         &#160;         &#160;          &#160; 
      <a>
      <xsl:attribute name="href">#<xsl:value-of select="@Req_type"/>-<xsl:value-of select="@Req_value"/></xsl:attribute>
       <xsl:value-of select="@Title"/>
      </a>
     </td>
    </tr>
  </xsl:if> 
</xsl:for-each>
</xsl:template>

<xsl:template name="tSectionPlaceholders">
   <table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
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

<xsl:for-each select="$pSectionType">
<xsl:if test="@Classes &gt; 0 or count(Noncourse) &gt; 0 ">
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
		<tr>

			<td colspan="20">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">

			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
					&#160;
					<xsl:copy-of select="$pSectionLabel" />
				</td>
				<td align="right" width="30%">
				<!-- New table for cat-yr, gpa, credits/classes required, credits/classes applied -->
				<table border="0" cellspacing="1" cellpadding="2" width="100%" class="BlockHeader">
					<tr>
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
							(<xsl:value-of select="@Discipline"/>		   <!-- left paren + Discipline -->
							<xsl:text>&#160;</xsl:text>					   <!-- space --> 
							<xsl:value-of select="@Number"/>)			   <!-- Number + right paren -->
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
   <tr> <!-- invisible headers for screen readers -->
     <th class="th-invisible">Course</th>
     <th class="th-invisible">Course Title</th>
     <th class="th-invisible">Grade</th>
     <th class="th-invisible"><xsl:value-of select="/Report/@rptCreditsLiteral"/></th>
     <th class="th-invisible">Term</th>
   </tr>
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
			<td class="ClassesAppliedClasses"  >
				<!-- Accessibility Adding tag to blue color classes  -->
				<xsl:if test="@Letter_grade = 'PLAN'"> 
					<div class="element-invisible" >
						Transfer Class
					</div>
				</xsl:if>
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
              <xsl:call-template name="tCourseSignalsGrade"/>
			</td>
			<td class="SectionCourseCredits">
		      <xsl:call-template name="CheckInProgressAndPolicy5"/>
			</td>
			<td class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
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
				<xsl:text>-</xsl:text> <!-- hyphen --> 
				<xsl:value-of select="key('ClsKey',@Id_num)/@Transfer_school"/>
        </xsl:if>
			</td>
		</tr>
		</xsl:if>
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
	<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
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
							(<xsl:value-of select="@Discipline"/>		   <!-- left paren + Discipline -->
							<xsl:text>&#160;</xsl:text>					   <!-- space --> 
							<xsl:value-of select="@Number"/>)			   <!-- Number + right paren -->
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
   <tr> <!-- invisible headers for screen readers -->
     <th class="th-invisible">Course</th>
     <th class="th-invisible">Course Title</th>
     <th class="th-invisible">Grade</th>
     <th class="th-invisible"><xsl:value-of select="/Report/@rptCreditsLiteral"/></th>
     <th class="th-invisible">Term</th>
   </tr>  
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
			<td class="ClassesAppliedClasses"  >
				<!-- Accessibility Adding tag to blue color classes  -->
				<xsl:if test="@Letter_grade = 'PLAN'"> 
					<div class="element-invisible" >
						Transfer Class
					</div>
				</xsl:if>
				<xsl:value-of select="@Discipline"/>
				<xsl:text>&#160;</xsl:text> <!-- space --> 
				<xsl:value-of select="@Number"/>    
			</td>
			<!-- TITLE -->
			<td width="50%" class="SectionCourseTitle">
			<!-- Use the Id_num attribute on this node to lookup the Class info
			  on the Clsinfo/Cass node and get the Title -->     
			<xsl:value-of select="key('ClsKey',@Id_num)[@In_progress='Y']/@Course_title"/>
			</td>
			<!-- GRADE -->
			<td class="SectionCourseGrade">
              <xsl:call-template name="tCourseSignalsGrade"/>
			</td>
			<!-- CREDITS -->
			<td class="SectionCourseCredits">
				<xsl:call-template name="tFormatNumber" >
								<xsl:with-param name="iNumber" select="@Credits" />
								<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
								</xsl:call-template>
			</td>
			<!-- TERM -->
			<td class="SectionCourseTerm"> <!-- Perform a lookup on the Clsinfo/Class to get the term -->
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
				<xsl:text>-</xsl:text> <!-- hyphen --> 
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

<!-- Qualifier advice on a course rule or subset -->
<xsl:template name="tQualAdvice">
						<xsl:for-each select="QualAdvice/Qual"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:choose>
                            <xsl:when test="@Classes or @Credits"> 
  							  <u>additionally you need a minimum of</u>
                            </xsl:when>
                            <xsl:otherwise> 
  							  <xsl:value-of select="@Text"/>
                            </xsl:otherwise>
							</xsl:choose>
							<xsl:text>&#160;</xsl:text> <!-- space --> 
                            <xsl:if test="@Credits"> 
 							    <xsl:call-template name="tFormatNumber" >
								  <xsl:with-param name="iNumber" select="@Needed" />
								  <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
								</xsl:call-template>
                                <xsl:text>&#160;</xsl:text> <!-- space --> 
                                <xsl:call-template name="tCreditsLiteral"/> from 
                            </xsl:if> 
                            <xsl:if test="@Classes"> 
                              <xsl:value-of select="@Needed"/> Classes from
                            </xsl:if> 
							<xsl:for-each select="Course">	<!-- FOR EACH EXCEPT COURSE -->
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
	    <xsl:if test="/Report/Audit/Clsinfo/Class[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='RED']">
			<table border="0" cellspacing="0" cellpadding="0" width="80%" class="bgLight0" align="center">
		    <tr>
			  <td rowspan="20" colspan="20" align="center">
				   <img src="common/coursesignals-red.png" ondragstart="window.event.returnValue=false;" title="You should seek help"/>
			  </td>
		    </tr>
			<tr >
				<td class="bgLight0" colspan="1" rowspan="2" valign="middle" xxnowrap="false" align="center">
					&#160;You are having trouble with your classes this semester. 
					We encourage you to make use of the services on campus to help you succeed.
					&#160;Please review the many ways we can help you by visiting 
					<a title="Get help" target="newCourseSignalsWindow">
                    <xsl:attribute name="href"><xsl:copy-of select="$CourseSignalsHelpUrl"/></xsl:attribute>
                    <xsl:copy-of select="$CourseSignalsHelpUrl"/>
					</a>
				</td>
				<!-- <td align="right" width="10%">				</td> -->
			</tr>
	      </table>
	   </xsl:if> <!-- help link -->
</xsl:template>

<xsl:template name="tSectionExceptions">
<table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
	<tr>
		<td colspan="20">
		<table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
			<tr >
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
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
	<!--TODO:<td class="ExceptionHeader">Block      </td>  -->
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
    <!--TODO
		<td class="AuditExceptionData">
			<xsl:value-of select="@Req_id"/>
		</td>
    -->
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
				<td class="BlockHeader" colspan="1" rowspan="2" valign="middle">
					&#160;Notes
				</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr>
			<td class="AuditNotesHeader"><b> </b></td>  
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

<!-- tLegend template is in this included xsl; shared by athletic and academic audits -->
<xsl:include href="AuditLegend.xsl" />

<!-- FormatDate template is in this included xsl -->
<xsl:include href="FormatDate.xsl" />

<!-- Templates for general functionality -->
<xsl:include href="CommonTemplates.xsl" />

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

<xsl:template name="tShowException">
			  <tr class="ExceptionLabel">
					<td class="RuleExceptionTitle" >
					<table cellspacing="0" cellpadding="0">
						  <tr>
								<td class="RuleExceptionByTitle">
					  <a> <!-- 1.18 -->
						<xsl:attribute name="name">Exception-<xsl:value-of select="key('XptKey',@Id_num)/@Req_id"/>-<xsl:value-of select="key('XptKey',@Id_num)/@Node_id"/></xsl:attribute>
					  </a> 
									  Exception By:
								</td>
								<td class="RuleExceptionByData">
									  <xsl:value-of select="key('XptKey',@Id_num)/@Who"/>
								</td>
							</tr>
							<tr>
								<td class="RuleExceptionOnTitle">
									  On:
								</td>
								<td class="RuleExceptionOnData">
									  <xsl:call-template name="FormatRuleXptDate"/>
								</td>
						  </tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="RuleExceptionTitle" >
					<table cellspacing="0" cellpadding="0">
						  <tr>
								<td class="RuleExceptionTextData">
									  <xsl:call-template name="tExceptionType"/>:
									  <xsl:text>&#160;</xsl:text> <!-- space --> 
									  <!-- Description: -->
									  <!-- Use the Id_num attribute on this node to lookup the Exception info
									  on the ExceptionList/Exception node and get the Label -->     
                     <!-- Show the Details as a hint on the label - but only for non-students -->
                     <xsl:choose> 
                     <xsl:when test="/Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id and 
                                     normalize-space(key('XptKey',@Id_num)/@Details) != '' "> 
                     <a> 
                      <xsl:attribute name="title"><xsl:value-of select="key('XptKey',@Id_num)/@Details"/></xsl:attribute>
                      <xsl:value-of select="key('XptKey',@Id_num)/@Label"/>
                     </a>  
                     </xsl:when> 
                     <xsl:otherwise> <!-- don't show a link -->
                      <xsl:value-of select="key('XptKey',@Id_num)/@Label"/>
                     </xsl:otherwise> 
                     </xsl:choose>
								</td>
						  </tr>
					</table>
					</td>
			  </tr>
</xsl:template>

<!-- If there is a subset ancestor and we are not showing the subset label
     then we need to reduce the indentation for each of the rules within the subset 1.15-->
<xsl:template name="tIndentLevel">
  <xsl:choose>
    <xsl:when test="ancestor::Rule[*]/@RuleType = 'Subset' and /Report/@rptHideSubsetLabels='Y'">
      <xsl:call-template name="tIndentLevel_aux" >
       <xsl:with-param name="pIndentLevel" select="@IndentLevel - 1" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="tIndentLevel_aux" >
       <xsl:with-param name="pIndentLevel" select="@IndentLevel" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tIndentLevel_aux">
<xsl:param name="pIndentLevel" />
 <!-- INDENT: invis1 has width=0 so nothing is indented really -->
  <xsl:choose>
    <xsl:when test="$pIndentLevel = 1">  
    <img src="Images_DG2/dwinvis1.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 2">  
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 3">  
    <img src="Images_DG2/dwinvis3.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 4">  
    <img src="Images_DG2/dwinvis4.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 5">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 6">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 7">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 8">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 9">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 10">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 11">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 12">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 13">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 14">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis2.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>
    <xsl:when test="$pIndentLevel = 15">  
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
    </xsl:when>

    <xsl:otherwise>
    <img src="Images_DG2/dwinvis5.gif" ondragstart="window.event.returnValue=false;"/>
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

<xsl:template name="tShowNoncourse"> 
   <tr class="CourseAppliedRowWhite">
      <!-- Show planned/look-ahead noncourses in another color -->
      <xsl:if test="substring(@Id_num,1,2) = 'PN'"> 
          <xsl:attribute name="style">color:#0000FF</xsl:attribute>
      </xsl:if>
      
      <td class="CourseAppliedDataDiscNum" >
        <xsl:value-of select="key('NonKey',@Id_num)/@Title"/>
      </td>
      <td class="CourseAppliedDataGrade" >
        <xsl:value-of select="@Value"/>
      </td>
      <td class="CourseAppliedDataTerm" colspan="6" >
        <xsl:value-of select="key('NonKey',@Id_num)/@TermLit"/>
      </td>
   </tr>
</xsl:template>

</xsl:stylesheet>
