
PatKitDef(\algokit).edit
PatKitDef(\algokit).savePresetCompileString

Pdef(\algo2, ~kiterize.(Pdef(\algo2_p4)))

Pdef(\algonote).stop

(
TrackDef(\algogrid, TrackTemplateDef(\playergrid)).source = [
	[
		Pdef(\algo2),
	],
	[
		Pdef(\algonote),
	],
];
)
TrackDef(\algogrid).edit

////////////////////////////// wobble

(
SynthDef(\wobblebass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freq2;
	freq = freq * ( (1..10)/10000+1 ) * [1,1/2];
	//freq2 = freq * ( 1 + ( SinOsc.ar(\fmf.kr(1) * [1,1.01]) * \fmamp.kr(1/2) ));
	freq2 = freq * SinOsc.kr(\fmf.kr(1)).range(0.1,2);
	sig = LFSaw.ar(freq);
	//sig = sig + SinOsc.ar(freq * [1,1/2,2] );
	sig = ( sig * 10 ).tanh / 2;
	//sig = RHPF.ar(sig, ( \hpf.kr(1/4) * freq2).clip(20,19000), \hrq.kr(0.5));
	sig = RLPF.ar(sig, ( \lpf.kr(3) * freq2).clip(20,19000), \lrq.kr(0.5));
	sig = sig + DelayC.ar(sig, 0.1,0.0001 + rrand(0.0001,0.01!10));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.postln;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\wobble, Pbind(
	\instrument, \wobblebass,
	\fmf, Plazy({ arg ev;
		Pseq(
			4.partition.collect({ arg x;
				x.postln;
				Pseq([
					[2,4,8,6,4,16,1,1/2].choose *~t
				], x)
			})
		)
	}).loop,
	\degree, Pseq([Pwhite(1,10,8).stutter(8)],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
Pdef(\wobble, 
	Plazy({
		var notes;
		notes = 4.collect({ exprand(100,6000); }) ;
		Pseq(
			8.collect({
				Pseq(
					4.partition.collect({ arg x, idx;
						x.postln;
						Pbind(
							\instrument, \wobblebass,
							\fmf, [2,4,8,6,4,16,1,1/2].choose *~t,
							\freq, Pseq([notes[idx]], x),
							\dur, 1/8,
							\amp, 0.1
						)
					})
					,2
				);
			})
		)

	}).loop
).play;
);

(
Pdef(\wobble, 
	Plazy({
		var notes;
		var freqs;
		var div=[2,4,8].choose;
		freqs = 4.collect({ exprand(80,900); }) ;
		notes = 4.collect({ rrand(0,12*3); }) ;
		Pseq(
			8.collect({
				Pseq(
					8.partition([2,4].choose).collect({ arg x, idx;
						//x.postln;
						Pfindur(x/div, Pbind(
							\out, BusDef(\fx1,\audio),
							\instrument, \wobblebass,
							\fmf, [2,4,8,6,4,16,1,1/2].choose *~t,
							\fmamp, exprand(0.1,1),
							\legato, [1,0.5,0.1,0.9,0.8].choose,
							//\legato, 1,
							//\freq, Pseq([freqs[idx]], inf),
							\note, Pseq([notes[idx]], inf),
							\octave, 3,
							\dur, [1/2,1/8,1/4].choose,
							\isRest, Pseq([
								[1,0.5,0].choose,
							],inf).coin.not,
							\amp, 0.1,
						))
					})
					,[1,2].choose
				);
			})
		)

	}).loop
).play;
);
ProtoDef(\rdn).edit
