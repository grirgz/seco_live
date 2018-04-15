
(
SynthDef(\klak, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([1261, 1110, 400], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1240/2,1410/2,131],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([1211/4,1450/4,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(PinkNoise.ar(0.1), 12500);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,120], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	sig = sig + sig4 / 1.2;
	sig = HPF.ar(sig, env2);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1,1,-6)), gate, doneAction:2);
	sig = sig + DelayC.ar(sig, 1, 1/[1,7,3,0.51]/10, mul:[0.1,0.3,0.4]);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\robotmove, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,2],[1.1,1.8],1), 1);

	sig1 = LFSaw.ar(freq * ( LFNoise1.kr(12) * 0.01 + 1 ));
	sig2 = LFNoise0.ar(freq) + WhiteNoise.ar;
	//sig2 = BPF.ar(sig2, [ freq, freq*3, freq*2, freq/2]*0.95, 0.1).mean*2;
	sig = sig1 + sig2;
	sig = BPF.ar(sig, [ freq, freq*3, freq*2, freq*4,freq/2]*0.95, 0.3 * env1).mean*2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \klak,
			\freq, 200,
			\sustain, 0.09,
			\dur, 1,
			\amp, 0.07,
		),
		Pbind(
			\instrument, \robotmove,
			\freq, 300,
			\lag,0.1,
			\legato, 0.5,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


////////////////////////////////



//////////////////////////
(
SynthDef(\perceuse, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(\freqenv.kr(Env.asr(0.4,1,1.3)), gate);
	freq = freq * [1,2,4,8] * LFNoise1.kr(1/3!4, mul:0.01, add:0.1 );
	freq = freq * ( env1+1);
	sig1 = Formant.ar(freq);
	sig2 = BPF.ar(WhiteNoise.ar, freq, 0.2)*10;
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	freqenv: XEnvSpec.asr
))).add;
);
