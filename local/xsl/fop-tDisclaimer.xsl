<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tDisclaimer.xsl#1 $ -->

<xsl:template name="tDisclaimer">	
<xsl:if test="/Report/@rptShowDisclaimer='Y'">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#EFEFEF" 
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="19cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<!-- CMU Localization === Change background-color 
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center"> -->
			<fo:table-cell background-color="#5D0022" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Block checkbox, Title -->
			<!-- CMU Localization === Change background-color 
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="1pt" display-align="center" > -->
			<fo:table-cell background-color="#5D0022" padding-left="5pt" padding-top="1pt" display-align="center" >
				<!-- CMU Localization === Change background-color 
				<fo:block font-size="10pt" keep-with-next.within-page="always"
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#5B788F"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
				-->
				<fo:block font-size="10pt" keep-with-next.within-page="always"
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						background-color="#5D0022"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						Disclaimer
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
		<!-- CMU Localization === Change background-color 
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"> -->
			<fo:table-cell background-color="#5D0022" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<fo:table-row>
		<!-- CMU Localization === Change color
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#555" > -->
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#000000" >
		<fo:block font-size="8pt">
		 <xsl:choose>
           <!--
            AA = academic audit
            FA = financial aid audit
            AE = athletic eligibility audit
           -->
           <xsl:when test="/Report/Audit/AuditHeader/@AuditType = 'FA'"> 
			You are encouraged to use this financial aid audit report as a guide when determining 
			your eligibility for your financial aid awards.  A financial aid officer 
			may be contacted for assistance in interpreting this report.  
			Send an email to help@aid.generic.edu.
			This audit is not your official financial aid status and 
			it is not official notification of financial aid awards.  
			Please contact the Financial Aid Office for more information.
		   </xsl:when>
           <xsl:when test="/Report/Audit/AuditHeader/@AuditType = 'AE'"> 
            You are encouraged to use this athletic eligibility audit report as a guide when determining your eligibility for your sport. 
            Someone in the athletic department may be contacted for assistance in interpreting this report. 
            Send an email to help@athletes.generic.edu. 
            This audit is not your official eligibility status and it is not official notification of eligibility. 
            Please contact the Athletic Department for more information. 
		   </xsl:when>
		   <xsl:otherwise>
		   <!-- CMU Localization === Replaced disclaimer text with CMU disclaimer
			You are encouraged to use this degree audit report as a guide when planning your progress toward completion of the above requirements. 
			Your academic advisor or the Registrar's Office may be contacted for assistance in interpreting this report. 
			This audit is not your academic transcript and it is not official notification of completion of degree or certificate requirements. 
			Please contact the Registrar's Office regarding this degree audit report, your official degree/certificate completion status, 
			or to obtain a copy of your academic transcript. 
			-->
			Degree Works evaluates completed and in-progress coursework against major requirements to determine progress toward the completion 
			of a degree. Changing your registration or completing a course with an unsatisfactory grade may impact your degree progress. should 
			meet regularly with your academic advisor to review degree progress and verify the accuracy of the Degree Works audit. It does not 
			constitute an official degree audit or an academic transcript. 
		   </xsl:otherwise>
		 </xsl:choose>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	</fo:table-body>
	</fo:table>

</xsl:if> 
</xsl:template>
 
</xsl:stylesheet>
