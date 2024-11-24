$fn=40;

WallCurve = 50;
Length = 73;

Opening = 50;
render_plunger = 1;

//"Left" or "Right"
PinappleOrientation = "Right";
Image = "Pinapple";  // Celtic or Pinapple


// Spike = 1.5
Spike = 1;

// Support screws
S1 = [0,0,13];
S2 =  [0,12,-5];
S3 =  [0,-12,-5];

TotalX = Length;
TotalY = WallCurve;

include <threads.scad>

module hallow_sphere(r, t){
    difference(){
        sphere(r);
        sphere(r-t);
    }
}

module wedge(t, spikes="none", walls="true"){
    ZF = 0.75; 
    R = 24/ZF; 


    intersection(){
        scale([2,1,ZF]) sphere(R);
        translate([0,0,WallCurve]) hallow_sphere(WallCurve,t);
    }
    

    translate([0, 0, 15]) scale([1.3,1,3]) rotate_extrude() translate([R-4, 0, 0]) circle(r = 2);

    
    if (spikes=="Full"){
        //Top row
//        translate([-4.6,15,10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
//        translate([-2.8,5,10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-2.8,-5,10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-4.6,-15,10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        
        //center row
//        translate([-5.8,20,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-2.6,10,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-1.6,0,0]) rotate([0,-90,0]) cylinder(h=9,r1=4.5,r2=Spike, $fn=6);
//        translate([-2.6,-10,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-5.8,-20,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);

        //Bottom row
//        translate([-4.6,15,-10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
//        translate([-2.8,5,-10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-2.8,-5,-10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
//        translate([-4.6,-15,-10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
    }

    
}

module shaft(){
    
    translate([33,0,0]) difference(){
        translate([0,0,14]) difference(){
           scale([1,1.5,1]) rotate([0,90,0]) cylinder(h=100, r=15);
           scale([1,1.5,1]) rotate([0,90,0]) cylinder(h=100, r=12);
           translate([0,0,50])cube([1000,1000,100], center=true);
        }
        rotate([0,-45,0])translate([0,0,30])cube([60,60,60], center=true);
    }
}


// Main area
   
difference(){
    union(){  
        shaft();
        // flattened ring
        difference() {
            scale([1,1,2.41]) hull(){
              translate([20,0,2]) rotate_extrude() translate([26, 0, 0]) circle(r = 2);
              translate([20,0,2]) rotate_extrude() translate([28, 0, 0]) circle(r = 2);
            }
            translate([0,0,54])cube([50,80,100], center=true);
        }
        translate([0,30,-1])scale([1,0.8,0.8])  wedge(4, spikes="Full");
        translate([0,-30,-1])scale([1,0.8,0.8]) wedge(4, spikes="Full"); 

    }
    
    translate([33,0,14]) scale([1,1.5,1]) rotate([0,90,0]) cylinder(h=100, r=12);
    
    // put a hole through it
    translate([20,0,0]) cylinder(h=50, r=Opening/2);
    // remove everything below 0 plane
    translate([0,0,-50])cube([1000,1000,100], center=true);
    translate([0,0,58])cube([60,15,100], center=true);
}

