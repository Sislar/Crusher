$fn=40;
TotalZ = 48;
WallCurve = 50;
Length = 73;
BottomAmount = 15;
BottomThichness = 5;

render_base = 0;
render_spinner = 0;
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

 module regular_polygon(order, r=1){
 	angles=[ for (i = [0:order-1]) i*(360/order) ];
 	coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
 	polygon(coords);
 }
 
module diamond_lattice(ipX, ipY, DSize, WSize)  {

    lOffset = DSize + WSize;

    intersection(){
        square([ipX, ipY]);
        for (x=[0:lOffset:ipX]) {
            for (y=[0:lOffset:ipY]){
               translate([x, y])  regular_polygon(4, r=DSize/2);
               translate([x+lOffset/2, y+lOffset/2]) regular_polygon(4, r=DSize/2);
            }
        }        
    }

}

module hallow_sphere(r, t){
    difference(){
        sphere(r);
        sphere(r-t);
    }
}

module wedge(t, lip = false, spikes="none"){
    ZF = 0.75; 
    R = TotalZ/2/ZF; 

    translate([t/2,0,0])  intersection(){
        scale([2,1,ZF]) sphere(R);
        translate([-WallCurve,0,0]) hallow_sphere(WallCurve,t);
    }
    
    if (lip){
        difference(){
            union(){
                scale([1,0.95,ZF])
                translate([-6.5,0,0])
                rotate([90,0,0]) rotate([0,270,0]) 
                rotate_extrude(angle = 180, convexity = 10)
                translate([R*0.8,0,0]) 
                polygon([[0,0],[5,1],[7,15],[4,15]], paths=[[0,1,2,3]]);
            }
            translate([-22,0,0])rotate([0,45,0]) cube([10,100,10], center = true);
        }
    }    
    
    if (spikes=="Full"){
        //Top row
        translate([-4.6,15,10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        translate([-2.8,5,10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-2.8,-5,10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-4.6,-15,10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        
        //center row
        translate([-5.8,20,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-2.6,10,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-1.6,0,0]) rotate([0,-90,0]) cylinder(h=9,r1=4.5,r2=Spike, $fn=6);
        translate([-2.6,-10,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-5.8,-20,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);

        //Bottom row
        translate([-4.6,15,-10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        translate([-2.8,5,-10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-2.8,-5,-10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-4.6,-15,-10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
    }
    
        if (spikes=="Offset"){
        //Top row
        translate([-5,15,10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        translate([-3,0,10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-5,-15,10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        
        //center row
        translate([-8,23,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-3,5,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-3,-5,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-8,-23,0]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);

        //Bottom row
        translate([-5,15,-10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
        translate([-3,0,-10]) rotate([0,-90,0]) cylinder(h=6,r1=3.5,r2=Spike, $fn=6);
        translate([-5,-15,-10]) rotate([0,-90,0]) cylinder(h=7,r1=3.5,r2=Spike, $fn=6);
    }
}

module bottom_plate() {
    intersection(){
        hull(){
            rotate([0,0,180]) wedge(5);
            translate([Length,0,0]) wedge(6);    
        }
        translate([30,0,BottomAmount/2-TotalZ/2]) cube([100,100,BottomAmount],center=true);
    }    
}

module base(){
    rotate([0,0,180]) wedge(5);
    
    translate([Length+2,0,0]) difference() {
        wedge(4,lip=true, spikes="Offset");
        if (Image == "Pinapple"){ 
          if (PinappleOrientation == "Left") {
            translate([-12,1,0])scale([1,1.25,1.5]) rotate([0,90,0])
            intersection() {
              rotate([0,0,180])linear_extrude(15) 
                import("pineapple_outline.svg", center=true);
              rotate([0,0,180])linear_extrude(15) 
                import("pineapple_interior.svg", center=true);  
            }
          }
          else{
            translate([-12,-0.8,0])scale([1,1.25,1.5]) rotate([0,90,0])
            intersection() {
              linear_extrude(15) import("pineapple_outline.svg", center=true);
              linear_extrude(15) import("pineapple_interior.svg", center=true);  
            }
          }
        }
        else{
          scale([1,0.33,0.33]) translate([-1.4,9,-10])rotate([-30,0,0]) 
            rotate([0,90,0]) linear_extrude(4)
                import("celticknot.svg", center=true); 
        }
    }
    translate([Length-1.2,0,0]) wedge(3,lip=false, spikes="Offset");

    difference(){
        bottom_plate();
        translate([0,0,BottomThichness]) scale([2,1,1]) bottom_plate();
        // add holes to bottom plate
        
       translate([10,-23,-TotalZ/2-5]) linear_extrude(20) diamond_lattice(55, 46, 10, 3);
    }
}

module ridged_wheel(ipR=10)
{
    difference(){
        union(){
            translate([0,0,-0.4]) cylinder(r1=4.7, r2=ipR, h=4.4);
            translate([0,0,4])cylinder(r=ipR, h =7);
        }
        for(i = [0 : 20 : 360]){
            translate([ipR*sin(i),ipR*cos(i),-1])cylinder(r=1, h =12);
        }
    }
}

// Main area

if (render_base == 1){
       
    difference(){
        union(){
            base();
            translate([2.6,0,0]) rotate([0,90,0]) cylinder(r=8,h=2.6);
        }

        translate([-10,0,0]) rotate([0,90,0]) cylinder(r=3.5,h=Length);
        translate([-1,0,0]) rotate([0,90,0]) linear_extrude(7) regular_polygon(6, r=6.8);
        translate([2,S1[1],S1[2]]) rotate([0,90,0]) cylinder(r1=4, r2=6, h=5);
        translate([2,S2[1],S2[2]]) rotate([0,90,0]) cylinder(r1=4, r2=6, h=5);
        translate([2,S3[1],S3[2]]) rotate([0,90,0]) cylinder(r1=4, r2=6, h=5); 
        translate([-3,S1[1],S1[2]]) rotate([0,90,0]) cylinder(r1=6, r2=4, h=5);
        translate([-3,S2[1],S2[2]]) rotate([0,90,0]) cylinder(r1=6, r2=4, h=5);
        translate([-3,S3[1],S3[2]]) rotate([0,90,0]) cylinder(r1=6, r2=4, h=5); 
        translate([TotalX/2,0,-TotalZ/2]) cube([TotalX, TotalY,4], center=true);
        }    
}    
   
if (render_spinner == 1){
    
    ShaftSizeR = 5.8;
    
    union() {
        // wheel plus shaft
        difference(){
            union() {
                rotate([0,90,0]) ridged_wheel(10.0);
                translate([-5,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR ,h=8);
            }
            // threads (diameter, threads per inch, length)
            translate([-5,0,0]) rotate([0,90,0]) english_thread (0.27, 20, 0.3);
        }
        
        // wheel lip/latch  -3 to -7
        difference(){
            union(){
                translate([-7,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+3,h=2.2);
                translate([-4.8,0,0]) rotate([0,90,0]) cylinder(r1=ShaftSizeR+3, r2=ShaftSizeR,h=1.8);
            }
            translate([-10,0,0]) rotate([0,90,0]) cylinder(r=3.3,h=10);
            translate([-10,0,0]) rotate([0,90,0]) cylinder(r=3.,h=5);
        }  
        
        // PART 2 of spinner
        
        // latching lip -1 to -4
        union() {
        difference(){
            translate([-4,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+4,h=3);
            translate([-4.1,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+0.6,h=4);
            translate([-4.1,0,0]) rotate([0,90,0]) cylinder(r1=ShaftSizeR+4, r2=ShaftSizeR+0.6 ,h=3);
        }  

        // latching extender
        difference(){
            translate([-7,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+5,h=6);
            translate([-7,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+3,h=6);
            translate([-7,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+3.6,h=5);
            translate([-1,S1[1],S1[2]]) rotate([0,-90,0]) cylinder(r=4,h=4);
            translate([-1,S2[1],S2[2]]) rotate([0,-90,0]) cylinder(r=4,h=4);
            translate([-1,S3[1],S3[2]]) rotate([0,-90,0]) cylinder(r=4,h=4);
        }     

        difference (){
            union(){
                // support screws
                translate([-1,S1[1],S1[2]]) rotate([0,-90,0]) difference() {
                   cylinder(r=6,h=6);
                    cylinder(r=2,h=6);
                    cylinder(r=4,h=4);
                }        
                translate([-1,S2[1],S2[2]]) rotate([0,-90,0]) difference() {
                    cylinder(r=6,h=6);
                    cylinder(r=2,h=6);
                    cylinder(r=4,h=4);
                }
                translate([-1,S3[1],S3[2]]) rotate([0,-90,0]) difference() {
                    cylinder(r=6,h=6);
                    cylinder(r=2,h=6);
                    cylinder(r=4,h=4);
                }    
            }
            translate([-7,0,0]) rotate([0,90,0]) cylinder(r=ShaftSizeR+3.4,h=5);
        }
        }
    }
}

if (render_plunger == 1){

    difference(){
        union(){
            scale([1,0.8,0.8]) wedge(4, spikes="Full");
            translate([-2.6,0,0]) rotate([0,90,0]) cylinder(r=14,h=8.8);
            translate([-2.6,S1[1],S1[2]]) rotate([0,90,0]) cylinder(r=5.1,h=8.8);
            translate([-2.6,S2[1],S2[2]]) rotate([0,90,0]) cylinder(r=5.1,h=8.8);
            translate([-2.6,S3[1],S3[2]]) rotate([0,90,0]) cylinder(r=5.1,h=8.8);
        }

        translate([-Length/2,0,0.2]) difference(){
            bottom_plate();
            translate([0,0,6]) bottom_plate(); 
        }
        
        hull(){
            translate([-1,0,0]) rotate([0,90,0]) cylinder(r=6.1,h=10);
            translate([-1,0,-20]) rotate([0,90,0]) cylinder(r=6.1,h=10);
        }
        
        // threads (diameter, threads per inch, length)
        translate([-3.8,S1[1],S1[2]]) rotate([0,90,0]) english_thread (0.14, 32, 0.42);
        translate([4.2,S1[1],S1[2]]) rotate([0,90,0]) cylinder(3,1,2.6);
        translate([-3.8,S2[1],S2[2]]) rotate([0,90,0]) english_thread (0.14, 32, 0.42);
        translate([4.2,S2[1],S2[2]]) rotate([0,90,0]) cylinder(3,1,2.6);
        translate([-3.8,S3[1],S3[2]]) rotate([0,90,0]) english_thread (0.14, 32, 0.42);
        translate([4.2,S3[1],S3[2]]) rotate([0,90,0]) cylinder(3,1,2.6);
    }
    
    difference(){
        translate([4.6,0,0]) rotate([0,90,0]) cylinder(r=8,h=1.6);
        hull(){
            translate([3,0, 0]) rotate([0,90,0]) cylinder(r=3.6,h=10);
            translate([3,0,-10]) rotate([0,90,0]) cylinder(r=3.6,h=10);
        }
    }
}