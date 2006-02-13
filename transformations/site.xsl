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
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="date">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:param name="site-structure"></xsl:param>
    <xsl:param name="items-dir"></xsl:param>


    <!-- Current date and time -->
    <xsl:variable name="now" select="date:date-time()" />

    <!-- Contents of site structure file -->
    <xsl:variable name="site-structure-file" select="document($site-structure)" />

    <!-- ID of this item -->
    <xsl:variable name="current-id" select="/item/id" />

    <!-- This relative path takes you to the base directory
         (can be ./ if already there). -->
    <xsl:variable name="base-path">
        <xsl:text>./</xsl:text><xsl:for-each select="$site-structure-file/site//item[id=$current-id]/ancestor::dir">../</xsl:for-each>
    </xsl:variable>

    <!-- This is the path to the current document, relative
         from the base directory (so use with $base-path). -->
    <xsl:variable name="current-path">
        <xsl:value-of select="$base-path" />
        <xsl:for-each
            select="$site-structure-file/site//item[id=$current-id]/ancestor-or-self::*[(name(.)='dir')or(name(.)='item')]">
            <xsl:value-of select="concat(location,'/')" />
        </xsl:for-each>
    </xsl:variable>

    <!-- This is really a bit of a hack to support pages in
         Dutch and in English. -->
    <xsl:variable name="str-last-changed">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Laatst gewijzigd</xsl:when>
            <xsl:otherwise>Last changed</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-last-generated">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Gegenereerd</xsl:when>
            <xsl:otherwise>Generated</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-index">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Meer op deze website</xsl:when>
            <xsl:otherwise>Elsewhere on this website</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-breadcrumbs">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Je bent hier</xsl:when>
            <xsl:otherwise>You are here</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-page-top">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Begin van de pagina</xsl:when>
            <xsl:otherwise>Top of page</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-page-top-descr">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Spring naar het begin van deze pagina</xsl:when>
            <xsl:otherwise>Jump to the top of this page</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-page-content">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Inhoud van de pagina</xsl:when>
            <xsl:otherwise>Page content</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-page-content-descr">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Spring naar de inhoud van deze pagina</xsl:when>
            <xsl:otherwise>Jump to the content of this page</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-navigation">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Navigatie van de website</xsl:when>
            <xsl:otherwise>Site navigation</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-navigation-descr">
        <xsl:choose>
            <xsl:when test="item/language='nl'">Spring naar de navigatie van deze website</xsl:when>
            <xsl:otherwise>Jump to the site navigation</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <xsl:template match="/item">

        <html xml:lang="{language}" lang="{language}">

        <head>

            <title>Martijn Vermaat - <xsl:value-of select="title" /></title>

            <link rel="stylesheet" type="text/css" media="screen" href="{$base-path}css/screen.css" />
            <link rel="stylesheet" type="text/css" media="screen" href="{$base-path}css/screen-why.css" title="whytheluckystiff" />
            <link rel="alternate stylesheet" type="text/css" media="screen" href="{$base-path}css/screen-ubuntu.css" title="Ubuntu colors" />

            <link rel="alternate stylesheet" type="text/css" media="screen" href="{$base-path}css/screen-bow.css" title="Black on white" />
            <link rel="alternate stylesheet" type="text/css" media="screen" href="{$base-path}css/screen-wob.css" title="White on black" />

            <link rel="stylesheet" type="text/css" media="print" href="{$base-path}css/print.css" />

            <link rel="home" href="{$base-path}" title="Homepage" />

        </head>

        <body id="cs-vu-nl-mvermaat">

        <ul class="xnav">
            <li><a href="#page-content" title="{$str-page-content-descr}" accesskey="2"><xsl:value-of select="$str-page-content" /></a></li>
            <li><a href="#navigation" title="{$str-navigation-descr}"><xsl:value-of select="$str-navigation" /></a></li>
        </ul>

        <div id="page-header">

            <h1><xsl:value-of select="title" /></h1>

            <p id="breadcrumbs">
                <xsl:value-of select="concat($str-breadcrumbs, ': ')" />
                <a href="{$base-path}" accesskey="1">Home</a>
                <xsl:apply-templates select="($site-structure-file/site/dir)|($site-structure-file/site/item)" mode="breadcrumbs" />
            </p>

        </div>

        <div id="page-content">

            <xsl:apply-templates select="content" />

            <p class="content-date">
                <xsl:value-of select="concat($str-last-changed, ': ',
                    date:year(last-change),
                    '/',
                    date:month-in-year(last-change)+1,
                    '/',
                    date:day-in-month(last-change))" />
                <br />
                <xsl:value-of select="concat($str-last-generated, ': ',
                    date:year($now),
                    '/',
                    date:month-in-year($now)+1,
                    '/',
                    date:day-in-month($now))" />
            </p>

        </div>

        <div id="page-footer">

            <h2><xsl:value-of select="$str-index" /></h2>

            <div id="navigation">
            <p>
                <xsl:choose>
                    <xsl:when test="count($site-structure-file/site/item[id=$current-id]/no-link) > 0">
                        <strong><a href="{$base-path}">Home</a></strong>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="{$base-path}">Home</a>
                    </xsl:otherwise>
                </xsl:choose>
            </p>
            <xsl:apply-templates select="$site-structure-file/site" mode="navigation" />
            <p><a href="#page-header" title="{$str-page-top-descr}"><xsl:value-of select="$str-page-top" /></a></p>
            </div>

        </div>

        </body>

        </html>

    </xsl:template>


    <xsl:template match="content">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="code|dd|dl|dt|em|hr|li|ol|p|pre|quote|strong|ul|img">
       <xsl:copy>
           <xsl:apply-templates select="@*" /> 
           <xsl:apply-templates />
       </xsl:copy>
    </xsl:template>


    <xsl:template match="a[@external='true']">
       <xsl:copy>
           <xsl:attribute name="class">external</xsl:attribute>
           <xsl:attribute name="title"><xsl:value-of select="@href" /></xsl:attribute>
           <xsl:apply-templates select="@*[name()!='external']" /> 
           <xsl:apply-templates />
       </xsl:copy>
    </xsl:template>


    <xsl:template match="a[not(@external='true')]">
       <xsl:copy>
           <xsl:attribute name="href"><xsl:value-of select="concat($base-path, @href)" /></xsl:attribute>
           <xsl:apply-templates select="@*[name()!='href']" /> 
           <xsl:apply-templates />
       </xsl:copy>
    </xsl:template>


    <xsl:template match="h1|h2|h3">
        <xsl:choose>
            <xsl:when test="name(.)='h1'">
                <h2><xsl:apply-templates select="@*" /><xsl:apply-templates /></h2>
            </xsl:when>
            <xsl:when test="name(.)='h2'">
                <h3><xsl:apply-templates select="@*" /><xsl:apply-templates /></h3>
            </xsl:when>
            <xsl:when test="name(.)='h3'">
                <h4><xsl:apply-templates select="@*" /><xsl:apply-templates /></h4>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="@*">
        <xsl:copy />
    </xsl:template> 


    <!-- This special tag generates a complete sitemap. -->
    <xsl:template match="sitemap">
        <p><a href="{$base-path}">Home</a></p>
        <xsl:apply-templates select="$site-structure-file/site" mode="sitemap" />
    </xsl:template>


    <xsl:template match="site" mode="navigation">

        <ul>
            <xsl:apply-templates select="item|dir" mode="navigation" />
        </ul>

    </xsl:template>


    <xsl:template match="item" mode="navigation">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />
 
        <xsl:if test="(not(no-link)) and (not(hidden))">
            <li>
                <xsl:choose>
                    <xsl:when test="id=$current-id">
                        <strong><a href="{$base-path}{$dir}{location}" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a></strong>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="{$base-path}{$dir}{location}" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
        </xsl:if>

    </xsl:template>


    <xsl:template match="dir" mode="navigation">
    
        <xsl:param name="dir" />

        <li>
            <xsl:choose>
                <xsl:when test="count(child::item[id=$current-id]/no-link) > 0">
                    <strong><a href="{$base-path}{$dir}{location}/"><xsl:value-of select="title" /></a></strong>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$base-path}{$dir}{location}/"><xsl:value-of select="title" /></a>
                </xsl:otherwise>
            </xsl:choose>
            <ul>
                <xsl:apply-templates select="item|dir" mode="navigation">
                    <xsl:with-param name="dir" select="concat($dir,location,'/')" />
                </xsl:apply-templates>
            </ul>
        </li>

    </xsl:template>


    <xsl:template match="site" mode="sitemap">

        <ul>
            <xsl:apply-templates select="item|dir" mode="sitemap" />
        </ul>

    </xsl:template>


    <xsl:template match="item" mode="sitemap">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />
 
        <xsl:if test="not(no-link)">
            <li>
                <xsl:choose>
                    <xsl:when test="id=$current-id">
                        <strong><a href="{$base-path}{$dir}{location}" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a></strong>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="{$base-path}{$dir}{location}" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
        </xsl:if>

    </xsl:template>


    <xsl:template match="dir" mode="sitemap">
    
        <xsl:param name="dir" />

        <li>
            <xsl:choose>
                <xsl:when test="count(child::item[id=$current-id]/no-link) > 0">
                    <strong><a href="{$base-path}{$dir}{location}/"><xsl:value-of select="title" /></a></strong>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$base-path}{$dir}{location}/"><xsl:value-of select="title" /></a>
                </xsl:otherwise>
            </xsl:choose>
            <ul>
                <xsl:apply-templates select="item|dir" mode="sitemap">
                    <xsl:with-param name="dir" select="concat($dir,location,'/')" />
                </xsl:apply-templates>
            </ul>
        </li>

    </xsl:template>


    <xsl:template match="dir" mode="breadcrumbs">

        <xsl:param name="dir" />

        <xsl:if test="count(descendant::item[id=$current-id]) > 0">

            <xsl:text> » </xsl:text><a href="{$base-path}{$dir}{location}/"><xsl:value-of select="title" /></a>
            <xsl:apply-templates select="(dir)|(item[id=$current-id])" mode="breadcrumbs">
                <xsl:with-param name="dir" select="concat($dir,location,'/')" />
            </xsl:apply-templates>

        </xsl:if>

    </xsl:template>


    <xsl:template match="item" mode="breadcrumbs">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />

        <xsl:if test="(not(no-link)) and (id=$current-id)">
            <xsl:text> » </xsl:text><a href="{$base-path}{$dir}{location}"><xsl:value-of select="$item/title" /></a>
        </xsl:if>

    </xsl:template>


</xsl:transform>
