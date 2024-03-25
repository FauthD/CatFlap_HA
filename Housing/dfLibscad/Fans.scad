// Various fan holes.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

// Indexes
Fan30=0;
Fan40=1;
Fan50=2;
Fan60=3;
Fan70=4;
Fan80=5;
Fan92=6;
Fan120=7;
Fan140=8;

module FanHoles(index=Fan80, wall)
{
   fans=[[30, 24.0, 3.4],[40, 32.0, 4.7],[50, 40.0, 4.7],[60, 50.0, 4.7],[70, 61.5, 4.7],
         [80, 71.5, 4.7],[92, 82.5, 4.7],[120, 105, 4.7],[140, 125, 4.7]];
   big=fans[index].x;
   screw_distance=fans[index].y;
   drill=fans[index].z;
   
   cylinder(d=big-2, h=5*wall, center=true);
   for(a=[45:90:360-Epsilon])
   {
      rotate([0,0,a])
         translate([screw_distance/1.414, 0, 0])
         {
            cylinder(d=drill, h=5*wall, center=true);
            h=drill/3;
            translate([0, 0, (wall-h)/2])
               cylinder(d1=drill*1.2, d2=drill, h=h+Epsilon, center=true);
         }
   }
}
