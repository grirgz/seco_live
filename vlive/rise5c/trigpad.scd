
(
~freqs = Scale.minor.as(Array) / 16 + 2;

~freqs = Scale.minor.degreeToRatio((0..7), 0) * 2;
~freqs.do { arg val, x;
	var row = 33;
	var node = Veco.main.clip.abspos_to_buf(Point(x, row));
	node[\execute] = { arg self;
		TempoClock.default.play({
			Ndef(~tbits1+++\fx).set(\freqfac, val);
			nil;
		}, 1.0/4);
	};
	node.is_present = true;
	node.response_mode = \exec;
}
)

Scale.minor.as(Array)
Scale.minor.degreeToRatio((0..7), 0)
