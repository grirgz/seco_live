// see also ndefpreset.scd track_rdnpreset.scd and mixerPreset.scd

(
ProtoTemplateDef(\rdnpreset_item, (
	new: { arg self, rdn;
		self = self.copy;
		self.rdn = rdn;
		self.idx = nil; // TODO
		self;
	},

	play: { arg self;
		"play rdnpreset_item".debug;
		self.load;
	},

	isPlaying: { arg self;
		false
	},

	isEmpty: { arg self;
		self.preset.isNil;
	},

	save: { arg self;
		var rdn = self.rdn;
		self.preset = (
			params: rdn.proxy.asParamGroup.collect({ arg param;
				[param.property, param.get]
			}).flat.asEvent,
			code: rdn.code, // actual code
			fxcode: rdn.fxcode, // 4--
			fxdef: rdn.fxdef,
			inbus: rdn.inbus,
		);
		self.changed(\preset, self.idx);
	},

	edit: { arg self;
		// to be able to save by edit shortcut
		self.save;
		true; // return nil to use parent gui
	},

	load: { arg self;
		var pre = self.preset;
		var rdn = self.rdn;
		if(pre.notNil) {
			PlayerWrapper(self.rdn.proxy).doWithQuant({
				pre.params.asAssociations.collect({ arg asso;
					Param(rdn.proxy, asso.key).debug("x");
					Param(rdn.proxy, asso.key).set(asso.value)
				});
			});
			if(pre.code != rdn.code or: { rdn.fxdef != pre.fxdef }) {
				rdn.inbus = pre.inbus;
				rdn.fxcode = pre.fxcode;
				rdn.fxdef = pre.fxdef;
				rdn.rebuild(nil, nil, pre.code);
			}
		}
	},

	erase: { arg self;
		self.preset = nil;
		self.changed(\preset, self.idx);
	},

	presetCompileString: { arg self;
		if(self.preset.notNil) {
			"ProtoDef(%).preset = %;\n".format(self.key.asCompileString, self.preset.asCompileString)
		} {
			""
		}
		
	},

));
);

(
// helper class to install and remove rdnpreset_item cells into a grid
// and a saveAs dialog to save presets into a file
ProtoTemplateDef(\rdnpreset_set, (
	defineRdnGrid: { arg self, rdnkeys, offset=5, gridkey=\pdefgrid;
		self.offset = offset;
		rdnkeys = rdnkeys ? [\rdn, \rdn2, \rdn3];
		self.columns = rdnkeys.collect { arg name, rdnidx;
			TrackDef(gridkey).childAt(offset+rdnidx).source = 8.collect({ arg index;
				var key = "%.%.%".format("rdnpreset_%".format(gridkey).asSymbol, offset+rdnidx, index).asSymbol;
				ProtoDef(key, ProtoTemplateDef(\rdnpreset_item)).rdn_(ProtoDef(name));
			})
		}
	},

	eraseRdnGrid: { arg self, rdnkeys, gridkey=\pdefgrid;
		rdnkeys = rdnkeys ? [\rdn, \rdn2, \rdn3];
		self.columns.collect { arg col, rdnidx;
			col.source.do { arg player;
				player.preset = nil
			};
		}
		
	},

	saveAs: { arg self, filename;
		var folderpath = PathName(filename).pathOnly;
		var folderpathname;
		var saveit = { arg fn;
			File.use(fn.standardizePath, "w", { arg file;
				"saving to %".format(file).debug;
				self.columns.do { arg col;
					col.source.do{ arg player;
						file.write(player.presetCompileString);
						file.write("\n");
					};
					file.write("//\n\n");
				}
			})
		};

		folderpathname = FileSystemProject.resolve(folderpath);
		if(folderpathname.isNil) {
			Dialog.savePanel({ arg mypath;
				//mypath.debug("save panel: path");
				saveit.(mypath);
			},{ })
		} {
			filename = folderpathname.fullPath ++ PathName(filename).fileName;
			WindowLayout({ arg win;
				VLayout (
					StaticText.new.string_("Are you sure you want to save to % ?".format(filename.asCompileString)),
					HLayout(
						nil,
						BasicButton.new.string_("Yes").action_({ 
							saveit.(filename);
							win.close;
						}),
						BasicButton.new.string_("Cancel").action_({
							win.close;
						}),
					)
				)
			})

		}
		
	},
));
ProtoDef(\rdnpreset_set, ProtoTemplateDef(\rdnpreset_set));
);


(
FileSystemProject.loadOnce("libdef/CustomTrackList.scd");
// CustomInstrumentTrack rdnpresets
TrackTemplateDef(\RdnPresetTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\RdnPresetTrackPart) },

	rdn: { arg self;
		ProtoDef(\rdn)
	},

	recorderView: { arg self;
		HLayout (
			Param(Message(self), \recordArmed, XBoolSpec()).asButton("●").maxWidth_(20),
			StaticText.new.string_(self.rdn.key)
		).margins_(0).spacing_(4)
	},

	trackEditor: { arg self;
		WindowDef(( \trackEditor_++self.trackKey ).asSymbol, { arg def, me;
			HLayout (
				StaticText.new.string_("Rdn:"),
				Param(Message( me ), \rdn, ParamNonFloatSpec()).asTextField
			)
		})
	},

	scorePresetCompileString: { arg self;
		"%.rdn = %;\n".format(self.refCompileString, self.rdn.asCompileString)
	},
));
TrackTemplateDef(\RdnPresetTrackPart, 
	(
		parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	).putAll(ProtoTemplateDef(\rdnpreset_item)).putAll((

		new: { arg self, parent, index;
			Log(\Param).debug("RdnPresetTrackPart: new!! % ! %".format(self, self.parent));
			TrackTemplateDef(\CustomInstrumentTrackPart)[\new].(self, parent, index)
		},

		rdn: { arg self;
			self.parentTrack.rdn;
		},

		play: { arg self;
			Log(\Param).debug("RdnPresetTrack: play! % ! %".format(self, self.parent));
			if(self.isEmpty == true) {
				if(self.parentTrack.recordArmed == true) {
					self.startRecordingNewScore;
					self.changed(\PlayerWrapper, \stopped); // else button wait for \playing
				} {
					self.parentTrack.stop;
					self.changed(\PlayerWrapper, \stopped); // else button wait for \playing
				}
			} {
				Log(\Param).debug("loading preset");
				self.load;
				self.changed(\PlayerWrapper, \stopped); // else button wait for \playing
			}
		},

		startRecordingNewScore: { arg self;
			Log(\Param).debug("startRecordingNewScore");
			self.save;
		},

		presetCompileString: { arg self;
			if(self.preset.notNil) {
				"%.preset = %;\n".format(self.refCompileString, self.preset.asCompileString)
			} {
				""
			}
		},
	))
);
TagSpecDef(\CustomTrackTemplate).addUnique(\RdnPresetTrack -> TrackTemplateDef(\RdnPresetTrack));
)

// END
////////////

//// demo
(
FileSystemProject.loadOnce("libdef/pdeftrack.scd");
[\rdn, \rdn2, \rdn3].do { arg name, rdnidx;
	TrackDef(\pdefgrid).childAt(5+rdnidx).source = 8.collect({ arg index;
		var key = "%.%.%".format(\rdnpreset_pdefgrid, rdnidx, index).asSymbol;
		ProtoDef(key, ProtoTemplateDef(\rdnpreset_item)).rdn_(ProtoDef(name));
	})
};

Pdef(\pdefgrid0_0, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([
			Pseq([
				0,2,4,1,
			],8),
			Pseq([
				0,Pwhite(0,7,1),4,1,
			],24),
		],inf),
		\dur, 1/4,
		\amp, 0.1,
		\out, BusDef(\sendbus1, \audio),
	)
);
)

// right click on play to save preset, left to laod it
TrackDef(\pdefgrid).edit

ProtoDef(\FxManager).edit;
ProtoDef(\FxManager).play;

/////////////////////////////////////

// demo RdnPresetTrack

(
Pdef(\pdeftest, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([
			Pseq([
				0,2,4,1,
			],8),
			Pseq([
				0,Pwhite(0,7,1),4,1,
			],24),
		],inf),
		\dur, 1/4,
		\amp, 0.1,
		\out, BusDef(\sendbus1, \audio),
	)
).play;
)


TrackDef(\mycus, TrackTemplateDef(\CustomTrackList));
TrackDef(\mycus).editGrid


///////////////////
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)
FileSystemProject.load("libdef/track_rdnpreset.scd");
TrackDef(\mycus, TrackTemplateDef(\CustomTrackList));
TrackDef(\mycus).editGrid
TrackDef(\mycus).edit
TrackDef(\mycus).clear


TrackDef(\mycus).childAt(0).trackTemplate = TrackTemplateDef(\RdnPresetTrack)
TrackDef(\mycus).childAt(0).recordArmed
TrackDef(\mycus).childAt(2).presetCompileString
TrackDef(\mycus).childAt(2).childAt(0).presetCompileString
TrackDef(\mycus).childAt(0).childAt(0)
TrackDef(\mycus).childAt(1).childAt(0).isPlaying
TrackDef(\mycus).childAt(1).childAt(0).changed(\PlayerWrapper, \stopped)
TrackDef(\mycus).childAt(3,0)[\play].asCompileString
TrackDef(\mycus).childAt(0).isEmpty
TrackDef(\mycus).childAt(0).childAt(0)
TrackDef(\mycus).childAt(0,0).outBus
TrackDef(\mycus).childAt(0,0).proxy.outBus
TrackDef(\mycus).existingChildren
TrackDef(\mycus).children
TrackDef(\mycus).isEmpty
TrackDef(\mycus).linePlayerAt(0).isEmpty
TrackDef(\mycus).linePlayerAt(0)
TrackDef(\mycus).childAt(0).parent.parent
TrackTemplateDef(\CustomInstrumentTrack).isEmpty
1

[].any(_.isNil)


//////////////////////////////////////
TrackDef(\pdefgrid).childAt(5,0).source.save
TrackDef(\pdefgrid).childAt(5,1).source.save
TrackDef(\pdefgrid).childAt(5,0).source.preset
TrackDef(\pdefgrid).childAt(5,0).source.save
TrackDef(\pdefgrid).childAt(5,0).play
TrackDef(\pdefgrid).childAt(5,0).proxy.play
TrackDef(\pdefgrid).childAt(5,0).isEmpty
TrackDef(\pdefgrid).childAt(5,0).proxy.isEmpty
TrackDef(\pdefgrid).childAt(5,0).proxy.target.isEmpty
TrackDef(\pdefgrid).childAt(5,0).proxy.source.isEmpty
TrackDef(\pdefgrid).childAt(5,0)[\isEmpty].asCompileString
TrackDef(\pdefgrid).childAt(5,0)[\play].asCompileString
TrackDef(\pdefgrid).childAt(5,0).isPlaying.
TrackDef(\pdefgrid).childAt(5,0).proxy.isPlaying
TrackDef(\pdefgrid).childAt(5,0).proxy.target.keys
TrackDef(\pdefgrid).childAt(5,0).proxy.target.edit
TrackDef(\pdefgrid).childAt(5,0).proxy.edit
TrackDef(\pdefgrid).childAt(5,0).proxy.wrapper.edit
TrackDef(\pdefgrid).childAt(5,0)[\isPlaying].asCompileString
TrackDef(\pdefgrid).clear
TrackDef(\pdefgrid).

TrackDef(\pdefgrid).childAt(5,1).source.edit
TrackDef(\pdefgrid).childAt(5,1)[\edit].asCompileString

TrackDef(\pdefgrid).childAt(0,0).proxy.target
TrackDef(\pdefgrid).childAt(0,0).isPlaying
TrackDef(\pdefgrid).childAt(0,0).proxy.isEmpty
TrackDef(\pdefgrid).childAt(1,0).source.source


ProtoDef(\rdnpreset1, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn)));
ProtoDef(\rdnpreset2, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn2)));
ProtoDef(\rdnpreset3, ProtoTemplateDef(\rdnpreset).new(ProtoDef(\rdn3)));
