<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tFinancialAidData.xsl#3 $ -->

<xsl:template name="tFinancialAidData">

<fo:table table-layout="fixed" width="19cm" 
		background-color="#EFEFEF" 	space-before="0.3cm" space-after="0.3cm"
		border-spacing="0pt" font-size="8pt">

    <!-- Six columns: label+value; label+value; label+value
         Aid Term                 Spring 2012  		Aid Term Credits Attempted 12  		Aid Term Credits Earned   12
  		 Aid Year                 2012       		Aid Year Credits Attempted 32 		Aid Year Credits Earned   19
  		 Enroll Status            Full Time         Total Credits Attempted    12		Total Credits Earned      47
  		 Probation                OK                Completed Residence Terms  4		Residence Credits Earned  43
  		 Degree Credits Required  120               Total Grade Points         78 		Cumulative GPA            3.24
    -->
	<fo:table-column column-width="4.3cm"/>
	<fo:table-column column-width="2.0cm"/>
	<fo:table-column column-width="4.3cm"/>
	<fo:table-column column-width="2.0cm"/>
	<fo:table-column column-width="4.3cm"/>
	<fo:table-column column-width="2.1cm"/>

  <fo:table-body>

  <fo:table-row height=".1cm">
   <fo:table-cell number-columns-spanned="6"><fo:block/></fo:table-cell>
  </fo:table-row>

  <!-- "Financial Aid Factoids" -->
  <fo:table-row>  <!-- Row for making the header look nice (no content) -->
  	<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="6">
  		<fo:block font-size="12pt" >
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x">
    <fo:table-cell padding-left="5pt" padding-top="1pt" number-columns-spanned="6">
		 <fo:block font-size="10pt" 
		 		font-family="sans-serif" 
		 		line-height="18pt"
		 		space-after.optimum="15pt"
		 		color="#fff"
		 		text-align="center"
		 		padding-top="3pt"
		 		padding-bottom="0pt"
		 		padding-left="2pt">
		 <fo:inline font-weight="bold" >
		   Financial Aid Factoids
		 </fo:inline>
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <fo:table-row border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid">   <!-- Row for making the block header look nice (no content) -->
  	<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="6">
  		<fo:block font-size="12pt" >
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>

  <!-- Error message if no aidyear found -->
  <xsl:if test="count(Deginfo/Custom[@Value=FinancialAid/@AidYear]) = 0">
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
    <fo:table-cell padding-left="5pt" padding-top="1pt" number-columns-spanned="6">
		 <fo:block font-size="8pt" 
		 		font-family="sans-serif" 
		 		line-height="18pt"
		 		space-after.optimum="15pt"
		 		text-align="center"
		 		padding-top="3pt"
		 		padding-bottom="0pt"
		 		padding-left="2pt">
		 <fo:inline font-weight="bold" >
          The aid year specified is not currently active for this student. 
          Active aid year<xsl:if test="count(Deginfo/Custom[@Code='AIDYEAR']) > 1">s</xsl:if> for this student:
          <xsl:for-each select="Deginfo/Custom[@Code='AIDYEAR']">
            <xsl:value-of select="@Value"/><xsl:if test="position()!=last()">, </xsl:if>  
          </xsl:for-each>
		 </fo:inline>
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  </xsl:if>

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Aid Term
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="FinancialAid/@AidTermLit" />
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Aid Term <xsl:value-of select="/Report/@rptCreditsLiteral" /> Attempted
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="format-number(FinancialAid/@CreditsAttemptedThisTerm, '#.##')" />
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Aid Term <xsl:value-of select="/Report/@rptCreditsLiteral" /> Earned
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="format-number(FinancialAid/@CreditsEarnedThisTerm, '#.##')" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Aid Year
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="FinancialAid/@AidYear" />
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Aid Year <xsl:value-of select="/Report/@rptCreditsLiteral" /> Attempted
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@CreditsAttemptedThisAidYear, '#.##')" />  
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Aid Year <xsl:value-of select="/Report/@rptCreditsLiteral" /> Earned
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@CreditsEarnedThisAidYear, '#.##')" /> 
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Enroll Status
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:call-template name="tGetEnrollLiteral"><xsl:with-param name="sCode" select="Deginfo/Custom[@Code='ENROLLSTATUS']/@Value" /></xsl:call-template> 
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Total <xsl:value-of select="/Report/@rptCreditsLiteral" /> Attempted
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@TotalCreditsAttempted, '#.##')" /> 
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Total <xsl:value-of select="/Report/@rptCreditsLiteral" /> Earned
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@TotalCreditsEarned, '#.##')" /> 
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Probation
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
	        <xsl:value-of select="FinancialAid/@Probation" /> 
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Completed Residence Terms
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@ResidenceCompletedTermCount, '#.##')" /> 
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Residence <xsl:value-of select="/Report/@rptCreditsLiteral" /> Earned
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@ResidenceCreditsEarned, '#.##')" /> 
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Degree <xsl:value-of select="/Report/@rptCreditsLiteral" /> Required
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="Block/Header/Qualifier[@Node_type='4121']/@Credits" />  
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Total Grade Points
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@CumGradePoints, '#.##')" /> 
  		</fo:block>
  	</fo:table-cell>

  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Cumulative GPA
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
            <xsl:value-of select="format-number(FinancialAid/@CumGPA, '#.00')" />  
  		</fo:block>
  	</fo:table-cell>

  </fo:table-row>

  </fo:table-body>
</fo:table> 


</xsl:template> 

<xsl:template name="tGetEnrollLiteral">
<xsl:param name="sCode"  />

<xsl:choose>
	<xsl:when test="$sCode='THIS'">
		Show this literal
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$sCode" />
	</xsl:otherwise>
</xsl:choose>

</xsl:template> 
 

 
</xsl:stylesheet>
