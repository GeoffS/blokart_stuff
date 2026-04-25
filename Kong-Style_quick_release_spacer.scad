include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeOnePiece = false;
makeUspacer = false;
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

module uShapedSpacer()
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
					translate([0, 4, -tw2]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);
					translate([-pinCylinderDia/2,spacerTopCtrOffset,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
				}
				// Trim below the pin center:
				tcu([-200,-400,-200], 400);
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
		tcu([-20, -40-pinDia/2, -20], 40);

		// Line slot:
		hull() 
		{
			lineSlotWidth = 6;
			lineSlotUpperDia = 2;
			upperOffsetZ = lineSlotWidth/2 - lineSlotUpperDia/2;
			upperOffsetY = pinDia/2 - lineSlotUpperDia/2 + 3;
			translate([0,-10,0]) rotate([0,90,0]) tcy([0,0,-50], d=lineSlotWidth, h=100);
			doubleZ() translate([0, upperOffsetY, upperOffsetZ]) rotate([0,90,0]) tcy([0,0,-50], d=3, h=100);
		}
	}
}

module onePieceSpacer()
{
	difference() 
	{
		union()
		{
			// The body around the pin:
			translate([0,0,-tw2]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);

			// THe body that fills the throat:
			difference()
			{
				hull()
				{
					translate([-pinCylinderDia/2,0,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
					translate([-pinCylinderDia/2,spacerTopCtrOffset,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
				}
				// Trim below the pin center:
				tcu([-200,-400,-200], 400);
			}
		}

		// Trim the base:
		tcu([-200, spacerTop, -200], 400);

		// Chamfer the base:`
		// MAGIC!!!
		//  ------------------------------------------------------------------------vvvv
		doubleX() translate([pinCylinderDia/2, spacerTop, 0]) rotate([0,0,45]) tcu([-0.7,-50,-50], 100);

		// Pin threads::
		mirror([0,0,1]) 
		{
			tcy([0,0,0], d=pinThreadsDia, h=100);
			translate([0,0,tw2-pinThreadsDia/2-1]) cylinder(d2=20, d1=0, h=10);
		}

		// Slot on one side of the spacer for installation:
		hull()
		{
			tcy([0,  0,0], d=pinDia, h=100);
			tcy([0,-20,0], d=pinDia, h=100);
		}
		hull()
		{
			translate([0,  0,tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);
			translate([0,-20,tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);
		}
		tcu([-20,-40-5.4,0], 40);

		// Line slot:
		hull() lineSlotXform() tcy([0,0,-50], d=lineSlotWidth, h=100);
	}
}

module lineSlotXform()
{
	translate([0,lineSlotWidth*0.8,0]) rotate([0,90,0]) children(); //tcy([0,0,-50], d=lineSlotWidth, h=100);
	translate([0,-100,0]) rotate([0,90,0]) children(); //tcy([0,0,-50], d=lineSlotWidth, h=100);
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
}

if(developmentRender)
{
	// display() translate([-30,0,0]) onePieceSpacer();
	// display() translate([-45,0,0]) spacerDisk();
	display() uShapedSpacer();

	displayGhost() tcy([0,0,-20], d=pinDia-0.2, h=40);

	// Print orientation:
	// display() translate([-20,0,spacerTop]) rotate([-90,0,0]) onePieceSpacer();
}
else
{
	if(makeOnePiece) rotate([-90,0,0]) onePieceSpacer();
	if(makeSpacerDisk) spacerDisk();
	if(makeUspacer) rotate([-90,0,0]) uShapedSpacer();
}
