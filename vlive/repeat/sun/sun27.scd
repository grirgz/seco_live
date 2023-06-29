~t = 300/4/60; TempoClock.default.tempo = ~t;


FileSystemProject.load("holis/synthdef.scd");
(
SynthDef(\hiyay, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\shortbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1+\del.kr(0.01)]).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\nappy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq = freq * \chord.kr(1!4);
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;
	//freq.poll(label:"freq");
	lfo1 = SinOsc.kr(0.1) * 0.001 * \lfo1range.kr(1);
	lfo3 = LFNoise1.kr(0.1!num).range(0.3,3); 
	lfo5 = LFNoise1.kr(0.1!num).range(0.3,0.7); 
	lfo2 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1, timeScale: lfo3, levelScale: lfo5);
	lfo4 = EnvGen.kr(Env([1,2,1],[0.7,0.8]), 1, timeScale: lfo3);
	cfreq = cfreq *.x [1 - lfo1,1 + lfo1] * [ [1/2,1,2,7,9] ];
	amps = [0.6,1,0.6,0.1,0.1];
	cfreq.debug("cfreq");
	sig = SelectX.ar( LFNoise1.kr(1/2!num).range(0.0,1.0) ,[
		SinOsc.ar(cfreq) * amps,
		LFSaw.ar(cfreq) * amps,
	].collect(_.flatten)) * 5;
	sig.debug("sig");
	//sig = sig * ( SinOsc.ar(freq/2 * ( SinOsc.ar(freq/4 + Rand(0.0,1!sig.size)) * 0.71 + 1 )) * 0.7 + 1 );
	sig = sig * sig.fold( ( SinOsc.kr(0.11) * 0.1 + 1 ).neg, ( SinOsc.kr(0.3) * 1 + 1 ) );
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).poll, \rq.kr(0.5) * lfo4);
	sig = RLPF.ar(sig, ( \lpf.kr(10001.1) * lfo2 ).clip(10,20000), \rq.kr(0.5) * lfo4);
	sig = HPF.ar(sig,\hpf.kr(30));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\iron, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig.fold( SinOsc.ar( (1..8)/8 * \foldfreq.kr(1), (1..8) ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + (sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ) * \panfreq.kr(1));
	}) * \panwidth.kr(1));
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * \gain.kr(18);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(),
))).add;
);

///


(
SynthDef(\freecordeenv, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1, timeScale=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env2 = EnvGen.kr(\fmrenv.kr(Env([1,1,1],[0.1,1.8])), 1, timeScale:timeScale);
	env3 = EnvGen.kr(\fmampenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env4 = EnvGen.kr(\amrenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env5 = EnvGen.kr(\amampenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread * env1 + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2) * env2) * \fmamp.kr(1) * env3 + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2) * env4) * \amamp.kr(1) * env5 + 1 );
	sig.debug("sig");
	sig = sig * 0.3;
	sig = SelectX.ar( LFNoise1.ar((1..8)/12 * \selratio.kr(1)).range(0,sig.size-1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\freecordeenv2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1, timeScale=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env2 = EnvGen.kr(\fmrenv.kr(Env([1,1,1],[0.1,1.8])), 1, timeScale:timeScale);
	env3 = EnvGen.kr(\fmampenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env4 = EnvGen.kr(\amrenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env5 = EnvGen.kr(\amampenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread * env1 + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2) * env2) * \fmamp.kr(1) * env3 + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2) * env4) * \amamp.kr(1) * env5 + 1 );
	sig.debug("sig");
	sig = sig * 0.3;
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = SelectX.ar( LFNoise1.ar((1..8)/12 * \selratio.kr(1)).range(0,sig.size-1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

///


(
SynthDef(\sawfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\olok, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\simplegran_adsrcomp, { arg out=0, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig1 = Resonz.ar(sig, ( \resfr.kr(4) * \gfreq.kr ).clip(20,20000), \bwr.kr(7.3));
	sig = SelectX.ar(\resmix.kr(0), [sig, sig1]);
	sig1 = RLPF.ar(sig, ( \lpfr.kr(1.1) * \gfreq.kr ).clip(20,20000), \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0), [sig, sig1]);
	sig = sig * \pregain.kr(1);
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.009), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\largechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,0.32,2.1],[0.7,1.8])), 1);
	freq = freq * [1/4,1/2,1,2,3,4,5,6,7];
	sig = LFSaw.ar(freq *.x [1,1+\diff.kr(0.00001)]);
	sig = sig + SinOsc.ar(freq,mul:\sinamp.kr(0.2));
	sig = RLPF.ar(sig, ( \lpfr.kr(8.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

////

(
SynthDef(\fx_meuble, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num=20;
	sig = in;
	sig = num.collect { arg idx;
		var isig;
		isig = BPF.ar(sig, idx.linexp(0,num-1,60,10000).postln,0.1);
		isig = Amplitude.kr(isig).lagud(0,rrand(0.41,1.5)*7)*4 * Pulse.ar(50 * exprand(1,2.6));
		isig;
	};
	sig = sig.mean;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fx_fat, { arg out=0, gate=1, lfofreq=0.5, lfoamp = 0.1, pan=0;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=10;
	sig = in;
	lfo1 = SinOsc.ar(1) * 0.1 + 1; 
	lfo2 = LFNoise1.ar(1) * 0.1 + 1; 
	lfo3 = LFNoise1.ar(1) * 0.1 + 1; 

	//sig = DelayL.ar(sig, 0.01 * lfo1) + sig;
	//sig = FreqShift.ar(sig, 0.01 * lfo2) + sig;
	sig = sig.collect { arg isig, idx;
		var xsig;
		//xsig = (sig.wrapAt(idx+1)*\crosstalk.kr(0.2));
		xsig = sig;
		isig = FreqShift.ar(isig + xsig, ExpRand(\shiftmin.kr(0.001),\shiftmax.kr(0.1)!num) * ( LFNoise1.kr(lfofreq!num) * lfoamp + 1 )).mean + isig;
		isig = DelayL.ar(isig, \delaymax.kr(0.1), ExpRand(\delaymin.kr(0.001),\delaymax.kr!num) * ( LFNoise1.kr(lfofreq!num) * lfoamp + 1 )).mean + isig;
		isig;
	};
	//sig = sig ++ [ SinOsc.ar(100)  ];
	//sig = Splay.ar(sig, \spread.kr(0.8), 0.8, );
	sig.debug("sig");
	sig = Pan2.ar(sig, pan + ( [1,-1] * \panspread.kr(0.8) ) + LFNoise1.kr(\panlfofreq.kr(1/2)!2,mul:\panlfoamp.kr(0.2)), 1).mean;
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fx_fatecho, { arg out=0, gate=1, lfofreq=0.5, lfoamp = 0.1, pan=0;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=10;
	var fbin;
	var fbsig;
	sig = in;

	fbin = FbNode(2);
	sig = sig + ( DelayL.ar(fbin, \fbdelaymax.kr(2), \fbdelay.kr(0.2)) * \fb.kr(0.7) );

	sig = sig.collect { arg isig, idx;
		var xsig;
		//xsig = (sig.wrapAt(idx+1)*\crosstalk.kr(0.2));
		xsig = 0;
		isig = FreqShift.ar(isig + xsig, ExpRand(\shiftmin.kr(0.001),\shiftmax.kr(0.1)!num) * ( LFNoise1.kr(lfofreq!num) * lfoamp + 1 )).mean + isig;
		isig = DelayL.ar(isig, \delaymax.kr(0.1), ExpRand(\delaymin.kr(0.001),\delaymax.kr!num) * ( LFNoise1.kr(lfofreq!num) * lfoamp + 1 )).mean + isig;
		isig;
	};

	//sig.debug("sig");
	sig = Pan2.ar(sig, pan + ( [1,-1] * \panspread.kr(0.8) ) + LFNoise1.kr(\panlfofreq.kr(1/2)!2,mul:\panlfoamp.kr(0.2)), 1).mean;

	fbsig = sig;
	fbsig = HPF.ar(fbsig, \hpf.kr(30));
	fbin.write(fbsig);

	//sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);

	sig = Limiter.ar(sig, \limiter.kr(0.4));

	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

//////////// rdn 


//~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

	SynthDef(\nappypool1, { arg out=0, gate=1;
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
		thisThread.randSeed = 752202.0;
		si = sig;
		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
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

		
Pdef(\nappypool1, Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.13865546218487,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.31318310052438,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 100.0,
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
));

		
);



///////////// lib

(
Pdef(\part, Pdef(\housedrum, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
	])
)).play;
);

(
Pdef(\igorbreak, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
		\legato, 1,
		\st, 272/4/60,
		\speed, 1 * ~t / Pkey(\st),
		\pos, Pseq([
			Pseq([
				Pser([
					(0..2)*2+48,
					//(0..2)+38,
				].flat,32-4),
				(0..3)+30,
			].flat,3),
			//Pseq([
				//Pser([
					//(0..5)+36,
				//].flat,16-4),
				//36,37,38,39,
			//],4),
		].flat,inf)/8 / Pkey(\st),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/8,
		\gain, 1/10,
		//\isRest, true,
		//\out, BusDef(\sendbus2, \audio),
	),
);
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

(
Pdef(\part, Pdef(\basicbreak2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[225].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0.41, 0,0,0.8,0,
				0.41,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[378].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],1),

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0.1,0, 0.1,0,0.1,0,
				0,0,0.5,0.1, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			]/2,inf),
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
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
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





/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\mtranspose, Pstep(Pseq([
			0,3,
		],inf),4),
		\octave, 3,
		\dur, 4,
		\legato, 1,
		\amp, 0.2,
	)
).play;
);

(
	// trance
Pdef(\part, Pdef(\zedpart, 
	Ppar([
	Pbind(
		\instrument, \shortbass,
		\degree, Pseq([0],inf),
		\mtranspose, Pstep(Pseq([
			0,3,
		],inf),4),
		\octave, 3,
		\dur, 4,
		\legato, 1,
		\amp, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0.4,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,0.3, 1,0,0.3,1,
				0,1,0.3,0.3, 1,0.3,0.3,1,
				0,1,0,0.3, 1,0,0.3,1,
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
			\out, BusDef(\sendbus1, \audio),
			\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
	// trance hi
Pdef(\part, Pdef(\zedpart, 
	Ppar([
	Pbind(
		\instrument, \shortbass,
		\degree, Pseq([0],inf),
		\mtranspose, Pstep(Pseq([
			0,3,
		],inf),4),
		\octave, 3,
		\dur, 4,
		\legato, 1,
		\amp, 0.1,
	),
	Pbind(
		\instrument, \hiyay,
		\degree, Pseq([
			0,\r,2,\r,4,
			0,0,0,2,4,
		],inf),
		\mtranspose, Pstep(Pseq([
			0,3,
		],inf),4),
		\dur, 1/16,
		\amp, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,0.3, 1,0,0.3,1,
				0,1,0.3,0.3, 1,0.3,0.3,1,
				0,1,0,0.3, 1,0,0.3,1,
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
			\out, BusDef(\sendbus1, \audio),
			\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),
		
	])
)).play;
);


(
	// trance hi2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shortbass,
			\degree, Pseq([0],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 3,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \hiyay,
			\degree, Pseq([
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r,\r,\r] ).choose }.dup(4),8)
				}),
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r,\r,\r] ).choose }.dup(8),8)
				}),
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r,\r,\r] ).choose }.dup(4),8)
				}).repeat(2),
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r] ).choose }.dup(16),8)
				}),
			],inf),
			\fmamp, ~pmodenv.(Pseq([0,1,0.31,1.4],1), 8).loop,
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,0.3, 1,0,0.3,1,
				0,1,0.3,0.3, 1,0.3,0.3,1,
				0,1,0,0.3, 1,0,0.3,1,
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
			\out, BusDef(\sendbus1, \audio),
			\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),

	])
)).play;
);

(
	// trance hi3
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shortbass,
			\degree, Pseq([0],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 3,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \hiyay,
			\degree, Pseq([
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r,\r,\r] ).choose }.dup(4),8)
				}),
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r,\r,\r] ).choose }.dup(8),8)
				}),
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r,\r,\r] ).choose }.dup(4),8)
				}).repeat(2),
				Plazy({ arg ev;
					Pseq({ ( (0..4)++[\r,\r] ).choose }.dup(16),8)
				}),
			],inf),
			\fmamp, ~pmodenv.(Pseq([0,1,0.31,1.4],1), 8).loop,
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,0.3, 1,0,0.3,1,
				0,1,0.3,0.3, 1,0.3,0.3,1,
				0,1,0,0.3, 1,0,0.3,1,
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
			\out, BusDef(\sendbus1, \audio),
			\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),

	])
)).play;
);


(
	// trance various hi
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shortbass,
			\degree, Pseq([0],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 3,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\degree, Pseq([
				[0+7,2,4-7,6b],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8*2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([

				7,0,0,0, 0,0,0,0,
				1,0.1,1,0, 0,2,0,0,
				6,0,0,0, 0,0,0.1,0.1,
				1,0.1,1,0, 0,2,0,0,

				6,0,0,0, 0,0,0.1,0.1,
				1,0,1,0.1, 0.1,2,0,0.1,
				1,0,0,1, 0.1,0.1,1,0,
				1,0.1,1,0, 0,2,0,0,
				//0.1,1,2,0,
			],inf),
			\env1, Pseq([
				[ Env([2.00,0.7,7.midiratio/2,7.midiratio/2],[0.01,0.08,3.4]) ]
			],inf),
			\env2, Pseq([
				[ Env([0.6,0.7,0.4,0.7],[0.01,0.08,3.4]) ]
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\hrq, 0.5,
			\hpfr, 1/4,
			\mixlpf, 1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2.34,1), 1).loop,
			\amp, 0.1/8/4,
		),
		
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				[0+7,2,4-7,9],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0.3,0.7,0, 0.7,0.7,0.1,0.8,
			],inf).coin.not,
			\decay, 0.14,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				0+7,2,4-7,9,
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				0,0,0,0, 0,0.1,0,0.1,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\degree, Pseq([
				0,7,4,
			],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0.1,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,0.3, 1,0,0.3,1,
				0,1,0.3,0.3, 1,0.3,0.3,1,
				0,1,0,0.3, 1,0,0.3,1,
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
			\out, BusDef(\sendbus1, \audio),
			\lag, -0.04,
		),
	])
)).play;
);

(
	// trance various hi + holes
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shortbass,
			\degree, Pseq([0],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 3,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\degree, Pseq([
				[0+7,2,4-7,9],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8*2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([



				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.1,0.1,1,0,
				1,0.1,1,0, 0,2,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//0.1,1,2,0,
			],inf),
			\env1, Pseq([
				[ Env([2.00,0.7,7.midiratio/2,7.midiratio/2],[0.01,0.08,3.4]) ]
			],inf),
			\env2, Pseq([
				[ Env([0.6,0.7,0.4,0.7],[0.01,0.08,3.4]) ]
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\hrq, 0.5,
			\hpfr, 1/4,
			\mixlpf, 1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2.34,1), 1).loop,
			\amp, 0.1/8/4,
		),
		
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				[0+7,2,4-7,9],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0.3,0.7,0, 0.7,0.7,0.1,0.8,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\decay, 0.14,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				0+7,2,4-7,9,
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0.1,0,0.1,
					4,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\degree, Pseq([
				0,12,4,
			],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0.1,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					Pseq([
						1,0,0.4,0, 0,0,0.4,0,
						1,0,0.4,0, 1,0,0.4,0,
					],3),
					1,0,0.4,0, 1,0,0.4,0,
					0,0,0.4,0, 0,0,0.4,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 0,0,1,1,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
				],8*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],3),

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0,0, 1,0,0,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0.3,0.3, 1,0.3,0.3,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11/3 * Pkey(\vel),
			//\out, BusDef(\sendbus1, \audio),
			//\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.6],7)
			],inf),
		),
	])
)).play;
);


(
	// trance various hi + holes + string
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				Pseq([
					\stringsx,
				],6),
				Pseq([
					\stringsx2,
				],2),
			],inf),
			\degree, Pseq([
				[ 0+7,2,4+7 ],
				[ 0+7,2,4+7,5 ],
				[ 0+7,2,4+7,6 ],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 4,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
				],6),
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,
				],6),
				0.1,0,
			],inf),
			\lag, Pseq([
				Pseq([
					0
				],6),
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
				0, 2,
				0, 2,
				0,1,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\pos, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\st, 129/4/60,
			\pos, 1/2 +0.02 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\legato, 2.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					Pseq([
						1,0,0.4,0, 0,0,0.4,0,
						1,0,0.4,0, 1,0,0.4,0,
					],3),
					1,0,0.4,0, 1,0,0.4,0,
					0,0,0.4,0, 0,0,0.4,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 0,0,1,1,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
				],8*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],3),

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0,0, 1,0,0,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0.3,0.3, 1,0.3,0.3,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11/3 * Pkey(\vel),
			//\out, BusDef(\sendbus1, \audio),
			//\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.6],7)
			],inf),
		),
		
	])
)).play;
);

(
	// breakbeat (rdn)
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pser([
						(0..2)+36,
						(0..2)+42,
						(0..2)+36,
						(0..2)+41,
						(0..2)+36,
					].flat,32-4),
					36,37,38,39,
				],4) - Pseq((0..32),inf).stutter(32*4)
				//Pseq([
					//Pser([
						//(0..5)+36,
					//].flat,16-4),
					//36,37,38,39,
				//],4),
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
			//\isRest, true,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([ 0, 1/16, ]+(0),1),1/16).repeat(8),
				Pseq([
					0,10,4,10, 8,10,10,16,
					20,18,0,19, 8,7,4,7,
					//0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3
					0,4,4,4, 8,10,4,0,
					4,4,0,16, 8,7,7,4,
					0,4,4,0, 8,10,4,4,
					17,16,0,16, 8,7,7,4,
					0,10,10,10, 8,10,10,16,
					17,16,0,16, 8,7,4,7,

					//16,16,16,16,
					//0,0,8,0, 0,8,0,8,
					//0,2,2,0, 8,2,0,8,
				],inf)/16,

				//Pseg(Pseq([ 0, 1/2, ]+0,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+0,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+1,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+( 1/2 ),1),1/2),
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
	// breakbeat2 (rdn)
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+30,
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+10,
				].flat,4)
				//Pseq([
					//Pser([
						//(0..5)+36,
					//].flat,16-4),
					//36,37,38,39,
				//],4),
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
			//\isRest, true,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([ 0, 1/16, ]+(0),1),1/16).repeat(8),
				Pseq([
					0,10,4,10, 8,10,10,16,
					20,18,0,19, 8,7,4,7,
					//0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3
					0,4,4,4, 8,10,4,0,
					4,4,0,16, 8,7,7,4,
					0,4,4,0, 8,10,4,4,
					17,16,0,16, 8,7,7,4,
					0,10,10,10, 8,10,10,16,
					17,16,0,16, 8,7,4,7,

					//16,16,16,16,
					//0,0,8,0, 0,8,0,8,
					//0,2,2,0, 8,2,0,8,
				],inf)/16,

				//Pseg(Pseq([ 0, 1/2, ]+0,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+0,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+1,1),1/2),
				//Pseg(Pseq([ 0, 1/2, ]+( 1/2 ),1),1/2),
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
	// breakbeat + varhi
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+30,
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+10,
				].flat,3),
				Pseq([
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+30,
					Pser([
						0,\r,\r,
						\r,\r,0,
					].flat+22,32-8),
					Pseq([8,33],1).stutter(4)
				].flat,1)
				//Pseq([
					//Pser([
						//(0..5)+36,
					//].flat,16-4),
					//36,37,38,39,
				//],4),
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
			//\isRest, true,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([ 0, 1/16, ]+(0),1),1/16).repeat(8),
				Pseq([
					0,10,4,10, 8,10,10,16,
					20,18,0,19, 8,7,4,7,
					0,4,4,4, 8,10,4,0,
					4,4,0,16, 8,7,7,4,

					0,4,4,0, 8,10,4,4,
					17,16,0,16, 8,7,7,4,
					0,10,10,10, 8,10,10,16,
					17,16,0,16, 8,7,4,7,
				],3)/16,
				Pseq([
					//0,\r,\r,\r, 8.3,\r,\r,\r,
					//\r,\r,0,\r, 8,\r,25,0,
					//0,\r,\r,\r, 8.1,\r,\r,\r,
					//\r,\r,0,\r, 24,\r,0,24,
					//0,4,4,4, 8.3,\r,\r,8.3,
					//\r,8.3,0,\r, 8.3,4,\r,4,
					//0,8.3,\r,\r, 8.3,\r,\r,8.3,
					//\r,8.3,0,\r, 8.3,\r,\r,8.3,
					(0..2)+3,
					(0..2)+3,
					(0..2)+13,
					(0..2)+10,
					8,10,10,10,
				].flat/16,4),

			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			//\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \shortbass,
			\degree, Pseq([0],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 3,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\degree, Pseq([
				[0+7,2,4-7,6b],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8*2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([

				7,0,0,0, 0,0,0,0,
				1,0.1,1,0, 0,2,0,0,
				6,0,0,0, 0,0,0.1,0.1,
				1,0.1,1,0, 0,2,0,0,

				6,0,0,0, 0,0,0.1,0.1,
				1,0,1,0.1, 0.1,2,0,0.1,
				1,0,0,1, 0.1,0.1,1,0,
				1,0.1,1,0, 0,2,0,0,
				//0.1,1,2,0,
			],inf),
			\env1, Pseq([
				[ Env([2.00,0.7,7.midiratio/2,7.midiratio/2],[0.01,0.08,3.4]) ]
			],inf),
			\env2, Pseq([
				[ Env([0.6,0.7,0.4,0.7],[0.01,0.08,3.4]) ]
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\hrq, 0.5,
			\hpfr, 1/4,
			\mixlpf, 1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2.34,1), 1).loop,
			\amp, 0.1/8/4,
		),
		
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				[0+7,2,4-7,9],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0.3,0.7,0, 0.7,0.7,0.1,0.8,
			],inf).coin.not,
			\decay, 0.14,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				0+7,2,4-7,9,
				0,12,2,14,	
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				0,0,0,0, 0,0.1,0,0.1,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\degree, Pseq([
				0,7,4,
				0,7,4,
				2,2-7,0+7,
				9,2,10,0,11,4,12
			],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0.1, 0.1,0,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
	// breakbeat + varhi2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+30,
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+10,
				].flat,3),
				Pseq([
					Pser([
						(0..2)*2+38,
						(0..2)+38,
					].flat,32-4),
					(0..3)+30,
					Pser([
						0,\r,\r,
						\r,\r,0,
					].flat+22,32-8),
					Pseq([8,33],1).stutter(4)
				].flat,1)
				//Pseq([
					//Pser([
						//(0..5)+36,
					//].flat,16-4),
					//36,37,38,39,
				//],4),
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
			//\isRest, true,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([ 0, 1/16, ]+(0),1),1/16).repeat(8),
				Pseq([
					0,10,4,10, 8,10,10,16,
					20,18,0,19, 8,7,4,7,
					0,4,4,4, 8,10,4,0,
					4,4,0,16, 8,7,7,4,

					0,4,4,0, 8,10,4,4,
					17,16,0,16, 8,7,7,4,
					0,10,10,10, 8,10,10,16,
					17,16,0,16, 8,7,4,7,
				],3)/16,
				Pseq([
					//0,\r,\r,\r, 8.3,\r,\r,\r,
					//\r,\r,0,\r, 8,\r,25,0,
					//0,\r,\r,\r, 8.1,\r,\r,\r,
					//\r,\r,0,\r, 24,\r,0,24,
					//0,4,4,4, 8.3,\r,\r,8.3,
					//\r,8.3,0,\r, 8.3,4,\r,4,
					//0,8.3,\r,\r, 8.3,\r,\r,8.3,
					//\r,8.3,0,\r, 8.3,\r,\r,8.3,
					(0..2)+3,
					(0..2)+3,
					(0..2)+13,
					(0..2)+10,
					8,10,10,10,
				].flat/16,4),

			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			//\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \shortbass,
			\degree, Pseq([0],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\octave, 3,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\degree, Pseq([
				[0+7,2,4-7,6b],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8*2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([

				1.2,0,
			],inf),
			\env1, Pseq([
				[ Env([2.00,0.7,7.midiratio/2,7.midiratio/2],[0.01,0.08,3.4]) ]
			],inf),
			\env2, Pseq([
				[ Env([0.6,0.7,0.4,0.7],[0.01,0.08,3.4]) ]
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\hrq, 0.5,
			\hpfr, 1/4,
			\mixlpf, 1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2.34,1), 11).loop,
			\amp, 0.1/8/4,
		),
		
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				[0+7,2,4-7,9],
				[0+7,2,4-7],
				[0,2+7,4],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0.3,0.7,0, 0.7,0.7,0.1,0.8,
			],inf).coin.not,
			\decay, 0.14,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				0+7,2,4-7,9,
				0,12,2,14,	
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				0.7,0,1.7,0,0, 1.7,0.1,0.1,
				0.7,0,1.7,0,0, 1.7,0,0,
				0.7,0.1,0.7,0, 1.7,0,0,1,
				0.7,0,0.7,0, 1.7,0,0,1,
				0.1,0.1,0.7,0.1, 1.7,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\degree, Pseq([
				0,7,4,
				0,7,4,
				2,2-7,0+7,
				9,2,10,0,11,4,12
			],inf),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);


(
	// igorbreak 1
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pseq([
					Pfin(32-8, Pseq([
						Pseq([ 0,1,0,1, ],1)+10,
						Pseq([ 0,1,0,1, ],2)+14,
						Pseq([ 0,1,0,1, ],2)+10,
						Pseq([ 0,2,0,1, ],2)+14,
						Pseq([ 0,1,0,1, ],1)+21,
					//(0..7)+4,8,8,
					].flat,inf)),
					(0..7)+4
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pdef(\basicbreak),
		
	])
)).play;
);

(
	// igorbreak 2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[225].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0.41, 0,0,0.8,0,
				0.41,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[378].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],1),

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							Pseq([ 0,0,4, ],1)+30,
						].flat,inf)),
						(0..7)+4,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							Pseq([
								0,0,2,0,0,2,0,2,
								0,2,8,0,2,0,0,2,
								
							],inf)+30,
						].flat,inf)),
						(0..7)+8,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pdef(\basicbreak),
	])
)).play;
);

(
	// igorbreak 3
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basicbreak2),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							(0..5)+12,
							(0..7)+12,
							0,0,
						].flat,inf)),
						(0..7)+34,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
	])
)).play;
);


(
	// igorbreak 3
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf),
			\sustain, 0.021 * Pseq([
				4,1,2,1, 1,1,1,1,
				4,1,1,1, 1,4,1,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
				//1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
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
				1,1,1,1, 1,1,1,1,
			],inf),
			\vel, Pseq([
				1,1/2,1,1/4,
			],inf),
			\sustain, Pkey(\vel)**2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
		),
	])
)).play;
);


(
	// breaks + rnd noise bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							6,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							2,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			]/2,inf),
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
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				0.2,0,1,0, 0.2,0.2,1,0.2,
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				Pser([
					0,-2,0,
				],8),
				Pser([
					0,-5,0,
				],8),
			],inf).stutter(4),
			\mtranspose, Pstep(Pseq([
				0,0,
			],inf),4),
			\octave, 3,
			\fmamp, 0.4,
			\legato, Pseq([
				0.7,0,1.7,0,0, 1.7,0.1,0.1,
				0.7,0,1.7,0,0, 1.7,0,0,
				0.7,0.1,0.7,0, 1.7,0,0,1,
				0.7,0,0.7,0, 1.7,0,0,1,
				0.1,0.1,0.7,0.1, 1.7,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							6,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							2,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			]/2,inf),
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
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				0.2,0,1,0, 0.2,0.2,1,0.2,
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				1.2,1.2,1,1, 1.1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0.8,1,0.9,0.9,
				
			],inf)*0.9,
			\pos, Pseq([
				Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				(0..7)+40,
				(0..3)+90, (0..3)+90,
				(0..7)+90,
				(0..7)+110,

				(0..7)+40,
				(0..3)+88, (0..3)+90,
				(0..7)+92,
				(0..7)+70,

				(0..7)+40,
				(0..3)+90, (0..3)+88,
				(0..7)+90,
				(0..7)+110,

				(0..7)+40,
				(0..3)+90, (0..3)+90,
				(0..7)+90,
				(0..7)+70,
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							6,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
					Pseq([
						Pfin(32-8, Pseq([
							2,
						].flat,inf)),
						(0..7)+29,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			]/2,inf),
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
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				0.2,0,1,0, 0.2,0.2,1,0.2,
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				(0..7)/10+1
			].flat,inf)*0.9,
			\pos, Pseq([
				4,9,2,1,
				1,9,32,11,
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				(0..7)+130,
				(0..7)+50,
				(0..7)+13,
				(0..7)+50,
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		),
		Pseq([
			Event.silent(12),
			Pfindur(4,Pbind(
				\instrument, \hiyay,
				//\degree, Pseq([
				//0,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,0,\r, \r,\r,\r,-1,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,-2,
				//],inf),
				\freq, Pexprand(300.0,10000,inf).stutter(8),
				\legato, 0.1,
				\octave, 7,
				\mtranspose, Pstep(Pseq([
					0,3,
				],inf),4),
				\dur, Pexprand(1/16,1,inf).stutter(8),
				\amp, 0.1,
			)),
		],inf),
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[225].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0.41, 0,0,0.8,0,
				0.41,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[378].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],1),

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						Pfin(32-8, Pseq([
							(0..5)+12,
							(0..7)+12,
							0,0,
						].flat,inf)),
						(0..7)+34,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0.1,0, 0.1,0,0.1,0,
				0,0,0.5,0.1, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			]/2,inf),
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
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/8,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				Pseq([ 1,1,2,1, 1,1,2,1, ]/2,1),
				0.2,0,1,0, 0.2,0.2,1,0.2,
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				(0..7)/10+1
			].flat,inf)*0.9,
			\pos, Pseq([
				4,9,2,1,
				1,9,32,11,
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				(0..7)+130,
				(0..7)+50,
				(0..7)+13,
				(0..7)+50,
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				(0..3)/10+1,
				(0..3).reverse/10+1
			].flat,inf)*0.9,
			\pos, Pseq([
				4,9,2,1, 1,9,32,11,
				\r,\r,\r,\r, \r,\r,\r,\r,
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+60,
				].flat,1),
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+62,
				].flat,1),

				//Pseq([
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, (0..3)+86,
				//].flat,1),
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+72,

				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+42,
			].flat/8,inf),
			\speed, 0.8,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				0,0,0,0,
				0,0,0,-1,
			],inf).stutter(2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\freq, Pseg(Pseq([80.midicps,78.midicps],1),4).loop,
			//\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\decay, 1.44,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, Pseq([
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.7,
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.07,
			],inf),
			//\coef, 0.005,
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pn(11,64-8),
				Pn(\r,8),
				Pn(65,8),Pn(11,64-8-8),
				Pn(81,6),\r,\r
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/11,
			//\isRest, true,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+60,
				].flat,1),
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+62,
				].flat,1),

				//Pseq([
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, (0..3)+86,
				//].flat,1),
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+72,

				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+42,
			].flat/8,inf),
			\speed, 0.8,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \shortbass,
			//\freq, 100,
			//\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\note, Pstep(Pseq([
				0,
				-1,
			],inf),4),
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),
		Pbind(
			\instrument, \shortbass,
			//\freq, 100,
			//\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\note, Pstep(Pseq([
				0,
				-1,
			],inf),4)+9,
			\octave, 5,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\isRest, Pseq([
				1,0.3,
			],inf).coin.not,
			\dur, 1/12 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),
		Pbind(
			\instrument, \vlip,
			\note, Pstep(Pseq([
				0,
				-1,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0.1,0,0.1,
					4,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


////////////////////////

(
Pdef(\part, Pdef(\pintro1, 
	Ppar([
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
			//\out, BusDef(\sendbus1, \audio),
		),
		//Pmono(\fx_freeverb2,
			//\inbus, BusDef(\ifx1, \audio),
			//\out, BusDef(\ifx2, \audio),
			//\addAction, \addToTail,
			//\room, 3,
			//\mix, 1,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		//Pmono(\fx_hpf,
			//\inbus, BusDef(\ifx2, \audio),
			//\hpf, Pseq([
				//~pmodenv.(Pseq([8000,1],1), 8, 1, -2),
				//Pn(1,inf),
			//],inf),
			//\addAction, \addToTail,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pn(11,64-8),
				Pn(\r,8),
				Pn(65,8),Pn(11,64-8-8),
				Pn(81,6),\r,\r
			].flat,inf)/8 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/11 * Pseg(Pseq([0,1,Pn(1,inf)],inf),8),
			//\isRest, true,
			//\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pmid1, 
	Ppar([
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		Ptpar([
			8, Pbind(
			   	\instrument, \playersec,
			   	\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			   	\legato, 1,
			   	\st, 272/4/60,
			   	\speed, 1 * ~t / Pkey(\st),
			   	\pos, Pseq([
			   		Pn(11,32-8),
			   		Pn(\r,8),
			   		Pn(65,32-8),
			   		Pn(81,6),\r,\r
			   	].flat,inf)/8 / Pkey(\st),
			   	\adsr, Pseq([
			   		[ Env.adsr(0.01,0.1,0.8,0.1) ],
			   	],inf),
			   	\dur, 1/8,
			   	\gain, 1/11,
			   	//\isRest, true,
			   	//\out, BusDef(\sendbus2, \audio),
			   ),
		]),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+60,
				].flat,1),
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+62,
				].flat,1),

				//Pseq([
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, (0..3)+86,
				//].flat,1),
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+72,

				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+42,
			].flat/8,inf),
			\speed, 0.8,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pmid2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				(0..3)/10+1,
				(0..3).reverse/10+1
			].flat,inf)*0.9,
			\pos, Pseq([
				4,9,2,1, 1,9,32,11,
				\r,\r,\r,\r, \r,\r,\r,\r,
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+60,
				].flat,1),
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+62,
				].flat,1),

				//Pseq([
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, (0..3)+86,
				//].flat,1),
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+72,

				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+42,
			].flat/8,inf),
			\speed, 0.8,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				0,0,0,0,
				0,0,0,-1,
			],inf).stutter(2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\freq, Pseg(Pseq([80.midicps,78.midicps],1),4).loop,
			//\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\decay, 1.44,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, Pseq([
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.7,
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.07,
			],inf),
			//\coef, 0.005,
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
	// trance hi
Pdef(\part, Pdef(\ptran1, 
	Ppar([
	Pbind(
		\instrument, \shortbass,
		\degree, Pseq([0],inf),
		\mtranspose, Pstep(Pseq([
			0,3,
		],inf),4),
		\octave, 3,
		\dur, 4,
		\legato, 1,
		\amp, 0.1,
	),
	Pbind(
		\instrument, \hiyay,
		\degree, Pseq([
			0,\r,2,\r,4,
			0,0,0,2,4,
		],inf),
		\mtranspose, Pstep(Pseq([
			0,3,
		],inf),4),
		\dur, 1/16,
		\amp, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,0.3, 1,0,0.3,1,
				0,1,0.3,0.3, 1,0.3,0.3,1,
				0,1,0,0.3, 1,0,0.3,1,
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\vel),
			\out, BusDef(\sendbus1, \audio),
			\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\pmid2tran1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.3],7)
			],inf),
		),
	Pbind(
		\instrument, \shortbass,
		\degree, Pseq([0],inf),
		\mtranspose, Pstep(Pseq([
			0,-1,
		],inf),4),
		\octave, 3,
		\dur, 4,
		\legato, 1,
		\amp, 0.1,
	),
	Pbind(
		\instrument, \hiyay,
		\degree, Pseq([
			0,\r,2b,\r,4,
			0,0,0,2b,4,
		],inf),
		\mtranspose, Pstep(Pseq([
			0,-1,
		],inf),4),
		\dur, 1/16,
		\amp, 0.1,
	),
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				0,0,0,0,
				0,0,0,-1,
			],inf).stutter(2),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\freq, Pseg(Pseq([80.midicps,78.midicps],1),4).loop,
			//\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\decay, 1.44,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, Pseq([
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.7,
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.07,
			],inf),
			//\coef, 0.005,
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\pmid2rise, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				(0..3)/10+1,
				(0..3).reverse/10+1
			].flat,inf)*0.9,
			\pos, Pseq([
				4,9,2,1, 1,9,32,11,
				\r,\r,\r,\r, \r,\r,\r,\r,
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1 * Pseg(Pseq([0.1,1],inf),32),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+60,
				].flat,1),
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, \r,\r,\r,\r,
					\r,\r,\r,\r, (0..3)+62,
				].flat,1),

				//Pseq([
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, \r,\r,\r,\r,
					//\r,\r,\r,\r, (0..3)+86,
				//].flat,1),
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+72,

				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, \r,\r,\r,\r,
				//\r,\r,\r,\r, (0..3)+42,
			].flat/8,inf),
			\speed, 0.8,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				0,0,0,0,
				0,0,0,-1,
			],inf).stutter(2),
			\mtranspose, Pstep(Pseq([
				0,3,
			],inf),4),
			\freq, Pseg(Pseq([80.midicps,78.midicps],1),4).loop,
			//\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\decay, 1.44 * Pseg(Pseq([0,1],inf),32),
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, Pseq([
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.7,
				0.7,0.7,0.4,0.7, 0.1,0.7,0.4,0.07,
			],inf) * Pseg(Pseq([1,0.2],inf),32),
			//\coef, 0.005,
			\dur, 1/8,
			\amp, 0.1/6 * Pseg(Pseq([0.5,1],inf),32),
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000,8000,10000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\pmid3, 
	Ppar([
		Ptpar([
			12, Pseq([
				Pbind(
					\pos, Pseq([
						Pfin(32-8, Pseq([
							Pseq([ 0,1,0,1, ],1)+10,
							Pseq([ 0,1,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],2)+10,
							Pseq([ 0,2,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],1)+21,
							//(0..7)+4,8,8,
						].flat,inf)),
						(0..7)+4
					].flat/8,inf),
				)
			],inf)<>
			Pdef(\igorbreak),
			8, Pdef(\basicbreak),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('samplekit/vipere/metal.flac'),
				\speed, Pseq([
					1.2,1.2,1,1, 1.1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,

					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 0.8,1,0.9,0.9,

				],inf)*0.9,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,0, 1,1,0,1,
					1,1,0,1, 1,1,1,1,
					1,0,0,1, 1,1,0,1,

					1,1,1,1, 1,1,1,1,
					1,0,0,1, 1,0,1,0,
					1,1,1,1, 1,1,1,1,
					1,0,0,0, 0,0,1,1,

					1,1,1,1, 1,1,1,1,
					1,1,1,0, 1,1,0,1,
					1,1,0,1, 1,1,1,1,
					1,0,0,1, 1,1,0,1,

					1,1,1,1, 0,0,0,1,
					1,1,0,1, 1,1,1,0,
					1,1,1,1, 1,1,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\pos, Pseq([
					Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
					Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
					Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
					Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

					Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
					Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
					Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
					Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
					//(0..3)*2,
					//(0..7)*2+10,
				].flat/8,inf),
				\legato, 1,
				\dur, 1/8,
				\gain, 1/6,
			),

		]),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000,8000,10000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\lag, -0.04,
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 0.09865546218487,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', ~pmodenv.(Pseq([0.31,0.02],1), 32).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 100.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 217,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pmid4, 
	Ppar([
		Ppar([
			Pseq([
				Pbind(
					\pos, Pseq([
						Pfin(32-8, Pseq([
							Pseq([ 0,1,0,1, ],1)+10,
							Pseq([ 0,1,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],2)+10,
							Pseq([ 0,2,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],1)+21,
							//(0..7)+4,8,8,
						].flat,inf)),
						(0..7)+4
					].flat/8,inf),
				)
			],inf)<>
			Pdef(\igorbreak),
			Pdef(\basicbreak),

		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					Pseq([
						1,0,0.4,0, 0,0,0.4,0,
						1,0,0.4,0, 1,0,0.4,0,
					],3),
					1,0,0.4,0, 1,0,0.4,0,
					0,0,0.4,0, 0,0,0.4,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 0,0,1,1,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
				],8*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],3),

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0,0, 1,0,0,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0.3,0.3, 1,0.3,0.3,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11/3 * Pkey(\vel),
			//\out, BusDef(\sendbus1, \audio),
			//\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.6],7)
			],inf),
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000,8000,10000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\lag, -0.04,
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.2436974789916,
			'gain', 0.39865546218487,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', ~pmodenv.(Pseq([0.01,0.02],inf), 8).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 7.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 217,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\degree, Pseq([
				[0+7,2b,4-7,9],
				[0+7,2b,4-7],
				[0,2b+7,4],
			],inf).stutter(8*2),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\legato, Pseq([



				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.1,0.1,1,0,
				1,0.1,1,0, 0,2,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//0.1,1,2,0,
			],inf),
			\env1, Pseq([
				[ Env([2.00,0.7,7.midiratio/2,7.midiratio/2],[0.01,0.08,3.4]) ]
			],inf),
			\env2, Pseq([
				[ Env([0.6,0.7,0.4,0.7],[0.01,0.08,3.4]) ]
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\hrq, 0.5,
			\hpfr, 1/4,
			\mixlpf, 1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2.34,1), 1).loop,
			\amp, 0.1/8/4,
		),
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				[0+7,2b,4-7,9],
				[0+7,2b,4-7],
				[0,2b+7,4],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0.3,0.7,0, 0.7,0.7,0.1,0.8,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\decay, 0.14,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				0+7,2b,4-7,9,
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0.1,0,0.1,
					4,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\degree, Pseq([
				0,12,4,
			],inf),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0.1,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
	//////
Pdef(\part, Pdef(\pmid4big, 
	Ppar([
		Ppar([
			Pseq([
				Pbind(
					\pos, Pseq([
						Pfin(32-8, Pseq([
							Pseq([ 0,1,0,1, ],1)+10,
							Pseq([ 0,1,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],2)+10,
							Pseq([ 0,2,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],1)+21,
							//(0..7)+4,8,8,
						].flat,inf)),
						(0..7)+4
					].flat/8,inf),
				)
			],inf)<>
			Pdef(\igorbreak),
			//Pdef(\basicbreak),

		]),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						\r,\r,\r,\r, \r,\r,\r,\r, 
						\r,\r, (0..5)+42,
					].flat,2),
					Pseq([
						Pfin(32-8, Pseq([
							(0..5)+12,
							(0..7)+12,
							0,0,
						].flat,inf)),
						(0..7)+34,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pdef(\basicbreak2),
	])
)).play;
);


(
Pdef(\part, Pdef(\pmid4big, 
	Ppar([
		Ppar([
			Pseq([
				Pbind(
					\pos, Pseq([
						Pfin(32-8, Pseq([
							Pseq([ 0,1,0,1, ],1)+10,
							Pseq([ 0,1,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],2)+10,
							Pseq([ 0,2,0,1, ],2)+14,
							Pseq([ 0,1,0,1, ],1)+21,
							//(0..7)+4,8,8,
						].flat,inf)),
						(0..7)+4
					].flat/8,inf),
				)
			],inf)<>
			Pdef(\igorbreak),
			Pdef(\basicbreak),

		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					Pseq([
						1,0,0.4,0, 0,0,0.4,0,
						1,0,0.4,0, 1,0,0.4,0,
					],3),
					1,0,0.4,0, 1,0,0.4,0,
					0,0,0.4,0, 0,0,0.4,0,
				],3),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0,0.4,0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[799].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 0,0,1,1,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
				],8*4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],3),

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2307].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0.2,0,0, 0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[336].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\vel, Pseq([
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0,0, 1,0,0,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
				Pser([
					0,
				],8*2*8),
				Pseq([
					0,1,0.3,0.3, 1,0.3,0.3,1,
					0,1,0,0.3, 1,0,0.3,1,
				],8),
			],inf),
			\isRest, Pkey(\vel).coin.not,
			\dur, 1/8,
			\gain, 0.11/3 * Pkey(\vel),
			//\out, BusDef(\sendbus1, \audio),
			//\lag, -0.04,
		),
		Pbind(
			\instrument, \shortbass,
			\freq, 100,
			\freq, ~pmodenv.(Pseq(100*[1,2,1/2,4],1), 9).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1/2,4]*1.34,1), 8).loop,
			\del, ~pmodenv.(Pseq([1,20,1/10,400]/1000,1), 5).loop,
			\rq, 0.1,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8 ,
			\amp, 0.1* Pseq([
				1, Pseq([0.6],7)
			],inf),
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000,8000,10000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\lag, -0.04,
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.2436974789916,
			'gain', 0.39865546218487,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', ~pmodenv.(Pseq([0.01,0.02],inf), 8).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 7.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 217,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			// chords
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\degree, Pseq([
				[0+7,2b,4-7,9],
				[0+7,2b,4-7],
				[0,2b+7,4],
			],inf).stutter(8*2),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\legato, Pseq([



				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.1,0.1,1,0,
				1,0.1,1,0, 0,2,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//0.1,1,2,0,
			],inf),
			\env1, Pseq([
				[ Env([2.00,0.7,7.midiratio/2,7.midiratio/2],[0.01,0.08,3.4]) ]
			],inf),
			\env2, Pseq([
				[ Env([0.6,0.7,0.4,0.7],[0.01,0.08,3.4]) ]
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\hrq, 0.5,
			\hpfr, 1/4,
			\mixlpf, 1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]*2.34,1), 1).loop,
			\amp, 0.1/8/4,
		),
		Pbind(
			\instrument, \pluck,
			\degree, Pseq([
				[0+7,2b,4-7,9],
				[0+7,2b,4-7],
				[0,2b+7,4],
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0.3,0.7,0, 0.7,0.7,0.1,0.8,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\decay, 0.14,
			\coef, Pseg(Pseq((1..10)/10,inf),1),
			\coef, 0.405,
			\coef, Pseq([
				0.7,0.7,0.4,0.7,
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \vlip,
			\degree, Pseq([
				0+7,2b,4-7,9,
			],inf).stutter(8),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\fmamp, 0.4,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0.1,0,0.1,
					4,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kalimba,
			\degree, Pseq([
				0,12,4,
			],inf),
			\mtranspose, Pstep(Pseq([
				0,-1,
			],inf),4),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0.1,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\pmid5, 
	Ppar([
		Pdef(\housedrum),
		
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						\r,\r,\r,\r, \r,\r,\r,\r, 
						\r,\r, (0..5)+42,
					].flat,2),
					Pseq([
						Pfin(32-8, Pseq([
							(0..5)+12,
							(0..7)+12,
							0,0,
						].flat,inf)),
						(0..7)+34,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		//Pdef(\basicbreak2),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				1,
				//(0..3)/10+1,
				//(0..3).reverse/10+1
			].flat,inf)*0.9,
			\isRest, Pseq([
				1,0.5,
			],inf).coin.not,
			\pos, Pseq([
				4,9,2,1, 1,9,32,11,
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/8,inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/6,
		),
	])
)).play;
);

///// main
(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8,Pdef(\pintro1)),
		Pfindur(16,Pdef(\pmid1)),
		Pfindur(16,Pdef(\pmid2rise)),
		Pfindur(32,Pdef(\pmid3)),
		Pfindur(32,Pdef(\pmid4)),
		Pfindur(32,Pdef(\pmid5b)),
		//Pseq([
			////Pfindur(16,Pdef(\pmid2)),
			//Pfindur(16,Pdef(\pmid2tran1)),
			//Pfindur(16,Pdef(\ptran1)),
			//Pfindur(16,Pdef(\pmid2tran1)),
		//],inf),
		
	])
)).play;
)

//// draft


(
Pdef(\part, Pdef(\pmid5b, 
	Ppar([
		Pbind(
			\muter, Pstep(Pseq([
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,0,0,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
			],inf), 1),
			//\gain, Pkey(\gain) * Pkey(\muter),
			//\amp, Pkey(\amp) * Pkey(\muter),
			\rester, Pfunc({ arg ev; if(ev[\muter].coin == true) { 1 } { ev[\type] = \rest } }),
		)<>
		Pdef(\housedrum),
		
		Pseq([
			Pbind(
				\pos, Pseq([
					Pser([
						\r,
					],8),
					Pser([
						40,\r,58,\r
					].flat,16),
					\r,\r,\r,\r, \r,\r,\r,\r,
					Pseq([
						\r,\r,\r,\r, \r,\r,\r,\r, 
						\r,\r, (0..5)+42,
					].flat,2),
					Pseq([
						Pfin(32-8, Pseq([
							(0..5)+12,
							(0..7)+12,
							0,0,
						].flat,inf)),
						(0..7)+34,
					].flat,1),
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
		//Pdef(\basicbreak2),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/metal.flac'),
			\speed, Pseq([
				1,
				//(0..3)/10+1,
				//(0..3).reverse/10+1
			].flat,inf)*0.9,
			\isRest, Pseq([
				1,0.5,
			],inf).coin.not,
			\pos, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,

				\r,\r,\r,\r, \r,\r,22,23,
				24,25,\r,\r, \r,\r,\r,\r,
				24,25,\r,\r, \r,\r,\r,\r,
				24,25,\r,\r, \r,\r,\r,\r,
				Pseq([
					Pn(24,4), Pn(\r,4),
					Pn(26,4), Pn(27,4),
					Pn(\r,4), Pn(47,4),
					Pn(\r,4), Pn(47,4),
				],3),
				Pseq([
					Pn(24,4), Pn(\r,4),
					Pn(26,4), Pn(27,4),
					Pn(\r,4), Pn(47,4),
					Pn(\r,4), Pn(47,4),
				],3),
					Pn(24,4), Pn(\r,4),
					Pn(26,4), Pn(27,4),
					Pn(\r,4), Pn(\r,4),
					Pn(\r,4), Pn(24,4),
				Pseq([
					Pn(24,8),
					Pn(14,8),
					4,9,2,1, 1,9,32,11,
					Pn(\r,8),
				],4),
				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,4,4, 0,4,0,0, ],1)+7,
				//Pseq([ 4,5,0,4, 0,6,0,0, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,

				//Pseq([ 0,1,2,0, 0,0,0,0, ],1)+1,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],1)+7,
				//Pseq([ 0,5,0,0, 0,6,0,7, ],1)+7,
				//Pseq([ 0,0,0,0, 0,7,8,9, ],1)+7,
				//(0..3)*2,
				//(0..7)*2+10,
			].flat/16,inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.9) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \nappy,
			\note, Pstep(Pseq([
				0,
				-1,
			],inf),4),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([8000,1000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.5,0.3,0.2) ],
			],inf),
			\chord, Pstep(Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),4),
			\dur, PdurStutter(Pseq([
				Pser([
					\r,
					1,
				],2),
				Pser([
					\r,
					8,
				],2),
				Pseq([4,16,32,32,8],1),
			],inf), 4),
			\legato, 0.4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\lag, -0.04,
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.051,
			\gain, 0.8,
			\delay, 0.61,
			\delay2, 0.01,
			\distamp, 10,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pdef(\nappypool1)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\isRest, Pstep(Pseq([
				1,0,0,0, 1,0,0,0,
			],inf), 1).coin.not,
		) <>
		Pdef(\ptran1),
		Pbind(
			\isRest, Pstep(Pseq([
				0,0,0,1, 0,0,0,1,
			],inf), 1).coin.not,
		) <>
		Pdef(\basicbreak),
		Pbind(
			\isRest, Pstep(Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf), 1).coin.not,
		) <>
		Pdef(\pmid2),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\housedrum),
		Pbind(
			\instrument, \nappy,
			\note, Pstep(Pseq([
				0,
				-1,
			],inf),4),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([8000,1000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.5,0.3,0.2) ],
			],inf),
			\chord, Pstep(Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),4),
			\dur, Pseq([
				Pser([
					1/2,
				],8*4),
				Pseq([1,1/4,1/8,1/8,1/2],8),
			],inf),
			\legato, 0.4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\lag, -0.04,
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.051,
			\gain, 0.8,
			\delay, 0.61,
			\delay2, 0.01,
			\distamp, 10,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pdef(\nappypool1)
	])
)).play;
);

(
Pdef(\part, Pdef(\phouse, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,1, 0,0,0,1,
				0,1,0,1, 0,0,0,1,
				0,1,1,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[783].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0, 1,0,1,0,
				],8*4*3),
				Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],1),
			],inf).coin.not,
			\legato, Pseq([
				1,1,2,1, 1,0.2,1,
				Pser([ 0.3 ],11),
				Pser([ 1.3 ],11),
			],inf),
			\dur, 1/8,
			\gain, 0.13,
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \freecordeenv2,
			\note, Pseq([
				0,7,8
			],inf) + Pseg(Pseq([0,-1],inf), 4),
			\note, Pseq([
				0,7,8
			],inf),
			\octave, 6,
			//\selratio, 0.010,
			//\fspread, 1/Pkey(\freq) * Pseq([1,1.2,4,8],inf).stutter(8),
			\amr, 1/2.01,
			\fmr, 1.01,
			\lpfr, ~pmodenv.(Pseq([0.3,2,1,0.4,0.7,4],1), 8).loop,
			\rq, ~pmodenv.(Pseq([0.2,1],1), Pseq([4,2,16],4)).loop,
			\spread, Pseq([1,0,1,1,0],inf),
			\rel, Pseg(Pseq([0.1,2.1],inf),18),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\pan, Pseq([-1,1],inf)*0.4,
			\amampenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([0,1.3,0.3],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fspreadenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fmampenv, Pseq([
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([1,1,1],[0.1,1.8]) ],
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			//\amamp, 0.1,
			//\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
			//\amamp, ~pmodenv.(Pseq([0,0.2,0.4],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,-1,-1,
			],inf),2),
			\octave, Pseq([
				4,Prand([4,4,5,5,5,6,7],3)
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1
			],inf),
			\fmr, Pseq([
				1/2,
				Pwrand([1/2,2,4],[1,0.1,0.1].normalizeSum,3),
			],inf),
			\fmamp, Pseg(Pseq([0,4],inf),8),
			\diff, Pseg(Pseq([0.001,0.2,0.00001],inf),5),
			\lpfr,4,
			\rel, Pseg(Pseq([0.01,1.1],inf),18),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			//\lag, 0.04,
			//\legato, Pseq([
				//0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				//0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				//Pseq([
					//0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				//],1)*0.8+0.05,
			//],inf)/10*2,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				Pseq([
					0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				],1)*0.8+0.05,
			],inf).coin.not,
			\dur, 1/16,
			\amp,0.02 / Pkey(\octave) * 4,
		),
		//Pbind(
			//\instrument, \nappy,
			//\note, Pseq([
				//0,
				//-1,
			//],inf),
			//\octave,5,
			////\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			//\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			//\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,2.1) ],
			//],inf),
			//\chord, Pseq([
				//[ [0,3,7,9].midiratio ],
				//[ [0,3,7,10].midiratio ],
			//],inf),
			//\dur, 4,
			//\amp, 0.1,
		//),

	])
)).play;
);

(
Pdef(\part, Pdef(\phouse, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,1, 0,0,0,1,
				0,1,0,1, 0,0,0,1,
				0,1,1,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[783].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0, 1,0,1,0,
				],8*4*3),
				Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],1),
			],inf).coin.not,
			\legato, Pseq([
				1,1,2,1, 1,0.2,1,
				Pser([ 0.3 ],11),
				Pser([ 1.3 ],11),
			],inf),
			\dur, 1/8,
			\gain, 0.13,
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
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \freecordeenv2,
			\note, Pseq([
				0,7,8
			],inf) + Pseg(Pseq([0,-1],inf), 4),
			\note, Pseq([
				Pser([
					0,7,8,
				],8*7),
				Pser([
					0,0,-1,-1
				],8*1),
			],inf),
			\octave, 6,
			//\selratio, 0.010,
			//\fspread, 1/Pkey(\freq) * Pseq([1,1.2,4,8],inf).stutter(8),
			\amr, 1/2.01,
			\fmr, 1.01,
			\lpfr, ~pmodenv.(Pseq([0.3,2,1,0.4,0.7,4],1), 8).loop,
			\rq, ~pmodenv.(Pseq([0.2,1],1), Pseq([4,2,16],4)).loop,
			\spread, Pseq([1,0,1,1,0],inf),
			\rel, Pseg(Pseq([0.1,2.1],inf),18),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.1,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\pan, Pseq([-1,1],inf)*0.4,
			\amampenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([0,1.3,0.3],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fspreadenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fmampenv, Pseq([
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([1,1,1],[0.1,1.8]) ],
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			//\amamp, 0.1,
			//\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
			//\amamp, ~pmodenv.(Pseq([0,0.2,0.4],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				//Pser([
					//0,0,-1,-1,
				//],4*3),
				Pser([
					5,8,4,4,
				],4*1)-12,
			],inf),2),
			\octave, Pseq([
				4,Prand([4,4,5,5,5,6,7],3)
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1
			],inf),
			\fmr, 4,
			\fmamp, Pseg(Pseq([0,4],inf),8),
			\diff, Pseg(Pseq([0.001,0.2,0.00001],inf),5),
			\lpfr,4,
			\rel, Pseg(Pseq([0.01,1.1],inf),18),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			//\lag, 0.04,
			//\legato, Pseq([
				//0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				//0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				//Pseq([
					//0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				//],1)*0.8+0.05,
			//],inf)/10*2,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					Pseq([
						0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					],1)*0.8+0.05,
				],3),
				0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				Pseq([
					1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0,
				],1)*0.8+0.05,
			],inf).coin.not,
			\dur, 1/16,
			\amp,0.02 / Pkey(\octave) * 4,
		),
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, 0.3,
			\chord, Pseq([
				[ [0,3+12,7].midiratio ],
				[ [0+12,3+12,7].midiratio ],
				[ [0+12,3,7-12].midiratio ],
				[ [0,3-12,7+12].midiratio ],
				[ [0+12,3-12,7+12].midiratio ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				Pstep(Pseq([
					0,
					-1,
				],3),4),
				Pstep(Pseq([
					5,5,0,3,3,11,9,9,
					4,4,-5,-5+12, -1,2,-1,-1,
				],1),1/2),
			],inf),
			\octave,7,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([1200,4000]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.3,
			\chord, Pseq([
				[ [1,1,1]],
				[ [0,0,0]],
				[ [1,1.1,1.001]],
				[ [1,1,1.001]],
				[ [1,1,1.001]],
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),

	])
)).play;
);

////////////////// crap

NoteTimeline(\bla).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[225].value,
			////\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0.41, 0,0,0.8,0,
				//0.41,0,0,0, 0,0,0,0,
				//0,0,1,0, 0,0,0,0,
				//0,0,0,0, 0,0,1,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[378].value,
			//\isRest, Pseq([
				//Pseq([
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0,
				//],1),

				//0,0,0,0, 1,0,0,0,
				//0,0,0,0, 1,0,0,0,
				//0,0,0,0, 1,0,0,1,
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		//Pseq([
			//Pbind(
				//\pos, Pseq([
					//Pseq([
						//Pfin(32-8, Pseq([
							//Pseq([ 0,0,4, ],1)+30,
						//].flat,inf)),
						//(0..7)+4,
					//].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//Pseq([
								//0,0,2,0,0,2,0,2,
								//0,2,8,0,2,0,0,2,
								
							//],inf)+30,
						//].flat,inf)),
						//(0..7)+8,
					//].flat,1),
				//].flat/8,inf),
			//)
		//],inf)<>
		//Pdef(\igorbreak),
		Pdef(\basicbreak),
	])
)).play;
);

(
Pdef(\part, Pdef(\xxbasicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				//1,0,0.4,0, 0.3,0,0.3,0,
				//0,0,0.5,0.5, 0,0,0,0,
				1,0,1,0, 0.5,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
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
			\isRest, true,
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

(
Pdef(\part, Pdef(\xxbasicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				Pser([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],8*6),
				Pser([
					0,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
				],8*2),
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				Pser([
					0,0,0,0, 1,0,0,0,
				],8*6),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],8*2),
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[772].value,
			\score, Pseq([
				Pser([
					0,0,0,0, 0,1,1,1,
					1,1,0,0, 0,0,1,0,
				]/3,8*3),
				Pser([
					0,1,1,0, 0,1,1,1,
					1,1,0,0, 1,0,0,0,
				]/3,8*3),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],8*2),
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
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				Pser([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
				],8*6),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*2),
			]/2,inf),
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
					0,0,0,0, 0,0.5,0.5,0.5,
					0.5,0.5,0,0, 0,0,0,0,
				],8*6),
				Pser([
					1,1,1,0, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],8*2),
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1080].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				Pser([
					0,0,0,0, 0,0.5,0.5,0.5,
					0.5,0.5,0,0, 0,0,0,0,
				],8*6),
				Pser([
					1,1,1,0, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],8*2),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.05 * (Pkey(\score) * 4).clip(0,1),
		),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				//Pser([
					//0,0,-1,-1,
				//],4*3),
				Pser([
					5,8,4,4,
				],4*1)-12,
			],inf),2),
			\octave, Pseq([
				4,Prand([4,4,5,5,5,6,7],3),
				4,Prand([4,4,5,5,5,6,7],3),
				4,Prand([4,4,5,5,5,6,7],3),
				//4,Prand([4,4,5,5,5,6,7],1),4,4,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1
			],inf),
			\fmr, Pseg([1,2,3,4,5],inf).stutter(12),
			\fmamp, Pseg(Pseq([0,4],inf),8),
			\diff, Pseg(Pseq([0.001,0.2,0.00001],inf),5),
			\lpfr, ~pmodenv.(Pseq([2,8,1,4],1), 8).loop,
			\rel, Pseg(Pseq([0.01,1.1],inf),18),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			//\lag, 0.04,
			//\legato, Pseq([
				//0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				//0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				//Pseq([
					//0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
					//0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				//],1)*0.8+0.05,
			//],inf)/10*2,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					Pseq([
						0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					],1)*0.8+0.05,
				],3),
				0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
				Pseq([
					1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0,
				],1)*0.8+0.05,
			],inf).coin.not,
			\dur, 1/16,
			\amp,0.02 / Pkey(\octave) * 4,
			\score, Pseq([
				1,0,0,0, 0,0,1,1,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,1,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,1,1,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\amp, 0.01 * (Pkey(\score) * 4).clip(0,1),
			\isRest, true,
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//(0..7)+49,
						Pfin(8*6,
							Pseq([
								//Pser([0,0,4],8)+7,
								////Pseq([ \r,\r,2,3, \r,\r,2,3 ],1)+44,
								//Pser([0,0,2],8)+7,
								Pser([
									3,0,0,3, 0,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									3,0,0,3, 2,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									0,0,2,0, 0,2,3,2,
									3,0,4,0, 2,0,4,0,
								],16)+7,
								//(0..7)+14,
								//Pser([0,0,4],4),
								//(0..7)+10,
								//(0..3)+2, (0..3)+2,
							],1),
						),
						Pser([
							0,0,0,0, 2,3,4,5,
							6,0,4,0, 2,0,4,0,
						],16)+7,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
					].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//Pseq([ 0,0,4, ],1)+24,
						//].flat,inf)),
						//(0..7)+4,
					//].flat,1),
				].flat/8,inf),
				\isRest, Pseq([
					Pser([
						0.5
					],8*6),
					Pser([
						1
					],8*2),
				],inf).coin.not,
			)
		],inf)<>
		Pdef(\igorbreak)
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basicbreak),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//(0..7)+49,
						Pfin(8*6,
							Pseq([
								//Pser([0,0,4],8)+7,
								////Pseq([ \r,\r,2,3, \r,\r,2,3 ],1)+44,
								//Pser([0,0,2],8)+7,
								Pser([
									3,0,0,3, 0,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									3,0,0,3, 2,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									0,0,2,0, 0,2,3,2,
									3,0,4,0, 2,0,4,0,
								],16)+7,
								//(0..7)+14,
								//Pser([0,0,4],4),
								//(0..7)+10,
								//(0..3)+2, (0..3)+2,
							],1),
						),
						Pser([
							0,0,0,0, 2,3,4,5,
							6,0,4,0, 2,0,4,0,
						],16)+7,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
					].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//Pseq([ 0,0,4, ],1)+24,
						//].flat,inf)),
						//(0..7)+4,
					//].flat,1),
				].flat/8,inf),
				\isRest, Pseq([
					Pser([
						0.5
					],8*6),
					Pser([
						1
					],8*2),
				],inf).coin.not,
				\gain, 0.07,
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				0,3,7,
			],inf),
			\fmamp, ~pmodenv.(Pseq([0.1,2,24],1), 8).loop,
			\legato, 0.4,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				0,3,7,3,
				0,3,7,
			],inf),
			\octave, 4,
			\fmamp, ~pmodenv.(Pseq([0.1,2,24],1), 8).loop,
			\legato, 0.4,
			\dur, 1/8,
			//\amp, 0.1,
			\amp, 0.1 * Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				0,0,7,
				3,3,7,
			],inf),
			\octave, 6,
			\fmamp, ~pmodenv.(Pseq([0.1,2,24],1), 8).loop,
			\legato, 0.4,
			\dur, 1/8,
			//\amp, 0.1,
			\amp, 0.1 * Pseg(Pseq([0,1],inf),11),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\nappypool1,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 0.09865546218487,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', ~pmodenv.(Pseq([0.00031,0.02,0.2],1), 32).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 10.0,
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
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,0,0,9, 0,0,-1,-1,
				0,0,3,0,-1,-1,-1,-1,
			],inf).stutter(2),
			\octave, 3,
			\pos, Pseq([
				Pseg(Pseq([0,0.01],inf),8)+2.2,
				//~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf) + Pseq([0,3],inf),
			\lpmix, 0.71,
			\lpfr, 8,
			\rq, 0.8,
			\resmix, 0.41,
			\bwr, ~pmodenv.(Pseq([0.1,2,1,14],1), 8).loop,
			\resfr, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1)*4,
				1,2,8,1/2,
			],inf),
			//\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			//\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				1,0.7, 0.7,0.7, 0.7,0.7, 1,0.7,
				0.5,0.7, 1,0.7, 0.7,0.7, 1,0.7,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0.7, 0.9,0.7,
			],inf).coin.not,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 0.7,

		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,7,0,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				Pseg(Pseq([0,0.01],inf),8)+2.2,
				//~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf) + Pseq([0,3],inf),
			\lpmix, 0,
			\lpfr, 8,
			\rq, 0.8,
			\resmix, 1,
			\bwr, ~pmodenv.(Pseq([0.1,2,1,14],1), 8).loop,
			\resfr, Pseq([
				1,2,8,1/2,
			],inf),
			//\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			//\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				1
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1/2,

		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord,
			\legato, 0.91,
			\diff, 0.00001,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+4,
				[0,3,7,11-12],
				[0,3,7,10-12]+4,
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \largechord)))

Pdef(\melo)
(
Pdef(\melo, 
	Pbind(
		\instrument, \largechord,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
	)
);
);


// blues

(
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
		Pdef(\basicbreak)
		
	])
)).play;
);
(
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
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12])),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\basicbreak)
		
	])
)).play;
);

(
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
			\note, Pseq([
				Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				-12,\r,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\basicbreak)
		
	])
)).play;
);

(
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
		),
		Pdef(\basicbreak)
		
	])
)).play;
);

(
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
		Ppar(2.collect({ arg idx;
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

					],1) + [0,12][idx],
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
			)
		})),
		Ppar(2.collect({ arg idx;
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

					],1) + [0,12][idx],
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
				\dur, 1/8,
				\amp, 0.1,
			)
		})),
		Pdef(\basicbreak)
		
	])
)).play;
);

(
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
			\note, Pseq([
				Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,\r,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\note, Pseq([
				Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				-12,\r,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\basicbreak)
		
	])
)).play;
);

(
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
			\amp, 0.1,
		),
		Pdef(\basicbreak),
		
	])
)).play;
);


////////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basicbreak),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pfin(64,Pseq([
					(0..11)+50,
					(0..3)+50,
					(0..7)+50,
					(0..7)+54,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1)),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basicbreak),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					(0..11)+50,
					(0..3)+50,
					(0..7)+50,
					(0..7)+54,

					(0..11)+40,
					(0..3)+50,
					(0..7)+50,
					(0..7)+54,

					(0..11)+40,
					(0..3)+50,
					(0..7)+40,
					(0..7)+54,

					(0..11)+40,
					(0..3)+40,
					(0..7)+40,
					(0..7)+54,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		)
		
	])
)).play;
);

(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2,\audio))<>
		Pdef(\basicbreak),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					Pseq([
						(0..5),
						(0..5),
						(0..3),
					].flat,11)+43,
					(0..5)+130,
					(0..5)+130,
					(0..9)+130,
					//(0..11)+130,
					//(0..3)+130,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
			//\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					Pseq([
						(0..11),
						(0..3),
						(0..9),
						(0..5),
					].flat,11)+156,
					Pseq([
						(0..5),
						(0..5),
						(0..3),
					].flat,11)+33,
					(0..5)+130,
					(0..5)+130,
					(0..9)+130,
					//(0..11)+130,
					//(0..3)+130,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
			//\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		)
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-3P4H-9Q9B", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.00069236664026787,
	'delay2', 0.0001,
	'shift', -0.04605,
	'shift2', 0.0,
	'distamp', 0.38004229563659,
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
	'wetamp', 0.73901997269246,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-6PR1-I0RR", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.14705882352941,
	'gain', 0.95798319327731,
	'fb', 0.0001,
	'delay', 0.00012613637220374,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.02605,
	'distamp', 1.2492192141522,
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
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pbind(\out, BusDef(\sendbus2,\audio))<>
		//Pdef(\basicbreak),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					Pseq([
						(0..5),
						(0..5),
						(0..3),
					].flat,11)+43,
					(0..5)+130,
					(0..5)+130,
					(0..9)+130,
					//(0..11)+130,
					//(0..3)+130,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
			//\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					Pseq([
						(0..11),
						(0..3),
						(0..9),
						(0..5),
					].flat,11)+156,
					Pseq([
						(0..5),
						(0..5),
						(0..3),
					].flat,11)+33,
					(0..5)+130,
					(0..5)+130,
					(0..9)+130,
					//(0..11)+130,
					//(0..3)+130,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
			//\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//(0..7)+49,
						Pfin(8*6,
							Pseq([
								//Pser([0,0,4],8)+7,
								////Pseq([ \r,\r,2,3, \r,\r,2,3 ],1)+44,
								//Pser([0,0,2],8)+7,
								Pser([
									3,0,0,3, 0,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									3,0,0,3, 2,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									0,0,2,0, 0,2,3,2,
									3,0,4,0, 2,0,4,0,
								],16)+7,
								//(0..7)+14,
								//Pser([0,0,4],4),
								//(0..7)+10,
								//(0..3)+2, (0..3)+2,
							],1),
						),
						Pser([
							0,0,0,0, 2,3,4,5,
							6,0,4,0, 2,0,4,0,
						],16)+7,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
					].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//Pseq([ 0,0,4, ],1)+24,
						//].flat,inf)),
						//(0..7)+4,
					//].flat,1),
				].flat/8,inf),
				\isRest, Pseq([
					Pser([
						0.5
					],8*6),
					Pser([
						1
					],8*2),
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					Pser([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],8*6),
					Pser([
						0,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,0,0,
					],8*2),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.1 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
					],8*6),
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*2),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11 * Pkey(\score),
			),
		]),
		
	])
)).play;
);

(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pbind(\out, BusDef(\sendbus2,\audio))<>
		//Pdef(\basicbreak),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					Pseq([
						(0..5),
						(0..5),
						(0..3),
					].flat,11)+43,
					(0..5)+130,
					(0..5)+130,
					(0..9)+130,
					//(0..11)+130,
					//(0..3)+130,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
			//\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					Pseq([
						(0..11),
						(0..3),
						(0..9),
						(0..5),
					].flat,11)+156,
					Pseq([
						(0..5),
						(0..5),
						(0..3),
					].flat,11)+33,
					(0..5)+130,
					(0..5)+130,
					(0..9)+130,
					//(0..11)+130,
					//(0..3)+130,
					//Pseq([
						//Rest(1)
					//],4),
				].flat,1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
			//\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pseq([
			Pbind(
				\pos, Pseq([
					Pseq([
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
						//(0..7)+49,
						Pfin(8*6,
							Pseq([
								//Pser([0,0,4],8)+7,
								////Pseq([ \r,\r,2,3, \r,\r,2,3 ],1)+44,
								//Pser([0,0,2],8)+7,
								Pser([
									3,0,0,3, 0,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									3,0,0,3, 2,0,3,0,
									0,0,4,0, 2,0,4,0,
								],16)+7,
								Pser([
									0,0,2,0, 0,2,3,2,
									3,0,4,0, 2,0,4,0,
								],16)+7,
								//(0..7)+14,
								//Pser([0,0,4],4),
								//(0..7)+10,
								//(0..3)+2, (0..3)+2,
							],1),
						),
						Pser([
							0,0,0,0, 2,3,4,5,
							6,0,4,0, 2,0,4,0,
						],16)+7,
						//Pseq([ \r,\r,2,3, 4,5,6,7, ],1)+44,
					].flat,1),
					//Pseq([
						//Pfin(32-8, Pseq([
							//Pseq([ 0,0,4, ],1)+24,
						//].flat,inf)),
						//(0..7)+4,
					//].flat,1),
				].flat/8,inf),
				\isRest, Pseq([
					Pser([
						0.5
					],8*6),
					Pser([
						1
					],8*2),
				],inf).coin.not,
				\out, BusDef(\sendbus2, \audio),
			)
		],inf)<>
		Pdef(\igorbreak),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					Pser([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*6),
					Pser([
						0,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,0,0,
					],8*2),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.1 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*6),
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*2),
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11 * Pkey(\score),
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
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pdef(\basicbreak),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1091].value,
			\speed, 1.1,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.07 * (Pkey(\score) * 4).clip(0,1) * Pwhite(0.4,1,inf),
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


(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pmono(
			 \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\note, Pseq([
				//Pseq([
					//0,
				//],inf),
				0,0,5,5,0,0,6,6,
			],inf).stutter(64),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zzbasicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
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
		Pseq([
			Pbind(
				\pos, Pseq([
					Pfin(32-8, Pseq([
						Pseq([
							0,0,4,0,0,10
						],1)+5,
					//(0..7)+4,8,8,
					].flat,inf)),
					(0..7)+4
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
	])
)).play;
);

(
Pdef(\part, Pdef(\zzbasicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,1,0, 0,1,1,0,
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
			\bufnum, ~buflib.hat[836].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
				0.2,0,1,0, 0.2,0.2,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.03 * (Pkey(\score) * 4).clip(0,1),
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
		Pseq([
			Pbind(
				\pos, Pseq([
					Pfin(32-8, Pseq([
						Pseq([
							0,0,4,0,0,10
						],1)+15,
					//(0..7)+4,8,8,
					].flat,inf)),
					(0..7)+4
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
	])
)).play;
);

(
Pdef(\part, Pdef(\zzbasicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
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
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,1,0, 0,1,1,0,
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
			\bufnum, ~buflib.clap[277].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\score, Pseq([
				0,0,0.3,0, 0,0,0.4,0.2,
				0.51,0.41,0.3,0, 0,0,0.4,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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
		Pseq([
			Pbind(
				\pos, Pseq([
					Pfin(32-8, Pseq([
						Pseq([
							0,4,0,10
						],1)+25,
					//(0..7)+4,8,8,
					].flat,inf)),
					(0..7)+4
				].flat/8,inf),
			)
		],inf)<>
		Pdef(\igorbreak),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1625].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1625].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0.1,0.1, 0,0,0.3,0.3,
				0.3,0,0,0, 0,0,0,0.3,
			],inf).coin.not,
			\sustain, 0.03,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.041) ],
			],inf),
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				134
			].flat/8,inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, 1.2,
			\legato, 1,
			\dur, 2/1,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1085].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				1,0,0,0, 1,0,1,0.3,
				0.41,0,0.3,0.3, 0.1,0,0.1,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				317+ Pseg(Pseq([0,8],inf),32),
			].flat/8,inf),
			\isRest, Pseq([
				1,0,0,0, 0,1,1,1,
				1,0,1,0, 0,0,0,1,
			]/2,inf).coin.not,
			\speed, 1.0,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				310+ Pseg(Pseq([0,8],inf),32),
			].flat/8,inf),
			\isRest, Pseq([
				1,0,0,0, 0,1,1,1,
				1,0,1,0, 0,0,0,1,
			]/2,inf).coin.not,
			\speed, 1.3,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				(0..11)+0,
				(0..3)+0,
				(0..15)+8,
				(0..3)+2,
				(0..3)+2,
				(0..3)+4,
				(0..3)+2,
				(0..11)+8,
				(0..3)+4,
				(0..7),
			].flat+0,inf)/8/Pkey(\st),
			\dur, 1/8,
			\gain, 1/11,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\note, Pseq([
				//[0,3,7]
				0,2,
				0,
			],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 3,
			\legato, 0.8,
			\gfreq, Pkey(\freq),
			\pos, Pseq([
				300,
				100,
				30,
			].flat/8,inf),
			\dur, 1,
			\gain, 1/6,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			//\instrument, \simplegran_adsrcomp,
			//\note, Pseq([
				//0,5,0,6
			//],inf).stutter(4),
			//\gfreq, Pkey(\freq),
			//\pos, Pseq([
				//300,
				//100,
				//30,
			//].flat/8,inf),
			//\speed, 1.2,
			//\legato, 1,
			//\dur, 1/8,
			//\gain, 1/6,
		//),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \largechord,
			\note, Pseq([
				[5,9,14,17],
				[5,8,14,17],
			],inf).stutter(4),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/3/~t,
			\decay, 2,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,10,4,10,
				],inf)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		
	])
)).play;
);


(
	// test fat
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,2,9,0,14
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1187].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_fat,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
	// test meuble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,2,9,0,14
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1187].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[932].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_meuble,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([0.5,0.5],inf),
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\gain, 2,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,-1,-1,-2,-2,-3,-3,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\pan, Pseq([-1,1],inf),
			\legato, 0.1,
			\out, BusDef(\ifx1, \audio),
			//\isRest, true,
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, 1/Pseq([1,3,4,16,8],inf)/~t,
			\gain, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1187].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx2, \audio),
			//\isRest, true,
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([1,2,3,4,8],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1,
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
			\gain, 0.11 * Pkey(\score),
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx3, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([1,2,4,8],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			\out, BusDef(\ifx4, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx4, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([4,8,16,2],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,0,-1,-1,-2,-2,-3,-3,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				Pseg(Pseq([0,0.01],inf),8)+4.2,
				//~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf) + Pseq([0,3],inf),
			\lpmix, 0.71,
			\lpfr, 8,
			\rq, 0.8,
			\resmix, 0.41,
			\bwr, ~pmodenv.(Pseq([0.1,2,1,14],1), 8).loop,
			\resfr, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1)*4,
				1,2,8,1/2,
			],inf),
			//\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			//\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				1,0.7, 0.7,0.7, 0.7,0.7, 1,0.7,
				0.5,0.7, 1,0.7, 0.7,0.7, 1,0.7,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0.7, 0.9,0.7,
			],inf).coin.not,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 0.7,

		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \largechord,
			\note, Pseq([
				[5,9,14,17],
				[5,8,14,17],
			],inf).stutter(4),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/3/~t,
			\decay, 2,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,\r,\r,\r,
					8,\r,\r,\r,
				],inf)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/Pseq([3,5,1,2,4,8],inf)/~t,
			\decay, 1,
			\decayFactor, 0.82,
			\addAction, \addToTail,
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
			\instrument, \largechord,
			\note, Pseq([
				[5,9,14,17],
				[5,8,14,17],
			],inf).stutter(4),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/3/~t,
			\decay, 2,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,\r,\r,\r,
					8,\r,\r,\r,
				],inf)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/Pseq([3,5,1,2,4,8],inf)/~t,
			\decay, 1,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pdef(\basicbreak)
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \largechord,
			\note, Pseq([
				[5,9,14,17],
				[5,8,14,17],
			],inf).stutter(4),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/ Pseq([
				1,1,2,2, 4,4,4,3,
			],inf)/~t,
			\decay, 0.8/~t,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					0,\r,\r,\r,
					8,\r,\r,\r,
				],inf)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/Pseq([
				Pseq([
					4,4,4,4, 4,4,4,4,
				],1),
				4,6,3,5, 1,2,4,8,
			],inf)/~t,
			\decay, 1,
			\decayFactor, 0.82,
			\addAction, \addToTail,
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
			\instrument, \largechord,
			\note, Pseq([
				5,5,5,5, 5,9,14,17,
				Pseq([
					Pseq([
						[5,9,14,17],
						[5,8,14,17],
					],3),
					[5+12,9,14,17-12],
					[5,8,14-12,17-12],
				],inf).stutter(4),
			],inf),
			\legato, Pseg(Pseq([0.1,0.2,0.2,0.71],inf),16),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/ Pseq([
				Pseq([
					1,1,2,2, 4,4,4,3,
				],6),
					8,7,6,6, 2,2,3,3,
					8,7,6,6, 2,2,3,3,
			],inf)/~t,
			\decay, 0.8/~t,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([
					10,11,12,13, 14,14,14,14,
					8,\r,\r,\r, \r,\r,\r,\r,

					0,4,4,4, 4,4,4,4,
					8,\r,\r,\r, \r,\r,\r,\r,
				],8*8)/16,
				Pseq([
					0,\r,\r,\r,
					8,\r,\r,\r,
				],inf)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/Pseq([
				Pser([
					10
				],8),
				Pseq([
					Pseq([
						4,4,4,4, 4,4,4,4,
					],1),
					4,6,3,5, 1,2,4,8,
				],inf),
			],inf)/~t,
			\decay, 1,
			\decayFactor, 0.82,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			32, Pdef(\basicbreak)
		]),
		Pbind(
			\instrument, \kalimba,
			\degree, Pstep(Pseq([
				9,8
			],inf),4),
			\mtranspose, Pstep(Pseq([
				-12,
			],inf),4),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0.1,0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
				],12),
				Pseq([
					\r,\r,\r,\r, \r,\r,\r,\r,
					(0..3)+90, (0..3)+88,
					(0..3)+12, \r,\r,\r,\r,
					(0..7)+100,
				],1),
			].flat/8,inf),
			\speed, 1.2,
			\legato, 1,
			\dur, 1/8,
			//\gain, 1/6 * Pseg(Pseq([0,1,1,1,1],1),1).loop,
			\gain, 1/6,
		)
	])
)).play;
);

/////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('samplekit/vipere/camelcactus.flac'),
			\pos, Pseq([
				Pseq([
					(0..1)+40,
				],6),
				(0..1)+40,
				(0..2)+40,
			].flat/8,inf),
			\speed, ~pmodenv.(Pseq([1,1.2,2],1), 8).loop,
			\legato, 1,
			\dur, 1/8,
			\gain, 1/6,
		)
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
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
			//\bufnum, BufDef('loop/pigs.flac'),
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/8/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 4,
				],1),4),
				Pseg(Pseq([
					2, 3,
				],1),2),
				Pseg(Pseq([
					1, 2,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
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
			\legato, 1,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\st, 129/4/60,
			\speed, 1/Pseq([1,1,1,1,2,2,1.41,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					1, 2,
				],1),1/4),
				Pseg(Pseq([
					0, 2,
				],1),1/4),
			],inf)/4 / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,2,1,8],inf), 1/2),
			//\dur, 1/8,
			\gain, 0.1,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
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
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4, 2,1,0.5,8],inf)*0.4 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 1,
				],1),2),
				//Pseg(Pseq([
					//2, 3,
				//],1),2),
				//Pseg(Pseq([
					//1, 2,
				//],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.2,

		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
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
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([
					//0, 1,
				//],1),2),
				Pseq([
					Pseg(Pseq([
						4, 8,
					],1),2)+8,
				],8),
				Pseq([
					Pseg(Pseq([
						4, 8,
					],1),2)+4,
				],8),
				Pseq([
					Pseg(Pseq([
						0, 8,
					],1),4)+8,
				],8),
				//Pseg(Pseq([
					//4, 6,
				//],1),2),
				//Pseg(Pseq([
					//0, 8,
				//],1),4),
				//Pseg(Pseq([
					//0, 8,
				//],1),4)+8,
				//Pseg(Pseq([
					//2, 4,
				//],1),2),
				//Pseg(Pseq([
					//0, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
			\gain, 0.1* Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				0.2,0.2,0.3,0.1, 1,1,1,1,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
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
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 2.5/Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0.7,1.2,1.2, 1,1,1,1,
			],inf),1/4) * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([
					//0, 1,
				//],1),2),
				Pseq([
					Pseg(Pseq([
						0, 4,
					],1),1),
				],7),
					Pseg(Pseq([
						0, 4,
					],1),1)+4,
				//Pseg(Pseq([
					//4, 6,
				//],1),2),
				//Pseg(Pseq([
					//0, 8,
				//],1),4),
				//Pseg(Pseq([
					//0, 8,
				//],1),4)+8,
				//Pseg(Pseq([
					//2, 4,
				//],1),2),
				//Pseg(Pseq([
					//0, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,2,2,8, 4,1,8,1, ],inf), 1/2),
			\gain, 0.1* Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([
					//0, 1,
				//],1),2),
				Pseq([
					Pseg(Pseq([
						4, 8,
					],1),2)+8,
				],8),
				Pseq([
					Pseg(Pseq([
						4, 8,
					],1),2)+4,
				],8),
				Pseq([
					Pseg(Pseq([
						0, 8,
					],1),4)+8,
				],8),
				//Pseg(Pseq([
					//4, 6,
				//],1),2),
				//Pseg(Pseq([
					//0, 8,
				//],1),4),
				//Pseg(Pseq([
					//0, 8,
				//],1),4)+8,
				//Pseg(Pseq([
					//2, 4,
				//],1),2),
				//Pseg(Pseq([
					//0, 4,
				//],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1),
			\gain, 0.1* Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
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
			//\bufnum, BufDef('loop/pigs.flac'),
			//\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			//\st, 272/8/60,
				\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
				\st, 272/1/60,
				\gain, 0.1,
			\speed, 4/Pseq([1,1.4,1,1,1,1,0.7],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					Pseg(Pseq([
						0, 8,
					],1),1),
				],3),
				Pseg(Pseq([
					0, 4,
				],1),1)+4,
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 4,4,4,4, 2,2,1,1],inf), 1/2),
			\gain, 0.1* Pstep(Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),1/8),
			//\legato, Pseq([1,0.5,0.7,1],inf),
			//\dur, 1/8,
		),
	])
)).play;
);
