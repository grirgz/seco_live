
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var bufnum, pos, loop, trigger;
	var speed;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitch_stretch, dur, pan, clk;
	var igate, sustain, legato;
	var phase;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	dur = 1;
	legato = 0.5;
	sustain = legato * dur;
	igate = TDuty.kr(dur/~t, 0, Dseq([
		1,0,1,0,
	],inf))*sustain/~t;

	bufnum = BufDef(\scream);

	pos= 11.5;
	env1 = EnvGen.kr(Env([1,1.2,1,1.14],[0.4,0.8,0.5]), igate);
	env1 = LFNoise1.kr(1/2 * (1..3)).range(1,1.2);
	env1 = 1;
	phase = Phasor.ar(igate, Duty.kr(1/2/~t, 0, Dseq([
		1,-1,
	],inf)) * env1,[0,0.01,0.02]*0 + pos * s.sampleRate,BufFrames.kr(bufnum));
	sig = BufRd.ar(2, bufnum, phase);
	//sig = sig.collect( { arg isig, x;
	//	isig = LPF.ar(isig, 700 * (1+ x ));
	//});
	sig = HPF.ar(sig, 220);
	sig = BPF.ar(sig, [14000,7000,4000],0.1)*50;
	//sig = LPF.ar(sig, 12420);
	[1000,2300,5021,13000,17000].do { arg x, y;
		sig = BRF.ar(sig, x * SinOsc.kr(1/(1+y+5)).range(1.1,1));
	};
	sig = sig * 12;
	sig = sig * 1;
	
	sig = sig * EnvGen.ar(Env.adsr(1.1,0.4,0.41,2.4, curve:-4),Trig.kr(igate,igate),doneAction:0);
	
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})
)

// END

Ndef(~name+++\fx).clear
	BufDef.mono(\robinet, "field/robinet.wav");
