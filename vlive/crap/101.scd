(
~t=1;
SynthDef(\glitch, {
arg freq1=40,freq2=200,freq3=100,dec1=1,dec2=0.5,gain=250,index=100,hFreq=1000,lFreq=10000,amp=0.125;

var aEnv = Decay.ar(Impulse.ar(0),dec1);
var pEnv = Decay.ar(Impulse.ar(0),dec2);
var free;

var sound;
var lfemix = \lfemix.kr(1);
var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
var sig;
var kick;
var cfreq;
var coin;
//pEnv = 1;
aEnv = aEnv + Decay.ar(Impulse.ar(0),dec1 * 1.5).log;
aEnv = EnvGen.ar(\env.kr(Env([0,1,0,0,0],[0.001,1,0,0])), timeScale:\timeScale.kr(1), doneAction:2);
lFreq = ( lFreq * ( 1-lfemix ) ) + ( lfemix * aEnv ).clip(0.0001,inf);
//sound = Pan2.ar(Saw.ar(freq1,0.25),Saw.ar(freq2+SinOsc.ar(freq3*pEnv,0,index)))*gain;
//sound = Pan2.ar(aEnv,Saw.ar(freq2+SinOsc.ar(freq3*pEnv,0,index)))*gain;
//freq1 = LFSaw.ar(1/55,2/4 * 2pi).range(ExpRand(50,17000),ExpRand(50,17000));
//freq2 = LFSaw.ar(1/45,1/4 * 2pi).range(ExpRand(50,17000),ExpRand(50,17000));
//freq3 = LFSaw.kr(1/43).range(ExpRand(50,17000),ExpRand(50,7000));
//freq1 = aEnv * freq1;
//freq2 = aEnv * freq2;
coin = { arg x; Select.kr(Rand(0,1), x) };
cfreq = { arg x; ( coin.([0,1])-aEnv )/4 + 1 * x };
cfreq = { arg x; ( coin.([0-aEnv,aEnv]) )/40 + 1 * x };
freq1 = ExpRand(50,15000);
freq2 = ExpRand(50,15000);
freq3 = ExpRand(50,15000);
freq1 = cfreq.(freq1);
freq2 = cfreq.(freq2);
freq3 = cfreq.(freq3);
sig5 = LFPulse.ar(freq3) + Saw.ar(freq2) + SinOsc.ar(freq1);
sig5 = sig5 * aEnv;

kick = SinOsc.ar(XLine.kr(\kickhi.kr(500),\kicklo.kr(60),[0.1,0.1]*\kicktimefac.kr(1/5)));

sig5 = SelectX.ar(\kickmix.kr(1), [sig5, kick]);

sig1 = Pan2.ar(aEnv,sig5)*gain;
sig2 = (sig5)*gain;

sound = SelectX.ar(\mix.kr(0.1), [sig1, sig2]);
sound = HPF.ar(sound,hFreq);
sound = sound*PinkNoise.ar;
sound = LPF.ar(sound,lFreq * [1,1/2,1/3]);
sound = sound.tanh;
sound = sound / 6;
sound = SelectX.ar(\kickmix2.kr(0.11), [sound, kick]);
sig1 = CombL.ar(sound, 1/20, 1/50 * [1,1/1.3,1.7,2] ++ SinOsc.kr([ 1/44, 1/47 ]).range(1,[2.0.rand,1/2.0.rand]),0.1 * SinOsc.kr(1/4,3/2 * pi).range(0,10)) + sound;
sound = SelectX.ar(\combmix.kr(0.5), [sound, sig1]);
sound.debug("sound");
sound = sound*aEnv;
//free = DetectSilence.ar(sound,doneAction:2);
sound = LeakDC.ar(sound);
sound = Pan2.ar(sound, Rand(-1 ! sound.size, 1), 1).flop;

Out.ar(0,sound*amp);
}).store;
)

(
Pbind(
	\instrument, \glitch,
'dur', 9.967213,
'legato', 0.800000,
'freq1', 0.106897,
'freq2', 40.000000,
'freq3', 175.527928,
'dec1', 4.189605,
'dec2', 0.139584,
'gain', 140,
'index', 100.000000,
'hFreq', 0.271964,
'lFreq', 2503.017054,
'amp', 0.717400,
'lfemix', 0.673224,
'env', Env([ 0.00010000000474975, 1.0, 0.4685994386673, 0.46859859369227, 0.0  ], [ 0.0, 0.0572865124266, 0.06030115947163, 0.88341195718205  ], [ 0, 0, 0, -4  ]),
'timeScale', 8.214754,
'mix', 0.100000,

).play
)

{ SinOsc.ar(20,1/4 * 2pi) }.plot(1/20)

EnvInit(\glitch,StepEvent.new);
(
Pdef(\glitch,  Pbind(
	\instrument, \glitch,
	\degree, Pseq([0],inf),
	\dur, Pkeyd(\dur,1),
	\amp, Pkeyd(\amp,0.1),
)).play;
Pdef(\glitch).addHalo(\instrument, \glitch);
Pdef(\glitch).addSpec(\env, XEnvSpec( ControlSpec(0,1,\lin)!5 ));
Pdef(\glitch).addSpec(\lfemix, \unipolar);
Pdef(\glitch).addSpec(\kickmix, \unipolar);
Pdef(\glitch).addSpec(\kickmix2, \unipolar);
Pdef(\glitch).addSpec(\combmix, \unipolar);
);
Pdef(\glitch).asParamGroup.edit;
Pdef(\glitch).asParamGroup.print
Pdef(\glitch).asParamGroup.collect({ arg p; "%, %,\n".format(p.property.asCompileString, p.get.asCompileString) }).join("")


(
ParamProto.init;
ParamGroupDef(\glitch, Pdef(\glitch).asParamGroup);
WindowDef(\glitch, {
	var player = Pdef(\glitch), pg = ParamGroupDef(\glitch);
	var lay;
	lay = ParamGroupLayout.two_panes(pg, \property);
	VLayout (
		HLayout (
			PlayerWrapper(player).asView,
			EventClass.presetSelectorView.(pg),
		),
		ScrollView.new.canvas_(View.new.layout_(lay));
	);
}).front
)

Pdef(\seq2).play;
Pdef(\glitch).setBusMode(\freq1)

(
Pdef(\seq1,
Pbind(
\instrument, \glitch,
\freq1, Pwhite(1,5000),
\freq2, Pwhite(1,5000),
\freq3, Pwhite(1,15000),
\hFreq, Pwhite(50,5000),
\lFreq3, Pwhite(5000,15000),
\index, Pwhite(5,50000),
\dec1, Pwhite(0.05,0.25),
\dec2, Pwhite(0.05,0.25),
\dur, 0.33
))
)
(
Pdef(\seq2,
Pbind(
\instrument, \glitch,
\freq1, Pseq(Array.geom(1,1,2.5),inf),
\freq2, Pseq(Array.geom(1,1,1.5),inf),
\freq3, Pseq(Array.geom(15,10,2),inf),
\hFreq, Pseq(Array.geom(10,10,4),inf),
\lFreq3, Pseq(Array.geom(10,1000,1.125),inf),
\index, Pseq(Array.geom(24,1,2),inf),
\dec1, Pwhite(0.05,0.5),
\dec2, Pwhite(0.05,0.5),
\amp, 1,
\dur, 0.125
))
)
(
Pdef(\seq3,
Pbind(
\instrument, \glitch,
\freq1, Pseq(Array.geom(4,1.5,2.5),inf),
\freq2, Pseq(Array.geom(7,1.5,1.5),inf),
\freq3, Pseq(Array.geom(15,10,2),inf),
\hFreq, Pseq(Array.geom(10,10,4),inf),
\lFreq3, Pseq(Array.geom(10,1000,1.125),inf),
\index, Pseq(Array.geom(24,1,2),inf),
\dec1, Pwhite(0.05,0.5),
\dec2, Pwhite(0.05,0.5),
\amp, 1,
\dur, 0.49
))
)
(
Pdef(\seq4,
Pbind(
\instrument, \glitch,
\freq1, Pseq(Array.geom(4,1.5,2.5),inf),
\freq2, Pseq(Array.geom(7,1.5,1.5),inf),
\freq3, Pseq(Array.geom(15,10,2),inf),
\hFreq, Pseq(Array.geom(10,10,4),inf),
\lFreq3, Pseq(Array.geom(10,1000,1.125),inf),
\index, Pseq(Array.geom(24,1,2),inf),
\dec1, Pwhite(0.5,2),
\dec2, Pwhite(0.5,2),
\amp, 1,
\dur, 1
))
)


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	//sig = SinOsc.ar(freq * 1);
	//sig = Pan2.ar( SinOsc.ar(freq * SinOsc.ar(100).range(14.01,1)), sig, amp);
	//sig = Pan2.ar( SinOsc.ar(8).round(0.2), sig, amp);
	//sig = Pan2.ar( SinOsc.ar(200)!2, 1, amp);
	sig = Pan2.ar( SinOsc.ar(202 * ( 1 + ( SinOsc.ar(50) * 1 ))), SinOsc.ar(201), amp);
	//sig = SinOsc.ar(freq * SinOsc.ar(100).range(14.01,1)) ! 2 * 0.1;
	sig = LeakDC.ar(sig);
}).play;
);
s.scope
Ndef(\plop).edit

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * 1);
	//sig = Pan2.ar( SinOsc.ar(freq * SinOsc.ar(100).range(14.01,1)), sig, amp);
	sig = Pan2.ar( SinOsc.ar(8), sig, amp);
	//sig = Pan2.ar( SinOsc.ar(200)!2, 1, amp);
	//sig = Pan2.ar( SinOsc.ar(202 * ( 1 + ( SinOsc.ar(50) * 1 ))), SinOsc.ar(201), amp);
	//sig = SinOsc.ar(freq * SinOsc.ar(100).range(14.01,1)) ! 2 * 0.1;
	sig = LeakDC.ar(sig);
}).play;
);


ProtoEvent.init
EventProto
ClassProto
ParamProto.init

~modStepTimeline.new(\glitch).edit
~modStepTimeline.new(\glitch).drumrack = DrumRack(\yep)

(
Ndef(\kilik).put(0, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = (sig*800).tanh;
	sig = SelectX.ar( LFPulse.kr(1/2 * LFPulse.kr(1/4)), [sig, sig1]);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\kilik).put(1, \set -> Pbind(
	\freq, Pseq([50,80,60,Pwhite(100,900,1)],inf),
	\dur, Pseq([1,1,1,1+4],inf),

	
));
)

(
Ndef(\kilik).put(0, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var wob = \wob.kr(8);
	sig = SinOsc.ar(freq * SinOsc.ar(wob.lag(1)).range(1,2));
	sig1 = (sig*800).tanh;
	sig = SelectX.ar( LFPulse.kr(1/2 * LFPulse.kr(1/4)), [sig, sig1]);
	sig = RLPF.ar(sig, \lpf.kr(500) * SinOsc.kr(wob).range(2,1), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\kilik).put(2, \set -> Pbind(
	\wob, Pseq([2,8,16,360],inf),
	\dur, Pseq([1,1,1,1+4],inf),

	
));
)


Digt
(
ParamGroupDef.update(\bla, [
	Param(Pdef(\bb), \bla),
	Param(Pdef(\bb), \bli),
	Param(Pdef(\bb), \blo),
]);
)

(
ParamGroupDef.update(\bla, [
	//Param(Pdef(\bb), \bla),
	Param(Pdef(\bb), \bli),
	Param(Pdef(\bb), \blo),
]);
)

Archive.global.read
Archive.read;
Archive.write;
(
ParamProto.init;
Pdef(\bb, Pbind());
ParamGroupDef(\bla, [
	Param(Pdef(\bb), \bla),
	Param(Pdef(\bb), \bli),
]);
WindowDef(\bla, {
	var pg = ParamGroupDef(\bla);
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\bb)).asView,
			EventClass.presetSelectorView.(pg),
		),
		ParamGroupLayout.two_panes(pg, \property),
	)
}).front;
//ParamGroupDef(\bla).edit;
)
ParamGroupDef(\bla).clear
