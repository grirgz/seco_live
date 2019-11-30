//// track_autoroute

// use master for sendbus1-rdn sendbus2-rdn2 sendbus3-rdn3

~t = 135/4/60; TempoClock.default.tempo = ~t;

ProtoDef(\rdn3).loadFromPresetLib("ile5_kick");
ProtoDef(\rdn).loadFromPresetLib("ile5_kick");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snare");
ProtoDef(\rdn2).loadFromPresetLib("ile3_rdn2");


ProtoDef(\rdn).edit;



// END

//////////////////////////// DRAFT

Pbind(
	\instrument, \a,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
);

(
Pdef(\test, 
	Ppar([
		Pmono(\autotreb,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
).play;
);

p = Pbind(\instrument, \test, \dur, 0.1,\freq,Pwhite(100,400),\amp, 0.1);
p.play

p.render("/tmp/bla.wav".standardizePath,2 )

(
SynthDef(\test, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1,dur |
    var audio = Blip.ar(freq, nharms, amp);
	var env = Linen.kr(Impulse.ar(0),0.1,1,0.1, doneAction: 2);
   Out.ar(out, Pan2.ar(audio, pan, 1) );
}).store;
)

(
Ndef(\fee).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(SinOsc.kr(0.7*(1..11)/12).unipolar*2, [sig1, sig2, sig3]);
	sig = SelectX.ar(SinOsc.kr(0.07*(1..11)/12).unipolar*6, sig.flop);

	sig = sig.fold2( SinOsc.kr(1/4/(1..11)).range(0.1,2));
	sig = sig.wrap2( SinOsc.kr(1/4/(1..11).reverse).range(0.1,2));
	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	//lpspread = 0;
	sig = RLPF.ar(sig, \lpf.kr(400) * SinOsc.kr((0..11)+1/42.3).exprange(1/2,10) * ((0..11)/11 - 0.5 * lpspread + 1), \rq.kr(0.5));
	sig = HPF.ar(sig, 700);

	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	//sig = sig.flop;
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
}).play;

)


(
Ndef(\eyes, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf)).lag(0.1);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*0.6 * 1.0 * env1) * 2.14 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 400, 800 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * 1.1 * Amplitude.kr(sig)**7.8 ) ).clip(5,18000));
	sig.debug("sig");
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1), amp);
	sig.debug("sig");
	sig = sig.mean;
	sig = sig /1;
	sig.debug("sig");
	sig;
}).play
);
Ndef(\eyes).clear



///////////////////////////////////

ProtoDef(\rdn).loadFromPresetLib("default");
ProtoDef(\rdn2).loadFromPresetLib("default");
ProtoDef(\rdn3).loadFromPresetLib("default");
ProtoDef(\rdn).inbus = BusDef(\sendbus1);
ProtoDef(\rdn2).inbus = BusDef(\sendbus2);
ProtoDef(\rdn3).inbus = BusDef(\sendbus3);

ProtoDef(\rdn).loadFromPresetLib("ile5_kick");
ProtoDef(\rdn3).loadFromPresetLib("ile5_kick");
ProtoDef(\rdn).loadFromPresetLib("ile5_kickdist");
ProtoDef(\rdn3).loadFromPresetLib("ile5_rdn2");
ProtoDef(\rdn3).loadFromPresetLib("ile5_snare");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snare");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snaredist");
ProtoDef(\rdn2).loadFromPresetLib("ile3_rdn2");
ProtoDef(\rdn3).loadFromPresetLib("lidist");


~master.();
Pdef(\part2, Pdef(\autobassintro)).play;
Pdef(\part2, Pdef(\autobasst2)).play;
Pdef(\part3, Pdef(\autobass2)).play;

Pdef(\part2, Pdef(\autobass1long)).play;
Pdef(\part3, Pdef(\automelo1)).play;
Pdef(\part3, Pdef(\automelo2)).play;
Pdef(\part2, Pdef(\automelo3)).play;
PlayerWrapper(Pdef(\part)).stop;
PlayerWrapper(Pdef(\part2)).stop;
PlayerWrapper(Pdef(\part3)).stop;

Pdef(\part, Pdef(\autoroute1)).play;
Pdef(\part, Pdef(\autoroute2)).play;
Pdef(\part, Pdef(\autoroute3)).play;
Pdef(\part, Pdef(\autoperc1)).play;
Pdef(\part, Pdef(\autoperc2)).play;
Pdef(\part, Pdef(\autoperc3)).play;
Pdef(\part, Pdef(\autoperc_onesi)).play;
Pdef(\part, Pdef(\autoperc_one1)).play;
Pdef(\part, Pdef(\autoperc_one2)).play;
Pdef(\part, Pdef(\autoperc_one3)).play;
Pdef(\part2, Pdef(\autorise)).play;


Pdef(\part).clear;

Ndef(\rdn3).set(\delay2, Ndef(\lfo1, { ( SinOsc.kr(1/2) * 1 + 1 ) * 0.01 }))
Ndef(\rdn).set(\delay2, 0.0001)
Ndef(\rdn).set(\postlpf, Ndef(\lfo1, { ( SinOsc.kr(4) * 0.4 + 1 ) * 15100.01 }))
Ndef(\rdn).set(\postlpf, 19000)
Ndef(\rdn).genfx
ProtoDef(\rdn).genfx
ProtoDef(\rdn3).genfx
ProtoDef(\rdn3).loadFromPresetLib(\autoperc1)
TempoClock.sched(1, { ProtoDef(\rdn3).loadFromPresetLib(\autopercdist) })


