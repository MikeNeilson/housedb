<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" media-type="text/yml" />
<xsl:strip-space elements="*"/>
<xsl:variable name="nl"><xsl:text>&#xa;</xsl:text></xsl:variable>
<!-- use technique from https://stackoverflow.com/a/11194007 -->
<xsl:template name="indent">
  <xsl:param name="depth" />
  <xsl:if test="$depth > 0">
   <xsl:value-of select="'  '"/>
   <xsl:call-template name="indent">
    <xsl:with-param name="depth" select="$depth - 1"/>
   </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
---
openapi: 3.0.3
components:
<xsl:call-template name="schemas"/>
  
  responses:
  securitySchemes:
  paths:
...    
</xsl:template>

<xsl:template name="schemas">
<xsl:variable name="indent" select="count(ancestor::*)" />
  <xsl:call-template name="indent">
   <xsl:with-param name="depth" select="$indent"/>
  </xsl:call-template>  
schemas:
<xsl:apply-templates select="//para[contains(.,'@schema')]/ancestor::compounddef[@kind='class']"/>
</xsl:template>
    


<xsl:template match="compounddef[@kind='class']">  
    <xsl:variable name="indent" select="count(ancestor::*)" />
    <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$indent"/>
    </xsl:call-template>
    <xsl:variable name="className" select="concat(replace(compoundname,'::','.'),':',$nl)"/>
    <xsl:value-of select="$className"/>
    <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$indent+1"/>
    </xsl:call-template>
    <xsl:value-of select="concat('type: object', $nl)"/>
    
    <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$indent+1"/>
    </xsl:call-template>
    <xsl:value-of select="concat('properties:', $nl)"/>
    <xsl:apply-templates select=".//memberdef[@kind='variable']"/>
</xsl:template>

<xsl:template match="memberdef[@kind='variable']">
    <xsl:if test="not(contains(briefdescription/para,'schema_ignore'))">
        <xsl:variable name="indent" select="count(ancestor::*)" />
        <xsl:call-template name="indent">
            <xsl:with-param name="depth" select="$indent"/>
        </xsl:call-template>
        <xsl:apply-templates select="./type/text"/>
        <xsl:value-of select="concat(./name,':',$nl)"/>
        <xsl:apply-templates select="./type"/>
        <xsl:if test="position() &lt; last()"><xsl:value-of select="$nl"/></xsl:if>    
    </xsl:if>
</xsl:template>

<xsl:template match="memberdef/type[text()='uint64_t']" >
    <xsl:variable name="indent" select="count(ancestor::*)" />
    <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$indent"/>
    </xsl:call-template>
    <xsl:value-of select="concat('type: integer',$nl)"/>
    <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$indent"/>
    </xsl:call-template>    
    <xsl:value-of select="'format: uint64'"/>
</xsl:template>

<xsl:template match="memberdef/type[(text()='std::string')]">
    <xsl:variable name="indent" select="count(ancestor::*)" />
    <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$indent"/>
    </xsl:call-template>
    <xsl:value-of select="'type: string'"/>
</xsl:template>
</xsl:stylesheet>




