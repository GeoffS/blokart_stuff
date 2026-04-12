include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

frameWidthRear_inch = 28;
rearTrack_inch = frameWidthRear_inch + 2*13.4;

scaleXY = 40/rearTrack_inch;
echo(str("scaleXY = ", scaleXY));

wheelWidth = 4.25*scaleXY;
wheelLength = 14*scaleXY;

wheelbase = 65*scaleXY;

frameWidthRear = frameWidthRear_inch*scaleXY;
frameWidthFront = 12*scaleXY; // est.
seatbackExtension = 9.5*scaleXY;
frameLength = wheelbase - wheelLength/2 + wheelWidth;

rearTrack = frameWidthRear + 2*13.4*scaleXY;
echo(str("rearTrack = ", rearTrack));

kartZ = firstLayerHeight + 10*layerHeight;

echo(str("wheelWidth = ", wheelWidth));

$fn = 128;

frameCylCZ = 2*layerHeight;

module kart()
{   
    scale([1, 1, 1]) 
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
        hull() doubleX() pieceCyl([-rearTrack/2, 0, 0], d=wheelWidth);

        // Rear wheels:
        doubleX() translate([rearTrack/2, 0, 0]) wheel();

        // Front wheel:
        translate([0, wheelbase, 0]) wheel();
    }
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
