
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, velocity=0.5;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	
	var xfreq = [1/4,1/2,1,2,4];
	env1 = EnvGen.kr(Env([0,1,1],[0.2,0.8], [0]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[4.2,0.8], [0]), 1);
	sig = LFSaw.ar(freq * xfreq);
	sig = sig + Pulse.ar(freq * xfreq);
	sig = sig + (sig *  env2).tanh;
	sig = (sig * 5).wrap2(8.5 * env1 * env2)+sig;
	sig = RLPF.ar(sig, freq * 2  * env1 * env2 * SinOsc.kr([1,1.1,1.2]*8, Rand(0,2pi)).range(1,2), \rq.kr(0.5) / env2 / 2);
	sig = sig / 12;
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\brass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, velocity=0.5;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	
	var xfreq = [1/4,1/2,1,2,4];
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([0,1,1],[0.2,0.8], [0]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[4.2,0.8], [0]), 1);
	env3 = EnvGen.kr(Env([1,1,2,1],[0.7,4,0.8], [0]), 1);
	lfo1 = LFSaw.kr(4).range(1,env1);
	lfo2 = LFSaw.kr(8).range(1,env2);
	sig = LFSaw.ar(freq * xfreq);
	sig = LFSaw.ar(freq  ! 2 * lfo2);
	sig = sig * lfo2;
	sig = RLPF.ar(sig, freq * 2  * env1 * env2 * lfo1 , \rq.kr(0.5) / env2 / 2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\brass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, velocity=0.5;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	
	var xfreq = [1/4,1/2,1,2,4];
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ifreq;
	freq = freq * EnvGen.kr(Env([1,1.01,0.94,1],[0.2,0.2,0.2]), 1);
	ifreq  = freq * ( 1 + ( SinOsc.ar(freq) * 18 * (1..8) ));
	env1 = EnvGen.ar(Env.adsr(0.7,0.1,0.8,0.4),gate,doneAction:2);
	env2 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = LFSaw.ar(ifreq);
	sig = sig + ( LocalIn.ar(8) * 1.999 );
	//sig = (sig * 1).fold2(1.5);
	//sig = (sig * 2).wrap2(1);
	sig = (sig * SinOsc.kr((1..8)/14, {Rand(0,2pi)}!sig.size).range(0,414)).tanh;
	//sig = Pan2.ar(Pulse.ar(freq) + sig, sig  ).mean;
	//sig = FreqShift.ar(sig, 0.01 * ( env1 * 200 + 1 )) + sig;
	//sig = FreqShift.ar(sig, 0.4004) + sig;
	//sig = RLPF.ar(sig, freq * ( env2 + 1 ), \rq.kr(0.5) - (env1/4) );
	//sig = Pluck.ar(sig, 1, 0.1,1/freq);
	LocalOut.ar(DelayC.ar(sig, 0.1, ( 1/freq - ControlDur.ir ) * 1 *1));
	//sig = sig / 100;
	sig = sig / 2;
	sig = sig /4;
	sig = RLPF.ar(sig, freq * 2, \rq.kr(0.1)) + (LPF.ar(sig, 400)/4);
	sig = HPF.ar(sig, 80);
	//sig = Limiter.ar(sig);
	sig = sig * env1;
	sig.debug("siga");
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/10, { Rand(0,2) } ! sig.size) * 0.1, amp).flop;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\violin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, velocity=0.5, doneAction=2;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	
	var xfreq = [1/4,1/2,1,2,4];
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ifreq;
	sig = WhiteNoise.ar(1!2);
	sig = CombL.ar(sig, 0.1, 1/freq,1) + sig;
	sig = CombL.ar(sig, 0.1, 1/freq,0.2) + sig;
	//sig = CombL.ar(sig, 0.1, 1/freq,1) + sig;
	//sig = CombL.ar(sig, 0.1, 1/freq + [[1,2,3]*100],1) + sig;
	sig = RLPF.ar(sig, 9000, \rq.kr(0.5));
	sig = sig/10;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.8,0.4,0.31,0.3,1,4)), gate, doneAction:doneAction, timeScale:\timeScale.kr(1/2));
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.8,0.4,0.31,0.1,1,4)), Trig1.kr(\itrig.tr(1), 1), doneAction:0, timeScale:\timeScale.kr(1/2));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/10, { Rand(0,2) } ! sig.size) * 0.1, amp).flop;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\violin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, velocity=0.5, doneAction=2;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	
	var xfreq = [1/4,1/2,1,2,4];
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ifreq;
	sig = WhiteNoise.ar(1!2);
	sig = LFNoise1.ar(10000!4 * Rand(1/100,1) * Rand(1,1.1!4));
	sig = CombL.ar(sig, 0.1, 1/freq,1) + sig;
	sig = sig.wrap2(1.8)*1 + sig;
	sig = CombL.ar(sig, 0.1, 1/freq,0.2) + sig;
	//sig = CombL.ar(sig, 0.1, 1/freq,1) + sig;
	//sig = CombL.ar(sig, 0.1, 1/freq + [[1,2,3]*100],1) + sig;
	sig = RLPF.ar(sig, 9000, \rq.kr(0.5));
	sig = sig/10;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.8,0.4,0.31,0.9,1,4)), gate, doneAction:doneAction, timeScale:\timeScale.kr(1/2));
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.8,0.4,0.31,0.1,1,4)), Trig1.kr(\itrig.tr(1), 1), doneAction:0, timeScale:\timeScale.kr(1/2));
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)/10, { Rand(0,2) } ! sig.size) * 0.4, amp).flop;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\violin, Pmono(\violin,
	\degree, Pseq([0,2, 7,-4],inf),
	\octave, Prand([6],inf),
	\legato, 0.1,
	\itrig, 1,
	\timeScale, 1/4,
	//\lag, Ptuple([0,Pwhite(0,0.1,inf)]),
	\dur, 2,
	\amp, 0.1
)).play;
);

(
Pdef(\violin, Pbind(
	\instrument, \violin,
	\degree, Pseq([
		0,2, -3,-4,
		0,2, -3,-4,
	],inf) + [0,2,4],
	\octave, Prand([6],inf),
	\legato, 1/4,
	\lag, Ptuple([Pwhite(0,0.1,inf),0,Pwhite(0,0.1,inf)]),
	\dur, 4,
	\timeScale, Pkey(\dur),
	\amp, 0.1
)).play;
);

(
Pdef(\violin, Pbind(
	\instrument, \violin,
	\degree, [0,2b,4],
	\ctranspose, Pseq([
		-4,-5,-2,-4,
	],inf),
	\octave, Prand([5],inf),
	\legato, 1/4,
	\lag, Ptuple([Pwhite(0,0.1,inf),0,Pwhite(0,0.1,inf)]),
	\dur, 4,
	\timeScale, Pkey(\dur),
	\amp, 0.4
)).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \brass,
	\degree, Pseq([0,2,1,4, 7,3,-3,-4, -8,-1,5,1],inf),
	\octave, Prand([3,4,5,6],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);

(
Pdef(\kick, Pbind(
	\instrument, \dr_kick,
	\degree, Pseq([0],inf),
	\octave, 4,
	\dur, 1,
	\amp, 0.1
)).play;
);
Pdef.defaultQuant = 4

(
Ndef(\brr, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq);
	sig = 
	sig = RLPF.ar(sig, freq * 8, 0.1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);



/////////////////////////////////////



(
////////////////////////////////////////////////////////////////
// EPIC SAX GUY SynthDefs
// http://www.youtube.com/watch?v=KHy7DGLTt8g
// Not yet there... but hearable

// sounds more like a trumpet/horn after the failure and cheesyness of the stk sax
SynthDef(\sax, { |out, freq=440, amp=0.1, gate=1|
	var num = 16;
	var harms = Array.series(num, 1, 1) * Array.exprand(num, 0.995, 1.001);
	var snd = SinOsc.ar(freq * SinOsc.kr(Rand(2.0,5.0),0,Rand(0.001, 0.01),1) * harms, mul:Array.geom(num, 1, 0.63));
	snd = Splay.ar(snd);
	snd = BBandPass.ar(snd, freq * XLine.kr(0.1,4,0.01), 2);
	snd = snd * amp * EnvGen.ar(Env.adsr(0.001, 0.2, 0.7, 0.2), gate, doneAction:2);
	Out.ar(out, snd!2);
}).add;

// should be more like a gated synth, but this one gives the rhythmic element
// remember to pass the bps from the language tempo!
SynthDef(\lead, { |out, freq=440, amp=0.1, gate=1, bps=2|
    var snd;
    var seq = Demand.kr(Impulse.kr(bps*4), 0, Dseq(freq*[1,3,2], inf)).lag(0.01);
    snd = LFSaw.ar(freq*{rrand(0.995, 1.005)}!4);
    snd = Splay.ar(snd);
    snd = MoogFF.ar(snd, seq, 0.5);
    snd = snd * EnvGen.ar(Env.asr(0.01,1,0.01), gate, doneAction:2);
    OffsetOut.ar(out, snd * amp);
}).add;

// yep, an organ with a sub bass tone :D
SynthDef(\organ, { |out, freq=440, amp=0.1, gate=1|
    var snd;
    snd = Splay.ar(SinOsc.ar(freq*Array.geom(4,1,2), mul:1/4));
    snd = snd + SinOsc.ar(freq/2, mul:0.4)!2;
    snd = snd * EnvGen.ar(Env.asr(0.001,1,0.01), gate, doneAction:2);
    OffsetOut.ar(out, snd * amp);
}).add;

// from the synth def pool
SynthDef(\kick, { |out=0, amp=0.1, pan=0|
	var env0, env1, env1m, son;
	
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*1.5, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);
	
	OffsetOut.ar(out, Pan2.ar(son * amp));
}).add;

// full of fail:

//SynthDef(\sax, { |out, freq=440, amp=0.1, gate=1|
//	var r_stiff = 67;
//	var r_ap = 63;
//	var noise = 10;
//	var pos = 20;
//	var vibf = 20;
//	var vibg = 1;
//	var press = 85;
//	var snd = StkSaxofony.ar(freq, r_stiff, r_ap, noise, pos, vibf, vibg, press, 1, amp);
//	snd = snd * EnvGen.ar(Env.adsr(0.001, 0.2, 0.7, 0.2), gate, doneAction:2);
//	Out.ar(out, snd!2);
//}).add;


)

////////////////////////////////////////////////////////////////
// EPIC SAX GUY TUNE
// http://www.youtube.com/watch?v=KHy7DGLTt8g
// ... still needs a nice gated pad

(
TempoClock.default.tempo = 2.1;

Pdef(\kick).quant = 4;
Pdef(\organ).quant = 4;
Pdef(\sax).quant = 4;
Pdef(\lead).quant = 4;

////////////////////////////////////////////////////////////////
Pdef(\kick, Pbind(\instrument, \kick, \dur, 1, \amp, 1)).play;

Pdef(\organ, Pbind(
	\instrument, \organ,
	\octave, [3,4],
	\root, 3,
	\scale, Scale.minor,
	\degree, Pstutter(3, Pseq([0,-2,2,4], inf)),
	\amp, 0.3,
	\dur, Pseq([1.5,1.5,1], inf)
)).play;

Pdef(\lead, Pbind(
	\instrument, \lead,
	\octave, [5,6],
	\root, 3,
	\scale, Scale.minor,
	\degree, Pseq([0,2,0,4], inf),
	\amp, 0.2,
	\bps, TempoClock.default.tempo,
	\dur, 4
)).play;

// needs more articulation...
Pdef(\sax, Pbind(
	\instrument, \sax,
	\root, 3,
	\scale, Scale.minor,
	\octave, 5,
	\legato, 0.75,
	\amp, Pwhite(0.9,1.0, inf),
	\degree, Pseq([Pseq([Pn(4,4),3,4],2), Pseq([4,6,4,3,2,0,0,1,2,0])], inf),
	\dur, Pseq([Pseq([2,1/2,Pn(1/4,3),3/4],2), Pseq([1.5,1,1,1,1,Pn(0.5,5)])], inf)
)).play;
)
Pdef(\kick).stop
Pdef(\lead).stop
Pdef(\organ).stop
