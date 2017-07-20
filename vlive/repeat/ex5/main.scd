
(
	s.waitForBoot {
		
		//~t = 235/4/60;

		//~t = 185/4/60; TempoClock.default.tempo = ~t;//orig
		~t = 120/1/60; TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
FileSystemProject.load("ex3/lib.scd");
//FileSystemProject.load("ex3/barlokkit.scd");
FileSystemProject.load("algokit/PatKitDef_algokit.scd");
FileSystemProject.load("algokit/kits/PatKitDef_kitsec.scd");
FileSystemProject.load("algokit/gen.scd");
FileSystemProject.load("algokit/patlist.scd");
FileSystemProject.load("algokit/kitlib.scd");
FileSystemProject.load("algokit/scorelib.scd");
FileSystemProject.load("algokit/patterns.scd");
FileSystemProject.load("algokit/grid.scd");
	};
)

PatKitDef(\ex5).edit
KitTimeline(\trans, PatKitDef(\ex5)).edit
KitTimeline(\free, PatKitDef(\ex5)).edit
KitTimeline(\trans).clear

(
Ndef(\alarm, { arg freq=400, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * LFSaw.kr(1*~t).range(1,2));
	sig = RLPF.ar(sig, \lpf.kr(500), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play(BusDef(\sendbus0, \audio).index, 2);
);


