<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tLegend.xsl#1 $ -->

<!-- CMU Localization === Replaced all instances of background-color="#AFC7D9" with background-color="#F1EFED" using Find/Replace -->
<xsl:template name="tLegend">
<xsl:if test="/Report/@rptShowLegend='Y'">

<!-- Vertical Space -->
<fo:block font-size="14pt" 
		font-family="sans-serif" 
		font-weight="bold" 
		line-height="14pt"
		space-after.optimum="15pt"
		background-color="#FFFFFF"
		color="#316C92"
		text-align="center">
</fo:block>

<fo:table table-layout="fixed" width="19cm" 
		background-color="#FFFFFF" 
		border-spacing="0pt" font-size="8pt"
		>
	<fo:table-column column-width="19cm"/>
	<fo:table-body>
		<fo:table-row > 
			<fo:table-cell>
				<fo:block font-size="10pt"
					color="#316C92" keep-with-next.within-page="always">
				Legend
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row >  <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell display-align="center" >
			<fo:table table-layout="fixed" width="19cm" 
					background-color="#EFEFEF" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="1cm"/>
				<fo:table-column column-width="5cm"/>
				<fo:table-column column-width="1cm"/>
				<fo:table-column column-width="7cm"/>
				<fo:table-column column-width="1cm"/>
				<fo:table-column column-width="4cm"/>
				<fo:table-body>
					<fo:table-row >
						<fo:table-cell display-align="center" background-color="#F1EFED" text-align="center" >
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic width="0.36cm" height="0.36cm"  src="../images/dwcheckyes.gif " />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Complete
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck98.gif" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Complete except for classes in-progress
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<!-- CMU Localization === Change text
							(T) -->
							T
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Transfer Class
							</fo:block>
						</fo:table-cell>
					</fo:table-row > 
					<fo:table-row > 
						<fo:table-cell display-align="center"  background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Not Complete
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
							<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck99.gif" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							Nearly complete - see advisor
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center" background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
							@
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
							<!-- CMU Localization === Change text
							Any course number -->
							Wildcard
							</fo:block>
						</fo:table-cell>
					</fo:table-row >
					
					<!-- CMU Localization === Added row of legend items -->
					<fo:table-row > 
						<fo:table-cell display-align="center"  background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
								IP
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
								In-Progress 							
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
								I
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
								Incomplete 
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center" background-color="#F1EFED" text-align="center">
							<fo:block keep-with-next.within-page="always">
								*
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center"  background-color="#F1EFED" padding-left="5pt" >
							<fo:block keep-with-next.within-page="always">
								Indicates Course has a Prerequisite 
							</fo:block>
						</fo:table-cell>
					</fo:table-row > 
					<!-- CMU Localization === End of Added row of legend items -->
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row > 
</fo:table-body>
</fo:table>

</xsl:if> 
</xsl:template>
 
</xsl:stylesheet>
