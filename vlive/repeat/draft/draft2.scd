
ProtoDef(\worldfx, ProtoTemplateDef(\rdn))
ProtoDef(\worldfx).loadDefaultPreset
ProtoDef(\worldfx).genfx
ProtoDef(\worldfx).edit
ProtoDef(\worldfx).play
(
Ndef(\world_listen, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	Out.ar(\sendbus.kr(BusDef(\sendbus0, \audio)),sig);
	Silent.ar;
	sig;
	
}).play;
);

Ndef(\world_listen).play;
{ SinOsc.ar(200) ! 2 * 0.1}.play;

(
	~init_master = {

ProtoDef(\worldfx).play;
	};
	~init_master.();
	Pdef(\drums, Ptpar([
		0, Pbind(
			\isRest, Pseq([
				Pseq({[
					1,0,1,0, 1,0,1,0,
				].clump(8).choose}.dup(4).flat,inf)
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/4,
			//\out, BusDef(\sendbus0,\audio),
			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.hiphop.kick.value,
		0, Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\sustain, 1/2,
			\out, BusDef(\sendbus0,\audio),
			//\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.hiphop.snare.value,
		0, Pbind(
			\isRest, Pseq([
				Pseq({[
				0,0,1,0, 1,0,1,0,
				0,1,1,0, 1,0,1,0,
				0,0,1,0, 1,1,1,0,
				].clump(8).choose}.dup(4).flat,inf)
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,0, 0,1,1,1,
			],inf).coin.not.stutter(1),
			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.trap.hat.value,
		0, Pbind(
			\out, BusDef(\sendbus0,\audio),
			\instrument, \basskick,
			\freqenv, Pseq([
				[ Env.new([210, 38.midicps, 35.midicps], [0.005, 0.49], [-4, -5]) ],
				[ Env.new([210, 38.midicps, 39.midicps], [0.005, 0.49], [-4, -5]) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,1,1,0,
				1,1,1,0, 0,1,1,1,
				0,0,0,0, 0,1,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,0.1,0.1, 1,0.1,0.51,0,
				0,0,0,0, 0,1,1,1,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,1,1,1,
			],inf).coin.not,
			\degree, Pseq([0],inf),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				//0.3,0.5,1,0.5,
				0.7,1,
			],inf),
		),
	])).play;
)


(
SynthDef(\basskick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \ampenv.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \freqenv.kr(Env.new([210, 35.midicps, 35.midicps], [0.005, 0.49], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\bass, 
	Pbind(
	\instrument, \basskick,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.1
)
).play;
);
