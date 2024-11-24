$fn=30;

/* [Global] */

// Render
Objects = "Box"; //  [Both, Box, Lid]



// Tolerance
gTol = 0.2;
// Wall Thickness
gWT = 1.6;
Border = 3;

baseShaftX = 80;
baseShaftY = 90;
baseBallsX = 120;
baseBallsY = 120;
baseUpperZ = 1.4;
baseLowerZ = 1.0;

baseBallsLowerY = 70;

holeD = 55;
holeOffset = 30;
holeOffset2 = 50;

screwRO = 14;
screwRI = 10;


TotalX = max(baseShaftX, baseBallsX);
TotalY = baseShaftY + baseBallsY;

 module regular_polygon(order, r=1){
 	angles=[ for (i = [0:order-1]) i*(360/order) ];
 	coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
 	polygon(coords);
 }

module circle_lattice(ipX, ipY, Spacing=10, Walls=1.2)  {
   intersection() {
      square([ipX,ipY]); 
      union() {
	    for (x=[-Spacing:Spacing:ipX+Spacing]) {
           for (y=[-Spacing:Spacing:ipY+Spacing]){
	          difference()  {
			     translate([x+Spacing/2, y+Spacing/2]) circle(r=Spacing*0.75);
			     translate([x+Spacing/2, y+Spacing/2]) circle(r=(Spacing*0.75)-Walls);
		      }
           }   // end for y        
	    }  // end for x
      } // End union
   }
}

module diamond_lattice(ipX, ipY, DSize, WSize)  {

    lOffset = DSize + WSize;

	difference()  {
		square([ipX, ipY]);
		for (x=[0:lOffset:ipX]) {
            for (y=[0:lOffset:ipY]){
  			   translate([x, y])  regular_polygon(4, r=DSize/2);
			   translate([x+lOffset/2, y+lOffset/2]) regular_polygon(4, r=DSize/2);
		    }
        }        
	}
}


module RCube(x,y,z,ipR=4) {
    translate([-x/2,-y/2,0]) hull(){
      translate([ipR,ipR,ipR]) sphere(ipR);
      translate([x-ipR,ipR,ipR]) sphere(ipR);
      translate([ipR,y-ipR,ipR]) sphere(ipR);
      translate([x-ipR,y-ipR,ipR]) sphere(ipR);
      translate([ipR,ipR,z-ipR]) sphere(ipR);
      translate([x-ipR,ipR,z-ipR]) sphere(ipR);
      translate([ipR,y-ipR,z-ipR]) sphere(ipR);
      translate([x-ipR,y-ipR,z-ipR]) sphere(ipR);
      }  
} 

module screw_hole(height)
{
    difference(){
            cylinder(h = height, r = screwRO);
            cylinder(h = height, r = screwRI);
    }
}

module under_plate()
{
    PlateZ = baseUpperZ - baseLowerZ;
    
    difference(){
        under_plate_base();
        translate([-baseBallsX/2,-TotalY/2,0]) cube([baseBallsX,baseBallsLowerY,100]);
    }

}


module under_plate_base()
{
    side_removal = ( baseBallsX - baseShaftX ) / 2;
       
    // Latice
    difference() {
        translate([-baseBallsX/2, -(baseBallsY + baseShaftY)/2, -baseUpperZ/2]) difference(){
            linear_extrude(height = baseUpperZ) circle_lattice(baseBallsX,baseBallsY + baseShaftY,16,2);
                
            translate([0,baseBallsY,0])cube([side_removal,baseShaftY,baseUpperZ]);
            translate([side_removal+baseShaftX,baseBallsY,0])cube([side_removal,baseShaftY,baseUpperZ]);
        }
        hull(){
            translate([0,-holeOffset,0])cylinder(h = baseUpperZ*2, r = holeD/2, center = true);
            translate([0,-holeOffset2,0])cylinder(h = baseUpperZ*2, r = holeD/2, center = true);
        }
    }

    
    // frame
    translate([0, -baseShaftY/2 ,0]) difference(){
        cube([baseBallsX, baseBallsY, baseUpperZ], center = true);
        cube([baseBallsX-Border, baseBallsY-Border, baseUpperZ], center = true); 
        translate([0,5,0])cube([baseShaftX, baseBallsY-Border*2, baseUpperZ], center = true);
    }
    translate([0, baseBallsY/2 ,0]) difference(){
        cube([baseShaftX, baseShaftY, baseUpperZ], center = true);
        translate([0,-Border/2,0])cube([baseShaftX-Border, baseShaftY, baseUpperZ], center = true); 
    }
    
    // frame of hole
    difference(){
        hull(){
            translate([0,-holeOffset,0])cylinder(h = baseUpperZ, r = holeD/2+Border, center = true);
            translate([0,-holeOffset2,0])cylinder(h = baseUpperZ, r = holeD/2+Border, center = true);
        }
        hull(){
            translate([0,-holeOffset,0])cylinder(h = baseUpperZ, r = holeD/2, center = true);
            translate([0,-holeOffset2,0])cylinder(h = baseUpperZ, r = holeD/2, center = true);
        }
    }
}

module ball_plate(){
    
    PlateZ = baseUpperZ - baseLowerZ;
    
     // Latice
    difference() {
        translate([-baseBallsX/2,-TotalY/2,0]) 
        union(){
            linear_extrude(height = PlateZ) circle_lattice(baseBallsX,baseBallsLowerY,18,2);
            
            // frame
            translate([baseBallsX/2,baseBallsLowerY/2,PlateZ/2])difference(){
                cube([baseBallsX, baseBallsLowerY, PlateZ],center=true);
                cube([baseBallsX-Border*2, baseBallsLowerY-Border*2, PlateZ],center=true); 
            }
        }
        translate([0,-holeOffset,0])cylinder(h = 100, r = holeD/2, center = true);
    }       
    
    difference(){
        translate([0,-holeOffset,PlateZ/2])cylinder(h = PlateZ, r = holeD/2+Border, center = true);
        translate([0,-holeOffset,PlateZ/2])cylinder(h = PlateZ, r = holeD/2, center = true);
        translate([0,-TotalY/2+holeD/2+baseBallsLowerY,PlateZ/2])cube([holeD*2,holeD,PlateZ],center=true);
    }
    

    
}


//under_plate();
//translate([0,0,15]) 
ball_plate();



