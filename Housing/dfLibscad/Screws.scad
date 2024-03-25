// A simple screw library for various srew holes.
// Copyright (C) 2021 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

Epsilon = 0.01;
ScrewTolerance=0.13;
UnderPrint=0.3;

// This kind of screws specify the total lenght including the head
module SinkScrew(diameter, head_dia, head_length, dept, outer_diameter=0, outer_diameter_length=0, extra_head = 0.7, extra_sink=0)
{
   head_diameter1 = (outer_diameter==0) ? diameter+UnderPrint : outer_diameter;
   head_length1 = head_length-extra_head;
   
   translate([0,0,-dept/2+Epsilon])
   {
        // screw hole
        cylinder(d=diameter+UnderPrint, h=dept, center=true );
        // sink head
        translate([0,0,dept/2-head_length1/2-extra_head-extra_sink])
            rotate([180,0,0])
                cylinder(d2=head_diameter1+UnderPrint, d1=head_dia+UnderPrint, h=head_length1, center=true );

         // some screws have a second angle in the head
         translate([0,0,dept/2-head_length1-extra_head-outer_diameter_length/2])
            rotate([180,0,0])
               cylinder(d2=diameter+UnderPrint, d1=head_diameter1+UnderPrint, h=outer_diameter_length+Epsilon, center=true );

      // sink the screw a bit
      translate([0,0,dept/2-(extra_head+extra_sink)/2])
         cylinder(d=head_dia+UnderPrint, h=extra_head+extra_sink+Epsilon, center=true );
   }
}

// This kind of screws specify the total lenght excluding the head
module HeadScrew(diameter, head_dia=0, head_length=0, show_head=false, dept, extra_sink=0, sunken=false)
{
   sink=sunken ? head_length+extra_sink : 0;
   translate([0,0,-dept/2-sink])
   {
      cylinder(d=diameter+UnderPrint, h=dept, center=true );
      if(sunken) // optional sink the screw
      {
         translate([0,0,dept/2+(head_length+extra_sink)/2])
            rotate([180,0,0])
               cylinder(d=head_dia+2*ScrewTolerance+UnderPrint, h=head_length+extra_sink+ScrewTolerance, center=true );
      }
      if(show_head)
      {
         translate([0,0,dept/2+head_length/2])
            cylinder(d=head_dia+UnderPrint, h=head_length+Epsilon, center=true );
      }
   }
}
// ScrewHole(diameter=3, dept=10, type="SunkenHead_M", hole_only=false, show_head=false, extra_sink=6);
// ScrewHole(diameter=3, dept=10, type="Head_M", hole_only=false, show_head=true, extra_sink=0);

function GetScrewIndex(diameter) = (diameter<=4) ? floor((diameter-2)*2) : floor(diameter);

// Self tabbing M screws, DIN 7500
Sink_Din7500_Database = 
[
  //dia   drill head_dia  head_lenght outer_diameter  outer_diameter_length extra_head
  [ 2,    1.85, 3.8+0.2,  1.2,        0,              0,                    0.3 ],
  [ 2.5,  2.25, 5.0+0.25, 1.5,        0,              0,                    0.3 ],
  [ 3,    2.7,  5.8+0.3,  1.65,       0,              0,                    0.5 ],
  [ 3.5,  3.2,  6.8+0.4,  1.93,       0,              0,                    0.5 ],
  [ 4,    3.6,  7.8+0.5,  2.2,        0,              0,                    0.6 ],
  [ 5,    4.5,  9.6+0.5,  2.7,        0,              0,                    0.6  ],
  [ 6,    5.6,  11.6+0.6, 3.3,        0,              0,                    0.6  ],
  [ -1,   0,    0,        0  ,        0,              0,                    0.6  ],  // M7 not available
  [ 8,    6.5,  16.1+0.6, 4.65,       0,              0,                    0.6  ],
];

// Self tabbing M screws, DIN 7500
Head_Din7500_Database = 
[
  //dia   drill head_dia  head_lenght
  [ 2,    1.85, 4,      1.6 ],
  [ 2.5,  2.25, 5,      2   ],
  [ 3,    2.7,  6,      2.4 ],
  [ 3.5,  3.2,  6.9,    2.8 ],  // not sure if these 3.5 values are correct
  [ 4,    3.6,  8,      3.1 ],
  [ 5,    4.5,  10,     3.8 ],
  [ 6,    5.6,  12,     4.6 ],
  [ -1,   0,    0,      0   ],  // M7 not available
  [ 8,    6.5,  16,     6.0 ],
];

// manual tabbing M screws
Head_M_Manual_Tabbing_Database = 
[
  //dia   drill head_dia  head_lenght
  [ 2,    1.6,  4,      1.6 ],
  [ 2.5,  2.1,  5,      2   ],
  [ 3,    2.5,  6,      2.4 ],
  [ 3.5,  2.9,  6.9,    2.8 ],  // not sure if these 3.5 vlaues are correct
  [ 4,    3.3,  8,      3.1 ],
  [ 5,    4.2,  10,     3.8 ],
  [ 6,    5.0,  12,     4.6 ],
  [ 7,    6.0,  16,     6.0 ],
  [ 8,    6.8,  16,     6.0 ],
];

// Regular M screws with a pan head
Head_M_Database = 
[
  //dia   drill head_dia  head_lenght
  [ 2,    2.2,  4,      1.6 ],
  [ 2.5,  2.75, 5,      2   ],
  [ 3,    3.3,  6,      2.4 ],
  [ 3.5,  3.85, 6.9,    2.8 ],  // not sure if these 3.5 vlaues are correct
  [ 4,    4.4,  8,      3.1 ],
  [ 5,    5.5,  10,     3.8 ],
  [ 6,    6.5,  12,     4.6 ],
  [ 7,    7.5,  14,     6.0 ],
  [ 8,    8.5,  16,     6.0 ],
];

// Regular M screws with sink head
Sink_M_Database = 
[
  //dia   drill head_dia  head_lenght outer_diameter  outer_diameter_length extra_head
  [ 2,    2.2,  3.8+0.2,  1.2,        0,              0,                    0.3 ],
  [ 2.5,  2.75, 5.0+0.25, 1.5,        0,              0,                    0.3 ],
  [ 3,    3.3,  5.8+0.3,  1.65,       0,              0,                    0.5 ],
  [ 3.5,  3.85, 6.8+0.4,  1.93,       0,              0,                    0.5 ],
  [ 4,    4.4,  7.8+0.5,  2.2,        0,              0,                    0.6 ],
  [ 5,    3.0,  9.6+0.5,  4.5,        0,              0,                    0.8],
  [ 6,    3.5, 111.6+0.6, 4.5,        0,              0,                    0.9],
  [ -1,   0,    0,          0,        0,              0,                    0],
  [ -1,   0,    16.1+0.6,   0,        0,              0,                    0],
];

// "wood" screws with sink head (~ DIN 7998)
Sink_SelfTab_Database = 
[
  //dia   drill head_dia  head_lenght outer_diameter  outer_diameter_length extra_head
  [ 2,    1.5,  3.8+0.2,  1.2,        0,              0,                    0.3 ],
  [ 2.5,  1.8,  5.0+0.25, 1.5,        0,              0,                    0.3 ],
  [ 3,    2.15, 5.8+0.3,  1.75,       0,              0,                    0.5 ],
  [ 3.5,  2.45, 6.8+0.4,  2.0,        0,              0,                    0.55],
  [ 4,    2.85, 7.8+0.5,  2.7,        0,              0,                    0.65],
  [ 5,    3.0,  9.6+0.5,  4.5,        0,              0,                    0.8],
  [ 6,    3.5,  11.6+0.6, 4.5,        0,              0,                    0.9],
  [ -1,   0,    0,          0,        0,              0,                    0],
  [ -1,   0,    16.1+0.6,   0,        0,              0,                    0],
];

// "wood" screws with pan head (~ DIN TBD)
Head_SelfTab_Database = 
[
  //dia   drill head_dia  head_lenght
  [ 2,    1.5,  4,      1.6 ],
  [ 2.5,  1.8,  5,      2.0 ],
  [ 3,    2.15, 6,      2.4 ],
  [ 3.5,  2.45, 6.9,    2.8 ],
  [ 4,    2.85, 8,      3.1 ],
  [ 5,    3.0,  9.5,    4.5 ],
  [ 6,    3.5,  12,     4.5 ],
  [ -1,   0,     0,       0 ],
  [ -1,   0,     0,       0 ],
];

module MakeSinkScrewHole(s, dept, hole_only, extra_sink=0)
{
  if(s[0]>0)
  {
    if(hole_only)
    {
      translate([0,0,-dept/2])
        cylinder(d=s[1], h=dept, center=true);
    }
    else
    {
      SinkScrew(diameter=s[0]*1.1, head_dia=s[2]+ScrewTolerance, head_length=s[3],
                outer_diameter=s[4], outer_diameter_length=s[5], extra_head=s[6], extra_sink=extra_sink+ScrewTolerance,
                dept=dept);
    }
  }
  else
  {
     echo("Screw with that diameter is not in database");
  }
}

module MakeHeadScrewHole(s, dept, hole_only, show_head=false, extra_sink=0, sunken=false)
{
  if(s[0]>0)
  {
    if(hole_only)
    {
      translate([0,0,-dept/2])
        cylinder(d=s[1], h=dept, center=true);
    }
    else
    {
      HeadScrew(diameter=s[0]*1.1, head_dia=s[2]+ScrewTolerance, head_length=s[3]+ScrewTolerance, dept=dept, extra_sink=extra_sink, sunken=sunken, show_head=show_head);
    }
  }
  else
  {
     echo("Screw with that diameter is not in database");
  }
}

module ScrewHole(diameter, dept, type, hole_only=false, show_head=false, extra_sink=0)
{
   // echo(type);
   assert(diameter>=2);
   assert(diameter<=6);
   index = GetScrewIndex(diameter);
   
   if((type=="Sink_Din7500")||(type=="Sink_M_ManualTab"))
   {
      s = Sink_Din7500_Database[index];
      MakeSinkScrewHole(s=s, dept=dept, hole_only=hole_only, extra_sink=extra_sink);
   }
   else if(type=="Head_Din7500")
   {
      s = Head_Din7500_Database[index];
      MakeHeadScrewHole(s=s, dept=dept, hole_only=hole_only, show_head=show_head, extra_sink=extra_sink);
   }
   else if(type=="Head_ManualTab")
   {
      s = Head_M_Manual_Tabbing_Database[index];
      MakeHeadScrewHole(s=s, dept=dept, hole_only=hole_only, show_head=show_head, extra_sink=extra_sink);
   }
   else if(type=="Sink_SelfTab")
   {
      s = Sink_SelfTab_Database[index];
      MakeSinkScrewHole(s=s, dept=dept, hole_only=hole_only, extra_sink=extra_sink);
   }
   else if(type=="Sink_M")
   {
      s = Sink_M_Database[index];
      MakeSinkScrewHole(s=s, dept=dept, hole_only=hole_only, extra_sink=extra_sink);
   }
   else if(type=="Head_M")
   {
      s = Head_M_Database[index];
      MakeHeadScrewHole(s=s, dept=dept, hole_only=hole_only, show_head=show_head, extra_sink=extra_sink);
   }
   else if(type=="SunkenHead_M")
   {
      s = Head_M_Database[index];
      MakeHeadScrewHole(s=s, dept=dept, hole_only=hole_only, show_head=show_head, extra_sink=extra_sink, sunken=true);
   }
   else if(type=="Head_SelfTab")
   {
      s = Head_SelfTab_Database[index];
      MakeHeadScrewHole(s=s, dept=dept, hole_only=hole_only, show_head=show_head);
   }
   else if(type=="SunkenHead_SelfTab")
   {
      s = Head_SelfTab_Database[index];
      MakeHeadScrewHole(s=s, dept=dept, hole_only=hole_only, show_head=show_head, extra_sink=extra_sink, sunken=true);
   }
   else
   {
      echo("not a known screw type");
   }
}

//ScrewHole(diameter=3, dept=10, type="Sink_M_ManualTab", hole_only=false, extra_sink=2);
