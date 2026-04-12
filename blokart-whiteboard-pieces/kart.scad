include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

magnetRecessZ = 2.1;

frameWidthRear_inch = 28;
rearTrack_inch = frameWidthRear_inch + 2*13.4;

scaleXY = 40/rearTrack_inch;
echo(str("scaleXY = ", scaleXY));

wheelScaling = 1.4; // Make the wheels look better.
wheelWidth = 4.25*scaleXY*wheelScaling;
wheelLength = 14*scaleXY*wheelScaling;

wheelbase = 65*scaleXY;

frameWidthRear = frameWidthRear_inch*scaleXY;
frameWidthFront = 12*scaleXY; // est.
seatbackExtension = 9.5*scaleXY;
frameLength = wheelbase - wheelLength/2 + wheelWidth;

rearTrack = frameWidthRear + 2*13.4*scaleXY;
echo(str("rearTrack = ", rearTrack));

kartZ = max(firstLayerHeight + 15*layerHeight, firstLayerHeight+magnetRecessZ);
echo(str("kartZ = ", kartZ));

echo(str("wheelWidth = ", wheelWidth));

$fn = 128;

frameCylCZ = 1;

module kart()
{   
    difference()
    {
        union() 
        {  
            // Frame trapezoid:
            hull()
            {
                frameCornerDia = 4;
                fcd2 = frameCornerDia/2;
                doubleX() pieceCyl([frameWidthRear/2-fcd2, frameCylCZ, 0], d=frameCornerDia);
                doubleX() pieceCyl([frameWidthFront/2-fcd2, frameLength-fcd2, 0], d=frameCornerDia);

                doubleX() pieceCyl([frameWidthRear/2*0.85-fcd2, -seatbackExtension-fcd2, 0], d=frameCornerDia);
            }

            // Rear axle:
            rearAxleY = wheelLength/3;
            difference()
            {
                hull() doubleX() pieceCyl([rearTrack/2, 0, 0], d=4);
                doubleX() tcu([rearTrack/2, -200, -200], 400);
            }
            // hull() doubleX() pieceCyl([-rearTrack/2, 0, 0], d=4);

            // Rear wheels:
            doubleX() translate([rearTrack/2, 0, 0]) wheel();

            // Front wheel:
            translate([0, wheelbase, 0]) wheel();
        }

        // Magnet recesses:
        magnetRecess(y= 0, magnetDia=10.2);
        magnetRecess(y=35, magnetDia= 5.2);
    }
}

module magnetRecess(y, magnetDia)
{
    tcy([0, y, firstLayerHeight], d=magnetDia, h=100);
}

module wheel()
{
    hull() doubleY() pieceCyl([0, wheelLength/2-wheelWidth/2, 0], d=wheelWidth);
}

module pieceCyl(t, d)
{
    translate(t) simpleChamferedCylinder(d=d, h=kartZ, cz=frameCylCZ);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() kart();
}
else
{
	kart();
}
