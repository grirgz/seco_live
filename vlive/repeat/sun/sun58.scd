/// expand sun27.scd blues

(
~t = 300/4/60; TempoClock.default.tempo = ~t;

FileSystemProject.loadOnce("sndlib/synthaccu.scd");
);

///////// lib

(
SynthDef(\olok, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\iGNUcius, {
	var freq, amp, gate, osc, lfo, out, aenv, filterEnv, bus, resoFilter, bowNoise;
   // [hackers]:free.be(ll), you!help(software).share;
	freq = \freq.kr(440);
	amp = \amp.kr(0.1) / 3;
	gate = \gate.kr(1);
	bus = \out.kr(0);
	
	// piles.of(can.get)hoarders.money,is[true];
	osc = Pulse.ar([freq, freq*2], LFNoise1.kr(0.5!2).range(0.1, 0.9)) +
		  Pulse.ar([freq*3, freq], LFNoise1.kr(0.5!2).range(0.1, 0.9));

	// neighbors.their(help).but!cannot; true.is[that];
	lfo = SinOsc.kr(\lfoFreq.kr(0.5)).range(-0.05, 0.05) * \lfoDepth.kr(1);
	bowNoise = WhiteNoise.ar(0.15) * EnvGen.kr(Env.perc(0.01, 0.1), gate); 

	// enough(when).software.free.have[we], call.our[at];
	out = (osc + bowNoise) * (1 + lfo);
	aenv = EnvGen.ar(Env.adsr(0.05, 0.2, 0.9, 0.5), gate, doneAction: Done.freeSelf) * amp;
	filterEnv = EnvGen.kr(Env.adsr(0.01, 0.3, 0.7, 0.5), gate);

	// dirty.those(licenses).kick[we'll] out.ever.more;
	resoFilter = RLPF.ar(out, freq * \filterMul.kr(4) * filterEnv, \resonance.kr(0.4));
	out = RHPF.ar(resoFilter, 100) * aenv;

	// be.free, hackers.you'll.join(us).now[and];
	Out.ar(bus, DFM1.ar(out));
	//Out.ar(bus, out);
}).add;
SynthDef(\Piano_rhodeySC, {
	//FM Rhodes Synthethizer
	|
	// standard meanings
	out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
	// all of these range from 0 to 1
	vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
	|
	var env1, env2, env3, env4;
	var osc1, osc2, osc3, osc4, snd;

	lfoSpeed = lfoSpeed * 12;

	freq = freq * 2;

	env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
	env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
	env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
	env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

	osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
	osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
	osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
	osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
	snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

	// using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
	snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	snd = Pan2.ar(snd, pan, amp);

	Out.ar(out, snd);
//By Nathan Ho aka Snappizz
//http://sccode.org/1-522
}).add;
SynthDef(\largechord2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lpenv;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,0.32,2.1],[0.7,1.8])), 1);
	freq = freq * [1/4,1/2,1,2,3,4,5,6,7];
	sig = LFSaw.ar(freq *.x [1,1+\diff.kr(0.00001)]);
	sig = sig + SinOsc.ar(freq,mul:\sinamp.kr(0.2));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(800) * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\fx_rfilterband, { arg out=0, gate=1;
	var sig, sig1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = RLPF.ar(sig, ( \center.kr(2301) + ( \range.kr(1000)/2 ) ).clip(2,2e4), \lrq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(1), [sig, sig1]);
	sig1 = RHPF.ar(sig, (\center.kr - (\range.kr/2)).clip(2,2e4) , \hrq.kr(0.5));
	sig = SelectX.ar(\hpmix.kr(1), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_rfilterbandfac, { arg out=0, gate=1;
	var sig, sig1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = RLPF.ar(sig, ( \center.kr(2301) * ( \fac.kr(1.1) ) ).clip(2,2e4), \lrq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(1), [sig, sig1]);
	sig1 = RHPF.ar(sig, (\center.kr / (\fac.kr)).clip(2,2e4) , \hrq.kr(0.5));
	sig = SelectX.ar(\hpmix.kr(1), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\rdn_flanger, { arg out=0, gate=1;
	// code: 4-I4AB-2U5D
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 96429.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
					}.value(si, env);

				].mean;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			}.value(si, env);

		].mean;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

Pbind(
	'wet10', 1.0,
	'mix', 0.48319327731092,
	'gain', 0.90336134453782,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.58170913293744,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 3.0718143012687,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

);

(

SynthDef(\rdn_racleverb, { arg out=0, gate=1;
	// code: 5-1P2U-BR5D
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 388269.0;
	si = sig;
	sig = { arg si, env;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			}.value(si, env);

		].mean;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

Pbind(
	'wet10', 1.0,
	'mix', 0.48319327731092,
	'gain', 0.29831932773109,
	'fb', 0.0001,
	'delay', 0.58170913293744,
	'delay2', 0.0001416643274669,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 0.55423950610442,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)
		
);

ProtoDef(\FxManager).initRdn;
//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-AP62-B9C3", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.31512605042017,
	'gain', 0.23109243697479,
	'fb', 0.0001,
	'delay', 0.00043516650709244,
	'delay2', 0.58170913293744,
	'shift', -0.12605042016807,
	'shift2', 0.0,
	'distamp', 6.1647570563372,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-1MAL-6OK2", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.35714285714286,
	'gain', 0.18067226890756,
	'fb', 0.0001,
	'delay', 0.92552159097914,
	'delay2', 0.00011674193588235,
	'shift', 0.71428571428571,
	'shift2', 0.12605042016807,
	'distamp', 5.3320075574803,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 166.41714337987,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
//ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-1P2U-BR5D", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.48319327731092,
	'gain', 0.29831932773109,
	'fb', 0.0001,
	'delay', 0.44366873309786,
	'delay2', 0.0001,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 0.6408002744416,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
Pdef(\part, Pdef(\basicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0.4,0, 0.3,0,0.3,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0.2,0,1,0, 0.2,0.2,1,0.2,
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
	])
)).play;
);

///////////////////////////////////

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\lpfr, ~pmodenv.(Pseq([0.1,2,1,4],1), 8).loop,
			\lpenv, Pseq([
				Pseq([
					[ Env([0.3,0.7,1],[1.1,0.8]) ],
				],16),
				Pser([
					[ Env([1,2,1],[0.1,0.8]) ],
					[ Env([1,1,4],[0.1,0.8]) ],
					[ Env([1,0.2,3],[0.1,0.8]) ],
				],16),
			],inf),
			\note, Pseq([
				Pser([
					[12,7],
					[12,7],
					7,
					[12,7],
					[12,7],
					6,
				],8),
				[0,7],
				[7-12,0],
				Pser([
					[12,7],
					12,
				],6),

				Pser([
					[12,7],
					[12,7],
					7,
					[12,7],
					[12,7],
					6,
				],8),
				Pser([
					[-12,0],
					-12,
					[7,3]
				],4),
				6,
				[-2,3],
				[0,7],
				[7-12,0],
			],inf),
			//\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),

			\legato, Pseq([
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,2,0,1,
				1,1,2,0, 1,1,1,1,

				4,0,0,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				1,0,2,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,8,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			
			\dur, 1/8,
			\amp, 0.051,
		),
		Pdef(\basicbreak),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\note, Pseq([
				Pseq([
					Prand([12,6,7],4),
					Prand([12,3,10,6,7],4),
					Prand([12,6,7],4),
					Prand([0,3,0,5,5,6],4),
					Prand([12,6,7],4),
					Prand([12,3,10,6,7],4),
					Prand([0,3,0,5,5,6],4),
					Prand([0,3,0,5,5,6],4),
					
				],1),
				//Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				//-12,\r,
			],inf),
			\isRest, Pseq([
				1,0.7,0.9,0.5
			],inf).coin.not,
			\legato, 0.8* Pseq([
				Prand([
					Pseq([ 4,0,0,0, ],1),
					Pseq([ 2,0,2,0, ],1),
					Pseq([ 0,1,1,1, ],1),
					Pseq([ 1,1,1,0, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 3,0,0, 3,0,0, 3,0 ],1),
					Pseq([ 1,2,0,1, ],1),
					Pseq([ 1,1,2,0, ],1),
				],1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\isRest] } }),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.061,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				7,10,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\basicbreak)
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(6,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pdef(\basicbreak)
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ptpar([
			8,  Pdef(\basicbreak),
			0, Pbind(
				\instrument, \iGNUcius,
				\lfoFreq, 0.5,
				\lfoDepth, 1.0,
				\filterMul, Pseq([
					9,Pwhite(2.0,9,3),
				],inf),
				\resonance, 0.40000000596046,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					0.9,Pwhite(0.2,1),
				],inf),
				\octave, 2,
				\note, Pseq([
					0,0,3,0, 3,3,0,0,
					0,0,5,Prand([5,10],1),0,0,6,6,
				],inf),
				\isRest, Pseq([
					1,1
				],inf).coin.not,
				\dur, 1/4,
				\amp, 0.1 * Pseq([
					1,Pwhite(0.3,1,1)
				],inf),
			),
		]),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(2,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				Prand([0,7,5,3],2),
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			//\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12])),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \olok,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 4,
			\note, Pseq([
				Pseq([
					Prand([12,6,7],2),
					Prand([12,3,10,6,7],2),
					Prand([12,6,7],2),
					Prand([0,3,0,5,5,6],2),
					Prand([12,6,7],2),
					Prand([12,3,10,6,7],2),
					Prand([0,3,0,5,5,6],2),
					Prand([0,3,0,5,5,6],2),

				],1),
				//Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				//-12,\r,
			],inf),
			\isRest, Pseq([
				1,0.7,0.9,0.5
			],inf).coin.not,
			\legato, 0.8* Pseq([
				Prand([
					Pseq([ 0,0,0,0, ],1),
					Pseq([ 0,0,0,0, 0,0,0,0,],1),
					Pseq([ 8,0,0,0, 0,0,0,0, ],1),
					Pseq([ 4,0,0,0, ],1),
					Pseq([ 4,0,0,0, ],1),
					Pseq([ 2,0,2,0, ],1),
					Pseq([ 0,1,1,1, ],1),
					Pseq([ 1,1,1,0, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 3,0,0, 3,0,0, 3,0 ],1),
					Pseq([ 1,2,0,1, ],1),
					Pseq([ 1,1,2,0, ],1),
				],1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\isRest] } }),
			\dur, 1/4,
			\amp, 0.1,
			\amp, 0.051,
		),
	])
)).play;
);

/////// bass draft
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \iGNUcius,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 2,
			\filterMul, 5,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				10,10,9,9,0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
	])
)).play;
);

//////////////////////
(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\apart1intro, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Ptpar([
			8, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					0,5,
				],inf),
				\dur, 1,
				\amp, 0.1/1.5,
				\out, BusDef(\sendbus3, \audio),
			),
			16, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
			),
			//32, Pdef(\smoothbreak6),
			16+8, Pdef(\basicbreak),
		])
	])
)).play;
);

(
///////////////// main //////////
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(32, Pdef(\apart1intro)),
		Pfindur(32, Pdef(\apart1)),
		Pfindur(8, Pdef(\apart1break)),
		Pfindur(32, Pdef(\apart2)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\apart1, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				7,10,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\basicbreak),
		Pdef(\smoothbreak6),
	])
)).play;
);

(
Pdef(\part, Pdef(\apart1break, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1,
					1,0,0,0,
				],4),
				Pseq([
					1,0,0,0,
					1,0,0,1,
				],4),
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				7,10,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\out, BusDef(\sendbus2, \audio),
		),
		//Pdef(\basicbreak),
		//Pdef(\smoothbreak6),
	])
)).play;
);

(
Pdef(\part, Pdef(\apart2, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(6,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pdef(\basicbreak)
	])
)).play;
);

(
Pdef(\part, Pdef(\apart3, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(6,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pdef(\basicbreak),
		Ptpar([
			8, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					0,5,
				],inf),
				\dur, 1,
				\amp, 0.1/1.5,
				\lag, -0.04,
				\out, BusDef(\sendbus3, \audio),
			),
			16, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
			),
			//32, Pdef(\smoothbreak6),
			//16+8, Pdef(\basicbreak),
		])
	])
)).play;
);

/////////// other idea

(
Pdef(\melo, 
	Pbind(
		\instrument, \olok,
		\amp, 0.3,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				[5,8,12,15,17].mirror1,
				[4,8,12,15,16].mirror1,
			],inf),
			\strum, 0.3,
			\lag, Pwhite(0.0,0.1,inf),
			\legato, Ptuple(Pexprand(0.1,0.9,inf)!5),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\lpfr, 1,
			\octave, 6,
			\envampt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, Pseg(Pseq([150,1000],inf),3),
			\pan, Pseg(Pwhite(-1,1,inf),Prand([1/4,1/2,1,2,3],inf)),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pstep(Prand([5,8,12,15,17] +.x [-12,0,12],4*4),4),
				Pstep(Prand([4,8,12,15,16] +.x [-12,0,12],4*4),1/8),
			],inf),
			\dur, 1/8,
			\amp, 0.1/4 * Pseq([
				1,0.5,0.8,0.4,
			],inf).linlin(0,1, Pseg(Pseq([0,1],inf),9),1),
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\fx1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pwhite(0,1,inf), Pwhite(0.1,4,inf)).loop,
			\sendbus0, BusDef(\sendbus3, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

/////////// rework

(
Pdef(\part, Pdef(\rpart1, 
	Ppar([
		
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);


(
// fx on olok
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\olok, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\olok, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\olok1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\olok1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			\mix, PmodEnv(Pseq([0,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\olok2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\olok2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
// fx on hats
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.3,
			],inf),
			\octave, 2,
			\isRest, Pseq([
				1,0,1,0.2,
				1,1,0,1,
				1,0,1,0.2,
				1,1,0.4,1,
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\olok, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1367].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
			\out, BusDef(\hats, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0,1,1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * (Pkey(\score) * 4).clip(0,1),
			\out, BusDef(\hats, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hats),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,0.4],1), 8).loop,
			\sendbus0, BusDef(\hats0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hats0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\hats1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hats1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\hats2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\hats2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.3,
			],inf),
			\octave, 2,
			\isRest, Pseq([
				1,0,1,0.2,
				1,1,0,1,
				1,0,1,0.2,
				1,1,0.4,1,
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\olok, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\olok, \audio),
			\shift, PmodEnv(Pseq([0.001,400,1000],1), 8,\exp).loop,
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\olok1, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\olok1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distpostamp, 0.2,
			\distamp, PmodEnv(Pseq([10,44,100],1), 8).loop,
			\dur, 1,
			\out, BusDef(\olok2, \audio),
		),
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\olok2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,100,5000,10000,400],1), Pseq([4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kick, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1367].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1.5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
			\out, BusDef(\hats, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0,0,1,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.25 * (Pkey(\score) * 4).clip(0,1),
			\out, BusDef(\hats, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hats),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,0.1,1,1,1],1), Pseq([6,2],inf)).loop,
			\sendbus0, BusDef(\hats0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\hats0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 1/2/~t,
			\diffmul, 1.5,
			\diffadd, 0.0,
			\decay, 1.4/~t,
			\lpf, 19000.0,
			\hpf, 50.0,
			\pfmix, 0.5,
			\mix, 1,
			\gain, 1/2,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\dur, 1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kick),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,0.4],1), 8).loop,
			\sendbus0, BusDef(\kick0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\kick0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\kick1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\kick1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\kick2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\kick2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.3,
			],inf),
			\octave, 2,
			\isRest, Pseq([
				1,0,1,0.2,
				1,1,0,1,
				1,0,1,0.2,
				1,1,0.4,1,
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\olok, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\olok, \audio),
			\shift, PmodEnv(Pseq([0.001,400,1000],1), 8,\exp).loop,
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\olok1, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\olok1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distpostamp, 0.2,
			\distamp, PmodEnv(Pseq([10,44,100],1), 8).loop,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\olok2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\olok2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0,0.2,1,0.4],1), 8).loop,
			\out, BusDef(\olok3, \audio),
			\dur, 1,
		),
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\olok3, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,100,5000,10000,400],1), Pseq([4]),\exp),
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kick, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1367].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 1.5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
			\out, BusDef(\hats, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0,0,1,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.25 * (Pkey(\score) * 4).clip(0,1),
			\out, BusDef(\hats, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hats),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,0.1,1,1,1],1), Pseq([6,2],inf)).loop,
			\sendbus0, BusDef(\hats0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\hats0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 1/2/~t,
			\diffmul, 1.5,
			\diffadd, 0.0,
			\decay, 1.4/~t,
			\lpf, 19000.0,
			\hpf, 50.0,
			\pfmix, 0.5,
			\mix, 1,
			\gain, 1/2,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\dur, 1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kick),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,0.4],1), 8).loop,
			\sendbus0, BusDef(\kick0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\kick0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\kick1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\kick1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\kick2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\kick2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\piano1, \audio),
			//\out, BusDef(\sendbus2, \audio),
			//\isRest, true,
		),
		Pmono(\rdn_flanger,
			\inbus, BusDef(\piano1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.48319327731092,
			'gain', 0.90336134453782,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.58170913293744,
			\delay2, PmodEnv(Pseq([0.7001,0.65,0.3,0.8],1), Pseq([7.9,0.1,8]),\exp).loop,
			'shift', 0.16806722689076,
			'shift2', 0.0,
			'distamp', 0.4718143012687,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\note, Pseq([
				0,5,
			],inf),
			\dur, 1,
			\amp, 0.1/1.5,
			\lag, -0.04,
			\out, BusDef(\piano2, \audio),
			//\out, BusDef(\sendbus3, \audio),
		),
		Pmono(\rdn_flanger,
			\inbus, BusDef(\piano2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.48319327731092,
			'gain', 0.90336134453782,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.58170913293744,
			\delay2, PmodEnv(Pseq([0.0001,0.05,0.8,0.8],1), Pseq([7.9,0.1,8]),\exp).loop,
			'shift', 0.16806722689076,
			'shift2', 0.0,
			'distamp', 13.0718143012687,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);


Pdef(\rfilter).edit


(
Pdef(\part, Pdef(\break2, 
	Ppar([
		Pbind(\out, BusDef(\breakfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.05) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					0.2,0,1,0, 0.2,0.2,1,0.2,
					0.2,0,0.2,0.1, 0.2,0,1,0.2,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			),
		]),
		Pmono(\rdn_flanger,
			\inbus, BusDef(\breakfx, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.48319327731092,
			'gain', 0.90336134453782,
			'fb', 0.001,
			'delay', 0.7501,
			'delay2', 0.00108170913293744,
			\delay2, PmodEnv(Pseq([0.7001,0.65,0.3,0.8]*0.0001,1), Pseq([7.9,0.1,8]),\exp).loop,
			'shift', 0.16806722689076,
			'shift2', 0.0,
			'distamp', 7.4718143012687,
			'pitchlag', 1.0,
			'pitchmix', 1.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 1700,
			\hpf, PmodEnv(Pseq([90,90,500,500],1), Pseq([8,0.1,7.9]), \exp).loop,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
)

(
// fx change on 16 beats
Pdef(\part, Pdef(\rpartintro1, 
	Ppar([
		Pbind(\out, BusDef(\breakfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,

					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.05) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					0.2,0,1,0, 0.2,0.2,1,0.2,
					0.2,0,0.2,0.1, 0.2,0,1,0.2,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			),
		]),
		Pmono(\rdn_flanger,
			\inbus, BusDef(\breakfx, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.48319327731092,
			\mix, PmodEnv(Pseq([0,0,1,1,1],1), 4).loop,
			'gain', 0.90336134453782,
			'fb', 0.001,
			'delay', 0.7501,
			'delay2', 0.00108170913293744,
			\delay2, PmodEnv(Pseq([0.7001,0.65,0.3,0.8]*0.0001,1), Pseq([7.9,0.1,8]),\exp).loop,
			'shift', 0.16806722689076,
			'shift2', 0.0,
			'distamp', 7.4718143012687,
			'pitchlag', 1.0,
			'pitchmix', 1.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 1700,
			//\hpf, PmodEnv(Pseq([90,90,500,500],1), Pseq([8,0.1,7.9]), \exp).loop,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),

		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\olok, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\olok, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\olok1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\olok1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			\mix, PmodEnv(Pseq([1,0.9,0.1,0],1), Pseq([8,0.1,7.9])).loop,
			\dur, 1,
			\out, BusDef(\olok2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\olok2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\gain, PmodEnv(Pseq([0,0,1,1,1]*0.5,1), Pseq([4,4],inf)).loop,
			\dur, 1,
		),
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([3000,200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\lchord, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\lchord, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0.5,0.5,0,0,],1), Pseq([7.9,0.1,8],inf)).loop,
			\gain, PmodEnv(Pseq([0,0,1,1,1],1), Pseq([4,4],inf)).loop,
			\dur, 1,
		),
	])
)).play;
)

(
// fx change on 16 beats
Pdef(\part, Pdef(\rpartintro2, 
	Ppar([
		Pbind(\out, BusDef(\breakfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,

					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.05) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					0.2,0,1,0, 0.2,0.2,1,0.2,
					0.2,0,0.2,0.1, 0.2,0,1,0.2,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			),
		]),
		Pmono(\rdn_flanger,
			\inbus, BusDef(\breakfx, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.48319327731092,
			\mix, PmodEnv(Pseq([0,0,1,1,1],1), 4).loop,
			'gain', 0.90336134453782,
			'fb', 0.001,
			'delay', 0.7501,
			'delay2', 0.00108170913293744,
			\delay2, PmodEnv(Pseq([0.7001,0.65,0.3,0.8]*0.0001,1), Pseq([7.9,0.1,8]),\exp).loop,
			'shift', 0.16806722689076,
			'shift2', 0.0,
			'distamp', 7.4718143012687,
			'pitchlag', 1.0,
			'pitchmix', 1.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 1700,
			//\hpf, PmodEnv(Pseq([90,90,500,500],1), Pseq([8,0.1,7.9]), \exp).loop,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),

		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\olok, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\olok, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,200,800],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\olok1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\olok1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			\mix, PmodEnv(Pseq([1,0.9,0.1],1), Pseq([8,8])).loop,
			\dur, 1,
			\out, BusDef(\olok2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\olok2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\gain, PmodEnv(Pseq([0,0,1,1,1]*0.5,1), Pseq([4,4],inf)).loop,
			\dur, 1,
		),
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([3000,200,800,4000,15000],1), 4,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\lchord, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\lchord, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0.5,0.5,0,0,],1), Pseq([7.9,0.1,8],inf)).loop,
			\gain, PmodEnv(Pseq([0,0,1,1.2],1), Pseq([8,6,2],inf)).loop,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\seq1, 
	Ppar([
		Pseq([
			Pfindur(16,Pdef(\rpartintro2)),
			Pfindur(16,Pdef(\rpart1)),
			
		],2),
		
	])
)).play;
);

(
// cutting bass is the key
Pdef(\part, Pdef(\rpart2, 
	Ppar([
		
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\lchord, \audio),
		),
		Pmono(\fx_greyhole,
			\damp, 0.5,
			\size, 1.0,
			\diff, 0.070700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.0010000000149012,
			\modFreq, 2.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\gain, 1.0,
			\inbus, BusDef(\lchord, \audio),
			\mix, PmodEnv(Pseq([0,0,0.1,0.5,0.5,0.2],1), Pseq([8,8,1,7,8])).loop,
			\delay, 1/4/~t,

			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf) * Pseg(Pseq([0.4,4],1),16).loop,
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				Pstep(Pseq([1,1],1),8),
				Pstep(Pseq([0,0],1),8),
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				Pser([
					3,5,6,
				],16*8),
			],inf),
			\isRest, Pseq([
				Pser([
					1
				],16*8),
				Pser([
					0
				],16*8),
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\drums, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\drums, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\drums, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,1,4000,14000],1), Pseq([7,1,8])).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1367].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
			\out, BusDef(\hats, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hats),
			\pregain, 1,
			\postgain, 1,
			\postgain, PmodEnv(Pseq([0,0,1,1,0]*0.5,1), Pseq([14,2,24,8])).loop,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,0,1,0.4],1), Pseq([10,6,16])).loop,
			\send0, 0,
			\sendbus0, BusDef(\hats0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hats0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,20,20],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\hats1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hats1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			//\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\hats2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\hats2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\gain, PmodEnv(Pseq([1,0,1,1]*0.5,1), Pseq([30,2,32])).loop,
			\dur, 1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0,1,1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * (Pkey(\score) * 4).clip(0,1),
			\out, BusDef(\hatsb, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hatsb),
			\pregain, 1,
			\postgain, 1,
			\postgain, PmodEnv(Pseq([0,0,1,1]*0.5,1), Pseq([14,2,8])).loop,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,0,1,0.4],1), Pseq([10,6,16])).loop,
			\send0, 0,
			\sendbus0, BusDef(\hatsb0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hatsb0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,20,20],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\hatsb1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hatsb1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			//\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\hatsb2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\hatsb2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\gain, PmodEnv(Pseq([1,0,1,1]*0.5,1), Pseq([30,2,32])).loop,
			\dur, 1,
		),
	])
)).play;
);




(
// bpart seq
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\seq2, 
	Ppar([
		Pseq([
			Pfindur(32,Pdef(\bpart1)),
			Pfindur(32,Pdef(\bpart2)),
			Pfindur(32,Pdef(\bpart_growhi)),
			Pfindur(32,Pdef(\bpart3)),
		],1),
	])
)).play;
);

(
Pdef(\part, Pdef(\bpart1, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Ptpar([
			8, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					0,5,
				],inf),
				\dur, 1,
				\amp, 0.1/1.5,
				\out, BusDef(\sendbus3, \audio),
			),
			16, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
			),
			//32, Pdef(\smoothbreak6),
			16+8, Pdef(\basicbreak),
		])
	])
)).play;
);
(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\bpart2, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Ptpar([
			0, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					0,5,
				],inf),
				\dur, 1,
				\amp, 0.1/1.5,
				\out, BusDef(\sendbus3, \audio),
			),
			0, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			),
			//32, Pdef(\smoothbreak6),
			0, Pbind(\out, BusDef(\drums,\audio)) <> Pdef(\basicbreak),
			8, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[735].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.1,
					//\out, BusDef(\drums, \audio),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11,
					//\out, BusDef(\drums, \audio),
				),
			]),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\drums, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,8000,10],1), 8),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);
(
Pdef(\part, Pdef(\bpart3, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\isRest, Pseq([
				Pser([
					1,1
				],14*4),
				Pser([
					0,0
				],2*4),
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\note, Pseq([
				0,5,
			],inf),
			\dur, 1,
			\amp, 0.1/1.5,
			\out, BusDef(\racle, \audio),
		),
		Pmono(\rdn_racleverb,
			\inbus, BusDef(\racle, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			'wet10', 1.0,
			'mix', 0.48319327731092,
			'gain', 0.29831932773109,
			'fb', 0.0001,
			'delay', 1/2/~t,
			'delay2', 0.0001416643274669,
			'shift', 0.06806722689076,
			'shift2', 0.0,
			'distamp', 4.55423950610442,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.1,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),


		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),

		//32, Pdef(\smoothbreak6),
		Pbind(\out, BusDef(\drums,\audio)) <> Pdef(\basicbreak),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\drums, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\out, BusDef(\drums, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\drums, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,8000,10],1), 8),
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1367].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
			\out, BusDef(\hats, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hats),
			\pregain, 1,
			\postgain, 1,
			\postgain, PmodEnv(Pseq([0,0,1,1,0]*0.5,1), Pseq([8,1,23,8])).loop,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,0,1,0.4],1), Pseq([10,6,16])).loop,
			\sendbus0, BusDef(\hats0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hats0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,20,20],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\hats1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hats1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			//\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\hats2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\hats2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\gain, PmodEnv(Pseq([1,0,1,1]*0.5,1), Pseq([30,2,32])).loop,
			\dur, 1,
		),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\bpart4, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Ptpar([
			0, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			),
			//32, Pdef(\smoothbreak6),
			0, Pbind(\out, BusDef(\drums,\audio)) <> Pdef(\basicbreak),
			0, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[735].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.1,
					//\out, BusDef(\drums, \audio),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11,
					//\out, BusDef(\drums, \audio),
				),
			]),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\drums, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([200,4000,10],1), 8),
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\drums2, \audio),
		).loop,
		Pmono(\fx_resonz,
			\inbus, BusDef(\drums2, \audio),
			\addAction, \addToTail,
			\freq, PmodEnv(Pseq([100,2000,4000],4), Pseq([2,8],inf), \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1/Pstep(Pseq([
				1,0.9,2,1, 1,1,2,1.2,
				2,1.9,2,1, 1,1,1/2,1.2,
				1,0.9,2,1, 1,1,1.2,1.2,
				2,1.9,2,1, 1,1,1.2,1.2,

				1,1,1,1.2, 1,1,1,1,
				2,1.52,1,1, 2,1,1,1,
				1,1,1,1, 0.8,1,1,1,
				1,2,1,1, 1,1,1,1,
			],inf),1/8) * ~t / Pkey(\st),
			\pos, Pseq([

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 2,
				],1),2)+6,
				Pseg(Pseq([
					2, 0,
				],1),2)+4,

				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2)+4,
				Pseg(Pseq([
					0, 8,
				],1),4)+1,
				//Pseg(Pseq([
				//1, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, PdurStutter(Pseq([
				Pser([
					4,4,4,8, 2,8,1,8,
				],inf),
				Pseq([
					1,1,6,1, 2,1,7,1,
				],4),
				Pseq([
					8,1,4,1, 1,4,2,4,
				],4),
			],inf), 1),
			\isRest, Pstep(Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0.81,0.51,0.51,
				],4),
				Pseq([
					1,0,0,0, 0,0.81,0.51,0.51,
					1,0.81,0.51,0.51, 1,0.81,0.51,0.51,
				],4),
				Pseq([
					0,0,0,0, 0,0.81,0.51,0.51,
					1,0,0,0, 0,0.81,0.51,0.51,
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0.3,0.3,0.3,
				],2),
				Pser([
					1,
				],8*8),
			],inf),1/8).coin.not,
			\gain, 1/13,
			\out, BusDef(\cook, \audio),
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\cook, \audio),
			\addAction, \addToTail,
			\freq, PmodEnv(Pseq([100,2000,4000],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pdef(\hei,Pbind(
			\type, \phrase,
			\instrument, \balienshort1,
			\dur, 1,
			\legato, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1/8,
		)),
	])
)).play;
);

//////////// structure en groupe de beats


(
// 3-1
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind( // bass
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
			],inf).stutter(4),
			\isRest, Pseq([
				Pser([
					1,1
				],24*4),
				Pser([
					0,0
				],8*4),
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),


		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(\out, BusDef(\drums,\audio)) <> Pdef(\basicbreak),

		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,0,0, 1,0,0,0,
				],8*24),
				Pser([
					0
				],8*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\drums, \audio),
		),

		Pbind( //snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 1,0,0,0,
				],28*8),
				Pser([
					0
				],4*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\out, BusDef(\drums, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\drums, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2000,8000,10],1), 8),
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind( // flipflop
			\instrument, \largechord2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\lpf, PmodEnv(Pseq([200,800,15000],1), 8,\exp).loop,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),

		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1367].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
			\out, BusDef(\hats, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hats),
			\pregain, 1,
			\postgain, 1,
			\postgain, PmodEnv(Pseq([0,0,1,1,0]*0.5,1), Pseq([8,1,23,8])).loop,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,0,1,0.4],1), Pseq([10,6,16])).loop,
			\sendbus0, BusDef(\hats0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hats0, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\distamp, PmodEnv(Pseq([20,20,20,20],1), Pseq([8,2,6])).loop,
			\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6])).loop,
			\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6])).loop,
			\dur, 1,
			\out, BusDef(\hats1, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hats1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.5,
			//\mix, PmodEnv(Pseq([0.5,0.1,1],1), Pseq([12,4])).loop,
			\dur, 1,
			\out, BusDef(\hats2, \audio),
		),
		//Pbindef(\rfilter) <>
		Pmono(\fx_rfilterbandfac,
			\inbus, BusDef(\hats2, \audio),
			\addAction, \addToTail,
			\center, PmodEnv(Pseq([4400,800,5000],1), Pseq([12,4]),\exp).loop,
			\fac, 2,
			\gain, 0.5,
			\lag, 0.0009,
			\gain, PmodEnv(Pseq([1,0,1,1]*0.5,1), Pseq([30,2,32])).loop,
			\dur, 1,
		),
	])
)).play;
);


//// break then house drums

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(8,
				Ptpar([
					0, 
					Ppar([
						Pbind(
							\instrument, \playersec,
							\bufnum, BufDef('voices/feynman.flac'),
							\pos, 0,
							\legato, 1,
							\dur, Pseq([
								1,1,Pn(1/2,inf)
							],1),
							\gain, 1/8,
							\out, BusDef(\voice, \audio),
						),
						Pmono(\fx_resonz,
							\inbus, BusDef(\voice, \audio),
							\freq, PmodEnv(Pseq([100,8000],1), 8,\exp).loop,
							\addAction, \addToTail,
							\lag, 0.0009,
							\dur, 1,
						),
					]),
					4, Ppar([
						Pbind( // bass intro
							\instrument, \iGNUcius,
							\lfoFreq, 0.5,
							\lfoDepth, 1.0,
							\filterMul, Pseq([
								9,Pwhite(2.0,9,1),
								9,Pwhite(2.0,9,3),
							],inf),
							\filterMul, PmodEnv(Pseq([74,1],1), 2,\exp).loop,
							\resonance, 0.40000000596046,
							\adsr, Pseq([
								[ Env.adsr(0.01,0.1,0.8,0.1) ],
							],inf),
							\legato, Pseq([
								0.9,Pwhite(0.2,1),
							],inf),
							\octave, 3,
							\note, Pseq([
								Pseq([5],4),
							],inf).stutter(4),
							\isRest, Pseq([
								Pser([
									1,1
								],24*4),
								Pser([
									0,0
								],8*4),
							],inf).coin.not,
							\dur, 1/4,
							\amp, 0.1 * Pseq([
								1,Pwhite(0.3,1,1)
							],inf),
						),
						Pbind(
							\instrument, \olok,
							\note, Pseq([
								3,5,6,
							],inf),
							\freq, PmodEnv(Pseq([7001,24],1), 2, \exp).loop,
							\octave, 5,
							\dur, 1/8,
							\amp, 0.1,
						),
						Pbind(\out, BusDef(\drumsintro, \audio)) <> Pdef(\lourdbreakslow),
						Pmono(\rdn_racleverb,
							\inbus, BusDef(\drumsintro, \audio),
							\addAction, \addToTail,
							\lag, 0.0009,
							\dur, 1,
							'wet10', 1.0,
							'mix', 0.48319327731092,
							'gain', 0.29831932773109,
							'fb', 0.0001,
							'delay', 0.00002,
							'delay2', 0.0001416643274669,
							'shift', 0.06806722689076,
							'shift2', 0.0,
							'distamp', 4.55423950610442,
							'pitchlag', 1.0,
							'pitchmix', 0.0,
							'prelpf', 17000,
							'prehpf', 17,
							'lpf', 17000,
							'hpf', 17,
							'fbdistamp', 0.47619047619048,
							'fbdistmix', 0.91176470588235,
							'postlpf', 17000,
							'posthpf', 17,
							'wetamp', 0.7,
							'indelay', 0.04,
							'wet20', 1.0,
							'mamp', 1,
						),
					]),
				]),
			),
			Pfindur(24,
				Ppar([
					Pbind( // kick
						\instrument, \playersec,
						\bufnum, ~buflib.kick[735].value,
						//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
						\isRest, Pseq([
							Pser([
								1,0,0,0, 1,0,0,0,
							],8*24),
							Pser([
								0
							],8*8),
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.1,
						//\out, BusDef(\drums, \audio),
					),

					Pbind( //snare
						\instrument, \playersec,
						\bufnum, ~buflib.snare[1753].value,
						//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
						\isRest, Pseq([
							Pser([
								0,0,0,0, 1,0,0,0,
							],28*8),
							Pser([
								0
							],4*8),
						],inf).coin.not,
						\dur, 1/8,
						\gain, 0.11,
						//\out, BusDef(\drums, \audio),
					),
					Pbind( // bass
						\instrument, \iGNUcius,
						\lfoFreq, 0.5,
						\lfoDepth, 1.0,
						\filterMul, Pseq([
							9,Pwhite(2.0,9,1),
							9,Pwhite(2.0,9,3),
						],inf),
						\resonance, 0.40000000596046,
						\adsr, Pseq([
							[ Env.adsr(0.01,0.1,0.8,0.1) ],
						],inf),
						\legato, Pseq([
							0.9,Pwhite(0.2,1),
						],inf),
						\octave, 2,
						\note, Pseq([
							12,12,11,11,Pseq([5],4),
						],inf).stutter(4),
						\isRest, Pseq([
							Pser([
								1,1
							],24*4),
							Pser([
								0,0
							],8*4),
						],inf).coin.not,
						\dur, 1/4,
						\amp, 0.1 * Pseq([
							1,Pwhite(0.3,1,1)
						],inf),
					),
				]),
			),
		],4),
	])
)).play;
);

(
Pdef(\part, Pdef(\lourdbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[314].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[27].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2308].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\lourdbreakslow, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[314].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[27].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2308].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
		),
		
	])
)).play;
);

/// list of instruments
// - kick
// - snare
// - hat1
// - hat2
// - olok triplet
// - falling bass iGNUcius
// - flipflop largechord2
// - piano fx
// - break drums
// - house drums


////// refaire la petite montée de sun27b dreadbassdrum6

(
Pdef(\part, Pdef(\bpart_break, 
	Pfindur(32, Ptpar([
		0, Pfindur(20,Ppar([

			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0.2,0,
						0.2,0,0,0.2, 0,0,0,0,
						0,0,0,0, 0,0,0.2,0.2,
						0,0,0.2,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
					],3),
					1,0,0,0, 0,0,0,0,
					0,0,0.5,0.5, 0,0,0,0,
					Pseq([
						1,0,0.3,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						1,0,0.2,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
					],3),
					Pser([
						0.5,
					],4*8),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],16),
					Pseq([
						0,0.5,0,0, 0.5,0,0,0.5,
					],16),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.05) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					Pser([
						0,0,1,0,
					],8*8),
					Pser([
						1,0,1,0,
					],8*8),
					Pser([
						1,1,1,1,
					],8*8),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
				\out, BusDef(\hats, \audio),
			),
		])),
		0, Pmono(\fx_greyhole, // fx for hats
			\inbus, BusDef(\hats, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0,0,0,1,1],1), Pseq([8,8,4,12])).loop,
			\damp, 0.0,
			\size, 4.0,
			\diff, 0.070700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.0010000000149012,
			\modFreq, 2.0,
			\gain, 1.0,
			\delay, 1/4/~t,
			\dur, 1,
		),

		0, Ppar([
			Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\olok, \audio),
			),
			Pmono(\fx_tanh,
				\inbus, BusDef(\olok, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6]*2)).loop,
				\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6]*2)).loop,
				\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6]*2)).loop,
				\dur, 1,
				\out, BusDef(\olok1, \audio),
			),
			Pmono(\fx_greyhole,
				\inbus, BusDef(\olok1, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, 0.5,
				\mix, PmodEnv(Pseq([0,0.1,1],1), Pseq([12,4]*2)).loop,
				\dur, 1,
				\out, BusDef(\olok2, \audio),
			),
			//Pbindef(\rfilter) <>
			Pmono(\fx_rfilterbandfac,
				\inbus, BusDef(\olok2, \audio),
				\addAction, \addToTail,
				\center, PmodEnv(Pseq([4,800,1000,5000,8000],1), Pseq([8],inf),\exp).loop,
				\fac, 2,
				\gain, 0.5,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		8, Pfindur(24-8,Ppar([

			Pbind( // bass
				\instrument, \iGNUcius,
				\lfoFreq, 0.5,
				\lfoDepth, 0.0,
				\filterMul, Pseq([
					9
				],inf),
				\resonance, 0.40000000596046,
				\adsr, Pseq([
					[ Env.adsr(1.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					0.4
				],inf),
				\octave, 2,
				\note, Pseq([
					12,12,11,11,Pseq([5],4),
				],inf).stutter(4),
				\freq, Pseg(Pseq([70,65],inf),16,\exp),
				\isRest, Pseq([
					Pser([
						1,0,0,1,
					],24*4),
					Pser([
						0,0
					],8*4),
				],inf).coin.not,
				\dur, 1/4,
				\amp, 0.1 * Pseq([
					1,Pwhite(0.3,1,1)
				],inf),
			),
		])),
		12, Ppar([

			Pbind(
				\instrument, \largechord2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 0.9,
				\octave, [3,4],
				\lpf, PmodEnv(Pseq([200,800,15000],1), Pseq([ 4,16 ]),\exp).loop,
				\note, Pseq([
					0,0,5,5,0,0,6,6,
				],inf),
				\dur, 1/4,
				\amp, 0.1 * Ptuple([1, Pseg(Pseq([0,0.6,1,Pn(1,inf)],inf),8)]),
				\out, BusDef(\lchord, \audio),
			),
			Pmono(\fx_greyhole,
				\inbus, BusDef(\lchord, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, PmodEnv(Pseq([0,0,0.1,0.5,0.5,0.2],1), Pseq([8,8,1,7,8])).loop,
				\damp, 0.5,
				\size, 1.0,
				\diff, 0.070700001716614,
				\fb, 0.89999997615814,
				\modDepth, 0.0010000000149012,
				\modFreq, 2.0,
				\gain, 1.0,
				\delay, 1/4/~t,

				\dur, 1,
				\out, BusDef(\lchord2, \audio),
			),
			Pmono(\fx_hpf,
				\inbus, BusDef(\lchord2, \audio),
				\addAction, \addToTail,
				\hpf, PmodEnv(Pseq([1,200,1800],1), Pseq([4,16]), \exp).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		0, Ppar([
			
			Pbind(\out, BusDef(\alienverb, \audio)) <>
			Pfindur(8,Pdef(\balienrise2)),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\alienverb, \audio),
				\addAction, \addToTail,
				\room, 5,
				\damp, 0.7,
				\mix, 0.5,
				\ingain, PmodEnv(Pseq([0,0,1,1],1), Pseq([7,1,8])).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		24, Pdef(\balienrise1),
	]))
)).play;
);

(
// start with hi
Pdef(\part, Pdef(\bpart_growhi, 
	Pfindur(32, Ptpar([
		0, Pfindur(28,Ppar([

			Pbind(\out, BusDef(\drumsfx, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[879].value,
					\score, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0.2,0,
							0.2,0,0,0.2, 0,0,0,0,
							0,0,0,0, 0,0,0.2,0.2,
							0,0,0.2,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
						],3),
						1,0,0,0, 0,0,0,0,
						0,0,0.5,0.5, 0,0,0,0,
						Pseq([
							1,0,0.3,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							1,0,0.2,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
						],3),
						Pser([
							0.5,
						],4*8),
					],inf),
					\isRest, Pkey(\score).coin.not,
					\dur, 1/8,
					\gain, 0.15 * Pkey(\score),
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[771].value,
					\score, Pseq([
						Pseq([
							0,0,0,0, 1,0,0,0,
						],16),
						Pseq([
							0,0.5,0,0, 0.5,0,0,0.5,
						],16),
					],inf),
					\isRest, Pkey(\score).coin.not,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.15 * Pkey(\score),
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[771].value,
					\score, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						0,1,0,0, 0,0,0,1,
					],inf),
					\isRest, Pkey(\score).coin.not,
					\sustain, 0.1/2,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.05) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11/2 * Pkey(\score),
				),
			]),
			Pmono(\fx_hpf,
				\inbus, BusDef(\drumsfx, \audio),
				\addAction, \addToTail,
				\hpf, PmodEnv(Pseq([2e4,2,2,3000,15000],1), 8).loop,
				\lag, 0.0009,
				\dur, 1,
			),


			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					Pser([
						0,0,0,0,
					],8*8),
					Pser([
						0,0,1,0,
					],8*8),
					Pser([
						1,0,1,0,
					],8*8),
					Pser([
						1,1,1,1,
					],8*8),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
				\out, BusDef(\hats, \audio),
			),
		])),
		0, Pmono(\fx_greyhole, // fx for hats
			\inbus, BusDef(\hats, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0,0,0,1,1],1), Pseq([8,8,4,12])).loop,
			\damp, 0.0,
			\size, 4.0,
			\diff, 0.070700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.0010000000149012,
			\modFreq, 2.0,
			\gain, 1.0,
			\delay, 1/4/~t,
			\dur, 1,
		),

		0, Ppar([
			Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\olok, \audio),
			),
			Pmono(\fx_tanh,
				\inbus, BusDef(\olok, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\distamp, PmodEnv(Pseq([20,20,200,200],1), Pseq([8,2,6]*2)).loop,
				\distpostamp, PmodEnv(Pseq([0.2,0.2,0.05,0.02],1), Pseq([8,2,6]*2)).loop,
				\mix, PmodEnv(Pseq([0,0.1,0.6,1],1), Pseq([8,2,6]*2)).loop,
				\dur, 1,
				\out, BusDef(\olok1, \audio),
			),
			Pmono(\fx_greyhole,
				\inbus, BusDef(\olok1, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, 0.5,
				\mix, PmodEnv(Pseq([0,0.1,1],1), Pseq([12,4]*2)).loop,
				\dur, 1,
				\out, BusDef(\olok2, \audio),
			),
			//Pbindef(\rfilter) <>
			Pmono(\fx_rfilterbandfac,
				\inbus, BusDef(\olok2, \audio),
				\addAction, \addToTail,
				\center, PmodEnv(Pseq([400,800,1000,5000,8000],1), Pseq([8],inf),\exp).loop,
				\fac, 2,
				\gain, 0.5,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		8, Pfindur(24-8,Ppar([

			Pbind( // bass
				\instrument, \iGNUcius,
				\lfoFreq, 0.5,
				\lfoDepth, 0.0,
				\filterMul, Pseq([
					9
				],inf),
				\resonance, 0.40000000596046,
				\adsr, Pseq([
					[ Env.adsr(1.01,0.1,0.8,0.01) ],
				],inf),
				\legato, Pseq([
					0.4
				],inf),
				\octave, 2,
				\note, Pseq([
					12,12,11,11,Pseq([5],4),
				],inf).stutter(4),
				\freq, Pseg(Pseq([70,65],inf),16,\exp),
				\isRest, Pseq([
					Pser([
						1,0,0,1,
					],24*4),
					Pser([
						0,0
					],8*4),
				],inf).coin.not,
				\dur, 1/4,
				\amp, 0.1 * Pseq([
					1,Pwhite(0.3,1,1)
				],inf),
			),
		])),
		12, Ppar([

			Pbind(
				\instrument, \largechord2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 0.9,
				\octave, [3,4],
				\lpf, PmodEnv(Pseq([200,800,15000],1), Pseq([ 4,16 ]),\exp).loop,
				\note, Pseq([
					0,0,5,5,0,0,6,6,
				],inf),
				\dur, 1/4,
				\amp, 0.1 * Ptuple([1, Pseg(Pseq([0,0.6,1,Pn(1,inf)],inf),8)]),
				\out, BusDef(\lchord, \audio),
			),
			Pmono(\fx_greyhole,
				\inbus, BusDef(\lchord, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, PmodEnv(Pseq([0,0,0.1,0.5,0.5,0.2],1), Pseq([8,8,1,7,8])).loop,
				\damp, 0.5,
				\size, 1.0,
				\diff, 0.070700001716614,
				\fb, 0.89999997615814,
				\modDepth, 0.0010000000149012,
				\modFreq, 2.0,
				\gain, 1.0,
				\delay, 1/4/~t,

				\dur, 1,
				\out, BusDef(\lchord2, \audio),
			),
			Pmono(\fx_hpf,
				\inbus, BusDef(\lchord2, \audio),
				\addAction, \addToTail,
				\hpf, PmodEnv(Pseq([1,200,1800],1), Pseq([4,16]), \exp).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		0, Ppar([
			
			Pbind(\out, BusDef(\alienverb, \audio)) <>
			Pfindur(8,Pdef(\balienrise2)),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\alienverb, \audio),
				\addAction, \addToTail,
				\room, 5,
				\damp, 0.7,
				\mix, 0.5,
				\ingain, PmodEnv(Pseq([0,0,1,1],1), Pseq([7,1,8])).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		24, Pdef(\balienrise1),
	]))
)).play;
);

//// risers

(
Pdef(\part, Pdef(\balienrise1, 
	Ppar([
			Pbind(
				\instrument, \oscsampler3,
				\pos, 0.012,
				//\fshift, -148,
				\lpmix, 0.41,
				\hpmix, 0.0,
				\hpfreq, 10,
				\rq, 0.1,
				\posenv, Pseq([
					[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
				],inf),
				\posenv, Pseq([
					[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
				],inf),
				\pos, 0.1 * [1,2,3,4,5,10,20],
				\levelScale, 8*2,
				\timeScale, 2,
				\range, 0.0007,
				//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
				\ffreq, 1000,
				\note, Pseq([
					0,
				],inf).stutter(8),
				\octave, 3,
				\bufnum, BufDef.stereo('voices/kaspi.flac'),
				\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.3,0.5,0.21) ],
				],inf),
				\legato, 8.0,
				\dur, 1,
				\isRest, Pseq([
					1,0,0,0,
					0,0,0,0,
				],1).coin.not,
				\amp, PmodEnv(Pseq([0.01,1]*0.081,1), 8,\exp).loop,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\balienrise2, 
	Ppar([
			Pbind(
				\instrument, \oscsampler3,
				\pos, 0.42,
				//\fshift, -148,
				\lpmix, 0.41,
				\hpmix, 0.0,
				\hpfreq, 10,
				\rq, 0.1,
				\posenv, Pseq([
					[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
				],inf),
				\posenv, Pseq([
					[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
				],inf),
				\pos, 0.1 * [1,2,3,4,5,10,20],
				\levelScale, 8*2,
				\timeScale, 2,
				\range, 0.00007,
				//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
				\ffreq, 8000,
				\note, Pseq([
					0,
				],inf).stutter(8),
				\octave, 5,
				\bufnum, BufDef.stereo('voices/kaspi.flac'),
				\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.3,0.5,0.21) ],
				],inf),
				\legato, 8.0,
				\dur, 1,
				\isRest, Pseq([
					1,0,0,0,
					0,0,0,0,
				],1).coin.not,
				\amp, 0.41 * Pkey(\amp),
				\amp, PmodEnv(Pseq([0.01,1]*0.041,1), 8,\exp).loop,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\balienrise3, 
	Ppar([
		Pmono(
			 \oscsampler3,
			\pos, 0.82,
			//\fshift, -148,
			\lpmix, 0.41,
			\hpmix, 0.0,
			\hpfreq, 10,
			\rq, 0.1,
			\posenv, Pseq([
				[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
			],inf),
			\posenv, Pseq([
				[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
			],inf),
			//\pos, 0.1 * [1,2,3,4,5,10,20]+1,
			\pos, 2.5,
			\levelScale, 100,
			\timeScale, 8,
			\range, 0.0017,
			//\range, PmodEnv(Pseq([5,12,16]*0.0001,1), 8).loop,
			\range, 0.0051,
			//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
			\ffreq, 400,
			\note, Pseq([
				0,12,4,3,
			],inf).stutter(8),
			//\freq, PmodEnv(Pexprand(0.4,5,3), 4,\exp).loop,
			\freq, 2*~t,
			\octave, 0,
			\bufnum, BufDef.stereo('voices/kaspi.flac'),
			\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.5,0.21) ],
			],inf),
			\dur, 1/4,
			\amp, 0.31,
			//\amp, PmodEnv(Pseq([1,1]*0.041,1), 8,\exp).loop,
			\out, BusDef(\alien, \audio),
		),
		Pmono(\fx_greyhole,
			\size, 0.0,
			\diff, 0.070700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.010000000149012,
			\modFreq, 1/4.0*~t,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\mix, 0.5,
			\inbus, BusDef(\alien, \audio),
			\addAction, \addToTail,
			\damp, PmodEnv(Pseq([1,0,],4), 8).loop,
			\delay, 1.01/~t,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\alien1, \audio),
		),
		
		Pmono(\nappypool1,
			\inbus, BusDef(\alien1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.436974789916,
			'gain', 0.69865546218487,
			'fb', 0.0001,
			'delay2', 0.50001001,
			'delay', ~pmodenv.(Pseq([0.1000001,0.02],inf), 8).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\balienrise4, 
	Ppar([
		Pmono(
			 \oscsampler3,
			\pos, 0.82,
			//\fshift, -148,
			\lpmix, 0.41,
			\hpmix, 0.0,
			\hpfreq, 10,
			\rq, 0.1,
			\posenv, Pseq([
				[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
			],inf),
			\posenv, Pseq([
				[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
			],inf),
			//\pos, 0.1 * [1,2,3,4,5,10,20]+1,
			\pos, 2.5,
			\levelScale, 42,
			\timeScale, 8,
			//\range, PmodEnv(Pseq([5,12,16]*0.0001,1), 8).loop,
			\range, 0.0001,
			//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
			\ffreq, 400,
			\note, Pseq([
				0,12,4,3,
			],inf).stutter(8),
			//\freq, PmodEnv(Pexprand(0.4,5,3), 4,\exp).loop,
			\freq, 60*~t,
			\octave, 0,
			\bufnum, BufDef.stereo('voices/kaspi.flac'),
			\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.5,0.21) ],
			],inf),
			\dur, 1/4,
			\amp, 0.31,
			//\amp, PmodEnv(Pseq([1,1]*0.041,1), 8,\exp).loop,
			\out, BusDef(\alien, \audio),
		),
		Pmono(\fx_greyhole,
			\size, 0.0,
			\diff, 0.070700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.010000000149012,
			\modFreq, 1/4.0*~t,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\mix, 0.5,
			\inbus, BusDef(\alien, \audio),
			\addAction, \addToTail,
			\damp, PmodEnv(Pseq([1,0,],4), 32).loop,
			\delay, 1.01/~t,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\alien1, \audio),
		),
		
		Pmono(\nappypool1,
			\inbus, BusDef(\alien1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.436974789916,
			'gain', 0.69865546218487,
			'fb', 0.0001,
			'delay2', 0.50001001,
			'delay', PmodEnv(Pseq([0.1000001,0.00002],inf), 32,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', PmodEnv(Pseq([10,12002],1), 32,\exp).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\alien2, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\alien2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([90,20000],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\gain, 0.4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\balienshort1, 
	Pfindur(20,Ppar([
		Pmono(
			 \oscsampler3,
			\pos, 0.82,
			//\fshift, -148,
			\lpmix, 0.41,
			\hpmix, 0.0,
			\hpfreq, 10,
			\rq, 0.1,
			\posenv, Pseq([
				[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
			],inf),
			\posenv, Pseq([
				[ Env([0.000,0.0002,0.0181].integrate.postln,[0.12,8.4]) ],
			],inf),
			//\pos, 0.1 * [1,2,3,4,5,10,20]+1,
			\pos, 4.3,
			\levelScale, 14,
			\timeScale, 1,
			//\range, PmodEnv(Pseq([5,12,16]*0.0001,1), 8).loop,
			\range, 0.0001,
			//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
			\ffreq, 400,
			\note, Pseq([
				0,12,4,3,
			],inf).stutter(8),
			//\freq, PmodEnv(Pexprand(0.4,5,3), 4,\exp).loop,
			\freq, 60*~t,
			\freq, PmodEnv(Pseq([1,8420],1), 2,\exp).loop,
			\octave, 0,
			\bufnum, BufDef.stereo('voices/kaspi.flac'),
			\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.3,0.5,0.01) ],
			],inf),
			\dur, 1/4,
			\amp, 0.31,
			//\amp, PmodEnv(Pseq([1,1]*0.041,1), 8,\exp).loop,
			\out, BusDef(\alien, \audio),
		),
		Pmono(\fx_greyhole,
			\size, 2.0,
			\diff, 0.070700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.010000000149012,
			\modFreq, 1/4.0*~t,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\mix, 0.5,
			\inbus, BusDef(\alien, \audio),
			\addAction, \addToTail,
			\damp, PmodEnv(Pseq([1,0,],4), 2).loop,
			\delay, 1.01/8/~t,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\alien1, \audio),
		),
		
		Pmono(\nappypool1,
			\inbus, BusDef(\alien1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.436974789916,
			'gain', 0.69865546218487,
			'fb', 0.0001,
			'delay2', 0.50001001,
			'delay', PmodEnv(Pseq([0.0000001,0.70002],inf), 2,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', PmodEnv(Pseq([10,1002],1), 2,\exp).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\alien2, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\alien2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([90,20000,2e4],1), 1,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\gain, 0.8,
		),
	]))
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.82,
			//\fshift, -148,
			\lpmix, 0.41,
			\hpmix, 0.0,
			\hpfreq, 10,
			\rq, 0.1,
			\posenv, Pseq([
				[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
			],inf),
			\posenv, Pseq([
				[ Env([0.000,0.0002,0.0181].integrate.postln,[0.12,8.4]) ],
			],inf),
			//\pos, 0.1 * [1,2,3,4,5,10,20]+1,
			\pos, 1.0 + Pseg(Pseq([0,1],inf),8),
			\levelScale, 24,
			\timeScale, 1,
			//\range, PmodEnv(Pseq([5,12,16]*0.0001,1), 8).loop,
			\range, 0.0001,
			//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
			\ffreq, 400,
			\note, Pseq([
				0,12,4,3,
			],inf).stutter(8),
			//\freq, PmodEnv(Pexprand(0.4,5,3), 4,\exp).loop,
			\freq, 60*~t,
			\freq, PmodEnv(Pseq([1,8420],1), 32,\exp).loop,
			\octave, 0,
			\bufnum, BufDef.stereo('voices/kaspi.flac'),
			\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.3,0.5,0.01) ],
			],inf),
			\dur, 1/4,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 0,1,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.071,
			//\amp, PmodEnv(Pseq([1,1]*0.041,1), 8,\exp).loop,
			\out, BusDef(\alien, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\alien, \audio),
			\addAction, \addToTail,
			\delay, 1/12/~t,
			\delay, PmodEnv(Pseq([1/12,1/12.1,1/32]/~t,1), Pseq([12,4])).loop,
			\decay, 16/~t,
			\diffmul, PmodEnv(Pseq([1.0001,1.01,1.5],41), 8).loop,
			\mix, 0.3,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \olok,
			\note, Pstep(Pseq([
				12,12,11,11,Pseq([5],4),
			],inf),1),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.82,
			//\fshift, -148,
			\lpmix, 0.41,
			\hpmix, 0.0,
			\hpfreq, 10,
			\rq, 0.1,
			\posenv, Pseq([
				[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
			],inf),
			\posenv, Pseq([
				[ Env([0.000,0.0002,0.0181].integrate.postln,[0.12,8.4]) ],
			],inf),
			//\pos, 0.1 * [1,2,3,4,5,10,20]+1,
			\pos, 1.4 + Pseg(Pseq([0,0.0001],inf),8),
			\levelScale, 2,
			\timeScale, 1,
			//\range, PmodEnv(Pseq([5,12,16]*0.0001,1), 8).loop,
			\range, 0.001,
			\range, ~pmodenv.(Pseq([1,2,142]*0.00003,1), 8).loop,
			\ffreq, 400,
			\note, Pseq([
				0,12,4,3,
			],inf).stutter(8),
			//\freq, PmodEnv(Pexprand(0.4,5,3), 4,\exp).loop,
			\freq, 3*~t,
			//\freq, PmodEnv(Pseq([1,8420],1), 32,\exp).loop,
			\octave, 0,
			\bufnum, BufDef.stereo('voices/kaspi.flac'),
			\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.1,0.1) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\amp, 0.171,
			//\amp, PmodEnv(Pseq([1,1]*0.041,1), 8,\exp).loop,
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				3,5,6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \olok,
			\note, Pstep(Pseq([
				12,12,11,11,Pseq([5],4),
			],inf),1) + Pseq([
				Pser([
					0
				],8*8),
				Pser([
					12
				],8*8),
				Pser([
					0,0,12,12,
				],8*8),
				Pser([
					0,4,-12,4,
				],8*8),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[735].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);
