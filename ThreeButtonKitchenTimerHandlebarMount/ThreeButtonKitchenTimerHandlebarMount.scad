// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3

include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/torus.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

layerThickness = 0.2;
wallThickness = 0.42;

clockZ = 21.55;
clockX = 73.5;
clockY = 67.4;

leftButtonX = 16.12 + 2.5;
middleButtonX = 35.38 + 1.6;
rightButtonX = 55 + 1.6;

buttonsY = 12.5 + 2.45;

leftButtonDia = 11;
middleButtonDia = leftButtonDia;
rightButtonDia = 13;

powerSwitchPosBottomY = 24.5 + 1.6 ;
powerSwitchPosTopY = 32.8 + 1.6;
powerSwitchPosZ = 5.3;

clockXYCornerDia = 2 * 21;
clockZEdgeDia = 2 * 4.3;

clockFaceSplitZ = 7.6;

clockHolderWallThickness = 4 * wallThickness - 0.1; // 0.1? No idea, makes the slicer happy.
clockHolderXYCornerDia = clockXYCornerDia + 2*clockHolderWallThickness;
clockHolderZEdgeDia = clockZEdgeDia + 2*clockHolderWallThickness;
clockHolderCZ = 2;
clockHolderX = clockX + 2*clockHolderWallThickness;

displayPosTopY = -22.5;
displayY = 29.5;
displayX = 59;
displayCtrX = 0;
displayCtrY = displayPosTopY + displayY/2;
displayCornerDia = 2*6.4;

leftExteriorEdgeX = -(clockX/2 + clockHolderWallThickness);
bottomExteriorEdgeY = clockY/2 + clockHolderWallThickness;

echo(str("clockHolderWallThickness = ", clockHolderWallThickness));

cornerX = (clockX - clockXYCornerDia)/2;
cornerY = (clockY - clockXYCornerDia)/2;

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

		// Front opening:
		button(leftButtonDia, leftButtonX);
		button(middleButtonDia, middleButtonX);
		button(rightButtonDia, rightButtonX);
		displayOpening();

		// Power switch cutout:
		switchY = (powerSwitchPosTopY - powerSwitchPosBottomY);
		tcu([0, bottomExteriorEdgeY - powerSwitchPosTopY, powerSwitchPosZ-1], [100, switchY, 20]);
	}
}

module displayOpening()
{
	
	translate([displayCtrX, displayCtrY, 0])  hull()
	{
		extraXY = 2;
		doubleX() doubleY() tcy([displayX/2-displayCornerDia/2+extraXY, displayY/2-displayCornerDia/2+extraXY, -10], d=displayCornerDia, h=100);
	} 
}

module button(dia, x)
{
	translate([leftExteriorEdgeX + x, bottomExteriorEdgeY - buttonsY, -10]) cylinder(d=dia+4, h=100);
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
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() holderFace();
}
else
{
	holderFace();
}
