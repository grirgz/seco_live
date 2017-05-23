(
SynthDef(\high1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	//sig = LFSaw.ar(freq * [1,1.001] *.t [1,2,4,1/2]).flop.mean;
	freq = freq * [1,2,1/2];
	freq = freq * EnvGen.kr(Env([2,1,1],[\ft0.kr(0.01),0.8]), gate);
	freq = freq * ( 1 + ( SinOsc.ar(\fmf.kr(4)*~t) * \fmamp.kr(1) ));
	freq = freq.clip(50,18000);
	sig = [
		LFSaw.ar(freq).mean,
		LFSaw.ar(freq+0.01).mean,
	];
	//sig = sig / 4;
	sig.postln;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

//{LFSaw.kr(1/4*~t, (0..4)/4 * 2)}.plot(4/~t)

(
	Ndef(\algonote_lfofreq, { LFSaw.kr(1/4*~t, 1).range(300,15000) });
	Pdef(\algonote, 
		Plazy({ 
			Ppar(
			4.collect({
				Pseq([
					Pfindur(7,
						Pbind(
							\instrument, \high1,
							//\freq, exprand(100.0,15000),
							\fmamp, Plazy({
								Pseq(
									{[
										Pseg(Pseq([exprand(0.01,1),exprand(0.01,1)]),4),
										a=exprand(0.01,1); Pseg(Pseq([a,a]),4),
									].choose}.dup(2)
								)
							}).loop,
							\ft0, Plazy({
								Pseq(
									{[
										Pseg(Pseq([exprand(0.0001,1),exprand(0.0001,1)]),4),
										a=exprand(0.0001,1); Pseg(Pseq([a,a]),4),
									].choose}.dup(2)
								)
							}).loop,
							\fmf, Prand([128,256,4,2,8,1/2],inf).stutter(16),
							\freq, Plazy({
								Pseq(
									{[
										Pseg(Pseq([exprand(100.0,15000),exprand(300.0,15000)]),4),
										Pseg(Pseq([exprand(100.0,15000),exprand(300.0,15000)]),4),
										a=exprand(100.0,15000); Pseg(Pseq([a,a]),4),
										a=exprand(100.0,15000); Pseg(Pseq([a,a]),4),
									].choose}.dup(2)
								)

							}).loop,
							//\lpf, Ndef(\algonote_lfofreq),
							\lpf, Pseg(Pseq([rrand(300.0,15000),rrand(300.0,15000)],inf),7),
							\isRest, Pseq( {[
								[ 1,0,1,0, 1,0,1,0, ],
								[ 1,0,1,0, 0,0,0,0, ],
								[ 1,1,1,1, 0,0,0,0, ],
								[ 1,0,0,1, 1,1,0,0, ],
								[ 1,1,1,0, 1,0,1,1, ],
								[ 1,0,0,0, 1,0,0,0, ],
								[ 0,0,0,0, 1,0,0,0, ],
							].choose }.dup(8).flatten ,inf).coin.not,
							\sustain, rrand(0.051,0.2),
							\dur, [1/2,1/4,1/16,1/8].choose,
							\amp, 0.1
						);
					),
					Pfindur(1,
						Pbind(
							\instrument, \high1,
							//\lpf, Ndef(\algonote_lfofreq),
							\freq, exprand(100,15000),
							\dur, [1/4,1/16,1/8].choose,
							\amp, 0.1
						);
					),
				])

			})
		) }).loop
	);
)

// END

Pdef(\algonote).play
