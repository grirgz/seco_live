

///////////// channels playing

// select mean mode with a two dimensional array (vertical or horizontal summing)
// strange panning effet, lofreq

sig2 = sig1.flop.mean;
sig3 = sig1.mean;
sig1 = SelectX.ar( SinOsc.kr(1/18).range(0,1), [sig2, sig3]);

// rotate the channels contents

sig1 = PanAz.ar(freq.size, sig1, {LFNoise1.kr(( 1/2 ).rand).range(-1,1)} ! sig1.size).flop.mean;

// rotate the channels contents in stereo field

sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;

// select direction mode (column or row) in 2d array
sig = SelectX.ar( SinOsc.kr(1/9).range(0,1), [sig, sig.flop] ); // crossfade between direction mode
sig = SelectX.ar( SinOsc.kr(1/13).range(0,1), sig ); // then select a row or column depending the direction

// in 2d array TODO
sig1 = PanAz.ar(freq.size, sig1, {LFNoise1.kr(( 1/2 ).rand).range(-1,1)} ! sig1.size).flop.mean;
// difference between: separating a channel in 4 identic copies then passing each copy in a different filter then selecting a channel
// and: panning a channel in 4 channel and pass each channel in a different filter then summing ?

////////////// multichannel expansion with matrix

[1,2,3] * [1,2] == [1*1, 2*2, 3*1]
[[1,2], [3,4]] * [5,6] == [[1*5, 2*5], [3*6,4*6]]
[[1,2], [3,4]] * [[5,6]] == [[1*5, 2*6], [3*5,4*6]]

[[1,2], [3,4]] * [5,6,7] == [[1*5, 2*5], [3*6,4*6], [1*7,2*7]]
[[1,2], [3,4]] * [[5,6,7]] == [[1*5, 2*6, 1*7], [3*5, 4*6, 3*7]]

[1,2,3] *.t [4,5] == ( [1,2,3] * [[4,5]] ) 
[4,5] *.t [1,2,3] == ( [[1,2,3]] * [4,5] ) 

////////////////////////////// base

// fm
SinOsc.ar(freq * ( 1 + ( SinOsc.kr(200) * 1 ))) 

// ring
SinOsc.ar(freq) * LFSaw.ar(freq)


/////////////////////////////// multichannel
SinOsc.ar(freq * (1..8)/8)  // create a range from 1/8 to 1 (8 channels)
SinOsc.ar(freq * (0..7)/7)  // create a range from 0 to 1 (8 channels)

/////////////////////////////// osc

SinOsc.ar(freq) 
SinOsc.ar(freq * [1,1.01]) 
SinOsc.ar(freq * Array.series(8,1,0.1)) 
SinOsc.ar(freq * (0..7)/7) 

/////////////////////////////// branch a multichannel signal
// we have 5 voices and want to apply a detune for each voice and add to itself


	freq = freq*[1/4,1/2,1,2,4] ; // 5 voices

	sig = LFSaw.ar(freq + [0, (\diff.kr(1)/1)].flop).flop.sum; // detune and add
	sig.debug("sig1");
	sig = SinOsc.ar(freq) + sig; 
	sig = sig * ( 1+[osclo, osclo+oscmid/2, oscmid, oscmid+oschi/2, oschi]); // 5 channel signal
	sig = sig.fold2( SinOsc.kr(1/15 * [1,1.2].flop).range(0.4,1) ).flop.sum; // apply 2 different fold to each voice
	sig.debug("sig2"); // 5 channel signal


//////////////////////////////// have a real env in a Ndef
// just double the level and add a zero second time segment

(
Ndef(\bass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var metro = Impulse.kr(1*~t);
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * freq;
	//env1 = EnvGen.kr(Env([4,2,1]/2,[0.1,0.8]), metro); // looped env
	env1 = EnvGen.kr(Env([4,4,2,1]/2,[0,0.1,0.8]), metro); // real env
	sig = LFSaw.ar(freq * [1,1.01,1/2]);
	sig = sig + SinOsc.ar(freq/2).fold(0.82);
	sig = RLPF.ar(sig, freq * env1, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

//////////////////////////////////////////// multichannel and stereo
/// when having SinOsc.ar([100,233,333]) Ndef will make a 3-channel synth
/// just add .flop and then Ndef will sum the channels to a stereo
/// or add .mean which will flop and sum


(
Ndef(\bass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var metro = Impulse.kr(1*~t);
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,2,1,
	],inf)).midiratio * freq;
	//env1 = EnvGen.kr(Env([4,2,1]/2,[0.1,0.8]), metro); // looped env
	env1 = EnvGen.kr(Env([4,4,2,1]/2,[0,0.1,0.8]), metro); // real env
	sig = LFSaw.ar(freq * [1,1.01,1/2]);
	sig = sig + SinOsc.ar(freq/2).fold(0.82);
	sig = RLPF.ar(sig, freq * env1, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

///////////////////////////////////////////// playing with sinosc phases


Ndef(\minitek, { SinOsc.ar((1..100) * 2).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * Duty.kr(4,0,Dseq([1,2,4,8],inf))).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).tanh.mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).fold2(0.51).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100) * 2).tanh.mean ! 2  }).play
Ndef(\minitek2, { SinOsc.ar((1..100) * 4).mean ! 2  }).play
Ndef(\minitek3, { SinOsc.ar((1..100) * 1).tanh.mean ! 2  }).play
Ndef(\minitek4, { SinOsc.ar((1..100) * Duty.kr(1,0,Dseq([16,2,8,2],inf))).mean ! 2 * 0.5  }).play
Ndef(\minitek3, { LPF.ar(SinOsc.ar((1..140) * 4, mul:[ LFPulse.kr(1/8).range(0,1),0.4,1, SinOsc.kr(1/2).range(0,1)]).mean, 700) ! 2  }).play


Ndef(\minitek, { SinOsc.ar((1..100).collect({ arg x, idx; x*( idx/100 ) }) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).mean ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100).collect({ arg x, idx; x*( log(idx)/4 ) }) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).mean ! 2  }).play

Ndef(\minitek, { LFPulse.ar((1..100).collect({ arg x, idx; 5 + (idx.odd.if({0+idx* SinOsc.kr(1/10).range(1/10,1/700)},{1+idx/200}))  }) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).mean * 0.3 ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100).collect({ arg x, idx; 2+( SinOsc.ar(1+( idx/100 ))*idx/1 )  }) * Line.kr(0,28,32)).mean * 0.3 ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100).collect({ arg x, idx; 2+( SinOsc.ar(1+( idx/100 ))*idx/1 * Line.kr(0,idx,32+idx))  }) ).mean * 0.3 ! 2  }).play
Ndef(\minitek, { SinOsc.ar((1..100).collect({ arg x, idx; 2+( SinOsc.ar(1/1000+( idx/1000 ))*idx/1 * LFPulse.kr(idx/1000,0,mul:32+idx))  }) ).mean * 0.3 ! 2  }).play

Ndef(\minitek, { LFPulse.ar((1..100).collect({ arg x, idx; 1 + (idx/1000)  }) * Duty.kr(1,0,Dseq([1,2,4,8],inf))).mean ! 2  }).play // cool comb

////////////////////// custom pulse wave

(
Ndef(\custom_pulse, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Duty.ar(1/freq, 0, Dseq([
		-1,1,0,-0.2,
		Dwhite(-1,1,1)
	],inf));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

//////////////////////// stereo
// ne pas confondre plusieurs sources reparties dans le champ stereo, et le fait d'etaler un son dans le champ stereo
(
// multiple sources moving in stereo
Ndef(\stereo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7, 0+12,4+12,7+12].midiratio );
	pan = pan + LFNoise1.kr(sig.collect({ arg x, idx; idx/10  }));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

// ex1
(
// multiple source centered
Ndef(\stereo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7, 0+12,4+12,7+12].midiratio, [[0,1]]  ).mean;
	sig = sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp).sum;
}).play;
);

(
// multiple sources widened (no pan to set them to center)
Ndef(\stereo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7, 0+12,4+12,7+12].midiratio, [ [0,1] ] ).mean;
	sig = sig.debug;
	sig = sig * amp;
}).play;
);

// ex2
(
// multiple sources centered
Ndef(\stereo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7, 0+12,4+12,7+12].midiratio *.t [1,1.01] ).mean;
	sig = sig.debug;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
(
// multiple sources widened
Ndef(\stereo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7, 0+12,4+12,7+12].midiratio *.t [1,1.01] ).mean;
	sig = sig.debug;
	sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

///////////////////////////// how to get a rich sound
// simply consider every basic property of a rich sound
// - harmonics
// - timbre variation
// - pitch variation
// - panning variation
// - amplitude variation
// - multichannelize

(
	// start with a sinosc
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// add harmonics (other waveform, substract, add, phasing, fm, am, ring, waveshaping)
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq/2) * 0.3 )));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// add timbre variation ( add lfo to harmonics technics )
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq/2 * SinOsc.kr(1/14,mul:0.1,add:1)) * 0.3 )));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// add pitch variation (melody, chords, rising pitch, continuous or segment)
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		2,1,0,0,
	],inf)).midiratio;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq/2 * SinOsc.kr(1/14,mul:0.1,add:1)) * 0.3 )));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// add panning variation (channels moving, stereo channel moving, stereo widening, channels spreading)
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		2,1,0,0,
	],inf)).midiratio;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq/2 * SinOsc.kr(1/14 * [1,1.01],mul:0.1,add:1)) * 0.3 ))); // stereo widening the fm
	sig = sig * amp; 
	// no more Pan2 needed
}).play;
);

(
	// amplitude variation (env, lofreq am, waveshaping?)
Ndef(\plop, { arg freq=200, pan=0, amp=0.1, time=1;
	var sig;
	freq = freq * Duty.kr(time/~t, 0, Dseq([
		2,1,0,0,
	],inf)).midiratio;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq/2 * SinOsc.kr(1/14 * [1,1.01],mul:0.1,add:1)) * 0.3 ))); // stereo widening the fm
	sig = sig * EnvGen.kr( Env([0.1,1,0.1],[0.1,0.8]), Impulse.kr(1/time*~t));
	sig = sig * amp; 
	// no more Pan2 needed
}).play;
);

(
	// multichannlize: make multiple copies of some block and add a variation (harmonics, timbre, pitch, amplitude, panning )
Ndef(\plop, { arg freq=200, pan=0, amp=0.1, time=1;
	var sig;
	freq = freq * Duty.kr(time/~t, 0, Dseq([
		2,1,0,0,
	],inf)).midiratio;
	sig = 8.collect({ arg idx;
		var lfo;
		lfo = SinOsc.ar(14 * [1,1.01],mul:0.1 * (idx+1 /114),add:1);
		sig = SinOsc.ar(freq * ( idx/10000 * 0 +1)* ( 1 + ( SinOsc.ar(freq/2  * lfo) * ( idx+1 )/7 ))); // stereo widening the fm
	}).mean;
	sig = sig * EnvGen.kr( Env([0.1,1,0.1],[0.1,0.8]), Impulse.kr(1/time*~t));
	sig.debug("sig");
	sig = sig * amp; 
	// no more Pan2 needed
}).play;
);

(
	// multichannel panning
Ndef(\plop, { arg freq=200, pan=0, amp=0.1, time=1;
	var sig;
	freq = freq * Duty.kr(time/~t, 0, Dseq([
		2,1,0,0,
	],inf)).midiratio;
	sig = 8.collect({ arg idx;
		var lfo;
		var ipan;
		lfo = SinOsc.ar(14 * [1,1.01],mul:0.1 * (idx+1 /114),add:1);
		sig = SinOsc.ar(freq * ( idx/10000 * 0 +1)* ( 1 + ( SinOsc.ar(freq/2  * lfo) * ( idx+1 )/7 ))); // stereo widening the fm
		ipan = pan + LFNoise1.kr(idx/20,mul:0.8);
		sig = Splay.ar(sig, 1, 1, ipan);
		sig;
	}).mean;
	sig = sig * EnvGen.kr( Env([0.1,1,0.1],[0.1,0.8]), Impulse.kr(1/time*~t));
	sig.debug("sig");
	
	sig = sig * amp; 
}).play;
);

///////////////////////// wave indexing !!!!!!!


(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	sig = SinOsc.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\amdel,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

// components changes, harsh sound
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	sig = SinOsc.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq/2), SinOsc.ar(freq+1) ]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// each repeat change the sound
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);
	sig = SinOsc.ar(freq); 
	4.do { arg x;
		sig = Select.ar(sig+1*2, [ Saw.ar(freq+x), Pulse.ar(freq), SinOsc.ar(freq) ].scramble);
	};
	//sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq), SinOsc.ar(freq) ]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



//////////////////////// FMGrain
// en fait on peut faire blindé de trucs avec FMGrain


(
SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(200), 0.14, freq, freq*fratio,
		LFNoise1.ar(500!2).range(1, 10),
	);
	sig = sig * EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		doneAction: 2
	);
	sig = sig /4;
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(0, sig);
}).add;
)

(
Pdef(\plop, Pbind(
	\instrument, \fm_grain_test,
	\fratio, Pseq([1,2,3/2,1.21314],inf),
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(240 * ( 1 + ( SinOsc.ar(4*~t) * 0.1 ))), 0.14, freq, freq*fratio * ( 1 + ( SinOsc.ar(freq*8) * 0.01 )),
		LFSaw.ar(200!2).range(0.1, 11),
	);
	sig = sig * 1/4;
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 180);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(0, sig);
}).add;
)
(
Pdef(\plop, Pbind(
	\instrument, \fm_grain_test,
	\fratio, 1/2,
	\fratio, Pseq([1,2,3/2,1.21314],inf),
	\degree, Pseq([0,2],inf),
	\octave, Pseq([3,4],inf).stutter(2),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig;
	
	env1 = EnvGen.kr(Env([1,8,31],[0.3,1.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(40 * ( 1 + ( SinOsc.ar(20*~t) * 0.1 ))), 0.14, freq * [1,2,1/2], freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar([ 200!2 ]).range(0.1, 1 * env1),
	).sum;
	sig = sig * 1/4;
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 180);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.4,0.1,0.8,1.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(0, sig);
}).add;
)

(
Pdef(\plop, Pbind(
	\instrument, \fm_grain_test,
	\fratio, 1/2,
	\fratio, Pseq([1],inf),
	\degree, Pseq([
		[0,2,4],
		[0,2-12,4],
		[0,2,4],
		[3,5-12,7],
	],inf),
	\octave, Pseq([4,5],inf).stutter(2),
	\legato, 1,
	\dur, 2,
	\amp, 0.1/8
)).play;
);
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////// architecture

soundscape
	- pdef with random dur and short synthdef as grain
	- big multichannel synthdef
	- dust

////////////// models

- oscs + filters // additive
	- chord based
	- mono synth
	- rising pitch/wobble/falling pitch
- noise + filters // substractive
- dust // soundscape
- array of random frequency (metallic)

//////////////////// synths
- kick
	falling osc freq or filter freq
	add pop and click
- snare
	short osc + noise with env modulated filter 
- hat
	noise with env modulated filter 
	array of random frequency (metallic)
- bass: 
	multiple osc with light fm and light dist
	detune lfsaw + freq octave + filter
- nappe
- soundscape
- lead
- subbass: simple sinosc

//////////// noise
- LFNoise1.kr(freq)
- WhiteNoise / PinkNoise
- Gendy1.ar(freq)
- fm
	Ndef(\test,{ LFSaw.ar(100 * ( 1 + ( LFSaw.ar(10 * ( 1 + ( SinOsc.ar(10) * 441 ))) * 444 ))) !2*0.1  }).play // high
	Ndef(\test,{ SinOsc.ar(50 * ( 1 + ( LFSaw.ar(50 * ( 1 + ( SinOsc.ar(10) * 4 ))) * 4 ))) !2*0.1  }).play // bass

/////////// random
- random from -n to n with bias to 0: 10.0.bilinrand

/////////// pitch types
- multitonnal Array.series 

////////////// processing
- freqshift the freq to double tune
- dist tanh
- fold
- CombC with inverse frequency as delay time
- level shifting: LeakDC.ar(sig + 1.3) 
- fm
- pm
- am
- add am : sig = sig * (mod + 1)
- self am:  sig = sig * (sig +1);

///////////// how to elabore a more complex synthdef

- multichannelize an argument
	- with serie (1..7)
		- add scale parameter
	- with random { rrand(0,1) }!8
	- with osc or lfnoise
- osc an argument (with different freq for each for phasing pseudo random effect or tempo frequence for rhytm)
- lfnoise an argument
- fm an argument ( 1 + ( SinOsc.kr(fm) * 1 ))


////////// simple fx
- a delay to add more presence
- multichannel lfnoise or osc the panning
- feedback
- chorus/flanger

///////////// advanced
- sample a synthdef, apply rdn multiple time
