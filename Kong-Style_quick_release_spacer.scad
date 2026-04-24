include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

pinDia = 5.5;
throatWidth = 17;

lineSlotWidth = 5;
lineSlotDepth = 8;

pinCylinderDia = pinDia + 6;

throatTop = 11;

tw2 = throatWidth/2;
pd2 = pinDia/2;

$fn=180;

module itemModule()
{
	difference() 
	{
		union()
		{
			translate([0,0,-tw2]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);

			difference()
			{
				hull()
				{
					translate([-pinCylinderDia/2,0,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
					translate([-pinCylinderDia/2,4.5,0]) rotate([0,90,0]) simpleChamferedCylinderDoubleEnded(d=throatWidth, h=pinCylinderDia, cz=1);
				}
				tcu([-200,-400,-200], 400);
			}
		}

		// Trim the base:
		tcu([-200, throatTop, -200], 400);

		// Chamfer the base:`
		// MAGIC!!!
		//  --------------------------------------------------------------vvvv
		doubleX() translate([pinCylinderDia/2, throatTop, 0]) rotate([0,0,45]) tcu([-0.7,-50,-50], 100);

		// Pin:
		tcy([0,0,-50], d=pinDia, h=100);
		doubleZ() translate([0,0,tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);

		// Line slot:
		hull() lineSlotXform() tcy([0,0,-50], d=lineSlotWidth, h=100);
		// // Line slot chamfer:
		// hull() lineSlotXform() translate([0,0,pd2]) cylinder(d2=20, d1=0, h=10);
	}
}

module lineSlotXform()
{
	translate([0,lineSlotWidth*0.8,0]) rotate([0,90,0]) children(); //tcy([0,0,-50], d=lineSlotWidth, h=100);
	translate([0,-100,0]) rotate([0,90,0]) children(); //tcy([0,0,-50], d=lineSlotWidth, h=100);
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
	displayGhost() tcy([0,0,-20], d=pinDia-0.2, h=40);

	// Print orientation:
	// display() translate([-20,0,throatTop]) rotate([-90,0,0]) itemModule();
}
else
{
	rotate([-90,0,0]) itemModule();
}
