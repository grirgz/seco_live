
(
SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;

    // body starts midrange, quickly drops down to low freqs, and trails off
    bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 100, 51], [0.035, 0.08], curve: \exp)));
    bodyAmp = EnvGen.ar(\bodyampenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    popFreq = XLine.kr(\popfreqstart.kr(750), \popfreqend.kr(261), \popfreqtime.kr(0.02));
    popAmp = EnvGen.ar(\popampenv.kr(Env.linen(0.001, 0.02, 0.001))) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
    click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \bwfreq.kr(2110)), \clicklpf.kr(3140)) * clickAmp;

    snd = body + pop + click;
    snd = snd.tanh;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}, metadata:(specs:(
	bodyfreqenv: XEnvSpec(\freq),
	bodyampenv: XEnvSpec(\amp),
	popampenv: XEnvSpec(\amp),
))).add;

SynthDef(\snapsnare, { |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

SynthDef(\snaphihat, { |out = 0, pan = 0, amp = 0.3, igate=1, gate=1, doneAction=2|
    var click, clickAmp;
    var noise, noiseAmp;
    var snd;
	var itrig = \itrig.tr(1);
	var rel = \rel.kr(1);
	var env1, env2, env3, env4, env5, env6, env7, env8;

    // noise -> resonance -> expodec envelope
    //noiseAmp = EnvGen.ar(Env.perc(0.001, \rel.kr(1), curve: -8), gate, doneAction: 2);
    noiseAmp = EnvGen.ar(Env([0,0,0.1,1,0],[0,0.01,0.01,rel]), itrig, doneAction: 0);
	env1 = EnvGen.kr(Env([1,1,0.8,1.1],[0,0.1,rel]), itrig) * \level.kr(1);
    noise = Mix(BPF.ar(ClipNoise.ar, [4010, 4151] * env1, [0.15, 0.56], [1.0, 0.6])) * 0.7 * noiseAmp;

    snd = noise;
	snd = noise * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.0,1,0.1)), gate, doneAction:doneAction);

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

// adapted from a post by Neil Cosgrove (other three are original)
SynthDef(\snapclap, { |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
);
