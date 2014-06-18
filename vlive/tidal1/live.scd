
(
Pdef(\plop, 
	

		Pbind(
			\instrument, \dwgplucked,
			\degree, Pseq([0],inf),
			\freq, Pseq([1000,200,300,400],inf).stutter(Pseq([2,1,4],inf)),
			\freq, Pseq([40,50],inf),
			//\cuspfreq, Pseq([1000,500,5000,2000],inf),
			\cuspfreq, Ndef(\lfo1, { SinOsc.kr(2).range(10,50) }),
			\c3, 0.1,
			\isRest, Pseq([
				1,0,0,0,
				0.51,0,0.5,0,
			],inf).coin.not,
			\isRest, false,
			\dur, 8,
			\amp, 0.2
		)
).play;
);


(
Pdef(\kick, Pbind(
	\instrument, \kick,
	\degree, Pseq([0],inf),
	\env0, [ Env.new([9.5, 1, 0.5, 0], [0.005, 0.06, 00.2], [-4, -2, -4]) ],
	\env1, [ Env.new([90, 41, 35], [0.005, 0.29], [-4, -5]) ],
	\dur, 1/2,
	//\stretch, 1/2,
	\amp, 0.4
)).play;
);

(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\fac1, Pseq([
		[40,50],
		[40,50]+10,
	],inf),
	\fac2, [
		Ndef(\lfo2, {CuspN.ar(1/4).range(10,12)}),
		Ndef(\lfo2, {CuspN.ar(2).range(50,12)}),
	],
	\dur, 1,
	\legato, 1,
	\decay, [ 2, 0.5 ],
	\amp, 0.4
)).play;
);

(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\fac1, Pseq([
		50,
	],inf),
	\fac2, 10,
	\dur, 1/8,
	\legato, 1,
	\isRest, Pseq([
		1,0,0,0,
		0.51,0,0.5,0,
	],inf).coin.not,
	\decay, 0.1,
	\amp, 0.2
)).play;
);

(
play {
};
)

(
);


DWGPlucked



//Define pluck synthdef

//Use it.
(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

Pbind(
    \instrument, \help_dwgplucked,
    \scale ,a,
    \delta , Pseq([1,0.5,0.5,0.5,0.5,0.5,0.5,1,0.5,0.5,1,1]*0.25,inf),
    \dur , 2,
    \degree, Pseq([1,8,8,8,8,8,8,-6,Prand([9,10,11],1),1,7,8]-8, inf),
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([1400],24),Pseq([300],24)],inf),
    \pan , Pwhite(-1,1),
).play;
)



//Define pluck synthdef
(
SynthDef(\help_dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked2.ar(freq, amp, gate,0.1,1,c3,inp);
    DetectSilence.ar(son, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)

Pseq([( dur: 1, sustain:0.5, note:27 )],inf) <> Pbind(\instrument, \dwgplucked).play

a = Plop
a.gui
Pseq([a.notes]) <> Pbind(\insttr)

//Use it.
(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

Pbind(
    \instrument, \help_dwgplucked,
    \scale ,a,
    \delta , Pseq([1,0.5,0.5,0.5,0.5,0.5,0.5,1,0.5,0.5,1,1]*0.25,inf),
    \dur , 2,
    \degree, Pseq([1,8,8,8,8,8,8,-6,Prand([9,10,11],1),1,7,8]-8, inf),
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([1400],24),Pseq([300],24)],inf),
    \pan , Pwhite(-1,1),
).play;
)


DetectSilence


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseg(Pseq([0,1,2,3],inf), 1/4),
	//\isRest, Pseq([1,1,0,1],inf).coin.not,
	\dur, Pseq([1/4,1/4,1/4],inf),
	\amp, 0.1
)).play;
);
