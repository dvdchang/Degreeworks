<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tSections.xsl#7 $ -->

<xsl:template name="tSections">       
	<!--//////////////////////////////////////////////////// 
		// Fallthrough Section							-->
	<xsl:if test="/Report/@rptShowFallThroughSection='Y'">
		<xsl:call-template name="tSectionFallthrough"/>
	</xsl:if> 
	<!--//////////////////////////////////////////////////// 
		// Insufficient Section							-->
		<xsl:if test="/Report/@rptShowInsufficientSection='Y'">
			<xsl:call-template name="tSectionInsufficient"/>
		</xsl:if> 
	<!--//////////////////////////////////////////////////// 
		// Inprogress Section (aka In-Progress)			-->
		<xsl:if test="/Report/@rptShowInProgressSection='Y'">
			<xsl:call-template name="tSectionInprogress"/>
		</xsl:if> 
	<!--//////////////////////////////////////////////////// 
		// Not Counted Section (aka OTL, Over-the-limit) -->
		<xsl:if test="/Report/@rptShowOverTheLimitSection='Y'">
			<xsl:call-template name="tSectionOTL"/>
		</xsl:if> 

	<!--//////////////////////////////////////////////////// 
		// Exceptions -->
		<xsl:if test="/Report/@rptShowExceptionsSection='Y'">
		<xsl:if test="ExceptionList/Exception">
			<xsl:call-template name="tSectionExceptions"/>
		</xsl:if> 
		</xsl:if> 

		<!-- //////////////////////////////////////////////////////////////////////// -->
		<!-- Notes -->
		<!-- //////////////////////////////////////////////////////////////////////// -->
		<xsl:if test="/Report/@rptShowNotesSection='Y'">
		<xsl:if test="Notes/Note[@Note_type != 'PL']">
			<xsl:call-template name="tSectionNotes"/>
		</xsl:if> 
		</xsl:if> 

</xsl:template>

<xsl:template name="tSectionFallthrough">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="Fallthrough">
<xsl:if test="@Classes &gt; 0 or count(Noncourse) &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F0F0F0"  space-after="0.3cm"
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
			<!-- CMU Localization === Changed background-color and removed background-image
			<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
			<fo:table-row background-color="#5D0022">
			<!-- Block checkbox, Title -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelFallthrough" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
    <xsl:for-each select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))">
    <xsl:if test="@Rec_type != 'G'">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
            <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_course"/>
            <!-- Show the transfer course title and transfer school name - if they exist -->                        
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle"/>
            </xsl:if>
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school"/>
            </xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	  </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	
   <xsl:for-each select="Noncourse"> 
      <xsl:call-template name="tShowNoncourse"/> <!-- in fop-tBlocks.xsl -->
   </xsl:for-each> 
  
  </fo:table-body>
	</fo:table>
</xsl:if>
</xsl:for-each> <!-- select="Fallthrough" -->
</xsl:template>

<xsl:template name="tSectionInsufficient">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="Insufficient">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F0F0F0"  space-after="0.3cm"
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<!-- CMU Localization === Changed background-color and removed background-image
			<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
			<fo:table-row background-color="#5D0022"> <!-- Block checkbox, Title -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelInsufficient" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
    <xsl:for-each select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))">
    <xsl:if test="@Rec_type != 'G'">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
            <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_course"/>
            <!-- Show the transfer course title and transfer school name - if they exist -->                        
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle"/>
            </xsl:if>
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school"/>
            </xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	  </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</fo:table-body>
	</fo:table>
</xsl:if>
</xsl:for-each> <!-- select="Insufficient" -->
</xsl:template>

<xsl:template name="tSectionInprogress">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="In_progress">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm"
			background-color="#F0F0F0"  space-after="0.3cm"
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<!-- CMU Localization === Changed background-color and removed background-image
			<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
			<fo:table-row background-color="#5D0022"> <!-- Block checkbox, Title -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelInprogress" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
                      <fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
                      </fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))[@In_progress='Y']/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
            <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_course"/>
            <!-- Show the transfer course title and transfer school name - if they exist -->                        
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle"/>
            </xsl:if>
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school"/>
            </xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	</xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->


	</fo:table-body>

	</fo:table>

    <xsl:if test="$vShowCourseSignals='Y'">
      <xsl:call-template name="tCourseSignalsHelp" />
	</xsl:if>

</xsl:if>
</xsl:for-each> <!-- select="Inprogress" -->
</xsl:template>


<xsl:template name="tSectionOTL">
<!-- If there is at least 1 fallthrough class listed -->
<xsl:for-each select="OTL">
<xsl:if test="@Classes &gt; 0">

	<fo:table table-layout="fixed" width="19cm" 
			background-color="#F0F0F0"  space-after="0.3cm"
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="13cm"/>
		<fo:table-column column-width="3.0cm"/>
		<fo:table-column column-width="3.0cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<!-- CMU Localization === Changed background-color and removed background-image
			<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
			<fo:table-row background-color="#5D0022"> <!-- Block checkbox, Title -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						<xsl:copy-of select="$LabelOTL" />
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						<xsl:value-of select="/Report/@rptCreditsLiteral" /> Applied: 
						<xsl:value-of select="@Credits"/>
					</fo:block>
			</fo:table-cell>
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center">
				<fo:block font-size="6pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
						Classes Applied: 
						<xsl:value-of select="@Classes"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='Y'">
	<fo:table-row>
		<fo:table-cell number-columns-spanned="3" padding-top="0.5pt" padding-bottom="0.5pt" >
		<fo:block font-size="8pt">
		<xsl:for-each select="Class">
			<xsl:value-of select="@Discipline"/>
			<xsl:text>&#160;</xsl:text> <!-- space --> 
			<xsl:value-of select="@Number"/> 
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@In_progress='Y'">&#160;(IP)</xsl:if> <!-- (IP) = In-progress -->
			<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">&#160;(T)</xsl:if> <!-- (T) = Transfer -->
			<xsl:if test="position()!=last()">, </xsl:if>  <!-- comma -->
		</xsl:for-each>
		</fo:block>
		</fo:table-cell >
	</fo:table-row>
	</xsl:if> <!-- show-course-keys-only = Y -->

	<xsl:if test="/Report/@rptShowClassCourseKeysOnly='N'">
	<xsl:for-each select="Class">
    <xsl:variable name="tReason"><xsl:value-of select="@Reason"/></xsl:variable>
    <xsl:for-each select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))">
    <xsl:if test="@Rec_type != 'G'">
		<fo:table-row>
			<fo:table-cell padding-left="0pt" padding-top="0.3pt" padding-bottom="0.0pt" display-align="center"
			               number-columns-spanned="3">

			<fo:table table-layout="fixed" width="19cm" 
					border-spacing="0pt" font-size="8pt">
				<fo:table-column column-width="4cm"/> <!-- Course Key -->
				<fo:table-column column-width="7cm"/> <!-- Title      -->
				<fo:table-column column-width="2cm"/> <!-- Grade      -->
				<fo:table-column column-width="2cm"/> <!-- Credits    -->
				<fo:table-column column-width="4cm"/> <!-- Term Taken -->

				<fo:table-body>
				<fo:table-row>

					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="@Discipline"/>
						<xsl:text>&#160;</xsl:text> <!-- space --> 
						<xsl:value-of select="@Number"/>    
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<!-- Title: -->
						<!-- Use the Id_num attribute on this node to lookup the Class info
						on the Clsinfo/Cass node and get the Title -->     
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Course_title"/>
						</fo:block>
						<!-- CMU Localization === Remove reason description
                        <xsl:if test="@Reason">
						<fo:block font-size="6pt" font-style="italic">
						
						<xsl:value-of select="@Reason"/> 
						-->
<!--
                        <xsl:call-template name="globalReplace">
                          <xsl:with-param name="outputString" select="@Reason"/>
                          <xsl:with-param name="target"       select="'credits'"/>
                          <xsl:with-param name="replacement"  select="normalize-space(/Report/@rptCreditsLiteral)"/>
                        </xsl:call-template>
-->
					<!-- </fo:block>
                        </xsl:if> -->
						<!-- CMU Localization === Remove reason description -->
					
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
                        <xsl:call-template name="tCourseSignalsGrade"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:call-template name="CheckInProgressAndPolicy5"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center">
						<fo:block font-size="8pt">
						<xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TermLit"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
		<!-- If this is a transfer class show more information -->
		<xsl:if test="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer='T'">
		<fo:table-row>
			<fo:table-cell  
							padding-left="15pt" padding-top="0.1pt" padding-bottom="0.0pt" display-align="center"
							number-columns-spanned="3">
				<fo:block font-size="8pt">
				<fo:inline font-weight="bold">
				Satisfied by: &#160;
				</fo:inline>
            <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_course"/>
            <!-- Show the transfer course title and transfer school name - if they exist -->                        
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@TransferTitle"/>
            </xsl:if>
            <xsl:if test="normalize-space(key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school) != ''"> 
              <xsl:text> - </xsl:text> <!-- hyphen --> 
              <xsl:value-of select="key('ClsKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Transfer_school"/>
            </xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	  </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
	</xsl:if> <!-- show-course-keys-only = N -->
	</fo:table-body>
	</fo:table>
</xsl:if>
</xsl:for-each> <!-- select="OTL" -->
</xsl:template>

<xsl:template name="tSectionExceptions">
	<fo:table table-layout="fixed" width="19cm" 
			background-color="#EFEFEF"  space-after="0.3cm"
			border-spacing="0pt" font-size="8pt">
		<fo:table-column column-width="3cm"/>
		<fo:table-column column-width="8cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>
		<fo:table-column column-width="2cm"/>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="6"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<!-- CMU Localization === Changed background-color and removed background-image
			<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
			<fo:table-row background-color="#5D0022"> <!-- Block checkbox, Title -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center" number-columns-spanned="6" >
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						Exceptions
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="6"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<fo:table-row>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Type
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Description
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Date
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Who
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Block
		</fo:block>
		</fo:table-cell>
		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Enforced
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	<xsl:for-each select="ExceptionList/Exception">

	<fo:table-row>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:call-template name="tExceptionType"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Label"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:call-template name="FormatXptDate"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Who"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Req_id"/>
		</fo:block>
		</fo:table-cell>
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Enforced"/>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	</xsl:for-each>

</fo:table-body>
</fo:table>

</xsl:template> <!-- tsectionexceptions -->

<xsl:template name="tExceptionType">
           <xsl:choose>
            <xsl:when test="@Type = 'AH'">  
		      Apply Here
            </xsl:when>
            <xsl:when test="@Type = 'AA'">  
		      Also Allow
            </xsl:when>
            <xsl:when test="@Type = 'FC'">  
		      Force Complete
            </xsl:when>
            <xsl:when test="@Type = 'RR'">  
		      Substitution
            </xsl:when>
            <xsl:when test="@Type = 'NN'">  
		      Remove Course / Change the Limit
            </xsl:when>
            <xsl:otherwise>
		     Unknown
            </xsl:otherwise>
          </xsl:choose>
</xsl:template>

<xsl:template name="tSectionNotes">
  <xsl:variable name="vUserIsStudent">
    <xsl:choose>
    <xsl:when test="/Report/@rptUsersId = AuditHeader/@Stu_id">Y</xsl:when> 
    <xsl:otherwise>N</xsl:otherwise> 
    </xsl:choose>
  </xsl:variable>
	<fo:table table-layout="fixed" width="19cm" 
			background-color="#EFEFEF"  space-after="0.3cm"
			border-spacing="0pt" font-size="8pt">
        <xsl:choose>
        <xsl:when test="/Report/@rptShowNoteCheckbox='Y' and $vUserIsStudent='N'"> 
         <fo:table-column column-width="2cm"/> <!-- internal -->
         <fo:table-column column-width="13cm"/>
         <fo:table-column column-width="2cm"/>
         <fo:table-column column-width="2cm"/>
        </xsl:when>

        <xsl:otherwise> <!-- do not show the internal flag -->
         <fo:table-column column-width="15cm"/>
         <fo:table-column column-width="2cm"/>
         <fo:table-column column-width="2cm"/>
        </xsl:otherwise>
        </xsl:choose>

		<fo:table-body>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.0pt" padding-bottom="0.1pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>

			<!-- CMU Localization === Changed background-color and removed background-image
			<fo:table-row background-color="#5B788F" background-image="../images/bg-header.gif" background-repeat="repeat-x"> -->
			<fo:table-row background-color="#5D0022"> <!-- Block checkbox, Title -->
			<fo:table-cell padding-left="5pt" padding-top="1pt" display-align="center" number-columns-spanned="3" >
				<fo:block font-size="10pt" 
						font-family="sans-serif" 
						line-height="18pt"
						space-after.optimum="15pt"
						color="#fff"
						text-align="justify"
						padding-top="3pt"
						padding-bottom="0pt"
						padding-left="2pt">
					<fo:inline font-weight="bold" >
						Notes
					</fo:inline>
				</fo:block> 
			</fo:table-cell>
		</fo:table-row>

		<fo:table-row > <!-- Row for making the block header look nice (no content) -->
			<fo:table-cell background-color="#5B788F" padding-left="5pt" padding-top="0.1pt" padding-bottom="0.0pt" number-columns-spanned="3"  display-align="center">
				<fo:block font-size="12pt" >
				</fo:block>
			</fo:table-cell>
		</fo:table-row>


	<fo:table-row>
    <xsl:if test="/Report/@rptShowNoteCheckbox='Y' and $vUserIsStudent='N'"> 
      <fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" text-align="center">
      <fo:block font-size="8pt">
        Internal
      </fo:block>
      </fo:table-cell>
    </xsl:if>

		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			
		</fo:block>
		</fo:table-cell>

		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Who
		</fo:block>
		</fo:table-cell>

		<fo:table-cell padding-top="0.5pt" padding-bottom="0.5pt" color="#5B788F" >
		<fo:block font-size="8pt">
			Date
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	<xsl:for-each select="Notes/Note[@Note_type != 'PL']">

	<fo:table-row>
		<!-- internal flag -->
    <xsl:if test="/Report/@rptShowNoteCheckbox='Y' and $vUserIsStudent='N'"> 
		 <fo:table-cell text-align="center">
		 <fo:block font-size="8pt">
              <xsl:choose>
              <xsl:when test="substring(@Note_type,2,1)='I'"> <!-- Internal -->
			  	<fo:external-graphic width="0.36cm" height="0.36cm"  src="../images/internal-note-checkmark.gif" /> 
              </xsl:when>
              <xsl:otherwise>
                &#160;
              </xsl:otherwise>
              </xsl:choose>
		 </fo:block>
		 </fo:table-cell>
    </xsl:if>
		<!-- note text -->
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:for-each select="./Text"><xsl:value-of select="."/></xsl:for-each>
		</fo:block>
		</fo:table-cell>
		<!-- users's name -->
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:value-of select="@Note_who"/> 
		</fo:block>
		</fo:table-cell>
		<!-- create date -->
		<fo:table-cell >
		<fo:block font-size="8pt">
			<xsl:call-template name="FormatNoteDate"/>
		</fo:block>
		</fo:table-cell>
	</fo:table-row>

	</xsl:for-each>

</fo:table-body>
</fo:table>

</xsl:template> <!-- tsectionnotes -->



</xsl:stylesheet>
