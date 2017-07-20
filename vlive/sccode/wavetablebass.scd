/*
formula-based morphing wavetable synth

inspired by Xfer Records Serum, in particular the "formula parser." VOsc3 doesn't antialias as well as
Serum, but if you stay in the bass for fundamental frequencies it should sound ok.
*/

// allocate buffer memory (do this only once)
// 256 frames of 2048-sample wavetables
(
~samples = 2048;
~frames = 256;
b = Buffer.allocConsecutive(~frames, s, ~samples * 2, completionMessage: { "done".postln; });
)

// fill in buffers
// you can do this multiple times, even live code it while synth is running
(
var formulas, formula;

formulas = (
    // I ported some Serum formulas if you want to experiment
    'lo-fi triangle': { |x, z| round((z * 14 + 2) * x.abs) / (z * 7 + 1) - 1 },
    'harmonic sync': { |x, z| var w = (x + 1) / 2; sin(w * pi) * sin(w * pi * (62 * z * z * z + 2)) },
    'brassy': { |x, z| sin(pi * x.sign * x.abs.pow((1 - z + 0.1) * pi * pi)) },
    'saw/sine reveal': { |x, z| if(x + 1 > (z * 2), x, sin(x * pi)) },
    'i can has kickdrum': { |x, z| sin(pi * z * z * 32 * log10(x + 1.1)) },
    'midpoint mischief': { |x, z| 0.5 * cos(x * 0.5pi) * (x.sin * pi + ((1 - z) * sin(z * pow(x * x, z) * 32pi))) },
    'taffy': { |x, z| sin(x * 2pi) * cos(x * pi) * cos(z * pi * pi * (abs(pow(x * 2, 3) - 1))) },
    // try your own!
    // x is the sample position in the from -1 to 1, and z is the frame position from 0 to 1
);

formula = formulas['midpoint mischief'];
formula = formulas['i can has kickdrum'];
formula = formulas['saw/sine reveal'];
formula = formulas['harmonic sync'];
formula = formulas['brassy'];

b.do { |table, frame|
    var signal, z;
    z = frame / ~frames;
    signal = Signal.fill(~samples, { |j|
        var x;
        x = j / ~samples * 2 - 1;
        formula.(x, z);
    });
    table.loadCollection(signal.asWavetable);
    signal.free;
};
)

(
SynthDef(\bass, {
    var snd, wavetableControl, freq, ffreq;
    freq = \freq.kr(440).varlag(0.1, warp: \exp);
    wavetableControl = LFNoise2.kr(11).range(0, 1.0) ** 3;
    ffreq = LFNoise2.kr(6.3).exprange(400, 8000);
    snd = VOsc3.ar(b[0].bufnum + (wavetableControl * (~frames - 1)), *freq * [-0.1, 0, 0.1].midiratio);
    snd = snd + (SinOsc.ar(freq * 0.5) * -3.dbamp);
    snd = tanh(snd * 1.4);
    snd = RLPF.ar(snd, ffreq, 0.8);
    snd = snd * Env.adsr(0.1, 0.3, 0.7, 0.1).kr(2, \gate.kr(1));
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;
)

(
Pmono(\bass, *[
    octave: 3,
    amp: 0.4,
    dur: 3.0,
    scale: Scale.minor,
    degree: Pseq([7, 6, 2, 3, 5], inf),
    legato: 1.1
]).play;
)

// contributors so far: nathan ho

//////////////////////////////////////////////// modif


/*
formula-based morphing wavetable synth

inspired by Xfer Records Serum, in particular the "formula parser." VOsc3 doesn't antialias as well as
Serum, but if you stay in the bass for fundamental frequencies it should sound ok.
*/

// allocate buffer memory (do this only once)
// 256 frames of 2048-sample wavetables
(
~samples = 2048 * 8;
~frames = 256;
b = Buffer.allocConsecutive(~frames, s, ~samples * 2, completionMessage: { "done".postln; });
)

// fill in buffers
// you can do this multiple times, even live code it while synth is running
(
var formulas, formula;

formulas = (
    // I ported some Serum formulas if you want to experiment
    'lo-fi triangle': { |x, z| round((z * 14 + 2) * x.abs) / (z * 7 + 1) - 1 },
    'harmonic sync': { |x, z| var w = (x + 1) / 2; sin(w * pi) * sin(w * pi * (62 * z * z * z + 2)) },
    'brassy': { |x, z| sin(pi * x.sign * x.abs.pow((1 - z + 0.1) * pi * pi)) },
    'saw/sine reveal': { |x, z| if(x + 1 > (z * 2), x, sin(x * pi)) },
    'i can has kickdrum': { |x, z| sin(pi * z * z * 32 * log10(x + 1.1)) },
    'midpoint mischief': { |x, z| 0.5 * cos(x * 0.5pi) * (x.sin * pi + ((1 - z) * sin(z * pow(x * x, z) * 32pi))) },
    'taffy': { |x, z| sin(x * 2pi) * cos(x * pi) * cos(z * pi * pi * (abs(pow(x * 2, 3) - 1))) },
    // try your own!
    // x is the sample position in the from -1 to 1, and z is the frame position from 0 to 1
);

formula = formulas['i can has kickdrum'];

b.do { |table, frame|
    var signal, z;
    z = frame / ~frames;
    signal = Signal.fill(~samples, { |j|
        var x;
        x = j / ~samples * 2 - 1;
        formula.(x, z);
    });
    table.loadCollection(signal.asWavetable);
    signal.free;
};
)

(

SynthDef(\bass, {
    var snd, wavetableControl, freq, ffreq;
    freq = \freq.kr(440).varlag(0.1, warp: \exp);
    wavetableControl = LFNoise2.kr(11).range(0, 1.0) ** 3;
    ffreq = LFNoise2.kr(6.3).exprange(400, 8000);
    snd = VOsc3.ar(b[0].bufnum + (wavetableControl * (~frames - 1)), *freq * [-0.1, 0, 0.1].midiratio);
    snd = snd + (SinOsc.ar(freq * 0.5) * -3.dbamp);
    //snd = tanh(snd * 1.4);
    snd = RLPF.ar(snd, ffreq, 0.8);
    snd = snd * Env.adsr(0.1, 0.3, 0.7, 0.1).kr(2, \gate.kr(1));
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;

Pdef(\bass, Pmono(\bass, *[
    octave: 3,
    amp: 0.4,
    dur: 1/1,
    scale: Scale.minor,
    //degree: Pseq([7, 6, 2, 3, 5], inf),
    degree: Pseq([2, 0, 0, 0], inf),
    legato: 1.1,
	out: BusDef(\sendbus0, \audio),
])).play;
)

ProtoDef(\rdn).edit

SynthDef(\bass, { arg pan=0;
    var snd, wavetableControl, freq, ffreq;
    freq = \freq.kr(440).varlag(0.1, warp: \exp);
    wavetableControl = SinOsc.kr(11).range(0, 1.0);
    ffreq = LFNoise2.kr(1/6.3).exprange(400, 8000);
    snd = VOsc3.ar(b[0].bufnum + (wavetableControl * (~frames - 1)), *freq * [-0.1, 0, 0.1].midiratio);
    snd = snd + (SinOsc.ar(freq * 0.5) * -3.dbamp);
    snd = tanh(snd * 1.4);
    snd = RLPF.ar(snd, ffreq, 0.1);
	//snd = snd + DelayC.ar(snd, 0.01, LFNoise2.kr([1/42,1/44]).range(0.00001,0.001));
    snd = snd * Env.adsr(0.1, 0.3, 0.7, 0.1).kr(2, \gate.kr(1));
	//pan = pan+ LFNoise2.kr((1..4)/6, mul:0.9);
    snd = Pan2.ar(snd, pan, \amp.kr(0.1));
	snd = snd.mean;
    Out.ar(\out.kr(0), snd);
}).add;
