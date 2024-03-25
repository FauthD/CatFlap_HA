// Write the version of this lib and a master project.
// I use SubVersion as revision control with SubWCRev to automatically create the version strings.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

include <./svn_rev.scad>

// halign: String. The horizontal alignment for the text. Possible values are "left", "center" and "right". Default is "left".
// valign : String. The vertical alignment for the text. Possible values are "top", "center", "baseline" and "bottom". Default is "baseline".

module WriteRevision(rev="", height=0.3, fontsize=6, font = "Liberation Mono:bold", halign="left", valign="top", mirror=false, rot=[0,0,0], oneline=false, lib=true)
{
	rotate(rot)
		mirror([mirror?1:0,0,0])
			linear_extrude(height = height, center = true, convexity = 10)
			{
					if (oneline)
					{
						if(lib)
							text(str(rev," ",SVN_RevisionStr_dfLibscad), size=fontsize, font = font, halign=halign, valign=valign);
						else
							text(rev, size=fontsize, font = font, halign=halign, valign=valign);
					}
					else
					{
						if(rev!="")
							text(rev, size=fontsize, font = font, halign=halign, valign=valign);
						if(lib)
							translate([0, -fontsize-1, 0])
								text(SVN_RevisionStr_dfLibscad, size=fontsize, font = font, halign=halign, valign=valign);
					}
			}
}
