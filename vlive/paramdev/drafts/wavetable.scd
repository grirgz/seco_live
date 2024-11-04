
/////////////////////////////////////////////
///////////////////// Osc: wavetable

WavetableDef.addPath("/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/");

WavetableDef(\saw2, "Classic - Saw/Cos Saw.wav");
WavetableDef(\saw, "/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav");
WavetableDef(\sin, "/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav");
WavetableDef(\sinpower2, "/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav");

(
SynthDef(\waver, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable;
	var sig;
	sig = Osc.ar(wavetable, freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \waver,
			\wavetable, WavetableDef(\saw),
			\wavetable, WavetableDef(\sinpower2),
			\wavetable, WavetableDef(\saw2),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

WavetableDef(\sin).plotWavetable
WavetableDef(\saw).plotWavetable

////// create from wavetable

~wt = Wavetable.sineFill(512, [ 1 ]);
// to be continued

////// create directly

b = Buffer.alloc(s, 512, 1);
b.sine1(1.0/[1], true, true, true);

/////////////////////////////////////////////
///////////////////// VOsc: multi wavetable

(
WavetableDef(\multi, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Misc - Assymetrical/Asymmetrical 018.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav",
])
)

(
SynthDef(\waver2d, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive;
	var sig;
	sig = VOsc.ar(wavetable + MouseX.kr(0,consecutive-1), freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \waver2d,
			\wavetable, WavetableDef(\multi),
			\consecutive, WavetableDef(\multi).consecutive.size,
			\note, Pseq([
				0,2,5,4,
			],inf),
			//\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

WavetableDef(\multi)
WavetableDef(\multi).consecutive
WavetableDef.all[\multi]
WavetableDef.clear(\multi)
WavetableDef.bufferMultiCache.values
WavetableDef.bufferChannelCache.keys.size
WavetableDef.bufferChannelCache.keys.asArray[0]
WavetableDef.bufferChannelCache.values.asArray[0]
WavetableDef.bufferChannelCache.keys.asArray[1]

/////////////////////////////////////////////
///////////////////// VOsc: terrain wavetable

(
WavetableDef(\multi2, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Misc - Assymetrical/Asymmetrical 018.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav",
])
)

(
WavetableDef(\multi3, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/FM - Dual/FM Dual 1 9 2.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/AM - Simple NonSine/AM Squ07 Squ02.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Formants - Sine/Formant 09.wav",
])
)

(
SynthDef(\waver3d, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = VOsc.ar(wavetable + MouseX.kr(0,consecutive-1).poll, freq);
	sig2 = VOsc.ar(wavetable2 + MouseX.kr(0,consecutive2-1), freq);
	sig = SelectX.ar(MouseY.kr(0,1), [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \waver3d,
			\wavetable, WavetableDef(\multi2),
			\consecutive, WavetableDef(\multi2).consecutive.size,
			\wavetable2, WavetableDef(\multi3),
			\consecutive2, WavetableDef(\multi3).consecutive.size,
			\octave, 3,
			\note, Pseq([
				0,2,4,1,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

WavetableDef(\multi)
WavetableDef(\multi).consecutive
WavetableDef.all[\multi]
WavetableDef.clear(\multi)
WavetableDef.bufferMultiCache.values
WavetableDef.bufferChannelCache.keys.size
WavetableDef.bufferChannelCache.keys.asArray[0]
WavetableDef.bufferChannelCache.values.asArray[0]
WavetableDef.bufferChannelCache.keys.asArray[1]

///////////////////////////////////////////////////////////////////////////////////////////
//////// Open wavetable from file example

f = SoundFile.openRead("/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav".standardizePath);
// An array to load the data
a = FloatArray.newClear(f.numFrames);
f.readData(a);
f.close; // close the file
a = a.as(Signal);
a = a.asWavetable;
a.size; // 256 oka.size; // 169 in my file
b = Buffer.loadCollection(s, a);



//////////////////////////////////////////////////////////////// draft



(
SynthDef(\surf3d, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var amps;
	lfo2 = SinOsc.ar(1/2 * [1,1.1]) * \env1.kr(1);
	lfo1 = SinOsc.ar(8.1 * [1,0.9]) * lfo2;
	//freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0001) + 1);
	freq = freq * [1,2,3,4,5,6].rotate(2);
	amps = [1,0.4,0.2, 0.2,0.2,0.2].rotate(2);
	sig1 = VOsc.ar(wavetable + lfo1.range(0,consecutive-1), freq);
	sig2 = VOsc.ar(wavetable2 + lfo1.range(0,consecutive2-1), freq);
	sig = SelectX.ar(lfo2.unipolar, [sig1, sig2]) * amps;

	env3 = EnvGen.kr(Env([freq/2,freq*2,freq/2],[1.1,1.8]), 1);
	sig = RLPF.ar(sig, \lpfr.kr(4.1).poll * freq, \rq.kr(0.5));

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \modenv,
			\env, Pseq([
				[ Env([0,1,0],[1.1,2.8]) ],
			],inf),
			\levelScale, 0.8,
			\dur, 2,
			\out, BusDef(\env1, \control),
			\amp, 0.1,
		),
		Pbind(
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\lag, 0.0005,
			\instrument, \surf3d,
			\env1, BusDef(\env1, \control).asMap,
			\lpfr, BusDef(\env2, \control).asMap,
			\lpfr, Pfunc({ arg ev;
				ev[\finish] = {
					Pbind(
						\instrument, \modenv,
						\env, Pseq([
							[ Env([0,1.0001,2],[1.0,1.2]) ],
						],inf),
						\legato, 1,
						\levelScale, 1.3,
						\latency, 0,
						\levelBias, 0.1,
						\dur, 2,
						\out, BusDef(\env2, \control),
						\amp, 0.1,
					).keep(1).play;
				};
				BusDef(\env2, \control).asMap;
			}),
			\wavetable, WavetableDef(\multi2),
			\consecutive, WavetableDef(\multi2).consecutive.size,
			\wavetable2, WavetableDef(\multi3),
			\consecutive2, WavetableDef(\multi3).consecutive.size,
			\octave, 3,
			\note, Pseq([
				0,2,4,1,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \modenv,
			\env, Pseq([
				[ Env([0,1,0],[1.1,2.8]) ],
			],inf),
			\levelScale, 0.8,
			\dur, 2,
			\out, BusDef(\env1, \control),
			\amp, 0.1,
		),
		Pbind(
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\lag, 0.0005,
			\instrument, \surf3d,
			\env1, BusDef(\env1, \control).asMap,
			\lpfr, BusDef(\env2, \control).asMap,
			\lpfr, ~pmodpat.(
					Pbind(
						\instrument, \modenv,
						\env, Pseq([
							[ Env([0,1.0001,2],[1.0,1.2]) ],
						],inf),
						\legato, 1,
						\levelScale, 1.3,
						\latency, 0,
						\levelBias, 0.1,
						\dur, 2,
						\amp, 0.1,
					).keep(1)
			),
			\wavetable, WavetableDef(\multi2),
			\consecutive, WavetableDef(\multi2).consecutive.size,
			\wavetable2, WavetableDef(\multi3),
			\consecutive2, WavetableDef(\multi3).consecutive.size,
			\octave, 3,
			\note, Pseq([
				0,2,4,1,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);


/////////////////// custom MouseX

(
WavetableDef(\multi2, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Misc - Assymetrical/Asymmetrical 018.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav",
])
)

(
WavetableDef(\multi3, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/FM - Dual/FM Dual 1 9 2.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/AM - Simple NonSine/AM Squ07 Squ02.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Formants - Sine/Formant 09.wav",
])
)

(
SynthDef(\waver3d, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2, pos=0, pos2=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = VOsc.ar(wavetable + (pos*(consecutive-1)), freq);
	sig2 = VOsc.ar(wavetable2 + ( pos*(consecutive2-1) ), freq);
	sig = SelectX.ar(pos2, [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \waver3d,
			\wavetable, WavetableDef(\multi2),
			\consecutive, WavetableDef(\multi2).consecutive.size,
			\wavetable2, WavetableDef(\multi3),
			\consecutive2, WavetableDef(\multi3).consecutive.size,
			\pos, ~pmodenv.(Pseq([0,1,0.1,0.4],inf), 1.28),
			\pos2, ~pmodenv.(Pseq([0,1,0.1,0.4],inf), 1.7),
			\octave, 3,
			\note, Pseq([
				0,2,4,1,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \waver3d,
			\wavetable, WavetableDef(\multi2),
			\consecutive, WavetableDef(\multi2).consecutive.size,
			\wavetable2, WavetableDef(\multi3),
			\consecutive2, WavetableDef(\multi3).consecutive.size,
			\pos, Ndef(\mouseX, { MouseX.kr(0,1) }),
			\pos2, Ndef(\mouseY, { MouseY.kr(0,1) }),
			\octave, 3,
			\note, Pseq([
				0,2,4,1,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);



////// Simple example

WavetableDef(\saw, "/path/to/Cos Saw.wav");
WavetableDef(\sin, "/path/to/Sine.wav");

(
// Use Osc UGen to play wavetables
SynthDef(\waver, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable;
	var sig;
	sig = Osc.ar(wavetable, freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\help,
	Ppar([
		Pbind(
			\instrument, \waver,
			\note, Pseq((0..10),inf) % Pseq((4..9),inf).stutter(2),
			\wavetable, WavetableDef(\saw),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
);

////// Morph between several wavetables

(
// allocate consecutive buffers to be used with VOsc UGen
WavetableDef(\multi, [
	"/path/to/Cos Saw.wav",
	"/path/to/Sine.wav",
])
)

(
// Use mouse to change wavetable position
SynthDef(\waver2d, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive;
	var sig;
	sig = VOsc.ar(wavetable + MouseX.kr(0,consecutive-1), freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\help, 
	Ppar([
		Pbind(
			\instrument, \waver2d,
			\wavetable, WavetableDef(\multi),
			\consecutive, WavetableDef(\multi).consecutive.size, // need size to know upper range
			\note, Pseq([
				0,2,5,4,
			],inf) + Pseq([0,7],inf).stutter(6) % Pseq((1..10),inf).stutter(3),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
);
