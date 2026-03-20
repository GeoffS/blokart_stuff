include <../OpenSCAD_Lib/MakeInclude.scad>
use <../OpenSCAD_Lib/torus.scad>

pwOD = 22;
pwID = 17.4;

plugOD = pwID;
plugID = 6;
plugInsidePullyWhipLen = 25;
bottomOutsideChamfer = 2;
bottomInsideChamfer = 1;

/* plugTorusInsideDia = 3;
plugTorusInsideOD = plugID + 2*plugTorusInsideDia;
plugTorusInsideRadius = plugTorusInsideDia/2; */

plugTorusOutsideOD = pwOD;
plugTorusOutsideDia = (plugTorusOutsideOD - plugID)/2;
plugTorusOutsideRadius = plugTorusOutsideDia/2;

module plug()
{
  difference()
  {
    union()
    {
      cylinder(d1=plugOD-2*bottomOutsideChamfer, d2=plugOD, h=bottomOutsideChamfer);
      translate([0,0,bottomOutsideChamfer]) cylinder(d=plugOD, h=plugInsidePullyWhipLen-bottomOutsideChamfer);
      translate([0,0,plugInsidePullyWhipLen]) difference()
      {
        torus3a(plugTorusOutsideOD, plugTorusOutsideDia);
        translate([-50, -50, plugTorusOutsideRadius*0.9]) cube(100);
        translate([-50, -50, -100]) cube(100);
      }
      /* translate([0,0,plugInsidePullyWhipLen]) difference()
      {
        torus3a(plugTorusInsideOD, plugTorusInsideDia);
        translate([-50, -50, -100]) cube(100);
      } */
    }
    translate([0,0,-10]) cylinder(d=plugID, h=100);
    d1 = plugID+bottomInsideChamfer+3;
    translate([0,0,-1]) cylinder(d1=d1, d2=0, h=d1/2);
  }
}

module clip(d=0)
{
  // tc([-200, -400-d, -50], 400);
}

if(developmentRender)
{
    display() plug();
}
else
{
	rotate([180,0,0]) plug();
}