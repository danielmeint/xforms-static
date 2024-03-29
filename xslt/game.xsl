<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="name"/>
    <xsl:param name="balance"/>
    
    <xsl:variable name="self" select="/game/player[@name = $name]"/>
    <xsl:variable name="activePlayer" select="/game/player[@state = 'active']"/>

    <xsl:template match="/">
            <div class="flex-container">
                <svg viewBox="-100 0 1000 520">
                    <!-- table dimensions: 800 x 450 -->
                    <use href="/static/xforms-static/svg/table.svg#table" x="0" y="0"/>
                    <g id="dealer">
                        <g class="card_group">
                            <xsl:choose>
                                <xsl:when test="game/@state = 'playing'">
                                    <!-- only show the dealer's first card -->
                                    <use
                                        href="/static/xforms-static/svg/cards.svg#{game/dealer/hand/card[1]/@value}_{game/dealer/hand/card[1]/@suit}"/>
                                    <use href="/static/xforms-static/svg/cards.svg#back"
                                        style="transform: translate(40px, 4px)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="game/dealer/hand/card">
                                        <use href="/static/xforms-static/svg/cards.svg#{@value}_{@suit}"
                                            style="transform: translate({(position() - 1) * 40}px, {(position() - 1) * 4}px)"
                                        />
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </g>
                        <g class="label label-hand">
                            <rect x="10px" y="70px" rx="25" ry="25" width="80" height="50"/>
                            <text class="name" x="30px" y="85px">
                                Dealer
                            </text>
                            <text class="hand_value" x="30px" y="115px" xmlns="http://www.w3.org/2000/svg">
                                <xsl:choose>
                                    <xsl:when test="/game/@state = 'playing'">
                                        ?
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="/game/dealer/hand/@value"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </text>
                        </g>
                        
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
                                        <use href="/static/xforms-static/svg/chips.svg#chip" width="50" height="50"/>
                                        <text x="25" y="25" alignment-baseline="central">
                                            <xsl:value-of select="bet"/>
                                        </text>
                                    </g>
                                </xsl:if>
                                <g class="card_group">
                                    <xsl:for-each select="hand/card">
                                        <use href="/static/xforms-static/svg/cards.svg#{@value}_{@suit}"
                                            style="transform: translate({(position() - 1) * 40}px, {(position() - 1) * 4}px)"
                                        />
                                    </xsl:for-each>
                                </g>
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
                                        <xsl:value-of select="hand/@value"/>
                                    </text>
                                </g>
                            </g>
                        </xsl:for-each>
                    </g>
                </svg>
                <div class="functions">
                    <div id="login" class="right top">
                        <span><b><a href="/xforms-blackjack/profile"><xsl:value-of select="$name"/></a></b> ($<xsl:value-of select="$balance"/>)</span>
                        <a class="btn btn-secondary" href="/xforms-blackjack/logout">
                            <svg>
                                <use href="/static/xforms-static/svg/solid.svg#sign-out-alt"/>
                            </svg>
                        </a>
                    </div>
                    
                    <xsl:choose>
                        <xsl:when test="$self">
                            <!-- client is participating in the game -->
                            <form class="top left" action="/xforms-blackjack/games/{/game/@id}/leave" method="post" target="hiddenFrame">
                                <button class="btn btn-secondary" type="submit">
                                    Leave
                                </button>
                            </form>
                            
                            <xsl:choose>
                                
                                <xsl:when test="(/game/@state = 'betting' or /game/@state = 'playing') and $self/@state = 'inactive'">
                                    <!-- Player is inactive -->
                                    <div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
                                </xsl:when>
                                
                                <xsl:when test="/game/@state = 'betting' and $self/@state = 'active'">
                                    <!-- Betting stage -->
                                    <form action="/xforms-blackjack/games/{/game/@id}/bet" method="POST" target="hiddenFrame">
                                        <input type="number" name="bet" min="1" max="{$balance}"/>
                                        <button class="btn" type="submit">
                                            Bet
                                        </button>
                                    </form>
                                </xsl:when>
                                
                                <xsl:when test="/game/@state = 'playing' and $self/@state = 'active'">
                                    <!-- Playing stage -->
                                    <xsl:if test="count($self/hand/card) &lt; 3 and $self/hand/@value &lt; 21 and $balance >= 2 * $self/bet">
                                        <form action="/xforms-blackjack/games/{/game/@id}/double" method="POST" target="hiddenFrame">
                                            <button class="btn btn-secondary" type="submit">Double Down</button>
                                        </form>
                                    </xsl:if>
                                    <xsl:if test="$self/hand/@value &lt; 21">
                                        <form action="/xforms-blackjack/games/{/game/@id}/hit" method="POST" target="hiddenFrame">
                                            <button class="btn" type="submit">Hit</button>
                                        </form>
                                    </xsl:if>
                                    <form action="/xforms-blackjack/games/{/game/@id}/stand" method="POST" target="hiddenFrame">
                                        <button class="btn" type="submit">Stand</button>
                                    </form>
                                </xsl:when>
                                
                                <xsl:when test="/game/@state = 'evaluated'">
                                    <form action="/xforms-blackjack/games/{/game/@id}/newRound" method="POST" target="hiddenFrame">
                                        <button class="btn" type="submit">New Round</button>
                                    </form>
                                    <p>
                                        <xsl:choose>
                                            <xsl:when test="$self/profit > 0">
                                                You win<xsl:text>&#xA0;</xsl:text><span class='earnings won'>$<xsl:value-of select="$self/profit"/></span>
                                            </xsl:when>
                                            
                                            <xsl:when test="$self/profit = 0">
                                                You tie and keep your bet.
                                            </xsl:when>
                                            
                                            <xsl:when test="$self/profit &lt; 0">
                                                You lose<xsl:text>&#xA0;</xsl:text><span class='earnings lost'>$<xsl:value-of select="$self/profit"/></span>
                                            </xsl:when>
                                        </xsl:choose>
                                    </p>
                                    <p>New balance: $<xsl:value-of select="$balance"/></p>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- client is not participating, spectator mode -->
                            <xsl:choose>
                                <xsl:when test="1 > $balance">
                                    <!-- insufficient balance -->
                                    <p>Insufficient funds. Replenish to your balance<xsl:text>&#xA0;</xsl:text><a href='/xforms-blackjack/profile'>here</a>.</p>
                                    <a class="btn btn-secondary" href="/xforms-blackjack">◀ Menu</a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>You are<xsl:text>&#xA0;</xsl:text><b>spectating</b><xsl:text>&#xA0;</xsl:text>this game.</p>
                                    <a class="btn btn-secondary" href="/xforms-blackjack">◀ Menu</a>
                                    <form action='/xforms-blackjack/games/{/game/@id}/join' method='POST' target="hiddenFrame">
                                        <button class="btn" type='submit'>Join</button>
                                    </form>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="chat left bottom">
                    <input type="checkbox" id="chatToggle"/>
                    <table>
                        <xsl:for-each select="/game/chat/message">
                            <tr>
                                <xsl:choose>
                                    <xsl:when test="@author = 'INFO'">
                                        <td colspan="2" class="msg msg-info">
                                            <xsl:value-of select="text()"/>
                                        </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <td class="author">
                                            <xsl:value-of select="@author"/>
                                        </td>
                                        <td class="msg">
                                            <xsl:value-of select="text()"/>
                                        </td>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </tr>
                        </xsl:for-each>
                    </table>
                    <label id="hideChat" for="chatToggle">
                        <svg>
                            <use href="/static/xforms-static/svg/solid.svg#times"/>
                        </svg>
                    </label>
                    <label id="showChat" for="chatToggle">
                        <svg>
                            <use href="/static/xforms-static/svg/solid.svg#comments"/>
                        </svg>
                    </label>
                    <form action="/xforms-blackjack/games/{/game/@id}/chat" method="POST" target="hiddenFrame">
                        <input type="text" name="msg" placeholder="Chatting as {$name}"/>
                        <button class="btn" type="submit">Chat</button>
                    </form>
                </div>
                <form class="right bottom" action="/xforms-blackjack/games/{/game/@id}/draw" method="post" target="hiddenFrame">
                    <button class="btn btn-secondary" type="submit">
                        &#8634; Redraw Game
                    </button>
                </form>
                <iframe class="hidden" name="hiddenFrame"/>
            </div>
    </xsl:template>
</xsl:stylesheet>
