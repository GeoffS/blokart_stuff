include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

magnetRecessZ = 2.1;

markZ = max(firstLayerHeight + 20*layerHeight, firstLayerHeight+magnetRecessZ);
echo(str("markZ = ", markZ));

markCZ = 1;

module big()
{
	simpleChamferedCylinderDoubleEnded(d=12, h=markZ, cz=markCZ);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() big();
}
else
{
	big();
}
