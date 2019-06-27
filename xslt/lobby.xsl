<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">

    <xsl:output indent="no" method="xml" omit-xml-declaration="yes"/>
    
    <xsl:param name="screen"/>
    <xsl:param name="name"/>

    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="/static/bjx/css/style.css"/>
            </head>
            <body>
                <span id="login" class="right">
                    Logged in as<xsl:text>&#xA0;</xsl:text><b><xsl:value-of select="$name"/></b><xsl:text>&#xA0;</xsl:text>(<a href="/bjx/logout">logout</a>)
                </span>
                
                <div class="flex-container">

                    <xsl:choose>
                        <xsl:when test="$screen = 'menu'">
                            <details>
                                <summary>Games</summary>
                                <table id="games-table" class="table table-hover">
                                    <thead class="thead-light">
                                        <tr>
                                            <th scope="col">#</th>
                                            <th scope="col">Players</th>
                                            <th scope="col">State</th>
                                            <th scope="col">
                                                <form action="/bjx/games" method="post">
                                                    <input class="btn" type="submit" value="Create new Game"/>
                                                </form>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="games/game">
                                            <tr>
                                                <td>
                                                    <a href="/bjx/games/{@id}/join"><xsl:value-of select="@id"/></a>
                                                </td>
                                                <td>
                                                    <a href="/bjx/games/{@id}/join">
                                                        <xsl:value-of select="player[1]/@name"/>
                                                        <xsl:for-each select="player[position() > 1]">
                                                            /<xsl:value-of select="@name"/>
                                                        </xsl:for-each>
                                                    </a>
                                                </td>
                                                <td>
                                                    <a href="/bjx/games/{@id}/join">
                                                        <xsl:value-of select="player[@state='active']/@name"/>=<xsl:value-of select="@state"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <form action="/bjx/games/{@id}/delete" method="post">
                                                        <input class="btn btn-danger" type="submit" value="Delete"/>
                                                    </form>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </details>
                            <details>
                                <summary>Highscores</summary>
                                <table id="highscores-table" class="table">
                                    <thead class="thead-light">
                                        <tr>
                                            <th scope="col">Name</th>
                                            <th scope="col">Balance</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="games/game/player">
                                            <xsl:sort select="balance" data-type="number" order="descending"/>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="@name"/> (Game <xsl:value-of select="../@id"/>)
                                                </td>
                                                <td>
                                                    <xsl:value-of select="balance"/>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </details>
                        </xsl:when>
                        
                        <xsl:when test="$screen = 'games'">
                            <table id="games-table" class="table table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Players</th>
                                        <th scope="col">State</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="games/game">
                                        <tr>
                                            <td>
                                                <a href="/bjx/games/{@id}/join"><xsl:value-of select="@id"/></a>
                                            </td>
                                            <td>
                                                <a href="/bjx/games/{@id}/join">
                                                <xsl:value-of select="player[1]/@name"/>
                                                <xsl:for-each select="player[position() > 1]">
                                                    /<xsl:value-of select="@name"/>
                                                </xsl:for-each>
                                                </a>
                                            </td>
                                            <td>
                                                <a href="/bjx/games/{@id}/join">
                                                <xsl:value-of select="player[@state='active']/@name"/>=<xsl:value-of select="@state"/>
                                                </a>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </xsl:when>
                        <xsl:when test="$screen = 'highscores'">
                            <table id="highscores-table" class="table">
                                <thead class="thead-light">
                                    <tr>
                                        <th scope="col">Name</th>
                                        <th scope="col">Balance</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="games/game/player">
                                        <xsl:sort select="balance" data-type="number" order="descending"/>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="@name"/> (Game <xsl:value-of select="../@id"/>)
                                            </td>
                                            <td>
                                                <xsl:value-of select="balance"/>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </xsl:when>
                    </xsl:choose>
                    
                </div>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
