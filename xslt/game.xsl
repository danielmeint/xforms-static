<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="name"/>
    
    <xsl:variable name="self" select="/game/player[@name = $name]"/>
    <xsl:variable name="activePlayer" select="/game/player[@state = 'active']"/>

    <xsl:template match="/">
        <div>
            <a id="exit-button" class="btn btn-secondary left top" href="/bjx">◀ Menu</a>
            <form class="right bottom" action="/bjx/games/{/game/@id}/draw" method="post" target="hiddenFrame">
                <input class="btn btn-secondary" type="submit" value="&#8634; Redraw Game"/>
            </form>
            <div class="flex-container">
                <svg viewBox="-100 0 1000 520">
                    <!-- table dimensions: 800 x 450 -->
                    <use href="/static/bjx/svg/table.svg#table" x="0" y="0"/>
                    
                    <g class="card_group" id="dealer">
                        <xsl:choose>
                            <xsl:when test="game/@state = 'playing' and count(game/dealer/hand/card) = 2">
                                <use
                                    href="/static/bjx/svg/cards.svg#{game/dealer/hand/card[1]/@value}_{game/dealer/hand/card[1]/@suit}"/>
                                <use href="/static/bjx/svg/cards.svg#back"
                                    style="transform: translate(40px, 4px)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="game/dealer/hand/card">
                                    <use href="/static/bjx/svg/cards.svg#{@value}_{@suit}"
                                        style="transform: translate({(position() - 1) * 40}px, {(position() - 1) * 4}px)"
                                    />
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </g>
                    <g id="player_cards">
                        <xsl:for-each select="/game/player">
                            <g id="player_{position()}_of_{count(/game/player)}">
                                <xsl:if test="bet > 0">
                                    <g viewBox="0 0 100 100">
                                        <xsl:choose>
                                            <xsl:when test="@state = 'won' or @state='tied'">
                                                <xsl:attribute name="style">animation: chip-won 1s ease-in forwards</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="@state = 'lost'">
                                                <xsl:attribute name="style">animation: chip-lost 1s ease-in forwards</xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                        
                                        <xsl:choose>
                                            <xsl:when test="bet >= 100">
                                                <xsl:attribute name="class">bet chip chip-100</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="bet >= 25">
                                                <xsl:attribute name="class">bet chip chip-25</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="bet >= 10">
                                                <xsl:attribute name="class">bet chip chip-10</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="bet >= 5">
                                                <xsl:attribute name="class">bet chip chip-5</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="bet >= 1">
                                                <xsl:attribute name="class">bet chip chip-1</xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="class">bet chip</xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <use href="/static/bjx/svg/chips.svg#chip" width="50" height="50"/>
                                        <text x="25" y="25" alignment-baseline="central">
                                            <xsl:value-of select="bet"/>
                                        </text>
                                    </g>
                                    <g class="card_group">
                                        <xsl:for-each select="hand/card">
                                            <use href="/static/bjx/svg/cards.svg#{@value}_{@suit}"
                                                style="transform: translate({(position() - 1) * 40}px, {(position() - 1) * 4}px)"
                                            />
                                        </xsl:for-each>
                                    </g>
                                </xsl:if>
                                <xsl:if test="/game/@state = 'playing'">
                                    <g>
                                        <xsl:choose>
                                            <xsl:when test="@state='active'">
                                                <xsl:attribute name="class">label label-hand label-active</xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="class">label label-hand</xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                      

                                        <rect x="10px" y="70px" rx="25" ry="25" width="80" height="50"/>
                                        <text class="name" x="30px" y="85px">
                                            <xsl:value-of select="@name"/>
                                        </text>
                                        <text class="hand_value" x="30px" y="115px" xmlns="http://www.w3.org/2000/svg">
                                            <xsl:choose>
                                                <xsl:when test="bet > 0">
                                                    <xsl:value-of select="hand/@value"/>
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    Sits out.
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            
                                        </text>
                                    </g>
                                </xsl:if>
                            </g>
                        </xsl:for-each>
                    </g>
                </svg>
                <div class="functions">
                    <xsl:choose>
                        <xsl:when test="/game/@state = 'playing' and $self/bet = 0">
                            <p>You are sitting out because you did not put down a bet.</p>
                        </xsl:when>
                        
                        <xsl:when test="(/game/@state = 'betting' or /game/@state = 'playing') and $self/@state = 'inactive'">
                            <!-- Player is inactive -->
                            <div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
                        </xsl:when>
                        
                        <xsl:when test="/game/@state = 'betting' and $self/@state = 'active'">
                            <!-- Betting stage -->
                            <form action="/bjx/games/{/game/@id}/bet" method="POST" target="hiddenFrame">
                                <input type="number" name="bet" min="0" max="{$self/balance}"/>
                                <input class="btn" type="submit" value = "Bet"/>
                            </form>
                        </xsl:when>
                        
                        <xsl:when test="/game/@state = 'playing' and $self/@state = 'active'">
                            <!-- Playing stage -->
                            <xsl:if test="count($self/hand/card) &lt; 3">
                                <form action="/bjx/games/{/game/@id}/double" method="POST" target="hiddenFrame">
                                    <input class="btn btn-secondary" type="submit" value="Double Down"/>
                                </form>
                            </xsl:if>
                            <xsl:if test="$self/hand/@value &lt; 21">
                                <form action="/bjx/games/{/game/@id}/hit" method="POST" target="hiddenFrame">
                                    <input class="btn" type="submit" value="Hit"/>
                                </form>
                            </xsl:if>
                            <form action="/bjx/games/{/game/@id}/stand" method="POST" target="hiddenFrame">
                                <input class="btn" type="submit" value="Stand"/>
                            </form>
                        </xsl:when>
                        
                        <xsl:when test="/game/@state = 'evaluated'">
                            <form action="/bjx/games/{/game/@id}/newRound" method="POST" target="hiddenFrame">
                                <input class="btn" type="submit" value="New Round"/>
                            </form>
                            <xsl:if test="$self/bet > 0">
                                <p>
                                    <xsl:choose>
                                        <xsl:when test="$self/@state = 'won'">
                                            You win<xsl:text>&#xA0;</xsl:text><span class='earnings won'>$<xsl:value-of select="$self/bet"/></span>
                                        </xsl:when>
                                        
                                        <xsl:when test="$self/@state = 'tied'">
                                            You tie and keep your bet.
                                        </xsl:when>
                                        
                                        <xsl:when test="$self/@state = 'lost'">
                                            You lose<xsl:text>&#xA0;</xsl:text><span class='earnings lost'>$<xsl:value-of select="$self/bet"/></span>
                                        </xsl:when>
                                    </xsl:choose>
                                </p>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </div>
                <div class="chat right top">
                    <p id="login">
                        Logged in as<xsl:text>&#xA0;</xsl:text><b><xsl:value-of select="$name"/></b>
                    </p>
                    <table>
                        <xsl:for-each select="/game/chat/message">
                            <tr>
                                <td class="author">
                                    <xsl:value-of select="@author"/>
                                </td>
                                <td class="msg">
                                    <xsl:value-of select="text()"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                    <form action="/bjx/games/{/game/@id}/{$self/@name}/chat" method="POST" target="hiddenFrame">
                        <input type="text" name="msg"/>
                        <input class="btn" type="submit" value="Chat"/>
                    </form>
                </div>
                <iframe class="hidden" name="hiddenFrame"/>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
