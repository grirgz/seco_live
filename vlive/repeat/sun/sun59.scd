
////// sound design


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
				lfo1 = XLine.kr(1,4,20);
				sig = SinOsc.ar(freq * lfo1);
				sig1 = DelayL.ar(sig, 0.1, 0.01 * SinOsc.ar(41 * lfo1,mul:0.1, add:1)) + sig;
				sig2 = DelayL.ar(sig, 0.1, 0.0123 * SinOsc.ar(43 * lfo1,mul:0.1, add:1)) + sig;
				sig = [sig1,sig2];
				sig = sig * amp;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				//sig = Pan2.ar(sig, pan, amp);
				sig;
			}.asDefName,
			\freq, 150,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
				var num = 10;
				lfo1 = XLine.kr(1,rrand(2.0,8!num),rrand(20,30.0)!num) * LFNoise1.kr(1/12!num).range(1.0,2.1);
				sig = SinOsc.ar(freq * lfo1);
				sig1 = DelayL.ar(sig, 0.1, (rrand(0.01,0.02!num)) * SinOsc.ar(rrand(0.0,1!num)+41 * lfo1,mul:0.1, add:1)) + sig;
				//sig2 = DelayL.ar(sig, 0.1, 0.0123 * SinOsc.ar(43 * lfo1,mul:0.1, add:1)) + sig;
				sig = Splay.ar(sig1, \spread.kr(0.8), amp, pan);
				//sig = [sig1,sig2];
				//sig = sig * amp;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				//sig = Pan2.ar(sig, pan, amp);
				sig;
			}.asDefName,
			\freq, 150,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

FileSystemProject.load("capsule/draftsynth.scd");
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
				var num = 10;
				lfo1 = XLine.kr(1,rrand(2.0,8!num),rrand(20,30.0)!num) * LFNoise1.kr(1/12!num).range(1.0,2.1);
				sig = SinOsc.ar(freq * lfo1);
				sig1 = DelayL.ar(sig, 0.1, (rrand(0.01,0.02!num)) * SinOsc.ar(rrand(0.0,1!num)+41 * lfo1,mul:0.1, add:1)) + sig;
				//sig2 = DelayL.ar(sig, 0.1, 0.0123 * SinOsc.ar(43 * lfo1,mul:0.1, add:1)) + sig;
				sig = Splay.ar(sig1, \spread.kr(0.8), amp, pan);
				//sig = [sig1,sig2];
				//sig = sig * amp;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				//sig = Pan2.ar(sig, pan, amp);
				Out.ar(\out.kr(0), sig);
				//sig;
			}.asDefName,
			\freq, 150,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\ifx1,\audio),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\comp, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1352].value,
			\bufnum, ~buflib.kick[389].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sideinbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[132].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[806].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \whitenoise2line,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 8,
			\lpf, 16000,
			\hpf, 4000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\whitenoise2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = LPF.ar(sig, (\lpf.kr(7000) ).clip(20,20000));
	sig = HPF.ar(sig, (\hpf.kr(3000) ).clip(20,20000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\whitenoise2line, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = LPF.ar(sig, (\lpf.kr(7000) ).clip(20,20000));
	sig = HPF.ar(sig, (\hpf.kr(3000)  * XLine.kr(1,7.1,1) ).clip(20,20000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
