package primevc.core.geom;

#if flash9
typedef Matrix2D = flash.geom.Matrix;
#elseif flash
typedef Matrix2D = flash.geom.Matrix;
#else
typedef Matrix2D = Dynamic;
#end