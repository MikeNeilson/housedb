<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" media-type="text/yml"/>
<xsl:template match="/">
---
openapi: 3.0.3
components:
  schemas:
    <xsl:apply-templates select="//para[contains(.,'@schema')]/ancestor::compounddef[@kind='class']"/>
  responses:
  securitySchemes:
  paths:
...    
</xsl:template>

<xsl:template match="compounddef[@kind='class']">  
    <xsl:value-of select="compoundname"/>:
      type: object
      properties:
<xsl:apply-templates select=".//memberdef[@kind='variable']"/>
</xsl:template>

<xsl:template match="memberdef[@kind='variable']">
<xsl:text>        </xsl:text><xsl:value-of select="./name"/>:
          type: <xsl:value-of select="./type"/>
        <xsl:if test="./type != 'std::string'">
          format: <xsl:value-of select="./type"/>
        </xsl:if>
    <xsl:if test="position() &lt; last()"><xsl:text>&#xa;</xsl:text></xsl:if>    
</xsl:template>

</xsl:stylesheet>



