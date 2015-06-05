<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tBlocks.xsl#10 $ -->

<xsl:template name="tBlocks">
     <xsl:call-template name="tBlocksAcademicOnly" />
</xsl:template>

<xsl:template name="tBlocksAcademicOnly">
  <xsl:for-each select="Block[@Req_type != 'ATHLETE' and @Req_type != 'AWARD' ]">
      <xsl:call-template name="tBlock" />
  </xsl:for-each>
</xsl:template>

<xsl:template name="tBlocksAthleteOnly">
  <xsl:for-each select="Block[@Req_type = 'ATHLETE'] ">
    <xsl:sort select="@Title"  order="ascending"/>
    <xsl:call-template name="tBlock" />
  </xsl:for-each> 
</xsl:template>

<xsl:template name="tBlocksAwardOnly">
  <xsl:for-each select="Block[@Req_type = 'AWARD'] ">
    <xsl:sort select="@Title"  order="ascending"/>
    <xsl:call-template name="tBlock" />
  </xsl:for-each>
</xsl:template>

<xsl:template name="tBlock">
		<fo:table table-layout="fixed" width="19cm"
				background-color="#fff" space-before="0.3cm" space-after="0.3cm"
				border-spacing="0pt" font-size="8pt" 
				>
			<fo:table-column column-width="1.5cm"/>
			<fo:table-column column-width="6.5cm"/>
			<fo:table-column column-width="2.5cm"/>
			<fo:table-column column-width="8.5cm"/>

			<fo:table-body>

			<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			    <!-- CMU Localization === Changed background-color 
				<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="4" display-align="center"> -->
				<fo:table-cell background-color="#5D0022" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="4" display-align="center"> 
					<fo:block font-size="12pt" keep-with-next.within-page="always">
					</fo:block>
				</fo:table-cell>
			</fo:table-row>

			<xsl:call-template name="tBlockHeaderChoose"/>

			<fo:table-row > <!-- Row for making the block header look nice (no content) -->
				<!-- CMU Localization === Changed background-color 
				<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center"> -->
				<fo:table-cell background-color="#5D0022" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
					<fo:block font-size="12pt" >
					</fo:block>
				</fo:table-cell>
			</fo:table-row>

<!--//////////////////////////////////////////////////// 
	// Header Qualifier Advice						-->
			<xsl:if test="/Report/@rptShowQualifierAdvice='Y'">
	      <xsl:if test="Header/Advice"> 
				<xsl:call-template name="tHeaderQualifierAdvice"/>
			  </xsl:if>
			</xsl:if>  
      <!-- For qualifiers with labels, show a checkbox and the label along with the advice -->
      <xsl:call-template name="tHeaderQualifierLabels"/>

<!--//////////////////////////////////////////////////// 
	// Block Remarks Rows							-->
			<xsl:if test="/Report/@rptShowBlockRemarks='Y'">
				<xsl:call-template name="tBlockRemarks"/>
			</xsl:if>  

<!--//////////////////////////////////////////////////// 
  // Block Exceptions             -->
   <xsl:if test="/Report/@rptShowBlockExceptions='Y'">
      <xsl:call-template name="tBlockExceptions"/>
   </xsl:if>  
   
<!--//////////////////////////////////////////////////// 
	// Block Qualifier Rows							-->
	<xsl:if test="/Report/@rptShowQualifierText='Y'">
	<xsl:if test="Header/Qualifier"> 
		<xsl:call-template name="tBlockQualifiers"/>
	</xsl:if>
	</xsl:if>  

<!--//////////////////////////////////////////////////// 
	// Rule Rows									-->
			<xsl:for-each select=".//Rule">
				<xsl:if test="@RuleType != 'IfStmt'">
				<xsl:if test="@RuleType != 'IncludeBlocks'">
        <xsl:if test="@RuleType != 'Subset' or /Report/@rptHideSubsetLabels='N'">
				<xsl:if test="@Per_complete != 'Not Used'">
				<xsl:if test="@Per_complete != 'Not Needed'">

		          <xsl:choose>
                  <xsl:when test="/Report/@rptShowRuleText='N' and
		                          ancestor::Rule[*]/@RuleType  = 'Group' and 
                                  ancestor::Rule[*]/@Per_complete = '100' and @Per_complete!='100'">
                    <!-- do not show the labels for the rules within the group that is already completed -->
                  </xsl:when>
		          
                  <xsl:when test="/Report/@rptShowRuleText='N' and
		                          ancestor::Rule[*]/@RuleType  = 'Group' and 
                                  ancestor::Rule[*]/@Per_complete = '98' and not(@Per_complete='100' or @Per_complete='98')">
                    <!-- do not show the labels for the rules within the group that is already completed -->
                  </xsl:when>

                  <!-- When there is an ancestor node, check to see if any of them are 
                        "Not Needed" If so, do not show the rule.  This happens in nested group rules. -->
                  <xsl:when test="ancestor::Rule and ancestor::Rule[*]/@Per_complete  = 'Not Needed'"> 
                    <!-- Do nothing -->
                  </xsl:when>
		          
                  <xsl:when test="/Report/@rptShowRuleText='N' and
		                              ancestor::Rule[*]/@RuleType  = 'Subset' and 
                                  ancestor::Rule[*]/@Per_complete = '100' and @Per_complete!='100'">
                    <!-- do not show the labels for the rules within the group that is already completed -->
                  </xsl:when>

		          <!-- block rule - block is missing -->
             <xsl:when test="Advice/BlockID/. = 'NOT_FOUND' and Requirement/Qualifier/@Name != 'HIDERULE' and Requirement/Qualifier/@Node_type != 'HideRule'"> 
              <xsl:call-template name="tRules"/>
             </xsl:when>
                  
             <xsl:when test="Requirement/Qualifier/@Name = 'HIDERULE' or Requirement/Qualifier/@Node_type = 'HideRule' ">
                <xsl:choose>
                  <xsl:when test="(@RuleType = 'Block' or @RuleType = 'Blocktype') and not (Advice)">
                    <!-- hide the block or blocktype rule - there is no advice node - probably it is 100% complete -->
                 </xsl:when>
                 <xsl:when test="@RuleType = 'Block' and Advice/BlockID/. = 'NOT_FOUND'">
                    <!-- Block is missing; it is important to see that the block is missing -->                          
                    <xsl:call-template name="tRules"/>
                 </xsl:when>
                 <xsl:when test="@RuleType = 'Blocktype' and count(Advice/Title) = 0">
                    <!-- Blocktype is missing; it is important to see that the block is missing -->                          
                    <xsl:call-template name="tRules"/>
                 </xsl:when>
                 <xsl:when test="@RuleType = 'Block' and Advice/BlockID/. != 'NOT_FOUND'">
                    <!-- hide the block rule - block was found; regardless of it being 0% or 50% complete -->
                 </xsl:when>
                 <xsl:when test="@RuleType = 'Blocktype' and Advice/Title">
                    <!-- hide the blocktype rule - block was found; regardless of it being 0% or 50% complete -->
                 </xsl:when>         
                 <xsl:when test="/Report/@rptShowRuleText = 'Y' or @Per_complete &gt; 0">
                    <xsl:call-template name="tRules"/>
                 </xsl:when>
                </xsl:choose>
              </xsl:when>
		                    
		          <!-- Check to see if this rule is within a group rule that has HideRule.
		               We check the parent group rule up to 4 levels deep (hence the 0, 1, 2, 3 numbers in Rule[x] -->
                  <!-- hide the group rule options for hidden group rule that is 0% complete -->
              <xsl:when test="(ancestor::Rule[0]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[0]/Requirement/Qualifier/@Node_type = 'HideRule') and
                              ancestor::Rule[0]/@RuleType = 'Group' and 
                              ancestor::Rule[0]/@Per_complete = '0'">
                <!-- hide it -->
              </xsl:when>
              <!-- hide the group rule options for hidden group rule that is 0% complete -->
              <xsl:when test="(ancestor::Rule[1]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[1]/Requirement/Qualifier/@Node_type = 'HideRule') and
                              ancestor::Rule[1]/@RuleType = 'Group' and 
                              ancestor::Rule[1]/@Per_complete = '0'">
                <!-- hide it -->
              </xsl:when>
              <!-- hide the group rule options for hidden group rule that is 0% complete -->
              <xsl:when test="(ancestor::Rule[2]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[2]/Requirement/Qualifier/@Node_type = 'HideRule') and        
                              ancestor::Rule[2]/@RuleType = 'Group' and 
                              ancestor::Rule[2]/@Per_complete = '0'">
                <!-- hide it -->
              </xsl:when>
              <!-- hide the group rule options for hidden group rule that is 0% complete -->
              <xsl:when test="(ancestor::Rule[3]/Requirement/Qualifier/@Name = 'HIDERULE' or ancestor::Rule[3]/Requirement/Qualifier/@Node_type = 'HideRule') and
                              ancestor::Rule[3]/@RuleType = 'Group' and 
                              ancestor::Rule[3]/@Per_complete = '0'">
                <!-- hide it -->
              </xsl:when>
		          
		          <xsl:otherwise>
		          	<xsl:call-template name="tRules"/>
		          </xsl:otherwise>
		          </xsl:choose>

				</xsl:if> 
				</xsl:if> 
        </xsl:if> 
				</xsl:if> 
				</xsl:if> 
			</xsl:for-each> 

			</fo:table-body>
		</fo:table>

</xsl:template> <!-- tblock -->


<xsl:template name="tBlockHeaderChoose">

<!--// here are the different attributes you can use to locate a block or
	// group of blocks:
	//   @Req_id				@Title				@Cat_yr
	//	 @Req_type				@Per_complete		@Cat_yrLit
	//   @Req_value				@Cat_yr_start		
	//   @BS					@Cat_yr_stop		@GPA
	//   @Degree				@Major				@Gpa_credits
	//	 @Classes_applied		@Credits_applied	@Gpa_grade_pts
-->
	<xsl:choose>
		<xsl:when test="@Req_type = 'ATHLETE'">  
					<xsl:call-template name="tBlockHeader_Athlete"/>
		</xsl:when>
		<xsl:when test="@Req_type = 'AWARD'">  
					<xsl:call-template name="tBlockHeader_Award"/>
		</xsl:when>

		<xsl:when test="@Req_type = 'OTHER'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'GENED'">  
					<!-- OTHER GENED blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- OTHER blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="@Req_type = 'DEGREE'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'BS'">  
					<!-- DEGREE BS blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- DEGREE blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="@Req_type = 'MAJOR'">  
			<xsl:choose>
				<xsl:when test="@Req_value = 'CS'">  
					<!-- MAJOR CS blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- MAJOR blocks -->
					<xsl:call-template name="tBlockHeader"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:otherwise>
			<xsl:call-template name="tBlockHeader"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> 

 <xsl:template name="tBlockHeader">
     <!-- CMU Localization === Changed background-color and remove background-image
	 <fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
	 <fo:table-row background-color="#5D0022">
	 <!-- Block checkbox, Title -->
		<fo:table-cell padding-left="2pt" padding-top="0pt" number-columns-spanned="4"  display-align="center">
			<fo:block font-size="9pt" 
					font-family="sans-serif" 
					line-height="12pt"
					color="#fff"
					text-align="justify"
					padding-top="0pt"
					padding-bottom="0pt"
					padding-left="2pt" keep-with-next.within-page="always">


			<!-- TODO Create a table for the block header information -->
			<fo:table table-layout="fixed" width="18cm" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="0.5cm"/>
				<fo:table-column column-width="11cm"/>
				<fo:table-column column-width="6.5cm"/>
				
				<fo:table-body>
				<fo:table-row>
					<fo:table-cell display-align="center">
					<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
						<xsl:choose>
							<xsl:when test="@Per_complete = 100">  
								<fo:external-graphic width="0.36cm" height="0.36cm"  src="../images/dwcheckyes.gif " />
							</xsl:when>
							<xsl:when test="@Per_complete = 99">  
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck99.gif" />
							</xsl:when>
							<xsl:when test="@Per_complete = 98">  
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck98.gif" />
							</xsl:when>
							<xsl:otherwise>
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="left" display-align="center">
						<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
							&#160; <xsl:value-of select="@Title"/>
					</fo:block>
					</fo:table-cell>

					<fo:table-cell text-align="right" display-align="center">
					<fo:block keep-with-next.within-page="always">

					<fo:table table-layout="fixed" width="6.5cm" padding-top="0pt" padding-bottom="0pt" padding-left="0pt" padding-right="0pt" border-spacing="0pt" font-size="6pt">
					<fo:table-column column-width="1.5cm"/>
					<fo:table-column column-width="1.5cm"/>
					<fo:table-column column-width="3cm"/>
					<fo:table-column column-width="0.9cm"/>

					<fo:table-body>
						<fo:table-row>
							<!-- CMU Localization === Replace Catalog year with GPA 
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								Catalog Year: 
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								<xsl:value-of select="@Cat_yrLit"/> 
							</fo:block>
							</fo:table-cell>
							-->
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								GPA:
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								<xsl:value-of select="@GPA"/> 
							</fo:block>
							</fo:table-cell>
							<!-- CMU Localization === End of Replace Catalog year with GPA -->
								<xsl:call-template name="tCheckCreditsClasses-Required"/>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
							   <!-- CMU Localization === Do not display GPA here
								GPA: -->
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								<!-- CMU Localization === Do not display GPA here
								<xsl:value-of select="@GPA"/>  -->
							</fo:block>
							</fo:table-cell>
							<xsl:call-template name="tCheckCreditsClasses-Applied"/>
						</fo:table-row>
					</fo:table-body>
					</fo:table>
					
					
					</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
			</fo:table>

			</fo:block> 
		</fo:table-cell>
	</fo:table-row>
</xsl:template>

<!-- CMU Localization === Create Block Header for Degree -->
 <xsl:template name="tBlockHeader_Degree">
     <!-- CMU Localization === Changed background-color and remove background-image
	 <fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
	 <fo:table-row background-color="#5D0022">
	 <!-- Block checkbox, Title -->
		<fo:table-cell padding-left="2pt" padding-top="0pt" number-columns-spanned="4"  display-align="center">
			<fo:block font-size="9pt" 
					font-family="sans-serif" 
					line-height="12pt"
					color="#fff"
					text-align="justify"
					padding-top="0pt"
					padding-bottom="0pt"
					padding-left="2pt" keep-with-next.within-page="always">


			<!-- TODO Create a table for the block header information -->
			<fo:table table-layout="fixed" width="18cm" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="0.5cm"/>
				<fo:table-column column-width="11cm"/>
				<fo:table-column column-width="6.5cm"/>
				
				<fo:table-body>
				<fo:table-row>
					<fo:table-cell display-align="center">
					<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
						<xsl:choose>
							<xsl:when test="@Per_complete = 100">  
								<fo:external-graphic width="0.36cm" height="0.36cm"  src="../images/dwcheckyes.gif " />
							</xsl:when>
							<xsl:when test="@Per_complete = 99">  
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck99.gif" />
							</xsl:when>
							<xsl:when test="@Per_complete = 98">  
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck98.gif" />
							</xsl:when>
							<xsl:otherwise>
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="left" display-align="center">
						<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
							&#160; <xsl:value-of select="@Title"/>
					</fo:block>
					</fo:table-cell>

					<fo:table-cell text-align="right" display-align="center">
					<fo:block keep-with-next.within-page="always">

					<fo:table table-layout="fixed" width="6.5cm" padding-top="0pt" padding-bottom="0pt" padding-left="0pt" padding-right="0pt" border-spacing="0pt" font-size="6pt">
					<fo:table-column column-width="1.5cm"/>
					<fo:table-column column-width="1.5cm"/>
					<fo:table-column column-width="3cm"/>
					<fo:table-column column-width="0.9cm"/>

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								Catalog Year: 
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
								<xsl:value-of select="@Cat_yrLit"/> 
							</fo:block>
							</fo:table-cell>
								<xsl:call-template name="tCheckCreditsClasses-Required"/>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
							    <!-- CMU Localization === Remove GPA 
								GPA: -->
							</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" text-align="right" >
							<fo:block keep-with-next.within-page="always">
							    <!-- CMU Localization === Remove GPA 
								<xsl:value-of select="@GPA"/> -->
							</fo:block>
							</fo:table-cell>
							<xsl:call-template name="tCheckCreditsClasses-Applied"/>
						</fo:table-row>
					</fo:table-body>
					</fo:table>
					
					
					</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
			</fo:table>

			</fo:block> 
		</fo:table-cell>
	</fo:table-row>
</xsl:template>
<!-- CMU Localization === End of Create Block Header for Degree -->


<xsl:template name="tBlockHeader_Athlete">
   <xsl:call-template name="tBlockHeader_TitleOnly"/>
</xsl:template>
<xsl:template name="tBlockHeader_Award">
   <xsl:call-template name="tBlockHeader_TitleOnly"/>
</xsl:template>
<!-- Show the block title only - no credits or catalog info -->
<xsl:template name="tBlockHeader_TitleOnly">
     <!-- CMU Localization === Changed background-color and remove background-image
	 <fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
	 <fo:table-row background-color="#5D0022"> <!-- Block checkbox, Title -->
		<fo:table-cell padding-left="2pt" padding-top="0pt" number-columns-spanned="4"  display-align="center">
			<fo:block font-size="9pt" 
					font-family="sans-serif" 
					line-height="12pt"
					color="#fff"
					text-align="justify"
					padding-top="0pt"
					padding-bottom="0pt"
					padding-left="2pt" keep-with-next.within-page="always">


			<fo:table table-layout="fixed" width="18cm" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="0.5cm"/>
				<fo:table-column column-width="11cm"/>
				<fo:table-column column-width="6.5cm"/>
				
				<fo:table-body>
				<fo:table-row>
					<fo:table-cell display-align="center">
					<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
						<xsl:choose>
							<xsl:when test="@Per_complete = 100">  
								<fo:external-graphic width="0.36cm" height="0.36cm"  src="../images/dwcheckyes.gif " />
							</xsl:when>
							<xsl:when test="@Per_complete = 99">  
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck99.gif" />
							</xsl:when>
							<xsl:when test="@Per_complete = 98">  
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck98.gif" />
							</xsl:when>
							<xsl:otherwise>
								<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="left" display-align="center">
						<fo:block font-weight="bold" keep-with-next.within-page="always" display-align="center">
							&#160; <xsl:value-of select="@Title"/>
					</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
			</fo:table>


			</fo:block> 
		</fo:table-cell>
	</fo:table-row>
</xsl:template> <!-- end tBlockHeader_Athlete -->

<!-- For each block header qualifer that has a label - show a checkbox and label and advice -->
<xsl:template name="tHeaderQualifierLabels">
<xsl:for-each select="Header/Qualifier[@Label]">
	 <fo:table-row border-bottom-width="medium" border-bottom-color="#ffffff" border-bottom-style="solid">
             <xsl:attribute name="background-color">
					 <xsl:value-of select="'#FFFFFF'"/> <!-- white -->
			 </xsl:attribute>
		 <fo:table-cell number-columns-spanned="4">
		  <fo:block>
		   <fo:table table-layout="fixed" width="19cm" space-before="0.3cm" border-spacing="0pt" font-size="8pt">
			<fo:table-column column-width="2.3cm"/>
			<fo:table-column column-width="5.7cm"/>
			<fo:table-column column-width="2.5cm"/>
			<fo:table-column column-width="8.5cm"/>

			<fo:table-body>
			  <fo:table-row>

		     <!-- CHECKBOX + LABEL -->
				<!-- CHECKBOX -->
				<fo:table-cell padding-left="2pt" padding-top="0.1pt" padding-bottom="0.0pt"
									 display-align="center" >
				 <fo:block font-size="8pt"
									 font-family="sans-serif"
									 color="#316C92"
									 line-height="15pt"
									 space-after.optimum="3pt"
									 text-align="left"  >
					 <xsl:choose>
				     <xsl:when test="@Satisfied='Yes'">  
							 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckyes.gif " />
						 </xsl:when>
						 <xsl:otherwise>
							 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
						 </xsl:otherwise>
					 </xsl:choose>
				 </fo:block>
				</fo:table-cell>
				<!-- END CHECKBOX -->

				<!-- LABEL -->
				<fo:table-cell display-align="center">
				 <fo:block>
					 <xsl:choose> <!-- use choose to allow us to change the look later -->
						<xsl:when test="@Satisfied='Yes'">  
						     <xsl:value-of select="@Label"/>
						 </xsl:when>
						 <xsl:otherwise>
							 <xsl:value-of select="@Label"/>
						 </xsl:otherwise>
					 </xsl:choose>
				 </fo:block>
				</fo:table-cell>
		        <!-- END LABEL -->

		    <!-- ADVICE -->
            <!-- table for "Reason" and advice text -->
			<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="2"  display-align="center">
			 <fo:block font-size="8pt"
								 font-family="sans-serif"
								 line-height="15pt"
								 space-after.optimum="3pt"
								 text-align="justify" >
		         <fo:table table-layout="fixed" width="11cm" border-spacing="0pt" font-size="8pt">
		         <fo:table-column column-width="2cm"/>   <!-- "Reason" label -->
		         <fo:table-column column-width="8.5cm"/> <!-- Advice text      -->
                 
		         <fo:table-body>
		         	<fo:table-row >
		         		<fo:table-cell >
		         		<fo:block color="#CC0000">
		         			Reason:
		         		</fo:block >
		         		</fo:table-cell >
		         		<fo:table-cell padding-right="0.4cm">
		         		<fo:block >
                          <!-- Show the advice-text for this qualifier -->
				          <xsl:variable name="thisNode_id" select="@Node_id"/>
					      <xsl:for-each select="../Advice/Text">
					      	<xsl:if test="$thisNode_id=@Node_id">
					      		<xsl:value-of select="." />
					      	</xsl:if>
					      </xsl:for-each>
		         		</fo:block >
		         		</fo:table-cell >
		         	</fo:table-row >
		         </fo:table-body>
		         </fo:table>
                 
		  	 </fo:block>
		   	</fo:table-cell>
		    <!-- END ADVICE -->

		     </fo:table-row>
		    </fo:table-body>
		    </fo:table>
		   </fo:block>
		 </fo:table-cell>


     </fo:table-row>

</xsl:for-each>
</xsl:template> 

<xsl:template name="tHeaderQualifierAdvice"> 
    <fo:table-row >
      <fo:table-cell background-color="#AFC7D9" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify">

		<fo:table table-layout="fixed" width="19cm" 
				border-spacing="0pt" font-size="8pt">
			<fo:table-column column-width="9.5cm"/>
			<fo:table-column column-width="9.5cm"/>

			<fo:table-body>

				<xsl:for-each select="Header/Advice/Text">	<!-- FOR EACH HEADER QUALIFIER -->
        <xsl:choose>
        <xsl:when test="key('HeadQualKey',concat(generate-id(ancestor::Audit),'-',@Node_id))/@Label" >
         <!-- do not show this qualifier's advice; the advice will be shown in tHeaderQualifierLabels -->
         <fo:table-row> 
         	<fo:table-cell>
							<fo:block>
							</fo:block>
					</fo:table-cell>
         </fo:table-row> 
        </xsl:when>
        <xsl:otherwise>
				<fo:table-row > 
				<!-- Put message on the left side with the actual qualifier advice on the right -->
					<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center" number-rows-spanned="1">
						<fo:block font-size="8pt" font-weight="bold">
					    <xsl:if test="position()=1">
							 Unmet conditions for this set of requirements:
					    </xsl:if>
						</fo:block>
				  </fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-right="20pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
							<fo:block font-size="8pt" >
							<xsl:value-of select="."/> <!-- get Text data -->
							</fo:block>
						</fo:table-cell>
				</fo:table-row>
        </xsl:otherwise>
        </xsl:choose>
				</xsl:for-each>	<!-- END FOR EACH HEADER QUALIFIER -->
			</fo:table-body>
			</fo:table>
		</fo:block>
      </fo:table-cell>

	</fo:table-row>
</xsl:template> 

<xsl:template name="tBlockExceptions"> 
  <xsl:for-each select="Header/Qualifier/Exception">  
    <xsl:call-template name="tShowException" />
  </xsl:for-each> 
</xsl:template> 

<xsl:template name="tBlockRemarks"> 

	<xsl:if test="Header/Remark"> 
    <fo:table-row >
      <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="8pt"
                 space-after.optimum="3pt"
                 text-align="justify">
          <xsl:for-each select="Header/Remark/Text">	<!-- FOR EACH HEADER REMARK TEXT -->
            <xsl:value-of select="."/>&#160;
          </xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
        </fo:block>
	</fo:table-cell>
	</fo:table-row>        
 </xsl:if>
  
  <xsl:if test="Header/Display/Text"> 
     <xsl:for-each select="Header/Display/Text">  <!-- FOR EACH HEADER DISPLAY TEXT -->
      <fo:table-row >
       <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="8pt"
                 space-after.optimum="3pt"
                 text-align="justify">               
         <xsl:for-each select="Line"><xsl:value-of select="."/>&#160;</xsl:for-each>
       </fo:block>
      </fo:table-cell>
      </fo:table-row>           
     </xsl:for-each>
  </xsl:if>

</xsl:template> 

<xsl:template name="tBlockQualifiers"> 
    <fo:table-row >
      <fo:table-cell padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="4"  display-align="center">
		<!-- CMU Localization === Change color to black  
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#888" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify"> -->
       <fo:block font-size="8pt" 
                 font-family="sans-serif" 
                 color="#000000" 
                 line-height="15pt"
                 space-after.optimum="3pt"
                 text-align="justify">
		<!-- CMU Localization === End of Change color to black -->
		<fo:table table-layout="fixed" width="19cm" 
				background-color="#efefef" 
				border-spacing="0pt" font-size="8pt">
			<fo:table-column column-width="8cm"/>
			<fo:table-column column-width="11cm"/>

			<fo:table-body>

			<xsl:for-each select="Header/Qualifier">	<!-- FOR EACH HEADER QUALIFIER -->
				<fo:table-row > 
				<!-- Put message on the left side with the actual qualifier advice on the right -->
						<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center"
						               number-rows-spanned="1">
							<fo:block font-size="8pt" font-weight="bold" text-align="right">
              <xsl:if test="position()=1">
							  Block Qualifiers: &#160;&#160;
              </xsl:if>  
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" display-align="center">
							<fo:block font-size="8pt" >
							<xsl:value-of select="Text"/>
							<xsl:for-each select="SubText">	
								<xsl:value-of select="."/>
							</xsl:for-each>	<!-- for each subtext -->
							</fo:block>
						</fo:table-cell>
				</fo:table-row>
			</xsl:for-each>	<!-- FOR EACH HEADER QUALIFIER -->
			</fo:table-body>
			</fo:table>
		</fo:block>
      </fo:table-cell>

	</fo:table-row>
</xsl:template> 


 <xsl:template name="tRules">
	 <fo:table-row border-bottom-width="medium" border-bottom-color="#ffffff" border-bottom-style="solid">
		 <xsl:choose>
             <xsl:when test="ancestor::Block/@Req_type = 'AWARD'"><xsl:attribute name="background-color">
					 <xsl:value-of select="'#FFFFFF'"/> <!-- white -->
				 </xsl:attribute></xsl:when>
			 <xsl:when test="@Per_complete = 100"><xsl:attribute name="background-color">
					 <xsl:value-of select="'#FFFFE0'"/> <!-- light yellow -->
				 </xsl:attribute></xsl:when>
			 <xsl:when test="@Per_complete = 99">
			     <xsl:attribute name="background-color">
					 <xsl:value-of select="'#E6F4FF'"/> <!-- light blue -->
				 </xsl:attribute></xsl:when>
			 <xsl:when test="@Per_complete = 98">
				 <xsl:attribute name="background-color">
					 <xsl:value-of select="'#E6F4FF'"/> <!-- light blue -->
				 </xsl:attribute>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:attribute name="background-color">
					 <xsl:value-of select="'#FEEEDD'"/> <!-- light pink -->
				 </xsl:attribute>
			 </xsl:otherwise>
		 </xsl:choose>
		 <fo:table-cell number-columns-spanned="4">
			 <fo:block>
				 <fo:table table-layout="fixed" width="19cm" space-before="0.3cm" border-spacing="0pt" font-size="8pt">
					 <fo:table-column column-width="1.0cm"/> <!-- checkbox -->
					 <fo:table-column column-width="7.0cm"/> <!-- label -->
					 <fo:table-column column-width="2.5cm"/>
					 <fo:table-column column-width="8.5cm"/>

					 <fo:table-body>
						 <fo:table-row>
              <xsl:choose>
               <xsl:when test="ancestor::Rule[1]/@RuleType  = 'Group' and 
                                                 @RuleType != 'Group' and 
                               /Report/@rptHideInnerGroupLabels='Y'">
                             <!-- do not show the labels for the rules within the group 1.15 -->
                 <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt">
                   <fo:block  line-height="15pt">
                   <!-- empty checkbox area -->
                   </fo:block>
                 </fo:table-cell>
                 <fo:table-cell display-align="center">
                   <fo:block>
                   <!-- empty label area -->
                   </fo:block>
                 </fo:table-cell>
               </xsl:when>
               <xsl:otherwise>
							 <fo:table-cell padding-left="2pt" padding-top="0.1pt" padding-bottom="0.0pt"
													 display-align="center">
								 <fo:block font-size="8pt"
													 font-family="sans-serif"
													 color="#316C92"
													 line-height="15pt"
													 space-after.optimum="3pt"
													 text-align="left">
									 <xsl:call-template name="tIndentLevel"/> <!-- indent the checkbox -->
									 <xsl:choose>
										 <xsl:when test="@Per_complete = 100">
											 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckyes.gif " />
										 </xsl:when>
										 <xsl:when test="@Per_complete = 99">
											 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck99.gif" />
										 </xsl:when>
										 <xsl:when test="@Per_complete = 98">
											 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheck98.gif" />
										 </xsl:when>
										 <xsl:otherwise>
											 <fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwcheckno.gif" />
										 </xsl:otherwise>
									 </xsl:choose>
								 </fo:block>
							 </fo:table-cell>
							 <fo:table-cell display-align="center">
								 <fo:block text-align="left">
                   <xsl:call-template name="tIndentLevel"/> <!-- indent the label text -->
									 <xsl:choose>
										 <xsl:when test="@Per_complete = 100">
											 <!-- CMU Localization === Change color to black
											 <fo:inline color="#606060"> -->
											 <fo:inline color="#000000">
												 <xsl:value-of select="@Label"/>
											 </fo:inline>
										 </xsl:when>
										 <xsl:when test="@Per_complete = 99">
											 <!-- CMU Localization === Change color to black
											 <fo:inline color="#606060"> -->
											 <fo:inline color="#000000">
												 <xsl:value-of select="@Label"/>
											 </fo:inline>
										 </xsl:when>
										 <xsl:when test="@Per_complete = 98">
											 <!-- CMU Localization === Change color to black
											 <fo:inline color="#606060"> -->
											 <fo:inline color="#000000">
												 <xsl:value-of select="@Label"/>
											 </fo:inline>
										 </xsl:when>
										 <xsl:otherwise>
										 <!-- CMU Localization === Change color to black
											 <fo:inline color="#606060"> -->
											 <fo:inline color="#000000">
											 <xsl:value-of select="@Label"/>
											 </fo:inline>
										 </xsl:otherwise>
									 </xsl:choose>
								 </fo:block>
							 </fo:table-cell>
                           </xsl:otherwise>
                           </xsl:choose>

							 <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="2"  display-align="center">
								 <fo:block font-size="8pt"
													 font-family="sans-serif"
													 line-height="15pt"
													 space-after.optimum="3pt"
													 text-align="justify" >
									 <xsl:choose>
										 <xsl:when test="@Per_complete = 100">
											 <xsl:attribute name="color">
												 <xsl:value-of select="'#888'"/>
											 </xsl:attribute>
										 </xsl:when>
										 <xsl:when test="@Per_complete = 99">
											 <xsl:attribute name="color">
												 <xsl:value-of select="'#888'"/>
											 </xsl:attribute>
										 </xsl:when>
										 <xsl:when test="@Per_complete = 98">
											 <xsl:attribute name="color">
												 <xsl:value-of select="'#888'"/>
											 </xsl:attribute>
										 </xsl:when>
										 <xsl:otherwise>
											 <xsl:attribute name="color">
												 <xsl:value-of select="'#000'"/>
											 </xsl:attribute>
										 </xsl:otherwise>
									 </xsl:choose>
									 <xsl:call-template name="tClassesApplied"/>
									 <xsl:call-template name="tRuleAdvice"/>
								 </fo:block>
							 </fo:table-cell>

						 </fo:table-row>
						 <!-- RULE REMARKS -->
						 <xsl:if test="/Report/@rptShowRuleRemarks='Y'">
							 <xsl:if test="Remark">
								 <fo:table-row>
									 <xsl:choose>
										 <xsl:when test="@Per_complete = 100">
											 <xsl:attribute name="background-color">
												 <xsl:value-of select="'#ECF4D1'"/>
											 </xsl:attribute>
										 </xsl:when>
										 <xsl:when test="@Per_complete = 99">
											 <xsl:attribute name="background-color">
												 <xsl:value-of select="'#CEDDEA'"/>
											 </xsl:attribute>
										 </xsl:when>
										 <xsl:when test="@Per_complete = 98">
											 <xsl:attribute name="background-color">
												 <xsl:value-of select="'#CEDDEA'"/>
											 </xsl:attribute>
										 </xsl:when>
										 <xsl:otherwise>
											 <xsl:attribute name="background-color">
												 <xsl:value-of select="'#F0E0CF'"/>
											 </xsl:attribute>
										 </xsl:otherwise>
									 </xsl:choose>
									 <fo:table-cell number-columns-spanned="2">
									 <!-- CMU Localization === Change color to black 
										 <fo:block text-align="right" color="#888"> -->
										 <fo:block text-align="right" color="#000000">
											 Remark:&#160;&#160;
										 </fo:block >
									 </fo:table-cell >
									 <!-- CMU Localization === Change color to black
									 <fo:table-cell number-columns-spanned="2" color="#888"> -->
									 <fo:table-cell number-columns-spanned="2" color="#000000">
										 <fo:block >
											 &#160;&#160;
											 <xsl:for-each select="Remark/Text">
												 <!-- FOR EACH RULE REMARK TEXT -->
												 <xsl:value-of select="."/>&#160;
											 </xsl:for-each>	<!-- FOR EACH REMARK TEXT -->
										 </fo:block >
									 </fo:table-cell >
								 </fo:table-row >
							 </xsl:if>
							 <!-- test="Remark" -->
						 </xsl:if>
						 <!-- show rule remarks -->
						 <!-- END RULE REMARKS -->

						 <!-- SHOW RULE TEXT -->
						 <xsl:if test="/Report/@rptShowRuleText='Y'">
							 <xsl:if test="Requirement">
								 <xsl:call-template name="tRuleRequirements" />
							 </xsl:if>
						 </xsl:if>

             <!-- SHOW RULE EXCEPTIONS - those on the rule and those on course nodes on the rule -->
						 <xsl:if test="/Report/@rptShowRuleExceptions='Y'">
							  <xsl:call-template name="tRuleExceptions" />
		            <xsl:for-each select="Requirement/.//Course">	
							   <xsl:call-template name="tRuleExceptions" />
                </xsl:for-each>
                <xsl:for-each select="Requirement/.//Qualifier">	
							   <xsl:call-template name="tRuleExceptions" />
                </xsl:for-each>
						 </xsl:if>

					 </fo:table-body>
				 </fo:table>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

</xsl:template>
 
<xsl:template name="tClassesApplied">
<xsl:if test="(Classes_applied &gt; 0 and ClassesApplied/Class) or NoncoursesApplied/Noncourse">
	<fo:table table-layout="fixed" width="11cm" border-spacing="0pt" font-size="8pt">
	<fo:table-column column-width="2cm"/> <!-- Course Key -->
	<fo:table-column column-width="5cm"/> <!-- Title      -->
	<fo:table-column column-width="1cm"/> <!-- Grade      -->
	<fo:table-column column-width="1cm"/> <!-- Credits    -->
	<fo:table-column column-width="2cm"/> <!-- Term Taken -->

	<fo:table-body>
	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
		<xsl:for-each select="ClassesApplied/Class">
		<!-- For each instance of the course in the clsinfo section that is not a Ghost record-->
		<!-- We have chosen not to do this when the Show Course keys only is Y because that 
		would make the display confusing.  -->
		<xsl:for-each select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))">
		<xsl:if test="@Rec_type != 'G'">
				<fo:table-row >
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<!-- Show planned classes in another color and within parens -->
            <xsl:if test="@Letter_grade = 'PLAN'"> 
							(<xsl:value-of select="@Discipline"/>	   <!-- left paren + Discipline -->
							<xsl:text>&#160;</xsl:text>				   <!-- space --> 
							<xsl:value-of select="@Number"/>)          <!-- Number + right paren -->
						</xsl:if>
						<!-- NOT Planned Class -->
						<xsl:if test="@Letter_grade != 'PLAN'"> 
							<xsl:value-of select="@Discipline"/>       <!-- Discipline -->
							<xsl:text>&#160;</xsl:text>                     <!-- space --> 
							<xsl:value-of select="@Number"/>           <!-- Number -->
						</xsl:if> 
					</fo:block>
					</fo:table-cell>

					<!-- TITLE -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Class node and get the Title -->     
						<xsl:value-of select="@Course_title"/>
					</fo:block>
					</fo:table-cell>

					<!-- GRADE -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
                      <fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
                      </fo:block>
					</fo:table-cell>

					<!-- CREDITS -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<!-- Place the @Credits in parens if the class is in-progress -->
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
					</fo:block>
					</fo:table-cell>

					<!-- TERM -->
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
					<fo:block font-size="8pt">
						<xsl:value-of select="@TermLit"/>
					</fo:block>
					</fo:table-cell>

				</fo:table-row >

				<!-- If this is a transfer class show more information -->
				<xsl:if test="@Transfer='T'">
					<fo:table-row >
						<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
							Satisfied by 
						</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
								number-columns-spanned="4">
						<fo:block font-size="8pt">
              <xsl:value-of select="@Transfer_course"/>
              <!-- Show the transfer course title and transfer school name - if they exist -->                        
              <xsl:if test="normalize-space(@TransferTitle) != ''"> 
                <xsl:text> - </xsl:text> <!-- hyphen --> 
                <xsl:value-of select="@TransferTitle"/>
              </xsl:if>
              <xsl:if test="normalize-space(@Transfer_school) != ''"> 
                <xsl:text> - </xsl:text> <!-- hyphen --> 
                <xsl:value-of select="@Transfer_school"/>
              </xsl:if>
						</fo:block>
						</fo:table-cell>
					</fo:table-row >
				</xsl:if>

		</xsl:if> <!-- @Rec_type != G -->
		</xsl:for-each> <!-- key('ClsKey',@Id_num)" -->
		</xsl:for-each> <!-- ClassesApplied/Class -->
		
		<xsl:for-each select="NoncoursesApplied/Noncourse"> <!-- most likely only one -->
		    <fo:table-row >
			  <fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
			  <fo:block font-size="8pt">
			    <xsl:value-of select="Code"/>
			    <xsl:text>&#160;</xsl:text> <!-- space -->	 
			    <xsl:value-of select="Value"/>		 
			  </fo:block>
			  </fo:table-cell>
			</fo:table-row >
      <xsl:call-template name="tShowNoncourse"/>
		</xsl:for-each> <!-- NoncoursesApplied/Noncourse -->

	</xsl:if> <!-- CourseKeysOnly = N -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
		<fo:table-row>

			<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
				number-columns-spanned="5">
				<fo:block font-size="8pt">

					<xsl:for-each select="ClassesApplied/Class">
					<!-- For each instance of the course in the clsinfo section that is not a Ghost record-->
					<!-- We have chosen not to do this when the Show Course keys only is Y because that 
					would make the display confusing.  -->

						<xsl:value-of select="@Discipline"/>			<!-- Discipline -->
						<xsl:text>&#160;</xsl:text> <!-- space -->		<!-- space -->
						<xsl:value-of select="@Number"/>				<!-- Number -->
						<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
   					    <xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
						<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma (if not last one in the series) -->

				  </xsl:for-each> <!-- ClassesApplied/Class -->

          <xsl:for-each select="NoncoursesApplied/Noncourse"> <!-- most likely only one -->
           <xsl:call-template name="tShowNoncourse"/>	 
          </xsl:for-each> <!-- NoncoursesApplied/Noncourse -->

				</fo:block>
			</fo:table-cell>

		</fo:table-row>


	</xsl:if>
	</fo:table-body>
	</fo:table>
</xsl:if> <!-- classes-applied > 0 -->

</xsl:template>

<xsl:template name="tShowNoncourse"> 
  <fo:table-row >
  <fo:table-cell  number-columns-spanned="3" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
  
  <fo:table table-layout="fixed" width="12cm" border-spacing="0pt" font-size="8pt">
    <fo:table-column column-width="6cm"/> <!-- Title      -->
    <fo:table-column column-width="2cm"/> <!-- Grade      -->
    <fo:table-column column-width="4cm"/> <!-- Term Taken -->

    <fo:table-body>
    <fo:table-row>

    <fo:table-cell padding-left="2pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
      <fo:block font-size="8pt">
       <xsl:value-of select="key('NonKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Title"/>
      </fo:block>
    </fo:table-cell>
    
    <fo:table-cell padding-left="2pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
      <fo:block font-size="8pt">
        <xsl:value-of select="@Value"/>
      </fo:block>
    </fo:table-cell>
    
    <fo:table-cell padding-left="2pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
      <fo:block font-size="8pt">
       <xsl:value-of select="key('NonKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
      </fo:block>
    </fo:table-cell>

    </fo:table-row>
    </fo:table-body>
  </fo:table>
  
  </fo:table-cell>
  </fo:table-row>
    
</xsl:template>

<!-- If this class is using repeat policy 5 then only show the credits for the
     class that was used for the Ghost record; for the other class(es) show 0 credits -->
<xsl:template name="CheckInProgressAndPolicy5">	
  <xsl:variable name="vLeftParen">
   <xsl:if test="@In_progress = 'Y'" >(</xsl:if>
  </xsl:variable>
  <xsl:variable name="vRightParen">
   <xsl:if test="@In_progress = 'Y'" >)</xsl:if>
  </xsl:variable>

  <xsl:variable name="vCredits">
  <xsl:choose>
  <xsl:when test="@Repeat_policy = '5'">
    <xsl:choose>
    <!-- If this was the class that was used for the Ghost record then use the real credits -->
	<xsl:when test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@Rec_type='G']/@Term = @Term">
		<xsl:value-of select="@Credits"/>
    </xsl:when>
    <xsl:otherwise> <!-- we want to show 0 for this class since its credits were not counted in the rule -->
        0
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise> <!-- no policy 5 -->
	<xsl:value-of select="@Credits"/>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>

  <!-- Put parens (or blanks) around credits -->
  <xsl:copy-of select="$vLeftParen"/>
   <xsl:call-template name="tFormatNumber" >
		<xsl:with-param name="iNumber" select="$vCredits" />
		<xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
	</xsl:call-template>
  <xsl:copy-of select="$vRightParen"/>

</xsl:template>


<xsl:template name="tRuleAdvice">	

<!-- /////////////////////////////////////////////// -->
<!-- /////////////////////////////////////////////// -->
<!-- RULE ADVICE -->
<!-- /////////////////////////////////////////////// -->
<!-- /////////////////////////////////////////////// -->
<xsl:if test="/Report/@rptShowRuleAdvice='Y'">
	<!-- If at least one Advice node exists -->
	<xsl:if test="Advice"> 
	<!-- If an ancestor has proxy-advice then don't show advice for this rule -->
	<!-- xsl:if test="ancestor::Rule[1]/@ProxyAdvice!='Yes'" -->
	<xsl:choose>
		<xsl:when test="ancestor::Rule[1]/@ProxyAdvice = 'Yes'">
		<!-- do nothing -->
		</xsl:when> <!-- proxyadvice = Yes -->
		<xsl:otherwise>
		<fo:table table-layout="fixed" width="11cm" border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="2cm"/> <!-- Still Needed Text -->
		<fo:table-column column-width="8.5cm"/> <!-- Advice      -->

		<fo:table-body>
			<fo:table-row >
				<fo:table-cell >
				<fo:block color="#CC0000">
					<xsl:copy-of select="$LabelStillNeeded" />
				</fo:block >
				</fo:table-cell >
				<fo:table-cell padding-right="0.4cm">
				<fo:block >
        	<xsl:call-template name="tIndentLevel"/> <!-- indent the advice -->
					<!-- Add an opening paren if this is rule is within a group -->
					<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
					(
					</xsl:if>
					<!-- /////////////////////////////////////////////// -->
					<!-- RULE-TYPE -->
					<!-- /////////////////////////////////////////////// -->
					<xsl:choose>
					<!-- GROUP RULE -->
						<xsl:when test="@RuleType = 'Group'">
							<xsl:if test="Advice/@NumGroupsNeeded >= 1">
                              <!-- If there is a least 2 rules that don't have HideRule - then show this "Choose" text -->
                <xsl:if test="count(Rule[*]) - count(Rule[*]/Requirement/Qualifier[@Name = 'HIDERULE' or @Node_type='HideRule']) > 1 or
                              count(Rule[*]) = 1"> 
								Choose from <xsl:value-of select="Advice/@NumGroupsNeeded"/> of the following: 
							  </xsl:if>
							</xsl:if>
						</xsl:when> 
					<!-- END GROUP RULE -->

          <!-- SUBSET -->
             <xsl:when test="@RuleType = 'Subset'">
                <!-- QUAL LIST -->
                <xsl:for-each select="Advice"> <!-- most likely only one -->
                       <xsl:call-template name="tQualAdvice"/>
                </xsl:for-each>
             </xsl:when> 
          <!-- END SUBSET -->
               
           <!-- NONCOURSE -->
           <xsl:when test="@RuleType = 'Noncourse'">
              <!-- One NonCourse <xsl:value-of select="Advice/Code"/>  -->
              <xsl:value-of select="Advice/Literal"/> <!-- show literal from UCX-SCR003 -->
              <xsl:if test="Advice/Operator"> 
                 <xsl:choose> <!-- = and >= are the most likely operators -->
                 <xsl:when test="Advice/Operator='='"> 
                    with a value of
                 </xsl:when>
                 <xsl:when test="Advice/Operator='&gt;='"> 
                    with a value of at least
                 </xsl:when>
                 <xsl:otherwise> 
                   <xsl:text>&#160;</xsl:text> <!-- space --> 
                   <xsl:value-of select="Advice/Operator"/> 
                   <xsl:text>&#160;</xsl:text> <!-- space --> 
                 </xsl:otherwise>
                 </xsl:choose>
                 <xsl:value-of select="Advice/Value"/>
              </xsl:if> 
           </xsl:when>
           <!-- END NONCOURSE -->

					<!-- BLOCK RULE -->
						<xsl:when test="@RuleType = 'Block'">
							<xsl:if test="Advice/BlockID='NOT_FOUND'"> 
								<xsl:value-of select="Requirement/Type"/> = <xsl:value-of select="Requirement/Value"/> 
								block was not found but is required
							</xsl:if>
								<xsl:if test="Advice/BlockID!='NOT_FOUND'"> 
								See <fo:inline font-weight="bold">
								<xsl:value-of select="key('BlockKey',concat(generate-id(ancestor::Audit),'-', Advice/BlockID))/@Title" />
								</fo:inline> section
							</xsl:if>
						</xsl:when> 
					<!-- END BLOCK RULE -->

					<!-- BLOCKTYPE RULE -->
						<xsl:when test="@RuleType = 'Blocktype'">
							<xsl:choose>
								<xsl:when test="Advice/Title"> 
									<xsl:for-each select="Advice/Title"> <!-- most likely only one -->
										See <fo:inline font-weight="bold"><xsl:value-of select="." /></fo:inline> section <!--<br/>-->
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline font-weight="bold"><xsl:value-of select="Advice/Type" /> block was not found but is required </fo:inline>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					<!-- END BLOCKTYPE RULE -->

					<!-- COURSE RULE -->
						<xsl:when test="@RuleType = 'Course'">
							<xsl:for-each select="Advice"> <!-- most likely only one -->
							<xsl:choose>
								<xsl:when test="Course">
									<xsl:if test="@Credits"> 
										<fo:inline font-weight="bold">
                       <xsl:variable name="vFormattedCredits">
                         <xsl:call-template name="tFormatNumber" >
                          <xsl:with-param name="iNumber" select="@Credits"/>
                          <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
                         </xsl:call-template>
                       </xsl:variable>
                      <xsl:choose>
                      <xsl:when test="$vShowToInsteadOfColon='Y' ">
                          <!-- Replace the colon with " to " -->
                          <xsl:call-template name="globalReplace">
                            <xsl:with-param name="outputString" select="$vFormattedCredits" />
                            <xsl:with-param name="target"       select="':'"      />
                            <xsl:with-param name="replacement"  select="' to '"   />
                          </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise> <!-- show the credits with the colon (if present) -->
                        <xsl:value-of select="$vFormattedCredits"/>
                      </xsl:otherwise>
                      </xsl:choose>
										</fo:inline>
								        <xsl:text>&#160;</xsl:text> <!-- space --> 
                        <xsl:call-template name="tCreditsLiteral"/>
									</xsl:if> 
                  <xsl:if test="@Class_cred_op='AND'"> 
                                and
                  </xsl:if> 
                  <xsl:if test="@Class_cred_op='OR'"> 
                                or
                  </xsl:if> 
									<xsl:if test="@Classes"> 
										<fo:inline font-weight="bold">
                    <xsl:choose>
                    <xsl:when test="$vShowToInsteadOfColon='Y' ">
                        <!-- Replace the colon with " to " -->
                        <xsl:call-template name="globalReplace">
                          <xsl:with-param name="outputString" select="@Classes" />
                          <xsl:with-param name="target"       select="':'"      />
                          <xsl:with-param name="replacement"  select="' to '"   />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise> <!-- show the classes with the colon (if present) -->
                      <xsl:value-of select="@Classes"/>
                    </xsl:otherwise>
                    </xsl:choose>
										</fo:inline> 
										<xsl:choose>
										<xsl:when test="@Classes = 1">
										Class
										</xsl:when>
										<xsl:otherwise>
										Classes
										</xsl:otherwise>
										</xsl:choose>
									</xsl:if> 
								    in

									<!-- "+" Connector -->
									<xsl:if test="@Connector=' + '"> 
										<xsl:for-each select="Course">	<!-- FOR EACH COURSE -->
											<xsl:call-template name="tCourseAdvice"/>
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
											<xsl:if test="position()!=last()">
												and <!-- and -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
											<xsl:if test="position()!=last()">
												+   <!-- plus -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
										</xsl:for-each> <!-- ADVICE/COURSE-->
									</xsl:if> 
									<!-- END "+" Connector -->

									<!-- "," Connector -->
									<xsl:if test="@Connector=', '"> 
										<xsl:for-each select="Course">  <!-- FOR EACH COURSE -->
											<xsl:call-template name="tCourseAdvice"/>
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
											<xsl:if test="position()!=last()">
												or       <!-- or -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
											<xsl:if test="position()!=last()">
												,        <!-- comma -->
											</xsl:if>
											</xsl:if> <!-- OR-ANDS=Y -->
										</xsl:for-each> <!-- ADVICE/COURSE-->
									</xsl:if> <!-- CONNECTOR = , -->
									<!-- END "," Connector -->

									<!-- INCLUDING LIST -->
									<xsl:if test="Including"> 
										<xsl:text>&#160;</xsl:text> <!-- space --> 
										<fo:inline text-decoration="underline"> Including </fo:inline>
										<xsl:text>&#160;</xsl:text> <!-- space --> 
										<xsl:for-each select="Including/Course">	<!-- FOR EACH INCLUDING COURSE -->
											<xsl:call-template name="tCourseAdvice"/>
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
											<xsl:if test="position()!=last()">
												and           <!-- and -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
											<xsl:if test="position()!=last()">
												+             <!-- plus -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
											<xsl:text>&#160;</xsl:text> <!-- space --> 
											<xsl:value-of select="With_advice"/> 
										</xsl:for-each> <!-- ADVICE/COURSE-->
									</xsl:if>
									<!-- END INCLUDING LIST -->

									<!-- EXCEPT LIST -->
									<xsl:if test="Except/Course"> 
										<xsl:text>&#160;</xsl:text> <!-- space --> 
										<fo:inline text-decoration="underline"> Except </fo:inline>
										<xsl:text>&#160;</xsl:text> <!-- space --> 
										<xsl:for-each select="Except/Course">	<!-- FOR EACH EXCEPT COURSE -->
											<xsl:call-template name="tCourseAdvice"/>
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
											<xsl:if test="position()!=last()">
												or                <!-- or -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
											<xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
											<xsl:if test="position()!=last()">
												,                 <!-- comma -->
											</xsl:if>  
											</xsl:if> <!-- OR-ANDS=Y -->
										</xsl:for-each> <!-- ADVICE/COURSE-->
									</xsl:if>
									<!-- END EXCEPT LIST -->
								</xsl:when> <!-- when test=Course-->
								<xsl:otherwise>
									<xsl:if test="@Credits"> 
										<fo:inline font-weight="bold">
                     <xsl:variable name="vFormattedCredits">
                          <xsl:call-template name="tFormatNumber" >
                          <xsl:with-param name="iNumber" select="@Credits" />
                          <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
                          </xsl:call-template>
                      </xsl:variable>
                      <!-- 5:17 more Credits -->
                      <xsl:choose>
                      <xsl:when test="$vShowToInsteadOfColon='Y' ">
                          <!-- Replace the colon with " to " -->
                          <xsl:call-template name="globalReplace">
                            <xsl:with-param name="outputString" select="$vFormattedCredits" />
                            <xsl:with-param name="target"       select="':'"      />
                            <xsl:with-param name="replacement"  select="' to '"   />
                          </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise> <!-- show the credits with the colon (if present) -->
                        <xsl:value-of select="$vFormattedCredits"/>
                      </xsl:otherwise>
                      </xsl:choose>
                    </fo:inline> more <xsl:call-template name="tCreditsLiteral"/> 
									</xsl:if> 
									<xsl:if test="@Classes"> 
										<fo:inline font-weight="bold">
                      <xsl:choose>
                      <xsl:when test="$vShowToInsteadOfColon='Y' ">
                          <!-- Replace the colon with " to " -->
                          <xsl:call-template name="globalReplace">
                            <xsl:with-param name="outputString" select="@Classes" />
                            <xsl:with-param name="target"       select="':'"      />
                            <xsl:with-param name="replacement"  select="' to '"   />
                          </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise> <!-- show the classes with the colon (if present) -->
                        <xsl:value-of select="@Classes"/>
                      </xsl:otherwise>
                      </xsl:choose>
                    </fo:inline> more 
										<xsl:choose>
										<xsl:when test="@Classes = 1">
											Class
										</xsl:when>
										<xsl:otherwise>
											Classes
										</xsl:otherwise>
										</xsl:choose>
									</xsl:if> 
								</xsl:otherwise>
							</xsl:choose>
              <!-- QUAL LIST -->
              <xsl:call-template name="tQualAdvice"/> 
							</xsl:for-each> <!-- select="Advice" -->
						</xsl:when> <!-- course rule -->
					<!-- END COURSE RULE -->

							<xsl:otherwise>
							<!-- do nothing -->
							</xsl:otherwise>
						</xsl:choose> <!-- ruletype -->
					<!-- /////////////////////////////////////////////// -->
					<!-- RULE-TYPE -->
					<!-- /////////////////////////////////////////////// -->
					<!-- Add a closing paren if this is rule is within a group -->
					<xsl:if test="ancestor::Rule[1]/@RuleType = 'Group'">
						) 
						<xsl:choose> <!--  -->
							<xsl:when test="@LastRuleInGroup='Yes'"> 
								<!-- do nothing -->
							</xsl:when>
                            <xsl:when test="ancestor::Rule[1]/Requirement/@NumGroups = ancestor::Rule[1]/Requirement/@NumRules">
							  and  <!-- group and - all rules are needed -->
						    </xsl:when>
                		    <!-- count how many following rules have HideRule - and compare to the number of rules -->
                <xsl:when test="(count(following-sibling::Rule[*]) =
                                 count(following-sibling::Rule[*]/Requirement/Qualifier[@Name = 'HIDERULE'])) or
                                (count(following-sibling::Rule[*]) =
                                 count(following-sibling::Rule[*]/Requirement/Qualifier[@Node_type = 'HideRule']))">  
							  <!-- hide or  - because all following-rules have HideRule -->
						    </xsl:when>
						    <xsl:otherwise>
							  or  <!-- group or -->
						    </xsl:otherwise>
						</xsl:choose> <!--  -->
					</xsl:if>
				</fo:block >
				</fo:table-cell >
			</fo:table-row >
		</fo:table-body>
		</fo:table>
	</xsl:otherwise>
	</xsl:choose> <!-- ruletype -->
</xsl:if> 
	<!-- /////////////////////////////////////////////// -->
	<!-- /////////////////////////////////////////////// -->
	<!-- END RULE ADVICE -->
	<!-- /////////////////////////////////////////////// -->
	<!-- /////////////////////////////////////////////// -->

	<!-- PROXY-ADVICE -->
	<xsl:if test="ProxyAdvice"> 
		<fo:table table-layout="fixed" width="11cm" border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="2cm"/> <!-- Still Needed Text -->
		<fo:table-column column-width="9cm"/> <!-- Title      -->

		<fo:table-body>
			<fo:table-row >
				<fo:table-cell >
				<fo:block color="#CC0000">
                        <xsl:choose>
                        <xsl:when test="ancestor::Block/@Req_type = 'AWARD'">
		         			Reason:
                        </xsl:when>
                        <xsl:otherwise>
						    <xsl:copy-of select="$LabelStillNeeded" />
                        </xsl:otherwise>
                        </xsl:choose>
				</fo:block >
				</fo:table-cell >
				<fo:table-cell padding-right="0.4cm">
				<fo:block >
						<xsl:for-each select="ProxyAdvice/Text">
						<xsl:value-of select="."/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						</xsl:for-each> <!-- ADVICE/COURSE-->
				</fo:block >
				</fo:table-cell >
			</fo:table-row >
		</fo:table-body>
		</fo:table>
	</xsl:if> <!-- PROXY-ADVICE -->

</xsl:if>  <!-- show rule advice = Y -->



</xsl:template> <!-- tRuleAdvice -->

<xsl:template name="tRuleRequirements">

			<fo:table-row display-align="center">
				<xsl:choose>
					<xsl:when test="@Per_complete = 100">
						<xsl:attribute name="background-color">
							<xsl:value-of select="'#ECF4D1'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="@Per_complete = 99">
						<xsl:attribute name="background-color">
							<xsl:value-of select="'#CEDDEA'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="@Per_complete = 98">
						<xsl:attribute name="background-color">
							<xsl:value-of select="'#CEDDEA'"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="background-color">
							<xsl:value-of select="'#F0E0CF'"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>

				<fo:table-cell number-columns-spanned="2">
				<!-- CMU Localization === Change color to black 
				<fo:block text-align="right" color="#888"> -->
				<fo:block text-align="right" color="#000000">
					Requirement:&#160;&#160;
				</fo:block >
				</fo:table-cell >
				<!-- CMU Localization === Change color to black 
				<fo:table-cell number-columns-spanned="2" color="#888"> -->
				<fo:table-cell number-columns-spanned="2" color="#000000">
				<fo:block >
				&#160;

				<xsl:choose>
					<xsl:when test="@RuleType = 'Group'">
						<xsl:if test="Requirement/@NumGroups = 1"> 
							<xsl:value-of select="Requirement/@NumGroups"/> 
							Group in 
						</xsl:if>
						<xsl:if test="Requirement/NumGroups > 1"> 
							<xsl:value-of select="Requirement/@NumGroups"/> 
							Groups in 
						</xsl:if>
					</xsl:when>

					<xsl:when test="@RuleType = 'Noncourse'">
						<xsl:value-of select="Requirement/NumNoncourses"/>
						NonCourse (
						<xsl:value-of select="Requirement/Code"/> 
						<xsl:value-of select="Requirement/Operator"/> 
						<xsl:value-of select="Requirement/Value"/> 
								   )
					</xsl:when>

					<xsl:when test="@RuleType = 'Blocktype'">
						1 Blocktype (<xsl:value-of select="Requirement/Type"/>)
					</xsl:when>

					<xsl:when test="@RuleType = 'Block'">
						1 Block (<xsl:value-of select="Requirement/Type"/> =
						<xsl:value-of select="Requirement/Value"/>)
					</xsl:when>

					<xsl:when test="@RuleType = 'IfStmt'">
						<xsl:for-each select="Requirement/LeftCondition"> 
							<xsl:call-template name="tCondition"/>
						</xsl:for-each>
					</xsl:when>

					<!-- WHEN RULETYPE = COURSE -->
					<xsl:when test="@RuleType = 'Course'">
					<!-- FOR EACH COURSE REQUIREMENT -->
					<xsl:for-each select="Requirement">	

						 <!-- CREDITS -->
						<xsl:if test="@Credits_begin">          
							<xsl:value-of select="@Credits_begin"/> 
								<xsl:if test="@Credits_end"> 
								:
								<xsl:value-of select="@Credits_end"/> 
								</xsl:if> 
								Credits
						</xsl:if> 
						<!-- Only show the AND/OR if both classes and credits were specified -->
						<xsl:if test="@Credits_begin"> 
							<xsl:if test="@Classes_begin"> 
								<xsl:value-of select="@Class_cred_op"/> <!-- AND/OR -->
								<xsl:text>&#160;</xsl:text> <!-- space --> 
							</xsl:if> 
						</xsl:if> 
						<xsl:if test="@Classes_begin">           <!-- CLASSES -->
							<xsl:value-of select="@Classes_begin"/> 
							<xsl:if test="@Classes_end"> 
								:
								<xsl:value-of select="@Classes_end"/> 
							</xsl:if> 
							Classes
						</xsl:if> 
						in

						<!-- PLUS=AND -->
						<xsl:if test="@Connector = '+'"> 
							<xsl:for-each select="Course">	<!-- FOR EACH COURSE -->
								<xsl:call-template name="tCourseReq"/>
								<xsl:if test="position()!=last()">
									+                      <!-- plus -->
								</xsl:if>  
							</xsl:for-each> <!-- REQUIREMENT/COURSE-->
						</xsl:if> <!-- CONNECTOR = + -->

						<!-- COMMA=OR -->            
						<xsl:if test="@Connector = ','"> 
							<xsl:for-each select="Course">  <!-- FOR EACH COURSE -->
							<xsl:call-template name="tCourseReq"/>
								<xsl:if test="position()!=last()">
									,                      <!-- comma -->
								</xsl:if>  
							</xsl:for-each> <!-- REQUIREMENT/COURSE -->
						</xsl:if> <!-- CONNECTOR = , -->

						<xsl:if test="Including"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<fo:inline text-decoration="underline"> Including </fo:inline >
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:for-each select="Including/Course">	<!-- FOR EACH INCLUDING COURSE -->
								<xsl:call-template name="tCourseReq"/>
									<xsl:if test="position()!=last()">
										+			      <!-- plus -->
									</xsl:if>  
							</xsl:for-each> <!-- ADVICE/COURSE-->
						</xsl:if> <!-- INCLUDING -->

						<xsl:if test="Except"> 
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<fo:inline text-decoration="underline"> Except </fo:inline >
							<xsl:text>&#160;</xsl:text> <!-- space --> 
							<xsl:for-each select="Except/Course">	<!-- FOR EACH EXCEPT COURSE -->
								<xsl:call-template name="tCourseReq"/>
									<xsl:if test="position()!=last()">
										,                     <!-- comma -->
									</xsl:if>  
							</xsl:for-each> <!-- EXCEPT/COURSE-->
						</xsl:if> <!-- EXCEPT -->

					</xsl:for-each> <!-- select="Requirement" -->
					<!-- END FOR EACH COURSE REQUIREMENT -->
					</xsl:when> <!-- course rule -->
					<!-- END WHEN RULETYPE = COURSE -->

					<xsl:otherwise>
					<!-- do nothing -->
					</xsl:otherwise>
				</xsl:choose> <!-- ruletype -->

				<xsl:if test="HideRule"> 
				 HideRule
				</xsl:if> <!-- HideRule -->

				<xsl:for-each select="Requirement/Qualifier">	<!-- FOR EACH QUALIFIER -->
					<!--<fo:external-graphic width="0.36cm" height="0.36cm" src="../images/dwinvis2.gif"/>-->
					<fo:inline color="#5B788F">&#160;
					<xsl:value-of select="Text"/>
					<xsl:for-each select="SubText">   
						<xsl:value-of select="."/>
					</xsl:for-each>	<!-- FOR EACH subtext -->
					</fo:inline>
				</xsl:for-each>	<!-- FOR EACH QUALIFIER -->



				</fo:block >
				</fo:table-cell >
			</fo:table-row >

</xsl:template>

<xsl:template name="tRuleExceptions">
<!-- FOR EACH COURSE EXCEPTION -->
<xsl:for-each select="Exception">	
  <xsl:call-template name="tShowException" />
</xsl:for-each> <!-- course exception -->
</xsl:template>

<xsl:template name="tShowException">
	<fo:table-row >
		<fo:table-cell number-columns-spanned="2" >
		<fo:block >
			<fo:inline color="#5B788F">Exception By: </fo:inline><xsl:value-of select="key('XptKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Who"/>
      <fo:inline color="#5B788F"> on </fo:inline><xsl:call-template name="FormatRuleXptDate"/>
		</fo:block >
		</fo:table-cell >
		<fo:table-cell number-columns-spanned="2" >
		<fo:block >
			<fo:inline color="#5B788F"><xsl:call-template name="tExceptionType"/>: </fo:inline>
			<xsl:value-of select="key('XptKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Label"/>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>
</xsl:template>

<!-- tCourseAdvice - used for displaying courses in requirement advice -->
<xsl:template name="tCourseAdvice">
  <!-- AdviceLink: Link to a new browser when user clicks on class in advice -->
     <!-- Display the discipline only if the discipline isn't repeated --> 
     <xsl:if test="@NewDiscipline='Yes'">
       <fo:inline font-weight="bold"><xsl:value-of select="@Disc"/></fo:inline>
     <xsl:text>&#160;</xsl:text> <!-- space betweem disc and num --> 
     </xsl:if>
     <xsl:choose>
      <xsl:when test="@Num_end">					  
       <xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="@Num"/>
      </xsl:otherwise>
     </xsl:choose>

  <xsl:if test="@PrereqExists='Y' and /Report/@rptPrereqIndicator='Y'">*<!-- asterisk --></xsl:if>
  <xsl:if test="@With_advice">
   <xsl:text>&#160;</xsl:text> <!-- space --> 
   <xsl:value-of select="@With_advice"/> 
  </xsl:if>
</xsl:template>

<!-- Qualifier advice on a course rule or subset -->
<xsl:template name="tQualAdvice">
  <xsl:for-each select="QualAdvice/Qual"> 
     <xsl:text>&#160;</xsl:text> <!-- space --> 
     <xsl:choose>
            <xsl:when test="@Classes or @Credits"> 
              additionally you need a minimum of
            </xsl:when>
            <xsl:otherwise> 
              <xsl:value-of select="@Text"/>
            </xsl:otherwise>
     </xsl:choose>
     <xsl:text>&#160;</xsl:text> <!-- space --> 
            <xsl:if test="@Credits"> 
                 <xsl:call-template name="tFormatNumber" >
                  <xsl:with-param name="iNumber" select="@Needed" />
                  <xsl:with-param name="sRoundingMethod" select="$vCreditDecimals" />
                </xsl:call-template>
                <xsl:text>&#160;</xsl:text> <!-- space --> 
                <xsl:call-template name="tCreditsLiteral"/> from 
            </xsl:if> 
            <xsl:if test="@Classes"> 
              <xsl:value-of select="@Needed"/> Classes from
            </xsl:if> 
     <xsl:for-each select="Course">   <!-- for each qualifier course -->
     <xsl:call-template name="tCourseAdvice"/>
        <xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses='Y'">
           <xsl:if test="position()!=last()">
              or                <!-- or -->
           </xsl:if>  
        </xsl:if> <!-- OR-ANDS=Y -->
        <xsl:if test="/Report/@rptShowOR-ANDsInsteadOfComma-Plusses!='Y'">
           <xsl:if test="position()!=last()">
              ,                 <!-- comma -->
           </xsl:if>  
        </xsl:if> <!-- OR-ANDS=Y -->
     </xsl:for-each> <!-- ADVICE/COURSE-->
  </xsl:for-each>
</xsl:template>

<xsl:template name="tCreditsLiteral">
<xsl:choose>
 <xsl:when test="@Credits = 1">
  <xsl:value-of select="normalize-space(/Report/@rptCreditSingular)" />
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="normalize-space(/Report/@rptCreditsLiteral)" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tIndentLevel">
  <xsl:choose>
    <xsl:when test="@IndentLevel = 1">  
    <fo:external-graphic width="0.01cm" height="0.36cm" src="../images/dwinvis1.gif"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 2">  
    <fo:external-graphic width="0.15cm" height="0.36cm" src="../images/dwinvis1.gif"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 3">  
    <fo:external-graphic width="0.30cm" height="0.36cm" src="../images/dwinvis1.gif"/>
    </xsl:when>
    <xsl:when test="@IndentLevel = 4">  
    <fo:external-graphic width="0.45cm" height="0.36cm" src="../images/dwinvis1.gif"/>
    </xsl:when>
    <xsl:otherwise>
     <fo:external-graphic width="0.60cm" height="0.36cm" src="../images/dwinvis1.gif"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Calculate the number of credits required -->
<xsl:template name="tCreditsRequired">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Block[1]/Header/Qualifier[@Node_type='4121']">
     <!-- xsl:if test="@Credits &gt; 0" -->	   
	 <xsl:choose>
     <xsl:when test="@Credits">
		<xsl:value-of select="@Credits" />
     </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - return 0 -->
		0
     </xsl:otherwise>
	 </xsl:choose>
   </xsl:for-each>
</xsl:template>

<!-- Check to see if credits or classes are required and show the corresponding value applied -->
<xsl:template name="tCheckCreditsClasses-Applied">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Header/Qualifier[@Node_type='4121']">
   <xsl:if test="not(@Pseudo)">
   <xsl:if test="position() = 1">
	 <xsl:choose>
     <xsl:when test="@Credits">	   

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="../../@Credits_applied"/>       <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>

	 </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - must be classes -->

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			Classes Applied:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="../../@Classes_applied"/>		 <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>
     </xsl:otherwise>
	 </xsl:choose>
   </xsl:if>
   </xsl:if>
   </xsl:for-each>

</xsl:template>


<!-- Check to see if credits or classes are required on this block and show the value -->
<xsl:template name="tCheckCreditsClasses-Required">	
   <!-- there will be only one 4121 node (Credits-Classes required) -->
   <xsl:for-each select="Header/Qualifier[@Node_type='4121']">
   <xsl:if test="not(@Pseudo)">
   <xsl:if test="position() = 1">
	 <xsl:choose>
     <xsl:when test="@Credits">	   

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
       <xsl:call-template name="tCreditsLiteral"/>
			 Required:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="@Credits"/>       <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>

	 </xsl:when>
     <xsl:otherwise> <!-- Credits not specified - must be classes -->

		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:choose>
			<xsl:when test="@Classes = 1">
				Class
			</xsl:when>
			<xsl:otherwise>
				Classes
			</xsl:otherwise>
			</xsl:choose>
			 Required:
		</fo:block>
		</fo:table-cell>
		<fo:table-cell display-align="center" text-align="right" >
		<fo:block keep-with-next.within-page="always">
			<xsl:value-of select="@Classes"/>		 <!-- get the value from the Block node -->
		</fo:block>
		</fo:table-cell>
     </xsl:otherwise>
	 </xsl:choose>
   </xsl:if>
   </xsl:if>
   </xsl:for-each>
</xsl:template>

<xsl:template name="tCondition">
  (
  <xsl:for-each select="LeftCondition"> 
   <xsl:call-template name="tCondition"/>
  </xsl:for-each>

  <xsl:value-of select="@Connector"/>

  <xsl:for-each select="RightCondition"> 
   <xsl:call-template name="tCondition"/>
  </xsl:for-each>

  <xsl:for-each select="Rop"> 
   <xsl:call-template name="tRop"/>
  </xsl:for-each>
  )
</xsl:template>

<xsl:template name="tRop">
  <xsl:value-of select="@Left"/> 
  <xsl:value-of select="@Operator"/> 
  <xsl:value-of select="@Right"/>
</xsl:template>

<xsl:template name="tCourseReq">
   <!-- Display the discipline only if the discipline isn't repeated --> 
   <xsl:if test="@NewDiscipline='Yes'">
    <xsl:value-of select="@Disc"/>
  <xsl:text>&#160;</xsl:text> <!-- space betweem disc and num --> 
  </xsl:if>     
  <xsl:choose>
   <xsl:when test="@Num_end">
    <xsl:value-of select="@Num"/>:<xsl:value-of select="@Num_end"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="@Num"/>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="@HideFromAdvice"> 
    (HideFromAdvice)
  </xsl:if>
  <xsl:if test="With"> 
   <xsl:apply-templates select="With"/>
  </xsl:if>
</xsl:template>

<xsl:template match="With">
(WITH <xsl:value-of select="@Code"/> 
      <xsl:value-of select="@Operator"/> 
      <xsl:for-each select="Value">  <!-- FOR EACH WITH VALUE -->
       <xsl:value-of select="."/>, 
      </xsl:for-each> <!-- WITH/VALUE -->
)
</xsl:template>
 
</xsl:stylesheet>
