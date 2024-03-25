// 
// Copyright (C) 2022 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

use <MCAD/math.scad>
// if above lib is not working, just use these few lines below.
// TAU = 6.2831853071; //2*PI, see http://tauday.com/
// PI = TAU/2;
// function deg(angle) = 360*angle/TAU;

function Hypotenuse(a, b) = sqrt(a^2+b^2);
	
// isosceles triangle
// gleichschenkliges Dreieck
//            /|\
//         a / H \ b=a
//          /  |  \
//  alpha   -------
//             c

function IsoscelesTriangleHeight_c(a,c) = 0.5 * sqrt(4*a^2 - c^2);
function IsoscelesTriangleAlpha(a,c) = acos(0.5*c/a);
