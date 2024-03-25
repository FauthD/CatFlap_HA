
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

Epsilon=0.01;
epsilon=Epsilon;

use <./Screws.scad>
use <./RoundCornersCube.scad>
use <./SlottedHole.scad>

// thick.x: Bottom thickness
// thick.y: Sides thickness
// thick.z: Cover thickness
function EN_GetOuterSize ( inner, thick ) = 
	[inner.x + 2*thick[1],	// add sides thickness
	 inner.y + 2*thick[1],	// add sides thickness
	 inner.z + thick[0]+thick[2]]; // add bottom+cover thickness

module EN_ScrewHoles(inner, depth, screws, extra_sink=0, hole_only=false)
{
	screwdiameter=screws[0];
	screwtype=screws[1];
	screwoffset=screws[2];
	
	so=screwoffset;
	if(screwdiameter>0)
	{
		for(x=[-inner.x/2+so,inner.x/2-so])
		{
			for(y=[-inner.y/2+so,inner.y/2-so])
			{
				translate([x, y, depth/2+Epsilon])
					ScrewHole(diameter=screwdiameter, dept=depth+0.1, type=screwtype, hole_only=hole_only, show_head=false, extra_sink=extra_sink);
			}
		}
	}
}

// thick.x: Bottom thickness
// thick.y: Sides thickness
// thick.z: Cover thickness
module EN_RawCover(inner, thick, tolerance, radius)
{
	shell = thick[1];
	top_thickness = thick[2];
	
	x = inner.x + 2/2*shell + tolerance/2;
	y = inner.y + 2/2*shell + tolerance/2;
	RoundCornersCube(size=[x, y, top_thickness], r=radius);
}

// thick.x: Bottom thickness
// thick.y: Sides thickness
// thick.z: Cover thickness
module EN_Cover(inner, thick, tolerance, radius, screws, extra_sink=0, opening_slit=true)
{
	shell = thick.y;
	top_thickness = thick.z;
	
	difference()
	{
		EN_RawCover(inner, thick, tolerance, radius=radius+shell/2);
		EN_ScrewHoles(inner=inner, depth=top_thickness, screws=screws, extra_sink=extra_sink);
		if(opening_slit)
			translate([inner.x/2+shell-shell/3,0, 0])
				cube(size=[shell, 6.5, 5*top_thickness+Epsilon], center=true);
	}
}

// thick.x: Bottom thickness
// thick.y: Sides thickness
// thick.z: Cover thickness

// tolerance is used for the cover
// radius is used for the rounding of the sides

module EN_RawBody(inner, thick, tolerance, radius, screws, screwmount=0, under_print=0)
{
	bottom_thickness = thick[0];
	shell = thick[1];
	top_thickness = thick[2];
	
	outer = EN_GetOuterSize(inner, thick);

	difference()
	{
		RoundCornersCube(size=outer, r=radius+shell);
		translate([0, 0, thick.x])
			if(screwmount>0)
			{
				cube(size=[inner.x-2*screwmount, inner.y, outer.z], center=true);
				cube(size=[inner.x, inner.y-2*screwmount, outer.z], center=true);
				translate([0, 0, bottom_thickness])
					EN_ScrewHoles(inner, depth=inner.z*0.7, screws=screws, hole_only=true);
			}
			else
			{
				RoundCornersCube(size=[inner.x, inner.y, outer.z], r=radius);
			}

		translate([0, 0, outer.z/2-top_thickness/2+under_print+Epsilon])
			EN_RawCover(inner, thick, tolerance, radius=radius+shell/2);
	}
}

// A holder for small modules (like a C1101, RMF69)
module EN_ModulMount(size, holder_width=2, holder_height=2, tolerance=0.2)
{
	// echo(size);
	for(n=[-1,1])
	{
		translate([n*(size.y-holder_width/2+tolerance)/2, 0, holder_height/2])
			cube(size=[holder_width/2+tolerance, size.x, holder_height], center=true);

		translate([n*(holder_width/4 + size.y/2 + tolerance), 0, (size.z+holder_height)/2])
			cube(size=[holder_width/2, size.x, size.z+holder_height], center=true);
	}
}

module EN_SlottedAirHoles(total_width, len, dia, distance, thick, thinner=false)
{
	width=distance+dia;
	num=floor(total_width/width);

	if(thinner)
		translate([0, 0, -thick/2])
			RoundCornersCube(size=[len, (num-0.5)*width, thick+Epsilon], center=true, r=dia/2);

	for(m=[0:num-1])
	{
		translate([0, (m - (num-1)/2)*width, -5*thick])
			SlottedHole(d=dia, h=5*thick+Epsilon, length=len-dia);
	}
}

module EN_MountingPost(outer, inner, height)
{
	difference()
	{
		cylinder(d=outer, h=height, center=true);
		cylinder(d=inner, h=2*height, center=true);
	}
}

module EN_CableMount(len=15, h=5)
{
	thick=3.5;
	translate([0,0,h/2])
		difference()
		{
			cube(size=[len, thick, h], center=true);

			translate([0,0,-thick/2])
				cube(size=[len-2*thick, 2*thick, h], center=true);
		}
}
