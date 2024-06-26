// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "box"; // ["box", "cover", "cut"]

/* [Sizes] */
BodyOuterLenght=100;
BodyInnerWidth=60;
BodyInnerDepth = 23;
BodyThickness=1.8;

BoardLength=70;
BoardWidth=50;

BoardOffsetL=-3.5;
BoardOffsetW=5;

BoardTolerance=0.75;
PcbThickness=1.6;

BoardMountHeight=4;

SupplyDiameter=13;
SupplyDiameterDrill=8.6;

CableSlot = 3.0;

ScrewType="Head_M"; // ["Head_M"]
ScrewDiameter = 3.5;	  // [2.5,1,6]

// Place screws towards the unside
ScrewOffset = 4.5;	//	[2:0.1:10]
// round the body
Radius=7;	//	[0:2:16]
// Gap between cover and body
GapTolerance=0.15;

// For revision text (0 turns off)
Fontsize=7;	//	[0:1:10]
// For revision text
Emboss=0.3;

/* [Misc] */

/* [Printer] */
// Some printers do not print height enough
UnderPrint = 0.35;	// [0:0.05:0.4]
Tolerance = 0.2;	// [0:0.05:0.4]


/* [Cover] */
CoverRadius=31;
CoverWidth=32;
CoverLength=96;
CoverThickness=2.7;

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.5;

// If you enable the next line, the $fa and $fs a	re ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

use <dfLibscad/Revision.scad>
use <dfLibscad/Screws.scad>
use <dfLibscad/Enclosure.scad>
include <./svn_rev.scad>

BodyInnerLength = BodyOuterLenght-2*BodyThickness;

ScrewMount=2.5*ScrewDiameter;
CornerMount=1.5*ScrewMount;
Inner = [BodyInnerLength, BodyInnerWidth+4*BoardTolerance, BodyInnerDepth];
Thick = [BodyThickness, BodyThickness, Epsilon];
Outer = EN_GetOuterSize (Inner, Thick);
Screws = [ScrewDiameter, ScrewType, ScrewOffset];

module PrintRevision()
{
	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		color("black")
		{
			translate([0, -Inner.y/2, Inner.z/2-Fontsize/2])
				WriteRevision(rev=SVN_RevisionStr, height=Emboss, fontsize=Fontsize, oneline=true, halign="center", rot=[90,0,0], mirror=true);
		}
	}
}

module RawBody()
{
	EN_RawBody(inner=Inner, thick=Thick, tolerance=GapTolerance, radius=Radius, screws=Screws, screwmount=ScrewMount, under_print=UnderPrint);
}

function BoardMountCenter(l,w) = [l/2-2, w/2-2];

module BoardMount(l,w)
{
	mount=5.5;
	drill=BoardMountCenter(l,w);
	for (x=[-1,1])
	{
		for (y=[-1,1])
		{
			translate([x*drill.x +BoardOffsetL, y*drill.y +BoardOffsetW, -Inner.z/2+BoardMountHeight/2])
				cube([mount, mount, BoardMountHeight], center=true);
		}
	}
}

module BoardMountDrills(l,w)
{
	{
		drill=BoardMountCenter(l,w);
		h=BoardMountHeight+BodyThickness;
		for (x=[-1,1])
		{
			for (y=[-1,1])
			{
				translate([x*drill.x +BoardOffsetL, y*drill.y+BoardOffsetW, -BodyInnerDepth/2+h/2])
					cylinder(d=1.6, h=h, center=true);
			}
		}
	}
}

module Body()
{
	difference()
	{
		union()
		{
			RawBody();
			// mounts for board
			BoardMount(BoardLength, BoardWidth);
		}

		// Drill mount screws totally through
		EN_ScrewHoles(inner=Inner, depth=2*Inner.z, screws=Screws, hole_only=true);

		// screws for board
		BoardMountDrills(BoardLength, BoardWidth);

		// drill for power connector
		translate([BodyOuterLenght/2-SupplyDiameter/2-BodyThickness, 0, -BodyInnerDepth/2])
			cylinder(d=SupplyDiameterDrill, h=5*BodyThickness, center=true);

		// Slot for flatcable
		translate([CornerMount/2-BodyOuterLenght/2, BoardOffsetW, -CableSlot/2+BodyInnerDepth/2+BodyThickness/2+Epsilon])
			cube([CornerMount+Epsilon, CoverWidth+2, CableSlot+Epsilon], center=true);

		// Make wall thinner to Expose the illumination better
		translate([BoardOffsetL, Inner.y/2-15/2+BodyThickness-0.6, -0.4*BodyInnerDepth/2-1.5*BodyThickness])
			cube([BoardLength-20, 15, 0.4*BodyInnerDepth], center=true);
	}

	PrintRevision();
}

// A cover to hide the flat cable on the wood
module CableCover()
{
	thick=CoverThickness;
	cable=1.7;
	difference()
	{
		translate([-CoverLength/2,0,thick/2])
			cube([CoverLength, CoverWidth, thick], center=true);
		
		translate([-CoverLength, -CoverWidth/2, 0])
			cylinder(r=CoverRadius, h=5*thick, center=true);

		translate([0,0, cable/2])
			cube([3*CoverLength, 16, cable+Epsilon], center=true);
		
		// screws
		for(x=[10,40])
		{
			for(y=[-1,1])
			{
				translate([-CoverLength + CoverRadius + x, y*CoverWidth*0.37, 0])
					cylinder(d=3, h=5*thick, center=true);
			}
		}
	}
}


module print(what="all")
{
	if(what == "box")
	{
		Body();
	}

	if(what == "cut")
	{
		difference()
		{
			Body();
			// translate([-BodyOuterLenght+8,-Outer.y+8, 0])
			// 	cube([BodyOuterLenght, Outer.y, 2*Outer.z], center=true);
			translate([20/2+BodyOuterLenght/2-18,-Outer.y+8, 0])
				cube([20, Outer.y, 2*Outer.z], center=true);
			// translate([60/28, Outer.y-4, BodyThickness/2])
			// 	cube([60, Outer.y, Inner.z], center=true);
		}
	}

	if(what == "cover")
	{
		CableCover();
	}

	if(what == "all")
	{
		print ("box");
	}
}

print(PrintThis);
