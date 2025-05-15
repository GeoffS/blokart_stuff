// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3

include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/torus.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

layerThickness = 0.2;
wallThickness = 0.42;

clockX = 72.5-0.1;
clockY = 66.4-0.1;
clockZ = 21.55;

leftButtonX = 16.12 + 2.5;
middleButtonX = 35.38 + 1.6 - 0.3;
rightButtonX = 55 + 1.6 - 0.1;

buttonsY = 12.5 + 2.45;

leftButtonDia = 11;
middleButtonDia = leftButtonDia;
rightButtonDia = 13;

powerSwitchPosBottomY = 24.5 + 1.6 ;
powerSwitchPosTopY = 32.8 + 1.6;
powerSwitchPosZ = 5.3;

clockXYCornerDia = 2 * 21.5;
clockZEdgeDia = 2 * 4.3;


clockHolderWallThickness = 4 * wallThickness - 0.1; // 0.1? No idea, makes the slicer happy.
clockHolderFrontThickness = clockHolderWallThickness + 1.0;
clockFaceSplitZ = 5.6 + clockHolderFrontThickness;
clockHolderXYCornerDia = clockXYCornerDia + 2*clockHolderWallThickness;
clockHolderZEdgeDia = clockZEdgeDia + 2*clockHolderWallThickness;
clockHolderCZ = 2;
clockHolderX = clockX + 2*clockHolderWallThickness;

displayPosTopY = -22.5 + 0.8;
displayY = 29.5;
displayX = 59-1;
displayCtrX = 0;
displayCtrY = displayPosTopY + displayY/2;
displayCornerDia = 2*6.8;

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
			mainInside();

			// Raised center of clock front panel:
			intersection()
			{
				frontPanelCenterDia = 50;
				frontPanelCurveZ = clockHolderWallThickness + frontPanelCenterDia/2;
				difference()
				{
					union()
					{
						tsp([0, -8, frontPanelCurveZ], d=frontPanelCenterDia);
						doubleX() tsp([24, 0, frontPanelCurveZ], d=frontPanelCenterDia);
					}
					tcu([-200, -200, clockHolderFrontThickness], 400);
				}

				hull() mainInside(topZ=20, bottomZ=-20);
			}
		}

		// Front opening:
		button(leftButtonDia, leftButtonX);
		button(middleButtonDia, middleButtonX);
		button(rightButtonDia, rightButtonX);
		displayOpening();
		// Chamfer:
		hull()
		{
			cz = 1;
			displayOpening(z=cz-0.1, h=0.1);
			minkowski()
			{
				displayOpening(z=-0.1, h=0.1);
				cylinder(d=2*cz, h=nothing);
			}
		}
		

		// Power switch cutout:
		switchY = (powerSwitchPosTopY - powerSwitchPosBottomY);
		//tcu([0, bottomExteriorEdgeY - powerSwitchPosTopY, powerSwitchPosZ-1], [100, switchY, 20]);
	}
}

module displayOpening(z=-10, h=100)
{
	
	translate([displayCtrX, displayCtrY, 0])  hull()
	{
		extraXY = 2;
		doubleX() doubleY() tcy([displayX/2-displayCornerDia/2+extraXY, displayY/2-displayCornerDia/2+extraXY, z], d=displayCornerDia, h=h);
	} 
}

buttonPosY = bottomExteriorEdgeY - buttonsY;

module button(dia, x)
{
	translate([leftExteriorEdgeX + x, buttonPosY, 0]) 
	{
		d = dia + 2;
		translate([0,0,-10]) cylinder(d=d, h=100);
		translate([0,0,-25+d/2+1]) cylinder(d1=50, d2=0, h=25);
	}
}

module cornerXform()
{
	doubleX() doubleY() translate([cornerX, cornerY, 0]) children();
}

module mainInside(topZ=20, bottomZ=0)
{
	translate([0,0,bottomZ]) insideLayer();
	translate([0,0,topZ]) insideLayer();
}

module insideLayer()
{
	cornerXform() translate([0,0,clockHolderFrontThickness + clockZEdgeDia/2]) torus3a(outsideDiameter=clockXYCornerDia, circleDiameter=clockZEdgeDia);
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
	// tc([-400-d, -200, -10], 400);
	// tc([-200, -400-d+buttonPosY, -10], 400);
}

if(developmentRender)
{
	display() holderFace();
}
else
{
	holderFace();
}
