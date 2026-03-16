include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

include <drillLocations.scad>

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
baseZ = 40;
baseCZ = 4.0;
baseCornerDia = 12;

jigBaseInsertZ = jigBaseZ + baseZ;
jigBaseInsertCZ = 1;

pullyWhipHoleBottomZ = 9;
pulleyWhipCtrZ = pullyWhipHoleBottomZ+pulleyWhipOD/2;

slotThickness = 2;

baseCornerX = baseX/2 - baseCornerDia/2;
baseCornerY = baseY/2 - baseCornerDia/2;

insertOffsetY = (jigBaseOpeningY - jigBaseOpeningX)/2;
echo(str("insertOffsetY = ", insertOffsetY));

upperY = 40;
upperOD = pulleyWhipOD + 10;

topBottomSplitOffsetZ = pulleyWhipCtrZ-slotThickness/2;
echo(str("topBottomSplitOffsetZ = ", topBottomSplitOffsetZ));

// m4 socket-head:
screwDia = 3.4;
screwHeadDia = 6.3;
screwNuteDia = 6.3;
screwThroughNutZ = 4;
screwZ = 20;

screwOffsetX = -22;
screwOffsetY = 22;

clampBoltX = 19;
clampBoltY = 0;

module jigTop()
{
    difference() 
    {
        jig();
        tcu([-200,-200,topBottomSplitOffsetZ-400], 400);
        tcu([0,-200,topBottomSplitOffsetZ-400+1], 400);
    }
}

module jigBottom()
{
    difference() 
    {
        jig();
        tcu([-200,-200,topBottomSplitOffsetZ], 400);
    }
}

effectiveScrewZ = screwZ - screwThroughNutZ;
echo(str("effectiveScrewZ = ", effectiveScrewZ));

screwHeadRecessZ = topBottomSplitOffsetZ+effectiveScrewZ/2;

module topToBottomScrews()
{
    nutRecessCutoutInInsetDia = 8;

    doubleY() translate([screwOffsetX, screwOffsetY, 0])
    {
        // Screw-hole all the way through:
        tcy([0, 0, -100], d=screwDia, h=200);

        // Nut Recess (bottom):
        tcy([0,0,topBottomSplitOffsetZ-200-effectiveScrewZ/2], d=screwNuteDia, h=200, $fn=6);
        // Taper to round to make nut installation easier:
        hull()
        {
            tcy([0,0,topBottomSplitOffsetZ-effectiveScrewZ/2-screwThroughNutZ], d=screwNuteDia, h=0.1, $fn=6);
            tcy([0,0,-0.1], d=nutRecessCutoutInInsetDia, h=0.1);
        }

        // Trim away the oval inset to reduce sharp corners and make printing easier:
        hull()
        {
            tcy([0,0,-200], d=nutRecessCutoutInInsetDia, h=200);
            // MAGIC!!!
            //  ---------vvv
            rotate([0,0,-35]) tcy([-6.5,0,-200], d=14, h=200);
        }

        // Screw-head recess (top):
        tcy([0,0,screwHeadRecessZ], d=screwHeadDia, h=200);
        translate([0,0,baseZ-screwHeadDia/2-1]) cylinder(d2=20, d1=0, h=10);
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
                baseCore();

                // Cut-away for the jig supports:
                jigSupportCutouts();
            }

            // Insert into jig=opening:
            difference()
            {
                hull() doubleY() translate([0, insertOffsetY, -jigBaseZ]) simpleChamferedCylinderDoubleEnded(d=jigBaseOpeningX, h=jigBaseInsertZ, cz=jigBaseInsertCZ);

                // Notches for alignment bit in the jig opening:
                doubleX() tcy([jigBaseOpeningX/2, 0, -100], d=2, h=100);
                doubleY() tcy([0, jigBaseOpeningY/2, -100], d=2, h=100);
            }
        }

        caarriageBoltHeadsClearance();

        drillGuideHole();

        pulleyWhipHole();

        pulleyWhipClampSlot();

        topToBottomScrews();

        clampScrewHoleAndRecess();
    }

    // Stop for the pulley-whip to locate the hole:
    difference()
    {
        intersection() 
        {
            translate([0,0,pulleyWhipCtrZ]) rotate([-90,0,0]) tcy([0,0,-200-plugScrewHoleDistanceFromEnd], d=pulleyWhipOD+2, h=200);
            baseCore();
        }
        tcu([-200, -200, pulleyWhipCtrZ], 400);
    }

    // Sacrificial layer at screw-head recesses:
    doubleY() translate([screwOffsetX, screwOffsetY, screwHeadRecessZ-layerHeight]) tcy([0,0,0], d=4, h=layerHeight);
}

module baseCore()
{
     hull() doubleX() doubleY() translate([baseCornerX, baseCornerY, 0]) simpleChamferedCylinderDoubleEnded(d=baseCornerDia, h=baseZ, cz=baseCZ);
}

module drillGuideHole()
{
    drilOD = 9.7;
    // Hole for drill bit:
    tcy([0,0,pulleyWhipCtrZ], d=drilOD, h=200);
    // Top chamfer:
    translate([0,0,baseZ-drilOD/2-1]) cylinder(d2=30, d1=0, h=15);
}

module clampScrewHoleAndRecess()
{
    clampBoltHoleDia = 6.6;
    translate([clampBoltX, clampBoltY, 0])
    {
        // Through hole:
        tcy([0, 0,-100], d=clampBoltHoleDia, h=200);

        // Carriage bolt head recess:
        clampBoltHeadRecessDia = 15;
        clampBoltHeadRecessZ = 4;
        translate([0,0,-jigBaseZ+clampBoltHeadRecessZ])
        {
            // Recess for the round part of the head:
            tcy([0,0,-100], d=15, h=100);
            // Recess for the square-section:
            tcy([0,0,-20+5], d=6.7*sqrt(2), h=20, $fn=4);
        }
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

// Compensate for the fact that the bridge of material at the top of the pulley-while hole will sag down a bit.
pulleyWhipHoileBridgeSayCompensationZ = 0.2;

module pulleyWhipHole()
{
    translate([0,0,pulleyWhipCtrZ]) hull()
    {
        rotate([-90,0,0]) tcy([0,0,-100], d=pulleyWhipOD, h=200);
        // f = cos(22.5);
        flatX = 9;
        tcu([-flatX/2, -100, -pulleyWhipOD/2-pulleyWhipHoileBridgeSayCompensationZ], [flatX, 200, pulleyWhipOD/2]);
    }
}

module pulleyWhipClampSlot()
{
    tcu([0,-100,pulleyWhipCtrZ-slotThickness/2], [100,200,slotThickness]);
}

module clip(d=0)
{
	tc([-200, -400-d, -50], 400);
    // tcu([-200, -200, -400+d], 400);

    // Screw holes along X:
    // tcu([screwOffsetX-400+d, -200, -200], 400);
    // Screw hole along X:
    // tcu([screwOffsetX-400+d, 0, -200], 400);
}

if(developmentRender)
{
    // display() jigBottom();

	display() jigBottom();
    display() jigTop();
    // displayGhost() screwGhost();
    // displayGhost() pulleyWhipGhost();
    displayGhost() clampBoltGhost();

	// display() jigBottom();
    // displayGhost() jigTop();
    
	// displayGhost() jigBottom();
    // display() jigTop();
}
else
{
	if(makeBottom) rotate([180,0,0]) jigBottom();
	if(makeTop) rotate([180,0,0]) jigTop();
}

module screwGhost()
{
    translate([screwOffsetX, screwOffsetY, topBottomSplitOffsetZ-screwZ+effectiveScrewZ/2]) cylinder(d=screwDia, h=screwZ);
}

module pulleyWhipGhost()
{
    translate([0,0,pulleyWhipCtrZ]) rotate([-90,0,0]) tcy([0,0,-100], d=pulleyWhipOD, h=200);
}

module clampBoltGhost()
{
    boltLength = 74;
    translate([clampBoltX, clampBoltY, 0])
    {
        // Bolt:
        tcy([0,0,-jigBaseZ], d=6.35, h=boltLength);
        // Wing-nut:
        tcy([0,0,baseZ], d=19, h=5);
    }
}