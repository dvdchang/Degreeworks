<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tStudentHeader.xsl#1 $ -->

<!-- CMU Localization === Change align="justify" to align="left" using find replase -->

<xsl:template name="tStudentHeader">

<fo:table table-layout="fixed" width="19cm" 
		background-color="#EFEFEF" 
		border-spacing="0pt" font-size="8pt">
	<!-- CMU Localization === Added 3rd column
	<fo:table-column column-width="2.5cm"/>
	<fo:table-column column-width="7.0cm"/>
	<fo:table-column column-width="2.5cm"/>
	<fo:table-column column-width="7.0cm"/>
	-->
	<fo:table-column column-width="2.2cm"/>
	<fo:table-column column-width="3.2cm"/>
	<fo:table-column column-width="1.6cm"/>
	<fo:table-column column-width="4.1cm"/>
	<fo:table-column column-width="3.4cm"/>
	<fo:table-column column-width="4.5cm"/>
	<!-- CMU Localization === Added 3rd column -->

	<fo:table-body>

		<fo:table-row>  <!-- Row for making the block header look nice (no content) -->
			<!-- CMU Localization === Changed background-color and changed number-columns-spanned
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="4">
			-->
			<fo:table-cell background-color="#5D0022" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="6">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<!-- CMU Localization === Changed background-color and removed background-image 
		<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
		<fo:table-row background-color="#5D0022"> <!-- Report Name Audit ID as of Date Time -->
		<!-- CMU Localization === Changed number-columns-spanned 
		<fo:table-cell padding-left="5pt" padding-top="1pt" number-columns-spanned="3"> -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" number-columns-spanned="5">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="left"
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
						color="#fff"
						text-align="left"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
				  <xsl:value-of select="AuditHeader/@AuditDescription"/>
                  <xsl:if test="AuditHeader/@FreezeTypeDescription != '' ">
				    (<xsl:value-of select="AuditHeader/@FreezeTypeDescription"/>)
                  </xsl:if>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid">  <!-- Row for making the block header look nice (no content) -->
			<!-- CMU Localization === Changed number-columns-spanned 
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"> -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="6">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> <!-- Row 1 -->
		     
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >  -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Student
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<xsl:value-of select="AuditHeader/@Stu_name"/>
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >  -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
			    <!-- CMU Localization === Changed text
				School -->
				Level
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<xsl:value-of select="Deginfo/DegreeData/@SchoolLit"/>
				</fo:block>
			</fo:table-cell>
			
			<!-- CMU Localization === Moved Level (Class Standing) Here -->
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >  -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
			    <!-- CMU Localization === Changed text 
				Level -->
				Class Standing
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === Moved Level (Class Standing) Here -->
			
			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
				<xsl:value-of select="Deginfo/DegreeData/@Stu_levelLit"/>
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === End of Moved Level (Class Standing) Here -->
		</fo:table-row>

		<fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> <!-- Row 2 -->
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >  -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
			    <!-- CMU Localizataion === Changed text
				ID -->
				Student ID
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<xsl:call-template name="tStudentID" />
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Degree
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
				<xsl:value-of select="Deginfo/DegreeData/@DegreeLit"/>
				</fo:block>
			</fo:table-cell>
			
			
			<!-- CMU Localization === Added Academic Standing -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
					Academic Standing
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
			<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='ACADSTAND']">
				<xsl:value-of select="@Value" />
				<xsl:if test="position()!=last()">
					<fo:block><!-- New Line --> </fo:block>
				</xsl:if>
			</xsl:for-each>
				</fo:block>
			</fo:table-cell>
			
		</fo:table-row>

		<fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> <!-- Row 3 -->

		<!-- CMU Localization === Moved Advisor up to here -->
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >  -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Advisor<xsl:if test="count(Deginfo/Goal[@Code='ADVISOR'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
			    <xsl:for-each select="Deginfo/Goal[@Code='ADVISOR']">
					<xsl:value-of select="@Advisor_name"/><xsl:if test="position()!=last()">
					<!-- CMU Localization === Replaced ; with new line by using fo:block
					; -->
					<fo:block><!-- New Line --> </fo:block>
					</xsl:if>
				</xsl:for-each>
				</fo:block>
			</fo:table-cell>
		<!-- CMU Localization === End of Moved Advisor up to here -->
		
			<!-- CMU Localizaiton === Moved Major up to here -->
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Major<xsl:if test="count(Deginfo/Goal[@Code='MAJOR'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
				<xsl:for-each select="Deginfo/Goal[@Code='MAJOR']">
					<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localizaiton === End of Moved Major up to here -->
			
			<!-- CMU Localization === Added Graduation Application Status -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
					Graduation Application Status
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<xsl:for-each select="/Report/Audit/Deginfo/Report[@Code='GRADAPPSTSDE']">
						<xsl:value-of select="@Value" />
						<xsl:if test="position()!=last()">
							<fo:block><!-- New Line --> </fo:block>
						</xsl:if>
					</xsl:for-each>
				</fo:block>
			</fo:table-cell>
			
		</fo:table-row>

		<fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> <!-- Row 4 -->
			<!-- CMU Localization === Moved GPA up to here -->
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				<!-- CMU Localization === Changed text
				Overall GPA -->
				Graduation GPA
				</fo:block>
			</fo:table-cell>
			
			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
				<!-- CMU Localization === Added formatting to GPA 
				<xsl:value-of select="AuditHeader/@SSGPA"/> -->
				<xsl:call-template name="tFormatNumber" >
					<xsl:with-param name="iNumber"         select="AuditHeader/@SSGPA" />
						<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === End of Moved GPA up to here -->
			
			<!-- CMU Localization === Moved Minor up to here -->
			<!-- CMU Localization === Changed background-color  
			<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<!-- CMU Localization === Changed color
				<fo:block text-align="left" font-weight="bold" color="#316C92"  > -->
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Minor<xsl:if test="count(Deginfo/Goal[@Code='MINOR'])>1">s</xsl:if>
				</fo:block>
			</fo:table-cell>

			<!-- CMU Localization === Changed background-color 
			<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
				<xsl:for-each select="Deginfo/Goal[@Code='MINOR']">
					<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === End of Moved Minor up to here -->
			
			<!-- CMU Localization === Added Empty cells for formatting -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
					<!-- Empty -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<!-- Empty -->
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> <!-- Row 5 -->
			<!-- CMU Localization === Added Confidentiality Status -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Confidentiality Status 
				</fo:block>
			</fo:table-cell>

			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<xsl:value-of select="/Report/Audit/Deginfo/Report[@Code='CONFIDENTIAL']/@Value" /> 
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === End of Added Confidentiality Status -->
			
			<!-- CMU Localization === Added Emphasis (Concentration) -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
				Emphasis
			</fo:block>
			</fo:table-cell>

			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='CONC']">
						<xsl:value-of select="@ValueLit" />
						<xsl:if test="position()!=last()">
							<fo:block><!-- New Line --></fo:block>
						</xsl:if>
					</xsl:for-each>
				</fo:block>
			</fo:table-cell>
			<!-- CMU Localization === End of Added Emphasis (Concentration) -->

			<!-- CMU Localization === Added Empty cells for formatting -->
			<fo:table-cell background-color="#6D5E51" padding-left="5pt" padding-top="1pt" display-align="center" > 
			<fo:block text-align="left" font-weight="bold" color="#FFFFFF"  >
					<!-- Empty -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="1pt" display-align="center" >
				<fo:block text-align="left">
					<!-- Empty -->
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

</fo:table-body>
</fo:table>

</xsl:template> <!-- end templateStudentHeader -->
 
</xsl:stylesheet>
