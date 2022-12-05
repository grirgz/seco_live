(
SynthDef.new(\bufrd_trig, {
	arg amp=1, out=0, buf, seg=#[0, 2.285], pitchRatio=#[1,1], timeDispersion=0;// 2.285 = 4*60/105 = 4 beats
	var sig, ptr, env, start, length, startSamp, endSamp, durSamp;

	durSamp = BufDur.ir(buf) * BufSampleRate.ir(buf);
	start = seg[0]; length = seg[1];
	startSamp = start * BufSampleRate.ir(buf);
	endSamp = startSamp + (length * BufSampleRate.ir(buf));
	ptr = Line.ar(startSamp, endSamp, length, doneAction: 2);
	sig  = BufRd.ar(2, buf, ptr, loop:0, interpolation:4) * 0.55;
	env = Env.new([0, 1, 1, 0], [0.02, 0.96, 0.02] * length, curve: [-4, 0, 4]);
	sig = sig * EnvGen.ar(env, doneAction: 2);
	Amplitude.kr(sig).ampdb.poll;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

~buf = ~buf ?? { Buffer.read(s, "~/Téléchargements/pads.wav".standardizePath) }


(
Pdef(\test, 
	Pmono(
		\bufrd_trig,
		\buf, ~buf,
		\seg, [[0,100]],
		\dur, 1,
		\amp, 4,
	),
)).play;
);
