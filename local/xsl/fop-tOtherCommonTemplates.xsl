<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xml.apache.org/fop/extensions">
<!-- $Id: //Tuxedo/RELEASE/Product/release/server/admin/xsl/fop-tOtherCommonTemplates.xsl#1 $ -->

<xsl:template name="FormatNoteDate">	
    <xsl:call-template name="FormatDate">
		<xsl:with-param name="pDate" select="@Note_date" />
    </xsl:call-template>
</xsl:template>
<xsl:template name="FormatXptDate">	
    <xsl:call-template name="FormatDate">
		<xsl:with-param name="pDate" select="@Date" />
    </xsl:call-template>
</xsl:template>

<xsl:template name="FormatRuleXptDate">	
    <xsl:call-template name="FormatDate">
		<xsl:with-param name="pDate" select="key('XptKey',concat(generate-id(ancestor::Audit),'-',@Id_num))/@Date" />
    </xsl:call-template>
</xsl:template>

<xsl:template name="FormatDate">	
<xsl:param name="pDate"/>
  <xsl:variable name="vDateFormat" select="/Report/@rptDateFormat"/>
  <xsl:variable name="vYear"  select="substring($pDate,1,4)"/>
  <xsl:variable name="vMonth" select="substring($pDate,5,2)"/>
  <xsl:variable name="vDay"   select="substring($pDate,7,2)"/>

  <xsl:choose>

    <xsl:when test="$vDateFormat='DMY'"> <!-- Europe/Australia/etc - 31/12/2009-->
     <xsl:value-of select="concat($vDay,'/',$vMonth,'/',$vYear)"/>
    </xsl:when>
  
    <xsl:when test="$vDateFormat='DXY'"> <!-- Europe/Australia/etc - 31DEC09-->
     <xsl:choose>
       <xsl:when test="$vMonth='01'"><xsl:value-of select="concat($vDay,'JAN',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='02'"><xsl:value-of select="concat($vDay,'FEB',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='03'"><xsl:value-of select="concat($vDay,'MAR',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='04'"><xsl:value-of select="concat($vDay,'APR',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='05'"><xsl:value-of select="concat($vDay,'MAY',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='06'"><xsl:value-of select="concat($vDay,'JUN',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='07'"><xsl:value-of select="concat($vDay,'JUL',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='08'"><xsl:value-of select="concat($vDay,'AUG',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='09'"><xsl:value-of select="concat($vDay,'SEP',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='10'"><xsl:value-of select="concat($vDay,'OCT',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='11'"><xsl:value-of select="concat($vDay,'NOV',substring($vYear,3,2))"/></xsl:when>
       <xsl:when test="$vMonth='12'"><xsl:value-of select="concat($vDay,'DEC',substring($vYear,3,2))"/></xsl:when>
       <xsl:otherwise>               <xsl:value-of select="concat($vDay,'???',substring($vYear,3,2))"/></xsl:otherwise>
     </xsl:choose>
    </xsl:when>
  
    <xsl:when test="$vDateFormat='YMD'"> <!-- China etc - 2009/12/31-->
     <xsl:value-of select="concat($vYear,'/',$vMonth,'/',$vDay)"/>
    </xsl:when>
  
    <xsl:otherwise> <!-- test="$vDateFormat='MDY'"> - USA format - 12/31/2009-->
     <xsl:value-of select="concat($vMonth,'/',$vDay,'/',$vYear)"/>
    </xsl:otherwise> 
  </xsl:choose>
</xsl:template>

<xsl:template name="tFormatNumber">
<xsl:param name="iNumber" />
<xsl:param name="sRoundingMethod" />
  <xsl:choose>
    <!-- If the number contains a range (eg: 0:4) -->
    <xsl:when test="contains ($iNumber, ':') ">
	 <xsl:value-of select="$iNumber" />
    </xsl:when>
    <xsl:otherwise>
	 <xsl:value-of select="format-number($iNumber, $sRoundingMethod)" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tStudentID">	
<xsl:variable name="stu_id"           select="normalize-space(AuditHeader/@Stu_id)"/>
<xsl:variable name="stu_id_length"    select="string-length(normalize-space(AuditHeader/@Stu_id))"/>
<xsl:variable name="bytes_to_remove"  select="$stu_id_length - /Report/@rptCFG020MaskStudentID"/>
<xsl:variable name="bytes_to_show"    select="$stu_id_length - $bytes_to_remove"/>
<xsl:variable name="myAsterisks">
<xsl:call-template name="tAsterisks" >
	<xsl:with-param name="bytes_to_remove" select="$bytes_to_remove" />
</xsl:call-template>
</xsl:variable>

<xsl:variable name="formatted_stu_id" />
<xsl:choose>
	<xsl:when test="/Report/@rptCFG020MaskStudentID = 'A'">  
		<xsl:value-of select="AuditHeader/@Stu_id"/> <xsl:copy-of select="$bytes_to_remove" />
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

<!-- Replace one string with another -->
<xsl:template name="globalReplace">
  <xsl:param name="outputString"/>
  <xsl:param name="target"/>
  <xsl:param name="replacement"/>
  <xsl:choose>
    <xsl:when test="contains($outputString,$target)">
      <xsl:value-of select="concat(substring-before($outputString,$target),$replacement)"/>
      <xsl:call-template name="globalReplace">
        <xsl:with-param name="outputString" select="substring-after($outputString,$target)"/>
        <xsl:with-param name="target"       select="$target"/>
        <xsl:with-param name="replacement"  select="$replacement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$outputString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
 
</xsl:stylesheet>
