<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->

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
dwcheck98.jpg
dwcheck99.jpg
dwcheckno.jpg
dwcheckyes.jpg
dwinvis1.jpg
dwinvis2.jpg
dwinvis3.jpg
dwinvis4.jpg
dwinvis5.jpg

Brett: We need to do this for ClsKey, ClsCrdReq, BlockKey and XptKey - I have
       done this below for ClsKey but it needs to be done for all keys.
<xsl:key name="ClsKey"    match="Audit/Clsinfo/Class" use="concat(generate-id(ancestor::Audit),'-', @Id_num)"/>
Here we generate and id for the node in question (the Audit node) and concatenate a hyphen and the
class id number. When we call it we do the same thing. The magic is that both use "ancestor:Audit" and 
thus match and we get the correct Audit tree. The code created is like this: "AA000123-0019". For each student/audit 
this will be a unique key to find the right Clsinfo/Class node when we have multiple Audit trees to process.
We do the same for the XptKey, ClsCrdReq and BlockKey.

-->

<xsl:variable name="LabelProgressBar">		Degree Progress </xsl:variable>
<xsl:variable name="LabelStillNeeded">		Still Needed:	</xsl:variable>
<xsl:variable name="LabelAlertsReminders">  Alerts and Reminders </xsl:variable>
<xsl:variable name="LabelFallthrough">      Fallthrough Courses </xsl:variable>
<xsl:variable name="LabelInprogress">       In-progress </xsl:variable>
<xsl:variable name="LabelOTL">              Not Counted </xsl:variable>
<xsl:variable name="LabelInsufficient">     Insufficient </xsl:variable>
<xsl:variable name="vCreditDecimals">0.###</xsl:variable>
<xsl:variable name="vGPADecimals">0.000</xsl:variable>
<xsl:variable name="vShowCourseSignals">Y</xsl:variable>
<xsl:variable name="CourseSignalsHelpUrl">http://helpme.myschool.edu</xsl:variable>
<xsl:variable name="vShowToInsteadOfColon">Y</xsl:variable> <!-- ":" is replaced with " to " in classes/credits range -->

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
					margin-bottom="3cm" 
					margin-left="1cm" 
					margin-right="1cm">
				<fo:region-body margin="0cm" margin-top="10mm" />
				<fo:region-before extent="2cm"/>
				<fo:region-after extent="2cm"/>
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
					<xsl:call-template name="tStudentAlerts"/>
					<xsl:call-template name="tBlocks"/>
					<xsl:call-template name="tSections" />
					<xsl:call-template name="tLegend"/>
					<xsl:call-template name="tDisclaimer"/>

				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:for-each>

	</fo:root> 
</xsl:template>



<xsl:template name="tSections">       
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

	<!--//////////////////////////////////////////////////// 
		// Exceptions -->
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


</xsl:template>

<xsl:template name="tPageHeader">       

<!--
A:  Ellucian Degree Works Report
B:  Degree Works: Detailed Advice 
C:  Your University: Detailed Advice audit
D:  Detailed Advice audit for Jones, George
E:  Detailed Advice audit for Jones, George - 285773
F:  Generic University: Detailed advice Audit for Jones, George
G:  Generic University: Detailed advice Audit for Jones, George - 285773
If blank or none of the above, the default is E.

-->
<fo:block font-size="8pt" 
		color="#000000">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#FFFFFF" 
			border-spacing="1pt" font-size="8pt">
		<fo:table-column column-width="17cm"/>
		<fo:table-column column-width="2cm"/>

		<fo:table-body>
			<fo:table-row>
				<fo:table-cell>
				<fo:block text-align="justify" >

				<xsl:choose>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'A'">  
						<xsl:call-template name="tPageHeader_A"/>
					</xsl:when>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'B'">  
						<xsl:call-template name="tPageHeader_B"/>
					</xsl:when>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'C'">  
						<xsl:call-template name="tPageHeader_C"/>
					</xsl:when>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'D'">  
						<xsl:call-template name="tPageHeader_D"/>
					</xsl:when>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'E'">  
						<xsl:call-template name="tPageHeader_E"/>
					</xsl:when>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'F'">  
						<xsl:call-template name="tPageHeader_F"/>
					</xsl:when>
					<xsl:when test="/Report/@rptCFG020AuditTitleStyle = 'G'">  
						<xsl:call-template name="tPageHeader_G"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="tPageHeader_D"/>
					</xsl:otherwise>
				</xsl:choose>

				</fo:block>
				</fo:table-cell>
				<fo:table-cell>
				<fo:block text-align="right" >
				<!-- Page numbering removed because it is total pages not page per audit
					(Page <fo:page-number />)
				-->
				</fo:block>
				</fo:table-cell>
			</fo:table-row>

		</fo:table-body>
	</fo:table>

</fo:block> 

</xsl:template>

<xsl:template name="tPageHeader_A">       
	Ellucian Degree Works Report
</xsl:template>

<xsl:template name="tPageHeader_B">       
	Degree Works: 	<xsl:value-of select="/Report/@rptReportName"/> 
</xsl:template>

<xsl:template name="tPageHeader_C">       
	<xsl:value-of select="/Report/@rptInstitutionName"/>: <xsl:value-of select="/Report/@rptReportName"/> 
</xsl:template>

<xsl:template name="tPageHeader_D">       
	<xsl:value-of select="/Report/@rptReportName"/> 
	for 
	<xsl:value-of select="AuditHeader/@Stu_name"/>
</xsl:template>

<xsl:template name="tPageHeader_E">       
	<xsl:value-of select="/Report/@rptReportName"/> 
	for 
	<xsl:value-of select="AuditHeader/@Stu_name"/>
	-
	<xsl:call-template name="tStudentID" />
</xsl:template>

<xsl:template name="tPageHeader_F">       
	<xsl:value-of select="/Report/@rptInstitutionName"/>: <xsl:value-of select="/Report/@rptReportName"/> 
	for 
	<xsl:value-of select="AuditHeader/@Stu_name"/>
</xsl:template>

<xsl:template name="tPageHeader_G">       
	<xsl:value-of select="/Report/@rptInstitutionName"/>: <xsl:value-of select="/Report/@rptReportName"/> 
	for 
	<xsl:value-of select="AuditHeader/@Stu_name"/>
	-
	<xsl:call-template name="tStudentID" />
</xsl:template>

<xsl:template name="tSchoolHeader">       
	<fo:block font-size="14pt" 
			font-family="sans-serif" 
			font-weight="bold" 
			line-height="20pt"
			space-after.optimum="15pt"
			background-color="#FFFFFF"
			color="#003659"
			text-align="center">
		<xsl:value-of select="/Report/@rptInstitutionName"/>
	</fo:block> 
</xsl:template> <!-- end templateSchoolHeader -->
 
<xsl:template name="tStudentHeader">

<fo:table table-layout="fixed" width="19cm" 
		background-color="#F8F8F8" 
		border-spacing="1pt" font-size="8pt">
	<fo:table-column column-width="2.5cm"/>
	<fo:table-column column-width="7.0cm"/>
	<fo:table-column column-width="2.5cm"/>
	<fo:table-column column-width="7.0cm"/>

	<fo:table-body>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="4">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Report Name Audit ID as of Date Time -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" number-columns-spanned="3">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:value-of select="/Report/@rptReportName"/>&#160;&#160;&#160;
					</fo:inline>
					<fo:inline font-size="9pt" font-weight="normal" >
						<xsl:value-of select="AuditHeader/@Audit_id"/> as of 
                        <xsl:call-template name="FormatDate">
	                   	   <xsl:with-param name="pDate" select="concat(AuditHeader/@DateYear,AuditHeader/@DateMonth,AuditHeader/@DateDay)" />
                        </xsl:call-template>
						at 
						<xsl:value-of select="AuditHeader/@TimeHour"/>:<xsl:value-of select="AuditHeader/@TimeMinute"/>
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell display-align="center" text-align="right" >
				<fo:block font-size="8pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
				  <xsl:value-of select="AuditHeader/@AuditDescription"/>
                  &#160;
                  <xsl:if test="AuditHeader/@FreezeTypeDescription != '' ">
				    (<xsl:value-of select="AuditHeader/@FreezeTypeDescription"/>)
                  </xsl:if>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" > <!-- Row 1: Student Name, School -->
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Student
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
					<xsl:value-of select="AuditHeader/@Stu_name"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				School
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
					<xsl:value-of select="Deginfo/DegreeData/@SchoolLit"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" > <!-- Row 2: Student ID, College -->
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				ID
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
					<xsl:call-template name="tStudentID" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Degree
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
				<xsl:value-of select="Deginfo/DegreeData/@DegreeLit"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" > <!-- Row 3: Advisor 1, Degree -->
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Level
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
				<xsl:value-of select="Deginfo/DegreeData/@Stu_levelLit"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				College<xsl:if test="count(Deginfo/Goal[@Code='COLLEGE'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
				<xsl:for-each select="Deginfo/Goal[@Code='COLLEGE']">
					<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>	
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" > <!-- Row 4: Advisor 2, Major -->
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Advisor<xsl:if test="count(Deginfo/Goal[@Code='ADVISOR'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
			    <xsl:for-each select="Deginfo/Goal[@Code='ADVISOR']">
					<xsl:value-of select="@Advisor_name"/><xsl:if test="position()!=last()">; </xsl:if>
				</xsl:for-each>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Major<xsl:if test="count(Deginfo/Goal[@Code='MAJOR'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
				<xsl:for-each select="Deginfo/Goal[@Code='MAJOR']">
					<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" > <!-- Row 5: Overall GPA, Student Level -->
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Overall GPA
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
				<xsl:value-of select="@SSGPA"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify" font-weight="bold" color="#003659"  >
				Minor<xsl:if test="count(Deginfo/Goal[@Code='MINOR'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="justify">
				<xsl:for-each select="Deginfo/Goal[@Code='MINOR']">
					<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

</fo:table-body>
</fo:table>

<!-- // Progress Bar // -->
<xsl:if test="/Report/@rptShowProgressBar='Y'">
<xsl:call-template name="tProgressBar"/>
</xsl:if>

<xsl:if test="$vShowCourseSignals='Y'">
  <xsl:call-template name="tCourseSignalsHelp" />
</xsl:if>

</xsl:template> <!-- end templateStudentHeader -->
 
<xsl:template name="tBlocks">

	<xsl:for-each select="Block">

		<fo:table table-layout="fixed" width="19cm" 
				background-color="#F8F8F8" 
				border-spacing="1pt" font-size="8pt">
			<fo:table-column column-width="2.5cm"/>
			<fo:table-column column-width="5.5cm"/>
			<fo:table-column column-width="2.5cm"/>
			<fo:table-column column-width="8.5cm"/>

			<fo:table-body>

			<fo:table-row > <!-- Row for making the block header look nice (no content) -->
				<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="4"  display-align="center">
					<fo:block font-size="12pt" keep-with-next.within-page="always">
					</fo:block>
				</fo:table-cell>
			</fo:table-row>

			<xsl:call-template name="tBlockHeaderChoose"/>

			<fo:table-row > <!-- Row for making the block header look nice (no content) -->
				<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
					<fo:block font-size="12pt" >
					</fo:block>
				</fo:table-cell>
			</fo:table-row>

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

		          <xsl:choose>
                  <xsl:when test="/Report/@rptShowRuleText='N' and
		                          ancestor::Rule[*]/@RuleType  = 'Group' and 
                                  ancestor::Rule[*]/@Per_complete = '100' and @Per_complete!='100'">
                    <!-- do not show the labels for the rules within the group that is already completed -->
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
		          <xsl:when test="Advice/BlockID/. = 'NOT_FOUND'"> 
  		            <xsl:call-template name="tRules"/>
		          </xsl:when>
                  
		          <xsl:when test="Requirement/Qualifier/@Node_type = 'HideRule' or Requirement/Qualifier/@Name = 'HIDERULE'">
		            <xsl:choose>
		          	<xsl:when test="@RuleType = 'Block' or @RuleType = 'Blocktype'">
		          		<!-- hide the block or blocktype rule - regardless of it being 0% or 50% complete -->
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
			</xsl:for-each> 

			</fo:table-body>
		</fo:table>

	</xsl:for-each>

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
	<fo:table-row > <!-- Block checkbox, Title -->
		<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0pt" number-columns-spanned="4"  display-align="center">
			<fo:block font-size="9pt" 
					font-family="sans-serif" 
					line-height="12pt"
					background-color="#B3B3B3"
					color="#000000"
					text-align="justify"
					padding-top="0pt"
					padding-bottom="0pt"
					padding-left="2pt" keep-with-next.within-page="always">


			<!-- TODO Create a table for the block header information -->
			<fo:table table-layout="fixed" width="18cm" 
					background-color="#B3B3B3" 
					border-spacing="0pt" font-size="8pt">
			<fo:table-column column-width="11.5cm"/>
			<fo:table-column column-width="6.5cm"/>

			<fo:table-body>
				<fo:table-row>
					<fo:table-cell display-align="center">
					<fo:block font-weight="bold" keep-with-next.within-page="always">
						<xsl:choose>
							<xsl:when test="@Per_complete = 100">  
								<fo:external-graphic src="../images/dwcheckyes.jpg" />
							</xsl:when>
							<xsl:when test="@Per_complete = 99">  
								<fo:external-graphic src="../images/dwcheck99.jpg" />
							</xsl:when>
							<xsl:when test="@Per_complete = 98">  
								<fo:external-graphic src="../images/dwcheck98.jpg" />
							</xsl:when>
							<xsl:otherwise>
								<fo:external-graphic src="../images/dwcheckno.jpg" />
							</xsl:otherwise>
						</xsl:choose>
						&#160;
						<xsl:value-of select="@Title"/>
					</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="right" display-align="center">
					<fo:block keep-with-next.within-page="always">


					<fo:table table-layout="fixed" width="6.5cm" 
							background-color="#B3B3B3" padding-top="0pt" padding-bottom="0pt" padding-left="0pt" padding-right="0pt"
							border-spacing="0pt" font-size="6pt">
					<fo:table-column column-width="1.5cm"/>
					<fo:table-column column-width="1.5cm"/>
					<fo:table-column column-width="3cm"/>
					<fo:table-column column-width="0.9cm"/>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								Catalog Year: 
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								<xsl:value-of select="@Cat_yrLit"/> 
							</fo:block>
							</fo:table-cell>
								<xsl:call-template name="tCheckCreditsClasses-Required"/>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								GPA:
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								<xsl:value-of select="@GPA"/> 
							</fo:block>
							</fo:table-cell>
							<xsl:call-template name="tCheckCreditsClasses-Applied"/>
						</fo:table-row>
					</fo:table-body>
					</fo:table>
					
					
					</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
			</fo:table>


			</fo:block> 
		</fo:table-cell>
	</fo:table-row>
</xsl:template>

<!-- For each block header qualifer that has a label - show a checkbox and label and advice -->
<xsl:template name="tHeaderQualifierLabels">
<xsl:for-each select="Header/Qualifier">
	 <fo:table-row border-bottom-width="medium" border-bottom-color="#ffffff" border-bottom-style="solid">
             <xsl:attribute name="background-color">
					 <xsl:value-of select="'#FFFFFF'"/> <!-- white -->
			 </xsl:attribute>
		 <fo:table-cell number-columns-spanned="4">
		  <fo:block>
		   <fo:table table-layout="fixed" width="19cm" space-before="0.3cm" border-spacing="0pt" font-size="8pt">
			<fo:table-column column-width="2.3cm"/>
			<fo:table-column column-width="5.7cm"/>
			<fo:table-column column-width="2.5cm"/>
			<fo:table-column column-width="8.5cm"/>

			<fo:table-body>
			  <fo:table-row>

		     <!-- CHECKBOX + LABEL -->
				<!-- CHECKBOX -->
				<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt"
									 display-align="center" >
				 <fo:block font-size="8pt"
									 font-family="sans-serif"
									 color="#316C92"
									 line-height="15pt"
									 space-after.optimum="3pt"
									 text-align="left"  >
                     <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwinvis1.gif"/> <!-- indent one level -->
					 <xsl:choose>
				            <xsl:when test="@Satisfied='Yes'">  
							 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckyes.gif " />
						 </xsl:when>
						 <xsl:otherwise>
							 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
						 </xsl:otherwise>
					 </xsl:choose>
				 </fo:block>
				</fo:table-cell>
				<!-- END CHECKBOX -->

				<!-- LABEL -->
				<fo:table-cell display-align="center">
				 <fo:block>
					 <xsl:choose> <!-- use choose to allow us to change the look later -->
						<xsl:when test="@Satisfied='Yes'">  
						     <xsl:value-of select="@Label"/>
						 </xsl:when>
						 <xsl:otherwise>
							 <xsl:value-of select="@Label"/>
						 </xsl:otherwise>
					 </xsl:choose>
				 </fo:block>
				</fo:table-cell>
		        <!-- END LABEL -->

		    <!-- ADVICE -->
            <!-- table for "Reason" and advice text -->
			<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="2"  display-align="center">
			 <fo:block font-size="8pt"
								 font-family="sans-serif"
								 line-height="15pt"
								 space-after.optimum="3pt"
								 text-align="justify" >
		         <fo:table table-layout="fixed" width="11cm" border-spacing="0pt" font-size="8pt">
		         <fo:table-column column-width="2cm"/>   <!-- "Reason" label -->
		         <fo:table-column column-width="8.5cm"/> <!-- Advice text      -->
                 
		         <fo:table-body>
		         	<fo:table-row >
		         		<fo:table-cell >
		         		<fo:block color="#CC0000">
		         			Reason:
		         		</fo:block >
		         		</fo:table-cell >
		         		<fo:table-cell padding-right="0.4cm">
		         		<fo:block >
                          <!-- Show the advice-text for this qualifier -->
				          <xsl:variable name="thisNode_id" select="@Node_id"/>
					      <xsl:for-each select="../Advice/Text">
					      	<xsl:if test="$thisNode_id=@Node_id">
					      		<xsl:value-of select="." />
					      	</xsl:if>
					      </xsl:for-each>
		         		</fo:block >
		         		</fo:table-cell >
		         	</fo:table-row >
		         </fo:table-body>
		         </fo:table>
                 
		  	 </fo:block>
		   	</fo:table-cell>
		    <!-- END ADVICE -->

		     </fo:table-row>
		    </fo:table-body>
		    </fo:table>
		   </fo:block>
		 </fo:table-cell>


     </fo:table-row>

</xsl:for-each>
</xsl:template> 

<xsl:template name="tHeaderQualifierAdvice"> 
    <fo:table-row >
      <fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify">

		<fo:table table-layout="fixed" width="19cm" 
				background-color="#FFFFFF" 
				border-spacing="1pt" font-size="8pt">
			<fo:table-column column-width="9.5cm"/>
			<fo:table-column column-width="9.5cm"/>

			<fo:table-body>

				<xsl:for-each select="Header/Advice/Text">	<!-- FOR EACH HEADER QUALIFIER -->
				<fo:table-row > 
        <xsl:choose>
         <xsl:when test="key('HeadQualKey',concat(generate-id(ancestor::Audit),'-',@Node_id))/@Label" >
         <!-- do not show this qualifier's advice; the advice will be shown in tHeaderQualifierLabels -->
        </xsl:when>
        <xsl:otherwise>
				<!-- Put message on the left side with the actual qualifier advice on the right -->
					<xsl:if test="position()=1">
						<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center"
						               number-rows-spanned="1">
							<fo:block font-size="8pt" font-weight="bold">
							Unmet conditions for this set of requirements:
							</fo:block>
						</fo:table-cell>
					</xsl:if>  
						<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
							<fo:block font-size="8pt" >
							<xsl:value-of select="."/> <!-- get Text data -->
							</fo:block>
						</fo:table-cell>
				</fo:table-row>
        </xsl:otherwise>
        </xsl:choose>
				</xsl:for-each>	<!-- END FOR EACH HEADER QUALIFIER -->
			</fo:table-body>
			</fo:table>
		</fo:block>
      </fo:table-cell>

	</fo:table-row>
</xsl:template> 

<xsl:template name="tBlockRemarks"> 
    <fo:table-row >
      <fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify">


			<xsl:if test="Header/Remark"> 
							<xsl:for-each select="Header/Remark/Text">	<!-- FOR EACH HEADER REMARK TEXT -->
								<xsl:value-of select="."/>&#160;
							</xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
			</xsl:if>

			<xsl:if test="Header/Display/Text"> 
							<xsl:for-each select="Header/Display/Text">	<!-- FOR EACH DISPLAY TEXT -->
								<xsl:value-of select="."/>&#160;
							</xsl:for-each>	<!-- FOR EACH DISPLAY TEXT -->
			</xsl:if>

	</fo:block>
	</fo:table-cell>
	</fo:table-row>
</xsl:template> 

<xsl:template name="tBlockQualifiers"> 
    <fo:table-row >
      <fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify">

		<fo:table table-layout="fixed" width="19cm" 
				background-color="#FFFFFF" 
				border-spacing="1pt" font-size="8pt">
			<fo:table-column column-width="8cm"/>
			<fo:table-column column-width="11cm"/>

			<fo:table-body>

			<xsl:for-each select="Header/Qualifier">	<!-- FOR EACH HEADER QUALIFIER -->
				<fo:table-row > 
				<!-- Put message on the left side with the actual qualifier advice on the right -->
					<xsl:if test="position()=1">
						<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center"
						               number-rows-spanned="1">
							<fo:block font-size="8pt" font-weight="bold" text-align="right">
							Block Qualifiers: &#160;&#160;
							</fo:block>
						</fo:table-cell>
					</xsl:if>  
						<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
							<fo:block font-size="8pt" >
							<xsl:value-of select="Text"/>
							<xsl:for-each select="SubText">	
								<xsl:value-of select="."/>
							</xsl:for-each>	<!-- for each subtext -->
							</fo:block>
						</fo:table-cell>
				</fo:table-row>
			</xsl:for-each>	<!-- FOR EACH HEADER QUALIFIER -->
			</fo:table-body>
			</fo:table>
		</fo:block>
      </fo:table-cell>

	</fo:table-row>
</xsl:template> 


 <xsl:template name="tRules">
    <fo:table-row >
      <fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="2"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#003659" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify"
				 >
		<xsl:call-template name="tIndentLevel"/>
        <xsl:choose>
        <xsl:when test="ancestor::Rule[1]/@RuleType  = 'Group' and 
                                          @RuleType != 'Group' and 
                          /Report/@rptHideInnerGroupLabels='Y'">
		<fo:table table-layout="fixed" width="19cm" space-before="0.3cm" border-spacing="0pt" font-size="8pt">
		 <fo:table-body>
 		  <fo:table-row>
          <!-- do not show the labels for the rules within the group 1.15 -->
          <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt">
		     <fo:block  line-height="15pt">
		     <!-- empty checkbox area -->
		     </fo:block>
		  </fo:table-cell>
		  <fo:table-cell display-align="center">
		     <fo:block>
		     <!-- empty label area -->
		     </fo:block>
		  </fo:table-cell>
 		  </fo:table-row>
		 </fo:table-body>
		</fo:table>
        </xsl:when>
        <xsl:otherwise>
		<xsl:choose>
			<xsl:when test="@Per_complete = 100">  
				<fo:external-graphic src="../images/dwcheckyes.jpg" />
			</xsl:when>
			<xsl:when test="@Per_complete = 99">  
				<fo:external-graphic src="../images/dwcheck99.jpg" />
			</xsl:when>
			<xsl:when test="@Per_complete = 98">  
				<fo:external-graphic src="../images/dwcheck98.jpg" />
			</xsl:when>
			<xsl:otherwise>
				<fo:external-graphic src="../images/dwcheckno.jpg" />
			</xsl:otherwise>
		</xsl:choose>
		&#160;
		<xsl:choose>
			<xsl:when test="@Per_complete = 100">  
				<fo:inline color="#606060">
					<xsl:value-of select="@Label"/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@Per_complete = 99">  
				<fo:inline color="#606060">
					<xsl:value-of select="@Label"/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@Per_complete = 98">  
				<fo:inline color="#606060">
					<xsl:value-of select="@Label"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@Label"/>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:otherwise>
        </xsl:choose>

		</fo:block>
      </fo:table-cell>
      <fo:table-cell background-color="#FFFFFF" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="2"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify" >
		<xsl:call-template name="tClassesApplied"/>
		<xsl:call-template name="tRuleAdvice"/>
		</fo:block>
      </fo:table-cell>

	</fo:table-row>
<!-- RULE REMARKS -->
<xsl:if test="/Report/@rptShowRuleRemarks='Y'">
<xsl:if test="Remark"> 
			<fo:table-row >
				<fo:table-cell number-columns-spanned="4" >
				<fo:block >
					&#160;&#160;
					<xsl:for-each select="Remark/Text">	<!-- FOR EACH RULE REMARK TEXT -->
					<xsl:value-of select="."/>&#160;</xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
				</fo:block >
				</fo:table-cell >
			</fo:table-row >
</xsl:if> <!-- test="Remark" --> 
</xsl:if>  <!-- show rule remarks -->
<!-- END RULE REMARKS -->

<!-- SHOW RULE TEXT -->
<xsl:if test="/Report/@rptShowRuleText='Y'">
<xsl:if test="Requirement"> 
<xsl:call-template name="tRuleRequirements" />
</xsl:if>
</xsl:if>


<!-- SHOW RULE EXCEPTIONS - those on the rule and those on course nodes on the rule -->
<xsl:if test="/Report/@rptShowRuleExceptions='Y'">
<xsl:call-template name="tRuleExceptions" />
<xsl:for-each select="Requirement/.//Course">	
  <xsl:call-template name="tRuleExceptions" />
</xsl:for-each>
</xsl:if>


</xsl:template>
 
<xsl:template name="tClassesApplied">
<xsl:if test="(Classes_applied &gt; 0 and ClassesApplied/Class) or NoncoursesApplied/Noncourse">
	<fo:table table-layout="fixed" width="11cm" 
			background-color="#FFFFFF" 
			border-spacing="1pt" font-size="8pt">
	<fo:table-column column-width="2cm"/> <!-- Course Key -->
	<fo:table-column column-width="5cm"/> <!-- Title      -->
	<fo:table-column column-width="1cm"/> <!-- Grade      -->
	<fo:table-column column-width="1cm"/> <!-- Credits    -->
	<fo:table-column column-width="2cm"/> <!-- Term Taken -->

	<fo:table-body>
	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
		<xsl:for-each select="ClassesApplied/Class">
		<!-- For each instance of the course in the clsinfo section that is not a Ghost record-->
		<!-- We have chosen not to do this when the Show Course keys only is Y because that 
		would make the display confusing.  -->
		<xsl:for-each select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))">
		<xsl:if test="@Rec_type != 'G'">
				<fo:table-row >
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<!-- Show planned classes in another color and within parens -->
            <xsl:if test="@Letter_grade = 'PLAN'"> 
							(<xsl:value-of select="@Discipline"/>	   <!-- left paren + Discipline -->
							<xsl:text>&#160;</xsl:text>				   <!-- space --> 
							<xsl:value-of select="@Number"/>)          <!-- Number + right paren -->
						</xsl:if>
						<!-- NOT Planned Class -->
						<xsl:if test="@Letter_grade != 'PLAN'"> 
							<xsl:value-of select="@Discipline"/>       <!-- Discipline -->
							<xsl:text>&#160;</xsl:text>                     <!-- space --> 
							<xsl:value-of select="@Number"/>           <!-- Number -->
						</xsl:if> 
					</fo:block>
					</fo:table-cell>

					<!-- TITLE -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Class node and get the Title -->     
						<xsl:value-of select="@Course_title"/>
					</fo:block>
					</fo:table-cell>

					<!-- GRADE -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
					</fo:block>
					</fo:table-cell>

					<!-- CREDITS -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<!-- Place the @Credits in parens if the class is in-progress -->
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
					</fo:block>
					</fo:table-cell>

					<!-- TERM -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<xsl:value-of select="@TermLit"/>
					</fo:block>
					</fo:table-cell>

				</fo:table-row >

				<!-- If this is a transfer class show more information -->
				<xsl:if test="@Transfer='T'">
					<fo:table-row >
						<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
							Satisfied by 
						</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
								number-columns-spanned="4">
						<fo:block font-size="8pt">
                <xsl:value-of select="@Transfer_course"/>
                <!-- Show the transfer course title and transfer school name - if they exist -->                        
                <xsl:if test="normalize-space(@TransferTitle) != ''"> 
                  <xsl:text> - </xsl:text> <!-- hyphen --> 
                  <xsl:value-of select="@TransferTitle"/>
                </xsl:if>
                <xsl:if test="normalize-space(@Transfer_school) != ''"> 
                  <xsl:text> - </xsl:text> <!-- hyphen --> 
                  <xsl:value-of select="@Transfer_school"/>
                </xsl:if>
						</fo:block>
						</fo:table-cell>
					</fo:table-row >
				</xsl:if>

		</xsl:if> <!-- @Rec_type != G -->
		</xsl:for-each> <!-- key('ClsKey',@Id_num)" -->
		</xsl:for-each> <!-- ClassesApplied/Class -->

		<xsl:for-each select="NoncoursesApplied/Noncourse"> <!-- most likely only one -->
		    <fo:table-row >
			  <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
			  <fo:block font-size="8pt">
			    <xsl:value-of select="Code"/>
			    <xsl:text>&#160;</xsl:text> <!-- space -->	 
			    <xsl:value-of select="Value"/>		 
			  </fo:block>
			  </fo:table-cell>
			</fo:table-row >
		</xsl:for-each> <!-- NoncoursesApplied/Noncourse -->

	</xsl:if> <!-- CourseKeysOnly = N -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
		<fo:table-row>

			<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
				number-columns-spanned="5">
				<fo:block font-size="8pt">

					<xsl:for-each select="ClassesApplied/Class">
					<!-- For each instance of the course in the clsinfo section that is not a Ghost record-->
					<!-- We have chosen not to do this when the Show Course keys only is Y because that 
					would make the display confusing.  -->

						<xsl:value-of select="@Discipline"/>			<!-- Discipline -->
						<xsl:text>&#160;</xsl:text> <!-- space -->		<!-- space -->
						<xsl:value-of select="@Number"/>				<!-- Number -->
						<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
   					    <xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
						<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->

					</xsl:for-each> <!-- ClassesApplied/Class -->

		            <xsl:for-each select="NoncoursesApplied/Noncourse"> <!-- most likely only one -->
			          <xsl:value-of select="Code"/>
			          <xsl:text>&#160;</xsl:text> <!-- space -->	 
			          <xsl:value-of select="Value"/>		 
			        </xsl:for-each> <!-- NoncoursesApplied/Noncourse -->

				</fo:block>
			</fo:table-cell>

		</fo:table-row>


	</xsl:if>
	</fo:table-body>
	</fo:table>
</xsl:if> <!-- classes-applied > 0 -->

</xsl:template>

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
	<xsl:when test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@Rec_type='G']/@Term = @Term">
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


<xsl:template name="tRuleAdvice">	

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
		<fo:table table-layout="fixed" width="11cm" 
				background-color="#FFFFFF" 
				border-spacing="1pt" font-size="8pt">
		<fo:table-column column-width="2cm"/> <!-- Still Needed Text -->
		<fo:table-column column-width="8.5cm"/> <!-- Advice      -->

		<fo:table-body>
			<fo:table-row >
				<fo:table-cell >
				<fo:block color="#CC0000">
					<xsl:copy-of select="$LabelStillNeeded" />
				</fo:block >
				</fo:table-cell >
				<fo:table-cell >
				<fo:block >
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
								See <fo:inline font-weight="bold">
								<xsl:value-of select="key('BlockKey',concat(generate-id(ancestor::Audit),'-', Advice/BlockID))/@Title" />
								</fo:inline> section
							</xsl:if>
						</xsl:when> 
					<!-- END BLOCK RULE -->

					<!-- BLOCKTYPE RULE -->
						<xsl:when test="@RuleType = 'Blocktype'">
							<xsl:choose>
								<xsl:when test="Advice/Title"> 
									<xsl:for-each select="Advice/Title"> <!-- most likely only one -->
										See <fo:inline font-weight="bold"><xsl:value-of select="." /></fo:inline> section <!--<br/>-->
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline font-weight="bold"><xsl:value-of select="Advice/Type" /> block was not found but is required </fo:inline>
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
										<fo:inline font-weight="bold">
                                          <xsl:choose>
                                          <xsl:when test="$vShowToInsteadOfColon='Y' ">
                                              <!-- Replace the colon with " to " -->
                                              <xsl:call-template name="globalReplace">
                                                <xsl:with-param name="outputString" select="@Credits" />
                                                <xsl:with-param name="target"       select="':'"      />
                                                <xsl:with-param name="replacement"  select="' to '"   />
                                              </xsl:call-template>
                                          </xsl:when>
                                          <xsl:otherwise> <!-- show the credits with the colon (if present) -->
							                <xsl:value-of select="@Credits"/>
                                          </xsl:otherwise>
                                          </xsl:choose>
										</fo:inline>
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
										<fo:inline font-weight="bold">
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
										</fo:inline> 
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
										<fo:inline text-decoration="underline"> Including </fo:inline>
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
									<xsl:if test="Except"> 
										<xsl:text>&#160;</xsl:text> <!-- space --> 
										<fo:inline text-decoration="underline"> Except </fo:inline>
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
								</xsl:when> <!-- when test=Course-->
								<xsl:otherwise>
									<xsl:if test="@Credits"> 
										<fo:inline font-weight="bold"><xsl:value-of select="@Credits"/></fo:inline> more 
										<xsl:choose>
										<xsl:when test="@Credits = 1">
											<xsl:value-of select="/Report/@rptCreditSingular" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/Report/@rptCreditsLiteral" />
										</xsl:otherwise>
										</xsl:choose>
									</xsl:if> 
									<xsl:if test="@Classes"> 
										<fo:inline font-weight="bold"><xsl:value-of select="@Classes"/></fo:inline> more 
										<xsl:choose>
										<xsl:when test="@Classes = 1">
											Class
										</xsl:when>
										<xsl:otherwise>
											Classes
										</xsl:otherwise>
										</xsl:choose>
									</xsl:if> 
								</xsl:otherwise>
							</xsl:choose>
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
					<!-- Add a closing paren if this is rule is within a group -->
					<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
						) 
						<xsl:choose> <!--  -->
							<xsl:when test="@LastRuleInGroup='Yes'"> 
								<!-- do nothing -->
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
						</xsl:choose> <!--  -->
					</xsl:if>
				</fo:block >
				</fo:table-cell >
			</fo:table-row >
		</fo:table-body>
		</fo:table>
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
		<fo:table table-layout="fixed" width="11cm" 
				background-color="#FFFFFF" 
				border-spacing="1pt" font-size="8pt">
		<fo:table-column column-width="2cm"/> <!-- Still Needed Text -->
		<fo:table-column column-width="9cm"/> <!-- Title      -->

		<fo:table-body>
			<fo:table-row >
				<fo:table-cell >
				<fo:block color="#CC0000">
						<xsl:copy-of select="$LabelStillNeeded" />
				</fo:block >
				</fo:table-cell >
				<fo:table-cell >
				<fo:block >
						<xsl:for-each select="ProxyAdvice/Text">
						<xsl:value-of select="."/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						</xsl:for-each> <!-- ADVICE/COURSE-->
				</fo:block >
				</fo:table-cell >
			</fo:table-row >
		</fo:table-body>
		</fo:table>
	</xsl:if> <!-- PROXY-ADVICE -->

</xsl:if>  <!-- show rule advice = Y -->



</xsl:template> <!-- tRuleAdvice -->

<xsl:template name="tRuleRequirements">

			<fo:table-row >
				<fo:table-cell number-columns-spanned="2">
				<fo:block text-align="right">
					Requirement:&#160;&#160;
				</fo:block >
				</fo:table-cell >
				<fo:table-cell number-columns-spanned="2">
				<fo:block >
				&#160;

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
							<fo:inline text-decoration="underline"> Including </fo:inline >
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
							<fo:inline text-decoration="underline"> Except </fo:inline >
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
				 HideRule
				</xsl:if> <!-- HideRule -->

				<xsl:for-each select="Requirement/Qualifier">	<!-- FOR EACH QUALIFIER -->
					<!--<fo:external-graphic src="../images/dwinvis2.jpg"/>-->
					<fo:inline color="blue">&#160;
					<xsl:value-of select="Text"/>
					<xsl:for-each select="SubText">   
						<xsl:value-of select="."/>
					</xsl:for-each>	<!-- FOR EACH subtext -->
					</fo:inline>
				</xsl:for-each>	<!-- FOR EACH QUALIFIER -->



				</fo:block >
				</fo:table-cell >
			</fo:table-row >

</xsl:template>

<xsl:template name="tRuleExceptions">
<!-- FOR EACH COURSE EXCEPTION -->
<xsl:if test="Exception">

<xsl:for-each select="Exception">	
	
	<fo:table-row >
		<fo:table-cell number-columns-spanned="2" background-color="#FFFFFF" >
		<fo:block >
			<fo:inline color="blue">Exception By: </fo:inline><xsl:value-of select="key('XptKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Who"/> on 
					      <xsl:call-template name="FormatRuleXptDate"/>

		</fo:block >
		</fo:table-cell >
		<fo:table-cell number-columns-spanned="2" background-color="#FFFFFF" >
		<fo:block >
			<fo:inline color="blue"><xsl:call-template name="tExceptionType"/>: </fo:inline>
			<xsl:value-of select="key('XptKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Label"/>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>
	
</xsl:for-each> <!-- course exception -->

</xsl:if>

</xsl:template>

<!-- tCourseAdvice - used for displaying courses in requirement advice -->
<xsl:template name="tCourseAdvice">
  <!-- AdviceLink: Link to a new browser when user clicks on class in advice -->
     <!-- Display the discipline only if the discipline isn't repeated --> 
     <xsl:if test="@NewDiscipline='Yes'">
       <fo:inline font-weight="bold"><xsl:value-of select="@Disc"/></fo:inline>
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

  <xsl:if test="@PrereqExists='Y' and /Report/@rptPrereqIndicator='Y'">*<!-- asterisk --></xsl:if>
  <xsl:if test="@With_advice">
   <xsl:text>&#160;</xsl:text> <!-- space --> 
   <xsl:value-of select="@With_advice"/> 
  </xsl:if>
</xsl:template>



<xsl:template name="tIndentLevel">
 <!-- INDENT: invis1 has width=0 so nothing is indented really -->
  <xsl:choose>
    <xsl:when test="@IndentLevel = 1">  
    <fo:external-graphic src="../images/dwinvis1.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 2">  
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 3">  
    <fo:external-graphic src="../images/dwinvis3.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 4">  
    <fo:external-graphic src="../images/dwinvis4.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 5">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 6">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 7">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 8">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 9">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 10">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 11">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 12">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 13">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 14">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    <fo:external-graphic src="../images/dwinvis2.jpg"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 15">  
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    </xsl:when>

    <xsl:otherwise>
    <fo:external-graphic src="../images/dwinvis5.jpg"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="tLegend">
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- Legend (Bottom) -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:if test="/Report/@rptShowLegend='Y'">

<!-- Vertical Space -->
<fo:block font-size="14pt" 
		font-family="sans-serif" 
		font-weight="bold" 
		line-height="14pt"
		space-after.optimum="15pt"
		background-color="#FFFFFF"
		color="#003659"
		text-align="center">
</fo:block>

<fo:table table-layout="fixed" width="19cm" 
		background-color="#FFFFFF" 
		border-spacing="1pt" font-size="8pt"
		>
	<fo:table-column column-width="19cm"/>
	<fo:table-body>
		<fo:table-row > 
			<fo:table-cell>
				<fo:block font-size="10pt"
					color="#003659" keep-with-next.within-page="always">
				Legend
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell display-align="center" >
			<fo:table table-layout="fixed" width="19cm" 
					background-color="#F8F8F8" 
					border-spacing="1pt" font-size="8pt">
				<fo:table-column column-width="1cm"/>
				<fo:table-column column-width="5cm"/>
				<fo:table-column column-width="1cm"/>
				<fo:table-column column-width="7cm"/>
				<fo:table-column column-width="1cm"/>
				<fo:table-column column-width="4cm"/>
				<fo:table-body>
					<fo:table-row > 
						<fo:table-cell display-align="center" background-color="#FFFFFF" text-align="center" >
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic src="../images/dwcheckyes.jpg" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Complete
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic src="../images/dwcheck98.jpg" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Complete except for classes in-progress
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" text-align="center">
							<fo:block keep-with-next.within-page="always">
							(T)
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Transfer Class
							</fo:block>
						</fo:table-cell>
					</fo:table-row > 
					<fo:table-row > 
						<fo:table-cell display-align="center"  background-color="#FFFFFF" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic src="../images/dwcheckno.jpg" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Not Complete
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic src="../images/dwcheck99.jpg" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Nearly complete - see advisor
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center" background-color="#FFFFFF" text-align="center">
							<fo:block keep-with-next.within-page="always">
							@
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#FFFFFF" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Any course number
							</fo:block>
						</fo:table-cell>
					</fo:table-row > 
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row > 
</fo:table-body>
</fo:table>

</xsl:if> 
</xsl:template>


<xsl:template name="tSectionFallthrough">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="Fallthrough">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelFallthrough" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Credits Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" background-color="#FFFFFF" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					background-color="#FFFFFF" 
					border-spacing="1pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  background-color="#FFFFFF" 
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
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
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	</xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</fo:table-body>
	</fo:table>
</xsl:if>
</xsl:for-each> <!-- select="Fallthrough" -->
</xsl:template>

<xsl:template name="tSectionInsufficient">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="Insufficient">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelInsufficient" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Credits Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" background-color="#FFFFFF" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					background-color="#FFFFFF" 
					border-spacing="1pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  background-color="#FFFFFF" 
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
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
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	</xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</fo:table-body>
	</fo:table>
</xsl:if>
</xsl:for-each> <!-- select="Insufficient" -->
</xsl:template>

<xsl:template name="tSectionInprogress">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="In_progress">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelInprogress" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Credits Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" background-color="#FFFFFF" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					background-color="#FFFFFF" 
					border-spacing="1pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@In_progress='Y']/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  background-color="#FFFFFF" 
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
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
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	</xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</fo:table-body>
	</fo:table>

    <xsl:if test="$vShowCourseSignals='Y'">
      <xsl:call-template name="tCourseSignalsHelp" />
	</xsl:if>

</xsl:if>
</xsl:for-each> <!-- select="Inprogress" -->
</xsl:template>

<!-- CourseSignals grade or icon -->
<xsl:template name="tCourseSignalsGrade">
  <xsl:choose>
  <xsl:when test="$vShowCourseSignals='Y'">  <!-- CourseSignals -->
    <xsl:choose>
    <xsl:when test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='YELLOW']">
		<fo:external-graphic width="0.30cm" height="0.30cm"  src="../images/coursesignals-yellow.gif " />
    </xsl:when>
    <xsl:when test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='RED']">
		<fo:external-graphic width="0.30cm" height="0.30cm"   src="../images/coursesignals-red.gif " />
    </xsl:when>
    <xsl:when test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='GREEN']">
		<fo:external-graphic width="0.30cm" height="0.30cm"   src="../images/coursesignals-green.gif " />
    </xsl:when>
    <xsl:otherwise>  <!-- no signal on this class - just show the grade -->
  	  <xsl:value-of select="@Letter_grade"/> 
  	  <xsl:text>&#160;</xsl:text> 
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  
  <xsl:otherwise>  <!-- CourseSignals is turned off - just how the grade -->
  	  <xsl:value-of select="@Letter_grade"/> 
  	  <xsl:text>&#160;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- CourseSignals help link -->
<!-- Only appears if the student has at least one red signal for an in-progress class -->
<xsl:template name="tCourseSignalsHelp">
	<xsl:if test="/Report/Audit/Clsinfo/Class[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='RED']">
	<fo:table table-layout="fixed" width="19cm"
			background-color="#F0F0F0"  
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="1cm"/>
		<fo:table-column column-width="18cm"/>

		<fo:table-body>

		    <fo:table-row>
			<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center" number-columns-spanned="1">
				<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
				   <fo:external-graphic width="0.30cm" height="0.30cm"  src="../images/coursesignals-red.gif " />
			    </fo:block>
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="0.2pt" padding-bottom="0.2pt" display-align="center" number-columns-spanned="1">
				<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
					&#160;You are having trouble with your classes this semester. 
					We encourage you to make use of the services on campus to help you succeed.
					&#160;Please review the many ways we can help you by visiting 
                    <xsl:copy-of select="$CourseSignalsHelpUrl"/>
			    </fo:block>
		    </fo:table-cell>
		    </fo:table-row>
	    </fo:table-body>
	</fo:table>
	</xsl:if> <!-- help link -->
</xsl:template>

<xsl:template name="tSectionOTL">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="OTL">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelOTL" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Credits Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" background-color="#FFFFFF" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					background-color="#FFFFFF" 
					border-spacing="1pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
                        <xsl:if test="@Reason">
						<fo:block font-size="6pt" font-style="italic">
						<!-- Reason -->
						<xsl:value-of select="@Reason"/>
<!--
                        <xsl:call-template name="globalReplace">
                          <xsl:with-param name="outputString" select="@Reason"/>
                          <xsl:with-param name="target"       select="'credits'"/>
                          <xsl:with-param name="replacement"  select="normalize-space(/Report/@rptCreditsLiteral)"/>
                        </xsl:call-template>
-->
						</fo:block>
                        </xsl:if>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  background-color="#FFFFFF" 
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
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
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	</xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</fo:table-body>
	</fo:table>
</xsl:if>
</xsl:for-each> <!-- select="OTL" -->
</xsl:template>


<xsl:template name="tProgressBar"> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- PROGRESS BAR  -->
<!-- //////////////////////////////////////////////////////////////////////// -->
  <!-- -->
  <!-- /Report/Audit/AuditHeader/@Per_complete contains the percent complete -->

<fo:block text-align="center" space-before.optimum="1cm" space-after.optimum="1cm">

	<fo:inline color="#000000" font-size="10pt">
	<xsl:copy-of select="$LabelProgressBar" />
	</fo:inline>

	<fo:table table-layout="fixed" width="14cm" 
				background-color="#CCCCCC" 
				border-spacing="1pt" font-size="9pt"
				start-indent="2cm" end-indent="2cm">

	<!-- TODO: figure out the smallest available and if the Per_complete is less than or equal to that 
	     value then hardcode the proportional width to that value-->
	<fo:table-column > 
		<xsl:if test="AuditHeader/@Per_complete = 0">
			<xsl:attribute name="column-width"> proportional-column-width(0) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete = 100">
			<xsl:attribute name="column-width"> proportional-column-width(100) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete &gt; 0">
		<xsl:if test="AuditHeader/@Per_complete &lt; 100">
			<xsl:attribute name="column-width">
			   proportional-column-width(<xsl:value-of select="AuditHeader/@Per_complete" />)
			</xsl:attribute>
		</xsl:if>
		</xsl:if>

	</fo:table-column > 
	<fo:table-column > 
		<xsl:if test="AuditHeader/@Per_complete = 0">
			<xsl:attribute name="column-width"> proportional-column-width(100) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete = 100">
			<xsl:attribute name="column-width"> proportional-column-width(0) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete &gt; 0">
		<xsl:if test="AuditHeader/@Per_complete &lt; 100">
			<xsl:attribute name="column-width">
			   proportional-column-width(<xsl:value-of select="100 - AuditHeader/@Per_complete" />)
			</xsl:attribute>
		</xsl:if>
		</xsl:if>
	</fo:table-column> 

	
	<fo:table-body>

		<fo:table-row>
			<fo:table-cell background-color="#F8F8F8" color="#000000">
				<fo:block>
					<xsl:value-of select='format-number(AuditHeader/@Per_complete, "#")' />% <!-- was #.0 but Mike wants no decimals -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</fo:table-body>
	</fo:table>
</fo:block >

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- PROGRESS BAR END -->
<!-- //////////////////////////////////////////////////////////////////////// -->
</xsl:template> 

<!-- Check to see if credits or classes are required and show the corresponding value applied -->
<xsl:template name="tCheckCreditsClasses-Applied">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Header/Qualifier[@Node_type='4121']">
   <xsl:if test="not(@Pseudo)">

	 <xsl:choose>
     <xsl:when test="@Credits">	   

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="../../@Credits_applied"/>       <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>

	 </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - must be classes -->

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			Classes Applied:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="../../@Classes_applied"/>		 <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>


     </xsl:otherwise>
	 </xsl:choose>
   </xsl:if>
   </xsl:for-each>

</xsl:template>


<!-- Check to see if credits or classes are required on this block and show the value -->
<xsl:template name="tCheckCreditsClasses-Required">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Header/Qualifier[@Node_type='4121']">
   <xsl:if test="not(@Pseudo)">
	 <xsl:choose>
     <xsl:when test="@Credits">	   

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:choose>
			<xsl:when test="@Credits = 1">
				<xsl:value-of select="/Report/@rptCreditSingular" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/Report/@rptCreditsLiteral" />
			</xsl:otherwise>
			</xsl:choose>
			 Required:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="@Credits"/>       <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>

	 </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - must be classes -->

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:choose>
			<xsl:when test="@Classes = 1">
				Class
			</xsl:when>
			<xsl:otherwise>
				Classes
			</xsl:otherwise>
			</xsl:choose>
			 Required:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="@Classes"/>		 <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>


     </xsl:otherwise>
	 </xsl:choose>
   </xsl:if>
   </xsl:for-each>
</xsl:template>



<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT ALERTS -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<xsl:template name="tStudentAlerts"> 
<!-- If an ALERT1 Report node exists -->
<xsl:if test="Deginfo/Report/@Code='ALERT1'"> 

<fo:block text-align="center" space-before.optimum="0.25cm" space-after.optimum="0.25cm"
		start-indent="2cm" end-indent="2cm"
		>

<fo:table table-layout="fixed" width="14cm" 
		background-color="#F8F8F8" 
		border-spacing="1pt" font-size="9pt" 
		>

	<fo:table-column column-width="14cm"/>

	<fo:table-body>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" >
				<fo:block font-size="9pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Report Name Audit ID as of Date Time -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt">
				<fo:block font-size="9pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						padding-top="0pt"
						padding-bottom="0pt"
						padding-left="0pt">
					<fo:inline font-weight="bold" text-align="center" >
						<xsl:copy-of select="$LabelAlertsReminders" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" >
				<fo:block font-size="9pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<xsl:if test="Deginfo/Report/@Code='ALERT1'"> 
			<fo:table-row >  
				<fo:table-cell text-align="justify" background-color="#FFFFFF" 
					start-indent="0cm" end-indent="0cm" >
				<fo:block font-size="7pt" text-align="justify">
				<fo:external-graphic src="../images/Arrow_Right.jpg" />&#160;
					<xsl:for-each select="Deginfo/Report[@Code='ALERT1']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</fo:block>
				</fo:table-cell>
			</fo:table-row >  
			</xsl:if>

			<xsl:if test="Deginfo/Report/@Code='ALERT2'"> 
			<fo:table-row >  
				<fo:table-cell text-align="justify" background-color="#FFFFFF" 
					start-indent="0cm" end-indent="0cm" >
				<fo:block font-size="7pt" text-align="justify">
				<fo:external-graphic src="../images/Arrow_Right.jpg" />&#160;
					<xsl:for-each select="Deginfo/Report[@Code='ALERT2']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</fo:block>
				</fo:table-cell>
			</fo:table-row >  
			</xsl:if>

	</fo:table-body>
</fo:table>

</fo:block>

</xsl:if>
</xsl:template> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT ALERTS END -->
<!-- //////////////////////////////////////////////////////////////////////// -->

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


<xsl:template name="tSectionExceptions">
	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="3cm"/>
		<fo:table-column column-width="8cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="6"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center" number-columns-spanned="6" >
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						Exceptions
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="6"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<fo:table-row>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Type
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Description
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Date
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Who
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Block
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Enforced
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	<xsl:for-each select="ExceptionList/Exception">

	<fo:table-row>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:call-template name="tExceptionType"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Label"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:call-template name="FormatXptDate"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Who"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Req_id"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Enforced"/>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	</xsl:for-each>

</fo:table-body>
</fo:table>


</xsl:template>

<xsl:template name="tSectionNotes">
	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
        <xsl:choose>
        <xsl:when test="(/Report/@rptShowNoteCheckbox) ='Y' and /Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id"> 
		 <fo:table-column column-width="2cm"/> <!-- internal -->
		 <fo:table-column column-width="13cm"/>
		 <fo:table-column column-width="2cm"/>
		 <fo:table-column column-width="2cm"/>
        </xsl:when>

        <xsl:otherwise> <!-- do not show the internal flag -->
		<fo:table-column column-width="15cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>
        </xsl:otherwise>
        </xsl:choose>
		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center" number-columns-spanned="3" >
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						Notes
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<fo:table-row>
        <xsl:if test="(/Report/@rptShowNoteCheckbox) ='Y' and /Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id"> 
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" text-align="center">
		<fo:block font-size="8pt">
			Internal
		</fo:block>
		</fo:table-cell>
        </xsl:if>

		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Who
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			Date
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	<xsl:for-each select="Notes/Note[@Note_type != 'PL']">

	<fo:table-row>
		<!-- internal flag -->
        <xsl:if test="(/Report/@rptShowNoteCheckbox) ='Y' and /Report/@rptUsersId != /Report/Audit/AuditHeader/@Stu_id"> 
		 <fo:table-cell text-align="center">
		 <fo:block font-size="8pt">
              <xsl:choose>
              <xsl:when test="substring(@Note_type,2,1)='I'"> <!-- Internal -->
			  	<fo:external-graphic width="0.36cm" height="0.36cm"  src="../images/internal-note-checkmark.gif" /> 
              </xsl:when>
              <xsl:otherwise>
                &#160;
              </xsl:otherwise>
              </xsl:choose>
		 </fo:block>
		 </fo:table-cell>
        </xsl:if>

		<!-- note text -->
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:for-each select="./Text"><xsl:value-of select="."/></xsl:for-each>
		</fo:block>
		</fo:table-cell>
      	<!-- users's name -->
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Note_who"/>
		</fo:block>
		</fo:table-cell>
		<!-- create date -->
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:call-template name="FormatNoteDate"/>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	</xsl:for-each>

</fo:table-body>
</fo:table>


</xsl:template>

<xsl:template name="tDisclaimer">	
<xsl:if test="/Report/@rptShowDisclaimer='Y'">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F8F8F8" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="19cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#B3B3B3"
						color="#000000"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						Disclaimer
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#B3B3B3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<fo:table-row>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="blue" >
		<fo:block font-size="8pt">
			You are encouraged to use this degree audit report as a guide when planning your progress toward completion of the above requirements. Your academic advisor or the Registrar's Office may be contacted for assistance in interpreting this report. This audit is not your academic transcript and it is not official notification of completion of degree or certificate requirements. Please contact the Registrar's Office regarding this degree audit report, your official degree/certificate completion status, or to obtain a copy of your academic transcript. 		
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	</fo:table-body>
	</fo:table>

</xsl:if> 
</xsl:template>

<xsl:template name="FormatNoteDate">	
    <xsl:call-template name="FormatDate">
		<xsl:with-param name="pDate" select="@Note_date" />
    </xsl:call-template>
</xsl:template>
<xsl:template name="FormatXptDate">	
    <xsl:call-template name="FormatDate">
		<xsl:with-param name="pDate" select="@Date" />
    </xsl:call-template>
</xsl:template>

<xsl:template name="FormatRuleXptDate">	
    <xsl:call-template name="FormatDate">
		<xsl:with-param name="pDate" select="key('XptKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Date" />
    </xsl:call-template>
</xsl:template>

<xsl:template name="FormatDate">	
<xsl:param name="pDate"/>
  <xsl:variable name="vDateFormat" select="/Report/@rptDateFormat"/>
  <xsl:variable name="vYear"  select="substring($pDate,1,4)"/>
  <xsl:variable name="vMonth" select="substring($pDate,5,2)"/>
  <xsl:variable name="vDay"   select="substring($pDate,7,2)"/>

  <xsl:choose>

    <xsl:when test="$vDateFormat='DMY'"> <!-- Europe/Australia/etc - 31/12/2009-->
     <xsl:value-of select="concat($vDay,'/',$vMonth,'/',$vYear)"/>
    </xsl:when>
  
    <xsl:when test="$vDateFormat='DXY'"> <!-- Europe/Australia/etc - 31DEC09-->
     <xsl:choose>
       <xsl:when test="$vMonth='01'"><xsl:value-of select="concat($vDay,'JAN',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='02'"><xsl:value-of select="concat($vDay,'FEB',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='03'"><xsl:value-of select="concat($vDay,'MAR',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='04'"><xsl:value-of select="concat($vDay,'APR',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='05'"><xsl:value-of select="concat($vDay,'MAY',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='06'"><xsl:value-of select="concat($vDay,'JUN',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='07'"><xsl:value-of select="concat($vDay,'JUL',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='08'"><xsl:value-of select="concat($vDay,'AUG',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='09'"><xsl:value-of select="concat($vDay,'SEP',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='10'"><xsl:value-of select="concat($vDay,'OCT',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='11'"><xsl:value-of select="concat($vDay,'NOV',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='12'"><xsl:value-of select="concat($vDay,'DEC',substring($vYear,3,2))"/></xsl:when>
       <xsl:otherwise>               <xsl:value-of select="concat($vDay,'???',substring($vYear,3,2))"/></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
  
    <xsl:when test="$vDateFormat='YMD'"> <!-- China etc - 2009/12/31-->
     <xsl:value-of select="concat($vYear,'/',$vMonth,'/',$vDay)"/>
    </xsl:when>
  
    <xsl:otherwise> <!-- test="$vDateFormat='MDY'"> - USA format - 12/31/2009-->
     <xsl:value-of select="concat($vMonth,'/',$vDay,'/',$vYear)"/>
    </xsl:otherwise> 
  </xsl:choose>
</xsl:template>

<xsl:template name="tFormatNumber">
<xsl:param name="iNumber" />
<xsl:param name="sRoundingMethod" />
  <xsl:choose>
    <!-- If the number contains a range (eg: 0:4) -->
    <xsl:when test="contains ($iNumber, ':') ">
	 <xsl:value-of select="$iNumber" />
    </xsl:when>
    <xsl:otherwise>
	 <xsl:value-of select="format-number($iNumber, $sRoundingMethod)" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tStudentID">	
<xsl:variable name="stu_id"           select="normalize-space(AuditHeader/@Stu_id)"/>
<xsl:variable name="stu_id_length"    select="string-length(normalize-space(AuditHeader/@Stu_id))"/>
<xsl:variable name="bytes_to_remove"  select="$stu_id_length - /Report/@rptCFG020MaskStudentID"/>
<xsl:variable name="bytes_to_show"    select="$stu_id_length - $bytes_to_remove"/>
<xsl:variable name="myAsterisks">
<xsl:call-template name="tAsterisks" >
	<xsl:with-param name="bytes_to_remove" select="$bytes_to_remove" />
</xsl:call-template>
</xsl:variable>

<xsl:variable name="formatted_stu_id" />
<xsl:choose>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'A'">  
		<xsl:value-of select="AuditHeader/@Stu_id"/> <xsl:copy-of select="$bytes_to_remove" />
	</xsl:when>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'N'">  
		<xsl:value-of select="AuditHeader/@Stu_id"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="concat($myAsterisks, substring($stu_id, $bytes_to_remove + 1, $bytes_to_show))" />
	</xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template name="tAsterisks">
<xsl:param name="bytes_to_remove" />
<xsl:variable name="decrement" select="$bytes_to_remove - 1" />
<xsl:if test="$decrement &gt; -1">*<xsl:call-template name="tAsterisks"><xsl:with-param name="bytes_to_remove" select="$decrement" /></xsl:call-template></xsl:if>
</xsl:template>

<!-- Replace one string with another -->
<xsl:template name="globalReplace">
  <xsl:param name="outputString"/>
  <xsl:param name="target"/>
  <xsl:param name="replacement"/>
  <xsl:choose>
    <xsl:when test="contains($outputString,$target)">
      <xsl:value-of select="concat(substring-before($outputString,$target),$replacement)"/>
      <xsl:call-template name="globalReplace">
        <xsl:with-param name="outputString" select="substring-after($outputString,$target)"/>
        <xsl:with-param name="target"       select="$target"/>
        <xsl:with-param name="replacement"  select="$replacement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$outputString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
 

