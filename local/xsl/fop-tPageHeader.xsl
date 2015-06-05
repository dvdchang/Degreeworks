<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tPageHeader.xsl#2 $ -->

<xsl:template name="tPageHeader">       

<!--
A:  Ellucian Degree Works Report
B:  Degree Works: Detailed Advice 
C:  Generic University: Detailed Advice audit
D:  Detailed Advice audit for Jones, George
E:  Detailed Advice audit for Jones, George - 285773
F:  Generic University: Detailed advice Audit for Jones, George
G:  Generic University: Detailed advice Audit for Jones, George - 285773
If blank or none of the above, the default is E.

-->
<fo:block font-size="8pt" color="#fff">
	<!-- CMU Localization === Removed background-image and added backround-color 
	<fo:table table-layout="fixed" width="19cm" 
						font-size="8pt" 
						background-repeat="no-repeat" 
						background-image="../images/pdf-header.gif" 
						border-bottom-width="medium" 
						border-bottom-color="#ffffff" 
						border-bottom-style="solid">
	-->

		<!-- CMU Localization === Added campus image  -->
				<fo:table table-layout="fixed" width="19cm" 
						font-size="8pt"
						background-color="#5D0022"
						border-bottom-width="medium" 
						border-bottom-color="#ffffff" 
						border-bottom-style="solid">
						
		<fo:table-column column-width="9cm"/>
		<fo:table-column column-width="9cm"/>
		<fo:table-column column-width="1cm"/>

		<fo:table-body>

			<fo:table-row>  <!-- Row for space above image -->
			<fo:table-cell>
				<fo:block font-size="6pt" >
				  <xsl:text>&#160;</xsl:text> <!-- space --> 
				</fo:block>
			</fo:table-cell>
			</fo:table-row>
				
			<fo:table-row>
				<fo:table-cell height="1.50cm" width="9.0cm" margin="15pt">
				    <fo:block-container position="absolute" >
					<fo:block text-align="left">
						<fo:external-graphic  src="../../local/images/cmu_v_logo_white.png"  
							content-height="1.00cm"/>
				     </fo:block>
					</fo:block-container>
				</fo:table-cell>
<!--			</fo:table-row> -->
	<!-- CMU Localization === End of Added campus image -->	
	
<!--			<fo:table-row> -->
				<fo:table-cell height="1.5cm">
				<fo:block text-align="right" padding-right="0.7cm" padding-top="0.7cm">

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
	-->
	Degree Works
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
 
</xsl:stylesheet>
