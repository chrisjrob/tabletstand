// tabletstand.scad
// Tablet Stand
// 
// Copyright 2013 Christopher Roberts

// Global Parameters
w = 120; // Width
h = 180; // Height
d = 3;   // Depth
wd = 2;  // Wire diameter e.g. a wire coathanger
gap = 1.2; // gap between things that move
bw = w*0.5;
bh = h*0.5;

// Item to print
// 0 - Demo
// 1 - Base
// 2 - Stand
// 3 - Holder
item = 0; 

use <MCAD/boxes.scad>;

module holder() {

    // This is the holder that clips onto the stand

    difference() {

        // Things that exist
        union() {

        }

        // Things that don't exist
        union() {

        }
    
    }

}

module bracket() {

    // This is central part of the stand, 
    // that drops down to brace against the base

    union() {

        // Bracket
        translate( v = [0, d, d/2] ) {
            roundedBox( [bw -gap*2, bh -d*2 - gap*2, d], 5, true );
        }

        // Bracket hinge top half
        translate( v = [0, -bh/2 + d, d] ) {
            rotate( a = [0, 90, 0] ) {
                cylinder( h = bw/2 - gap*2, r = d, $fn = 100, center = true);
            }
        }

        // Bracket hinge bottom half
        translate( v = [-bw/4 + gap, -bh/2 +d, 0] ) {
            cube( [ bw/2 - gap*2, d*2, d ] );
        }

    }

}

module stand() {

    union() {

        difference() {

            // Things that exist
            union() {

                // Bracket hinge top half
                translate( v = [0, -bh/2 + d, d] ) {
                    rotate( a = [0, 90, 0] ) {
                        cylinder( h = bw, r = d, $fn = 100, center = true);
                    }
                }

                // Bracket hinge bottom half
                translate( v = [-bw/2, -bh/2, 0] ) {
                    cube( [ bw, d*2, d ] );
                }


            }

            // Things to cut away
            union() {

                // Cutaway centre of bracket hinge
                translate( v = [-bw/4, -bh/2, 0] ) {
                    cube( [ bw/2, d*2, d*2 ] );
                }

                // Bracket Hinge Wire (deliberate duplicate)
                translate( v = [0, -bh/2+d, d] ) {
                    rotate( a = [0, 90, 0] ) {
                        # cylinder( h = w - (w-bw)/2, r = wd/2, $fn = 100, center = true);
                    }
                }

                
            }

        }

    }

    difference() {

        // Things that exist
        union() {

            // Base
            translate( v = [0, 0, d/2] ) roundedBox( [w, h, d], 5, true );

            // Central portion of hinge
            translate( v = [0, -h/2+d, d] ) {
                rotate( a = [0, 90, 0] ) {
                    cylinder( h = w/2, r = d, $fn = 100, center = true);
                }
            }


        }

        // Things to be cut out
        union() {

            // Bracket
            translate( v = [0, 0, d/2] ) {
                # roundedBox( [bw, bh, d], 5, true );
            }

            // Main Hinge Wire
            translate( v = [0, -h/2 + d, d] ) {
                rotate( a = [0, 90, 0] ) {
                    # cylinder( h = w, r = wd/2, $fn = 100, center = true);
                }
            }

            // Bracket Hinge Wire (deliberate duplicate)
            translate( v = [0, -bh/2+d, d] ) {
                rotate( a = [0, 90, 0] ) {
                    # cylinder( h = w - (w-bw)/2, r = wd/2, $fn = 100, center = true);
                }
            }

            // Remove side portions of hinge
            for (x = [-w/2-5, w/4] ) {
                translate( v = [x, -h/2-d, d*2] ) {
                    rotate( a = [0, 90, 0] ) {
                        cube( [d*3, d*3, w/4+5] );
                    }
                }
            }

            // Extra gap to help bracket hinge work smoothly
            translate( v = [-bw/4, -bh/2-gap, 0] ) {
                cube( [ bw/2, gap*2, d*2 ] );
            }


        }

    }

}

module base() {

    difference() {

        // Things that exist
        union() {
            // Base
            translate( v = [0, 0, d/2] ) roundedBox( [w, h, d], 5, true );

            // Hinge
            translate( v = [0, -h/2 + d, d] ) {
                rotate( a = [0, 90, 0] ) {
                    cylinder( h = w, r = d, $fn = 100, center = true);
                }
            }
        }

        // Things to be cut out
        union() {
            // Slots
            for ( y = [0 : h/2/5 : h/2 - h/2/5] ) {
                translate( v = [0, y, d/2] ) roundedBox( [w/2, h/2/10, d], 2, true );
            }

            // Base Wire
            translate( v = [0, -h/2 + d, d] ) {
                rotate( a = [0, 90, 0] ) {
                    # cylinder( h = w, r = wd/2, $fn = 100, center = true);
                }
            }

            // Remove central portion of hinge
            translate( v = [-w/4, -h/2-d, d*2] ) {
                rotate( a = [0, 90, 0] ) {
                    cube( [d*3, d*3, w/2] );
                }
            }

        }
    }

}


// Demo
if (item == 0) {

    translate( v = [0, 0, -d] ) {
        base();
    }

    translate( v = [0, -27, 63] ) {
        rotate( a = [-45, 180, 0] ) {
            stand();
        }
    }

    translate( v = [0, -15, 17] ) {
        rotate( a = [25, 180, 0] ) {
            bracket();
        }
    }

}

if (item == 1) {
    base();
}

if (item == 2) {
    stand();
    bracket();
}

if (item == 3) {
    holder();
}

// http://en.wikibooks.org/wiki/OpenSCAD_User_Manual

// primitives
// cube(size = [1,2,3], center = true);
// sphere( r = 10, $fn=100 );
// circle( r = 10 );
// cylinder( h = 10, r = 20, $fs = 6, center = true );
// cylinder( h = 10, r1 = 10, r2 = 20, $fs = 6, center = false );
// polyhedron(points = [ [x, y, z], ... ], triangles = [ [p1, p2, p3..], ... ], convexity = N);
// polygon(points = [ [x, y], ... ], paths = [ [p1, p2, p3..], ... ], convexity = N);

// transormations
// scale(v = [x, y, z]) { ... }
// rotate(a=[0,180,0]) { ... }
// translate(v = [x, y, z]) { ... }
// mirror([ 0, 1, 0 ]) { ... }

// rounded box by combining a cube and single cylinder
// $fn=50;
// minkowski() {
//   cube([10,10,1]);
//   cylinder(r=2,h=1);
// }

// hull() {
//   translate([15,10,0]) circle(10);
//   circle(10);
// }

// dxf_linear_extrude(file="tridentlogo.dxf", height = 1, center = false, convexity = 10);
// deprecated - import_dxf(file="design.dxf", layer="layername", origin = [100,100], scale = 0.5);
// linear_extrude(height = 10, center = true, convexity = 10, twist = 0, $fn = 100)
// rotate_extrude(convexity = 10, $fn = 100)
// import_stl("example012.stl", convexity = 5);

// for (z = [-1, 1] ) { ... } // two iterations, z = -1, z = 1
// for (z = [ 0 : 5 ] ) { ... } // range of interations step 1
// for (z = [ 0 : 2 : 5 ] ) { ... } // range of interations step 2

// for (i = [ [ 0, 0, 0 ], [...] ] ) { ... } // range of rotations or vectors
// usage say rotate($i) or translate($i)
// if ( x > y ) { ... } else { ... }
// assign (angle = i*360/20, distance = i*10, r = i*2)
