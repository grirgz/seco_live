


(
	{
		var sig;
		sig = [
			Klank.ar (`
				[
					(1..50) * 186, 1 / (1..13),
					nil
				],
				PinkNoise.ar(0.01)
			),

			// stereo
			Klank.ar (`
				[
					(1..50) * 186, 1 / (1..13),
					nil
				],
				PinkNoise.ar(0.01)
			)
		]
	}.scope(1);
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
		sig = 
			Klank.ar (
				`[
					(1..50) * 186, 1 / (1..13),
					nil
				],
				PinkNoise.ar(0.01)
			);
		Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
}).play.scope;
);
