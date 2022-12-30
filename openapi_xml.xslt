<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<xsl:output indent="true"/>
<xsl:strip-space elements="*"/>
<xsl:variable name="nl"><xsl:text>&#xa;</xsl:text></xsl:variable>
<xsl:template match="/">
<api>
    <xsl:apply-templates select="//api_info"/>
    <xsl:apply-templates select="//api_path"/>
</api>
</xsl:template>

<xsl:template match="api_info">
    <info>
        <xsl:copy-of select="./*"/>
    </info>
</xsl:template>

<xsl:template match="api_path">
    <xsl:element name="path">
        <xsl:attribute name="path">
            <xsl:value-of select="@path"/>
        </xsl:attribute>
        <xsl:apply-templates select="get"/>
        
    </xsl:element>    
</xsl:template>

<xsl:template match="api_path/get">
<xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>