include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeTwo_mm_line_loop_spacer = false;
makeShackle_spacer_ziptie = false;
makeShackle_spacer_nubs = false;
makeSpacerDisk = false;

pinDia = 5.4;
pinThreadsDia = 5.9;
throatWidth = 17;

lineSlotWidth = 6;

tw2 = throatWidth/2;
pd2 = pinDia/2;

pinCylinderDia = 13;
echo(str("pinCylinderDia = ", pinCylinderDia));

spacerTopOffset = 18.0;
spacerTopCtrOffset = spacerTopOffset - tw2;
spacerTop = spacerTopOffset - 2;

echo(str("spacerTopCtrOffset = ", spacerTopCtrOffset));
echo(str("spacerTop = ", spacerTop));

$fn=180;


two_mm_line_loop_spacer_ZipTieOffsetY = 8.5;
		
module two_mm_line_loop_spacer()
{
	difference() 
	{
		union()
		{
			// THe body that fills the throat:
			difference()
			{
				hull()
				{
					translate([0, 2.5, -tw2]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);
					translate([-pinCylinderDia/2,spacerTopCtrOffset,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
				}
				// Trim below the pin:
				tcu([-200,-400-pinDia/2+0.5,-200], 400);
			}
		}

		// Trim the base:
		tcu([-200, spacerTop, -200], 400);

		// Chamfer the base:`
		// MAGIC!!!
		//  ------------------------------------------------------------------------vvvv
		doubleX() translate([pinCylinderDia/2, spacerTop, 0]) rotate([0,0,45]) tcu([-0.7,-50,-50], 100);

		// Slot:
		translate([0,0,-50]) hull()
		{
			tcy([0,  0,0], d=pinDia, h=100);
			tcy([0,-20,0], d=pinDia, h=100);
		}
		doubleZ() hull()
		{
			translate([0,   0, tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);
			translate([0, -20, tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);
		}

		// Line slot:
		hull() 
		{
			lineSlotWidth = 6;
			lineSlotUpperDia = 2;
			upperOffsetZ = lineSlotWidth/2 - lineSlotUpperDia/2;
			upperOffsetY = pinDia/2 - lineSlotUpperDia/2 + 1.2;
			translate([0,-10,0]) rotate([0,90,0]) tcy([0,0,-50], d=lineSlotWidth, h=100);
			doubleZ() translate([0, upperOffsetY, upperOffsetZ]) rotate([0,90,0]) tcy([0,0,-50], d=3, h=100);
		}

		// Hole for the zip-tie:
		zipTieTailDia = 3;
		zipTieHeadDia = 5;
		zipTieHeadRecessDepth = 5;
		translate([0, two_mm_line_loop_spacer_ZipTieOffsetY, 0]) rotate([0,90,0]) 
		{
			tcy([0,0,-50], d=zipTieTailDia, h=100);
			tcy([0,0,pinCylinderDia/2-zipTieHeadRecessDepth], d=zipTieHeadDia, h=20);
			doubleZ() translate([0, 0, pinCylinderDia/2-zipTieHeadDia/2-0.45]) cylinder(d2=20, d1=0, h=10);
		}
	}
}

shackle_spacer_ZipTieOffsetY = 10.5;

module shackle_spacer_nubs()
{
	shackle_spacer_core();

	shackleSideWidth = 6.5; //6.8;
	nubHeight = 0.6;
	numDia = 2;
	numbCtrOffsetY = 7.5;

	doubleX() doubleZ() translate([shackleSideWidth/2, numbCtrOffsetY, throatWidth/2-1]) simpleChamferedCylinder(d=numDia, h=nubHeight+1, cz=nubHeight);
}
		
module shackle_spacer_ziptie()
{
	difference()
	{
		shackle_spacer_core();

		// Hole for the zip-tie:
		zipTieTailDia = 3;
		zipTieHeadDia = 5;
		zipTieHeadRecessDepth = 5;

		translate([0, shackle_spacer_ZipTieOffsetY, 0]) rotate([0,90,0]) 
		{
			tcy([0,0,-50], d=zipTieTailDia, h=100);
			tcy([0,0,pinCylinderDia/2-zipTieHeadRecessDepth], d=zipTieHeadDia, h=20);
			doubleZ() translate([0, 0, pinCylinderDia/2-zipTieHeadDia/2-0.45]) cylinder(d2=20, d1=0, h=10);
		}
	}
}

module shackle_spacer_core()
{
	difference() 
	{
		union()
		{
			// THe body that fills the throat:
			difference()
			{
				hull()
				{
					translate([0, 2.5, -tw2]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);
					translate([-pinCylinderDia/2,spacerTopCtrOffset,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
				}
				// Trim below the pin:
				tcu([-200,-400-pinDia/2+0.5,-200], 400);
			}
		}

		// Trim the base:
		tcu([-200, spacerTop, -200], 400);

		// Chamfer the base:`
		// MAGIC!!!
		//  ------------------------------------------------------------------------vvvv
		doubleX() translate([pinCylinderDia/2, spacerTop, 0]) rotate([0,0,45]) tcu([-0.7,-50,-50], 100);

		// Slot:
		translate([0,0,-50]) hull()
		{
			tcy([0,  0,0], d=pinDia, h=100);
			tcy([0,-20,0], d=pinDia, h=100);
		}
		doubleZ() hull()
		{
			translate([0,   0, tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);
			translate([0, -20, tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);
		}

		// Shackle slot:
		hull() 
		{
			shackleSlotWidth = 8.3;
			shackleSlotUpperDia = 2;
			upperOffsetZ = shackleSlotWidth/2 - shackleSlotUpperDia/2;
			upperOffsetY = pinDia/2 - shackleSlotUpperDia/2 + 3.5;
			translate([0,-10,0]) rotate([0,90,0]) tcy([0,0,-50], d=shackleSlotWidth, h=100);
			doubleZ() translate([0, upperOffsetY, upperOffsetZ]) rotate([0,90,0]) tcy([0,0,-50], d=3, h=100);
		}

		// // Hole for the zip-tie:
		// zipTieTailDia = 3;
		// zipTieHeadDia = 5;
		// zipTieHeadRecessDepth = 5;
		// translate([0, shackle_spacer_ZipTieOffsetY, 0]) rotate([0,90,0]) 
		// {
		// 	tcy([0,0,-50], d=zipTieTailDia, h=100);
		// 	tcy([0,0,pinCylinderDia/2-zipTieHeadRecessDepth], d=zipTieHeadDia, h=20);
		// 	doubleZ() translate([0, 0, pinCylinderDia/2-zipTieHeadDia/2-0.45]) cylinder(d2=20, d1=0, h=10);
		// }
	}
}

diskOD = 14;
centerWidth = 5.5;
diskWidth = (throatWidth - centerWidth)/2;

module spacerDisk()
{
	difference()
	{
		simpleChamferedCylinderDoubleEnded(d=diskOD, h=diskWidth, cz=1);
		tcy([0,0,-50], d=pinThreadsDia, h=100);
	}
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
	// tcu([0,-200,-200], 400);
	// tcu([-200, two_mm_line_loop_spacer_ZipTieOffsetY, -200], 400);
}

if(developmentRender)
{
	// display() translate([-45,0,0]) spacerDisk();
	// display() translate([-30,0,0]) two_mm_line_loop_spacer();
	// display() shackle_spacer_ziptie();

	display() translate([-40, 0, 0]) shackle_spacer_ziptie();
	display() shackle_spacer_nubs();

	displayGhost() tcy([0,0,-20], d=pinDia-0.2, h=40);

	// Print orientation:
	// display() translate([-20,0,spacerTop]) rotate([-90,0,0]) two_mm_line_loop_spacer();
}
else
{
	if(makeSpacerDisk) spacerDisk();
	if(makeTwo_mm_line_loop_spacer) rotate([-90,0,0]) two_mm_line_loop_spacer();
	if(makeShackle_spacer_ziptie) rotate([-90,0,0]) shackle_spacer_ziptie();
	if(makeShackle_spacer_nubs) rotate([-90,0,0]) shackle_spacer_nubs();
}
