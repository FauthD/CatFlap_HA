// A simple funnel.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

Epsilon = 0.01;

module Funnel(d1, d2, lenght, thick1, thick2)
{
   difference()
   {
      translate([0, 0, lenght/2])
         cylinder(d1=d1, d2=d2, h=lenght, center=true);
      translate([0, 0, lenght/2])
         cylinder(d1=d1-thick1, d2=d2-thick2, h=lenght+Epsilon, center=true);
   }
}

use <RoundCornersCube.scad>
use <Helpers.scad>

module FunnelHandle(d1, thick)
{
    Size=13;
    Hole=8;
    Offset=Size-Hole;
    Wall = 1*thick;
    translate([0, -d1/2-Size/2+(Size-Hole)/2, Wall/2])
        rotate([0,0,270])
            difference()
            {
                RoundCornersCube(size=[Size+Offset, Size, Wall], r=Hole/2);
                translate([Offset/2,0,0])
                    cylinder(d=Hole, h=Wall+Epsilon, center=true);
                translate([-Size+Offset/2-Wall,0,0])
                    cube(size=Size, center=true);
            }
}

module FunnelWithHandle(d1, d2, lenght, thick=1, thick1=0, thick2=0)
{
	_thick1 = (thick1<=0) ? thick : thick1;
	_thick2 = (thick2<=0) ? _thick1 : thick2;

    diff_x = (d1-d2)/2 - _thick1 - _thick2;
    ring_width = max(3.5, 2.5*_thick1);
    enforce_funnel_height = lenght/diff_x * ring_width;

    Funnel(d1=d1, d2=d2, lenght=lenght, thick1=_thick1, thick2=_thick2);
	FunnelHandle(d1=d1, thick=_thick1);	
	translate([0, 0, _thick1/2])
		Ring(diameter=d1+_thick1/2, height=_thick1, width=_thick1);
    Funnel(d1=d1-_thick1/2, d2=d1-ring_width-_thick1, lenght=enforce_funnel_height/2, thick1=ring_width, thick2=0);
}
