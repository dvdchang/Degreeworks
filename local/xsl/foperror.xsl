<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/foperror.xsl#2 $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- The xml tree structure looks like this:
<Error>
    <Message>
    some message text here 
    </Message>
</Error>
-->

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

	<xsl:for-each select="Error/Message">
		<fo:page-sequence master-reference="simple">

		<fo:static-content flow-name="xsl-region-before">
			<fo:block>
				<xsl:call-template name="tPageHeader"/>
			</fo:block>
		</fo:static-content>

		<fo:flow flow-name="xsl-region-body">
	      <fo:block font-size="14pt" 
	      		font-family="sans-serif" 
	      		font-weight="bold" 
	      		line-height="20pt"
	      		space-after.optimum="5pt"
	      		background-color="#ACC4D5"
	      		color="#224D78"
	      		text-align="center"
	      		>
                <!-- the error message -->
                <xsl:value-of select="." /> 

	      </fo:block> 
		</fo:flow>

		</fo:page-sequence>
	</xsl:for-each>

	</fo:root> 
</xsl:template>


<xsl:template name="tPageHeader">       

<fo:block font-size="8pt" color="#fff">

	<fo:table table-layout="fixed" width="19cm" height="1.52cm" 
						font-size="8pt" 
						background-repeat="no-repeat" 
						border-bottom-width="medium" border-bottom-color="#ffffff" border-bottom-style="solid">
		<fo:table-column column-width="18cm"/>
		<fo:table-column column-width="1cm"/>

		<fo:table-body>
			<fo:table-row>
				<fo:table-cell height="1.5cm">
				<fo:block text-align="right" padding-right="0.7cm" padding-top="0.7cm"  font-size="14pt">

	      	      Error Creating PDF

				</fo:block>
				</fo:table-cell>
				<fo:table-cell>
				<fo:block text-align="right" >
				</fo:block>
				</fo:table-cell>
			</fo:table-row>

		</fo:table-body>
	</fo:table>

</fo:block> 

</xsl:template>

</xsl:stylesheet>
 

