(
Pdef.defaultQuant = 2;
//Ndef.defaultQuant = 1;
~t = 135/4/60; TempoClock.default.tempo = ~t;
s.waitForBoot {
	"lib.scd".loadRelative;
	//FileSystemProject.load("capsule/lib.scd");
	FileSystemProject.load("capsule/ile_lib.scd");
	FileSystemProject.load("capsule/mainwindow.scd");
	FileSystemProject.load("capsule/track1.scd");
	FileSystemProject.load("capsule/draftsynth.scd");
	FileSystemProject.load("capsule/PatKitDef_ksh.scd");
	FileSystemProject.load("holis/synthdef.scd");

};
);


(


	// define channels
	Pdef(\kick, Pbind(
		\out, BusDef(\mixer0, \audio),
	));
	Pdef(\snare, Pbind(
		\out, BusDef(\mixer1, \audio),
	));
	Pdef(\hat, Pbind(
		\out, BusDef(\mixer2, \audio),
	));
	Pdef(\bass, Pbind(
		\out, BusDef(\mixer3, \audio),
	));
	Pdef(\pad, Pbind(
		\out, BusDef(\mixer4, \audio),
	));
	Pdef(\piano, Pbind(
		\out, BusDef(\mixer5, \audio),
	));

	// less generic name to avoid name clash
	Pdef(\c_kick, Pbind(
		\out, BusDef(\mixer0, \audio),
	));
	Pdef(\c_snare, Pbind(
		\out, BusDef(\mixer1, \audio),
	));
	Pdef(\c_hat, Pbind(
		\out, BusDef(\mixer2, \audio),
	));
	Pdef(\c_bass, Pbind(
		\out, BusDef(\mixer3, \audio),
	));
	Pdef(\c_pad, Pbind(
		\out, BusDef(\mixer4, \audio),
	));
	Pdef(\c_piano, Pbind(
		\out, BusDef(\mixer5, \audio),
	));
	Pdef(\c_drums, Pbind(
		\out, BusDef(\mixer6, \audio),
	));

	BusDef(\mixer6, \audio);
	BusDef(\mixer7, \audio);
	BusDef(\mixer8, \audio);




	ProtoDef(\simpleMixer).tracks[0].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[1].proxy.set(\send0, 1);
	ProtoDef(\simpleMixer).tracks[2].proxy.set(\send0, 1);
	ProtoDef(\rdn).outBus = BusDef(\mixer7, \audio);
	ProtoDef(\rdn).inBus = BusDef(\sendbus1, \audio);
	ProtoDef(\rdn).fxdef = \del3;

	ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn2).outBus = BusDef(\mixer8, \audio);
	ProtoDef(\rdn2).inBus = BusDef(\sendbus2, \audio);
	ProtoDef(\rdn2).fxdef = \del3full;
	ProtoDef(\rdn2).genfx;
	ProtoDef(\rdn2).proxy.set(\indelay, 0.04);

	ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn3).outBus = BusDef(\mixer8, \audio);
	ProtoDef(\rdn3).inBus = BusDef(\sendbus3, \audio);
	ProtoDef(\rdn3).fxdef = \del3full;
	ProtoDef(\rdn3).genfx;
	ProtoDef(\rdn3).proxy.set(\indelay, 0.04);

	7.do { arg idx;
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\prefader, 1);
		ProtoDef(\simpleMixer).tracks[idx].proxy.set(\postdelay, 0.04);
	};

	~master = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
	~master_simple = {
		ProtoDef(\simpleMixer).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};


);

~startControl.();


(
	~master.();
	Pdef(\main, 
		Pseq([
			Pdef(\track1),
			Rest(8),
			Pdef(\drbass),
			Rest(8),
			Pdef(\track2),
		])
	).play;
)

// END

////////////// CONTROL

WindowDef(\main).front;

ProtoDef(\rdn).edit;
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2).edit;
ProtoDef(\rdn).inbus
ProtoDef(\simpleMixer).edit;
~master.()

	(
	~master2 = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
	)
