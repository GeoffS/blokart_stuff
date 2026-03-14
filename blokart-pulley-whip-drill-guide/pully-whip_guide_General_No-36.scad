include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

jigBaseX = 71;
jigBaseY = 81;
jigBaseZ = 12.5;

jigBaseOpeningX = 57.3;
jigBaseOpeningY = 73.3;

jigRodSupportY = 54;

baseX = jigBaseX;
baseY = jigBaseY;
baseZ = 10;
baseCZ = 4.0;
baseCornerDia = 12;

jigBaseInsertZ = jigBaseZ + baseZ;
jigBaseInsertCZ = 1;

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
                doubleX() translate([baseX/2-9, 0, 0]) rotate([0,45,0]) tcu([0, -jigRodSupportY/2, -50], [100, jigRodSupportY, 100]);
            }

            // Insert into jig=opening:
            hull() doubleY() translate([0, insertOffsetY, -jigBaseZ]) simpleChamferedCylinderDoubleEnded(d=jigBaseOpeningX, h=jigBaseInsertZ, cz=jigBaseInsertCZ);
        }

        // Clearance for the carriage bolt heads:
        carriageBoltHeadDia = 30;
        doubleX() tcy([baseX/2+carriageBoltHeadDia/2-4, 0, -50], d=carriageBoltHeadDia, h=100);

        // Drill Guide Hole:
        tcy([0,0,-50], d=9.7, h=200);
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
