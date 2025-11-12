centerSquishX = 29/2;
centerSquishXFlat = 19/2; //17/2;
centerSquishY = 15;
centerSquishZ = 38;
centerSquishZFlat = 10;

tubeOD = 22.5;

csx2 = centerSquishX/2;
csy2 = centerSquishY/2;
csz2 = centerSquishZ/2;

csaXY = centerSquishX - centerSquishXFlat;

flareXY = 3.8;
flareZ = 4; //2.6;
fzf = centerSquishZFlat - flareZ;

centerSquishPoints = [
  [centerSquishXFlat,  csy2],
  [centerSquishX    ,  csy2-csaXY],
  [centerSquishX    , -csy2+csaXY],
  [centerSquishXFlat, -csy2],

  [-centerSquishXFlat, -csy2],
  [-centerSquishX    , -csy2+csaXY],
  [-centerSquishX    ,  csy2-csaXY],
  [-centerSquishXFlat,  csy2],
];

module steeringTubeInternal(steeringTubeZ, handleTubeOD=tubeOD, steeringTubeOD=tubeOD)
{
  centerSquishFlare(handleTubeOD);
  z0 = -handleTubeOD/2 - (centerSquishZ-centerSquishZFlat) - 1 + 6;
  z2 = -centerSquishZ-handleTubeOD/2 - 4;
  z1 = (z0 + z2)/2;
  hull()
  {
    squishedSection(-handleTubeOD/2-centerSquishZFlat-1+nothing, 1);

    translate([0,0,z0]) cylinder(d=steeringTubeOD+2, h=1);
    translate([0,0,z1]) scale([1.15, 1, 1]) cylinder(d=steeringTubeOD+2, h=1);
    translate([0,0,z2-1]) cylinder(d=steeringTubeOD, h=1);
  }
  translate([0,0,z2-50]) cylinder(d=steeringTubeOD, h=50);
}

module centerSquishFlare(handleTubeOD)
{
  centerSquish(-handleTubeOD/2, handleTubeOD/2, r=flareXY);
  hull()
  {
    centerSquish(-handleTubeOD/2, 1, r=flareXY);
    squishedSection(-handleTubeOD/2-flareZ-1, 1);
  }
  squishedSection(-handleTubeOD/2-flareZ-fzf, fzf);
}

module squishedSection(zo, z)
{
  rd = 2;
  centerSquish(zo, z, r=rd, d=-rd, f=[1.1,1.25]);
}

module centerSquish(zo, z, r=0, d=0, f=[1,1])
{
  //echo(str("centerSquishPoints = ", centerSquishPoints));
  points = [ for(p = centerSquishPoints) [ p[0]*f[0], p[1]*f[1] ] ];
  //echo(str("points = ", points));
  translate([0,0,zo])
    linear_extrude(height=z)
      offset(r=r) offset(delta=d) polygon(points);
}
