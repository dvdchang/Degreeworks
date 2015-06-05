<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tProgressBar.xsl#3 $ -->

<!-- Credits progress bar and Requirements progress bar -->
<xsl:template name="tProgressBar"> 

<!-- /Report/Audit/AuditHeader/@Per_complete contains the percent complete -->

<xsl:if test="/Report/@rptShowProgressBar='Y'">
<fo:block text-align="center" >
<!--
<fo:block text-align="center" space-before.optimum="1cm" space-after.optimum="1cm" space-after="0.5cm">
-->

	<fo:inline color="#000000" font-size="10pt">
	<xsl:copy-of select="$LabelProgressBar" />
	</fo:inline>

	<xsl:if test="$vProgressBarPercent='Y'">
	<fo:table table-layout="fixed" width="14cm" 
				background-color="#5B788F" background-image="../images/progress-dark.gif" background-repeat="repeat-x"
				border-spacing="0pt" font-size="9pt"
				start-indent="0.1cm" end-indent="0.1cm">

	<!-- for the 'Requirements' label -->
	<fo:table-column column-width="proportional-column-width(22)"/> 
	<!-- TODO: figure out the smallest available and if the Per_complete is less than or equal to that 
	     value then hardcode the proportional width to that value-->

	<xsl:variable name="vStudentPercentCompleteDecimal">
	<xsl:value-of select=".01 * AuditHeader/@Per_complete" />
	</xsl:variable>

	<fo:table-column > 
		<xsl:if test="AuditHeader/@Per_complete = 0">
			<xsl:attribute name="column-width"> proportional-column-width(0) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete = 100">
			<xsl:attribute name="column-width"> proportional-column-width(78) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete &gt; 0">
		<xsl:if test="AuditHeader/@Per_complete &lt; 100">
			<xsl:attribute name="column-width">
			   proportional-column-width(<xsl:value-of select="100 * ($vStudentPercentCompleteDecimal * .78)" />)
			</xsl:attribute>
		</xsl:if>
		</xsl:if>

	</fo:table-column > 
	<fo:table-column > 
		<xsl:if test="AuditHeader/@Per_complete = 0">
			<xsl:attribute name="column-width"> proportional-column-width(78) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete = 100">
			<xsl:attribute name="column-width"> proportional-column-width(0) </xsl:attribute>
		</xsl:if>
		<xsl:if test="AuditHeader/@Per_complete &gt; 0">
		<xsl:if test="AuditHeader/@Per_complete &lt; 100">
			<xsl:attribute name="column-width">
			   proportional-column-width(<xsl:value-of select="(100 - AuditHeader/@Per_complete) * .78" />)
			</xsl:attribute>
		</xsl:if>
		</xsl:if>
	</fo:table-column> 

	
	<fo:table-body>

		<fo:table-row>
			<fo:table-cell background-color="#FFFFFF" color="#000000">
				<fo:block>
					Requirements
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#5B788F" background-image="../images/progress-light.gif" background-repeat="repeat-x" color="#000000">
				<fo:block>
					<xsl:value-of select='format-number(AuditHeader/@Per_complete, "#")' />% <!-- was #.0 but Mike wants no decimals -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</fo:table-body>
	</fo:table>
	</xsl:if> <!-- test="$vProgressBarPercent='Y'" -->

	<xsl:if test="$vProgressBarCredits='Y'">
	<xsl:choose>
	<xsl:when test="Block[1]/Header/Qualifier[@Node_type='4121']">

	<xsl:variable name="vOverallCreditsRequired">
	  <xsl:call-template name="tCreditsRequired" />   <!-- 50 -->
	</xsl:variable>

	<xsl:variable name="vOverallCreditsApplied">
        <xsl:choose>
        <xsl:when test="AthleticEligibility">
         <xsl:value-of select="AthleticEligibility/CREDITSAPPLIEDTOWARDSDEGREE/@Credits" />
        </xsl:when>
        <xsl:when test="Block[1]/Header/Qualifier/CREDITSAPPLIEDTOWARDSDEGREE">
         <xsl:value-of select="Block[1]/Header/Qualifier/CREDITSAPPLIEDTOWARDSDEGREE/@Credits" />
        </xsl:when>
        <xsl:otherwise>
 	      <xsl:value-of select="Block[1]/@Credits_applied" />  <!-- Credits_applied="202.5" -->
        </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>

	<xsl:variable name="vOverallCreditsPercentComplete">
		<xsl:choose>
		<xsl:when test="100 * ($vOverallCreditsApplied div $vOverallCreditsRequired) &gt; 100">100</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="100 * ($vOverallCreditsApplied div $vOverallCreditsRequired)" />
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="vOverallCreditsPercentCompleteDisplay">
      <xsl:value-of select="$vOverallCreditsPercentComplete" />
	</xsl:variable>

	<xsl:variable name="vOverallCreditsPercentCompleteDecimal">
	  <xsl:value-of select=".01 * $vOverallCreditsPercentComplete" />
	</xsl:variable>

	<fo:table table-layout="fixed" width="14cm" 
				background-color="#5B788F" background-image="../images/progress-dark.gif" background-repeat="repeat-x"
				border-spacing="0pt" font-size="9pt"
				start-indent="0.1cm" end-indent="0.1cm">

	<!-- for the 'Requirements' label -->
	<fo:table-column column-width="proportional-column-width(22)"/> 
	<!-- TODO: figure out the smallest available and if the Per_complete is less than or equal to that 
	     value then hardcode the proportional width to that value-->

	<fo:table-column > 
		<xsl:if test="$vOverallCreditsPercentComplete = 0">
			<xsl:attribute name="column-width"> proportional-column-width(0) </xsl:attribute>
		</xsl:if>
		<xsl:if test="$vOverallCreditsPercentComplete = 100">
			<xsl:attribute name="column-width"> proportional-column-width(78) </xsl:attribute>
		</xsl:if>
		<xsl:if test="$vOverallCreditsPercentComplete &gt; 0">
		<xsl:if test="$vOverallCreditsPercentComplete &lt; 100">
			<xsl:attribute name="column-width">
			   proportional-column-width(<xsl:value-of select="100 * ($vOverallCreditsPercentCompleteDecimal * .78)" />)
			</xsl:attribute>
		</xsl:if>
		</xsl:if>

	</fo:table-column > 
	<fo:table-column > 
		<xsl:if test="$vOverallCreditsPercentComplete = 0">
			<xsl:attribute name="column-width"> proportional-column-width(78) </xsl:attribute>
		</xsl:if>
		<xsl:if test="$vOverallCreditsPercentComplete = 100">
			<xsl:attribute name="column-width"> proportional-column-width(0) </xsl:attribute>
		</xsl:if>
		<xsl:if test="$vOverallCreditsPercentComplete &gt; 0">
		<xsl:if test="$vOverallCreditsPercentComplete &lt; 100">
			<xsl:attribute name="column-width">
			   proportional-column-width(<xsl:value-of select="(100 - $vOverallCreditsPercentComplete) * .78" />)
			</xsl:attribute>
		</xsl:if>
		</xsl:if>
	</fo:table-column> 

	
	<fo:table-body>

		<fo:table-row>
			<fo:table-cell background-color="#FFFFFF" color="#000000">
				<fo:block>
					<xsl:value-of select="/Report/@rptCreditsLiteral" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell background-color="#5B788F" background-image="../images/progress-light.gif" background-repeat="repeat-x" color="#000000">
				<fo:block>
          <xsl:choose>
           <xsl:when test="$vOverallCreditsPercentCompleteDisplay &gt;= 100">
                100%
	         </xsl:when>
           <xsl:when test="AthleticEligibility">
             <xsl:copy-of select='substring($vOverallCreditsPercentCompleteDisplay,1,2)' />% <!--  truncate per NCAA rules -->
           </xsl:when>
           <xsl:otherwise>
           		<xsl:value-of select='format-number($vOverallCreditsPercentCompleteDisplay, "#")' />% <!-- was #.0 but Mike wants no decimals -->
           </xsl:otherwise>
          </xsl:choose>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</fo:table-body>
	</fo:table>

	</xsl:when>
	<xsl:otherwise /> <!-- do nothing. No credits rule in the starter block so no data to use to calculate credits pct complete -->
	</xsl:choose>
	</xsl:if> <!-- test="$vProgressBarCredits='Y'" -->

</fo:block >
</xsl:if> <!-- test="/Report/@rptShowProgressBar='Y'" -->

<!-- CMU Localization === Progress bar disclaimer ============================================================================================ -->
	<fo:table table-layout="fixed" width="19cm" 
			background-color="#EFEFEF" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="19cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#F1EFED" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

	<fo:table-row>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#000000" >
		<fo:block font-size="8pt">
			The percentages above are calculated from the number of check boxes completed not actual degree completion. 
			Completing 100% of the credits and/or requirements is not official notification of degree completion. 
			You must meet with your advisor to determine if all degree requirements have been met. Click on the Help 
			link in the top bar for more details. 
		</fo:block>
		</fo:table-cell>
	</fo:table-row>
	</fo:table-body>
	</fo:table>
<!-- CMU Localization === End of Progress bar disclaimer ===================================================================================== -->

</xsl:template> 
 
</xsl:stylesheet>
