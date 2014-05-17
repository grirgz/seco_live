
(
Ndef(~name, {
	var mod;
	var seq;
	seq = Dseq([100,200],inf);
	mod = Demand.kr(Impulse.kr(10), 0, seq);
	SinOsc.ar(mod) * 0.3


}).play;
)

(
Ndef(~name, {
	var mod;
	var seq;
	var sig;
	seq = Dseq([100,200,300,500,1600],inf);
	mod = Demand.kr(Impulse.kr(XLine.kr(1,20,20)), 0, seq);
	sig = SinOsc.ar(mod) * 0.3;
	sig = sig ! 2;


}).play;
)
Ndef(~name).clear
(
Ndef(~name, {
	var mod;
	var seq;
	var sig;
	seq = Dseq([
		100,200,300,500,1600, 400,40,50,60,30,40,50,60,
		10,20,30,500,1600, 400,40,50,600,1030,40,50,60,
		1000,20,30,500,1600, 400,40,50,600,1030,40,50,60,
	],inf);
	mod = Demand.kr(Impulse.kr(SinOsc.kr(10.1).range(0.1,40)), 0, seq);
	mod = mod.lag(SinOsc.kr(0.021).exprange(0,0.5));
	sig = SinOsc.ar(mod) * 0.3;
	sig = sig ! 2;


}).play;
)
