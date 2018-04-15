
RandDelayNetwork(\del4).make(\fx1, "5--", BusDef(\sendbus1, \audio))
Ndef(\fx1).edit

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
)

// contrain error is because BusDef is a control bus by default, clear Ndef and retry

/////////////////////:

// need to load rdn protodef file


ProtoDef(\rdn).edit
Ndef(\rdn).edit
Ndef(\rdn).clear
