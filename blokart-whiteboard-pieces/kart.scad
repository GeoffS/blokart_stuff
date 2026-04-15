include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeBase_sm = false;
makeSail_sm = false;

magnetRecessZ = 2.1;

frameWidthRear_inch = 28;
rearTrack_inch = frameWidthRear_inch + 2*13.4;

scaleXY = 33/rearTrack_inch;
echo(str("scaleXY = ", scaleXY));

wheelScaling = 1.4; // Make the wheels look better.
wheelWidth = 4.25*scaleXY*wheelScaling;
wheelLength = 14*scaleXY*wheelScaling;

wheelbase = 65*scaleXY * 0.75;

frameWidthRear = frameWidthRear_inch*scaleXY;
frameWidthFront = 12*scaleXY; // est.
seatbackExtension = 9.5*scaleXY*0.75;
frameLength = wheelbase - wheelLength/2 + wheelWidth;

mastPosition = 28*scaleXY; // est.

rearTrack = frameWidthRear + 2*13.4*scaleXY*0.85;
echo(str("rearTrack = ", rearTrack));

kartZ = max(firstLayerHeight + 20*layerHeight, firstLayerHeight+magnetRecessZ);
echo(str("kartZ = ", kartZ));

echo(str("wheelWidth = ", wheelWidth));

$fn = 128;

frameCylCZ = 1;

module kart_small()
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
            rearAxleY = wheelLength/2.8;
            difference()
            {
                hull() doubleX() pieceCyl([rearTrack/2, 0, 0], d=rearAxleY);
                doubleX() tcu([rearTrack/2, -200, -200], 400);
            }

            // Rear wheels:
            doubleX() translate([rearTrack/2, 0, 0]) wheel();

            // Front wheel:
            translate([0, wheelbase*0.9, 0]) wheel();

            // Sail stops:
            doubleX() translate([8.3,0,0]) simpleChamferedCylinder(d=rearAxleY-2*frameCylCZ, h=kartZ+1.2, cz=2*firstLayerHeight);
        }

        // // Top-Down Magnet Recesses:
        // magnetRecessTop(y=0, magnetDia=10.2);
        // magnetRecessTop(y=frameLength-5.2, magnetDia= 5.2);

        // Bottom-Up Magnet Recesses:
        magnetRecessBottom(y=0, magnetDia=10.2);
        magnetRecessBottom(y=frameLength-5.2, magnetDia= 5.2);

        // Mast pivot hole:
        tcy([0, mastPosition, firstLayerHeight+2*layerHeight], d=2, h=100);
    }
}

module magnetRecessTop(y, magnetDia)
{
    tcy([0, y, firstLayerHeight], d=magnetDia, h=100);
}

module magnetRecessBottom(y, magnetDia)
{
    tcy([0, y, -100+magnetRecessZ], d=magnetDia, h=100);
}

module wheel()
{
    hull() doubleY() pieceCyl([0, wheelLength/2-wheelWidth/2, 0], d=wheelWidth);
}

module pieceCyl(t, d)
{
    translate(t) simpleChamferedCylinderDoubleEnded(d=d, h=kartZ, cz=frameCylCZ);
}


perimeterWidth = 0.42;
sailZ = firstLayerHeight + 9*layerHeight;
sailWidth = 4*perimeterWidth;

pivotHoleDia = 2.3;
pivorOD = pivotHoleDia + 4*perimeterWidth;

echo(str("sailZ = ", sailZ));
echo(str("pivorOD = ", pivorOD));

module sail_small(a=0)
{
    translate([0, mastPosition, 0])
    {
        rotate([0,0,a]) difference() 
        {
            union()
            {
                // Mast:
                hull()
                {
                    cylinder(d=pivorOD, h=sailZ);
                    tcy([0, -3.5, 0], d=sailWidth, h=sailZ);
                }
                // Sail:
                hull()
                {
                    cylinder(d=sailWidth, h=sailZ);
                    tcy([0, -mastPosition-6, 0], d=sailWidth, h=sailZ);
                }
            }
            
            // Hole for m2 mast pivot screw:
            tcy([0,0,-10], d=pivotHoleDia, h=100);
        }
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
    // tcu([0-d, -200, -10], 400);
}

if(developmentRender)
{
	display() kart_small();
    displayGhost() translate([0,0,kartZ]) sail_small(a=20);

    // display() sail_small();
    // displayGhost() translate([0,0,-kartZ]) kart_small();
}
else
{
	if(makeBase_sm) kart_small();
    if(makeSail_sm) sail_small();
}
