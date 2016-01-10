
(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=70;
	var sig;
	sig = Pulse.ar(freq);
	sig = sig + SinOsc.ar(freq);
	sig = LPF.ar(sig, \lpf.kr(400));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = [sig[0], DelayC.ar(sig[1],0.1,\delayr.ar(0.0001))];
	Out.ar(out, sig);
}).add;
);
(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\degree, Pseq([0],inf),
	\delayr, Pseq([0.02,0.01,0.001,0.0001,0.00001],inf),
	\lpf, Pseq([1000,10000,2000,400],inf),
	\octave, 3,
	\dur, 1/4,
	\amp, 0.2
)).play;
);

(
SynthDef(\kick, { arg out=0, amp=0.1, gate=1, pan=0, freq=70;
	var sig;
	var env1, env2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.ar(\env1.kr(Env([600,65,60],[0.01,0.8], -4)), 1);
	env2 = EnvGen.ar(\env2.kr(Env([1,4,1],[0.001,0.1])), 1);
	
	sig = SinOsc.ar(env1);
	//sig = sig + Pulse.ar(env1/2);
	sig = sig + SinOsc.ar(env1);
	sig = sig + SinOsc.ar(env1, 0.3);
	sig = sig + SinOsc.ar(env1, 0.8);
	sig = 1.collect({ SinOsc.ar(env1, Rand(0, 2*pi )) }).mean;

	sig1 = sig;
	sig1 = sig1 + WhiteNoise.ar(1);
	sig2 = sig1;
	sig1 = LPF.ar(( sig1 * 10 ).tanh, \lpf.kr(300));
	sig1 = HPF.ar(( sig1 * 10 ).tanh, \hpf.kr(20));
	sig1 = sig1 + BPF.ar(sig2, 4500,0.4);
	sig = sig + sig1;
	sig = LPF.ar(sig, env2 * 42);
	sig = sig * EnvGen.ar( \ampenv.kr(Env([0,1,0],[0.001,0.7], -4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(\freq!3),
	env2: XEnvSpec(ControlSpec(0.01,10, \exp)!3),
	ampenv: XEnvSpec(ControlSpec(0.01,2, \exp)!3),
	duration: ControlSpec(0.001,4,\lin, 0, 1)
))).add;
);

(
Pdef(\kick, Pbind(
	\instrument, \kick,
	\degree, Pseq([0, Pwhite(0,12)],inf),
	//\dur, 1,
	\dur, Pkeyd(\dur, 1),
	\amp, Pkeyd(\amp, 0.1),
)).play;
Pdef(\kick).addHalo(\instrument, \kick);
);
Pdef(\kick).asParamGroup.edit
~pdef_editor.(\kick)

PdefPreset.new(\kick).gui

(
Pdef(\kick2, Pbind(
	\instrument, \kick,
	\degree, Pseq([0, Pwhite(0,12)],inf),
	\dur, Pkeyd(\dur, 1/4),
	\amp, Pkeyd(\amp, 0.1),
)).play;
Pdef(\kick2).addHalo(\instrument, \kick);
);
Pdef(\kick2).asParamGroup.edit
Pdef(\kick).stop


(
SynthDef(\snare, { arg out=0, amp=0.1, gate=1, pan=0, freq=4700, doneAction=2;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1000,4400,441],[0.01,0.3])), 1);
	env2 = EnvGen.kr(\env2.kr( Env([4310,440,1641],[0.01,0.1], -4) ), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1.02,1],[0.4,0.13])), 1);
	env4 = EnvGen.kr(\env4.kr( Env([4310,440,1641],[0.01,0.1], -4) ), 1);
	sig = WhiteNoise.ar;
	sig = sig + LFNoise1.ar( 200 * env3 );
	//sig = sig + SinOsc.ar(freq);
	sig = Ringz.ar(sig, 
		\ringfreq.kr(
			Array.geom(8,80,1.022) +
			Array.series(8,70,3)
		),
		\ring.kr({ rrand(0.01,0.4) } ! 8)

	).mean * \ringamp.kr(0.4)/10 + sig;
	sig = FreqShift.ar(sig, \shift.kr(-400));
	sig = LPF.ar(sig, [ env1, env4 ]).mean;
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, \lpf.ar(10000));
	sig = BRF.ar(sig, 4500,0.1);
	sig = BRF.ar(sig, 7500,0.1);
	//sig = sig + WhiteNoise.ar;
	//sig = LPF.ar(sig, env1 * 2);
	//sig = HPF.ar(sig, env2);

	sig = Pan2.ar(sig, pan, amp);
	sig = [sig[0], DelayC.ar(sig[1],0.1,\delayr.ar(0.0001)) + sig[1]];
	//sig = sig * EnvGen.ar(Env.adsr(0.0001,0.1,0.8,0.3, 1, -5),gate,doneAction:2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(\freq!3),
	env2: XEnvSpec(\freq!3),
	env3: XEnvSpec( ControlSpec(0.01,8,\exp)!3),
	env4: XEnvSpec(\freq!3),
	ringfreq: XArraySpec(\freq!8),
	ring: XArraySpec( \unipolar!8),
	adsr: XEnvSpec.adsr,
))).add;
);

(
Pdef(\snare, Pbind(
	\instrument, \snare,
	\degree, Pseq([0],inf),
	\delayr, Pseq([0.02,0.01,0.001,0.0001,0.00001],inf),
	\delayr, Pseq([0.001],inf),
	\env1, [ Env([11070,4170,1770],[0.001,0.1]) ],
	\env2, [ Env([780,18,700],[0.001,0.2]) ],
	\env4, [ Env([11800,480,4000],[0.001,0.8]) ],
	\ringfreq, [
		Array.geom(1,( 62 ).midicps,2) +
		//[80,280] +
		Array.series(8,0,0)
	],
	\ring, [
		1!8
	],
	\shift, -40,
	\ringamp, 0.2,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.4,0.2,1,-4) ],
	],inf),
	\sustain, 0.1,
	\freq, 3000,
	\dur, 1,
	\lag, 1/2,
	\amp, 0.4
));
Pdef(\snare).play;
);
(
	Pdef(\snare).addHalo(\instrument, \snare);
	Pdef(\snare, Pbind(\instrument, \snare)).asParamGroup.edit;
)

ParamProto.init
(
	~pdef_editor = { arg name;
		var pdef;
		var pg;
		var absname = 'pdef_'+++name;
		if(name.isKindOf(Pdef)) {
			pdef = name;
			name = pdef.key;
		} {
			pdef = Pdef(name)
		};
		pg = ParamGroupDef(absname, pdef.asParamGroup);
		WindowDef(absname, {
			VLayout (
				HLayout (
					PlayerWrapper(pdef).asView,
					EventClass.presetSelectorView.(pg),
				),
				ParamGroupLayout.two_panes(pg, \property)
			)
		}).front;
	};
	Pdef(\snare).addHalo(\instrument, \snare);
	Pdef(\snare, Pbind(\instrument, \snare));
	~pdef_editor.(\snare);
)
	Pdef(\snare).set(\ring, [ 0.1!8 ])
	Pdef(\snare).envir
	Pdef(\snare).clear
	Pdef(\snare).envir.clear
	Pdef(\snare).get(\ring)

Pdef(\snare, Pbind(\instrument, \snare)).asParamGroup.do({ arg p; "%:%".format(p.label, p.get).debug });
	Pdef(\snare, Pbind(\instrument, \snare)).asParamGroup.collect({ arg p; "%, %,".format(p.property.asCompileString, p.get.asCompileString) }).join($\n)

	PdefPreset(\snare).storeToDisk
	PdefPreset(\snare).currSet
	PdefPreset(\snare).addSet(\yep)
	PdefPreset(\snare).currSet
	PdefPreset(\snare).storePath
	PdefPreset(\snare).presetPath
	PdefPresetGui(\snare)

~preset_gui.(Pdef(\snare))

	57+17%60
(
	Pdef(\snare, 
	
		Pbind(
			\instrument, \snare,
			'dur', 1,
			'legato', 0.006155,
			'amp', 0.362942,
			'pan', 0.000000,
			'freq', 725.542777,
			'env1', [ Env([ 5623.4134523618, 6775.6764547909, 20.0 ], [ 0.37442141860106, 0.37944733297423 ], [ 0.0, 0.0 ]) ],
			'env2', [ Env([ 20.0, 164.01413348197, 1035.8951186377 ], [ 0.43659758148313, 0.43160623731494 ], [ -4.0, -4.0 ]) ],
			'env3', [ Env([ 3.2128365169031, 4.0518235644849, 0.014347233976308 ], [ 0.0062176282517612, 0.0091018546042909 ], [ 0.0, 0.0 ]) ],
			'env4', [ Env([ 14393.713742232, 143.93714729963, 5987.1551372448 ], [ 0.02936096675694, 0.12208980768726 ], [ -4.0, -4.0 ]) ],
			'shift', 16.631094,
			'lpf', 1000.000000,
			'delayr', 0.001000,
			'adsr', [ Env([ 0.0, 1.1904761791229, 0.86349206405973, 0.0 ], [ 0.0, 0.0065630426266856, 0.30345424253603 ], [ -4.0, -4.0, -6.0 ], 2.0), ]
		)
	).play
)

(
Ndef(\snare)[0] = Pdef(\snare);
Ndef(\snare)[1] = \filter -> { arg in;
	FreeVerb.ar(in, \mix.kr(0.2), \room.kr(0.1), \damp.kr(1));
};
Ndef(\snare).play;
)
Ndef(\snare).asParamGroup.edit
Ndef(\snare).stop

(
Pdef.defaultQuant = 1;
Ndef.defaultQuant = 1;
)




s.boot;

(

Spec.add(\dens, [1, 1000, \exp]);

Spec.add(\ring, [0.0001, 100, \exp]);


a = Ndef(\a, { |freq=300, dens=10, ring = 0.03, amp= 0.25| 

	Ringz.ar(Dust.ar(dens ! 2, (1/dens.max(1)).sqrt * amp), (freq * [1.01, 0.99]).lag(0.2), ring) 

}).play;


	// make a preset for Ndef(\a)

	// - stored by the Ndef's name in NdefPreset.all

z = NdefPreset(Ndef(\a));


w = Window("NdefPreset test", Rect(200, 200, 420, 250)).front;

w.addFlowLayout;

	// a gui for the NdefPreset

g = ProxyPresetGui(z, parent: w);

	// and one for the Ndef

b = NdefGui(a, 8, parent: w);

)


(
~preset_gui = { arg proxy;
	var a, z, w, g, b;

	a = proxy;
	z = PdefPreset(proxy);
	w = Window("NdefPreset test", Rect(200, 200, 420, 250)).front;
	w.addFlowLayout;
	// a gui for the NdefPreset
	g = ProxyPresetGui(z, parent: w);
	// and one for the Ndef
	b = PdefGui(a, 8, parent: w);
}
)
~preset_gui.(Pdef(\snare))
