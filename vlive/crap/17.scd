(
SynthDef.new(\boom_ef, {
        arg out=0, amp=1, freq=121, len=0.23, boost=5, pan=0;
        var sig, ampenv;
        ampenv = EnvGen.kr(Env.triangle(len,boost),doneAction:2);
        sig = SinOsc.ar(freq) + PinkNoise.ar(0.12);
        sig = (sig * ampenv).clip(-1,1);
        sig = RLPF.ar(sig, freq*3, 0.5);
        //sig = sig * amp;
		sig = Pan2.ar(sig, pan, amp);
        Out.ar(out, sig);
}).add;
)

Synth.new(\boom_ef);



~call = {
	w = (
		RLPF.ar(LFPar.ar(SinOsc.ar(100).range(100,103),0,SinOsc.kr(1.5).range(0.95,1))
		+ PinkNoise.ar(0.12),[400,500,1000,3000],1,SinOsc.kr(0.1).range
		(0.75,0.8)
	).sum);
	w = FreeVerb.ar(w,0.5,0.4) * 0.4 * EnvGen.ar(
		Env.new([0, 0.99, 1, 0], [1.5, 3, 4],[-4, 0, 5]),SinOsc.kr(0.1)); w =
		HPF.ar(w,150)   !2
}.play



(
fork {
    loop {
		p = ParGroup.new;
        (
            degree: rrand(0.0, 12.0).round(1/4),
            group: p,
            db: rrand(-30, -25),
            pan: rrand(-1.0, 1.0)
        ).play;
        0.2.wait;
    }
}
)


(
fork {
    p = ParGroup.new;
    loop {
        (
            degree: rrand(0.0, 12.0).round(1/4),
            group: p,
            db: rrand(-30, -25),
            pan: rrand(-1.0, 1.0)
        ).play;
        0.2.wait;
    }
}
)


(
Pbind(
	\instrument, \default,
	\group, p,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Server.supernova
	p = ParGroup.new;
	x = 0;
(
	fork {
		100.do {
			Synth(\default, [\freq, 2000.rand+50], target:p);
			x = x + 1;
			x.postln;
			0.02.wait;
		};
	};
)
Volume.volume
VolumeGui.new
s.volume.volume = -5
Server.supernova
Server.threads
s.options.threads = 3
s.options.threads
Server.default.options.threads
Server.scsynth



