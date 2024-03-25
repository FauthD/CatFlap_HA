// Various helper functions collected from other projects.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

Epsilon = 0.01;
TAU = 6.2831853071; //2*PI, see http://tauday.com/
PI = TAU/2;

// calculates a point on the circle at the specified angle and adds an offset length
function pointOnCircleOffset(radius=1, angle=0, circumferenceOffset=0) = (
     let(offsetAngle = (circumferenceOffset * 180 / ((radius-circumferenceOffset) * PI) ) )
     [sin(angle+offsetAngle) * (radius), cos(angle+offsetAngle) * (radius)]
);

// calculate a point on a circle
function old_pointOnCircle(radius=1, center=[0,0], angle) =
(
     [sin(angle) * (radius) + center[0], cos(angle) * (radius) + center[1]]
);

function PointOnCircle(radius=1, center=[0,0], angle) =
(
     [cos(angle) * (radius) + center[1], sin(angle) * (radius) + center[0]]
);

// rotate and instancce children
module rotateCopy(deltaAngle = 4, no_original=true)
{
    if(!no_original)
      children();
    rotate(deltaAngle, [0,0,1])
      children();
}

module RingCamferInner(diameter=40, width=5, round=1)
{
   height = 2*round;

   difference()
   {
      cylinder(d=diameter, h=height, center=true);

      rotate_extrude(angle = 360, convexity = 2)
         translate([diameter/2, 0, 0])
            circle(r = round);
            
      translate([0, 0, -height/2])
         cylinder(d=diameter+Epsilon, h=height, center=true);
      //cylinder(d=diameter-round, h=height+Epsilon, center=true);
   }
}

module RingCamferOuter(diameter=40, width=5, angle=360, round=1)
{
   height = 2*round;
   SomeNumber = round;
   
   translate([0, 0, -height/2])
      difference()
      {
         cylinder(d=diameter+SomeNumber, h=height+Epsilon, center=true);

         rotate_extrude(angle = angle, convexity = 2)
            translate([diameter/2-round, 0, 0])
               circle(r = round);
               
         translate([0, 0, -height/2])
            cylinder(d=diameter+SomeNumber+Epsilon, h=height, center=true);
         cylinder(d=diameter-2*round, h=2*height+Epsilon, center=true);
         
         rotate([0, 0, angle])
            translate([0, 0, -round])
               rotate_extrude(angle = 360-angle, convexity = 2)
                  translate([diameter/2-2*round-Epsilon, 0, 0])
                     square(size = round*4);
            
         // cut 90° off to see inside (debug)
         // translate([0, 0, -50/2])
         //    cube(size=50);
      }
}

module Ring(diameter=40, height=5, width=5, fn_out=$fn, fn_in=$fn)
{
   difference()
   {
      cylinder(d=diameter, h=height, center=true, $fn=fn_out);
      cylinder(d=diameter-2*width, h=height+Epsilon, center=true, $fn=fn_in);
   }
}

module OldRingPortion(radius, angle, thick, height)
{
    difference()
    {
        cylinder(r=radius, h=height, center=true);
        cylinder(r=radius-thick, h=height+Epsilon, center=true);

        translate([0, radius, 0] )
            cube(size = [radius*3, radius*2, height+Epsilon], center=true);
        rotate([0,0,angle])
            translate([0, -radius, 0] )
                cube(size = [radius*6, radius*2, height+Epsilon], center=true);
    }
}

module RingPortion(diameter=40, height=5, width=5, angle=35, round_end=false, round=0)
{
   _angle=angle;
   difference()
   {
      union()
      {
         difference()
         {
            Ring(diameter, height, width);
            rotate([0,0,_angle])
               translate([-diameter*0.33, diameter/2, 0])
                  cube(size=[2*diameter, diameter, 2*height], center = true);
            translate([0, -diameter/2, 0])
               cube(size=[diameter+Epsilon, diameter, 2*height], center = true);
         }
         // round the end
         if(round_end)
         {
            end = PointOnCircle(radius=(diameter-width)/2, angle=_angle);
            // rotate([0,0,_angle])
            translate([end.x, end.y, 0])
               cylinder(d=width, h=height, center=true);
         }
      }
      
      if (round>0)
      { 
         // make it round (upper)
         translate([0, 0, height/2+Epsilon])
            RingCamferOuter(diameter=diameter, round=round);
         // make it round (lower)
         translate([0, 0, -height/2-Epsilon])
            rotate([0, 180, 0])
               RingCamferOuter(diameter=diameter, round=round);
      }
   }
}
// 
module RingPortionFlatInside(diameter=40, height=5, width=5, angle=35, round_end=false, round=0)
{
   _angle=angle;
   difference()
   {
      union()
      {
         difference()
         {
            cylinder(d=diameter, h=height, center=true);
            translate([(diameter-2*width)/2, 0, 0])
               rotate([0,0,_angle/2])
                     translate([-diameter/2, 0, 0])
                        cube(size=[diameter, 2*diameter, 2*height], center = true);
            
            
            rotate([0,0,_angle])
               translate([-diameter*0.33, diameter/2, 0])
                  cube(size=[2*diameter, diameter, 2*height], center = true);
            translate([0, -diameter/2, 0])
               cube(size=[diameter+Epsilon, diameter, 2*height], center = true);
         }
         // round the end
         if(round_end)
         {
            end = PointOnCircle(radius=(diameter-width)/2, angle=_angle);
            // rotate([0,0,_angle])
            translate([end.x, end.y, 0])
               cylinder(d=width, h=height, center=true);
         }
      }
      
      if (round>0)
      { 
         // make it round (upper)
         translate([0, 0, height/2+Epsilon])
            RingCamferOuter(diameter=diameter, width=width);
         // make it round (lower)
         translate([0, 0, -height/2-Epsilon])
            rotate([0, 180, 0])
               RingCamferOuter(diameter=diameter, width=width);
      }
   }
}
// RingPortionFlatInside(diameter=40, height=5, width=5, angle=45, round_end=false, round=0);

module CutHoles(len=20, width=10, thick=4, offset=0)
{
    step = width*0.75;
    num = round(len/step) - 1;
    translate([-num*step/2 + offset, 0, 0])
    {
        for(x=[0:1:num])
        {
            translate([x*step, 0, 0])
                cylinder(d=width/2, h=4*thick, center=true);
        }
    }
}

module AirHoleGrid(width, height, thick=5, grid=[4,3,3], max_bridge_width=30, center=true, alignlow=false)
{
    hole_height=grid[0];
    bridge_height=grid[1];
    pole_with=grid[2];

    num_bridges = ceil(width/(max_bridge_width+pole_with));
    bridge_width = width/num_bridges - pole_with;
    //echo(num_bridges, bridge_width+pole_with);
    num_slits = floor(height/(hole_height+bridge_height));
    //echo(num_slits);
    upper_limit = num_slits*(hole_height+bridge_height);
    offset_y = height-upper_limit;
    //echo (offset_y);
    
    translate([center ? -width/2:0, center ? (alignlow ? -offset_y/2-height/2 : -height/2) : 0, 0])
    {
        for(y=[0:(hole_height+bridge_height):upper_limit-Epsilon])
        {
            translate([0,bridge_height+offset_y/2+y,0])
            {
                for(x=[0:bridge_width+pole_with:width-Epsilon])
                {
                    translate([bridge_width/2+pole_with/2+x,0,0])
                        cube(size=[bridge_width, hole_height, thick], center=true);
                }
            }
        }
    }
}

// #AirHoleGrid(width=100, height=100, center=true, alignlow=true);

// diameter=outer diameter
module SphereShell(diameter, thick)
{
    inner = diameter-thick;
    outer = diameter;
    difference()
    {
        sphere(d=outer);
        sphere(d=inner);
    }
}
//SphereShell(thick=2, diameter=10);

// diameter=outer diameter
module HalfSphereShell(diameter, thick)
{
    inner = diameter-thick;
    outer = diameter;
    difference()
    {
        sphere(d=outer);
        sphere(d=inner);
        translate([0,0,-outer/2])
          cube(size=[outer, outer, outer], center=true);
    }
}
//HalfSphereShell(thick=2, diameter=10);

module AirHolesInCirles(outer_diamter, thick, air_hole_diameter=5)
{
   wall = 1.05;
   distance = air_hole_diameter*wall;
   
   //cylinder(d=outer_diamter, h=0.1, center=true);
   
   for(ring=[0:air_hole_diameter+wall:outer_diamter/2-wall-Epsilon])
   {
      //Ring(diameter=2*ring+wall, height=0.5, width=1);
      num_holes = floor(2*ring*PI/(air_hole_diameter+wall));
      angle=360/num_holes;
      //echo(num_holes, angle, ring);
      
      // circle of holes
      for(a=[0:angle:360-Epsilon])
      {
            rotateCopy(deltaAngle=a)
               translate([0, ring, 0])
                  cylinder(d=air_hole_diameter, h=thick, center=true);
      }
   }
}

// AirHolesInCirles(outer_diamter=55, thick=2, air_hole_diameter=5);

// experimental, use with care!!!
module rotate_about_pt(a, v, pt)
{
   translate(pt) rotate(a,v) translate(-pt) children();
}

module right_triangle(size, center=false)
{
   x = center ? -size.x/2 : 0;
   y = center ? -size.y/2 : 0;
   z = center ? -size.z/2 : 0;

   translate([x,y,z])
      linear_extrude(height=size.z)
         polygon(points = [ [0, 0], [size.x, 0], [0, size.y]]);
}
