include <./config.scad>;

gripLength = 120;
rodLength = 180; // actual length is 120 as gripLength
gpsSize = 40;
thickness = 20; // pure height-difference
module basicCone(){
   cylinder(h=gripLength+rodLength,d2=0,d1=gpsSize*1.2,$fn=3);
   //translate([-5,-20,0]) rotate(30) cube(gpsSize);
}

module top(ledHole=false){

   difference(){
      translate([0,0,-gripLength]) basicCone();
      translate([0,0,-gripLength-thickness-0.1]) basicCone();
      translate([0,0,-gripLength/2-0.1]) cube(gripLength,center=true);
      translate([0,0,gripLength*1.5]) cube(gripLength,center=true);
   }
   linear_extrude(2) difference(){
      circle(d=gpsSize/1.48,$fn=3);
      circle(d=gpsSize/3.5,$fn=30);
   }
   
}
top();


module base(){
   difference(){
   rotate([0.6,-1.5,60]) translate([0,0,7.1]) rotate([0,-90,30]) difference(){
      translate([0,0,-gripLength]) basicCone();
      translate([0,0,-gripLength-thickness*3.5]) basicCone();
      translate([0,0,gripLength/2+0.1]) cube(gripLength,center=true);
      translate([0,0,gripLength*1.5]) cube(gripLength,center=true);
   }
   translate([-25,-1,-gpsSize]) cube([gpsSize*2,rodLength,gpsSize]);
   }
}
module corner_hole(laengePlatte,breitePlatte,abstandAussen,durchmesserSchraube){
   abstandMitteLoch = abstandAussen + durchmesserSchraube/2;
      translate([abstandMitteLoch,abstandMitteLoch]){
                //circle(d=durchmesserSchraube, $fn=30);
      }
      translate([breitePlatte - abstandMitteLoch, abstandMitteLoch]){
                //circle(d=durchmesserSchraube, $fn=30);
      }
      translate([breitePlatte - abstandMitteLoch,laengePlatte - abstandMitteLoch]){
                circle(d=durchmesserSchraube, $fn=30);
      }
      translate([abstandMitteLoch,laengePlatte - abstandMitteLoch]){
                circle(d=durchmesserSchraube, $fn=30);
      }
   
}


module gpsHoles(corner=true){
   antenna = 26;
   preciseGpsSize = 38;
   square(antenna, center=true);
   if(corner){
      translate([-preciseGpsSize/2,-preciseGpsSize/2,0 ]) corner_hole(preciseGpsSize,preciseGpsSize,0.5,4);
   }
}
//gpsHoles();

module espHole(){
   //difference()
   {
   //translate([-14,-11])  square([28, 28]);
   translate([10,-8]) square([13, 16]);
   circle(d=3);
   translate([34,0]) circle(d=3);
   translate([7,-10]) square([5, 5]);
   }
}


module baseBottom(){
   difference(){
      base();
      translate([-20,-1,5]) cube([gpsSize*2,rodLength,gpsSize]);
      translate([0,10,-7]) sphere(10);
      translate([-3.5,6.5,0]) cube(7);
      translate([-gpsSize/2,gripLength-gpsSize*2.3,2]) cube([gpsSize,gpsSize*3,10]);
      translate([0,gripLength-gpsSize/2.3,-2]) linear_extrude(10) gpsHoles();
      translate([0,gripLength-gpsSize*2,-2]) linear_extrude(10) rotate([0,180,-90]) espHole();
      
   }
   
}
//baseBottom();
module base_thin(){
   difference(){
   rotate([0.6,-1.5,60]) translate([0,0,7.1]) rotate([0,-90,30]) difference(){
      translate([0,0,-gripLength]) basicCone();
      translate([0,0,-gripLength-thickness*2]) basicCone();
      translate([0,0,gripLength/2+0.1]) cube(gripLength,center=true);
      translate([0,0,gripLength*1.5]) cube(gripLength,center=true);
   }
   translate([-25,-1,-gpsSize]) cube([gpsSize*2,rodLength,gpsSize]);
   }
}


module baseCover(){
   difference(){
      union(){
         difference(){
            base_thin();
            translate([-gpsSize/2,-gpsSize/2,-0.1]) cube([rodLength, rodLength,3]);
            translate([-gpsSize/2,-(gpsSize*2.3),2]) cube([gpsSize,gpsSize*3,5]);
         }
         difference(){ // rohr
            fitDiameter = gpsSize/3.5;
            translate([0,-4,9.1]) rotate([92,30,0]) cylinder(h=13,d2=fitDiameter,d1=fitDiameter,$fn=30,center=true);
         translate([0,-7,9.1]) rotate([92,30,0]) cylinder(h=20,d2=9,d1=9,$fn=30,center=true);
            
         }
         difference(){
            translate([0,0.7,8.5]) rotate([90,30,0]) cylinder(h=2,d2=20,d1=20,$fn=3,center=true);
            translate([0,0.7,9]) rotate([92,30,0]) cylinder(h=8,d2=10,d1=10,$fn=30,center=true);
         }
         difference(){ // bottom, power button
            translate([0,gripLength-1.5,14.1]) rotate([90,30,0]) cylinder(h=2,d2=40,d1=40,$fn=3,center=true);
            translate([0,gripLength,15]) rotate([92,30,0]) cylinder(h=8,d2=16,d1=16,$fn=30,center=true);
         }
      }
   }
   
}
//baseCover();