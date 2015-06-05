<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tSchoolHeader.xsl#1 $ -->

<xsl:template name="tSchoolHeader">  

	<!-- CMU Localization === Changed background-color and color
	<fo:block font-size="14pt" 
			font-family="sans-serif" 
			font-weight="bold" 
			line-height="20pt"
			space-after.optimum="5pt"
			background-color="#ACC4D5"
			color="#224D78"
			text-align="center"
			>
	-->
	<fo:block font-size="14pt" 
			font-family="sans-serif" 
			font-weight="bold" 
			line-height="20pt"
			space-after.optimum="5pt"
			background-color="#FFFFFF"
			color="#000000" 
			text-align="center"
			>
	<xsl:value-of select="/Report/@rptInstitutionName"/> 
	</fo:block> 
</xsl:template> 
 
</xsl:stylesheet>
