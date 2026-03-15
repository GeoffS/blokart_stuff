include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

pulleyWhipOD = 22.4; // 7/8" nominal

jigBaseX = 71;
jigBaseY = 81.2 + 0.5;
jigBaseZ = 12.5;

jigBaseOpeningX = 57.3 + 0.5;
jigBaseOpeningY = 73.3;

jigRodSupportY = 54;
jigRodSupportUpperY = 41;

baseX = 85;
baseY = jigBaseY;
baseZ = 10;
baseCZ = 4.0;
baseCornerDia = 12;

jigBaseInsertZ = jigBaseZ + baseZ;
jigBaseInsertCZ = 1;

pullyWhipHoleBottomZ = 9;
pulleyWhipCtrZ = pullyWhipHoleBottomZ+pulleyWhipOD/2;

baseCornerX = baseX/2 - baseCornerDia/2;
baseCornerY = baseY/2 - baseCornerDia/2;

insertOffsetY = (jigBaseOpeningY - jigBaseOpeningX)/2;
echo(str("insertOffsetY = ", insertOffsetY));

module itemModule()
{
    difference()
    {
        union()
        {
            difference()
            {
                // Base:
                hull() doubleX() doubleY() translate([baseCornerX, baseCornerY, 0]) simpleChamferedCylinderDoubleEnded(d=baseCornerDia, h=baseZ, cz=baseCZ);

                // Cut-away for the jig supports:
                doubleX() translate([jigBaseOpeningX/2, 0, 0]) rotate([0,45,0]) tcu([0, -jigRodSupportY/2, -1], [100, jigRodSupportY, 100]);
                doubleX() tcu([jigBaseX/2, -jigRodSupportUpperY/2, -50], [100, jigRodSupportUpperY, 100]);
            }

            // Insert into jig=opening:
            difference()
            {
                hull() doubleY() translate([0, insertOffsetY, -jigBaseZ]) simpleChamferedCylinderDoubleEnded(d=jigBaseOpeningX, h=jigBaseInsertZ, cz=jigBaseInsertCZ);

                // Notches for alignment bit in the jig opening:
                doubleX() tcy([jigBaseOpeningX/2, 0, -100], d=2, h=100);
                doubleY() tcy([0, jigBaseOpeningY/2, -100], d=2, h=100);
            }

            // // Upper section:
            // upperY = baseY - 2*baseCZ;
            // upperOD = pulleyWhipOD + 15;
            // hull()
            // {
            //     translate([0,0,pulleyWhipCtrZ]) rotate([-90,0,0]) tcy([0,0,-upperY/2], d=upperOD, h=upperY);
            // }
        }

        // Clearance for the carriage bolt heads:
        carriageBoltHeadDia = 30;
        carriageBoltHeadSpacingX = 65;
        doubleX() tcy([carriageBoltHeadSpacingX/2-carriageBoltHeadDia/2+carriageBoltHeadDia, 0, -50], d=carriageBoltHeadDia, h=100);

        // Drill Guide Hole:
        tcy([0,0,-50], d=9.7, h=200);

        // Pulley-whip hole:
        translate([0,0,pulleyWhipCtrZ]) rotate([-90,0,0]) tcy([0,0,-100], d=pulleyWhipOD, h=200);

        // Pulley-whip clamp slot:
        slotThickness = 2.5;
        tcu([0,-100,pulleyWhipCtrZ-slotThickness/2], [100,200,slotThickness]);
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -50], 400);
    // tcu([-200, -200, -400+d], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	rotate([180,0,0]) itemModule();
}
