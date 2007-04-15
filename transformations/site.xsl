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

    <!-- Contents of the root index page -->
    <xsl:variable name="rootitem" select="document(concat($items-dir,'/',$site-structure-file/dir/item[index]/location,'.xml'))/item" />

    <!-- ID of this item -->
    <xsl:variable name="current-id" select="/item/id" />

    <!-- Is this item the homepage? -->
    <xsl:variable name="is-homepage" select="$site-structure-file/dir/item[id=$current-id]/index" />

    <!-- This relative path takes you to the base directory
         (can be ./ if already there). -->
    <xsl:variable name="base-path">
        <xsl:text>./</xsl:text><xsl:for-each select="$site-structure-file//item[id=$current-id]/ancestor::dir/ancestor::dir">../</xsl:for-each>
    </xsl:variable>

    <!-- This is the path to the current document, relative
         from the base directory (so use with $base-path). -->
    <xsl:variable name="current-path">
        <xsl:value-of select="$base-path" />
        <xsl:for-each
            select="$site-structure-file/dir//item[id=$current-id]/ancestor-or-self::*[(name(.)='dir')or(name(.)='item')]">
            <xsl:value-of select="concat(location,'/')" />
        </xsl:for-each>
    </xsl:variable>

    <!-- This is really a bit of a hack to support pages in
         Dutch and in English. -->
    <xsl:variable name="str-last-changed-month">
        <xsl:choose>
            <xsl:when test="item/language='nl'">
                <xsl:choose>
                    <xsl:when test="date:month-in-year(item/last-change)='0'">januari</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='1'">februari</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='2'">maart</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='3'">april</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='4'">mei</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='5'">juni</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='6'">juli</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='7'">augustus</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='8'">september</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='9'">oktober</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='10'">november</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='11'">december</xsl:when>
                    <xsl:otherwise>een maand</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="date:month-in-year(item/last-change)='0'">January</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='1'">February</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='2'">March</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='3'">April</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='4'">May</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='5'">June</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='6'">July</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='7'">August</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='8'">September</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='9'">October</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='10'">November</xsl:when>
                    <xsl:when test="date:month-in-year(item/last-change)='11'">December</xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str-last-changed-format">
        <xsl:choose>
            <xsl:when test="item/language='nl'">'Laatst inhoudswijziging was op' d '<xsl:value-of select="$str-last-changed-month" />' yyyy</xsl:when>
            <xsl:otherwise>'Last content change was on <xsl:value-of select="$str-last-changed-month" />' d yyyy</xsl:otherwise>
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


    <xsl:template match="/item">

        <html xml:lang="{language}" lang="{language}">

        <head>

            <title>
                <xsl:value-of select="$rootitem/title" />
                <xsl:apply-templates select="($site-structure-file/dir/item)|($site-structure-file/dir/dir)" mode="title" />
            </title>

            <link rel="stylesheet" type="text/css" media="screen" href="{$base-path}css/screen.css" />
            <link rel="stylesheet" type="text/css" media="print" href="{$base-path}css/print.css" />

            <script type="text/javascript" src="{$base-path}script/default.js">var someBrowsersNeedThisContent;</script>

            <link rel="home" href="{$base-path}" title="Homepage" />

        </head>

        <body id="cs-vu-nl-mvermaat">

        <xsl:if test="$is-homepage">
            <xsl:attribute name="class">homepage</xsl:attribute>
        </xsl:if>

        <p class="skip"><a href="#content" title="{$str-page-content-descr}"><xsl:value-of select="$str-page-content" /></a></p>

        <div id="header">
            <div id="menu">
                <ul>
                    <li>
                        <xsl:if test="$is-homepage">
                            <xsl:attribute name="class">active</xsl:attribute>
                        </xsl:if>
                        <a href="{$base-path}">Home</a>
                    </li>
                    <li>
                        <xsl:if test="id='site:colofon'">
                            <xsl:attribute name="class">active</xsl:attribute>
                        </xsl:if>
                        <a href="{$base-path}colofon">Colofon</a>
                    </li>
                </ul>
                <xsl:if test="not($is-homepage)">
                    <p>
                        <a href="{$base-path}"><xsl:value-of select="$rootitem/title" /></a>
                        <xsl:apply-templates select="($site-structure-file/dir/item)|($site-structure-file/dir/dir)" mode="breadcrumbs" />
                    </p>
                </xsl:if>
            </div>
            <div id="navigation">
                <ul>
                <xsl:apply-templates select="($site-structure-file/dir/item)|($site-structure-file/dir/dir)" mode="navigation" />
                </ul>
            </div>
            <div id="header-end"><p><a href="#header" title="{$str-page-top-descr}"><xsl:value-of select="$str-page-top" /></a></p></div>
        </div>

        <div id="content">
            <h1><xsl:value-of select="title" /></h1>
            <xsl:apply-templates select="content" />
        </div>

        <div id="footer">
            <hr />
            <p><xsl:value-of select="date:format-date(last-change, $str-last-changed-format)" /></p>
            <p><a href="#header" title="{$str-page-top-descr}"><xsl:value-of select="$str-page-top" /></a></p>
        </div>

        </body>

        </html>

    </xsl:template>


    <xsl:template match="content">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="code|dd|dl|dt|em|hr|li|ol|p|pre|blockquote|strong|ul|img|sup|sub|script|div|table|tr|td">
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
        <p><a href="{$base-path}"><xsl:value-of select="$rootitem/title" /></a></p>
        <ul>
            <xsl:apply-templates select="($site-structure-file/dir/item)|($site-structure-file/dir/dir)" mode="sitemap" />
        </ul>
    </xsl:template>


    <xsl:template match="item" mode="navigation">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />
 
        <xsl:if test="(not(index)) and (not(hidden))">
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
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'/',item[index]/location,'.xml'))/item" />

        <li>
            <xsl:choose>
                <xsl:when test="count(child::item[id=$current-id]/index) > 0">
                    <strong><a href="{$base-path}{$dir}{location}/" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a></strong>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$base-path}{$dir}{location}/" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a>
                </xsl:otherwise>
            </xsl:choose>
            <ul>
                <xsl:apply-templates select="item|dir" mode="navigation">
                    <xsl:with-param name="dir" select="concat($dir,location,'/')" />
                </xsl:apply-templates>
            </ul>
        </li>

    </xsl:template>


    <xsl:template match="item" mode="sitemap">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />
 
        <xsl:if test="not(index)">
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
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'/',item[index]/location,'.xml'))/item" />

        <li>
            <xsl:choose>
                <xsl:when test="count(child::item[id=$current-id]/index) > 0">
                    <strong><a href="{$base-path}{$dir}{location}/" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a></strong>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$base-path}{$dir}{location}/" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a>
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
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'/',item[index]/location,'.xml'))/item" />

        <xsl:if test="count(descendant::item[id=$current-id]) > 0">

            <xsl:text> » </xsl:text><a href="{$base-path}{$dir}{location}/" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a>
            <xsl:apply-templates select="(dir)|(item[id=$current-id])" mode="breadcrumbs">
                <xsl:with-param name="dir" select="concat($dir,location,'/')" />
            </xsl:apply-templates>

        </xsl:if>

    </xsl:template>


    <xsl:template match="item" mode="breadcrumbs">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />

        <xsl:if test="(not(index)) and (id=$current-id)">
            <xsl:text> » </xsl:text><a href="{$base-path}{$dir}{location}" hreflang="{$item/language}"><xsl:value-of select="$item/title" /></a>
        </xsl:if>

    </xsl:template>


    <xsl:template match="dir" mode="title">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'/',item[index]/location,'.xml'))/item" />

        <xsl:if test="count(descendant::item[id=$current-id]) > 0">

            <xsl:text> » </xsl:text><xsl:value-of select="$item/title" />
            <xsl:apply-templates select="(dir)|(item[id=$current-id])" mode="title">
                <xsl:with-param name="dir" select="concat($dir,location,'/')" />
            </xsl:apply-templates>

        </xsl:if>

    </xsl:template>


    <xsl:template match="item" mode="title">

        <xsl:param name="dir" />
        <xsl:variable name="item" select="document(concat($items-dir,'/',$dir,location,'.xml'))/item" />

        <xsl:if test="(not(index)) and (id=$current-id)">
            <xsl:text> » </xsl:text><xsl:value-of select="$item/title" />
        </xsl:if>

    </xsl:template>


</xsl:transform>
