// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3

include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/torus.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

// makePlugWithStop = false;
// makePlugThrough = false;
makeSandingJig = false;

plugScrewHoleDistanceFromEnd = 13.8; //12.5;
pluScrewDrillBitDia = 2.5; //1.6; // 1/16" drill = #4 screw

springPinHoleDistanceFromEnd = 24.3;
springPinHoleBitDia = 9.3;

pulleyWhipOD = 22.4; // 7/8" nominal

module plugScrewGuideWithStop()
{
    topThickness = 3;
    plugScrewHoleZ = topThickness + plugScrewHoleDistanceFromEnd;

    difference()
    {
        simpleChamferedCylinderDoubleEnded(
            d = pulleyWhipOD + 16,
            h = 40,
            cz = 3
        );
    
        // Hole for the pulley whip:
        tcy([0,0,topThickness], d=pulleyWhipOD, h=200);

        // Plug drill hole:
        translate([0,0,plugScrewHoleZ])
            rotate([0,90,0])
                tcy([0,0,0], d=pluScrewDrillBitDia, h=50);
    }
}

module plugScrewGuideThrough()
{
    difference()
    {
        simpleChamferedCylinderDoubleEnded(
            d = pulleyWhipOD + 16,
            h = 40, //2*plugScrewHoleDistanceFromEnd,
            cz = 3
        );
    
        // Hole for the pulley whip:
        tcy([0,0,-1], d=pulleyWhipOD, h=200);

        // Plug drill hole:
        translate([0,0,plugScrewHoleDistanceFromEnd])
            rotate([0,90,0])
                tcy([0,0,0], d=pluScrewDrillBitDia, h=50);
    }
}

$fn=180;

wingNutBaseDia = 19;

jigZ = 60;
jigCZ = 3;
jigDia = 60;

flatDia = 10;
f = cos(22.5);
echo(str("f = ", f));

flatFaceOppositeDrillHolesOffsetX = jigDia/2 - flatDia/2*f + 6.5;
screwHoleOffsetX = flatFaceOppositeDrillHolesOffsetX + flatDia/2*f - jigCZ - wingNutBaseDia/2 - 1;
screwHoleOffsetZ = jigZ/2;

horizHoleTopWidthFactor = 0.37; //0.4;

module flatForDrilling()
{
    translate([flatFaceOppositeDrillHolesOffsetX, jigDia/2, screwHoleOffsetZ]) 
        doubleZ() translate([0, 0, screwHoleOffsetZ-flatDia/2*f]) rotate([90,0,0])
            rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded(d=flatDia, h=jigDia, cz=jigCZ, $fn=8);
}

module sandingJig()
{
    difference()
    {
        hull()
        {
            // Main body cylinder:
            simpleChamferedCylinder(
                d = jigDia,
                h = jigZ,
                cz = jigCZ
            );
            
            flatForDrilling();
        }
    
        // Hole for the pulley whip:
        tcy([0,0,-1], d=pulleyWhipOD, h=200);

        // Slot:
        slotThickness = 2.5;
        tcu([0, -slotThickness/2, -1], [100, slotThickness, 100]);

        // Clamp Screw:
        translate([screwHoleOffsetX, 0, screwHoleOffsetZ]) rotate([90,0,0])
        {
            // Through Hole:
            hull()
            {
                clampBoltHoleDia = 6.6;
                tcy([0,0,-100], d=clampBoltHoleDia, h=200);
                x = clampBoltHoleDia * horizHoleTopWidthFactor;
                echo(str("Clamp bolt hole x = ", x));
                tcu([-x/2,0,-100], [x, clampBoltHoleDia/2, 200]);
            }

            // Carriage bolt recess:
            tcy([0,0,-jigDia/2-20+5], d=6.7*sqrt(2), h=20, $fn=4);
        }

        // Plug drill hole:
        translate([0,0,plugScrewHoleDistanceFromEnd])
            rotate([0,0,-90])
                rotate([90,0,0]) hull()
                {
                    tcy([0,0,0], d=pluScrewDrillBitDia, h=50);
                    x = pluScrewDrillBitDia * horizHoleTopWidthFactor;
                    echo(str("Screw hole x = ", x));
                    tcu([-x/2,0,0], [x, pluScrewDrillBitDia/2, 50]);
                }

        // Spring-ping drill hole:
        translate([0,0,springPinHoleDistanceFromEnd])
            rotate([0,0,-90])
                rotate([90,0,0]) hull()
                {
                    tcy([0,0,0], d=springPinHoleBitDia, h=50);
                    x = springPinHoleBitDia * horizHoleTopWidthFactor;
                    echo(str("Spring-pin hole x = ", x));
                    tcu([-x/2,0,0], [x, springPinHoleBitDia/2, 50]);
                }
    }
}


module roundedCylinder(d, cz, h)
{
    echo(str("roundedCylinder = ", d));
    cylinder(d=d, h=h-cz/2);
    translate([0,0,h-cz/2]) 
        torus3(
            outsideDiameter = d, 
            circleDiameter = cz
        );
}

module clip(d=0)
{
	// tc([-200, -400, -10], 400);
    // tc([20, -200, -200], 400);
}

if(developmentRender)
{
	display() sandingJig();
            
    // Bolt ghost:
    displayGhost() translate([screwHoleOffsetX, 0, screwHoleOffsetZ]) rotate([-90,0,0]) union()
    {
        // Bolt:
        tcy([0,0,-jigDia/2], d=6.35, h=74);
        // Wing-nut:
        tcy([0,0,jigDia/2], d=19, h=5);
    }
        
		// plugScrewGuideWithStop();
        // plugScrewGuideThrough();

        // union()
        // {
        //     translate([-60,0,0]) plugScrewGuideWithStop();
        //     sandingJig();
        //     translate([ 60,0,0]) plugScrewGuideThrough();
        // }

		// clip();
	// }
}
else
{
	// if(makePlugWithStop) plugScrewGuideWithStop();
    // if(makePlugThrough) plugScrewGuideThrough();
    if(makeSandingJig) sandingJig();
}
