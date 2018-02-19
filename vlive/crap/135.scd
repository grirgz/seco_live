(
Ndef(\grav,{

	var phasespacedim = 6; 
	var feedback = LocalIn.ar(phasespacedim);
	var r, phi;
	var rdot, rdotdot, phidot, phidotdot;
	var update = MouseX.kr*1;  //0 to 1

	rdotdot = ((-1/((feedback[0]).max(0.0001).squared)) + ((feedback[0]-(100*MouseY.kr))*((feedback[3]).squared)) + DC.ar(0)).fold(-10,10);
	phidotdot = (((-2)*(feedback[2])*(feedback[3]))/((feedback[0]).max(0.0001)) + DC.ar(0)).fold(-10,10);

	rdot = (((feedback[2]) + (update*rdotdot)) + Impulse.ar(0)).fold(-510,410);
	phidot = (((feedback[2]) + (update*(pi/10)*phidotdot)) + Impulse.ar(0)).fold(-pi,pi);

//initialise with single sample impulse
	r = (Impulse.ar(0)+ (feedback[0]) + (update*rdot)).fold(-100,100);
	phi = (DC.ar(0)+ (feedback[1]) + (update*(pi/100)*phidot)).fold(-pi,pi);

	LocalOut.ar([r,phi,rdot,phidot,rdotdot,phidotdot]);

	Pan2.ar(LeakDC.ar(((r * cos(phi)).poll)*0.01),0);

}).play.scope;
)
