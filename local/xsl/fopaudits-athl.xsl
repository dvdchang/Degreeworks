<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fopaudits-athl.xsl#11 $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- The xml tree structure looks like this:
<DegreeWorksAudits>
    <Report xxxx  />
    <Audit xxxx />
    <Audit xxxx />
    <Audit xxxx />
</DegreeWorksAudits>

These images must exist in the ../images directory:
dwcheck98.gif
dwcheck99.gif
dwcheckno.gif
dwcheckyes.gif 
dwinvis1.gif
dwinvis2.gif
dwinvis3.gif
dwinvis4.gif
dwinvis5.gif
coursesignals-yellow.png
coursesignals-red.png
coursesignals-green.png

Note: We need to do this for ClsKey, ClsCrdReq, BlockKey and XptKey - I have
       done this below for ClsKey but it needs to be done for all keys.
<xsl:key name="ClsKey"    match="Audit/Clsinfo/Class" use="concat(generate-id(ancestor::Audit),'-', @Id_num)"/>
Here we generate and id for the node in question (the Audit node) and concatenate a hyphen and the
class id number. When we call it we do the same thing. The magic is that both use "ancestor:Audit" and 
thus match and we get the correct Audit tree. The code created is like this: "AA000123-0019". For each student/audit 
this will be a unique key to find the right Clsinfo/Class node when we have multiple Audit trees to process.
We do the same for the XptKey, ClsCrdReq and BlockKey.
-->

<xsl:variable name="LabelProgressBar">      Athletic Eligibility - Progress Towards Degree</xsl:variable>
<xsl:variable name="LabelStillNeeded">		Still Needed:	</xsl:variable>
<xsl:variable name="LabelAlertsReminders">  Alerts and Reminders </xsl:variable>
<xsl:variable name="LabelFallthrough">      Electives </xsl:variable>
<xsl:variable name="LabelInprogress">       In-progress </xsl:variable>
<xsl:variable name="LabelOTL">              Not Counted </xsl:variable>
<xsl:variable name="LabelInsufficient">     Insufficient </xsl:variable>
<xsl:variable name="vCreditDecimals">0.###</xsl:variable>
<xsl:variable name="vGPADecimals">0.000</xsl:variable>
<xsl:variable name="vProgressBarPercent">N</xsl:variable>
<xsl:variable name="vProgressBarCredits">Y</xsl:variable>
<xsl:variable name="vShowCourseSignals">Y</xsl:variable>
<xsl:variable name="CourseSignalsHelpUrl">http://helpme.myschool.edu</xsl:variable>
<xsl:variable name="vShowToInsteadOfColon">Y</xsl:variable> <!-- ":" is replaced with " to " in classes/credits range -->

<xsl:variable name="vShowFootballStatus">Y</xsl:variable>

<xsl:key name="XptKey"    match="Audit/ExceptionList/Exception" use="concat(generate-id(ancestor::Audit),'-', @Id_num)"/>
<xsl:key name="ClsKey"    match="Audit/Clsinfo/Class"           use="concat(generate-id(ancestor::Audit),'-', @Id_num)"/>
<xsl:key name="NonKey"    match="Audit/Clsinfo/Noncourse"       use="concat(generate-id(ancestor::Audit),'-', @Id_num)"/>
<xsl:key name="ClsCrdReq" match="Header/Qualifier"              use="concat(generate-id(ancestor::Audit),'-', @Node_type)"/>
<xsl:key name="BlockKey"  match="Audit/Block"                   use="concat(generate-id(ancestor::Audit),'-', @Req_id)"/>
<xsl:key name="HeadQualKey" match="Header/Qualifier"            use="concat(generate-id(ancestor::Audit),'-', @Node_id)"/>

<xsl:template match="/">

	<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

		<fo:layout-master-set>
			<fo:simple-page-master master-name="simple"
					page-height="27.9cm" 
					page-width="21cm"
					margin-top="1cm" 
					margin-bottom="1cm" 
					margin-left="1cm" 
					margin-right="1cm">
				<fo:region-body margin="0cm" margin-top="1.6cm" />
				<fo:region-before extent="1.6cm"/>
				<fo:region-after extent="1cm"/>
				<fo:region-start extent="0cm"/>
				<fo:region-end extent="0cm"/>
			</fo:simple-page-master>
		</fo:layout-master-set>

	<xsl:for-each select="Report/Audit">
		<fo:page-sequence master-reference="simple">
		<fo:static-content flow-name="xsl-region-before">
			<fo:block>
				<xsl:call-template name="tPageHeader"/>
			</fo:block>
		</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<xsl:call-template name="tSchoolHeader"/>
				<fo:block font-family="sans-serif">
				
					<xsl:call-template name="tStudentHeader"/>
          <xsl:call-template name="tAthleteFactoids"/>
          <xsl:call-template name="tProgressBar"/>
          <xsl:call-template name="tCourseSignalsHelp" />
					<xsl:call-template name="tStudentAlerts"/>
					<xsl:call-template name="tBlocksAthleteOnly"/>
          <xsl:if test="contains(/Report/@rptReportCode,'56')"> <!-- WEB56 and RPT56 -->
					  <xsl:call-template name="tBlocksAcademicOnly"/>
          </xsl:if>
					<xsl:call-template name="tSections" />
					<xsl:call-template name="tLegend"/>
					<xsl:call-template name="tDisclaimer"/>

				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:for-each>

	</fo:root> 
</xsl:template>

<xsl:include href="fop-tPageHeader.xsl" />
<xsl:include href="fop-tSchoolHeader.xsl" />
<xsl:include href="fop-tStudentHeader.xsl" />
<xsl:include href="fop-tCourseSignals.xsl" />
<xsl:include href="fop-tProgressBar.xsl" />
<xsl:include href="fop-tStudentAlerts.xsl" />
<xsl:include href="fop-tBlocks.xsl" />
<xsl:include href="fop-tSections.xsl" />
<xsl:include href="fop-tLegend.xsl" />
<xsl:include href="fop-tDisclaimer.xsl" />
<xsl:include href="fop-tOtherCommonTemplates.xsl" />

<xsl:include href="fop-tAthleteFactoids.xsl" />

</xsl:stylesheet>
 

