

//Ndef(~name+++\lfo2, { XLine.kr(200,3000,4) });
//Ndef(~name+++\lfofreq, { Pulse.kr(2).range(200,300) });
Ndef(~name+++\lfofreq, { Pulse.kr(2).range(20,30) + LFSaw.ar(0.1).range(0,100)});
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\freq, Ndef(~name+++\lfofreq).bus.asMap,
	\attackTime, Pseq([0.01,0.1,0.5],inf),
	\fenvamount, Ndef(~name+++\lfo1, { SinOsc.kr(49).range(0.1,5) }),
	\fadsr, Pfunc { arg ev; 
		[Env.adsr(ev[\attackTime],0.0,1.0,0.2)]
	
	},
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.3,0.3,0.4,0.1) ],
	],inf),
	
	\dur, 1,
	\legato, 1,
	\gain, Pseq([2,0.1,1],inf),
	\cutoff, Ndef(~name+++\lfo2),

));
