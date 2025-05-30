
(
	SynthDef('pirodeo',{|
		freq = 200, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
		amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
		pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
		attack = 0, decay = 0, sustain = 0, release = 1,
		attack_level = 1, decay_level = -1, sustain_level = 1,
		cutoff = 95, cutoff_slide = 0, cutoff_slide_shape = 1, cutoff_slide_curve = 1,
		gate=1, rq=0.5,

		use_chorus=0, use_compressor=0, amp_scale = 0.1,

		out_bus = 0|

		var snd, filter, filter_env, env, chorus;
		var note;
		note = freq;

		note = note.varlag(note_slide, note_slide_curve, note_slide_shape);
		decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
		amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
		pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);
		cutoff = cutoff.midicps;
		cutoff = cutoff.varlag(cutoff_slide, cutoff_slide_curve, cutoff_slide_shape);

		snd = Pulse.ar(note*[1,33.5.midiratio],[0.2,0.1],[0.7,0.3]);

		filter_env = EnvGen.ar(Env.adsr(0.0, 1.0, 0.8, 3.0), gate, doneAction:2);

		//keyboard tracking filter cutoff
		snd = BLowPass4.ar(snd,(cutoff * (filter_env.squared)) + 200 + note, rq);

		chorus = Select.ar(use_chorus,
			[
				snd,
				Splay.ar(Array.fill(4,{
					var maxdelaytime= rrand(0.005,0.02);

					DelayC.ar(snd[0], maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
				}))
			]
		);

		snd = Select.ar(use_compressor,
			[
				snd,
				Compander.ar(2*(snd + chorus),snd*amp_scale,0.4,1,4)
			]
		);

		env = Env.new(
			levels: [0, attack_level, decay_level, sustain_level, 0],
			times: [attack, decay, sustain, release],
			curve: \lin
		);

		snd = Pan2.ar(Mix(snd) * EnvGen.kr(env, doneAction: 2), pan);

		Out.ar(out_bus, snd * amp);

	}).add
)


(
SynthDef('pigabberkick', {|
 	freq = 54,
	amp = 0.5, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
	pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
	attack = 0.001, decay = 0.01, sustain = 0.3, release = 0.02,
	attack_level = 1, decay_level = 0.7, sustain_level = 0.7,

	slope_start = 84, slope_length1 = 0.015,
	slope_intermediate = 69, slope_length2 = 0.1,
	boost = 8, boost_slide = 0, boost_slide_shape = 1, boost_slide_curve = 0,

	cutoff = 119, cutoff_slide = 0, cutoff_slide_shape = 1, cutoff_slide_curve = 0,
	res = 0.2, res_slide = 0, res_slide_shape = 1, res_slide_curve = 0,
	out_bus = 0|

	var snd, env;
	var note;

	note = freq;
	decay_level = Select.kr(decay_level < 0, [decay_level, sustain_level]);
	amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
	pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);

	cutoff = cutoff.midicps;
	cutoff = cutoff.varlag(cutoff_slide, cutoff_slide_curve, cutoff_slide_shape);

	slope_start = slope_start.midicps;
	slope_intermediate = slope_intermediate.midicps;

	res = res.linlin(0, 1, 1, 0);
	res = res.varlag(res_slide, res_slide_curve, res_slide_shape);

	boost = boost.varlag(boost_slide, boost_slide_curve, boost_slide_shape);

    snd = SinOsc.ar(
		Env(
			[slope_start, slope_intermediate, note],
			[slope_length1, slope_length2],
			\exp
		).ar * ([-0.1, 0, 0.1]*0).midiratio);

	snd = Mix(snd);
    //snd = (snd * \distamp1.kr(10)).tanh;
    //snd = (snd * \distamp2.kr(5.1)).atan;
    //snd = BPeakEQ.ar(snd, XLine.kr(\eqstart.kr(2000), \eqend.kr(100), \eqdur.kr(0.3)), \eqrq.kr(2.0), boost);
    //snd = snd + DelayC.ar(snd, \delrange.kr(0.001), SinOsc.ar(\delfreq.kr(1)).range(0.0, \delrange.kr(0.001)));
	snd = RLPF.ar(snd, cutoff, res);
	//snd = ((snd * 0.6).clip(-1, 1));
	snd = snd * 0.00001;

	env = Env.new(
		[0, attack_level, decay_level, sustain_level, 0],
		[attack,decay,sustain,release],
		\lin
	);

	snd = Pan2.ar(snd * EnvGen.kr(env, doneAction: 2), pan);
	Out.ar(out_bus, snd * amp * 0.5);

}).add;
)

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.2));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\zed).edit
