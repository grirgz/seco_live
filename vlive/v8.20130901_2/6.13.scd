
//Ndef(~name+++\line1, { Line.kr(100,10000,32) });
//Ndef(~name+++\line2, { Line.kr(30,1000,64) });
//Ndef(~name+++\line2, { Line.kr(30,1000,32) * LFPulse.kr(1.5, 0, 0.9).range(0.8,1) });
//Ndef(~name+++\line2, { arg freq=800; freq * LFPulse.kr(1.5, 0, 0.9).range(0.8,1) });
Ndef(~name+++\line2, { arg freq=800; freq });
Ndef(~name+++\line2).put(1, \set -> Pbind(\freq, Pseq([400,800,1200,300],inf), \dur, 1));
Pdef(~name +++ \pre, Pbind(
	//\freq, Pstutter(4,Pseq([80,90],inf)),
	\freq, Ndef(~name+++\line2).bus.asMap,
	//\ffreq, Pstutter(4,Pseq([14480,1190],inf)),
	//\ffreq, Pstutter(2,Pseq([14480,1190],inf)),
	//\ffreq, Pn(Pseries(10,100,32*2)),
	//\ffreq, Ndef(~name+++\line1),
	\ffreq, 5000,
));
