(
// vocoder basique analyse/copie d’enveloppes
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
    var mod, carrier, freqs, analysis, envelopes, resynth;

    // signal modulateur (voix, etc.) venant d’un bus
	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

    // signal porteuse : un saw riche en harmoniques
    carrier = LFSaw.ar(freq);

    // fréquences centrales des bandes (échelle géométrique)
    freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));

    // banque de filtres bande-passante sur le modulateur
    analysis = BPF.ar(mod, freqs, \rq.kr(0.01));

    // suiveurs d’enveloppe sur chaque bande
    envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);

    // même banque de filtres sur la porteuse
    resynth = BPF.ar(carrier, freqs, \rq.kr);

    // appliquer les enveloppes du modulateur à la porteuse et mixer
	resynth = Mix(resynth * envelopes);

	resynth = resynth * amp;

    // sortie stéréo
    Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1/2,8),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		).loop,
		Pmono(\vocoder,
			\inbus, BusDef(\ifx1, \audio),
			\note, Pseq([
				[0,7],
				[0,6],
				0,4,7,12,
			],inf),
			\octave, Pseq([3,4,5],inf).stutter(6),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			//\rq, 1,
			\amp, 8*2,
		),
	])
)).play;
);


///////////////// test carrier




(
// saw
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = LFSaw.ar(freq);

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// pulse
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = LFPulse.ar(freq);

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// sinosc
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = SinOsc.ar(freq);

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// whitenoise
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = WhiteNoise.ar;

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// fm
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(2)) * \fmamp.kr(45) + 1 ));

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// fm saw
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(2)) * \fmamp.kr(25) + 1 ));

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// whitenoise bpf
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = WhiteNoise.ar;
	6.do { arg item, idx;
		carrier = BPF.ar(carrier, freq*2, 0.2);
	};
	carrier = carrier*10*2;

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1/2,8),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		).loop,
		Pmono(\vocoder,
			\inbus, BusDef(\ifx1, \audio),
			\note, Pseq([
				[0,7],
				[0,6],
				0,4,7,12,
			],inf),
			\octave, Pseq([3,4,5],inf).stutter(6),
			//\octave, 6,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			//\rq, 1,
			\amp, 2*2,
		),
	])
)).play;
);


//////////// test bands

(
// 200-8000
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = LFSaw.ar(freq);

	freqs = Array.geom(bands, 200, (8000/200).pow(1/(bands-1)));
	freqs.debug("freqs");
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// 200-18000
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = LFSaw.ar(freq);

	freqs = Array.geom(bands, 200, (18000/200).pow(1/(bands-1)));
	freqs.debug("freqs");
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// 50-18000
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = LFSaw.ar(freq);

	freqs = Array.geom(bands, 50, (18000/50).pow(1/(bands-1)));
	freqs.debug("freqs");
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
// 2000-4000
SynthDef(\vocoder, { |out=0, freq=100, atk=0.01, rel=0.1, amp=0.5|
	var bands=64;
	var mod, carrier, freqs, analysis, envelopes, resynth;

	mod = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2).mean; 

	carrier = LFSaw.ar(freq);

	freqs = Array.geom(bands, 2000, (4000/2000).pow(1/(bands-1)));
	//freqs = freqs - 1800;
	freqs.debug("freqs");
	analysis = BPF.ar(mod, freqs, \rq.kr(0.01));
	envelopes = LagUD.kr(Amplitude.kr(analysis), atk, rel);
	resynth = BPF.ar(carrier, freqs, \rq.kr);
	resynth = Mix(resynth * envelopes);
	resynth = resynth * amp;
	Out.ar(out, resynth.dup);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('voices/kaspi.flac'),
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1/2,8),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		).loop,
		Pmono(\vocoder,
			\inbus, BusDef(\ifx1, \audio),
			\note, Pseq([
				[0,7],
				[0,6],
				0,4,7,12,
			],inf),
			\octave, Pseq([4,5],inf).stutter(6),
			\octave, Pseq([3,4,5],inf).stutter(6),
			//\octave, 6,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			//\rq, 1,
			\amp, 2*2*8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1/2,6),
			\speed, 1 * (~t/( 137/4/60 )),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		).loop,
		Pmono(\vocoder,
			\inbus, BusDef(\ifx1, \audio),
			\note, Pseq([
				[0,7],
				[0,6],
				0,4,7,12,
			],inf),
			\octave, Pseq([4,5],inf).stutter(6),
			\octave, Pseq([3,4,5],inf).stutter(6),
			//\octave, 6,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			//\rq, 1,
			\amp, 2*2*4,
		),
	])
)).play;
);
