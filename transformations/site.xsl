<?xml version="1.0" encoding="UTF-8"?>


<!--

This is a transformation from source XML item files to
XHTML output with navigation links.

Two parameters are expected:

* site-structure
  Filename of the site structure XML file.

* items-dir
  Directory where all source XML item files are stored.

-->


<xsl:transform version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>


    <xsl:param name="site-structure"></xsl:param>
    <xsl:param name="items-dir"></xsl:param>


    <!-- Contents of site structure file -->
    <xsl:variable name="site-structure-file" select="document($site-structure)" />

    <!-- This relative path takes you to the base directory
         (can be empty if already there). -->
    <xsl:variable name="base-path">
        <xsl:for-each select="$site-structure-file/site//item[id=current()/item/id]/ancestor::dir">../</xsl:for-each>
    </xsl:variable>

    <!-- This is the path to the current document, relative
         from the base directory (so use with $base-path). -->
    <xsl:variable name="current-path">
        <xsl:value-of select="$base-path" />
        <xsl:for-each
            select="$site-structure-file/site//item[id=current()/item/id]/ancestor-or-self::*[(name(.)='dir')or(name(.)='item')]">
            <xsl:value-of select="concat(location,'/')" />
        </xsl:for-each>
    </xsl:variable>


    <xsl:template match="/item">

        <html>

        <head>
        <title><xsl:value-of select="title" /></title>
        </head>

        <body>

        <xsl:apply-templates select="$site-structure-file/site" mode="navigation">
            <xsl:with-param name="current-id" select="id" />
        </xsl:apply-templates>

        <p>
            You are here:
            <xsl:apply-templates select="$site-structure-file/site/dir" mode="breadcrumbs">
                <xsl:with-param name="current-id" select="id" />
            </xsl:apply-templates>
            <a href="{$current-path}"><xsl:value-of select="title" /></a>
        </p>

        <h1><xsl:value-of select="title" /></h1>

        <xsl:apply-templates select="content" />

        </body>

        </html>

    </xsl:template>


    <xsl:template match="content">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="a|code|em|h2|h3|h4|hr|li|ol|p|pre|quote|strong|ul">
       <xsl:element name="{name(.)}">
           <xsl:apply-templates />
       </xsl:element>
    </xsl:template>


    <xsl:template match="site" mode="navigation">

        <xsl:param name="current-id" />

        <ul>
            <xsl:apply-templates select="item|dir" mode="navigation">
                <xsl:with-param name="current-id" select="$current-id" />
            </xsl:apply-templates>
        </ul>

    </xsl:template>


    <xsl:template match="dir" mode="breadcrumbs">

        <xsl:param name="current-id" />
        <xsl:param name="dir" />

        <xsl:if test="count(descendant::item[id=$current-id]) > 0">

            <a href="{$base-path}{$dir}{location}"><xsl:value-of select="title" /></a>
            <xsl:apply-templates select="dir" mode="breadcrumbs">
                <xsl:with-param name="current-id" select="$current-id" />
                <xsl:with-param name="dir" select="concat($dir,location,'/')" />
            </xsl:apply-templates>

        </xsl:if>

    </xsl:template>


    <xsl:template match="item" mode="navigation">

        <xsl:param name="dir" />
        <xsl:param name="current-id" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />

        <xsl:if test="not(no-link)">
            <li>
                <xsl:choose>
                    <xsl:when test="id=$current-id">
                        <strong><a href="{$base-path}{$dir}{location}"><xsl:value-of select="$item/title" /></a></strong>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="{$base-path}{$dir}{location}"><xsl:value-of select="$item/title" /></a>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
        </xsl:if>

    </xsl:template>


    <xsl:template match="dir" mode="navigation">
    
        <xsl:param name="dir" />
        <xsl:param name="current-id" />

        <li>
            <xsl:choose>
                <xsl:when test="count(child::item[id=$current-id]/no-link) > 0">
                    <strong><a href="{$base-path}{$dir}{location}"><xsl:value-of select="title" /></a></strong>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$base-path}{$dir}{location}"><xsl:value-of select="title" /></a>
                </xsl:otherwise>
            </xsl:choose>
            <ul>
                <xsl:apply-templates select="item|dir" mode="navigation">
                    <xsl:with-param name="dir" select="concat($dir,location,'/')" />
                    <xsl:with-param name="current-id" select="$current-id" />
                </xsl:apply-templates>
            </ul>
        </li>

    </xsl:template>


</xsl:transform>
