<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tStudentAlerts.xsl#1 $ -->

<xsl:template name="tStudentAlerts"> 
<!-- If an ALERT1 Report node exists -->
<xsl:if test="Deginfo/Report/@Code='ALERT1'"> 

<fo:block text-align="center" space-before.optimum="0.25cm" space-after.optimum="0.25cm"
		start-indent="2cm" end-indent="2cm"
		>

<fo:table table-layout="fixed" width="14cm" 
		background-color="#EFEFEF" 
		border-spacing="0pt" font-size="9pt" 
		>

	<fo:table-column column-width="14cm"/>

	<fo:table-body>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" >
				<fo:block font-size="9pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Report Name Audit ID as of Date Time -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="1pt">
				<fo:block font-size="9pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#5B788F"
						color="#fff"
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
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" >
				<fo:block font-size="9pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<xsl:if test="Deginfo/Report/@Code='ALERT1'"> 
			<fo:table-row >  
				<fo:table-cell text-align="justify" 
					start-indent="0cm" end-indent="0cm" >
				<fo:block font-size="7pt" text-align="justify">
				<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/Arrow_Right.jpg" />&#160;
					<xsl:for-each select="Deginfo/Report[@Code='ALERT1']">
						<xsl:value-of select="@Value" />
					</xsl:for-each>
				</fo:block>
				</fo:table-cell>
			</fo:table-row >  
			</xsl:if>

			<xsl:if test="Deginfo/Report/@Code='ALERT2'"> 
			<fo:table-row >  
				<fo:table-cell text-align="justify" 
					start-indent="0cm" end-indent="0cm" >
				<fo:block font-size="7pt" text-align="justify">
				<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/Arrow_Right.jpg" />&#160;
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
 
</xsl:stylesheet>
