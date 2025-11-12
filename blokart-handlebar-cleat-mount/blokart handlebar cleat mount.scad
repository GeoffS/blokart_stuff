include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/torus.scad>
include <../../OpenSCAD_Lib/Hardware.scad>
include <blokart steering tube internal utilities.scad>

build_fa = 5;
build_fs = 0.2;
/* build_fa = 20;
build_fs = 1; */


makeTopHalf = false;
makeBottomHalf = false;
echo(str("makeTopHalf = ", makeTopHalf));
echo(str("makeBottomHalf = ", makeBottomHalf));
//makeUpperRightSupportEnforcer2 = false;

nothing = 0.01;
inch = 25.4;
layerThickness = 0.2;
perimeterWidth = 0.45;

cleatHeight = 20;
cleatWidthFB = 26 + 1; // Includes fairlead
cleatWidthLR = 47 + 0.5;
holeCtrToCleatBack = cleatWidthFB/2; //14;
holeCtrsLR = 27;

boltholeDia = UNC8_holeDia;
nutRecessDia = UNC8_nutRecessDia; // - 0.1; // Slightly tigher fit
nutRecessDepth = UNC8_nutRecessDepth + 0.2;

boltLengthShort = 50.3;
boltLengthLong = 55.5; //63;
lengthFromTopToNutShort = boltLengthShort - cleatHeight - nutRecessDepth;;
echo(str("lengthFromTopToNutLong = ", lengthFromTopToNutLong));
lengthFromTopToNutLong = boltLengthLong - cleatHeight - nutRecessDepth;;
echo(str("lengthFromTopToNutLong = ", lengthFromTopToNutLong));

handleAngle = 11;
barEndDia = 22.5;
steeringTubeDia = barEndDia;

mountOD = barEndDia + 6; //36;

md2 = mountOD/2 - 3; //mountOD - barEndDia - 0.2;
md = md2*2;
echo(str("md2 = ", md2));

steeringTubeZ = 75-md2;
handleExternalDia = mountOD-md;
echo(str("handleExternalDia = ", handleExternalDia));

cleatHoleCtrs = holeCtrsLR;
cleatHoleOD = UNC8_holeDia;
cleatHolesOffsetX = 19.5;
cleatHolesOffsetZ = 16.25;

handleX = cleatHolesOffsetX + cleatHoleCtrs + cleatHoleOD/2 + handleExternalDia/2 + 0;

echo(str("cleatHolesOffsetX = ", cleatHolesOffsetX));
echo(str("cleatHolesOffsetZ = ", cleatHolesOffsetZ));
echo(str("handleX = ", handleX));

barEndOffsetX = -8;
barEndOffsetY = 4.5;
barEndAngle = -10;
barCenterOffsetY = -2;

handleEndOffsetY = -sin(handleAngle) * handleX;
echo(str("handleEndOffsetY = ", handleEndOffsetY));

by = 5.2;
bz = 4;

y1 = barEndDia/2+by;
y2 = 39;

module fullExternal()
{
  difference()
  {
    minkowski()
    {
      //difference()
      union()
      {
        hull()
        {
          handleExternal();
          mirror([1,0,0]) handleExternal();
          //#barBendXform() translate([0.2,-1.0,0]) cheeseWheel(dc+9, 30, 100);

          dc = handleExternalDia + 4; // - 1.5;
          //#translate([0,4,0]) rotate(90, [0,1,0]) translate([0,0,0]) cheeseWheel(dc, 30, 100);
          translate([0,0,0]) rotate(90, [0,1,0]) translate([0,0,0]) cheeseWheel(dc, 30, 100);

          steeringTubeExternal();

          cleatBase();
          mirror([1,0,0])  cleatBase();
        }
      }
      sphere(d=md);
    }
  }
}

frontBoldHoleDia = M3_holeDia;
//frontBoltLen = 15.5; // m3x16
frontBoltLen = 19.5; // m3x20
frontBoltHeadRecessDia = M3_socketHeadRecesssDia;
frontBoltHeadRecessXoffset = -4.5; //M3_socketHeadRecessDepth;
frontBoltNutRecessDia = M3_nutRecessDia + 0.05;
frontBoltNutRecessXoffset = -3.5;
frontBoltsOD = 10;
frontBoltOffsetX = 10 - md2;
frontBoltOffsetY = tubeOD/2 + frontBoltHeadRecessDia/2 + 2.4;
frontBoltOffsetZ = -steeringTubeZ + 5.5;

module frontBoltBottomXform()
{
  mirror([0,1,0]) children();
}

module frontBoltsInternal()
{
  rotate(-90,[0,0,1])
  {
    frontBoltInternal();
    frontBoltBottomXform() frontBoltInternal();
  }
}

module frontBoltsGhost()
{
  rotate(-90,[0,0,1])
  {
    boltGhost();
    frontBoltBottomXform() boltGhost();
  }
}

offsetToEndOfSphere = frontBoltOffsetX+frontBoltsOD/2;
echo(str("offsetToEndOfSphere = ", offsetToEndOfSphere));
module frontBoltInternal()
{
  frontBoltXform()
  {
    // Hole for the threads:
    translate([0,0,-50]) cylinder(d=frontBoldHoleDia, h=100);
    // Recess for the socket-head:
    translate([0,0,-offsetToEndOfSphere-30+frontBoltHeadRecessXoffset])
      cylinder(d=frontBoltHeadRecessDia, h=30);
    // Recess for the nut:
    translate([0,0,offsetToEndOfSphere-frontBoltNutRecessXoffset])
      cylinder(d=frontBoltNutRecessDia, h=30, $fn=6);
  }
  //%boltGhost();
}

module boltGhost()
{
  frontBoltXform()
  {
    translate([0,0,-offsetToEndOfSphere+frontBoltHeadRecessXoffset])
    {
      // Head:
      translate([0,0,-3]) cylinder(d=5.3, h=3);
      // Threads:
      cylinder(d=3, h=frontBoltLen);
    }
  }
}

module frontBoltXform()
{
  offsetToEndOfSphere = frontBoltOffsetX+frontBoltsOD/2;
  echo(str("offsetToEndOfSphere = ", offsetToEndOfSphere));
  translate([ 0, frontBoltOffsetY, frontBoltOffsetZ])
      rotate(90, [0,1,0])
        children();
}

module fullMount()
{
  difference()
  {
    fullExternal();

    handleInternal();
    cleatHoles();
    mirror([1,0,0])
    {
      handleInternal();
      cleatHoles();
    }

    localizedSteeringTubeInternal();

    frontBoltsInternal();
  }
}

module localizedSteeringTubeInternal()
{
  difference()
  {
    translate([0,0,0]) steeringTubeInternal(steeringTubeZ);
  }
}

module steeringTubeExternal()
{
  difference()
  {
    yo1 = handleEndOffsetY - handleExternalDia/2;
    czo = steeringTubeZ - 1;
    cz = steeringTubeZ - czo; // + handleExternalDia/2;
    translate([0, 0, -cz-czo]) union()
    {
      cylinder(d=handleExternalDia, h=cz);
    }
  }
}

module handleInternal()
{
  barEndInternal();
  barBendInternal();
}

module cleatHoles()
{
  cleatTransform() translate([0,0,-50])
  {
    cylinder(d=cleatHoleOD, h=100);
    nutRecess(magicNutRecessOffsetLongZ);
    translate([27,0,0])
    {
      cylinder(d=cleatHoleOD, h=100);
      nutRecess(magicNutRecessOffsetShortZ);
    }
  }
}

magicNutRecessOffsetShortZ = mountOD/2+barEndOffsetY+2.4-lengthFromTopToNutShort;
magicNutRecessOffsetLongZ = mountOD/2+barEndOffsetY+2.4-lengthFromTopToNutLong;
module nutRecess(zo)
{
  translate([0,0,-50+zo]) UNC8_nutRecess(h=100);
}

module cleatBase()
{
  cleatBaseOD = 24.5;
  hed2 = handleExternalDia/2;

  difference()
  {
    cleatTransform() translate([0,0,barEndOffsetY]) hull()
    {
      h = 0.2;
      h1 = 1;
      yo1 = 0;
      yo2 = -1.8;
      zo = 3.2; // + 3;
      translate([0,yo1,zo])
      {
        cylinder(d=cleatBaseOD, h=h);
        translate([0,yo2,0]) cylinder(d=cleatBaseOD, h=h);
      }
      translate([cleatHoleCtrs,yo1,zo])
      {
        cylinder(d=cleatBaseOD, h=h);
        translate([0,yo2,0]) cylinder(d=cleatBaseOD, h=h);
      }
      // Make the thickness at the outside hole a bit more to
      // recess the end of the bolt:
      translate([cleatHoleCtrs,yo1,zo-2])
      {
        cylinder(d=cleatBaseOD, h=h);
        translate([0,yo2,0]) cylinder(d=cleatBaseOD, h=h);
      }
      //tc([0,-cleatBaseOD/2,-hed2], [27+cleatBaseOD/2, cleatBaseOD/2, handleExternalDia]);
    }
    tc([-400, -200, -200], 400);
  }
}

cleatAngle = 5;
module cleatTransform()
{
  translate([0, 0, -cleatHolesOffsetZ])
    rotate(cleatAngle, [0,1,0])
      rotate(-handleAngle, [0,0,1])
        translate([cleatHolesOffsetX,0,0])
          rotate(-90, [1,0,0])
          {
            children();
          }
}

module handleExternal()
{
  dx = -57;
  union()
  {
    translate([barEndOffsetX, barEndOffsetY, 0])
      rotate(-handleAngle, [0,0,1])
          translate([-dx,0,0])
            rotate(barEndAngle, [0,1,0])
              rotate(90, [0,1,0])
              {
                cylinder(d=handleExternalDia, h=0.1);
              }
  }
}

module barBendInternal()
{
  handleCenterDia = barEndDia + 3;
  handleCenterLen = barEndDia/2;
  hull()
  {
    translate([0,0.5,-0.5]) barBendXform() cylinder(d=handleCenterDia, h=handleCenterLen);
    translate([0,1.5,-1.2]) barBendXform() cylinder(d=handleCenterDia+1, h=handleCenterLen);
    //%translate([0,0.5,-0.5]) barBendXform() cylinder(d=handleCenterDia, h=handleCenterLen);
    barEndXform()
    {
      h = 8;
      zo = 8;
      d = barEndDia + 3.8;
      //#translate([0,0,zo])cylinder(d=d, h=h);
      dd = d - barEndDia;
      //translate([0,0,zo+h]) cylinder(d1=d, d2=barEndDia, h=dd/2);
      translate([0,0,zo+h]) cylinder(d=barEndDia, h=4);
    }
    difference()
    {
      localizedSteeringTubeInternal();
      tc([-200,-200,-400-barEndDia/2], 400);
    }
  }
}

module barEndInternal()
{
  /* translate([barEndOffsetX, barEndOffsetY, 0])
    rotate(-handleAngle, [0,0,1])
      translate([10,0,0])
        rotate(90, [0,1,0]) */
        barEndXform()
        {
          h = 8;
          zo = 8;
          d = barEndDia + 3.8;
          //translate([0,0,zo])cylinder(d=d, h=h);
          dd = d - barEndDia;
          //translate([0,0,zo+h]) cylinder(d1=d, d2=barEndDia, h=dd/2);
          translate([0,0,zo+h]) cylinder(d=barEndDia, h=200);
        }
}

module barEndXform()
{
  translate([barEndOffsetX, barEndOffsetY, 0])
    rotate(-handleAngle, [0,0,1])
      translate([10,0,0])
        rotate(90, [0,1,0])
          children();
}

module barBendXform()
{
  translate([-1,barCenterOffsetY,0])
    rotate(90, [0,1,0])
    {
      children();
    }
}

module barGhost()
{
  barEndGhost();
  mirror([1,0,0]) barEndGhost();
}

module barEndGhost()
{
  translate([barEndOffsetX, barEndOffsetY, 0])
    rotate(-handleAngle, [0,0,1])
      translate([10,0,0])
        rotate(90, [0,1,0])
        {
          cylinder(d=barEndDia, h=150);
        }
  barBendXform() cylinder(d=barEndDia, h=14);
}

yo = -5.5;
a = 7;
module topHalf()
{
  difference()
  {
    fullMount();
    rotate(a, [1,0,0]) tc([-200, yo-400, -200], 400);
  }
}

module bottomHalf()
{
  difference()
  {
    fullMount();
    rotate(a, [1,0,0]) tc([-200, yo, -200], 400);
  }
}

module Harken471CamCleat()
{
  ctrY = 7.47;
  magicYoffset = 1.35;
  handleEndOffsetY =26.7;
  cleatTransform() rotate(90,[1,0,0]) translate([27/2+0.13,handleEndOffsetY,12.85]) import("471.stl");
}

module topAndBottomSplit(s=1)
{
  //s = 1;
  translate([0, s/2,0]) topHalf();
  translate([0,-s/2,0]) bottomHalf();
}

module prettyRender()
{
  translate([0, 0, 0]) rotate(30, [0,0,1]) rotate(90-10, [1,0,0])
  {
    color("RoyalBlue") topAndBottomSplit(0.1);
    color("DarkGray")
    {
      Harken471CamCleat();
      mirror([1,0,0]) Harken471CamCleat();
    }
    color("Silver")
    {
      barGhost();
      rotate(-180, [1,0,0]) cylinder(d=barEndDia, h=400);
    }

    color("Gray")
    {
      frontBoltsGhost();
    }
  }
}

if(developmentRender)
{
  //prettyRender();

  difference()
  {
    union()
    {
      translate([0, -0.2, 0]) bottomHalf();
      translate([0,  0.2, 0]) topHalf();
    }

    // fullMount();
    //rotate(handleAngle, [0,0,1]) fullMount();
    //fullExternal();

    //topAndBottomSplit(0.1);

    clip();
  }

  //%frontBoltsGhost();

  /* %Harken471CamCleat();
  %mirror([1,0,0]) Harken471CamCleat(); */

  /* difference()
  {
    barGhost();
    //clip();
    translate([-200, -200, -0.1]) cube(400);
  } */

}
else
{
  if(makeTopHalf) translate([0,0,-yo]) rotate(90-a, [1,0,0]) topHalf();
  if(makeBottomHalf) translate([0,0,yo]) rotate(-90-a, [1,0,0]) bottomHalf();
}

module clip()
{
  // Test two-part print cut:
  //yo = -3.5;
  //a = 2;
  //a = atan(barEndOffsetY/steeringTubeZ);
  //echo(str("a = ", a));
  //rotate(a, [1,0,0]) tc([-200, yo, -200], 400);
  //rotate(a, [1,0,0]) tc([-200, yo-400, -200], 400);

  // Cut through cleat center:
  //cleatTransform() tc([-20, -400, -200], 400);

  // Cut across the front bolts:
  //translate([-200, -200, frontBoltOffsetZ-400]) cube(400);

  // Cut across the handle:
  //translate([-200, -200, 0]) cube(400);

  // Cut through right inside cleat screw-hole:
  //cleatTransform() tc([0,-200,-200], 400);

  // Cut through right outside cleat screw-hole:
  //cleatTransform() tc([27,-200,-200], 400);

  // Trim +X half:
  //translate([0, -200, -200]) cube(400);

  // Trim +Y half:
  //translate([-200, 0, -200]) cube(400);

  // Trim -Y half:
  //translate([-200, -400, -200]) cube(400);

  // Trim +Z half:
  //translate([-200, -200, 0]) cube(400);
}
