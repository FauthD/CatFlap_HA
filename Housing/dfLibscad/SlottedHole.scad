// A sloted hole (long hole).
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

$fa = 0.1;
$fs = 0.1;
Epsilon = 0.001;

// long hole
module SlottedHole(d, h, length)
{
   translate([0, 0, h/2])
      cube(size=[length, d, h+Epsilon], center=true);
      
   for(x=[-length/2,length/2])
   {
      translate([x, 0, h/2])
      {
         cylinder(d=d, h=h+Epsilon, center=true);
      }
   }
}

module SlottedHole_2D(d, length)
{
   translate([0, 0])
      square(size=[length, d], center=true);
      
   for(x=[-length/2,length/2])
   {
      translate([x, 0])
      {
         circle(d=d);
      }
   }
}
