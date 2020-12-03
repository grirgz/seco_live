// different Ndefs for each parameter eg. 
(
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1)
))).add;
)


Ndef(\mix, {var mix; mix = Ndef.kr(\lfo).linlin(-1,1,0.05,3.75)});
Ndef(\predelay, {var predelay; predelay = Ndef.kr(\lfo).linlin(-1, 1, 100.05, 700.15)});
Ndef(\lfo, {arg rate=2.5; var lfo; lfo = SinOsc.ar(rate)});


(
	Pdef(\test,
		Pmono(\saw,
			\dur, 1,
			\lpfr, Ndef(\mix).asMap,
			\freq, Ndef(\predelay).asMap,
			\amp, 1
		)
	).play;
)

// Pkey

Ndef(\lfo, {arg rate=0.5; var lfo; lfo = SinOsc.ar(rate).linlin(-1,1,0.05,0.75)});

(
Pdef(\reverbtest,
Pmono(\reverb,
\dur, 1,
\mix, Ndef(\lfo).asMap,
\delaytime, Pkey(\mix.linlin(0.05, 0.75, 0.05, 0.15)),
\in, ~reverbBus,
\amp, 1
)).play;
)


(
p = Pbind(
	\degree, Pwhite(-4, 11, 32),
	\pan, Env([-1, 0, -1], [2, Pseq([1,2],inf)], \sin),
	\dur, 0.125
).play;
)


(
Pdef(\zed, 
	Pmono(\default,
		\freq, 200,
		\dur, inf,
		\amp, 0.1,
	),
).play;
);

Pdef(\zed).stop
PathName("//ddd/fff/../aaa///../aze.scd").normalizedPath
FileSystemProject.unresolve("repeat/simpleProject")




// what can it sound like? see: https://www.youtube.com/watch?v=dRmY3tEwZyE 
// the youtube version has been sent through an additional reverb pedal, but
// you don't need the pedal to get something that sounds interesting

(
//s.options.memSize_(16384*10);
//s.reboot;
s.waitForBoot({
	
	Ndef(\bits, {
		var t = PulseCount.ar(Impulse.ar(8e3));
		var u = PulseCount.ar(Impulse.ar(7009));
		var sig = HPF.ar(
			(
				((t * 15) & (t >> 5)) |
				((t * 5) & (t >> [3, 4])) |
				((t * 2) & (t >> 9)) |
				((t * 8) & (t >> 11)) |
				(((t*t) & t) | (t >> 3))
				- 3 % 256
			) / 127-1 * 3
			, 20
		) * 0.1;
		var sig2 = LPF.ar(HPF.ar(gcd(t*u, u+t), WhiteNoise.ar()*2000 + 1000), 20);
		sig2 = sig2*sig;
		sig = 0.3*Splay.ar(Limiter.ar(Greyhole.ar(sig + sig2, sig, 0.5, sig), 0.5).flatten);
		//sig = 0.3*Splay.ar(Limiter.ar(sig + sig2, 0.5).flatten);
	}).play;
});
)

(
Ndef(\bitshift, {
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var bufnum;
    var t = PulseCount.ar(Impulse.ar(8e3));
		var u = PulseCount.ar(Impulse.ar(7009));
    var sig = HPF.ar(
        (  
            ((t * 15) & (t >> 5)) |
            ((t * 5) & (t >> [3, 4])) |
            ((t * 2) & (t >> 9)) |
            ((t * 8) & (t >> 11))
            - 3 % 256
        ) / 127-1 * 3
        , 20
    ).distort * 0.2; 

	sig = LFSaw.ar(4200) ;
	bufnum = BufDef(\amen, "vipere/amenbreak.wav");
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * 1, 1, startPos: (0*BufFrames.kr(bufnum)), doneAction:2, loop: 1);
	sig = DC.ar(1);
	sig2 = LPF.ar(HPF.ar(sig, WhiteNoise.ar()*2000 + 1000), 20).poll;

	//sig2 = sig2*sig;
	sig.debug("sig");
	sig = 0.3*Splay.ar(Limiter.ar(Greyhole.ar(sig2, 1, 0.1, 0.2, sig,1.9,0.9,1), 0.5).flatten);
	sig = HPF.ar(sig, 2300)*5;
    //sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
}).play;
)
