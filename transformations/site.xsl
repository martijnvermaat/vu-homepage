<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns="http://www.w3.org/1999/xhtml">

<xsl:output method="xml" indent="yes" encoding="UTF-8"
     doctype-public="-//W3C//DTD XHTML 1.1//EN"
     doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>


     <xsl:param name="structure"></xsl:param>


     <xsl:template match="/">

         <html>

         <xsl:apply-templates select="item" />

         </html>

     </xsl:template>


     <xsl:template match="item">

         <head>
         <title><xsl:value-of select="title" /></title>
         </head>

         <body>

         <xsl:apply-templates select="document($structure)/site" />

         <h1><xsl:value-of select="title" /></h1>

         <xsl:apply-templates select="content" />

         </body>

     </xsl:template>


     <xsl:template match="content">
         <xsl:apply-templates />
     </xsl:template>


     <xsl:template match="a|code|em|h2|h3|h4|hr|li|ol|p|pre|quote|strong|ul">
        <xsl:element name="{name(.)}">
            <xsl:apply-templates />
        </xsl:element>
     </xsl:template>


     <xsl:template match="site">

         <ul>
             <xsl:apply-templates select="item" mode="navigation" />
         </ul>

     </xsl:template>


     <xsl:template match="item" mode="navigation">

         <li><xsl:value-of select="location" /></li>

     </xsl:template>


</xsl:transform>
