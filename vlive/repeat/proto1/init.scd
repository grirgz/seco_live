
(
"htisworks!!".debug;
FileSystemProject(\proto1).open;
);


(
ParamProto.init;
ParamProto.init(true);
FileSystemProject(\proto1).tempo = 60/60;
FileSystemProject(\proto1).defaultQuant = 4;
MKtl(\lp, "novation-launchpad-s").device;

FileSystemProject(\proto1).load("perc.scd");
FileSystemProject(\proto1).load("tracks.scd");
FileSystemProject(\proto1).load("ot1.scd");
FileSystemProject(\proto1).load("ot3.scd");
FileSystemProject(\proto1).edit = { TrackDef(\main).edit };
FileSystemProject(\proto1).activate = { TrackDef(\main).activate };
);

(
~init_quickpad = {
	~lauchpad_playergrid.quickpad = { nil ! 9 } ! 9;
	~lauchpad_playergrid.quickpad[7][0] = {
		TrackDef(\ot).activate;
	};
	~lauchpad_playergrid.quickpad[7][1] = {
		TrackDef(\main).activate;
	};
	~lauchpad_playergrid.quickpad[7][2] = {
		TrackDef(\ot4).activate;
	};

	~lauchpad_playergrid.quickpad[6][0] = {
		{
			FileSystemProject.current.current_trackgrid.edit;
		}.defer
	};

};
~init_quickpad.();

);

(
TrackDef(\main, TrackDef(\playergrid));
TrackDef(\main).childAt(0,0).source = Pdef(\kick);
TrackDef(\main).childAt(1,0).source = Pdef(\snare);
TrackDef(\main).childAt(2,0).source = Pdef(\hat);
TrackDef(\main).childAt(3,0).source = Pdef(\lide);
TrackDef(\main).childAt(4,0).source = Pdef(\hydro);
TrackDef(\main).childAt(4,1).source = Pdef('hydro.1');
TrackDef(\main).childAt(4,2).source = Pdef('hydro.2');
//TrackDef(\main).childAt((0..4)).collect(_.quant_(8));
TrackDef(\main).activate;
);

//TrackDef(\ot).clear
(
	TrackDef(\ot, TrackDef(\playergrid));
	TrackDef(\ot).source = [
		[
			Pdef('otkick'),
		],
		[
			Ndef('fairydrone.rise'),
			Ndef('fairydrone.night'),
			Ndef('fairydrone.digital'),
		],
		[
			Ndef(\crudebass),
		],
		[
			Ndef('kicky'),
		],
		[
			Ndef('alarm.0'),
			Ndef('alarm.1'),
			Ndef('alarm.2'),
			Ndef('alarm.3'),
		],
		[
			Ndef('hatty.0'),
			Ndef('hatty.1'),
			Ndef('hatty.2'),
		],
		[
			Ndef('fasthatty.0'),
			Ndef('fasthatty.1'),
		],
		[
			Ndef('bigbass.0'),
			Ndef('bigbass.high'),
		],
		[
			Pdef(\fakick)
		],
		[
			Pdef(\fasnare)
		],
		[
			Ndef('kickfx.0'),
			Ndef('kickfx.1'),
			Ndef('kickfx.2'),
		],
	];
	TrackDef(\ot).childAt(0).source.do(_.fadeTime_(1));


TrackDef(\ot).activate;

)


// END

GroupDef(\mixer, nil, \addAfter)


Pdef(\hat).isPlaying
Pdef(\hat).get(\out)
Pdef(\hat).set(\out, 82)
Pdef(\hat).set(\out, 0)
TrackDef(\main).childAt(2,0).mixer.inbus
TrackDef(\main).childAt(2,0).mixer.proxy.monitor.isPlaying
TrackDef(\main).childAt(2,0).mixer.proxy.edit
TrackDef(\main).childAt(2,0).mixer.proxy.parentGroup = GroupDef(\mixer, nil, \addAfter)
TrackDef(\main).edit
TrackDef(\main).edit
TrackDef(\ot).childAt(0,0).play
TrackDef(\ot).childAt(0,0).stop
TrackDef(\ot).childAt(0,1).s
TrackDef(\ot).childAt(0,0).source.fadeTime =4
TrackDef(\ot).childAt(0,0).mixer.play

(
Ndef('fairydrone.rise', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = XLine.kr(21,100,20*1);
	env1 = EnvGen.kr(Env([1,21,102,1000,70],[4,4,7.9,0.1]).circle, 1);
	env2 = EnvGen.kr(Env([1,1,2,1],[4,4,4]).circle, 1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	sig = SinOsc.ar(freq / [1,2,4]);
	sig.debug("sig");
	sig = sig / 1.0;
	sig = Pan2.ar(sig.flop, SinOsc.kr(sig.flop.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,1) })).range(-1,1), amp).flop.mean.sum;
});
)

~lp = ~lauchpad_playergrid.new(TrackDef(\ot))
~lp.activate
~lp.quickpad
~lp[\quickpad].asCompileString

(

)
Ndef('kickfx.1').get(\inbus)
BusDef(\sendbus0)

(
FileSystemProject(\proto1).load("tracks.scd");
~init_quickpad.();
TrackDef(\ot).activate;
)


FileSystemDictionary('/home/')[\bucket]
TrackTimeline('/home/bucket')

FileSystemDictionary('/usr/')[\bucket]
TrackTimeline('/usr/bucket')
TrackTimeline('/usr/project1/data/TrackTimeline/bucket')

FileSystemDictionary('/usr/project/data/TrackTimeline')[\bucket]
TrackTimeline('/usr/project1')

a
new: { arg self;
	self = self.deepCopy;

	

	self;
},

TrackDef(\ot).activate;
TrackDef(\main).activate;
TrackDef(\ot).edit;
TrackDef(\main).edit;
Ndef('kickfx.0').edit
Ndef('fairydrone.rise').edit
Ndef('kickfx.0').asParamGroup

~trackTimeline.new(\ot, TrackDef(\ot)).edit
~trackTimeline.new(\ot).eventFactory.startRecording
~trackTimeline.new(\ot).eventFactory.stopRecording

MKtl(\lp, "novation-launchpad-s").addHalo(\bla, 3223);
MKtl(\lp, "novation-launchpad-s").getHalo(\bla);

MKtl(\lp).elAt(\bt, 0).action = { arg ...args; args.debug("donne!!!") }
MKtl(\lp).elAt(\bt, \bt_user2).action.value
MKtl(\lp).elAt(\bt)
MKtl(\lp).elAt(\bt, \bt_user2).action = { "kkkk".debug };
MKtl(\lp).elAt(\bt, \bt_mixer).action = { "kkkk".debug };
MKtl(\lp).elAt(\bt, \bt_user1).action = { "kkkk".debug };
MKtl(\lp).elAt(\bt, \bt_session).action = { "kkkk".debug };
MKtl(\lp).elAt(\bt, 3).action = { "kkkk".debug };

TrackDef(\ot).edit
TrackDef(\ot).clear
TrackDef(\ot).childAt(0,0).label
TrackDef(\ot).childAt(9,0).label
TrackDef(\ot).childAt(9,0).source
TrackDef(\ot).childAt(0,0).label
TrackDef(\ot).childAtOffset(0).label
TrackDef(\ot).childAtOffset(0).childAtOffset(0)
TrackDef(\ot).childAtOffset(0).childAt(0).label
TrackDef(\ot).childAtOffset(0).parentTrack.gridOffset.y
TrackDef(\ot).childAtOffset(0).gridPosToAbsPos(0)
TrackDef(\ot).childAtOffset(0)[\gridPosToAbsPos]
TrackDef(\ot).children = nil
TrackDef(\ot).children 
TrackDef(\ot).children 

TrackDef(\ot).gridOffset = Point(1,1)
TrackDef(\ot).gridOffset = Point(0,0)
MKtl(\lp).elAt(\pad, 0, \on).value = 0x0c - 0x3c
MKtl(\lp).elAt(\pad, 0, \on).value = 0x07 - 0x0c
MKtl(\lp).elAt(\pad, 0, \on).value = 4 / 127
MKtl(\lp).elAt(\pad, 0, \on).value = 0-0x0c / 127 
MKtl(\lp).elAt(\pad, 0, \on).value = 60 / 127 
MKtl(\lp).elAt(\pad, 0, \on).value = 15 / 127 
MKtl(\lp).elAt(\pad, 0, \on).value = 60 - 0x0c / 127 
MKtl(\lp).elAt(\pad, 0, \on).value = 15 / 127 

MKtl(\lp).elAt(\pad, 0, \on).value = ~lauchpad_playergrid.colors
~lauchpad_playergrid.colors
MKtl(\lp).elAt(\pad, 0, \on).value = 0x1c 
MKtl(\lp).elAt(\pad, 0, \on).value = 0x8 / 256

PlayerWrapper(Ndef(\kicky)).quant
PlayerWrapper(Pdef(\fakick)).quant
PlayerWrapper(Pdef(\fakick)).wrapper.quant
Ndef('fairydrone.rise').play
Ndef('fairydrone.rise', { SinOsc.ar(400) ! 2 * 0.2 }).play
{ SinOsc.ar(200) ! 2 * 0.1}.play;
TrackDef(\ot).edit
TrackDef(\ot).childAt(0,0).isPlaying
TrackDef(\ot).childAt(0,0).play
TrackDef(\ot).childAt(0,0).stop
TrackDef(\ot).childAt(0,0).source
TrackDef(\ot).childAt(0,0).source.play
TrackDef(\ot).childAt(0,0).source.stop
TrackDef(\ot).childAt(0,0).source.free
TrackDef(\ot).childAt(0).source.do(_.clear)
FileSystemProject(\proto1).load("ot1.scd");
TrackDef(\ot).activate
TrackDef(\ot).source
TrackDef(\main).edit
TrackDef(\main).activate
ParamProto.init(true);
FileSystemProject(\proto1).edit
~trackTimeline.new(\tracks, TrackDef(\main)).edit

FileSystemProject(\proto1).isOpening
FileSystemProject(\proto1).isOpeningxx = 3
FileSystemProject(\proto1).isOpening = false 
FileSystemProject(\proto1).isOpening 
FileSystemProject.paths
FileSystemProject.resolve("~".standardizePath)
FileSystemProject.resolve("proto1")
FileSystemProject.cwd = "proto1"
FileSystemProject.cwd
FileSystemProject.defaultProject
FileSystemProject.load("init.scd")
FileSystemProject.addPath("~/")
PathName("/").exists
PathName("~").isAbsolutePath
PathName("~".standardizePath).isFile
PathName("~".standardizePath).isFolder
PathName("~".standardizePath).isAbsolutePath
PathName("~").isFolder

"~/".standardizePath
FileSystemProject

'/home'.addHalo(\isLoading, true)

FileSystemProject(\proto1).load("perc.scd");
"/home/ggz/code/sc/seco/vlive/repeat/proto1/perc.scd".load;
