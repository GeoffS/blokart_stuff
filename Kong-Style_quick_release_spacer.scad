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
			simpleChamferedCylinderDoubleEnded(d=pinCylinderDia, h=throatWidth, cz=1);
		}

		// Pin:
		tcy([0,0,-10], d=pinDia, h=100);
		translate([0,0,tw2]) doubleZ() translate([0,0,tw2-pinDia/2-1]) cylinder(d1=0, d2=20, h=10);
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
