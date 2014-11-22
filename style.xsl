<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>

  <xsl:template match="root">
    <html>
      <head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css"/>
      </head>
      <body class="container">
	<h2>Individu</h2>
	<table class="table">
	  <thead>
	    <tr>
	      <th>Name</th>
	    </tr>
	  </thead>
	  <tbody>
	    <xsl:apply-templates select="indi"/>
	  </tbody>
	</table>
	<h2>Famille</h2>
	<table class="table">
	  <thead>
	    <tr>
	      <th>Husband</th>
	      <th>Wife</th>
	    </tr>
	  </thead>
	  <tbody>
	    <xsl:apply-templates select="fam"/>
	  </tbody>
	</table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="indi">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id" />
      <td><xsl:value-of select="name"/></td>
    </xsl:element>
  </xsl:template>

  <xsl:template match="fam">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id" />
      <td>
	<xsl:element name="a">
	  <xsl:apply-templates select="husb/@idref" />
	  Husband
	</xsl:element>
      </td>
      <td>
	<xsl:element name="a">
	  <xsl:apply-templates select="wife/@idref" />
	  Wife
	</xsl:element>
      </td>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:attribute name="{name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@idref">
    <xsl:attribute name="href">
      #<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
