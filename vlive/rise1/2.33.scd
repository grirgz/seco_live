
Ndef(~name+++\lfo1).quant=Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant=Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant=Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { arg freq; LFPulse.kr(freq * t).range(50,2500).lag(0.1)});
//Ndef(~name+++\lfo1).put(1, \set -> Pbind(
//	\freq, Pseq([8,8,16,4],inf),
//	\dur, 1/2,
//));
Ndef(~name+++\lfo1, { arg freq=800; freq.lag(0.101)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([8,2,14,2]*100,inf),
	\dur, PdurStutter(Pseq([1,2,4,8, 1,2,1,8],inf),Pseq([1/4],inf)),
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Ndef(~name+++\lfo2, { arg freq; SinOsc.kr(freq).range(0.01,0.02) + 0.2 });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	//\freq, Pseq([1,1,4,16,8,8,4,4],inf),
	\freq, Pseq([2,2],inf),
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg freq=800; freq.lag(1.001)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([8,2]*100,inf),
	\dur, 1,
));
