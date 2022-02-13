// better to have synthdef in a separate code block to give the time to build and send on the server
(
SynthDef("test",{
    arg freq = 200,amp = 0.1, gate = 1, wowrelease = 3, feedback =1, out;
    var chorus,source, snd, filtermod, env;
    chorus = Lag.kr(freq,lagTime: 10,) * LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range
(1, 1.02);
    filtermod = SinOsc.kr(1/16).range(6,10);
    source = LFSaw.ar(chorus) * 0.5;
    env = Env.asr(1, amp, wowrelease).kr(2, gate);
    snd = LPF.ar(in: source, freq: freq * filtermod, mul: env);
    //local = LocalIn.ar(2)+snd.dup;
    //15.do{local = AllpassN.ar(local, 0.06, Rand(0.001,0.06),3)};
    //LocalOut.ar(local*feedback);
    Out.ar(out,Splay.ar(snd));

}).add;

SynthDef(\reverb, {
    arg in, out =0;
    var sig;
    sig = InFeedback.ar(in,2); // InFeedback allow you to not care about node order for simple fx routing
    sig = FreeVerb.ar(sig,0.5,0.8,0.2);
    Out.ar(out,sig);

}).add;

~reverbBus = ~reverbBus ?? { Bus.audio(s, 2); }; // this syntax avoid creating a new bus each time you run the code

// clocks were not used in your code so i removed them
// using different \tempo in several Pbind on the same clock can't work
// an alternative to clocks is scaling \dur using \stretch or with simple multiplication
// this way you can change tempo of the whole piece at a single point by changing default clock tempo
TempoClock.default.tempo = 1;
);



(
Pdef(\line2, // Pdef are lot easier to work with, because sound is replaced when code is executed again
	Pbind( 
		\scale, Scale.melodicMinor,
		\instrument, "test",
		\degree, Pseq([6,2,7,3],inf),
		\dur, Pseq([1.5,4/8,2+9/8,2+2/8],inf), 
		\stretch, 60/39.5, 
		\amp, Pwhite(0.05, 0.1),
		\ctranspose, -12,
		\legato, Pwhite(0.98, 1),
		\out, ~reverbBus;
	).trace
);
Pdef(\line3, 
	Pbind(
		\scale, Scale.melodicMinor,
		\instrument, "test",
		\degree, Pseq([8,4,7,5],inf),
		\dur, Pseq([1,3/8,2+9/8,2+2/8],inf),
		\amp, Pwhite(0.08,0.1),
		\ctranspose, -12,
		\stretch, 60/40,
		\out, ~reverbBus;
	).trace
);

Pdef(\main, 
	Ppar([ // Ppar is handy to ensure sounds are started in sync
		Pdef(\line2),
		Pdef(\line3),
		Pmono(\reverb, // Pmono is nice for using fx
			\in, ~reverbBus,
			\out, ~delayBus,
		),
		Pmono(\reverb, // Pmono is nice for using fx
			\in, ~delayBus,
		),
	]),
).play;
)

Pdef(\main).stop; // with Pdef no need to store the player in a separate variable

XOut


/////////////////


~t = 1; TempoClock.default.tempo = ~t;
TempoClock.default.tempo = 40/60;

(
~line3 = Pbind(
		\scale, Scale.melodicMinor,
		\instrument, "test",
		\degree, Pseq([8,4,7,5],inf),
		\dur, Pseq([1,3/8,2+9/8,2+2/8],inf),
		\amp, Pwhite(0.08,0.1),
		\ctranspose, -12,
		\tempo, 40/60,
	).trace
)
);
~line3.play;

4/6


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\stretch, 0.2,
		\amp, 0.1,
	)
).play;
);



~ss = Synth(\reverb)
~ss.release

(
Pdef(\zed, 
	Pbind(
		\instrument, \reverb,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

//////////////////////////////:


{ var sig = SinOsc.ar(80,mul:Line.kr(0.1,4,0.1)); [sig, sig.clip2(1), sig.softclip, sig.tanh, sig.distort] }.plot(0.1)

///////////


(
SynthDef(\bpfsaw, {
    arg atk=2, sus=2, rel=3, c1=1, c2 =(-1),
    freq = 500, cf = 1500, rq = 0.2, amp =1, out =0;
    var sig,env;
    env = EnvGen.kr(Env([0,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
    sig = Saw.ar(freq);
    sig = BPF.ar(sig, cf, rq);
    sig = sig*env;
    Out.ar(out, sig);

}).add;
)
Synth(\bpfsaw);

(
(1..6).choose.do{
    //arg f;
    Synth(
        \bpfsaw,
        [
            \freq, 440;//exprand(100,1000),
            \amp, 0.25,
            \cf, exprand(200,5000),
            \rq, exprand(0.01,0.5),
        ]
    );
};
)

(
(1..6).choose.do{
    //arg f;
    Synth(
        \bpfsaw,
        [
            \freq, 0.25, \amp, 0.25,
            \cf, exprand(200,5000),
            \rq, exprand(0.01,0.5),
        ]
    );
};
)

    (
	Synth(
		\bpfsaw,
		[
			\freq, 440,//exprand(100,1000),
			\amp, 0.25,
			\cf, exprand(200,5000),
			\rq, exprand(0.01,0.5),
		]
	);
    )



/////////

(
SynthDef(\bpfsaw, {
    arg atk=2, sus=5, rel=5, c1=1, c2 =(-1),
    freq = 500,amp =1, out =0,detune = 0.2,
    cfmin =500, cfmax = 2000, rqmin = 0.1, rqmax = 0.2, pan =0;
    var sig,env;
    env = EnvGen.kr(Env([0.1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
    sig = Saw.ar(freq*LFNoise1.kr(0.5,detune).midiratio);
    sig = BPF.ar(
        sig,
        LFNoise1.kr(0.2).poll.exprange(cfmin,cfmax),
        LFNoise1.kr(0.1).exprange(rqmin,rqmax)
    );
    //sig = Pan2.ar(sig,pan);
    sig = sig*env * amp;
    Out.ar(out, sig!2);

}).add;
)


1/0.2
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bpfsaw,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

10000/(2**9)
