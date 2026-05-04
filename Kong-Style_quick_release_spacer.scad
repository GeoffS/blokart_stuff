include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeTwo_mm_line_loop_spacer = false;
makeShackle_spacer_ziptie = false;
makeShackle_spacer_nubs = false;
makeShackle_spacer_screw1 = false;
makeShackle_spacer_screw2 = false;
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
	difference()
	{
		shackle_spacer_core();

		// Slot to allow a bit of give:
		hull()
		{
			rotate([0,90,0]) tcy([0,0,-50], d=1, h=100);
			translate([0,spacerTop-5,0]) rotate([0,90,0]) tcy([0,0,-50], d=1, h=100);
		}
		// MAGIC!!!
		//  ---------vvvvv
		translate([0,3.665+1.2,0]) rotate([45,0,0]) cube([100, 5, 5], center=true);
	}
	
	shackleSideWidth = 7.5;
	nubHeight = 0.45;
	numDia = 2.2;
	numbCtrOffsetY = 7.5;

	// Nubs:
	cz = nubHeight + 0.1;
	doubleX() doubleZ() translate([shackleSideWidth/2, 5.3, throatWidth/2-1]) simpleChamferedCylinder(d=numDia, h=nubHeight+1, cz=cz);
	doubleX() doubleZ() translate([shackleSideWidth/2, 9.2, throatWidth/2-1]) simpleChamferedCylinder(d=numDia, h=nubHeight+1, cz=cz);
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
	}
}

screwCtrY = 11;

module shackle_spacer_screw1()
{
	difference()
	{
		shackle_spacer_screw();

		tcu([0, -200, -200], 400);
		translate([0,screwCtrY, 0]) rotate([0,90,0]) 
		{
			tcy([0,0,-50], d=3, h=100);
		}
	}
}

module shackle_spacer_screw2()
{
	// Chamfer for flat-head screw.
	fh = false;

	difference()
	{
		shackle_spacer_screw();

		tcu([-400, -200, -200], 400);
		translate([0,screwCtrY, 0]) rotate([0,90,0]) 
		{
			d = 3.4;
			tcy([0,0,-50], d=d, h=100);
			
			if(fh) translate([0,0,pinCylinderDia/2-d/2-d/2]) cylinder(d2=10, d1=0, h=5);
		}
	}
}

module shackle_spacer_screw()
{
	difference() 
	{
		union()
		{
			// Slightly wider than the throat.
			// We'll do a cut later to clear it.
			w = throatWidth + 2;

			// The body that fills the throat:
			difference()
			{
				hull()
				{
					f = cos(22.5); // Face diameter factor.
					translate([0, 2.5, -w/2]) rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia/f, h=w, cz=1, $fn=8);
					translate([-pinCylinderDia/2, spacerTopCtrOffset, 0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=w, h=pinCylinderDia, cz=1);
				}
				// Trim below the pin:
				tcu([-200,-400-pinDia/2+0.5,-200], 400);
			}
		}

		// Pin Slot:
		translate([0,0,-50]) hull()
		{
			tcy([0,  0,0], d=pinDia, h=100);
			tcy([0,-20,0], d=pinDia, h=100);
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

		// Shackle side cutouts:
		sideX = 7.4;
		doubleZ() translate([-sideX/2, -50, tw2]) cube([sideX, 100, 20]);

		// Trim for cylinder around the pin:
		pinTrimOffsetY = 5.0;
		doubleZ()
		{
			tcu([-100, -200+pinTrimOffsetY, tw2], 200);
			translate([0,pinTrimOffsetY,tw2+5]) rotate([0,90,0]) tcy([0,0,-50], d=10, h=100, $fn=4);
		}
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
	// tcu([-200, screwCtrY, -200], 400);
}

if(developmentRender)
{
	// display() translate([-45,0,0]) spacerDisk();
	// display() translate([-30,0,0]) two_mm_line_loop_spacer();
	// display() shackle_spacer_ziptie();

	// display() translate([-40, 0, 0]) shackle_spacer_ziptie();
	// display() shackle_spacer_nubs();

	// display() shackle_spacer_screw();

	display() shackle_spacer_screw1();
	display() shackle_spacer_screw2();

	displayGhost() tcy([0,0,-20], d=pinDia-0.2, h=40);
	doubleZ() displayGhost() tcy([0,0,tw2], d=11.9, h=sideZ);
	displayGhost() shackleBodyGhost();

	// Print orientation:
	// display() translate([-20,0,spacerTop]) rotate([-90,0,0]) two_mm_line_loop_spacer();
	// display() rotate([0,90,0]) shackle_spacer_screw2();
}
else
{
	if(makeSpacerDisk) spacerDisk();
	if(makeTwo_mm_line_loop_spacer) rotate([-90,0,0]) two_mm_line_loop_spacer();
	if(makeShackle_spacer_ziptie) rotate([-90,0,0]) shackle_spacer_ziptie();
	if(makeShackle_spacer_nubs) rotate([-90,0,0]) shackle_spacer_nubs();
	if(makeShackle_spacer_screw1) rotate([0,-90,0]) shackle_spacer_screw1();
	if(makeShackle_spacer_screw2) rotate([0,90,0]) shackle_spacer_screw2();
}

sideX = 6.82;
sideZ = 6.5;
module shackleBodyGhost()
{
	
	doubleZ() translate([-sideX/2, -4, throatWidth/2]) cube([sideX, 20, sideZ]);
}