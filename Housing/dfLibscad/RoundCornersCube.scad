// A RoundCornersCube that is close in usage to a normal cube.
// Also some holow versions of it.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de
// Inspired by:
// http://codeviewer.org/view/code:1b36 
// Copyright (C) 2011 Sergio Vilches

Epsilon = 0.01;

module Meniscus(h, r, angle=0)
{
	rotate([0, 0, angle])
		difference()
		{
			translate([r/2+Epsilon, r/2+Epsilon, 0])
				cube([r+Epsilon, r+Epsilon, h+Epsilon], center=true);

			cylinder(h=h+2*Epsilon, r=r, center=true);
		}
}

// Meniscus(h=50, r=2, angle=0);
// Meniscus(h=50, r=2, angle=90);
// Meniscus(h=50, r=2, angle=180);
// Meniscus(h=50, r=2, angle=270);

module RoundCornersCube(size, center=true, r=1, corner=[true, true, true, true])
{
	h=size.z;
	z=(center==true) ? 0 : h/2;
	x=(center==true) ? 0 : size.x/2;
	y=(center==true) ? 0 : size.y/2;
	difference()
	{
		cube(size, center=center);

		if(corner[0])
			translate([size.x/2+x-r, size.y/2+y-r, z])
				Meniscus(h=h+Epsilon, r=r, angle=0);
		if(corner[1])
			translate([size.x/2+x-r, -size.y/2+y+r, z])
				Meniscus(h=h+Epsilon, r=r, angle=270);
		if(corner[2])
			translate([-size.x/2+x+r, -size.y/2+y+r, z])
				Meniscus(h=h+Epsilon, r=r, angle=180);
		if(corner[3])
			translate([-size.x/2+x+r, size.y/2+y-r, z])
				Meniscus(h=h+Epsilon, r=r, angle=90);
	}
}

module Test_RoundCornersCube(center)
{
	difference()
	{
		union()
		{
			RoundCornersCube(size = [10,20,30], center = center, r=2);
			#cube(size = [10,20,30], center = center);
		}
		//#cube(size = [11,21,10], center = center);
	}
}

// Test_RoundCornersCube(center=true);
// Test_RoundCornersCube(center=false);

pos_all_corners_centered = 
[
	[-0.5,-0.5,-0.5],
	[0.5,-0.5,-0.5],
	[0.5,0.5,-0.5],
	[-0.5,0.5,-0.5],
	[-0.5,-0.5,0.5],
	[0.5,-0.5,0.5],
	[0.5,0.5,0.5],
	[-0.5,0.5,0.5],
];

pos_all_corners_not_centered = 
[
	[0,0,0],
	[1,0,0],
	[1,1,0],
	[0,1,0],
	[0,0,1],
	[1,0,1],
	[1,1,1],
	[0,1,1],
];

module RoundAllCornersCube(size, center = true, r=1)
{
	pos = (center==true) ? pos_all_corners_centered : pos_all_corners_not_centered;
	offset = (center==true) ? 0 : r;
	z=(center==true) ? -size.z+2*r : size.z-2*r;
	x=(center==true) ? -size.x+2*r : size.x-2*r;
	y=(center==true) ? -size.y+2*r : size.y-2*r;

	hull()
	{
		for(i=[0:7])
		{
			translate([pos[i].x*x+offset, pos[i].y*y+offset, pos[i].z*z+offset])
				sphere(r=r);
		}
	}
}

module Test_RoundAllCornersCube(center)
{
	difference()
	{
		union()
		{
			RoundAllCornersCube(size = [10,20,30], center = center, r=2);
			cube(size = [10,20,30], center = center);
		}
		//#cube(size = [11,21,10], center = center);
	}
}

//Test_RoundAllCornersCube(center=true);
//Test_RoundAllCornersCube(center=false);

pos_upper_corners_not_centered = 
[
	[0,0,1],
	[1,0,1],
	[1,1,1],
	[0,1,1],
];

module RoundUpperCornersCube(size, center = true, r=1)
{
	pos = (center==true) ? pos_all_corners_centered : pos_upper_corners_not_centered;
	offset = (center==true) ? 0 : r;
	z=(center==true) ? -size.z+2*r : size.z-2*r;
	x=(center==true) ? -size.x+2*r : size.x-2*r;
	y=(center==true) ? -size.y+2*r : size.y-2*r;

	hull()
	{
		for(i=[0:3])
		{
			translate([pos[i].x*x+offset, pos[i].y*y+offset, pos[i].z*z+offset])
				sphere(r=r);
		}
		translate([0, 0, center ? -size.z/2+r/2 : 0])
			cube(size=[size.x, size.y, r], center=center);
		
	}
}

module Test_RoundUpperCornersCube(center)
{
	difference()
	{
		union()
		{
			RoundUpperCornersCube(size = [10,20,30], center = center, r=2);
			//cube(size = [10,20,30], center = center);
		}
		//cube(size = [11,21,10], center = center);
	}
}

// Test_RoundUpperCornersCube(center=true);
// Test_RoundUpperCornersCube(center=false);


module RoundCornersShell(size, thick, r)
{
    inner = size;
    outer = [inner.x+2*thick, inner.y+2*thick, inner.z+2*thick];
    difference()
    {
        RoundAllCornersCube(size=outer, center = true, r=r+thick/2);
        RoundAllCornersCube(size=inner, center = true, r=r);
    }
}
// RoundCornersShell(size=[100, 200, 250], thick=2, r=10);
module Test_RoundCornersShell(size=[100, 150, 250], thick=2, r=10)
{
	difference()
	{
		union()
		{
			RoundCornersShell(size = size, thick=thick, r=10);
			//cube(size = [10,20,30], center = center);
		}
		cube(size = size, center = false);
	}
	translate([0, size.y/2, 0])
		cube(size = [thick, thick, thick], center = false);
}

// Test_RoundCornersShell(size=[100, 150, 250], thick=20, r=10);

module RoundCornersShellOpen(size, thick, r)
{
    inner = size;
    outer = [inner.x+2*thick, inner.y+2*thick, inner.z+2*thick];
    extra_z = 4*r+thick;
	echo(inner, outer);
    difference()
    {
        translate([0,0,-extra_z/2])
            RoundCornersShell(size=[size.x, size.y, size.z+extra_z], thick=thick, r=r);
        translate([0,0,-(extra_z+thick)/2-size.z/2])
            cube(size=[outer.x+Epsilon, outer.y+Epsilon, extra_z+Epsilon+thick], center=true);
    }
}
// RoundCornersShellOpen(size=[100, 150, 250], thick=2, r=10);
// #cube(size=[100, 150, 250], center=true);

module Test_RoundCornersShellOpen(size=[100, 150, 250], thick=2, r=10)
{
	difference()
	{
		union()
		{
			RoundCornersShellOpen(size = size, thick=thick, r=10);
			//cube(size = [10,20,30], center = center);
		}
		cube(size = size, center = false);
	}
	translate([0, size.y/2, 0])
		cube(size = [thick, thick, thick], center = false);
}

//Test_RoundCornersShellOpen(size=[100, 150, 250], thick=20, r=10);

///////////////////////////////////////////////////////////////////////////////
// Some helpers to round combined objects
module RoundConvex(r)
{
	offset(r = r)
	{
		offset(delta = -r)
		{
			children();
		}
	}
}

module RoundConcave(r)
{
	offset(r = -r)
	{
		offset(delta = r)
		{
			children();
		}
	}
}

module RoundThis(r)
{
	RoundConcave(r) RoundConvex(r) children();
}

// Can round combined 2D objects and make them 3D
module RoundExtrude(r, h)
{
	linear_extrude(height = h)
		RoundThis(r) children();
}
