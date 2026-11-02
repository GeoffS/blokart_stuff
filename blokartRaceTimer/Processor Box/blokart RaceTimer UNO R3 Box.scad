// include <../../../OpenSCADdesigns/MakeInclude.scad>
// use <../../../OpenSCADdesigns/torus.scad>
include <../../../OpenSCAD_Lib/MakeInclude.scad>
use <../../../OpenSCAD_Lib/torus.scad>

perimeterWidth = 0.4;

// Arduino board dimensions:
hole1 = [15.24, 50.8,0];
hole2 = [66.04, 35.56, 0];
hole3 = [66.04, 7.62, 0];
hole4 = [13.97, 2.54, 0];

topEdge = 53.34;
backEdge = 68.58;
bottomEdge = 0;
frontEdge = 0;

boardThickness = 1.6;

// Box parameters:
bottomThickness = 3;
wallThickness = 7 * perimeterWidth;
sideClearance = 2;
mountingHoleDia = 3.5;
standoffHeight = 2.5;
standoffOD = mountingHoleDia + 2*0.4*3;
wallHeight = 10 + standoffHeight + bottomThickness;
sideOD_Z = 8;
sideOD_XY = 6;
sideID_Z = sideOD_Z - 2*wallThickness;
sideID_XY = sideOD_XY - 2*wallThickness;
echo("sideID_Z", sideID_Z);
echo("sideID_XY", sideID_XY);

pwrConnWidth = 9;
pwrConnHeight = 11;
pwrConnCtrY = 7.62;
pwrConnSocketCtrZ = standoffHeight + boardThickness + 6.35;
pwrConnPlugDia = 12;
echo("pwrConnSocketCtrZ", pwrConnSocketCtrZ);

usbCtrY = topEdge - 15.5;
usbTypeAWidthY = 12.5;
usbTypeAHeightZ = 10.9;

usbMicroCtrZ = standoffHeight + boardThickness + 2.54/2;

usbTypeAX = -6.35;
powerConnectorX = -1.778;

pwrConnExtraY = 1.0;
pwrConnExtraZ = 0.5;

pwrConnOpeningYOffset = pwrConnCtrY - pwrConnWidth/2 - pwrConnExtraY;
pwrConnOpeningYWidth = pwrConnWidth + 2*pwrConnExtraY;
pwrConnOpeningZOffset = standoffHeight+boardThickness - pwrConnExtraZ;
pwrConnOpeningZHeight = pwrConnHeight + 2*pwrConnExtraZ;
echo("pwrConnOpeningZOffset", pwrConnOpeningZOffset);

usbConnExtraY = 1.0;
usbConnExtraZ = 0.5;

usbConnOpeningYOffset = usbCtrY - usbTypeAWidthY/2 - usbConnExtraY;
usbConnOpeningYWidth = usbTypeAWidthY + 2*usbConnExtraY;
usbConnOpeningZOffset = standoffHeight+boardThickness - usbConnExtraZ;
usbConnOpeningZHeight = usbTypeAHeightZ + 2*usbConnExtraZ;
echo("usbCtrY", usbCtrY);
echo("usbConnOpeningYOffset", usbConnOpeningYOffset);
echo("usbConnOpeningYWidth", usbConnOpeningYWidth);
echo("usbConnOpeningZHeight", usbConnOpeningZHeight);

corner1 = [-sideClearance, topEdge+sideClearance, 0];
corner2 = [backEdge+sideClearance, topEdge+sideClearance, 0];
corner3 = [backEdge+sideClearance, -sideClearance, 0];
corner4 = [-sideClearance, -sideClearance, 0];

module itemModule()
{
  difference()
  {
    union()
    {
      box();
      standoff(hole1);
      standoff(hole2);
      standoff(hole3);
      standoff(hole4);
    }
    hole(hole1);
    hole(hole2);
    hole(hole3);
    hole(hole4);

    //powerConnectorRound();
    powerConnectorSquare();

    usbTypeAConnector();
    //usbMicroConnector();
  }
}

module powerConnectorRound()
{
  translate([-10, pwrConnCtrY, pwrConnSocketCtrZ]) rotate(90, [0,1,0]) cylinder(d=pwrConnPlugDia, h=20);
}

module powerConnectorSquare()
{
  translate([-10, pwrConnOpeningYOffset, pwrConnOpeningZOffset]) cube([20, pwrConnOpeningYWidth, pwrConnOpeningZHeight]);
}

module usbMicroConnector()
{
  d = 10.5;
  offset = 12.8 - d;
  echo("usbMicroConnector offset", offset);
  translate([-10, usbCtrY, usbMicroCtrZ]) hull()
  {
    translate([0,  offset, 0]) rotate(90, [0,1,0]) cylinder(d=d, h=20);
    translate([0, -offset, 0]) rotate(90, [0,1,0]) cylinder(d=d, h=20);
  }
}

module usbTypeAConnector()
{
  translate([-10, usbConnOpeningYOffset, usbConnOpeningZOffset]) cube([20, usbConnOpeningYWidth, usbConnOpeningZHeight]);
}

module box()
{
  difference()
  {
    hull()
    {
      odxy = sideOD_XY * 1.25;
      roundedSheet(corner1, corner2, corner3, corner4,  sideOD_XY/2-bottomThickness, sideOD_Z, odxy);
      roundedSheet(corner1, corner2, corner3, corner4,  wallHeight+10, sideOD_Z, odxy);
    }
    tcu([-200, -200, -bottomThickness-400], 400);
    hull()
    {
      roundedSheet(corner1, corner2, corner3, corner4,  sideID_XY/2, sideID_Z, sideID_XY);
      roundedSheet(corner1, corner2, corner3, corner4, wallHeight+20, sideID_Z, sideID_XY);
    }
    translate([-10, -10, wallHeight-wallThickness/2]) cube([100, 100, 100]);
  }
  o1 = [0,0, wallHeight-wallThickness/2];
  translate(corner1+o1) qt();
  translate(corner2+o1) rotate(-90, [0,0,1]) qt();
  translate(corner3+o1) rotate(180, [0,0,1]) qt();
  translate(corner4+o1) rotate(90, [0,0,1]) qt();
  translate(corner1+o1+[0,sideOD_Z/2-wallThickness/2,0]) topEdge(backEdge+2*sideClearance);
  translate(corner2+o1+[sideOD_Z/2-wallThickness/2,0,0]) rotate(-90, [0,0,1]) topEdge(topEdge+2*sideClearance);
  translate(corner4+o1+[-sideOD_Z/2+wallThickness/2,0,0]) rotate(90, [0,0,1]) topEdge(topEdge+2*sideClearance);
  translate(corner4+o1+[0,-sideOD_Z/2+wallThickness/2,0]) topEdge(backEdge+2*sideClearance);
}

module topEdge(length)
{
  rotate(90, [0,1,0]) cylinder(d=wallThickness, h=length);
}

module qt()
{
  quarterTorus(radius=wallThickness/2, translation=sideOD_Z/2-wallThickness/2);
}

module quarterTorus(radius, translation)
{
  echo("radius, translation", radius, translation);
  difference()
  {
    rotate_extrude(convexity = 4)
      translate([translation, 0, 0])
        circle(r = radius);
    translate([0,-2*translation,-2*radius]) cube([4*translation, 4*translation, 4*radius]);
    translate([-2*translation,-4*translation,-2*radius]) cube([4*translation, 4*translation, 4*radius]);
  }
}

module roundedSheet(c1, c2, c3, c4, zOffset, zDia, xyDia)
{
  offset = [0,0,zOffset];
  translate(c1+offset) torus3(zDia, xyDia);
  translate(c2+offset) torus3(zDia, xyDia);
  translate(c3+offset) torus3(zDia, xyDia);
  translate(c4+offset) torus3(zDia, xyDia);
}

module hole(pos)
{
  offset = [0,0,-15];
  h = 30;
  translate(pos)
  {
    translate(offset)
      cylinder(d=mountingHoleDia, h=h);
    translate([0,0,-5-bottomThickness+mountingHoleDia/2+1.6])
      cylinder(d1=10, d2=0, h=5);
  }
}

module standoff(pos)
{
  offset = [0,0,0];
  translate(pos+offset) cylinder(d=standoffOD, h=standoffHeight);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
  // tc([hole1.x-d, -200, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}

firstLayerHeight = 0.2;
layerHeight = 0.2;

