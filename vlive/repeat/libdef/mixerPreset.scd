
/// the goal is to have a trackgrid where each column is an object :
// - mixer (with send)
// - fxManager (with each rdn)
// - playergrid

// l'ideal c'est que les colonnes soient dynamiques, qu'on puisse degrouper ou grouper des parametres a l'envie


(
	ParamProto.init;
	s.boot;
	FileSystemProject.load("libdef/tracks.scd");
	FileSystemProject.load("libdef/simplemixer.scd");
	FileSystemProject.load("libdef/FxManager.scd");

TrackTemplateDef(\MixerPresetClip, ().putAll(TrackTemplateDef(\playerwrapper)).putAll((

	prefix: { arg self;
		self.parentTrack.prefix;
	},

	//isEmpty: { arg self;
		//if(self.source.isKindOf(ProtoClass)) {
			//self.source.isEmpty;
		//} {
			//self.source.source.isNil
		//}
	//},

	//defaultSource: { arg self;
		//Pdef("%_%".format(self.prefix, self.index).asSymbol)
	//},

	source: { arg self;
		self.parentTrack.target
	},

	takeSnapshot: { arg self;
		var mixer = self.source;
		var str = mixer.presetCompileString;
		self.snapshot = str;
		self.changed(\content);
	},

	eraseSnapshot: { arg self;
		self.snapshot = nil;
		self.changed(\content);
	},

	isEmpty: { arg self;
		self.snapshot.isNil;
	},

	play: { arg self;
		self.parentTrack.activeIndex = self.index;
		if(self.snapshot.notNil) {
			self.snapshot.interpret;
			//self.source.play;
		}
	},

	isPlaying: { arg self;
		var mixer = self.source;
		mixer.notNil and: { mixer.isPlaying == true and: { self.isActive == true and: { self.isEmpty.not } } }; 
	},

	stop: { arg self;
		var mixer = self.source;
		mixer.stop;
	},

	presetCompileString: { arg self;
		"%.childAt(%,%).snapshot = %;".format(self.parentTrack.parentTrack.asCompileString, self.parentTrack.index, self.index, self.snapshot.asCompileString)
		
	},

	edit: { arg self;
		WindowDef(\MixerPresetOverlay, { arg def, model;
			VLayout (
				PlayerWrapper(model).asView,
				Button.new.string_("Take snapshot").action_({
					self.takeSnapshot;
				}),
				Button.new.string_("Erase"),
				nil,
			)
		}).front(self);
	},

)));

TrackTemplateDef(\MixerPresetTrack, ().putAll(TrackTemplateDef(\playertrack)).putAll((
	childClass: { TrackTemplateDef(\MixerPresetClip) },

	new: { arg self, parent, index, target;
		self = self.copy;

		self.selectChild(0);
		self.index = index;
		self.parentTrack = {parent};
		self.target = { target };
		self;
	},

	presetCompileString: { arg self;
		self.children.collect(_.presetCompileString).join("\n\n");
	},

	prefix: { arg self;
		self.parentTrack.prefix+++self.index;
	},
	mixer: nil,

)));

TrackTemplateDef(\MixerPresetGrid, ().putAll(TrackTemplateDef(\playergrid)).putAll((
	childClass: { TrackTemplateDef(\MixerPresetTrack) },

	children: { arg self;
		self[\obj_children] ?? { 

			self[\obj_children] = SparseArray.new;
			//self[\obj_children] = SparseArray[
				//self.childClass.new(self, 0, FileSystemProject.current.mainMixer),
				//self.childClass.new(self, 1, FileSystemProject.current.fxManager),
				//self.childClass.new(self, 2, FileSystemProject.current.mainTrackGrid),
			//];
			self[\obj_children];
		};
	},

	presetCompileString: { arg self;
		self.children.collect(_.presetCompileString).join("\n\n\n");
	},

	presetCompileStringSavePath_: { arg self, val;
		self[\presetCompileStringSavePath] = val;
	},

	prefix: { arg self;
		self.key;
	},
	enableMixer:false,
	mixer:nil,

)));

ProtoDef(\GridPresetWrapper, (
	new: { arg self, grid;
		self = self.deepCopy;
	
		self.grid = { grid };
	
		self;
	},

	presetCompileString: { arg self;
		self.grid.children.collect({ arg child, colidx;
			//child.index -> child.activeIndex;
			if(child.isPlaying) {
				"%.childAt(%,%).play;".format(self.grid.asCompileString, colidx, child.activeIndex)
			} {
				"%.childAt(%).stop;".format(self.grid.asCompileString, colidx)
			}
		}).join("\n")
	},

));

TrackDef(\MixerPresetGrid, TrackTemplateDef(\MixerPresetGrid));
TrackDef(\MixerPresetGrid).childAt(0).target = { ProtoDef(\simpleMixer) };
TrackDef(\MixerPresetGrid).childAt(1).target = { ProtoDef(\GridPresetWrapper).new(TrackDef(\xxx)) };
TrackDef(\MixerPresetGrid).childAt(2).target = { ProtoDef(\FxManager) };
)
TrackDef(\MixerPresetGrid).clear; TrackTemplateDef(\MixerPresetGrid).clear; TrackTemplateDef(\MixerPresetClip).clear;
ProtoDef(\FxManager).edit
	"caplib.scd".loadRelative;
	FileSystemProject.load("capsule/lib.scd")
// END

// ==================================================
~a = SparseArray[\a]
~a[10]=123

TrackDef(\xxx, TrackTemplateDef(\playergrid))
TrackDef(\xxx).edit
TrackDef(\xxx).asCompileString
(
TrackDef(\xxx).source = [
	[
		Pdef(\zed1, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		)),
		Pdef(\zed2, Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
		Pdef(\zed3, Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
		Pdef(\zed4, Pbind(
			\instrument, \default,
			\freq, 500,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		)),
	]
];
)
TrackDef(\MixerPresetGrid).edit
TrackDef(\MixerPresetGrid).presetCompileString
TrackDef(\MixerPresetGrid).savePresetCompileString("blaxxx.scd")
TrackDef(\MixerPresetGrid).presetCompileStringSavePath = "blaxxx.scd";
TrackDef(\MixerPresetGrid).mixer
TrackDef(\MixerPresetGrid).children
TrackDef(\MixerPresetGrid).edit
TrackDef(\MixerPresetGrid).e
TrackDef(\MixerPresetGrid).source = []
TrackDef(\MixerPresetGrid).source
TrackDef(\MixerPresetGrid).childAt(0).target = { FileSystemProject.current.mainMixer }
TrackDef(\MixerPresetGrid).childAt(0).target = { ProtoDef(\simpleMixer) }
TrackDef(\MixerPresetGrid).childAt(0,0).isActive
PlayerWrapper(TrackDef(\MixerPresetGrid).childAt(0,0)).isActive
TrackDef(\MixerPresetGrid).childAt(0,0).edit
TrackDef(\MixerPresetGrid).childAt(4,5).edit
TrackDef(\MixerPresetGrid).childAt(0,0).snapshot.action
TrackDef(\MixerPresetGrid).childAt(0,0).snapshot.compileString
TrackDef(\MixerPresetGrid).childAt(1,0).snapshot.compileString

FileSystemProject.current = FileSystemProject('repeat/simpleProject')
FileSystemProject.default
FileSystemProject.current.mainTrackGrid.presetCompileString

(
TrackDef(\testpremix, TrackDef(\playergrid)).source = [
	//8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefParamGroupDef).new(Ndef(\testpre))); },
	8.collect { arg x; ProtoDef(\myndef+++x, ProtoDef(\NdefPreset).new(Ndef(\testpre))); },

]
)



FileSystemProject.current.mainMixer.presetCompileString.editorInsert
FileSystemProject.current.mainMixer.clearAll
FileSystemProject.current.mainMixer.edit
(
//ProtoDef('simpleMixer').trackCount = 10;

ProtoDef('simpleMixer').tracks[0].set('inbus', BusDef(\mixer0));
ProtoDef('simpleMixer').tracks[0].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[0].set('prefader', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[0].set('send0', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[0].set('send1', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[0].set('send2', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[0].set('send3', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[0].set('send4', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[0].set('send5', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[0].set('send6', 0);
ProtoDef('simpleMixer').tracks[0].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[0].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[0].set('send7', 0);
ProtoDef('simpleMixer').tracks[0].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[0].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[0].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[0].set('postfader', 0.0);
//ProtoDef('simpleMixer').tracks[0].outBus = 0;

ProtoDef('simpleMixer').tracks[1].set('inbus', BusDef(\mixer1));
ProtoDef('simpleMixer').tracks[1].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[1].set('prefader', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[1].set('send0', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[1].set('send1', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[1].set('send2', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[1].set('send3', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[1].set('send4', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[1].set('send5', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[1].set('send6', 0);
ProtoDef('simpleMixer').tracks[1].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[1].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[1].set('send7', 0);
ProtoDef('simpleMixer').tracks[1].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[1].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[1].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[1].set('postfader', 0.0);
//ProtoDef('simpleMixer').tracks[1].outBus = 0;

ProtoDef('simpleMixer').tracks[2].set('inbus', BusDef(\mixer2));
ProtoDef('simpleMixer').tracks[2].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[2].set('prefader', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[2].set('send0', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[2].set('send1', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[2].set('send2', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[2].set('send3', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[2].set('send4', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[2].set('send5', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[2].set('send6', 0);
ProtoDef('simpleMixer').tracks[2].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[2].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[2].set('send7', 0);
ProtoDef('simpleMixer').tracks[2].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[2].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[2].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[2].set('postfader', 0.0);
//ProtoDef('simpleMixer').tracks[2].outBus = 0;

ProtoDef('simpleMixer').tracks[3].set('inbus', BusDef(\mixer3));
ProtoDef('simpleMixer').tracks[3].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[3].set('prefader', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[3].set('send0', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[3].set('send1', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[3].set('send2', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[3].set('send3', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[3].set('send4', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[3].set('send5', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[3].set('send6', 0);
ProtoDef('simpleMixer').tracks[3].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[3].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[3].set('send7', 0);
ProtoDef('simpleMixer').tracks[3].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[3].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[3].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[3].set('postfader', 0.0);
//ProtoDef('simpleMixer').tracks[3].outBus = 0;

ProtoDef('simpleMixer').tracks[4].set('inbus', BusDef(\mixer4));
ProtoDef('simpleMixer').tracks[4].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[4].set('prefader', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[4].set('send0', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[4].set('send1', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[4].set('send2', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[4].set('send3', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[4].set('send4', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[4].set('send5', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[4].set('send6', 0);
ProtoDef('simpleMixer').tracks[4].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[4].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[4].set('send7', 0);
ProtoDef('simpleMixer').tracks[4].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[4].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[4].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[4].set('postfader', 0);
//ProtoDef('simpleMixer').tracks[4].outBus = 0;

ProtoDef('simpleMixer').tracks[5].set('inbus', BusDef(\mixer5));
ProtoDef('simpleMixer').tracks[5].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[5].set('prefader', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[5].set('send0', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[5].set('send1', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[5].set('send2', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[5].set('send3', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[5].set('send4', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[5].set('send5', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[5].set('send6', 0);
ProtoDef('simpleMixer').tracks[5].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[5].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[5].set('send7', 0);
ProtoDef('simpleMixer').tracks[5].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[5].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[5].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[5].set('postfader', 0);
ProtoDef('simpleMixer').tracks[5].outBus = 0;

ProtoDef('simpleMixer').tracks[6].set('inbus', BusDef(\mixer6));
ProtoDef('simpleMixer').tracks[6].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[6].set('prefader', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[6].set('send0', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[6].set('send1', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[6].set('send2', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[6].set('send3', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[6].set('send4', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[6].set('send5', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[6].set('send6', 0);
ProtoDef('simpleMixer').tracks[6].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[6].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[6].set('send7', 0);
ProtoDef('simpleMixer').tracks[6].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[6].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[6].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[6].set('postfader', 0);
ProtoDef('simpleMixer').tracks[6].outBus = 0;

ProtoDef('simpleMixer').tracks[7].set('inbus', BusDef(\mixer7));
ProtoDef('simpleMixer').tracks[7].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[7].set('prefader', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[7].set('send0', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[7].set('send1', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[7].set('send2', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[7].set('send3', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[7].set('send4', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[7].set('send5', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[7].set('send6', 0);
ProtoDef('simpleMixer').tracks[7].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[7].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[7].set('send7', 0);
ProtoDef('simpleMixer').tracks[7].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[7].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[7].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[7].set('postfader', -28.695723486512);
ProtoDef('simpleMixer').tracks[7].outBus = 0;

ProtoDef('simpleMixer').tracks[8].set('inbus', BusDef(\mixer8));
ProtoDef('simpleMixer').tracks[8].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[8].set('prefader', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[8].set('send0', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[8].set('send1', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[8].set('send2', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[8].set('send3', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[8].set('send4', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[8].set('send5', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[8].set('send6', 0);
ProtoDef('simpleMixer').tracks[8].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[8].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[8].set('send7', 0);
ProtoDef('simpleMixer').tracks[8].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[8].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[8].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[8].set('postfader', -29.586779274958);
ProtoDef('simpleMixer').tracks[8].outBus = 0;

ProtoDef('simpleMixer').tracks[9].set('inbus', BusDef(\mixer9));
ProtoDef('simpleMixer').tracks[9].set('wet1000', 1.0);
ProtoDef('simpleMixer').tracks[9].set('prefader', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1100', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus0', BusDef(\sendbus0));
ProtoDef('simpleMixer').tracks[9].set('send0', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1101', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus1', BusDef(\sendbus1));
ProtoDef('simpleMixer').tracks[9].set('send1', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1102', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus2', BusDef(\sendbus2));
ProtoDef('simpleMixer').tracks[9].set('send2', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1103', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus3', BusDef(\sendbus3));
ProtoDef('simpleMixer').tracks[9].set('send3', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1104', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus4', BusDef(\sendbus4));
ProtoDef('simpleMixer').tracks[9].set('send4', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1105', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus5', BusDef(\sendbus5));
ProtoDef('simpleMixer').tracks[9].set('send5', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1106', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus6', BusDef(\sendbus6));
ProtoDef('simpleMixer').tracks[9].set('send6', 0);
ProtoDef('simpleMixer').tracks[9].set('wet1107', 1.0);
ProtoDef('simpleMixer').tracks[9].set('sendbus7', BusDef(\sendbus7));
ProtoDef('simpleMixer').tracks[9].set('send7', 0);
ProtoDef('simpleMixer').tracks[9].set('wet2001', 1.0);
ProtoDef('simpleMixer').tracks[9].set('postdelay', 0);
ProtoDef('simpleMixer').tracks[9].set('wet3000', 1.0);
ProtoDef('simpleMixer').tracks[9].set('postfader', 0);
ProtoDef('simpleMixer').tracks[9].outBus = 0;
);

