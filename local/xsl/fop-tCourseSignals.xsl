<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tCourseSignals.xsl#1 $ -->

<!-- CourseSignals grade or icon -->
<xsl:template name="tCourseSignalsGrade">
  <xsl:choose>
  <xsl:when test="$vShowCourseSignals='Y'">  
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
  <xsl:if test="$vShowCourseSignals='Y'">
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
   </xsl:if> <!-- red signal found -->
  </xsl:if> <!-- show-course-signals -->
</xsl:template>

 
</xsl:stylesheet>
