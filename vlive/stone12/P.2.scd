
Ndef(~scratch1+++\speed, {
	var lag;
	var speed;
	lag = 0.1;
	speed = Duty.kr(1/2/~t, 0, Dseq([
		1,1,2,8,
	],inf)/4).lag( Duty.kr(1/2/~t, 0, Dseq([
		1,2,0,0,
	],inf)));
	speed = SinOsc.ar(speed*4*~t).lag(0.1 * SinOsc.kr(1/14).range(1,4));
	speed;
});


// END
Ndef(~scratch1+++\speed).rate 
Ndef(~scratch1+++\speed).quant = 1/2
