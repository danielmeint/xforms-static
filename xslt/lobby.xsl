<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output indent="no" method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="screen"/>
    <xsl:param name="name"/>
    <xsl:param name="balance"/>
    
    <xsl:template match="/">
        <div class="content">
            <div id="login" class="right top">
                <span><b><a href="/xforms-blackjack/profile"><xsl:value-of select="$name"/></a></b> ($<xsl:value-of select="$balance"/>)</span>
                <a class="btn btn-secondary" href="/xforms-blackjack/logout">
                    <svg>
                        <use href="/static/xforms-static/svg/solid.svg#sign-out-alt"/>
                    </svg>
                </a>
            </div>
            <a class="btn btn-secondary left top" href="/xforms-blackjack">◀ Menu</a>
            <xsl:choose>
                <xsl:when test="$screen = 'games'">
                    <xsl:choose>
                        <xsl:when test="count(games/game) = 0">
                            <p>No active games.</p>
                            <form action="/xforms-blackjack/games" method="post">
                                <input class="btn" type="submit" value="Create new Game"/>
                            </form>
                        </xsl:when>
                        <xsl:otherwise>
                            <table id="games-table" class="table table-hover information">
                                <thead class="thead-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Players</th>
                                        <th>State</th>
                                        <th>
                                            <form action="/xforms-blackjack/games" method="post">
                                                <input class="btn" type="submit" value="+"/>
                                            </form>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="games/game">
                                        <tr>
                                            <td>
                                                <xsl:value-of select="@id"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="player[1]/@name"/>
                                                <xsl:for-each select="player[position() &gt; 1]">
                                                  ,<xsl:text> </xsl:text><xsl:value-of
                                                  select="@name"/></xsl:for-each>
                                            </td>
                                            <td>
                                                <xsl:value-of
                                                  select="player[@state = 'active']/@name"
                                                  />=<xsl:value-of select="@state"/></td>
                                            <td>
                                                <a class="btn btn-secondary" href="/xforms-blackjack/games/{@id}"
                                                  >Open</a>
                                                <form action="/xforms-blackjack/games/{@id}/delete" method="POST">
                                                  <input class="btn btn-danger" type="submit"
                                                  value="Delete"/>
                                                </form>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <xsl:when test="$screen = 'highscores'">
                    <a class="btn btn-secondary left top" href="/xforms-blackjack">◀ Menu</a>
                    <table id="highscores-table" class="table information">
                        <thead class="thead-light">
                            <tr>
                                <th>Name</th>
                                <th>Highscore</th>
                                <th>Current Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="/users/user">
                                <xsl:sort select="highscore" data-type="number" order="descending"/>
                                <tr>
                                    <xsl:if test="@name = $name">
                                        <xsl:attribute name="class">self</xsl:attribute>
                                    </xsl:if>
                                    <td>
                                        <xsl:value-of select="@name"/>
                                    </td>
                                    <td>
                                        $<xsl:value-of select="highscore"/>
                                    </td>
                                    <td>
                                        $<xsl:value-of select="balance"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </xsl:when>
                
                <xsl:when test="$screen = 'profile'">
                        <h2><xsl:value-of select="/user/@name"/></h2>
                        <p>Balance: $<xsl:value-of select="/user/balance"/></p>
                        <p>Highscore: $<xsl:value-of select="/user/highscore"/></p>
                        <form action="/xforms-blackjack/deposit" method="POST">
                            <input type="number" name="amount"/>
                            <button type="submit" class="btn">
                                Deposit
                            </button>
                        </form>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>
</xsl:stylesheet>
