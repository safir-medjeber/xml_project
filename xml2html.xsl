<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>

  <xsl:key name="individus" match="indi" use="@id" />
  <xsl:key name="indiFirstLetters" match="indi" use="substring(normalize-space(name/fname),1,1)" />

  <xsl:template match="root">
    <html>
      <head>
	<link rel="stylesheet" href="assets/css/style.css"/>
      </head>
      <body>
	<nav>
	  <ul>
	    <xsl:for-each select="indi">
	      <xsl:sort select="name/fname"/>
	      <xsl:variable name="firstLetter" select="substring(normalize-space(name/fname), 1, 1)"/>
	      <xsl:if test="generate-id(.) = generate-id(key('indiFirstLetters', $firstLetter)[1])">
		<li>
		  <a>
		    <xsl:attribute name="href">#i<xsl:value-of select="$firstLetter" />i</xsl:attribute>
		    <xsl:value-of select="$firstLetter" />
		  </a>
		</li>
	      </xsl:if>
	    </xsl:for-each>
	  </ul>
	</nav>
	<section>
	<h2>Individu</h2>
	<table class="table">
	  <thead>
	    <tr>
	      <th>Prenom</th>
	      <th>Nom</th>
	      <th>famc</th>
	      <th>fams</th>
	      <th> ... </th>
	    </tr>
	  </thead>
	  <tbody>
	    <xsl:for-each select="indi">
	      <xsl:sort select="name/fname"/>
	      <xsl:variable name="firstLetter" select="substring(normalize-space(name/fname), 1, 1)"/>
	      <xsl:if test="generate-id(.) = generate-id(key('indiFirstLetters', $firstLetter)[1])">
		<tr>
		  <td colspan="100%" class="idIndex" id="$firstLetter">
		    <xsl:attribute name="id">i<xsl:value-of select="$firstLetter" />i</xsl:attribute>
		    <xsl:value-of select="$firstLetter" />
		  </td>
		</tr>
		<xsl:apply-templates select="key('indiFirstLetters', $firstLetter)" />
	      </xsl:if>
	    </xsl:for-each>
	  </tbody>
	</table>
	<h2>Famille</h2>
	<table>
	  <thead>
	    <tr>
	      <th>Husband</th>
	      <th>Wife</th>
	      <th>Children</th>
	    </tr>
	  </thead>
	  <tbody>
	    <xsl:apply-templates select="fam"/>
	  </tbody>
	</table>
	</section>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="assets/js/javascript.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="indi">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id" />
      <td><xsl:value-of select="name/fname" /></td>
      <td><xsl:value-of select="name/lname" /></td>
      <td><xsl:apply-templates select="famc" /></td>
      <td>
	<ul>
	  <xsl:for-each select="fams">
	    <li><xsl:apply-templates select="." /></li>
	  </xsl:for-each>
	</ul>
      </td>
      <td>
	<xsl:element name="button">
	  <xsl:attribute name="data-target" >#modal<xsl:value-of select="@id"/></xsl:attribute>
	  more
	</xsl:element>
      </td>

      <xsl:element name="div" use-attribute-sets="modal">
	<xsl:attribute name="id" >modal<xsl:value-of select="@id" /></xsl:attribute>
      	<div class="modal-dialog">
	  <div class="modal-content">
	    <div class="modal-header">
              <h4 class="modal-title">Informations</h4>
	    </div>
	    <div class="modal-body">
	      <xsl:apply-templates select="sex" />
	      <xsl:apply-templates select="bapm | birt | deat"/>
	    </div>
	    <div class="modal-footer">
              <button type="button" data-dismiss="modal">Close</button>
	    </div>
	  </div>
	</div>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sex[contains(text(),'F')]"><p>Femme</p></xsl:template>
  <xsl:template match="sex[contains(text(),'M')]"><p>Homme</p></xsl:template>

  <xsl:template match="bapm">
    <p>Batpeme  :<xsl:apply-templates select="date | plac" /></p>
  </xsl:template>

  <xsl:template match="birt">
    <p>Naissance:<xsl:apply-templates select="date | plac" /></p>
  </xsl:template>

  <xsl:template match="deat">
    <p>Mort     :<xsl:apply-templates select="date | plac" /></p>
  </xsl:template>

  <xsl:template match="date">
    <xsl:value-of select="text()"/>
  </xsl:template>

  <xsl:template match="plac">
    à <xsl:value-of select="text()"/>
  </xsl:template>

  <xsl:template match="fam">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id" />
      <td><xsl:apply-templates select="husb" /></td>
      <td><xsl:apply-templates select="wife" /></td>
      <td>
	<ul>
	  <xsl:for-each select="chil">
	    <li><xsl:apply-templates select="." /></li>
	  </xsl:for-each>
	</ul>
      </td>
    </xsl:element>
  </xsl:template>

  <xsl:template match="husb | wife | chil">
    <xsl:element name="a">
      <xsl:apply-templates select="@idref" />
      <xsl:variable name="id" select="@idref" />
      <xsl:variable name="name" select="key('individus', @idref)/name" />
      - <xsl:value-of select="$name/fname" /><xsl:value-of select="$name/lname" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="famc | fams">
    <xsl:element name="a">
      <xsl:apply-templates select="@idref" />
      <xsl:variable name="id" select="@idref" />
      lien
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

  <xsl:attribute-set name="modal">
    <xsl:attribute name="class">modal</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
