// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3

include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/torus.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

layerThickness = 0.2;
wallThickness = 0.42;

clockZ = 21.55;
clockX = 72.5;
clockY = 66.4;

clockXYCornerDia = 2 * 21;
clockZEdgeDia = 2 * 4.3;

clockFaceSplitZ = 7.6;

clockHolderWallThickness = 4 * wallThickness - 0.1; // 0.1? No idea, makes the slicer happy.
clockHolderXYCornerDia = clockXYCornerDia + 2*clockHolderWallThickness;
clockHolderZEdgeDia = clockZEdgeDia + 2*clockHolderWallThickness;
clockHolderCZ = 2;

echo(str("clockHolderWallThickness = ", clockHolderWallThickness));

cornerX = clockX - clockHolderXYCornerDia;
cornerY = clockY - clockHolderXYCornerDia;

module holderFace()
{
	difference()
	{
		//  Exterior:
		translate([0,0,clockFaceSplitZ]) hull() cornerXform() mirror([0,0,1]) simpleChamferedCylinder(d=clockHolderXYCornerDia, h=clockFaceSplitZ, cz=clockHolderCZ);

		// Interior:
		hull() 
		{
			insideLayer();
			translate([0,0,20]) insideLayer();
		}
	}
}

module cornerXform()
{
	doubleX() doubleY() translate([cornerX, cornerY, 0]) children();
}

module insideLayer()
{
	cornerXform() translate([0,0,clockHolderWallThickness+clockZEdgeDia/2]) torus3a(outsideDiameter=clockXYCornerDia, circleDiameter=clockZEdgeDia);
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() holderFace();
}
else
{
	holderFace();
}
