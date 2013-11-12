(
SynthDef(\sawFilt, { |out = 0, freq = 440, amp = 0.1, gate = 1, cf = 100, wobble = 3, t_bd, t_sd, pw = 0.4|
    var base = Splay.ar(RLPF.ar(Pulse.ar(freq * [0.99,0.5,1.01],pw),cf.lag(0.05),0.3).madd(SinOsc.ar(wobble).range(0.5,4)).sin) * 0.5;
    var env = Linen.kr(gate, attackTime: 0.01, releaseTime: 0.5, doneAction: 2);
    var sig = base;
    var bd = tanh(Ringz.ar(LPF.ar(Trig.ar(t_bd,SampleDur.ir),1000),30,0.5,5).sin*2);
    var sd = tanh(Ringz.ar(LPF.ar(Trig.ar(t_sd,SampleDur.ir),1000),120,0.75,PinkNoise.ar(2!2)).sin*2);
    sd = HPF.ar(sd,60);
    //sig = tanh(GVerb.ar(HPF.ar(base * env,30), 70, 11, 0.15)*0.5 + sig + bd + sd);
    Out.ar(out, sig*amp*env);
}).add;
)

(
p = Pproto(
    {
        ~id = (
            type: \on,
            dur: 0,
            instrument: \sawFilt,
            amp: 0.1,
        ).yield[\id];
        ~type = \set;
    },
    Ppar([
        Pbind(
            \args, #[freq],
            \freq, Pseq([49,47,50,48]-12,inf).midicps,
            \dur, 4,
        ),
        Pbind(
            \args, #[cf],
            \cf, Pseq([100,Prand([700,400,1100],3)],inf),
            \stutter, Prand([1,2,4,8],inf),
            \dur, PdurStutter(Pkey(\stutter)*2, 2),
            // NOTE: also useful is .collect on patterns!
            // \dur, Prand([1,2,4,8], inf).collect{ |x| (1/x)!(x*2) }.flatten
        ),
        Pbind(
            \args, #[wobble],
            \wobble, Pxrand([3,1.5,6],inf),
            \dur, Prand([2,1],inf),
        ),
        Pbind(
            \args, #[t_bd],
            \t_bd, Pseq([1,0,0,1],inf),
            \dur, 0.5,
        ),
        Pbind(
            \args, #[t_sd],
            \t_sd, Pseq([0,0,1,0],inf),
            \dur, 0.5,
        ),
        Pbind(
            \args, #[pw],
            \pw, Prand([0.4,0.3,0.5],inf),
            \dur, 2,
        ),
    ])
).play;
)



////////////////////////////////////////////
// Silly formant synthesis example.
// Using Pmono or Pbind to create a voice.
// SynthDef is hardwired to bass formants.

// Evaluate SynthDef first, then scroll down for Pmono and Pbind.

(
// SynthDef
SynthDef("sillyVoice", { arg
	freq = 220,
	amp = 0.5,
	vibratoSpeed = 6,
	vibratoDepth = 4,
	vowel = 0,
	att = 0.01,
	rel = 0.1,
	lag = 1,
	gate = 1;

	var in, vibrato, env, va, ve, vi, vo, vu, snd;

	vibrato = SinOsc.kr(vibratoSpeed, mul: vibratoDepth);
	in = Saw.ar(Lag.kr(freq, lag) + vibrato);
	env = EnvGen.kr(Env.asr(att, 1, rel), gate, doneAction: 2);

	va = BBandPass.ar(
		in: in,
		freq: [ 600, 1040, 2250, 2450, 2750 ],
		bw: [ 0.1, 0.067307692307692, 0.048888888888889, 0.048979591836735, 0.047272727272727 ],
		mul: [ 1, 0.44668359215096, 0.35481338923358, 0.35481338923358, 0.1 ]);

	ve = BBandPass.ar(
		in: in,
		freq: [ 400, 1620, 2400, 2800, 3100 ] ,
		bw: [ 0.1, 0.049382716049383, 0.041666666666667, 0.042857142857143, 0.038709677419355 ],
		mul: [ 1, 0.25118864315096, 0.35481338923358, 0.25118864315096, 0.12589254117942 ]);

	vi = BBandPass.ar(
		in: in,
		freq: [ 250, 1750, 2600, 3050, 3340 ] ,
		bw: [ 0.24, 0.051428571428571, 0.038461538461538, 0.039344262295082, 0.035928143712575 ],
		mul: [ 1, 0.031622776601684, 0.15848931924611, 0.079432823472428, 0.03981071705535 ] );

	vo = BBandPass.ar(
		in: in,
		freq:[ 400, 750, 2400, 2600, 2900 ] ,
		bw: [ 0.1, 0.10666666666667, 0.041666666666667, 0.046153846153846, 0.041379310344828 ],
		mul: [ 1, 0.28183829312645, 0.089125093813375, 0.1, 0.01 ]);

	vu = BBandPass.ar(
		in: in,
		freq: [ 350, 600, 2400, 2675, 2950 ],
		bw: [ 0.11428571428571, 0.13333333333333, 0.041666666666667, 0.044859813084112, 0.040677966101695 ],
		mul: [ 1, 0.1, 0.025118864315096, 0.03981071705535, 0.015848931924611 ]);

	snd = SelectX.ar(Lag.kr(vowel, lag), [va, ve, vi, vo, vu]);
	snd = Mix.new(snd);
	Out.ar(0, snd!2 * env * amp);
}).add;
)


// Play around with these examples/
// Vowels a e i o u correspond to number 0 1 2 3 4

// Example 1
(
Pmono(
	"sillyVoice",
	\note, Pseq([5, 7, 9, 11], inf),
	\ctranspose, -14,
	\dur, Pwhite(0.61, 1.7),
	\amp, 0.2,
	\vibratoSpeed, Pwhite(6,7),
	\vibratoDepth, 4,
	\vowel, Pwrand([0, 2], [0.8, 0.2], inf),
	\lag, 0.5
).play;
)

// Example 2
(
Pmono(
	"sillyVoice",
	\note, Pseq([-5, -3, -1, 0], inf),
	\ctranspose, -14,
	\dur, Pwhite(0.61, 1.7),
	\amp, 0.2,
	\vibratoSpeed, Pwhite(6,7),
	\vibratoDepth, 4,
	\vowel, Pwrand([0, 1], [0.8, 0.2], inf),
	\lag, 0.5
).play;
)

// Example 3
(
Pbind(
	\instrument, "sillyVoice",
	\note, Prand([0, 5, 7, 9], inf),
	\ctranspose, -14,
	\dur, Pwhite(0.61, 1.7),
	\amp, 0.2,
	\vibratoSpeed, Pwhite(6,8),
	\vibratoDepth, 4,
	\vowel, Pwrand([0, 1], [0.8, 0.2], inf),
	\legato, 1,
	\att, 1.1,
	\rel, 2.5
).play;
)


(
SynthDef(\ChicagoPad2, { |out = 0, freq = 440, freq2=660, freq3=528, cutoff = 500, amp = 0.2, gate=1|

	var snd;
	var delay = 0.045+0.05;

	freq = freq + SinOsc.kr(freq*1/2, 0, freq/2, 0);

	snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;

	snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr(7.13).range(0.00,0.1))*0.1;


	snd = Mix(snd);
	snd = FreeVerb.ar(snd, 0.51,10,0.1)*2;
	snd = snd *8;
	snd = RLPF.ar(snd, SinOsc.kr([0.1,4.2], 0, [1700,480], [4000,700,5000])/[20.51,20], SinOsc.ar(0.1,1.5*pi)+1.05)/3;
	snd = Mix(snd);

	snd = MoogFF.ar(snd, SinOsc.kr(0.08, 0.5, cutoff/10, cutoff), 3, 0);

	snd = snd * EnvGen.ar(Env.dadsr(delay,0.4, 0.01,0.8,0.4), gate, doneAction:2);
	//snd = snd * EnvGen.ar(Env.adsr(0.4, 0.01,0.8,0.4), gate, doneAction:2);

	snd = [snd , AllpassC.ar(snd, delay, 0.05+SinOsc.ar(0.11).range(0,0.045), 0.3)];
	snd = snd * amp;
	Out.ar(out, snd);

}).add;
)

(
Pdef(\plop2, Pbind(
	\instrument, \ChicagoPad2,
	\freq, Pseq([50,50,60,40]*8,inf),
	//\root, 17,
	\freq2, Pkey(\freq)*(1/3) * 8,
	\freq3, Pkey(\freq)*(1/5) * 8,
	\legato, 1,
	\cutoff, 4500,
	\dur, 4,
	\amp, 0.7
)).play;
);
Pdef(\plop2).quant=4
Pdef(\plop2).stop
