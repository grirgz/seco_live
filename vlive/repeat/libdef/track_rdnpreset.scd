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



// END
////////////

(
[\rdn, \rdn2, \rdn3].do { arg name, rdnidx;
	TrackDef(\pdefgrid).childAt(5+rdnidx).source = 8.collect({ arg index;
		var key = "%.%.%".format(\rdnpreset_pdefgrid, rdnidx, index).asSymbol;
		ProtoDef(key, ProtoTemplateDef(\rdnpreset_item)).rdn_(ProtoDef(name));
	})
}
)

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
