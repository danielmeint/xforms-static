<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="name"/>
    
    <xsl:variable name="self" select="/game/player[@name = $name]"/>
    <xsl:variable name="activePlayer" select="/game/player[@state = 'active']"/>

    <xsl:template match="/">
        <div>
            <a id="exit-button" class="btn btn-secondary left" href="/bjx">&lt; Menu</a>
            <span id="login" class="right">
                Logged in as<xsl:text>&#xA0;</xsl:text><b><xsl:value-of select="$name"/></b><xsl:text>&#xA0;</xsl:text>(<a href="/bjx/logout">logout</a>)
            </span>
            <div class="container flex-container">
                <svg viewBox="0 0 800 520">
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
                        <xsl:for-each select="game/player">
                            <g id="player_{position()}_of_{count(/game/player)}">
                                <xsl:if test="@state = 'active'">
                                    <use viewBox="0 0 450 450" height="20px" width="20px"
                                        href="/static/bjx/svg/gui.svg#arrow_down"/>
                                </xsl:if>
                                <g class="card_group">
                                    <xsl:for-each select="hand/card">
                                        <use href="/static/bjx/svg/cards.svg#{@value}_{@suit}"
                                            style="transform: translate({(position() - 1) * 40}px, {(position() - 1) * 4}px)"
                                        />
                                    </xsl:for-each>
                                </g>
                                <xsl:if test="/game/@state = 'playing'">
                                    <g class="label label-hand">
                                        <rect x="-50px" y="70px" rx="25" ry="25" width="80" height="50"/>
                                        <text class="name" x="-30px" y="85px">
                                            <xsl:value-of select="@name"/>
                                        </text>
                                        <text class="hand_value" x="-30px" y="115px" xmlns="http://www.w3.org/2000/svg">
                                            <xsl:value-of select="hand/@value"/>
                                        </text>
                                    </g>
                                </xsl:if>
                            </g>
                        </xsl:for-each>
                    </g>
                </svg>
                <div class="functions">
                    <xsl:choose>
                        <xsl:when test="(/game/@state = 'betting' or /game/@state = 'playing') and $self/@state = 'inactive'">
                            <!-- Player is inactive -->
                            <div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
                        </xsl:when>
                        
                        <xsl:when test="/game/@state = 'betting' and $self/@state = 'active'">
                            <!-- Betting stage -->
                            <form action="/bjx/games/{/game/@id}/{$name}/bet" method="POST" target="hiddenFrame">
                                <input type="number" name="bet" min="0" max="{$self/balance}"/>
                                <input class="btn" type="submit" value = "Bet"/>
                            </form>
                        </xsl:when>
                        
                        <xsl:when test="/game/@state = 'playing' and $self/@state = 'active'">
                            <!-- Playing stage -->
                            <xsl:if test="$self/hand/@value &lt; 21">
                                <form action="/bjx/games/{/game/@id}/{$name}/hit" method="POST" target="hiddenFrame">
                                    <input class="btn" type="submit" value="Hit"/>
                                </form>
                            </xsl:if>
                            <form action="/bjx/games/{/game/@id}/{$name}/stand" method="POST" target="hiddenFrame">
                                <input class="btn" type="submit" value="Stand"/>
                            </form>
                        </xsl:when>
                        
                        <xsl:when test="/game/@state = 'evaluated'">
                            <xsl:choose>
                                <xsl:when test="$self/@state = 'won'">
                                    You win<xsl:text>&#xA0;</xsl:text><span class='earnings won'><xsl:value-of select="$self/bet"/></span>
                                </xsl:when>
                                
                                <xsl:when test="$self/@state = 'tied'">
                                    You tied and keep your bet.
                                </xsl:when>
                                
                                <xsl:when test="$self/@state = 'lost'">
                                    You lost<xsl:text>&#xA0;</xsl:text><span class='earning lost'><xsl:value-of select="$self/bet"/></span>
                                </xsl:when>
                            </xsl:choose>
                            <form action="/bjx/games/{/game/@id}/newRound" method="POST" target="hiddenFrame">
                                <input class="btn" type="submit" value="New Round"/>
                            </form>
                        </xsl:when>
                    </xsl:choose>
                </div>
                <iframe class="hidden" name="hiddenFrame"/>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
