// A slide in for 2020/4040 aluminum profiles used by 3D printers.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

// View it like a tree:
Tolerance=0.4;
TrunkWidth=6.25-Tolerance;
TrunkHeight=1.8+Tolerance;
BranchWidth=11-Tolerance;
BranchHeight=1.64+TrunkHeight-Tolerance;
TipWidth=5.68-Tolerance;
TipHeigh=6.1-Tolerance;

use <RoundCornersCube.scad>

SlotInProfile=
[
	// start at tip of trunk, then proceede clock wise
	[0, TrunkHeight],
	[-BranchWidth/2, TrunkHeight],
	[-BranchWidth/2, BranchHeight],
	[-TipWidth/2, TipHeigh],
	// an now back towards starting point
	[TipWidth/2, TipHeigh],
	[BranchWidth/2, BranchHeight],
	[BranchWidth/2, TrunkHeight],
	[0, TrunkHeight],
];

module SlideIn(l)
{
	RoundExtrude(r=0.75, h=l)
		polygon(SlotInProfile);
	
	translate([0, TrunkHeight/2, l/2])
		cube([TrunkWidth, TrunkHeight, l], center=true);
}

// SlideIn(10);
