
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
