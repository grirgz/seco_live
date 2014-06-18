////////////////////////// content

## Pbind default arguments
legato/sustain
dur/stretch/delta
freq/detune/degree/note/midinote
octave/root/mtranspose


Pkey

## Common modulation of parameters
Pseq
Pseg
Ndef modulation
Ndef gui editing

## multichannel expansion

## special parameters
array param
env param

## composing
Pseq
Ppar
<> Pchain

## notes and rests

## GUI: start/stop 

////////////////// ////////////////// PATTERNS ////////////////// //////////////////


///// what is a pattern

// default event
Pbind().play;
Pbind().trace.play;
().play;
Event.default.play;
Event.default.parent;

(degree:0, dur:1/8).play

// An event is a kind of smart dictionnary

(
~a = Pbind(
	\degree, Pseq([0,2,4, 3,5,7],inf),
	\octave, 4,
	\dur, 1,
);
~a.play
)
~a.stop


// Pdef is a proxy, a placeholder for patterns
// useful to avoid multiple instances of the pattern
// and change pattern in real time

(
Pdef(\a, Pbind(
	\degree, Pseq([0,2,4, 3,5,7],inf),
	\mtranspose, Pseq([0,2],inf),
	\octave, 4,
	\dur, 1/2,
));
Pdef(\a).play
)

Pdef(\a).quant = 4;

Pdefn(\x, Pseq([1,2],inf));
Pdefn(\x, Pseq([4,7],inf));

(
Pdef(\a, Pbind(
	\degree, Pdefn(\x),
	\octave, 4,
	\dur, 1,
));
Pdef(\a).play
)

// legato/sustain
// dur/stretch/delta
// freq/detune/degree/note/midinote
// octave/root/mtranspose

// common bugs : use reserved keys: sustain 

// sustain = dur * legato
// delta = dur * stretch


////////////////// base

SynthDef(\granu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
						graindur=1, grainrate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						doneAction=2, release=0.2;
	var sig, clk, phasor;

	clk = Impulse.kr(grainrate);
	phasor = Phasor.ar(0, time_stretch.abs / SampleRate.ir / BufDur.kr(mbufnum), 0, 1);
	pos = phasor * BufDur.kr(mbufnum) + pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), graindur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.005,0.1,0.8,release),gate,doneAction:doneAction);
	sig = Splay.ar(sig, 1, amp, pan);
	Out.ar(out, sig);

}).store;

Platform.resourceDir;

~buf = Buffer.readChannel(s, Platform.resourceDir++"/sounds/a11wlk01.wav", channels:0)


(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, 0.3,
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

//// key overwrite

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, 0.3,
	// the last key overwrite the previous ones
	\pitch_stretch, 0.4,
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

//// Pkey: last value


(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, 0.3,
	\pitch_stretch, Pkey(\pitch_stretch) * 2,
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

/////////// common modulation of parameters
//// Pseq

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseq([0.3,0.1,1],inf),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)



//// pattern rate modulation: Pseg

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseg(Pseq([0.3,0.1,1],inf),2),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

//// control rate modulation: Ndef


(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Ndef(\lfo1, { SinOsc.kr(1.3).range(0.1,0.8) }),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

// change Ndef while playing
Ndef(\lfo1, { SinOsc.kr(8.3).range(0.1,0.8) });
Ndef(\lfo1, { Line.kr(0.1,4,32) });
Ndef(\lfo1, { Line.kr(4,0.4,2) });
Ndef(\lfo1, { EnvGen.kr(Env([1,0.1,0.5],[1, 3]).circle) });
Ndef(\lfo1, { A2K.kr(CuspN.ar(1.3).range(0.01,1.8)).lag(0.4) });

// quant and fadetime
Ndef(\lfo1).quant = 4;
Ndef(\lfo1).quant = 0;

Ndef(\lfo1).fadeTime = 4;
Ndef(\lfo1).fadeTime = 0;

// special case for reserved keys like freq

(
Pdef(\a, Pbind(
	\instrument, \default,
	//\freq, Ndef(\lfo1, { Line.kr(50,254,32) }), // bad
	\freq, Ndef(\lfo1, { Line.kr(50,254,32) }).asMap,
)).play;
)

//// gui modulation


(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Ndef(\lfo1, { arg lofreq=1; SinOsc.kr(lofreq).range(0.1,0.8) }),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

Ndef(\lfo1).edit;

/////////////////// multichannel expansion

// Live

// \strum, \lag

////////////////// composing

//// Pseq: pattern play in sequence

(
Pdef(\pat1,  Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseq([0.3,0.1],1), // pattern need to be finite
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
));

Pdef(\pat2,  Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.2,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0.1,
	\pitch_stretch, Pseq([0.3,0.1],1) * 3, // pattern need to be finite
	\release, 0.05,
	\grainrate, 40,
	\graindur, 0.05,
	\pos, 0.2,
));

Pdef(\main, 
	Pseq([ 
		Pdef(\pat1),
		Pdef(\pat2),
	],inf)
)

)
Pdef(\pat1).play;
Pdef(\pat1).stop;

Pdef(\pat2).play;
Pdef(\pat2).stop;

Pdef(\main).play;
Pdef(\main).stop;

//// Ppar: pattern play in parrallel

Pdef(\main, 
	Ppar([ 
		Pdef(\pat1),
		Pdef(\pat2),
	],inf)
)

//// Pchain: pattern inherit keys from parent pattern


// base pattern
Pdef(\pat10,  Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, 0.1,
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
));
Pdef(\pat10).play;

// derivated pattern
(
Pdef(\pat11,  
	Pchain(
		Pbind(
			\time_stretch, Pseq([0.1,2,3],inf),
			\amp, 0.4,
		),
		Pdef(\pat10) // parent
	)
));
)
Pdef(\pat11).play;

// filtering: use value from base pattern with Pkey
// in Pchain(A,B,C), the values goes from C and are filtered by B then by A
(
Pdef(\pat12,  
	Pchain(
		Pbind(
			\pitch_stretch, Pkey(\pitch_stretch) * Pseq([4,8,3],inf),
		),
		Pdef(\pat10)
	)
));
)
Pdef(\pat12).play;

// <> is syntax shortcut for Pchain
// Pchain(a,b,c)     is equal to      a <> b <> c

(
Pdef(\main, 
	Pseq([
		Pbind(\legato, 0.1) <> Pdef(\pat1),
		Pdef(\pat2),
	],inf)
).play
)

// all in one

(
Pdef(\main, 
	Pseq([
		Pbind(\legato, 0.1) <> Pdef(\pat1),
		Ppar([
			Pseq([ 
				Pbind(\degree, Pseq([1])),
				Pbind(\degree, Pseq([4])),
			]),
			Pbind(\legato, 0.3, \pitch_stretch, 2) <> Pdef(\pat2),
		])
	],inf)
).play
)

/////////////////// special arguments

//// array

SynthDef(\granu2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
						graindur=1, grainrate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						doneAction=2, release=0.2;
	var sig, clk, phasor;

	clk = Impulse.kr(grainrate);
	phasor = Phasor.ar(0, time_stretch.abs / SampleRate.ir / BufDur.kr(mbufnum), 0, 1);
	pos = phasor * BufDur.kr(mbufnum) + pos;
	//pos = pos + \postab.kr([1,0.8,0.7]);
	pitch_stretch = pitch_stretch * \pitchtab.kr([0.5,1,1,0.5]);

	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), graindur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.15,0.1,0.8,release),gate,doneAction:doneAction);
	sig = sig.flat;
	sig.postln;
	sig = Splay.ar(sig, 1, amp, pan);
	Out.ar(out, sig);

}).store;

(
Pdef(\a, Pbind(
	\instrument, \granu2,
	\amp, 0.4,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0.1,
	\pitch_stretch, 0.6,
	\release, 0.2,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.7,

	// need double brackets or else it will be understood as pattern multichannel expansion
	\pitchtab, [ [ 0.1,0.2, 4.6,4 ] ],
	\pitchtab, [ [ 0.1,0.2, 4.6,4 ].reverse ],
)).play;
)

//// pattern of arrays

(
Pdef(\a, Pbind(
	\instrument, \granu2,
	\amp, 0.4,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0.1,
	\pitch_stretch, 0.6,
	\release, 0.2,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.7,

	\pitchtab, Pseq([
		[ [ 0.1,0.2, 4.6,4 ] ],
		[ [ 0.1,0.2, 4.6,4 ].reverse ],
	],inf),
).trace).play;
)

//// independent pattern for each array slot

(
Pdef(\a, Pbind(
	\instrument, \granu2,
	\amp, 0.4,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0.1,
	\pitch_stretch, 0.6,
	\release, 0.2,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.7,

	\pitchtab, 
		// double Ptuple because need double enclosing
		Ptuple([
			Ptuple([
				Pseq([1, 0.1, 4],inf),
				Pseq([1, 0.1],inf),
				Pseq([0.1, 1],inf),
				Pseq([0.1, 1],inf),
			])
		]),

	// output

).trace).play;
)


(
~a = Ptuple([
			Ptuple([
				Pseq([1, 0.1, 4],inf),
				Pseq([1, 0.1],inf),
				Pseq([0.1, 1],inf),
				Pseq([0.1, 1],inf),
			])
		]);
~a.asStream.nextN(5);
)


/////////////////// envelopes

SynthDef(\granu3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum,
						graindur=1, grainrate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						doneAction=2, release=0.2;
	var sig, clk, phasor;

	clk = Impulse.kr(grainrate);
	phasor = Phasor.ar(0, time_stretch.abs / SampleRate.ir / BufDur.kr(mbufnum), 0, 1);
	pos = phasor * BufDur.kr(mbufnum) + pos;
	//pos = pos + \postab.kr([1,0.8,0.7]);
	pitch_stretch = pitch_stretch * \pitchtab.kr([0.5,1,1,0.5]);

	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), graindur, pan, 1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.005,0.1,0.8,0.02)),gate,doneAction:doneAction);
	sig = sig.flat;
	sig.postln;
	sig = Splay.ar(sig, 1, amp, pan);
	Out.ar(out, sig);

}).store;


(
Pdef(\a, Pbind(
	\instrument, \granu3,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0.4,
	\pitch_stretch, 0.4,
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,

	\pitchtab, [ [ 0.1, 4.6,  4, 0.2, ] ],
	// env is converted internally in an array, so use the same syntax as for array: double brackets
	\adsr, Pseq([
		[ Env.adsr(0.5,0.2,0.1,0.2) ],
		[ Env.adsr(0.01,0.2,0.1,0.2) ],
	],inf),
	\adsr, [ Env.adsr(0.05,0.2,0.1,0.02) ],
	\adsr, [ Env.adsr(0.5,0.2,0.1,0.2) ],
)).play;
)

/////////////////// isRest

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,

	\isRest, true,
	\isRest, Pseq([false, true],inf),
	// equivalent shorter syntax 
	// 1 < 0 = false
	// 1 is note, 0 is rest
	\isRest, Pseq([1, 0],inf) < 1,  
)).play;
)

//// probalistic rest
0.2.coin

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,

	\isRest, Pseq([1, 0.3],inf).coin.not,  
)).play;
)

/////////////////// useful methods

//// stutter

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/8,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf).stutter(8),
	\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,

	\isRest, Pseq([1, 0.3],inf).coin.not,  
)).play;
)


/////////////////// tour of patterns

Prand
Pwrand
Pser
Ptpar
Pstutter
Pwhite

////////////////// ////////////////// GUI ////////////////// //////////////////

//// set and get pdef values (a method of Pdef, not Pbind)

(
Pdef(\amod, Pbind()); // empty pattern for putting value

Pdef(\a, 
	Pdef(\amod) <>
	Pbind(
		\instrument, \granu,
		\amp, 1.8,
		\legato, 0.5,
		\dur, 1/8,

		\mbufnum, ~buf,
		\time_stretch, 0,
		\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf).stutter(8),
		\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf),
		\release, 0.05,
		\grainrate, 100,
		\graindur, 0.05,
		\pos, 0.2,

		\isRest, Pseq([1, 0.3],inf).coin.not,  
	)
);
)

Pdef(\a).play;
Pdef(\amod).set(\pitch_stretch, 1/4);
Pdef(\amod).unset(\pitch_stretch);


(

        ~win = Window.new;

        ~bt1 = Button.new;

        ~bt1.states = [
            [ "Hello" ],
            [ "World", Color.green, Color.blue ],
        ]; 
		~bt1.action = {
			"plop".postln;
		};

        ~layout = VLayout.new;
        ~layout.add(~bt1);

        ~win.view.layout = ~layout;
        ~win.front;
)

(
        ~slider = Slider.new;
        ~layout.add(~slider);
		~slider.value = 0.3;
		~slider.action = { arg slider;
			slider.value.postln;
		};

)

//// specs: translate a range from 0 to 1 to a specified range

~spec1 = ControlSpec(minval:0.01, maxval:4.2, warp:\exp, step:0, default:1);
~spec1.map(0);
~spec1.map(1);
~spec1.map(0.351);
~spec1.unmap(0.028619466152776)

//// control a pattern

(
        ~win = Window.new;

        ~bt1 = Button.new;

        ~bt1.states = [
            [ "start pattern a" ],
            [ "stop pattern a" ],
        ]; 

		~bt1.action = { arg but;
			if(but.value == 1) {
				Pdef(\a).play
			} {
				Pdef(\a).stop
			}
		};

		~slider1 = Slider.new;

		~spec1 = ControlSpec(minval:0.01, maxval:4.2, warp:\exp, step:0, default:1);
		~slider1.action = { arg sli;
			Pdef(\amod).set(\pitch_stretch, ~spec1.map(sli.value))
		};

        ~layout = VLayout.new;
        ~layout.add(~bt1);
		~layout.add(~slider1);
        ~win.view.layout = ~layout;
        ~win.front;
        
)

//// make a function

(
	~make_pat_control = { arg patname, paramname, spec;
		var bt1, slider1, layout;
		var patmodname = (patname ++ \mod).asSymbol;
        bt1 = Button.new;

        bt1.states = [
            [ "start "++patname++": "++paramname ],
            [ "stop "++patname++": "++paramname ],
        ]; 

		bt1.action = { arg but;
			if(but.value == 1) {
				Pdef(patname).play
			} {
				Pdef(patname).stop
			}
		};

		slider1 = Slider.new;

		slider1.action = { arg sli;
			Pdef(patmodname).set(paramname, spec.map(sli.value))
		};

        layout = VLayout.new;
        layout.add(bt1);
		layout.add(slider1);
		layout;
	};
)

(

	~win = Window.new;
	~hlayout = HLayout.new;

	~win.view.layout = ~hlayout;

	~spec1 = ControlSpec(minval:0.01, maxval:4.2, warp:\exp, step:0, default:1);
	~hlayout.add(~make_pat_control.(\a, \pitch_stretch, ~spec1));
	~hlayout.add(~make_pat_control.(\a, \time_stretch, ~spec1));

	~win.front;

)

(
Pdef(\bmod, Pbind());
Pdef(\b, 
	Pdef(\bmod) <>
	Pbind(
		\instrument, \granu,
		\amp, 1.8,
		\legato, 0.5,
		\dur, 1/4,

		\mbufnum, ~buf,
		\time_stretch, 0,
		\pitch_stretch, Pseq([0.3, 0.1,  1, 2],inf).stutter(2),
		\release, 0.05,
		\grainrate, 100,
		\graindur, 0.05,
		\pos, 0.2,

		\isRest, Pseq([1, 0.3],inf).coin.not,  
	)
);
)

~hlayout.add(~make_pat_control.(\b, \time_stretch, ~spec1));

~hlayout.add(~make_pat_control.(\b, \legato, ~spec1));

//// control rate slider

(

Pdef(\c, 
	Pbind(
		\instrument, \granu,
		\amp, 1.0,
		\legato, 1.0,
		\dur, 1/2,

		\mbufnum, ~buf,
		\time_stretch, 0,
		\pitch_stretch, Ndef(\lfo1, { arg pitch=1; pitch.lag(0.1) }),
		\release, 0.05,
		\grainrate, 100,
		\graindur, 0.02,
		\pos, Pseq([0.4,0.2,0.01,0.5],inf),

		\isRest, Pseq([1],inf).coin.not,  
	)
).play;
)

Ndef(\lfo1).edit; // easy way

// custom way
(
        ~win = Window.new;

        ~bt1 = Button.new;

        ~bt1.states = [
            [ "start pattern c" ],
            [ "stop pattern c" ],
        ]; 

		~bt1.action = { arg but;
			if(but.value == 1) {
				Pdef(\c).play
			} {
				Pdef(\c).stop
			}
		};

		~slider1 = Slider.new;

		~spec1 = ControlSpec(minval:0.01, maxval:4.2, warp:\exp, step:0, default:1);
		~slider1.action = { arg sli;
			// change the Ndef instead of the Pdef
			~spec1.map(sli.value).postln;
			Ndef(\lfo1).set(\pitch, ~spec1.map(sli.value))
		};

        ~layout = VLayout.new;
        ~layout.add(~bt1);
		~layout.add(~slider1);
        ~win.view.layout = ~layout;
        ~win.front;
        
)

Pdef(\a).isPlaying

////////////////////////////// plazy, pfunc, prout

//// pfunc

~pitch_factor = 0.2;
(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\mypitch, Pseq([1,2],inf),
	\pitch_stretch, Pseq([1,2],inf) * ~pitch_factor, // bad
	\pitch_stretch, Pfunc({ arg ev;
		ev[\mypitch] * ~pitch_factor;
	}),
	\strum, Pseg(Pseq([0.02,0.2],inf),8),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)
~pitch_factor = 1;
~pitch_factor = 0.2;

//// Plazy

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Pseq([
		[0.1,0.2,0.3,0.4],
		[0.1,0.2,0.3,0.4].scramble, // scramble only one time
	],inf),
	\pitch_stretch, Plazy({
		Pseq([
			[0.1,0.2,0.3,0.4],
			[0.1,0.2,0.3,0.4].scramble,
		],1)
	}).loop,
	\strum, Pseg(Pseq([0.02,0.2],inf),8),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)

//// Prout

(
Pdef(\a, Pbind(
	\instrument, \granu,
	\amp, 1.8,
	\legato, 0.5,
	\dur, 1/2,

	\mbufnum, ~buf,
	\time_stretch, 0,
	\pitch_stretch, Prout({
		var tab = [0.1,0.2,0.3,0.4];
		tab.do { arg x, n;
			tab.rotate(n).postln.yield;
		};
	}).loop,
	\strum, Pseg(Pseq([0.02,0.2],inf),8),
	\release, 0.05,
	\grainrate, 100,
	\graindur, 0.05,
	\pos, 0.2,
)).play;
)
