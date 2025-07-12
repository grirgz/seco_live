

///////////// channels playing

// select mean mode with a two dimensional array (vertical or horizontal summing)
// strange panning effet, lofreq

sig2 = sig1.flop.mean;
sig3 = sig1.mean;
sig1 = SelectX.ar( SinOsc.kr(1/18).range(0,1), [sig2, sig3]);

// rotate the channels contents
//  rotate sig1.size channels into freq.size channels

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

 // the one the most nested appear as the most nested in result
 // size 2 is most nested, so 3 groups of 2
[1,2,3] * [[4,5]] == [[1*4, 1*5], [2*4, 2*5], [3*4,3*5]]
// sum and flop remove the outer structure, we are left with a group size of 2
( [1,2,3] * [[4,5]] ).sum == ( [1*4, 1*5] + [2*4, 2*5] + [3*4,3*5])
( [1,2,3] * [[4,5]] ).mean == [8 ,10]

// Pan act like .dup(2) when pan==0
[1,2,3].collect(_.dup(2));
Pan2.ar([sig1, sig2, sig3]) == [[sig1, sig1], [sig2, sig2], [sig3, sig3]]
Pan2.ar([sig1, sig2, sig3]).flop == [[sig1, sig2, sig3], [sig1, sig2, sig3]]
//when summed or meaned, it remains only the pan
Pan2.ar([sig1, sig2, sig3]).sum == [sig1+sig2+sig3, sig1+sig2+sig3]
Pan2.ar([sig1, sig2, sig3]).flop.sum == [sig1+sig1, sig2+sig2, sig3++sig3]
Pan2.ar([sig1, sig2]).flop.sum == [sig1+sig1, sig2+sig2]
// if you want a two channel signal to be left and right with Pan2
Pan2.ar([sig1, sig2], [-1,1]).sum; // assign each channel a pan
Pan2.ar([sig1, sig2]).flop.sum; // or flop it
// or use Splay

// *.t is nesting/flopping the second array
[1,2,3] *.t [4,5] == ( [1,2,3] * [[4,5]] ) 
[4,5] *.t [1,2,3] == ( [[1,2,3]] * [4,5] ) 
[1,2].flop == [[1,2]]
[[1,2]].flop ==  [[1],[2]]
[[1],[2]].flop == [[1,2]]
[1,2] * [400,500].flop
( [1,2].flop + [400,50] ).sum
( [1,2] + [400,50].flop ).sum

// know the shape of your array
([1,2,3] *.t [4,5]).shape.debug("shape"); // first item is outermost size, here 3
([1,2] *.t [3,4,5]).shape.debug("shape");

// flop the one you want to keep after .meaning
{ SinOsc.ar([1,1.001] * [400,900].flop).mean * 0.1; }.play; // return left channel 400hz and right 450hz
{ SinOsc.ar([1,1.001].flop * [400,900]).mean * 0.1; }.play; // return a chord with right channel slightly detuned from left
{ SinOsc.ar([1,1.001] * [400,900].flop).mean; }.plot(1/8); // return left channel 400hz and right 450hz
{ SinOsc.ar([1,1.001].flop * [400,900]).mean; }.plot(1/8); // return a chord with right channel slightly detuned from left

SinOsc.ar([1,1.001,2].flop * [400,900]).mean

{
SinOsc.ar([1,0.1] * [400,450])[1] * 0.1;
}.play;

////////////////////////////// base

// fm
SinOsc.ar(freq * ( 1 + ( SinOsc.kr(200) * 1 ))) 

// ring
SinOsc.ar(freq) * LFSaw.ar(freq)

// am
SinOsc.ar(freq) * ( 1 + ( SinOsc.kr(100) * 1 ))


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
// en fait les 6 canaux sont dupliqués a gauche et a droite, mais avec une difference de phase grace a [[0,1]]
(
// multiple sources moving in stereo
Ndef(\stereo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7, 0+12,4+12,7+12].midiratio );
	pan = pan + LFNoise1.kr(_ / 10 ! sig.size);
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
	sig = Pan2.ar(sig, pan, amp).mean;
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

	sig = LFSaw.ar(freq); 
	sig = Select.ar(sig+1*2, [ Saw.ar(freq), Pulse.ar(freq/2), SinOsc.ar(freq+1) ]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// change indexer freq
(
SynthDef(\amdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.1);

	//freq = freq * 2; // true octave
	sig = SinOsc.ar(freq * 2); // nice octave
	sig = Select.ar(sig+1*2, [ LFSaw.ar(freq), LFPulse.ar(freq), SinOsc.ar(freq) ]);
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

// recursive select
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
SynthDef(\fm_grain_test, {arg out=0,gate = 1, amp = 1, freq=200, fratio=2, pan=0;
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
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(out, sig);
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
Pdef(\plop,
	Pbind(
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
		\amp, 0.1/4
	)
).play;
);

/////////////////////////////////////
// kind of acid without RLPF

(
SynthDef(\melsap, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * EnvGen.kr(Env([1,  2, 1.1, 0.9, 1,  1/2],[0.1,0.1, 0.8, 0.1,0.1,0.8 ]), 1);
	sig = SinOsc.ar(freq);
	env2 = EnvGen.kr(Env([1,0.2,1,0.7],[0.4,1.8,2]), 1);
	sig = sig.fold(env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demome, 
	Ppar([
		Pbind(
			\instrument, \melsap,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


////////////////////////////// pok
// the env is very important, the pok sound is from the extreme short env + the extreme curve
{ SinOsc.ar(300) * EnvGen.kr(Env([0,1,0],[0.01,0.01], [4,-4]), Impulse.kr(1)) * 0.1 !2  }.play

{ SinOsc.ar(700) * EnvGen.kr(Env([0,1,0.1,0],[0.01,0.01,0.5], [4,-4]), Impulse.kr(1)) * 0.1 !2  }.play // this give a perc attack to sound

{ SinOsc.ar(700) * EnvGen.kr(Env([0,1,0],[0.01,0.5], [0,-0]), Impulse.kr(1)) * 0.1 !2  }.play // compare

{ SinOsc.ar(700) * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.01,0.1,0.5,1,[4,-4])), Duty.kr(1/2, 0, Dseq([ 1,0],inf))) * 0.1 !2  }.play // with adsr

////////////////////////////// FM Cymbal
// the key is the multichannel LFSaw fm in SinOsc create a mettalic sound and fold tame it in noise
// could add envs and pan to bring life

(
SynthDef(\fmcymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1/70,0.1,0.8,0.2)),gate,doneAction:2);
	sig = sig.fold(\fold.kr(0.23));
	sig = sig * \gain.kr(1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\plop, Pbind(
	\instrument, \fmcymbal,
	\freq, 5200,
	\fmr, 1/2,
	\diff, 0.2,
	\fold, 0.7,
	\gain, 1,
	\sustain, 0.1,
	\dur, 1,
	\amp, 0.1,
)).play;
)


/////////////////////////////////////////////
// synthetize snare, hat, pan, and any other metallic percussion
// they key is there is an impact and a resonance
// the impact should be very short to free the resonance
// the resonent frequencies do everything else

(
SynthDef(\doublebell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = sig * EnvGen.ar(Env.perc(0.001,0.01),gate); // short impact of noise
	sig = Ringz.ar(sig, \freqtab.kr({exprand(100,10000) }.dup(30)) * \freqr.kr(1), \res.kr(3)).mean; // resonance
	sig = Ringz.ar(sig, \freqtab2.kr({exprand(100,10000) }.dup(30)) * \freqr2.kr(1), \res2.kr(0.1)).mean; // other layer of resonance
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\zed, 
	Ppar([
		Plazy({ arg ev;
			Pbind(
				\instrument, \doublebell,
				\freqtab, Pseq([
					[{exprand(400,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(400,10000) }.dup(30)  ]
				],inf),
				\sustain, 0.1,
				\dur, Pseq((1..10).reverse/20),
				\freqr, Pkey(\dur),
				\freqr, Pseg(Pseq([0,1],inf),8),
				\amp, 0.1,
			);
		}).loop,
		
	])
)).play;
);


////// tuned perc with the LFSaw as striker
// added noise with envelope then filtered, this give the hall reverb style
// then crossfade between two ring filters
// can also use a ring filtered striker then ring filter it again
(
SynthDef(\doublebell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFSaw.ar(freq) + sig;
	sig = sig * EnvGen.ar(Env.perc(0.001,0.04),gate);
	sig = sig + ( HPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), 1000)  );
	sig1 = Ringz.ar(sig, \freqtab.kr({exprand(100,10000) }.dup(tabsize)) * \freqr.kr(1), \res.kr(3.dup(tabsize))).mean;
	sig2 = Ringz.ar(sig, \freqtab2.kr({exprand(100,10000) }.dup(tabsize)) * \freqr2.kr(1), \res2.kr(0.1.dup(tabsize))).mean;
	sig = SelectX.ar(Line.kr(0,0.5,1/2), [sig1 , sig2]);
	//sig = LPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,1)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\zed, 
	Ppar([
		Plazy({ arg ev;
			Pbind(
				\degree, Pseq([
					1,2,3,4,5,
				],inf),
				\instrument, \doublebell,
				\freqtab, Pseq([
					[{exprand(40,10000) }.dup(30)  ]
				],inf),
				\freqtab2, Pseq([
					[{exprand(40,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,0.3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,0.4) }.dup(30)  ]
				],inf),
				\sustain, 0.1,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
				\freqr, 1,
				\amp, 0.3,
			);
		}).loop,
		
	])
)).play;
);

/// sorting the freq and rez random arrays make higher frequency ringz for longer
// the reverse is also fun
// use rotate to move the most resonent center on the frequency band
(
SynthDef(\ringme, { arg out=0, gate=1;
	var sig;
	var tabsize = 30;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = Ringz.ar(sig, { exprand(70,12000) }.dup(tabsize).sort, { exprand(0.5000,5.6000) }.dup(tabsize).sort) * 0.01;
	sig = Ringz.ar(sig, { exprand(70,12000) }.dup(tabsize).sort, { exprand(0.5000,5.6000) }.dup(tabsize).sort.reverse.rotate(10)) * 0.01;
	sig = Splay.ar(sig, \spread.kr(0.8), 1, 0);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ring, \audio),
		),
		Pmono(\ringme,
			\inbus, BusDef(\ring, \audio),
			\dur, 1,
		),
	])
)).play;
);


////////

// Use latch to generate lfo patterns that are cyclic-like but with natural variation

(
SynthDef(\latchsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1* LFNoise1.ar(0.1,mul:0.01,add:1),1/2 * LFNoise1.ar(0.1,mul:0.01,add:1),LFNoise1.ar(0.1,mul:0.01,add:1) ]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( 
		Latch.ar( SinOsc.ar(\fmf.kr(1000.2)).unipolar, Impulse.ar(\latchfreq.kr(10))).lag(\latchlag.kr(0.01)) * \latchamt.kr(0.1) + 1 
	), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

ProtoDef(\piano).startControl

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \latchsaw,
			 \latchamt, Pseg(Pseq([0,3.71],inf),8),
			 \latchlag, Pseg(Pseq([0,0.01,1],inf),9),
			 \fmf, Pseq([
			 	[1000.2,1000.1,2000,1002]
			 ],inf),
			 \lpfr, 0.8,
			 \latchfreq, 16*~t,
			\note, Pseq([
				[0,7,12,15],
				[1,6,13,15],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

/////// latch also good as a filter!

(
SynthDef(\latched, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Latch.ar(sig, Impulse.ar(MouseX.kr(10,4999)));
	sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\latched, 
	Ppar([
		Pbind(
			\instrument, \latched,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.3,0.8,2.1) ],
			],inf),
			\note, Pseq([
				[0,7,12,15, 10],
				[0,7,12,15, 8+12]+2,
			],inf),
			\dur, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


// bass with latch
// does not work, like fm it change pitch

(
Pdef(\demo, Pdef(\latched, 
	Ppar([
		Pbind(
			\instrument, \latched,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.3,0.8,2.1) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				0,2,4,
			],inf),
			\dur, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
SynthDef(\latchbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * \freqmul.kr(8));
	//sig2 = Latch.ar(sig, Impulse.ar(MouseX.kr(10,4999).poll));
	sig2 = Latch.ar(sig, Impulse.ar( ( freq * \fmf.kr(1) ).poll ));
	//sig = sig + sig2;
	sig = sig2;
	//sig = Latch.ar(sig, Impulse.ar( freq * 4/1));
	//sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\demo, Pdef(\latched, 
	Ppar([
		Pbind(
			\instrument, \latchbass,
			\note, Pseq([
				0,2,4,5,
			],inf),
			\freqmul, 2,
			\fmf, 4.001,
			\lpfr, 10,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\demo, Pdef(\latched, 
	Ppar([
		Pbind(
			\instrument, \latchbass,
			\note, Pseq([
				0,2,4,5,
			],inf),
			\freqmul, 1,
			\fmf, 6.001,
			\lpfr, 10,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////////// impending doom or thx: let fm desync phase progressively
(
SynthDef(\doom, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(
		( freq * ( ExpRand(0.100,0.7000!16) * 0.007 + 1 ) )
		* ( SinOsc.ar(ExpRand(0.0100,0.07000!16)/1).round(0.01) * SinOsc.ar(Rand(0.100,0.7!16)/10).range(0,0.9) + 1 )
		* ( SinOsc.ar(ExpRand(100,7000!16)) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.03) + 1 ) 
	);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \rq.kr(0.5));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\doom, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(
		( freq * ( ExpRand(0.100,0.7000!16) * 0.007 + 1 ) )
		* ( SinOsc.ar(ExpRand(0.0100,0.07000!16)/1).round(0.01) * SinOsc.ar(Rand(0.100,0.7!16)/10).range(0,0.2).neg + 1 )
		* ( SinOsc.ar(ExpRand(100,7000!16)) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.03) + 1 ) 
	);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \rq.kr(0.5));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \doom,
			\note, Pseq([
				0,4,12,
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////////////// grain enveloppe

// serie
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0, 3, 7, 12, 15].midiratio);
	sig = sig * Decay.kr(Impulse.kr((0..sig.size-1)), 0.4) * 4;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

// polyrythm
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0, 3, 7, 12, 15].midiratio);
	sig = sig * Decay.kr(Impulse.kr([2,3,5,7]), 0.4) * 4;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


(
// 30 channels with random freq, apply env serie
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	sig = SinOsc.ar(freq * TWChoose.kr(Dust.kr(1.1!num), [0, 3, 7, 12, 15].midiratio, 1!5,1).poll);
	sig = sig * Decay.kr(Impulse.kr((0..sig.size-1)/10), 0.8);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 8*2;
}).play;
);

(
// random grain duration
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	sig = SinOsc.ar(freq * TWChoose.kr(Dust.kr(0.1!num), [0, 3, 7, 12, 15].midiratio, 1!5,1).poll);
	sig = sig * Decay.kr(Impulse.kr((0..sig.size-1)/30), LFNoise1.kr(1/2!num).range(0.01,4.0));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 8*2;
}).play;
);

(
// Dust triggered grains
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	sig = SinOsc.ar(freq * TWChoose.kr(Dust.kr(0.1!num), [0, 3, 7, 12, 15].midiratio, 1!5,1).poll);
	sig = sig * Decay.kr(Dust.kr((0..sig.size-1)/30), LFNoise1.kr(1/2!num).range(0.01,4.0));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 8*2;
}).play;
);

(
// Dust triggered grains filtered
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	sig = SinOsc.ar(freq * TWChoose.kr(Dust.kr(0.1!num), [0, 3, 7, 12, 15].midiratio, 1!5,1).poll);
	sig = sig * Decay.kr(Dust.kr(0.7!num), LFNoise1.kr(1/32!num).exprange(1.5,4.0)) * 3;
	sig = RHPF.ar(sig, \hpf.kr(100) * LFNoise1.kr(1/12!2).range(1.0,30.0), \rq.kr(0.3))*5*2;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig *8 ;
}).play;
);

(
// Dust triggered grains + allpass
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	sig = SinOsc.ar(freq * TWChoose.kr(Dust.kr(0.1!num), [0, 3, 7, 12, 15].midiratio, 1!5,1).poll);
	//sig = sig * Decay.kr(Dust.kr(0.7!num), LFNoise1.kr(1/32!num).range(0.41,4.0));
	sig = sig * Decay.kr(Dust.kr(0.1!num), LFNoise1.kr(1/32!num).exprange(1.5,4.0)) * 3;
	//sig = RHPF.ar(sig, \hpf.kr(100) * LFNoise1.kr(1/22!num).range(1.0,30.0), \rq.kr(0.3))*5*2;
	//sig = RHPF.ar(sig, \hpf.kr(100) * LFNoise1.kr(1/12!2).range(1.0,30.0), \rq.kr(0.3))*5*2;
	sig = AllpassL.ar(sig, 4/~t, 0.101 * LFNoise1.kr(1/4!4).range(0.9,2.1),0.3)*3 + sig;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig *2 *4;
}).play;
);

(
// full parrallel grain
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	var grainimp = Dust.kr(0.1!num);
	sig = SinOsc.ar(freq * TWChoose.kr(grainimp, [0, 3, 7, 12, 15].midiratio, 1!5,1).poll);
	//sig = sig * Decay.kr(grainimp, TRand.kr(3.1,9,grainimp)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.5,0.1)), Trig.kr(grainimp, TRand.kr(1.1,9,grainimp)), doneAction:0);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig *2 *8;
}).play;
);

(
// full parrallel sawlpf grain
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 30;
	var grainimp = Dust.kr(0.1!num);
	sig = LFSaw.ar(freq * TWChoose.kr(grainimp, ( [0, 3, 7, 12, 15]+0 ).midiratio, 1!5,1).poll);
	//sig = sig * Decay.kr(grainimp, TRand.kr(3.1,9,grainimp)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.5,1.5)), Trig.kr(grainimp, TRand.kr(0.1,0.3,grainimp)), doneAction:0);
	sig = RLPF.ar(sig, freq * TWChoose.kr(grainimp, [0, 3, 7, 12, 15].midiratio, 1!5,1), \rq.kr(0.1));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig *2 *8;
}).play;
);

//////////////////////////////////////
// how to get a resonant body effect
// - Integrator
// - Decay2
// - feedback




//////////////////////////////////////////////////////////////
///////////////// FM


// simple fm

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \zed,
		\degree, Pseq([0],inf),
		\dur, 8,
		\amp, 0.1,
	)
).play;
);

// detune in stereo to get slow moving effect
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq + [0,0.7]) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

// different way: do not add freq, add a small frequency like 0.2, this will be the moving frequency
// do not multiply between 0 and 1, but go above 1
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq) * freq * 4 + 0.2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

// now you can modulate with noise to get all kind of texture
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq) * freq * LFNoise1.kr(0.21).range(1,10) + 0.2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

// modulate carrier
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq) * freq * 4 + LFNoise1.kr(0.2).exprange(0.01,10) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

// all in one
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq/2 + [0,0.7]) * freq * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.2).exprange(0.01,1) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

// small delta
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq/2 + [0,0.07]) * freq * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.2).exprange(0.01,1) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

// high delta
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq/2 + [0,1.07]) * freq * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.2).exprange(0.01,1) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);


// several fm op, harmonic 1, 2, 3
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(SinOsc.ar(freq + [0,0.07]) * freq * LFNoise1.kr(0.21).range(1,30) + LFNoise1.kr(0.2).exprange(0.01,2) );
	sig2 = SinOsc.ar(SinOsc.ar(freq*2 + [0,0.27] ) * freq*2  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig3 = SinOsc.ar(SinOsc.ar(freq*3 + [0,1.27]) * freq*3  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig = sig1 + sig2 + sig3;
	sig = sig / 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0,2,-1,3],inf),
		\octave, 2,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

////
(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(SinOsc.ar(freq + [0,0.07]) * freq * LFNoise1.kr(0.21).range(1,30) + LFNoise1.kr(0.2).exprange(0.01,2) );
	sig2 = SinOsc.ar(SinOsc.ar(freq*2 + [0,0.27] * ( sig1 * LFNoise1.kr(0.12).range(0,0.41) + 1 )) * freq*2  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig3 = SinOsc.ar(SinOsc.ar(freq*3 + [0,1.27] * ( sig2 * LFNoise1.kr(0.12).range(0,0.41) + 1 )) * freq*3  * LFNoise1.kr(0.21).range(1,10) + LFNoise1.kr(0.012).exprange(0.01,2) );
	sig = sig1 + sig2 + sig3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0,2,-1,3],inf),
		\octave, 2,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pmono(
		 \zed,
		\degree, Pseq([0],inf),
		\octave, 2,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


//////////////////////////////////////////////////////////
//////////////////////////////// synthdef architecture
//////////////////////////////////////////////////////////

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
- pluck + whitenoise + filter + dist

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
- latch

/////////// pitch types
- multitonnal Array.series 
- dust chord chooser
	(
	Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
		var sig;
		var num = 10;
		freq = freq * num.collect({ 
			TWChoose.kr(
				Dust.kr(0.1),
				[0,3,7,0+12].midiratio,
				[1,1,1,1],
				1,
			);
		});
		sig = SinOsc.ar(freq);
		sig = Pan2.ar(sig, pan, amp).mean;
		sig.debug("sig");
	}).play;
	);


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
- enveloppe:
	

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



////////////// granulation grain

- architecture
	- each grain is panned differently (TGrain)
	- one granulator for each channel, to have different grain size in left and right for example
		- can be achieved at pattern level
- grain frequency
	- random
   		- level
		- frequency
		- waveform (LFNoise1 or LFNoise0)
		- can be constant during note (Rand)
- grain duration
	- random
- pitch_stretch
	- random 
- buffer position
	- random
	- lfo
		- waveform
		- left/right dephasing
		- continuous or unique for each note
	- scan (forward continuously buffer position)
		- speed (time_stretch)
		- 
- filter
- fm
- am


//////// chan opener
/// take an array of channel and mute them all of gate is 0 and mute half is gate is 0.5

	~chanOpener = { arg door, array;
		array * ( door - ((0..array.size-1)/(array.size) ).postln * array.size ).clip(0,1);
	};


/////////////////// modulation
// two kind : linear and exponential
// linear:
//   mod = (lfo * amt) + base
// exponential:
//   mod = (amt ** lfo) * base

// normalized linear: 
//   mod = base * ( lfo * amt + 1 )
//   mod = ( base * lfo * amt ) + base
//     here the amt goes from 0 to 1 and when at 1, it can't exceed 0 or 2*base
//     in non normalized linear modulation, maximum amt shoud be equal to base


// harkins: In the example above, I set a default baseline filter frequency = 600 (your
// value) and a default modulation amount = 4x (2 octaves). When the envelope
// is at rest, it's 0 -- then 4 ** 0 = 1, then 600 * 1 = 600 so the modulation
// isn't deviating from the baseline at that point (desired behavior for
// modulator = 0). At its peak, 4 ** 1 = 4, then ffreq = 600 * 4 = 2400 =
// maximum deviation (also desired behavior).

2**0
2**0.1001
1**3.1001
0.1**0.0001

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * (\amt.kr(3) ** SinOsc.ar(1) ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit
Ndef(\zed).set(\amt, 0.0001)


(
{ [ 
	0.3 ** SinOsc.ar(2), 
	1 ** SinOsc.ar(2), 
	3 ** SinOsc.ar(2), 
	30 ** SinOsc.ar(2), 
	SinOsc.ar(2)   
] }.plot(2)
)

(
{ 
	var eg = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	[ 
	0.3 ** eg,
	1 ** eg,
	3 ** eg,
	//30 ** eg,
	eg,
] }.plot(2)
)
