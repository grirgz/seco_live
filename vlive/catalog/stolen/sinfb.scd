
(
{ // from ritchse 
    var fb = InFeedback.ar(0,2);
    var del = MouseX.kr(0.3,0.07,0,1.2);
    var ffreq = 1/del;
    var freq = LFNoise0.kr(ffreq/16).exp.range(55,110) + LFNoise2.kr(4,0.1);
    var chirp, signal;
    freq = [freq,freq*1.5];
    fb = DelayC.ar(fb,0.3,del,[1.05,0.9]);
    chirp = SinOsc.ar(1100,0,LFClipNoise.kr(ffreq*2).range(0,0.05));
    chirp = Pan2.ar(chirp,LFNoise2.kr(ffreq/2));
    signal = SinOsc.ar(freq,fb.reverse*MouseY.kr(0,5),0.3) - chirp + (fb*0.2);
	signal = signal * 0.5;
}.play
);

(
Ndef(\bla, {
    var fb = InFeedback.ar(0,2);
    var del = MouseX.kr(0.3,0.07,0,1.2);
    var ffreq = 1/del;
    var freq = LFNoise0.kr(ffreq/16).exp.range(55,110) + LFNoise2.kr(4,0.1);
    var chirp, signal;
    freq = [freq,freq*1.5];
    fb = DelayC.ar(fb,0.3,del,[1.05,0.9]);
    chirp = LFCub.ar(1100 * LFNoise0.kr(ffreq/8).range(1,0.05),0,LFClipNoise.kr(ffreq*2).range(0,0.05));
    chirp = Pan2.ar(chirp,LFNoise2.kr(ffreq/2));
	signal = SinOsc.ar(freq,fb.reverse*MouseY.kr(0,5),0.3) + chirp + (fb*0.5);
	//signal = signal.softclip(-0.3,0.3);
	signal = signal.clip(-0.3,0.3);
	//signal * 0.5;
}).play
);


(
Ndef(\bla, { arg amp=0.1, freq=100;
	
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	sig = 0;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		//isig = Limiter.ar(isig);
		isig = SinOsc.ar(freq!2, fb.reverse * MouseY.kr(0,5));
		isig;
	});
	sig = sig * amp;
}).play;
)


(
SynthDef(\fbsin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = 0;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		//isig = Limiter.ar(isig);
		isig = DelayC.ar(isig, 0.3,1/freq) + isig;
		isig = SinOsc.ar(freq!2, fb.reverse * isig);
		isig;
	});
	sig = sig * amp;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fbsin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = 0;
	sig = sig + Fb({ arg fb;
		var isig;
		var isig2;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		//isig = Limiter.ar(isig);
		isig = DelayC.ar(isig, 0.3,\delay.kr(0.101) * [1,4	]) + ( isig * \mixsigamp.kr(0.1) );
		isig = DelayC.ar(isig, 0.3,\delay2.kr(0.001) * [1,4	]) + isig;
		isig = SinOsc.ar(freq!2 * [[1,2,3,4]] * ( fb.reverse * isig * \fmamp.kr(1) +1 ),mul:[ \harmamp.kr([1,0.7,0.5,0.3]) ]).flop.mean;
		isig2 = ( isig*\distamp.kr(2) ).tanh * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig2]);
		isig.debug("isig");
		isig;
	});
	sig = sig * amp;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \fbsin,
		//\fb, ~pmodenv.(Pseq([1,2,1,4]/2,1), Pwhite(0.1,2)).loop,
		\fmamp, 0.2,
		\fmamp, ~pmodenv.(Pseq([0.1,8,1,4]/8,1), Pwhite(0.1,2)).loop,
		\fb, ~pmodenv.(Pseq([0.1,8,1,4]/8,1), Pwhite(0.1,2)).loop,
		\degree, Pseq([0,3,2,1],inf),
		\octave, 3,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pmono(
		 \fbsin,
		//\fb, ~pmodenv.(Pseq([1,2,1,4]/2,1), Pwhite(0.1,2)).loop,
		\fmamp, 0.2,
		\fmamp, ~pmodenv.(Pseq([0.1,18,1,4]/8,1), Pwhite(0.1,2)).loop,
		\fb, ~pmodenv.(Pseq([0.1,18,1,4]/8,1), Pwhite(0.1,2)).loop,
		\degree, Pseq([0,0,0,-5, -1,-1,-1,-3],inf)+3,
		\octave, 3,
		\octave, 3 + Pwrand([0,1,2],[1,0.01,0.01].normalizeSum,inf),
		\harmamp, Pseq([
			[ [ 1,0.3,0.3,0.3,0.1 ] ],
			[ [ 1,0.7,0.3,0.2,0.81 ] ],
			[ [ 1,0.7,0.3,1,3 ] ],
		],inf),
		\distmix, Pwhite(0,1.0,inf),
		\dur, 1/2,
		\amp, 0.6,
	)
).play;
);

(
Pdef(\zed, 
	PmonoArtic(
		 \fbsin,
		//\fb, ~pmodenv.(Pseq([1,2,1,4]/2,1), Pwhite(0.1,2)).loop,
		\fmamp, 0.2,
		\fmamp, ~pmodenv.(Pseq([0.1,18,1,4]/8,1), Pwhite(0.1,2)).loop,
		\fb, ~pmodenv.(Pseq([0.1,18,1,4]/8,1), Pwhite(0.1,2)).loop,
		\degree, Pstep(Pseq([0,0,0,-5, -1,-1,-1,-3],inf)+3, 1),
		\octave, 3,
		\octave, 3 + Pwrand([0,1,2],[1,0.01,0.01].normalizeSum,inf),
		\harmamp, Pseq([
			[ [ 1,0.3,0.3,0.3,0.1 ] ],
			[ [ 1,0.7,0.3,0.2,0.81 ] ],
			[ [ 1,0.7,0.3,1,3 ] ],
		],inf).stutter(4),
		\distmix, Pwhite(0,1.0,inf).stutter(2),
		\legato, Pseq([
			1,0,1,1, 0,0,1,0,
			1,1,0,1, 1,0,1,1,
			1,1,1,1, 0,0,0,0,
			1,1,0,1, 0,0,0,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\amp, 0.6,
	)
).play;
);
