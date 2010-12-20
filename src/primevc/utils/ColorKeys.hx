/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package primevc.utils;



/**
 * A list of colorKey name constants that respect the SVG 
 * specification of ColorKeys.
 * 
 * @author Degrafa
 */
class ColorKeys
{
	public static inline var ALICEBLUE				: UInt = 0xF0F8FF; // 240,248,255
	public static inline var ANTIQUEWHITE			: UInt = 0xFAEBD7; // 250,235,215
	public static inline var AQUA					: UInt = 0x00FFFF; // 0,255,255
	public static inline var AQUAMARINE				: UInt = 0x7FFFD4; // 127,255,212
	public static inline var AZURE					: UInt = 0xF0FFFF; // 240,255,255
	public static inline var BEIGE					: UInt = 0xF5F5DC; // 245,245,220
	public static inline var BISQUE					: UInt = 0xFFE4C4; // 255,228,196
	public static inline var BLACK					: UInt = 0x000000; // 0,0,0
	public static inline var BLANCHEDALMOND			: UInt = 0xFFEBCD; // 255,235,205
	public static inline var BLUE					: UInt = 0x0000FF; // 0,0,255
	public static inline var BLUEVIOLET				: UInt = 0x8A2BE2; // 138,43,226
	public static inline var BROWN					: UInt = 0xA52A2A; // 165,42,42
	public static inline var BURLYWOOD				: UInt = 0xDEB887; // 222,184,135
	public static inline var CADETBLUE				: UInt = 0x5F9EA0; // 95,158,160
	public static inline var CHARTREUSE				: UInt = 0x7FFF00; // 127,255,0
	public static inline var CHOCOLATE				: UInt = 0xD2691E; // 210,105,30
	public static inline var CORAL					: UInt = 0xFF7F50; // 255,127,80
	public static inline var CORNFLOWERBLUE			: UInt = 0x6495ED; // 100,149,237
	public static inline var CORNSILK				: UInt = 0xFFF8DC; // 255,248,220
	public static inline var CRIMSON				: UInt = 0xDC143C; // 220,20,60
	public static inline var CYAN					: UInt = 0x00FFFF; // 0,255,255
	public static inline var DARKBLUE				: UInt = 0x00008B; // 0,0,139
	public static inline var DARKCYAN				: UInt = 0x008B8B; // 0,139,139
	public static inline var DARKGOLDENROD			: UInt = 0xB8860B; // 184,134,11
	public static inline var DARKGRAY				: UInt = 0xA9A9A9; // 169,169,169
	public static inline var DARKGREEN				: UInt = 0x006400; // 0,100,0
	public static inline var DARKGREY				: UInt = 0xA9A9A9; // 169,169,169
	public static inline var DARKKHAKI				: UInt = 0xBDB76B; // 189,183,107
	public static inline var DARKMAGENTA			: UInt = 0x8B008B; // 139,0,139
	public static inline var DARKOLIVEGREEN			: UInt = 0x556B2F; // 85,107,47
	public static inline var DARKORANGE				: UInt = 0xFF8C00; // 255,140,0
	public static inline var DARKORCHID				: UInt = 0x9932CC; // 153,50,204
	public static inline var DARKRED				: UInt = 0x8B0000; // 139,0,0
	public static inline var DARKSALMON				: UInt = 0xE9967A; // 233,150,122
	public static inline var DARKSEAGREEN			: UInt = 0x8FBC8F; // 143,188,143
	public static inline var DARKSLATEBLUE			: UInt = 0x483D8B; // 72,61,139
	public static inline var DARKSLATEGRAY			: UInt = 0x2F4F4F; // 47,79,79
	public static inline var DARKSLATEGREY			: UInt = 0x2F4F4F; // 47,79,79
	public static inline var DARKTURQUOISE			: UInt = 0x00CED1; // 0,206,209
	public static inline var DARKVIOLET				: UInt = 0x9400D3; // 148,0,211
	public static inline var DEEPPINK				: UInt = 0xFF1493; // 255,20,147
	public static inline var DEEPSKYBLUE			: UInt = 0x00BFFF; // 0,191,255
	public static inline var DIMGRAY				: UInt = 0x696969; // 105,105,105
	public static inline var DIMGREY				: UInt = 0x696969; // 105,105,105
	public static inline var DODGERBLUE				: UInt = 0x1E90FF; // 30,144,255
	public static inline var FIREBRICK				: UInt = 0xB22222; // 178,34,34
	public static inline var FLORALWHITE			: UInt = 0xFFFAF0; // 255,250,240
	public static inline var FORESTGREEN			: UInt = 0x228B22; // 34,139,34
	public static inline var FUCHSIA				: UInt = 0xFF00FF; // 255,0,255
	public static inline var GAINSBORO				: UInt = 0xDCDCDC; // 220,220,220
	public static inline var GHOSTWHITE				: UInt = 0xF8F8FF; // 248,248,255
	public static inline var GOLD					: UInt = 0xFFD700; // 255,215,0
	public static inline var GOLDENROD				: UInt = 0xDAA520; // 218,165,32
	public static inline var GRAY					: UInt = 0x808080; // 128,128,128
	public static inline var GREEN					: UInt = 0x008000; // 0,128,0
	public static inline var GREENYELLOW			: UInt = 0xADFF2F; // 173,255,47
	public static inline var GREY					: UInt = 0x808080; // 128,128,128
	public static inline var HONEYDEW				: UInt = 0xF0FFF0; // 240,255,240
	public static inline var HOTPINK				: UInt = 0xFF69B4; // 255,105,180
	public static inline var INDIANRED				: UInt = 0xCD5C5C; // 205,92,92
	public static inline var INDIGO					: UInt = 0x4B0082; // 75,0,130
	public static inline var IVORY					: UInt = 0xFFFFF0; // 255,255,240
	public static inline var KHAKI					: UInt = 0xF0E68C; // 240,230,140
	public static inline var LAVENDER				: UInt = 0xE6E6FA; // 230,230,250
	public static inline var LAVENDERBLUSH			: UInt = 0xFFF0F5; // 255,240,245
	public static inline var LAWNGREEN				: UInt = 0x7CFC00; // 124,252,0
	public static inline var LEMONCHIFFON			: UInt = 0xFFFACD; // 255,250,205
	public static inline var LIGHTBLUE				: UInt = 0xADD8E6; // 173,216,230
	public static inline var LIGHTCORAL				: UInt = 0xF08080; // 240,128,128
	public static inline var LIGHTCYAN				: UInt = 0xE0FFFF; // 224,255,255
	public static inline var LIGHTGOLDENRODYELLOW	: UInt = 0xFAFAD2; // 250,250,210
	public static inline var LIGHTGRAY				: UInt = 0xD3D3D3; // 211,211,211
	public static inline var LIGHTGREEN				: UInt = 0x90EE90; // 144,238,144
	public static inline var LIGHTGREY				: UInt = 0xD3D3D3; // 211,211,211
	public static inline var LIGHTPINK				: UInt = 0xFFB6C1; // 255,182,193
	public static inline var LIGHTSALMON			: UInt = 0xFFA07A; // 255,160,122
	public static inline var LIGHTSEAGREEN			: UInt = 0x20B2AA; // 32,178,170
	public static inline var LIGHTSKYBLUE			: UInt = 0x87CEFA; // 135,206,250
	public static inline var LIGHTSLATEGREY			: UInt = 0x778899; // 119,136,153
	public static inline var LIGHTSTEELBLUE			: UInt = 0xB0C4DE; // 176,196,222
	public static inline var LIGHTYELLOW			: UInt = 0xFFFFE0; // 255,255,224
	public static inline var LIME					: UInt = 0x00FF00; // 0,255,0
	public static inline var LIMEGREEN				: UInt = 0x32CD32; // 50,205,50
	public static inline var LINEN					: UInt = 0xFAF0E6; // 250,240,230
	public static inline var MAGENTA				: UInt = 0xFF00FF; // 255,0,255
	public static inline var MAROON					: UInt = 0x800000; // 128,0,0
	public static inline var MEDIUMAQUAMARINE		: UInt = 0x66CDAA; // 102,205,170
	public static inline var MEDIUMBLUE				: UInt = 0x0000CD; // 0,0,205
	public static inline var MEDIUMORCHID			: UInt = 0xBA55D3; // 186,85,211
	public static inline var MEDIUMPURPLE			: UInt = 0x9370DB; // 147,112,219
	public static inline var MEDIUMSEAGREEN			: UInt = 0x3CB371; // 60,179,113
	public static inline var MEDIUMSLATEBLUE		: UInt = 0x7B68EE; // 123,104,238
	public static inline var MEDIUMSPRINGGREEN		: UInt = 0x00FA9A; // 0,250,154
	public static inline var MEDIUMTURQUOISE		: UInt = 0x48D1CC; // 72,209,204
	public static inline var MEDIUMVIOLETRED		: UInt = 0xC71585; // 199,21,133
	public static inline var MIDNIGHTBLUE			: UInt = 0x191970; // 25,25,112
	public static inline var MINTCREAM				: UInt = 0xF5FFFA; // 245,255,250
	public static inline var MISTYROSE				: UInt = 0xFFE4E1; // 255,228,225
	public static inline var MOCCASIN				: UInt = 0xFFE4B5; // 255,228,181
	public static inline var NAVAJOWHITE			: UInt = 0xFFDEAD; // 255,222,173
	public static inline var NAVY					: UInt = 0x000080; // 0,0,128
	public static inline var OLDLACE				: UInt = 0xFDF5E6; // 253,245,230
	public static inline var OLIVE					: UInt = 0x808000; // 128,128,0
	public static inline var OLIVEDRAB				: UInt = 0x6B8E23; // 107,142,35
	public static inline var ORANGE					: UInt = 0xFFA500; // 255,165,0
	public static inline var ORANGERED				: UInt = 0xFF4500; // 255,69,0
	public static inline var ORCHID					: UInt = 0xDA70D6; // 218,112,214
	public static inline var PALEGOLDENROD			: UInt = 0xEEE8AA; // 238,232,170
	public static inline var PALEGREEN				: UInt = 0x98FB98; // 152,251,152
	public static inline var PALETURQUOISE			: UInt = 0xAFEEEE; // 175,238,238
	public static inline var PALEVIOLETRED			: UInt = 0xDB7093; // 219,112,147
	public static inline var PAPAYAWHIP				: UInt = 0xFFEFD5; // 255,239,213
	public static inline var PEACHPUFF				: UInt = 0xFFDAB9; // 255,218,185
	public static inline var PERU					: UInt = 0xCD853F; // 205,133,63
	public static inline var PINK					: UInt = 0xFFC0CB; // 255,192,203
	public static inline var PLUM					: UInt = 0xDDA0DD; // 221,160,221
	public static inline var POWDERBLUE				: UInt = 0xB0E0E6; // 176,224,230
	public static inline var PURPLE					: UInt = 0x800080; // 128,0,128
	public static inline var RED					: UInt = 0xFF0000; // 255,0,0
	public static inline var ROSYBROWN				: UInt = 0xBC8F8F; // 188,143,143
	public static inline var ROYALBLUE				: UInt = 0x4169E1; // 65,105,225
	public static inline var SADDLEBROWN			: UInt = 0x8B4513; // 139,69,19
	public static inline var SALMON					: UInt = 0xFA8072; // 250,128,114
	public static inline var SANDYBROWN				: UInt = 0xF4A460; // 244,164,96
	public static inline var SEAGREEN				: UInt = 0x2E8B57; // 46,139,87
	public static inline var SEASHELL				: UInt = 0xFFF5EE; // 255,245,238
	public static inline var SIENNA					: UInt = 0xA0522D; // 160,82,45
	public static inline var SILVER					: UInt = 0xC0C0C0; // 192,192,192
	public static inline var SKYBLUE				: UInt = 0x87CEEB; // 135,206,235
	public static inline var SLATEBLUE				: UInt = 0x6A5ACD; // 106,90,205
	public static inline var SLATEGRAY				: UInt = 0x708090; // 112,128,144
	public static inline var SLATEGREY				: UInt = 0x708090; // 112,128,144
	public static inline var SNOW					: UInt = 0xFFFAFA; // 255,250,250
	public static inline var SPRINGGREEN			: UInt = 0x00FF7F; // 0,255,127
	public static inline var STEELBLUE				: UInt = 0x4682B4; // 70,130,180
	public static inline var TAN					: UInt = 0xD2B48C; // 210,180,140
	public static inline var TEAL					: UInt = 0x008080; // 0,128,128
	public static inline var THISTLE				: UInt = 0xD8BFD8; // 216,191,216
	public static inline var TOMATO					: UInt = 0xFF6347; // 255,99,71
	public static inline var TURQUOISE				: UInt = 0x40E0D0; // 64,224,208
	public static inline var VIOLET					: UInt = 0xEE82EE; // 238,130,238
	public static inline var WHEAT					: UInt = 0xF5DEB3; // 245,222,179
	public static inline var WHITE					: UInt = 0xFFFFFF; // 255,255,255
	public static inline var WHITESMOKE				: UInt = 0xF5F5F5; // 245,245,245
	public static inline var YELLOW					: UInt = 0xFFFF00; // 255,255,0
	public static inline var YELLOWGREEN			: UInt = 0x9ACD32; // 154,205,50
}