
// END

Ndef(\ins, { arg level, limit;
	var in = SoundIn.ar([0,1])*level;
	Limiter.ar(in, limit)
	0;
}).play
Ndef(\ins).edit;
