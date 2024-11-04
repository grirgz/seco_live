
(
SynthDef(\simplegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,3],
				[0,4],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

(
	// livecode
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 1),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,1*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,3],
				[0,4],
			].midiratio * 100,inf) * Pseq([1,2,1/2],inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1/2,
		),
	])
)).play;
)

//////////////////////////////////
