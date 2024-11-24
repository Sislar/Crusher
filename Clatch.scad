$fn=50;

module ridged_wheel(ipH=5, ipR=10)
{
    difference(){
        union(){
            translate([0,0,ipH*0.5])cylinder(r=ipR, h=ipH);
            translate([0,0,0]) cylinder(r1=ipR/2, r2=ipR, h=ipH*0.5);
        }
        for(i = [0 : 30 : 360]){
            translate([ipR*sin(i),ipR*cos(i),-1])cylinder(r=1, h =12);
        }
    }
}


cylinder(h=22, r=2.8);
translate([0,3.5,2]) cube([2.8,5,4], center=true);

translate([0,0,21]) ridged_wheel(5,5);