include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeBase_sm = false;
makeSail_sm = false;
makeBase_med_25mm = false;
makeBase_med_20mm = false;
makeSail_med = false;

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

kartZ = firstLayerHeight + 20*layerHeight;
echo(str("kartZ = ", kartZ));

echo(str("wheelWidth = ", wheelWidth));

$fn = 128;

frameCylCZ = 1;

scaleMedium = 2;

module kart_small()
{
    difference()
    {
        kartCore();
        
        // Bottom-Up Magnet Recess:
        magnetRecessBottom(y=7, magnetDia=10.4, magnetThickness=3.0);

        // Mast pivot hole:
        tcy([0, mastPosition, firstLayerHeight+2*layerHeight], d=2, h=100);
    }
}

module kart_medium_25mm()
{
    kart_medium_core()
    {
        magnetRecessBottom(y=8.5, magnetDia=25.2, magnetThickness=3.4);
    }
}

module kart_medium_20mm()
{
    kart_medium_core()
    {
        magnetRecessBottom(y=18, magnetDia=20.0, magnetThickness=3.2);
    }
}

module kart_medium_core()
{
    difference()
    {
        scale(scaleMedium) kartCore();
        
        // Bottom-Up Magnet Recesses:
        children();

        // Mast pivot hole:
        tcy([0, mastPosition*scaleMedium, 3], d=3, h=100);
    }
}

module kartCore()
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
    }
}

module magnetRecessBottom(y, magnetDia, magnetThickness)
{
    tcy([0, y, -100+magnetThickness], d=magnetDia, h=100);
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

module sail_small(a=0)
{
    pivotHoleDia = 2.3;

    difference()
    {
        sailCore(
            scale = 1,
            angle = a, 
            pivotOD = pivotHoleDia + 4*perimeterWidth,
            sailZ = firstLayerHeight + 9*layerHeight,
            sailWidth = 4*perimeterWidth)
        {
            // Hole for m2 mast pivot screw:
            tcy([0,0,-10], d=pivotHoleDia, h=100);
        }
            
        
    }
}

module sail_medium(a=0)
{
    pivotHoleDia = 3.4;

    sailCore(
            scale = scaleMedium,
            angle = a, 
            pivotOD = pivotHoleDia + 8*perimeterWidth,
            sailZ = firstLayerHeight + 13*layerHeight,
            sailWidth = 6*perimeterWidth)
    {
        // Hole for m3 mast pivot screw:
        tcy([0,0,-10], d=pivotHoleDia, h=100);
    }
}

module sailCore(scale, angle, pivotOD, sailZ, sailWidth)
{
    translate([0, mastPosition*scale, 0])
    {
        rotate([0,0,angle]) difference() 
        {
            union()
            {
                // Mast:
                hull()
                {
                    cylinder(d=pivotOD, h=sailZ);
                    tcy([0, -3.5*scale, 0], d=sailWidth, h=sailZ);
                }
                // Sail:
                hull()
                {
                    cylinder(d=sailWidth, h=sailZ);
                    tcy([0, (-mastPosition-6)*scale, 0], d=sailWidth, h=sailZ);
                }
            }

            // Subtractive bits:
            children();
        }
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
    // tcu([0-d, -200, -10], 400);
    // tcu([-400+d, -200, -10], 400);
}

if(developmentRender)
{
    display() kart_medium_20mm();
    displayGhost() translate([0,0,kartZ*scaleMedium]) sail_medium(a=20);
    translate([-80,0,0])
    {
        display() color("red") kart_medium_25mm();
        display() color("white") translate([0,0,kartZ*scaleMedium]) sail_medium(a=20);
    }
    translate([-140,0,0])
    {
        display() color("green") kart_small();
        display() color("white") translate([0,0,kartZ]) sail_small(a=20);
    }

	// display() kart_small();
    // displayGhost() translate([0,0,kartZ]) sail_small(a=20);

    // display() sail_small();
    // displayGhost() translate([0,0,-kartZ]) kart_small();
}
else
{
	if(makeBase_sm) kart_small();
    if(makeSail_sm) sail_small();
    if(makeBase_med_25mm) kart_medium_25mm();
    if(makeBase_med_20mm) kart_medium_20mm();
    if(makeSail_med) sail_medium();
}
