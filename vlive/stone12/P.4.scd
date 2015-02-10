
Ndef(~scratch1+++\speed, {
	var lag;
	var speed;
	lag = 0.1;
	speed = Duty.kr(1/2/~t, 0, Dseq([
		4,2,0,0, 0,0,0,0,
	],inf)/4).lag( Duty.kr(1/2/~t, 0, Dseq([
		0,2,0,1,
	],inf)));
	speed = SinOsc.ar(speed*4*~t).lag(0.1);
	speed;
});


// END
Ndef(~scratch1+++\speed).rate 
Ndef(~scratch1+++\speed).quant = 1/2
