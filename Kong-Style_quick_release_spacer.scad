include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

pinDia = 5.5;
throatWidth = 17;

lineSlotWidth = 5;
lineSlotDepth = 8;

pinCylinderDia = pinDia + 6;

tw2 = throatWidth/2;

module itemModule()
{
	difference() 
	{
		union()
		{
			translate([0,0,-tw2]) simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);
		}

		// Pin:
		tcy([0,0,-50], d=pinDia, h=100);
		doubleZ() translate([0,0,tw2-pinDia/2-1]) cylinder(d2=20, d1=0, h=10);

		// Line slot:

	}
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
