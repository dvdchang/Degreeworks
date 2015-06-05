<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tAwardSummary.xsl#3 $ -->

<xsl:template name="tAwardSummary">
<xsl:if test="Deginfo/Custom[@Code='AWARD']">
	<fo:table table-layout="fixed" width="19cm" display-align="center"
			background-color="#fff" space-before="0.3cm" space-after="0.3cm"
			border-spacing="0pt" font-size="8pt" >
 	<fo:table-column column-width="8.5cm"/>

     <fo:table-body>

     <!-- First row for "Financial Aid Awards" header -->
	 <fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> 
		<fo:table-cell padding-left="5pt" padding-top="0pt" number-columns-spanned="1"  display-align="center">
			<fo:block font-size="9pt" 
					font-family="sans-serif" 
					line-height="12pt"
					color="#fff"
					text-align="center"
					padding-top="0pt"
					padding-bottom="0pt"
					padding-left="2pt" keep-with-next.within-page="always">


			<fo:table table-layout="fixed" width="18cm" border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="8cm"/>
				
				<fo:table-body>
				<fo:table-row>
					<fo:table-cell text-align="center" display-align="center">
						<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
							Financial Aid Awards
					    </fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
			</fo:table>

			</fo:block> 
		</fo:table-cell>
	</fo:table-row>

<!-- One row for each AWARD value -->
<xsl:for-each select="Deginfo/Custom[@Code='AWARD']">
<xsl:sort select="@Value"  order="ascending"/>
	 <fo:table-row background-color="#FFFFFF" > 
		<fo:table-cell padding-left="5pt" padding-top="0pt" number-columns-spanned="1"  display-align="center">
			<fo:block font-size="9pt" 
					font-family="sans-serif" 
					line-height="12pt"
					color="#5B788F"
					text-align="center"
					padding-top="0pt"
					padding-bottom="0pt"
					padding-left="2pt" keep-with-next.within-page="always">

			<fo:table table-layout="fixed" width="18cm" border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="8cm"/>
				
				<fo:table-body>
				<fo:table-row>
					<fo:table-cell text-align="center" display-align="center">
						<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
		                    <xsl:call-template name="tGetAwardLiteral">
		                    	<xsl:with-param name="sCode" select="@Value" />
		                    </xsl:call-template>
					    </fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
			</fo:table>

			</fo:block> 
		</fo:table-cell>
	</fo:table-row>
</xsl:for-each>                                   

    </fo:table-body>
    </fo:table>
</xsl:if>
</xsl:template>

<xsl:template name="tGetAwardLiteral">
<xsl:param name="sCode"  />

<xsl:choose>
	<xsl:when test="$sCode='PELL'">
		Pell Grant
	</xsl:when>
	<xsl:when test="$sCode='STAFFORD'">
		Stafford Loan
	</xsl:when>
	<xsl:when test="$sCode='FULLTIME'">
		Full Time
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$sCode" />
        (see fop-tAwardSummary.xsl for list of award codes and descriptions)
	</xsl:otherwise>
</xsl:choose>

</xsl:template> 
 
</xsl:stylesheet>
