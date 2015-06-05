<!-- 
 Copyright 1995-2012 Ellucian Company L.P. and its affiliates. 
 $Id: //Tuxedo/RELEASE/Product/webroot/AuditTranscript.xsl#3 $ -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 


<!-- CMU Localization === Included AuditStudentHeader.xsl to match other Audit .xsl files ==== -->
<!-- tStudentHeader template is in this included xsl; shared by athletic and fin-aid audits   -->
<xsl:include href="AuditStudentHeader.xsl" />


<xsl:variable name="vLabelSchool"     >Level</xsl:variable>
<xsl:variable name="vLabelDegree"     >Degree</xsl:variable>
<xsl:variable name="vLabelMajor"      >Major</xsl:variable>
<xsl:variable name="vLabelMinor"      >Minor</xsl:variable>
<xsl:variable name="vLabelCollege"    >College</xsl:variable>
<xsl:variable name="vLabelLevel"      >Classification</xsl:variable>
<xsl:variable name="vLabelAdvisor"    >Advisor</xsl:variable>
<xsl:variable name="vLabelStudentID"  >ID</xsl:variable>
<xsl:variable name="vLabelStudentName">Student</xsl:variable>
<xsl:variable name="vLabelOverallGPA" >Overall GPA</xsl:variable>
<xsl:variable name="vGPADecimals">0.000</xsl:variable>
<xsl:variable name="vCreditDecimals">0.###</xsl:variable>

<xsl:variable name="vShowCourseSignals">Y</xsl:variable>
<xsl:variable name="CourseSignalsHelpUrl">http://helpme.myschool.edu</xsl:variable>
<xsl:variable name="CourseSignalsRedLow"    >You are very much at risk of failing this class</xsl:variable>
<xsl:variable name="CourseSignalsRedHigh"   >You are at risk of failing this class</xsl:variable>
<xsl:variable name="CourseSignalsYellowLow" >You are doing okay but could do better</xsl:variable>
<xsl:variable name="CourseSignalsYellowHigh">You are doing okay but could do better</xsl:variable>
<xsl:variable name="CourseSignalsGreenLow"  >You are doing well - keep it up!</xsl:variable>
<xsl:variable name="CourseSignalsGreenHigh" >You are doing very well - keep it up!</xsl:variable>

<xsl:template match="Report/Audit">
  <html>
  <title><xsl:value-of select="/Report/@rptReportName"/></title>
  <link rel="stylesheet" href="DGW_Style.css" type="text/css" />
  <body style="margin: 5px;">

<!-- // School Header // -->
<xsl:call-template name="tSchoolHeader"/>

<!-- // Student Header // -->
<xsl:if test="/Report/@rptShowStudentHeader='Y'">
<xsl:call-template name="tStudentHeader"/>
</xsl:if>

<br />



<!-- CMU Localization === Added disclaimer ================================================================== -->
   <table border="0" cellspacing="1" cellpadding="0" width="100%" class="Blocks">
      <tr>
      <td colspan="20">
      <table border="0" cellspacing="0" cellpadding="0" width="100%" class="BlockHeader">
         <tr >
            <td class="BlockHeader" colspan="1" rowspan="2" valign="middle" nowrap="true">
               &#160;Disclaimer:
            </td>
         </tr>
      </table>
      </td>
      </tr>
      <tr >
         <td class="DisclaimerText">
			This is not your unofficial or official transcript and does not list your 
			academic standing. It is meant to be used with Degree Works as a summary 
			of classes taken. Visit the MAVzone Student Academics Tab to obtain a copy 
			of your transcript.
         </td>
      </tr>
   </table>
   <br/>
<!-- CMU Localization === End of Added disclaimer =========================================================== -->


<table border="0" cellspacing="0" cellpadding="1" width="100%" class="AuditTable">

 <xsl:for-each select="Clsinfo/Class[@Rec_type != 'G']"> <!-- omit Ghost records -->
   <xsl:sort select="@Term" order="ascending"/>
   <xsl:choose>
    <xsl:when test="preceding-sibling::Class[@Rec_type != 'G']/@Term = @Term">
      <!-- same term - do nothing -->
    </xsl:when>
    <xsl:otherwise> <!-- Show all of the classes for this term -->
      <tr >
       <td colspan="10" class="BlockHeader" >
 	     <xsl:text>&#160;</xsl:text> <!-- space --> 
 	     <xsl:text>&#160;</xsl:text> <!-- space --> 
         <xsl:value-of select="@TermLit"/>
       </td>
	    </tr>
      
      <xsl:call-template name="tShowTerm">
	      <xsl:with-param name="pTerm" select="@Term" />
      </xsl:call-template> 
    </xsl:otherwise>
    </xsl:choose>
   
 </xsl:for-each>

</table>

<xsl:if test="$vShowCourseSignals='Y'">
<xsl:call-template name="tCourseSignalsHelp" />
<br />
</xsl:if>


  </body>
  </html>
</xsl:template>

<!-- CourseSignals help link -->
<!-- Only appears if the student has at least one red signal for an in-progress class -->
<xsl:template name="tCourseSignalsHelp">
	    <xsl:if test="/Report/Audit/Clsinfo/Class[@In_progress='Y']/Attribute[@Code='COURSESIGNAL' and @Value='RED']">
			<table border="0" cellspacing="0" cellpadding="0" width="80%" class="bgLight0" align="center">
		    <tr>
			  <td rowspan="20" colspan="20" align="center">
				   <img src="common/coursesignals-red.png" title="You should seek help"/>
			  </td>
		    </tr>
			<tr >
				<td class="bgLight0" colspan="1" rowspan="2" valign="middle" xxnowrap="false" align="center">
					&#160;You are having trouble with your classes this semester. 
					We encourage you to make use of the services on campus to help you succeed.
					&#160;Please review the many ways we can help you by visiting 
					<a title="Get help" target="newCourseSignalsWindow">
                    <xsl:attribute name="href"><xsl:copy-of select="$CourseSignalsHelpUrl"/></xsl:attribute>
                    <xsl:copy-of select="$CourseSignalsHelpUrl"/>
					</a>
				</td>
				<!-- <td align="right" width="10%">				</td> -->
			</tr>
	      </table>
	   </xsl:if> <!-- help link -->
</xsl:template>

<xsl:template name="tSchoolHeader"> 
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- School Name: Using Text -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<table border="0" cellspacing="0" cellpadding="0" width="100%" class="SchoolName">												  
	<tr>
		<td align="left" valign="top">
		<table border="0" cellspacing="0" cellpadding="4" width="100%">		 
			<tr>
				<td align="center" valign="middle">
				<span class="SchoolName"><xsl:value-of select="/Report/@rptInstitutionName" />
				</span>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- FOR_CUSTOMIZING:SCHOOLNAME -->
<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- School Name: To use an image, replace the <img src> tag below.
<table border="0" cellspacing="0" cellpadding="0" width="100%" class="SchoolName">												  
	<tr>
		<td align="left" valign="top">
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td align="center" valign="middle">
				<img src="Images_DG2/Icon_DegreeWorks.gif" />
				<br />
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table> -->
<!-- //////////////////////////////////////////////////////////////////////// -->
</xsl:template>

<!-- CMU Localization - comment out tStudent header since it is included in the include statement above
<xsl:template name="tStudentHeader"> 

<xsl:for-each select="AuditHeader">
<table border="0" cellspacing="0" cellpadding="0" width="100%" class="AuditTable">

	<tr>                                                                          
		<td align="left" valign="top">                                               
		<table border="0" cellspacing="0" cellpadding="4" width="100%">
			<tr>
				<td align="left" valign="middle" class="StuHead">
				<span class="StuHeadTitle"> <xsl:value-of select="/Report/@rptReportName" /> </span>
				<span class="StuHeadCaption">&#160; &#160;<xsl:value-of select="@Audit_id" /> as of         
					<xsl:value-of select="@DateMonth" />/<xsl:value-of select="@DateDay"   />/<xsl:value-of select="@DateYear"  /> 
			        at *** Format the time as hh:mm *** <xsl:value-of select="@TimeHour" />:<xsl:value-of select="@TimeMinute" />
				</span>
				</td>
				<td align="right" valign="middle" class="StuHead">
				  ***This will be "What If Audit" or "Look Ahead Audit"; for normal audits this attribute will not exist ****
				  <span class="StuHeadTitle"> <xsl:value-of select="/Report/@rptAuditAction" /> </span>
				<br />
				</td>
			</tr>
		</table>
		</td>
	</tr>
		
	<tr>
		<td>
		<table class="Inner" cellspacing="1" cellpadding="3" border="0" width="100%">

 *** xxxxxxxxxxx NEXT ROW xxxxxxxxxxx ***
  <tr class="StuTableTitle">
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelStudentName"/></td>
    <td class="StuTableData" >
        <xsl:value-of select="/Report/Audit/AuditHeader/@Stu_name" />  
    </td>
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelSchool"/></td>
    <td class="StuTableData" ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@SchoolLit" />  </td>
  </tr>
  *** xxxxxxxxxxx NEXT ROW xxxxxxxxxxx ***
  <tr class="StuTableTitle">
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelStudentID"/></td>
    <td class="StuTableData"  >	<xsl:for-each select="/Report/Audit"><xsl:call-template name="tStudentID" /> </xsl:for-each></td>
    <td class="StuTableTitle"  ><xsl:copy-of select="$vLabelDegree"/> </td>
    <td class="StuTableData"   ><xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@DegreeLit" /> &#160;  </td>
  </tr>
 *** xxxxxxxxxxx NEXT ROW xxxxxxxxxxx ***
  <tr class="StuTableTitle">
      <td class="StuTableTitle" ><xsl:copy-of select="$vLabelLevel"/></td>
      <td class="StuTableData"  >
        <xsl:value-of select="/Report/Audit/Deginfo/DegreeData/@Stu_levelLit" /> &#160; 
      </td>
    <td class="StuTableTitle" >
		<xsl:copy-of select="$vLabelCollege"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='COLLEGE'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='COLLEGE']">
		<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>	
	</td>
  </tr>
 *** xxxxxxxxxxx NEXT ROW xxxxxxxxxxx ***
  <tr class="StuTableTitle">
    <td class="StuTableTitle"  >
		<xsl:copy-of select="$vLabelAdvisor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='ADVISOR'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"   >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='ADVISOR']">
      <a>
        <xsl:attribute name="href">mailto:<xsl:value-of select="@Advisor_email" 
               />?cc=<xsl:value-of select="/Report/Audit/AuditHeader/@Stu_email" /> &amp;subject=Advising Worksheet question&amp;body=I have a question about my worksheet.</xsl:attribute>
        <xsl:attribute name="title">Email this advisor</xsl:attribute>
        <xsl:value-of select="@Advisor_name" />
      </a>&#160;  
	<xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>
    </td>
    <td class="StuTableTitle" >
		<xsl:copy-of select="$vLabelMajor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='MAJOR'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='MAJOR']">
		<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>
	</td>
  </tr>
 *** xxxxxxxxxxx NEXT ROW xxxxxxxxxxx ***
  <tr class="StuTableTitle">
    <td class="StuTableTitle" ><xsl:copy-of select="$vLabelOverallGPA"/></td>
    <xsl:choose>
      <xsl:when test="/Report/@rptShowStudentSystemGPA='Y'">
      ***If the SSGPA is empty then show the DWGPA value***
        <xsl:choose>
	  <xsl:when test="normalize-space(@SSGPA)=''">*** SSGPA is empty/blanks***
	    <td class="StuTableData"  >
			<xsl:call-template name="tFormatNumber" >
				<xsl:with-param name="iNumber"         select="@DWGPA" />
				<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
			</xsl:call-template>
		</td>
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="StuTableData"  >
			<xsl:call-template name="tFormatNumber" >
				<xsl:with-param name="iNumber" select="@SSGPA" />
				<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
			</xsl:call-template>
		</td>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> *** We always want to show the DWGPA ***
	<td class="StuTableData"  >
			<xsl:call-template name="tFormatNumber" >
				<xsl:with-param name="iNumber" select="@DWGPA" />
				<xsl:with-param name="sRoundingMethod" select="$vGPADecimals" />
			</xsl:call-template>
	</td>
      </xsl:otherwise>
    </xsl:choose>
    <td class="StuTableTitle" >
		<xsl:copy-of select="$vLabelMinor"/><xsl:if test="count(/Report/Audit/Deginfo/Goal[@Code='MINOR'])>1">s</xsl:if>
	</td>
    <td class="StuTableData"  >
    <xsl:for-each select="/Report/Audit/Deginfo/Goal[@Code='MINOR']">
		<xsl:value-of select="@ValueLit" /><xsl:if test="position()!=last()"><br /></xsl:if>
	</xsl:for-each>
	</td>

    </tr>
  </table>
	</td></tr>	
</table>
  </xsl:for-each> *** audit header ***
</xsl:template> 

CMU Localization - comment out tStudent header since it is included in the include statement above -->

<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- STUDENT HEADER END -->
<!-- //////////////////////////////////////////////////////////////////////// -->


<!-- If this is the first class for this term then show its term lit -->
<xsl:template name="tShowTerm" >
 <xsl:param name="pTerm" />
 <xsl:for-each select="/Report/Audit/Clsinfo/Class[@Rec_type != 'G']"> <!-- omit Ghost records -->

   <!-- Sort the classes by term so we can create term headers -->
   <!-- Within term sort by disc and num -->
   <xsl:sort select="@Discipline" order="ascending" data-type="text"/> 
   <xsl:sort select="@Number"     order="ascending" data-type="text"/>
   <!--
   <xsl:sort select="@Term" order="ascending" data-type="text"/>
   <xsl:sort select="concat(substring-before(@Discipline,'_'), substring-after(@Discipline,'_'))" order="ascending" data-type="text"/> 
   -->


   <!-- omit split-credit classes because they'll display properly 
        with their "regular" clsinfo instance; omit Nocount classes also -->
   <xsl:if test="substring(@Id_num,1,1) != 'F' and
                 substring(@Id_num,1,1) != 'N' and
                 substring(@Id_num,1,1) != 'S' and
                 @Term = $pTerm" >

  <tr >
    <xsl:if test="position() mod 2 = 0">
     <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
    </xsl:if>
    <xsl:if test="position() mod 2 = 1">
     <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
    </xsl:if>
	<td width="6%">           </td>
	<td width="6%"  class="TranscriptCourseKey" ><xsl:value-of select="@Discipline"/></td>
	<td width="6%"  class="TranscriptCourseKey"><xsl:value-of select="@Number"/>    </td>
	<td width="200" class="SectionCourseTitle"> <xsl:value-of select="@Course_title"/></td>
	<td width="6%"  class="SectionCourseGrade">
	   <xsl:choose>
       <xsl:when test="$vShowCourseSignals='Y'">  <!-- CourseSignals -->
	     <xsl:choose>
           <!-- Effort - contains both the color and the high/low value -->
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='SIGNALEFFORT' and @Value='6']">
        	  <img src="common/coursesignals-red.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsRedLow"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='SIGNALEFFORT' and @Value='5']">
        	  <img src="common/coursesignals-red.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsRedHigh"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='SIGNALEFFORT' and @Value='4']">
        	  <img src="common/coursesignals-yellow.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsYellowLow"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='SIGNALEFFORT' and @Value='3']">
        	  <img src="common/coursesignals-yellow.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsYellowHigh"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='SIGNALEFFORT' and @Value='2']">
        	  <img src="common/coursesignals-green.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsGreenLow"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='SIGNALEFFORT' and @Value='1']">
        	  <img src="common/coursesignals-green.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsGreenHigh"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <!-- Effort is missing so just rely on the signal color -->
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='COURSESIGNAL' and @Value='RED']">
        	  <img src="common/coursesignals-red.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsRedHigh"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='COURSESIGNAL' and @Value='YELLOW']">
        	  <img src="common/coursesignals-yellow.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsYellowHigh"/></xsl:attribute>
        	  </img>
            </xsl:when>
            <xsl:when test="@In_progress='Y' and descendant::Attribute[@Code='COURSESIGNAL' and @Value='GREEN']">
        	  <img src="common/coursesignals-green.png">
                <xsl:attribute name="title"><xsl:copy-of select="$CourseSignalsGreenHigh"/></xsl:attribute>
        	  </img>
            </xsl:when>

	     <xsl:otherwise> <!-- no signal on this class - just show the grade -->
	     <xsl:value-of select="@Letter_grade"/> 
	     <xsl:text>&#160;</xsl:text> <!-- space --> 
	     </xsl:otherwise>
	     </xsl:choose>
	   </xsl:when>

	   <xsl:otherwise> <!-- CourseSignals is turned off - just how the grade -->
	     <xsl:value-of select="@Letter_grade"/> 
	     <xsl:text>&#160;</xsl:text> <!-- space --> 
	   </xsl:otherwise>
	   </xsl:choose>
	</td>
	<td width="6%"  class="SectionCourseCredits"><xsl:value-of select="@Credits"/>   </td>
	<td width="50"> <!-- spacer -->   </td>
  </tr>
  <!-- If this is a transfer class show more information -->
  <xsl:if test="@Transfer='T'">
  <tr >
	<xsl:if test="position() mod 2 = 0">
	 <xsl:attribute name="class">CourseAppliedRowAlt</xsl:attribute>
	</xsl:if>
	<xsl:if test="position() mod 2 = 1">
	 <xsl:attribute name="class">CourseAppliedRowWhite</xsl:attribute>
	</xsl:if>
	<td align="center" colspan="3" class="TranscriptCourseKey">
	</td>
	<td colspan="5" class="SectionCourseTitle">
	<b><i>Transferred from</i></b> &#160;
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
	</td>
  </tr>
  </xsl:if>

  </xsl:if>

  </xsl:for-each>


</xsl:template>


<!-- CMU Localization === Removed the tStudentHeader that was located since we are === -->
<!--      using the tStudentHeader template in the included AuditStudentHeader.xsl file -->

<!-- If this is the first class for this term then show its term lit -->
<xsl:template name="tFirstTerm" >
 <xsl:param name="term" />
<xsl:choose>
  <xsl:when test="preceding-sibling::Class[@Rec_type != 'G']/@Term = $term">
    <!-- same term - do nothing -->
  </xsl:when>
  <xsl:otherwise>
        <tr >
          <td colspan="10" class="BlockHeader" >
 	     <xsl:text>&#160;</xsl:text> <!-- space --> 
 	     <xsl:text>&#160;</xsl:text> <!-- space --> 
                <xsl:value-of select="@TermLit"/>
           </td>
	    </tr>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tStudentID">	
<xsl:variable name="stu_id"           select="normalize-space(AuditHeader/@Stu_id)"/>
<xsl:variable name="stu_id_length"    select="string-length(normalize-space(AuditHeader/@Stu_id))"/>
<xsl:variable name="fill_asterisks"   select="$stu_id_length"/>
<xsl:variable name="bytes_to_remove"  select="/Report/@rptCFG020MaskStudentID"/>

<xsl:variable name="bytes_to_show"    select="$stu_id_length - $bytes_to_remove"/>
<xsl:variable name="myAsterisks">
<xsl:call-template name="tAsterisks" >
	<xsl:with-param name="bytes_to_remove" select="$bytes_to_remove" />
</xsl:call-template>
</xsl:variable>

<xsl:variable name="formatted_stu_id" />
<xsl:choose>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'A'">  
		<xsl:call-template name="tFillAsterisks" >
			<xsl:with-param name="string_length" select="$fill_asterisks" />
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'N'">  
		<xsl:value-of select="AuditHeader/@Stu_id"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="concat($myAsterisks, substring($stu_id, $bytes_to_remove + 1, $bytes_to_show))" />
	</xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template name="tAsterisks">
<xsl:param name="bytes_to_remove" />
<xsl:variable name="decrement" select="$bytes_to_remove - 1" />
<xsl:if test="$decrement &gt; -1">*<xsl:call-template name="tAsterisks"><xsl:with-param name="bytes_to_remove" select="$decrement" /></xsl:call-template></xsl:if>
</xsl:template>
            
<xsl:template name="tFillAsterisks">
<xsl:param name="string_length" />
<xsl:variable name="decrement" select="$string_length - 1" />
<xsl:if test="$decrement &gt; -1">*<xsl:call-template name="tFillAsterisks"><xsl:with-param name="string_length" select="$decrement" /></xsl:call-template></xsl:if>
</xsl:template>

<xsl:template name="tFormatNumber">
<xsl:param name="iNumber" />
<xsl:param name="sRoundingMethod" />
	<xsl:value-of select="format-number($iNumber, $sRoundingMethod)" />
</xsl:template>

<!-- CMU Localization === Added Format Date template ==== -->
<!-- FormatDate template is in this included xsl -->
<xsl:include href="FormatDate.xsl" />

</xsl:stylesheet>
