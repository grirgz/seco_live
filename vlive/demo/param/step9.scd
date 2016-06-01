///////////////// in this file: mainly DrumRack code

DrumRack(\plop).loadDrumrack(\newrack);
(
EventPrototype.initPrototypes(true);
SynthDef(\dr_kick, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;

/////////////////////////////

DrumRack(\plop);

	////////////////

	Pdef(\dr_kick, Pbind(
		\instrument, \dr_kick,

	));
	Pdef(\dr_kick).addSpec(\env0, XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ));
	Pdef(\dr_kick).addSpec(\env1, XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ));
	Pdef(\dr_kick).addHalo(\instrument, \dr_kick);
	Pdef(\dr_kick).addHalo(\params, [
		\amp, \env0, \env1, [\fratio, ControlSpec(0,20,\lin)]
	]);
	//Param.getSynthDefDefaultValue(\env0, \dr_kick).asEnv

	DrumRack.addInstr(\dr_kick);

	////////////////

	Pdef(\dr_kick2, Pbind(
		\instrument, \dr_kick,

	));

	Pdef(\dr_kick2).addHalo(\params, [
		\amp, \fratio, \timeScale
	]);

	DrumRack.addInstr(\dr_kick2);

	////////////////

	Pdef(\dr_kick3, Pbind(
		\instrument, \dr_kick,

	));

	Pdef(\dr_kick3).addHalo(\params, [
		\amp, \fratio, \timeScale, \release, \freqpan, \spread,
	]);

	DrumRack.addInstr(\dr_kick3);

//DrumRack.all[\plop] = nil;
//DrumRack.lib_drumrack[\default] = nil;

//~pg = ~class_presetgroup.new;
//~pg2 = ~class_presetgroup.new;
//~p1 = ~class_preset.new(\dr_kick);
//~p2 = ~class_preset.new(\dr_kick2);
//~p3 = ~class_preset.new(\dr_kick3);
//
//~pg.add_preset(~p1);
//~pg2.add_preset(~p2);
//~pg2.add_preset(~p3);
//DrumRack.lib_drumpad[\note1] = ~pg;
//DrumRack.lib_drumpad[\note2] = ~pg2;

DrumRack(\plop).edit;
)

DrumRack(\plop).asArchiveData
DrumRack.all.save
Archive.global.at(\PresetDictionary, \DrumRack)
Archive.global.at(\PresetDictionary, \DrumRack)[\plop]

DrumRack(\plop).drumrack.get_pad(0)
DrumRack(\plop).drumrack.list.size
Archive
Object
DrumRack
PresetDictionary(\lib_drumrack)[\het]
PresetDictionary(\lib_drumrack).keys
PresetDictionary.loadAll
PresetDictionary.all.keys
PresetDictionary(\lib_drumrack).clear
DrumRack.all[\plop].drumrack = PresetDictionary(\lib_drumrack)
DrumRack.all[\plop] = nil
DrumRack.lib_drumrack.keys

Archive.global.at(\PresetDictionary, \lib_drumrack)
Archive.global.at(\PresetDictionary)[\lib_drumrack].keys
Archive.global.at(\PresetDictionary)[\lib_drumrack][\het]

Archive.global.put(\PresetDictionary, \lib_drumrack, nil)
Archive.write

this.shutdown
thisProcess.shutdown
1+1

StepSeq(\sc1).edit;
StepSeq(\sc1).stepseq.trackCount = 16;

Pdef(\score, Ppar(
	StepSeq(\sc1).patterns.collect({ arg pat, x;
		Pbind(
			\whatthefuck, Pfunc{ arg ev; ev.debug("EV!!!"); \non },
			\isRest, pat.coin.not,
			\midinote, x,
			\dur, 1/4,
		).loop;
	})
).loop);

//////////////////////


Archive.global.at(\PresetDictionary).keys

(
Pdef(\test, Ppar([
	Pbind(\instrument, \1),
	Pbind(\instrument, \2),
	Pbind(\instrument, \3),
]))
)
Pdef(\test).source.list

~data = ~p1.asArchiveData
~data.load

~data = ~pg.asArchiveData
~data.load

DrumRack(\plop).drumrack
~a = DrumRack(\plop).edit
~a.drumrack.pads.size

DrumRack.lib_drumrack[\default]
DrumRack.lib_drumrack[\het]
DrumRack.lib_drumrack.keys
PresetDictionary.loadAll
PresetDictionary.all.keys
PresetDictionary.all = IdentityDictionary.new;
PresetDictionary(\lib_drumrack)
PresetDictionary(\StepSeq)

DrumRack(\plop).drumrack = ~class_drumrack.new;
DrumRack.lib_drumrack.get_list.first
~class_drumrack_view.new(DrumRack(\plop));

			"/home/ggz/code/sc/seco/vlive/demo/param/lib/drumrack.scd".load;
DrumRack.lib_drumpad.load
DrumRack.lib_drumpad.keys
DrumRack.lib_drumpad.save
DrumRack.lib_drumpad.collect({ arg x; x.dump })
DrumRack.lib_drumpad[\ddd]
DrumRack.lib_drumpad[\note1]
Archive.global.put(\PresetDictionary, \bla, 2)
Archive.global.put(\PresetDictionary, 3, nil)
Archive.global.put(\PresetDictionary, 2, nil)
Archive.global.put(\PresetDictionary, \lib_drumrack, nil)
Archive.global.removeAtPath([\PresetDictionary])
Archive.global.at(\PresetDictionary)
Archive.global.at(\PresetDictionary).keys
Archive.global.at(\PresetDictionary)[\lib_drumrack].keys
Archive.global.at(\PresetDictionary)[\lib_drumrack][\default]
Archive.global.at(\PresetDictionary)[\lib_drumpad].keys
Archive.global.keys
Archive.global.dictionary.keys
Archive.global.put(\testndef, nil)
Archive.write

DrumRack(\plop).drumrack.asArchiveData.asCompileString

(
Pn(DrumRack(\plop, Pbind(
	\midinote, Pseq([0,1,1,0,2,2],inf),
	\dur, 1/4,
))).play;
)
Pdef(\plop).play

~p1.params
~p1.instr
~p1.paramlist
~pg.paramlist
~pg.list.first.paramlist

DrumRack(\plop).drumrack.get_pad(0).play_preset
DrumRack(\plop).drumrack.get_pad(0).play_preset
/////////////////////////////////////////////////////////////////////

Pdef(\dr_kick).play
Pdef(\dr_kick).asParamGroup.edit
Pdef(\dr_kick).addHalo(\instrument, \dr_kick)
Param(Pdef(\dr_kick), \env0).edit
(
ParamGroup([ 
	Param(Pdef(\dr_kick), \env0) ,
	Param(Pdef(\dr_kick), \env1) ,
]).edit
)

	Param(Pdef(\dr_kick), \env0).default
DrumRack(\plop).edit
DrumRack(\plop).play

DrumRack.addInstr(Pdef(\dr_kick), [
	\env0, \env1, [\fratio, ControlSpec(0,20,\lin)]
]);
DrumRack.addInstr(Pdef(\dr_snare), [
	\env0, \env1, [\fratio, ControlSpec(0,20,\lin)]
]);

Pseq(
	DrumRack(\plop).asPattern(
		Pbind(
			\midinote, Pseq([1,2,3,4,5,6]),
			\dur, 1/4
		)
	),
	DrumRack(\bla).asPattern(
		Pbind(
			\midinote, Pseq([1,2,3,4,5,6]),
			\dur, 1/4
		)
	),
)

Pseq(
	DrumRack(\plop).asPattern(
		Pdemul(
			DrumRack(\plop)
			Pbind(
				\midinote, Pseq([1,2,3,4,5,6]),
				\dur, 1/4
			)
			
		)
	)
)

	DrumRack(\plop).asPattern( StepSeq(\yep) ).play;
	WindowLayout({ HLayout(DrumRack(\plop).asView, StepSeq(\yep).asView)  })
	StepSeq(\norta).edit



(
	(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\dr_kick, 
		PlazyEnvir({ arg freqfac=2, lpf=300;
			freqfac.debug("freqfaq");
			Pbind(
				\instrument, \saw,
				\freq, freqfac * Pseq([100,137,120,125]),
				\amp, Pkey(\amp) * 3,
			)
		}).loop;
	);
	Pdef(\dr_kick).play;
)
	Pdef(\dr_kick).set(\freqfac, 3.3);
	Pdef(\dr_kick).set(\freqfac, 1.155);
	Pdef(\dr_kick).unset(\freqfac);
	Pdef(\dr_kick).set(\lpf, 2000);
	Pdef(\dr_kick).set(\lpf, 1000);
	Pkey


(
	(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\dr_kick, 
		Pbind(
			\instrument, \saw,
			\freq, Pkeyd(\freqfac, 4) * Pseq([100,137,120,125],inf),
			\amp, Pkey(\amp) * 3,
		)
	);
	Pdef(\dr_kick).play;
)

(
	(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\dr_kick, 
		Pbind(
			\instrument, \saw,
			\freqfac, Pkeyd(\freqfac, 4),
			\freq, Pkey(\freqfac) * Pseq([100,137,120,125],inf),
			\amp, Pkey(\amp) * 3,
		)
	);
	Pdef(\dr_kick).play;
)

		Archive.global.at(\PresetDictionnary)


~a = (bla: 4, fun:{ arg self, x=100; x+1 })
~a.tryPerform(\fun)
~a.perform(\fun)
~a.fun

~ssm = StepSeqManager.new(8)
~ssm.make_window

		"/home/ggz/code/sc/seco/vlive/demo/param/lib/stepeditor.scd".load;
		~class_score_manager.new

CaTestClass.my = 1000
CaTestClass.my 
CbTestClass.my 
EventPrototype.initPrototypes(true)
StepSeq.all.save
EventPrototype.new



Archive.global.at(\PresetDictionary, \StepSeq, \het, \stepseq, \data, \banks)
Archive.global.at(\PresetDictionary, \StepSeq, \het, \stepseq).load
Archive.global.at(\PresetDictionary, \StepSeq, \het).load
Archive.global.put(\PresetDictionary, \StepSeq, \het, nil)

PresetDictionary.loadIfNotInitialized

StepSeq(\het).edit
StepSeq(\het).setStepSpec(\unipolar)
StepSeq(\het).setStepSpec(\bipolar)
StepSeq(\het).stepseq.setStepSpec(\unipolar)
StepSeq(\het).stepseq.banks[0][1].getSpec(\list)
StepSeq(\het).addSpecgtg
StepSeq(\het).stepseq
StepSeq(\het).stepseq.asArchiveData
StepSeq.new(\het).
StepSeq.save
Archive.write

	(
	{ arg self, spec;
		self.banks.do { arg bank;
			bank.do { arg list;
				list.addSpec(\list, spec);
				list.debug("list===");
				list.getSpec(\list).debug("spec");
			}
		};
		self.addSpec(\list, spec);
	}.value(StepSeq(\het).stepseq, \unipolar);
	)



///////////////////////////////////////////////////


BufDef(\viper, "vipere/DrumRack")
~s = SampleProxy.new("/home/ggz/Musique/sc/samplekit/vipere/amenbreak.wav" )

		BufDef(\amen, "vipere/amenbreak.wav");

(instrument: \playbuf, bufnum:~s).play
(instrument: \playbuf, bufnum:BufDef(\amen)).play

(
SynthDef(\playbuf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), 1, 1, startPos: 0, doneAction:2, loop: 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)


~s = SampleProxy("/home/ggz/Musique/boom1.wav")
SampleProxy("/home/ggz/Musique/boom1.wav").bufnum
SampleProxy("/home/ggz/Musique/boom1.wav").source.play
