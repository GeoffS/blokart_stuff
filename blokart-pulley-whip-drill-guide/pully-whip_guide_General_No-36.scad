include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeBottom = false;
makeTop = false;

pulleyWhipOD = 22.4; // 7/8" nominal

jigBaseX = 71;
jigBaseY = 81.2 + 0.2;
jigBaseZ = 12.5;

jigBaseOpeningX = 57.3 + 0.5;
jigBaseOpeningY = 73.3;

jigRodSupportY = 54;
jigRodSupportUpperY = 41;

baseX = 85;
baseY = jigBaseY;
baseZ = 40; //10;
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

upperY = 40; //baseY - 2*baseCZ;
upperOD = pulleyWhipOD + 10;

module jigTop()
{
    difference() 
    {
        jig();
        tcu([-200,-200,pulleyWhipCtrZ-slotThickness/2-400], 400);
    }
}

module jigBottom()
{
    difference() 
    {
        jig();
        tcu([-200,-200,pulleyWhipCtrZ-slotThickness/2], 400);
    }
}

module jig()
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
                jigSupportCutouts();
            }

            // difference()
            // {
            //     dz = 15;
            //     hull()
            //     {
            //         // Concentric cylinder around the pulley whip hole:
            //         translate([0,0,pulleyWhipCtrZ]) rotate([-90,0,0]) translate([0,0,-upperY/2]) simpleChamferedCylinderDoubleEnded(d=upperOD, h=upperY, cz=5);
            //         // Additional cylinder to give a good print-surface contact:
            //         translate([0,0,pulleyWhipCtrZ+dz]) rotate([-90,0,0]) translate([0,0,-upperY/2]) rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded(d=upperOD, h=upperY, cz=5, $fn=8);
            //     }

            //     tcu([-200, -200, pulleyWhipCtrZ+dz+9.5], 400);
            // }

            // Insert into jig=opening:
            difference()
            {
                hull() doubleY() translate([0, insertOffsetY, -jigBaseZ]) simpleChamferedCylinderDoubleEnded(d=jigBaseOpeningX, h=jigBaseInsertZ, cz=jigBaseInsertCZ);

                // Notches for alignment bit in the jig opening:
                doubleX() tcy([jigBaseOpeningX/2, 0, -100], d=2, h=100);
                doubleY() tcy([0, jigBaseOpeningY/2, -100], d=2, h=100);
            }
        }

        // Clearance for the carriage bolt heads:
        caarriageBoltHeadsClearance();

        // Drill Guide Hole:
        tcy([0,0,-50], d=9.7, h=200);

        // Pulley-whip hole:
        pulleyWhipHole();

        pulleyWhipClampSlot();
    }
}

module jigSupportCutouts()
{
    doubleX() translate([jigBaseOpeningX/2, 0, 0]) rotate([0,45,0]) tcu([0, -jigRodSupportY/2, -1], [100, jigRodSupportY, 100]);
    doubleX() tcu([jigBaseX/2, -jigRodSupportUpperY/2, -50], [100, jigRodSupportUpperY, 100]);
}

module caarriageBoltHeadsClearance()
{
    carriageBoltHeadDia = 30;
    carriageBoltHeadSpacingX = 65;
    doubleX() tcy([carriageBoltHeadSpacingX/2-carriageBoltHeadDia/2+carriageBoltHeadDia, 0, -50], d=carriageBoltHeadDia, h=100);
}

module pulleyWhipHole()
{
    translate([0,0,pulleyWhipCtrZ]) hull()
    {
        rotate([-90,0,0]) tcy([0,0,-100], d=pulleyWhipOD, h=200);
        // f = cos(22.5);
        flatX = 9;
        tcu([-flatX/2, -100, -pulleyWhipOD/2], [flatX, 200, pulleyWhipOD/2]);
    }
}

slotThickness = 2;

module pulleyWhipClampSlot()
{
    tcu([0,-100,pulleyWhipCtrZ-slotThickness/2], [100,200,slotThickness]);
}

module clip(d=0)
{
	// tc([-200, -400-d, -50], 400);
    // tcu([-200, -200, -400+d], 400);
}

if(developmentRender)
{
	// display() jigBottom();
    // displayGhost() jigTop();
    
	displayGhost() jigBottom();
    display() jigTop();
}
else
{
	if(makeBottom) rotate([180,0,0]) jigBottom();
	if(makeTop) rotate([180,0,0]) jigTop();
}
