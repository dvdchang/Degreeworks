<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tAthleteFactoids.xsl#3 $ -->

<!-- Athletic Eligibility Factoids -->
<xsl:template name="tAthleteFactoids"> 

<fo:table table-layout="fixed" width="16cm" 
		background-color="#EFEFEF" 	space-before="0.3cm" space-after="0.3cm"
		border-spacing="0pt" font-size="8pt">
	<fo:table-column column-width="6.0cm"/>
	<fo:table-column column-width="2.0cm"/>
	<fo:table-column column-width="6.0cm"/>
	<fo:table-column column-width="2.0cm"/>

  <fo:table-body>

  <fo:table-row height=".1cm">
   <fo:table-cell number-columns-spanned="4"><fo:block/></fo:table-cell>
  </fo:table-row>

  <fo:table-row>  <!-- Row for making the header look nice (no content) -->
  	<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="4">
  		<fo:block font-size="12pt" >
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x">
    <fo:table-cell padding-left="5pt" padding-top="1pt" number-columns-spanned="4">
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
		   Athletic Eligibility Factoids
		 </fo:inline>
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <fo:table-row border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid">  <!-- Row for making the block header look nice (no content) -->
  	<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4">
  		<fo:block font-size="12pt" >
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>

  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 1: Prev Term Credits, Prev 2 Term Credits -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Previous Term <xsl:value-of select="/Report/@rptCreditsLiteral" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/PREVIOUSTERMEARNEDCREDITS/@Credits" />  
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Previous 2 Terms <xsl:value-of select="/Report/@rptCreditsLiteral" /> <!-- change this to "3" for quarter schools -->
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/PREVIOUS2TERMSEARNEDCREDITS/@Credits" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 2: Previous Academic Year Credits and First Year Credits -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Previous Academic Year <xsl:value-of select="/Report/@rptCreditsLiteral" /> 
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/PREVIOUSACADEMICYEAREARNEDCREDITS/@Credits" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		First Year <xsl:value-of select="/Report/@rptCreditsLiteral" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/FIRSTYEAREARNEDCREDITS/@Credits" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 3: Previous Term and Active Term -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Previous Term
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/@PreviousTermLit" /> 
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Active Term
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/@ActiveTermLit" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 4: Credits Applied Towards Degree and Credits Required to Graduate -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Credits Applied Towards Degree
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/CREDITSAPPLIEDTOWARDSDEGREE/@Credits" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Credits Required to Graduate
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/ECA-Overall/@Credits" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 5: Total Credits Attempted and Total Credits Earned -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Total <xsl:value-of select="/Report/@rptCreditsLiteral" /> Attempted
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="format-number(AthleticEligibility/@TotalCreditsAttempted, '#.##')" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Total <xsl:value-of select="/Report/@rptCreditsLiteral" /> Earned
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="format-number(AthleticEligibility/@TotalCreditsEarned, '#.##')" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 6: Total Grade Points and Cumulative GPA -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Total Grade Points
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="format-number(AthleticEligibility/@CumGradePoints, '#.##')" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Cumulative GPA
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="format-number(AthleticEligibility/@CumGPA, '#.00')" />
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 7: Completed Term Count and Cumulative GPA -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Residence Completed Term Count
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
  			<xsl:value-of select="AthleticEligibility/@ResidenceCompletedTermCount" />
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Academic Standing
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
         <!-- use the report ACADSTANDESC if found; else - just use the ACADSTANDING custom data -->
         <xsl:choose>
         <xsl:when test="Deginfo/Report[@Code='ACADSTANDESC']">
           <xsl:value-of select="Deginfo/Report[@Code='ACADSTANDESC']/@Value" />
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="Deginfo/Custom[@Code='ACADSTANDING']/@Value" />
         </xsl:otherwise>
         </xsl:choose>
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Row 8: Participating Sports and (nothing) -->
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Participating Sports
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
         <!-- use the report SPORTDESC if found; else - just use the SPORT custom data -->
         <xsl:choose>
         <xsl:when test="Deginfo/Report[@Code='SPORTDESC']">
          <xsl:for-each select="Deginfo/Report[@Code='SPORTDESC']">
            <xsl:sort select="@Value"  order="ascending"/>
              <xsl:choose>
              <!-- Suppress duplicate sports -->
              <xsl:when test="(@Code=preceding-sibling::Report/@Code) and (@Value=preceding-sibling::Report/@Value)"/>
              <xsl:otherwise>
                <xsl:value-of select="@Value" />  <xsl:if test="position()!=last()">; </xsl:if>
              </xsl:otherwise>
              </xsl:choose>              
          </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
          <xsl:for-each select="Deginfo/Custom[@Code='SPORT']">
            <xsl:sort select="@Value"  order="ascending"/>
              <xsl:value-of select="@Value" /> <xsl:if test="position()!=last()">; </xsl:if>
          </xsl:for-each>
         </xsl:otherwise>
         </xsl:choose>
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
		First Date of Attendance
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify">
        <xsl:call-template name="FormatDate">
		  <xsl:with-param name="pDate" select="Deginfo/Custom[@Code='AEAFIRSTDATE']/@Value" />
        </xsl:call-template>
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
 <!-- xxxxxxxxxxx NEXT ROW xxxxxxxxxxx -->
  <!-- Football 9 HR/APR E Point  - aka AEASTATUS -->
  <!-- hide if not a football player -->
  <!-- hide if AEASTATUS not setup in SCR002 (but it will be missing if aea-status field in the db is blank) -->
  <xsl:if test="Deginfo/Custom[@Code='SPORT']/@Value = 'FOOTBALL' and $vShowFootballStatus = 'Y'">
  <fo:table-row height="0.50cm" border-bottom-width="thin" border-bottom-color="#ffffff" border-bottom-style="solid"> 
  	<fo:table-cell background-color="#D2E2EE" padding-left="5pt" padding-top="1pt" display-align="center" >
  		<fo:block text-align="justify" font-weight="bold" color="#316C92"  >
  		Football 9 HR/APR E Point 
  		</fo:block>
  	</fo:table-cell>
  	<fo:table-cell background-color="#F0F0F0" padding-left="5pt" padding-top="1pt" display-align="center" number-columns-spanned="3" >
  		<fo:block text-align="justify">
      <xsl:choose>
      <!-- if the active term is FALL then show the status of the current ATHLETE blocks -->
      <xsl:when test="AthleticEligibility/@ActiveTermType='FALL'" >
         <!-- show success only if all ATHLETE blocks are complete -->
         <xsl:variable name="vBlocksComplete">
           <xsl:if test="Block[@Req_type='ATHLETE']/@Per_complete &lt; 100">N</xsl:if>
         </xsl:variable>
          <xsl:choose>
          <xsl:when test="$vBlocksComplete = 'N'" >
            <fo:block color="red">Failed</fo:block> 
          </xsl:when>
          <xsl:otherwise>
            Passed
          </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      
      <xsl:otherwise> <!-- not fall - get status calculated from a previous fall audit -->
        <xsl:variable name="vFallTerm">
          <xsl:value-of select="AthleticEligibility/PREVIOUSTERMEARNEDCREDITS-FALL/@TermLit" />
        </xsl:variable>
        <xsl:choose>
        <xsl:when test="Deginfo/Custom[@Code='AEASTATUS']/@Value = 'FAILED'" >
          <fo:inline color="red">Failed</fo:inline>  (as of <xsl:value-of select="$vFallTerm" />)
        </xsl:when>
        <xsl:when test="Deginfo/Custom[@Code='AEASTATUS']/@Value = 'PASSED'" >
          Passed (as of <xsl:value-of select="$vFallTerm" />)
        </xsl:when>
        <xsl:otherwise>
          (unknown)
        </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
      </xsl:choose>
  		</fo:block>
  	</fo:table-cell>
  </fo:table-row>
  </xsl:if>
  
  </fo:table-body>
</fo:table> 

</xsl:template> <!-- ATHLETE FACTOIDS end -->
 
</xsl:stylesheet>
