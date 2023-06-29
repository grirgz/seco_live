
(
	~delaymatrix = (
		num: 8,
		knobs: [\delay, \delaymix, \distamp, \distpostamp, \distmix, \gain],
		knobspecs: (
			delay: \delay,
			delaymix: \unipolar,
			distamp: ControlSpec(0.1,10,\lin),
			distpostamp: ControlSpec(0.01,2,\lin),
			distmix: \unipolar,
			gain: \unipolar,
		),
		specs: (
			delayfac: ControlSpec(0,4,\lin),
		),
	);
	~delaymatrix.num.do { arg idx;
		~delaymatrix.specs[( \fbintab++idx ).asSymbol] = ParamArraySpec(\unipolar);
		~delaymatrix.knobs.do { arg key, knobidx;
			var idxkey = ( key++idx ).asSymbol;
			~delaymatrix.specs[idxkey] = ~delaymatrix.knobspecs[key];
		};
	};
SynthDef(\delaymatrix, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, maxdelay=0.4;
	var sig;
	var num = ~delaymatrix.num;
	var num2 = num * 2; // stereo
	var in;
	var fbintab = FbNode(num2);
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = num.collect { arg idx;
		var isig;
		var isig2;
		isig = in;
		isig = ( ( fbintab * (\fbintab++idx).asSymbol.kr(0 ! num).stutter(2) ).poll(label:"ch"++idx).sum * \fb.kr(0) ) + isig;
		
		isig2 = DelayL.ar(isig, maxdelay, (\delay++idx).asSymbol.kr(idx/10) * \delayfac.kr(1));
		isig = SelectX.ar((\delaymix++idx).asSymbol.kr(0.5), [isig, isig2]);
		isig2 = ( isig*( \distamp++idx ).asSymbol.kr(10) ).tanh * (\distpostamp++idx).asSymbol.kr(1/2);
		isig = SelectX.ar(( \distmix++idx ).asSymbol.kr(0.5), [isig, isig2]);
		isig = Limiter.ar(isig);
		isig = isig * ( \gain++idx ).asSymbol.kr(1);
		isig;
	};
	sig.debug("sig2");
	sig = HPF.ar(sig, \hpf.kr(200));
	fbintab.write(sig.flat);
	sig = sig.sum;
	sig.debug("sig3");
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:~delaymatrix.specs)).add;
);

~delaymatrix.specs
[1,2,3]+ [10,20]

(
Pdef(\delaymatrix, 
	Pmono(\delaymatrix,
		\inbus, BusDef(\sendbus1, \audio),
		\addAction, \addToTail,
		\maxdelay, 1,
		\lag, 0.0009,
		\dur, 1,
	)
).play;
);

Pdef(\delaymatrix).edit

(
WindowDef(\delaymatrix, { arg def;
	var num = ~delaymatrix.num;
	var model = Pdef(\delaymatrix);
	var knobs = ~delaymatrix.knobs;
	var paramkeys = [\fbintab, \fbin] ++ knobs;
	var gridl;
	//ParamGroupLayout.inline_groups(model.asParamGroup);
	gridl = GridLayout.columns(*
		[ paramkeys.collect({ arg k; StaticText.new.string_(k) }) ] ++
		num.collect { arg idx;
			[Param(model, (\fbintab++idx).asSymbol).asView] ++
			[Param(model, (\fbintab++idx).asSymbol -> idx).asKnob] ++
			knobs.collect { arg key; 
				Param(model, (key++idx).asSymbol).asKnob;
			};
		}
	);

	VLayout (
		HLayout (
			PlayerWrapper(model).asView,
			PlayerWrapper(Pdef(\part)).asView,
		),
		VLayout (*
			[\mix, \gain, \fb, \delayfac, \hpf].collect { arg key, idx;
				Param(model, key).asView;
			}
		),
		gridl
	)
	
}).front;
)


(1..4).stutter(2)


	Pdef(\delaymatrix).envir.clear;
(
	Pdef(\delaymatrix).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	Pdef(\delaymatrix).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);





(

{

	var in = Saw.ar([100,102])*Line.kr(1,0,0.1); // stereo input signal

	var fbNode = FbNode(2, 1.0);


	var signal = Mix.fill(10,{fbNode.delay(1.0.rand)});

	

	fbNode.write(in + (signal*0.1));

	// if you want, you can use FbNode as a normal multi-tap delay, just by not adding in the

	// feedback signal here.

	

	signal;


}.play;

)



//////////////////////////////



(
	// delay modulation
	~delaymatrix = (
		num: 8,
		knobs: [\delay, \delaymix, \distamp, \distpostamp, \distmix, \loopgain, \gain],
		knobspecs: (
			delay: \delay,
			delaymix: \unipolar,
			distamp: ControlSpec(0.1,50,\lin),
			distpostamp: ControlSpec(0.01,2,\lin),
			distmix: \unipolar,
			loopgain: ControlSpec(0,100,\lin),
			gain: \unipolar,
		),
		specs: (
			delayfac: ControlSpec(0.0001,4,\exp),
			delmodamp: ControlSpec(0,4,\lin),
			delmodfreq: \widefreq,
		),
	);
	~delaymatrix.num.do { arg idx;
		~delaymatrix.specs[( \fbintab++idx ).asSymbol] = ParamArraySpec(\unipolar);
		~delaymatrix.knobs.do { arg key, knobidx;
			var idxkey = ( key++idx ).asSymbol;
			~delaymatrix.specs[idxkey] = ~delaymatrix.knobspecs[key];
		};
	};
SynthDef(\delaymatrix2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, maxdelay=0.4;
	var sig;
	var num = ~delaymatrix.num;
	var num2 = num * 2; // stereo
	var in;
	var fbintab = FbNode(num2,0);
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = num.collect { arg idx;
		var isig;
		var isig2;
		var delmod;
		isig = in;
		isig = ( ( fbintab * (\fbintab++idx).asSymbol.kr(0 ! num).stutter(2) ).poll(label:"ch"++idx).clump(2).sum * \fb.kr(0) ) + isig;
		isig = isig * ( \loopgain++idx ).asSymbol.kr(1);
		
		delmod = LFPulse.ar(\delmodfreq.kr(0.1)) * \delmodamp.kr(1) + 1;
		delmod = delmod * ( LFPulse.kr(\delmodfreq.kr * 2) * 0.4 + 1 );
		isig2 = DelayL.ar(isig, maxdelay, (\delay++idx).asSymbol.kr(idx/10) * \delayfac.kr(1) * delmod);
		isig = SelectX.ar((\delaymix++idx).asSymbol.kr(0.5), [isig, isig2]);
		isig2 = ( isig*( \distamp++idx ).asSymbol.kr(10) ).softclip * (\distpostamp++idx).asSymbol.kr(1/2);
		isig = SelectX.ar(( \distmix++idx ).asSymbol.kr(0.5), [isig, isig2]);
		isig = HPF.ar(isig, \ihpf.kr(40));
		isig = LPF.ar(isig, \ilpf.kr(19940));

		//isig = RLPF.ar(isig, ( \lpf.kr(500) * ( Amplitude.kr(isig).lag(0.04) * 4.8 + 1 ) ).poll, \rq.kr(0.4));

		isig = Limiter.ar(isig);
		isig;
	};
	sig.debug("sig2");
	sig = HPF.ar(sig, \hpf.kr(50));
	fbintab.write(sig.flat);
	sig = sig * num.collect { arg idx; ( \gain++idx ).asSymbol.kr(1) };
	sig = sig.sum;
	sig.debug("sig3");

	//sig = RLPF.ar(sig, ( \lpf.kr(900) * ( Amplitude.kr(sig).lag(0.04) * 4.8 + 1 ) ).poll, \rq.kr(0.4));

	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}, metadata:(specs:~delaymatrix.specs)).add;
Pdef(\delaymatrix2).reset;
);

(
WindowDef(\delaymatrix2, { arg def;
	var num = ~delaymatrix.num;
	var model = Pdef(\delaymatrix2);
	var knobs = ~delaymatrix.knobs;
	var paramkeys = [\fbintab, \fbin] ++ knobs;
	var gridl;
	//ParamGroupLayout.inline_groups(model.asParamGroup);
	gridl = GridLayout.columns(*
		[ paramkeys.collect({ arg k; StaticText.new.string_(k) }) ] ++
		num.collect { arg idx;
			[Param(model, (\fbintab++idx).asSymbol).asView] ++
			[Param(model, (\fbintab++idx).asSymbol -> idx).asKnob] ++
			knobs.collect { arg key; 
				Param(model, (key++idx).asSymbol).asKnob;
			};
		}
	);

	VLayout (
		HLayout (
			PlayerWrapper(model).asView,
			PlayerWrapper(Pdef(\part)).asView,
		),
		VLayout (*
			[\mix, \wetgain, \gain, \fb, \delayfac, \hpf, \delmodfreq, \delmodamp, \ilpf, \ihpf].collect { arg key, idx;
				Param(model, key).asView;
			}
		),
		gridl
	)
	
}).front;
)

(
Pdef(\delaymatrix2, 
	Pmono(\delaymatrix2,
		\inbus, BusDef(\sendbus1, \audio),
		\addAction, \addToTail,
		\maxdelay, 1,
		\out, BusDef(\sendbus2, \audio),
		\lag, 0.0009,
		\dur, 1,
	)
).play;
);

(
	Pdef(\delaymatrix2).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);
(
	Pdef(\delaymatrix2).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	Pdef(\delaymatrix2).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	Pdef(\delaymatrix2).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([ 1,0.9,1.2,1, 1.1,1.2,1.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.0,0.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.2,1.3,1.5, ],1),
				Pshuf([ 1,0.9,1.2,1, 1.1,1.2,0.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.2,1.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.0,0.3,1.5, ],1),
				Prand([2,0.2],16),
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,1/2,
				1,1/2,
				1,1/2,
				1/2,1/2,

				1,1/2,
				1,1/2,
				1,4/5,
				1,1/2,

				1,1/2,
				1,1/2,
				1,1/2,
				1/2,1/2,

				1,1/2,
				1/2,1/2,
				1/2,1/2,
				1,1,
			],inf).coin.not,
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);
(
~delaymatrix.num.do { arg idx;
	Pdef(\delaymatrix2).set((\delay++idx).asSymbol, rrand(0.001,1));
};
)

(
~delaymatrix.num.do { arg idx;
	Pdef(\delaymatrix2).set((\delay++idx).asSymbol, exprand(1/80,1));
};
)



////////////////////// compare with rdn

	(
		// rdnstudy1_orig
	SynthDef(\rdnstudy1, { arg out=0, gate=1;
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
		thisThread.randSeed = 386847.0;
		si = sig;
		sig = { arg si, env;
			si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
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
	Pdef(\part).reset;
	)


~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

	SynthDef(\rdnstudy1, { arg out=0, gate=1;
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
		var xx;
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

		//sig = LPF.ar(sig, \prelpf.kr(17000));
		//sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		//sig = LPF.ar(sig, \lpf.kr(17000));
		//sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 386847.0;
		si = sig;
		sig = { arg si, env;
			//si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			//si = [
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					////si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				//}.value(si, env);
				//,
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				//}.value(si, env);

			//].mean;
			//si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 3;
			//si = FreqShift.ar(si, 0);
			//si = si * 8;
			//si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.4, 0.00001);
			si = si * 8 * 4 * 2;
			//BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		//sig1 = sig;
		//#afreq, hasFreq = Pitch.kr(sig1).flop;
		//sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		//#afreq, hasFreq = Pitch.kr(sig1).flop;
		//sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		//sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		//sig = LPF.ar(sig, \postlpf.kr(17000));
		//sig = HPF.ar(sig, \posthpf.kr(17));
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
	Pdef(\part).reset;


	Pbind(
		'wet10', 1.0,
		'mix', 0.7436974789916,
		'gain', 1.0,
		'fb', 0.026650894586569,
		'delay', 0.00011674193588235,
		'delay2', 0.00011674193588235,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 0.53838436220335,
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\rdnstudy1,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <>
		Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 1.0,
			'fb', 0.026650894586569,
			'delay', 0.00011674193588235,
			'delay2', 0.00011674193588235,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.53838436220335,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);


////////////// test freqshift
(
	// sin
SynthDef(\testfreqshift, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = FreqShift.ar(sig, 0);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	// whitenoise
SynthDef(\testfreqshift, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar(1);
	sig1 = FreqShift.ar(sig, 0);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	// whitenoise + 2 freqshift
SynthDef(\testfreqshift, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar(1);
	sig1 = FreqShift.ar(sig, 0);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig1 = FreqShift.ar(sig, 0);
	sig = SelectX.ar(\mix2.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	mix2: \unipolar
))).add;
);

(
	// delay
SynthDef(\testfreqshift, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar(1);
	sig1 = DelayL.ar(sig, 0.4, \delay.kr(0));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\testfreqshift,
		Pmono(\testfreqshift,
			\dur, 1,
		)),
		
	])
)).play;
);

Pdef(\testfreqshift).edit

//////////////// distfb

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + tanh
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);
	
		isig1 = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + distort
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);
	
		isig1 = ( isig*\distamp.kr(10) ).distort * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + clip
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);


	
		isig1 = ( isig*\distamp.kr(10) ).clip2(1) * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + tanh
	// freqshift
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);
	
		isig1 = FreqShift.ar(isig, 0);
		isig = SelectX.ar(\fsmix.kr(0.5), [isig, isig1]);
		isig1 = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + tanh
	// BRF
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);
	
		//isig1 = BRF.ar(isig, 6446);
		isig1 = BRF.ar(isig, \brf.kr(246));
		isig = SelectX.ar(\fsmix.kr(1.0), [isig, isig1]);
		isig1 = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
	fsmix: \unipolar,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + tanh
	// EQui
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);
	
		//isig1 = BRF.ar(isig, 6446);
		//isig1 = BRF.ar(isig, \brf.kr(246));
		isig1 = isig.equi;
		isig = SelectX.ar(\fsmix.kr(1.0), [isig, isig1]);
		isig1 = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
	fsmix: \unipolar,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// LocalIn
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var isig;
	var isig1;
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + ( LocalIn.ar(2) * \fb.kr(1));
	isig = sig * \loopgain.kr(1);
	
	isig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
	isig = Limiter.ar(isig);

	sig = isig;

	LocalOut.ar(sig);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
))).add;
);


(
	// kick
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\distfb,
		Pmono(\distfb,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	// snare
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\distfb, Pmono(\distfb,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\distfb, Pmono(\distfb,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		)),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([ 1,0.9,1.2,1, 1.1,1.2,1.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.0,0.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.2,1.3,1.5, ],1),
				Pshuf([ 1,0.9,1.2,1, 1.1,1.2,0.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.2,1.3,1.5, ],1),
				Pseq([ 1,0.9,1.2,1, 1.1,1.0,0.3,1.5, ],1),
				Prand([2,0.2],16),
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,1/2,
				1,1/2,
				1,1/2,
				1/2,1/2,

				1,1/2,
				1,1/2,
				1,4/5,
				1,1/2,

				1,1/2,
				1,1/2,
				1,1/2,
				1/2,1/2,

				1,1/2,
				1/2,1/2,
				1/2,1/2,
				1,1,
			],inf).coin.not,
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8 / 8 / 2,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

Pdef(\distfb).edit;
(
	// gui for equi
WindowDef(\win, { arg def, model;
	var equikeys = EQuiParams.new.asArgsArray.clump(2).flop[0] ++ [\lagEQ];
	model = model ?? { Pdef(\distfb) };
	VLayout (
		HLayout (
			PlayerWrapper(model),
			PlayerWrapper(Pdef(\part)),
		),
		HLayout (
			model.asParamGroup.rejectByKey(equikeys).asView,
			EQui(nil,nil,model).asView.minSize_(400,100),
		)
	)
	
}).front;
)

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + tanh
	// delay
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var maxdel= 0.4;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);

		isig1 = DelayL.ar(isig, maxdel, \delay.kr(0.01));
		isig = SelectX.ar(\delmix.kr(1.0), [isig, isig1]);
	
		//isig1 = BRF.ar(isig, 6446);
		isig1 = BRF.ar(isig, \brf.kr(246));
		isig = SelectX.ar(\fsmix.kr(1.0), [isig, isig1]);
		isig1 = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
	fsmix: \unipolar,
))).add;
Pdef(\part).reset;
);

(
	// recreate dist rdn with only a dist and a feedback
	// Fb + tanh
	// delay + muter
SynthDef(\distfb, { arg out=0, gate=1;
	var sig;
	var maxdel= 0.4;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * \ingain.kr(1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = isig * \loopgain.kr(1);

		isig1 = DelayL.ar(isig, maxdel, \delay.kr(0.01));
		isig = SelectX.ar(\delmix.kr(1.0), [isig, isig1]);
	
		isig1 = BRF.ar(isig, 1/\delay.kr, \muterq.kr(0.5));
		isig = SelectX.ar(\mutermix.kr(1.0), [isig, isig1]);

		//isig1 = BRF.ar(isig, 6446);
		isig1 = BRF.ar(isig, \brf.kr(246), \brrq.kr(0.5));
		isig = SelectX.ar(\fsmix.kr(1.0), [isig, isig1]);
		isig1 = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	ingain: \gain,
	fsmix: \unipolar,
	delmix: \unipolar,
	mutermix: \unipolar,
	muterq: \rq,
	brrq: \rq,
))).add;
Pdef(\part).reset;
);

(
	// gui simple
WindowDef(\win, { arg def, model;
	var equikeys = EQuiParams.new.asArgsArray.clump(2).flop[0] ++ [\lagEQ];
	model = model ?? { Pdef(\distfb) };
	VLayout (
		HLayout (
			PlayerWrapper(model),
			PlayerWrapper(Pdef(\part)),
		),
		HLayout (
			model.asParamGroup.rejectByKey(equikeys).asView,
			//EQui(nil,nil,model).asView.minSize_(400,100),
		)
	)
	
}).front;
)
/////////// side band modulation
// freqshift is single side band modulation
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1, amfreq=100;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = sig * ( SinOsc.ar(amfreq) * 1 + 1 );
	sig2 = sig * ( SinOsc.ar(amfreq, \phase.kr(0)*pi) * 1 + 1 );
	sig3 = sig1 + sig2;
	sig4 = sig1 - sig2;
	sig5 = sig2 - sig1;
	sig = SelectX.ar(\mix.kr(0.5) * 5, [sig, sig1, sig2, sig3, sig4, sig5]);
	sig = sig / 2;

	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit
