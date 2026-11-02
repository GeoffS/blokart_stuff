include <kart.scad>
use <marks.scad>

$fn=180;
developmentRender = false;

scale(1)
{
    color("brown") translate([0,0,-10-1]) cube([1000, 1000, 10], center=true);

    board(-70, -50);

    translate([0,100,0]) color("Fuchsia") big();

    stbd([120,  0, 0], 45, color="green");
    stbd([125, 40, 0], 45, color="red");
}

module stbd(t, a, color="gray")
{
    translate(t) rotate([0,0,a]) 
    {
        color(color)kart();
        color("white") translate([0,0,kartZ]) sail(a=-20);
    }
}

module board(dx, dy)
{
    x = 250;
    y = 180;
    z = 1;

    translate([x/2+dx, y/2+dy, -z]) 
    {
        color("white") hull()
        {
            doubleX() doubleY() tcy([x/2, y/2, 0], d=30, h=z);
            doubleX() doubleY() tcy([x/2, y/2, 0], d=30, h=z);
        }

        color("black") hull()
        {
            doubleX() doubleY() tcy([x/2, y/2, 0], d=36, h=z/2);
            doubleX() doubleY() tcy([x/2, y/2, 0], d=36, h=z/2);
        }
    }
}