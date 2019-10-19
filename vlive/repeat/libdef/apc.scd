(
ProtoDef(\apc40, (
	new: { arg self, grid;
		self = self.deepCopy;
	
		self.grid = grid;
		//~lazy_property.(self, \quickpad, { { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 ) });
		//self.clearAll;
		//if(self.ktl.device.notNil) {
			//self.ktl.sendSpecialMessage(\enableFlashMode);
		//};
	
		self;
	},

	shiftModifier: false,

	clearAll: { arg self;
		//self.ktl.sendSpecialMessage(\clearAll);
		//self.ktl.sendSpecialMessage(\enableFlashMode);
	},

	quickpad: { arg self;
		var name = \quickpad;
		self['property_'+++name] ?? {
			self['property_'+++name] = { { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 ) };
			self['property_'+++name]
		}
	},

	quickpad_: { arg self, val;
		var name = \quickpad;
		self['property_'+++name] = val
	},

	colors: (
			red: 120,
			red2: 121,
			dimred: 121,
			green: 122,
			green2: 123,
			dimgreen: 123,
			yellow: 124,
			orange: 125,
			amber: 126,
			off: 0, 
	),

	color_modes: (
		normal: 0,
		blink: 13,
	),

	gridsize: Point(8,5),

	gridOffset_: { arg self, val;
		self.grid.gridOffset = val;
		self.render_grid;
	},

	gridOffset: { arg self;
		self.grid.gridOffset;
	},

	ktl: { 
		MKtl(\apc, "akai-apc40mkii");
	},

	padAt: { arg self, pos;
		//pos.debug("padAt");
		//self.ktl.elAt(\pad, pos.x+( pos.y*self.gridsize.x ));
		self.ktl.elAt(\bt, \clip, pos.y, pos.x);
	},

	setColorAt: { arg self, pos, color, mode;
		mode = mode ? 0;
		//[pos, color, mode].debug("setColorAt");
		self.ktl.elAt(\bt, \clipColor, pos.y, pos.x, mode).value = color/127;
	},

	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var child = self.childAtOffset(pos);
		if(child.isNil or: {child.isEmpty == true}) {
			color = \off
		} {
			//[isPlaying, child.isPlaying].debug("render_cell: is, chiisp");
			isPlaying = isPlaying ?? { child.isPlaying };
			if(isPlaying) {
				color = \green;
			} {
				if(child.isActive) {
					color = \red;
				} {
					color = \yellow;
				}
			};
		};
		color = self.colors[color];
		self.setColorAt(pos, color, mode);
	},

	render_linebutton: { arg self, idx;
		var clip = self.grid.linePlayerAt(idx);
		if(clip.isPlaying) {
			self.ktl.elAt(\bt, \clipS, idx).value = self.colors.green;
		} {
			self.ktl.elAt(\bt, \clipS, idx).value = self.colors.off;
		};
	},

	render_grid: { arg self;
		self.gridsize.x.do { arg x;
			self.gridsize.y.do { arg y;
				var pos = Point(x, y);
				self.render_cell(pos);
				self.listenAt(pos);
			}
		};
		self.gridsize.y.do { arg x;
			self.render_linebutton(x)
		};
		self.makeListeners;
	},

	refresh: { arg self;
		self.render_grid;
	},

	controllers: { arg self;
		var k = self.ktl.getHalo(\controllers);
		if(k.isNil) {
			k = { nil ! ( self.gridsize.y + 1 )} ! ( self.gridsize.x + 1 );
			self.ktl.addHalo(\controllers, k)
		};
		k
	},

	controllers_dict: { arg self;
		var k = self.ktl.getHalo(\controllers_dict);
		if(k.isNil) {
			k = IdentityDictionary.new;
			self.ktl.addHalo(\controllers_dict, k)
		};
		k
	},

	listenAt: { arg self, pos;
		var player = PlayerWrapper(self.childAtOffset(pos));
		if(self.controllers[pos.x][pos.y].notNil) {
			self.controllers[pos.x][pos.y].remove;
		};
		self.controllers[pos.x][pos.y] = player.makeListener({ arg me, msg, args;
			//{
			//[msg, args].debug("listenat!!");
				self.render_cell(pos, msg == \play, self.color_modes.blink);
				player.doWithQuant {
					self.render_cell(pos);
				};
			//}.defer(1)
		});
	},

	makeListeners: { arg self;
		if(self.controllers_dict[\gridOffset].notNil) {
			self.controllers_dict[\gridOffset].remove;
		};
		self.controllers_dict[\gridOffset] = SimpleController(self.grid).put(\gridOffset, {
			self.render_grid;
		});
	},

	mapParam: { arg self, ktlpath, param;
		[ktlpath, param].debug("mapParam");
		if(param.isNil) {
			self.ktl.elAt(*ktlpath).action = { arg me; };
			self.ktl.elAt(*ktlpath).value = 0;
		} {
			self.ktl.elAt(*ktlpath).action = { arg me;
				param.normSet(me.value)
			};
			self.ktl.elAt(*ktlpath).value = param.normGet;
		};
	},

	childAtOffset: { arg self, point;
		self.grid.childAtOffset(point);
	},

	activate: { arg self, grid;
		var move_in_grid;
		if(grid.notNil) {
			self.grid = grid;
		};
		if(FileSystemProject.current.isNil) {
			FileSystemProject.current = ();
		};
		FileSystemProject.current.current_trackgrid = { self.grid };
		//self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			//self.edit_mode = ( el.value != 0 );
			//self.edit_mode.debug("edit mode!");
		//};
		//self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			//self.modifier_mixer = ( el.value != 0 );
			//self.modifier_mixer.debug("mixer mode!");
		//};

		self.ktl.sendSpecialMessage(\setLiveMode);


		self.ktl.elAt(\bt, \clip).do { arg row, rowidx;
			row.do { arg pad, colidx;

				pad.elAt(\on).action = {
					var point = Point(colidx, rowidx);
					point.debug("pad down");
					if(self.shiftModifier == true) {
						{
							self.childAtOffset(point).edit;
							self.render_cell(point);
						}.defer;
					} {
						if(self.modifier_mixer == true) {
							point.debug("what ?");
							self.quickpad[point.x][point.y].debug("2what ?");
							self.quickpad[point.x][point.y].value(self, point);
							self.quickpad[point.x][point.y].debug("end what ?");
						} {
							var node = self.childAtOffset(point);
							if(node.playMode == \gate) {
								point.debug("pad gate play");
								PlayerWrapper(node).play;
							} {
								if(node.playMode == \reset) {
									point.debug("pad reset play");
									node.resetPlay;
								} {
									point.debug("pad toggle play");
									PlayerWrapper(node).togglePlay;
								}
							}
						};
					}
				};
				pad.elAt(\off).action = {
					var point = Point(colidx, rowidx);
					var node = self.childAtOffset(point);
					if(node.playMode == \gate) {
						point.debug("pad gate stop");
						PlayerWrapper(node).stop;
					} {
						// NOOP
					}
				};
			};
		};
		self.ktl.elAt(\bt, \scene).do { arg pad, idx;
			idx = 4-idx;
			pad.elAt(0).action = {
				PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)).togglePlay;
			};
		};
		self.ktl.elAt(\bt, \clipS).do { arg pad, idx;
			idx = 7-idx;
			pad.elAt(0).action = {
				PlayerWrapper(self.grid.childAtOffset(idx)).stop;
			};
		};

		self.map_quant_chooser;


		self.ktl.elAt(\bt, \flat, \shift, \on).action =  { arg me;
			"kjkjk".debug;
			self.shiftModifier = true;
		};
		self.ktl.elAt(\bt, \flat, \shift, \off).action = { arg me;
			"aaakjkjk".debug;
			self.shiftModifier = false;
		};

		self.ktl.elAt(\bt, \master, \on).action = { arg me;
			if(self.shiftModifier) {
				{
				ProtoDef(\simpleMixer).edit
				}.defer;
			}{
				~master.()
			};
			self.render_grid;
		};

		self.ktl.elAt(\bt, \stopAll, \on).action = { arg me;
			if(self.shiftModifier) {
				//{
				//ProtoDef(\simpleMixer).edit
				//}.defer;
			}{
				CmdPeriod.run;
			};
			self.render_grid;
		};

		// debug
		//self.ktl.elAt(\bt, 0).action = { self.render_grid; "refresh!!!!".debug };
		move_in_grid = { arg el, offset;
			el.value.debug("drole!!");
			if(el.value == 0) {

			} {
				if(self.shiftModifier) {
					offset = offset * Point(8,5);
				};
				self.gridOffset = self.gridOffset + offset;
			}
		};
		self.ktl.elAt(\bt, \bank, \up,\on).action = { arg el; move_in_grid.(el, Point(0,-1)) }; // down
		self.ktl.elAt(\bt, \bank, \down,\on).action = { arg el; move_in_grid.(el, Point(0,1)) }; // up
		self.ktl.elAt(\bt, \bank, \left,\on).action = { arg el; move_in_grid.(el, Point(-1,0)) }; // left
		self.ktl.elAt(\bt, \bank, \right,\on).action = { arg el; move_in_grid.(el, Point(1,0)) }; // right
		self.ktl.elAt(\bt, \flat, \metronome).mapPlayer(PlayerWrapper(Pdef(\metronome)));

		//self.clearAll;

		self.activate_bank_selector;
		self.activate_simplemixer;
		self.map_rdn;
		if(self.grid.notNil) {
			self.render_grid;
		}
	},

	///// custom

	clear_flats: { arg self;
		self.bank_names.do { arg name;
			self.ktl.elAt(\bt, \flat, name, \on).value=0;
		}
	},

	bank_names:[ \device_left, \device_right, \bank_left, \bank_right ],
	bank_actions: IdentityDictionary.new,

	activate_bank_selector: { arg self;
		self.bank_names.do { arg name, idx;
			self.ktl.elAt(\bt, \flat, name, \on).action = {
				self.clear_flats;
				self.ktl.elAt(\bt, \flat, name, \on).value=1;
				self.bank_actions[idx].(self, idx);
				self.map_simplemixer_send(idx);
			};
		}
	},

	map_rdn_to_bank: { arg self, bankidx, rdnkey, arglist;
		self.bank_actions[bankidx] = {
			if(self.shiftModifier) {
				{
				ProtoDef(rdnkey).edit;
				}.defer;
			} {
				arglist.collect({ arg param, idx;
					param = case(
						{ param.isKindOf(Symbol) }, {
							Param(ProtoDef(rdnkey).proxy, param);
						},
						{ param.isSequenceableCollection }, {
							Param(ProtoDef(rdnkey).proxy, *param);
						}, {
							param;
						}
					);
					self.mapParam([ \kn, \d, idx ], param);
				})
			}
		};
		
	},

	map_rdn: { arg self;
		self.bank_actions[0] = {
			if(self.shiftModifier) {
				{
				ProtoDef(\rdn).edit;
				}.defer;
			} {
				[
					Param(Ndef(\rdn), \delay),
					Param(Ndef(\rdn), \delay2),
					nil,
					Param(Ndef(\rdn), \fb),

					Param(Ndef(\rdn), \distamp),
					nil,
					nil,
					Param(Ndef(\rdn), \gain),
				].collect({ arg param, idx;
					self.mapParam([ \kn, \d, idx ], param);
				})
			}
		};
		self.bank_actions[1] = {
			if(self.shiftModifier) {
				{
				ProtoDef(\rdn2).edit;
				}.defer;
			} {
				[
					Param(Ndef(\rdn2), \delay),
					Param(Ndef(\rdn2), \delay2),
					Param(Ndef(\rdn2), \delay3),
					Param(Ndef(\rdn2), \fb),

					Param(Ndef(\rdn2), \distamp),
					Param(Ndef(\rdn2), \distamp2),
					Param(Ndef(\rdn2), \distamp3),
					Param(Ndef(\rdn2), \gain),
				].collect({ arg param, idx;
					self.mapParam([ \kn, \d, idx ], param); 
				});
			};
		};
	},

	map_quant_chooser: { arg self;
		self.quant_list = [0, 8, 4, 2,  1, 1/4, 1/8, 1/16];
		8.do { arg idx;
			var iidx = 7-idx;
			self.ktl.elAt(\bt, \selection, idx, 0).action = { arg me;
				if(self.shiftModifier == true) {
					self.quant_list[iidx].debug("set quant to");
					Pdef.defaultQuant = self.quant_list[iidx];
				} {
					self.grid.childAtOffset(iidx).play;
				}
			};
		}
	},

	map_simplemixer_send: { arg self, send=0;
		var mixer = ProtoDef(\simpleMixer);
		8.do { arg idx;
			self.mapParam([\kn, \t, idx], mixer.tracks[idx].asParam(\send+++send));
		}
	},
	map_simplemixer_sends: { arg self...args; self.map_simplemixer_send(*args) },

	map_simplemixer_faders: { arg self;
		var mixer = ProtoDef(\simpleMixer);
		8.do { arg idx;
			self.mapParam([\sl, 0, idx], mixer.tracks[idx].asParam(\postfader));
		}
	},

	map_track_mixer_faders: { arg self;
		8.do { arg idx;
			self.mapParam([\sl, 0, idx], self.grid.childAt(idx).mixer.asParam(\postfader));
		}
	},

	map_track_mixer_sends: { arg self, send=0;
		8.do { arg idx;
			self.mapParam([\kn, \t, idx], self.grid.childAt(idx).mixer.asParam(\send+++send));
		}
	},

	activate_simplemixer: { arg self;
		self.map_simplemixer_send;
		self.map_simplemixer_faders;
	},

));

);

// END

ProtoDef(\apc40).activate(TrackDef(\mygrid)); // debug
ProtoDef(\apc40).activate; // debug
ProtoDef(\apc40).ktl.elAt(\bt, \flat)



/////////////

MKtl.find
""
Modality	
MKtlDesc.loadDescs; 
k = MKtl(\apc, "akai-apc40mkii");
k.desc.reload
k.reload
k.rebuild
k.free
k.postElements
k.elAt(\bt).postElements
k.elAt(\bt, \clipColor).postElements
k.elAt(\bt, \clipColor, 0,0, 4).postElements
k.elAt(\bt, \bank, \left, \on).action = { "kjkj".postln }
k.elAt(\bt, \bank, \left, \on)
k.elAt(\bt, \left, \on)
k.elAt(\bt, \stopAll)
k.elAt(\bt, \clitra)
k.elAt(\bt, \flat, \bank_left)
k.elAt(\bt, 8, \clitra)
k.elAt(\bt, \clipColorxxx)
k.elAt(\bt, \flat, \shift, \on).action = { "bla".debug }

k.elAt(\bt, \clip, 0,0,\on).action = { "kjkj".postln }
k.elAt(\bt, \clip, 0,0, \on).value = 123/127 // works!
k.elAt(\bt, \clipBlink18, 0,0, \on).value = 121/127 // works!
k.elAt(\bt, \clipColor, 0,0,0).value = 123/127
k.elAt(\bt, \clipColor, 0,0,0).value = 121/127
k.elAt(\bt, \clipColor, 0,0,4).value = 43/127
k.elAt(\bt, \clipColor, 0,0,14).value = 53/127
k.elAt(\bt, \clip, \1, \1, \on).action = { "kjkj".postln; }
k.elAt(\bt, \clip).action = { "kjkj".postln; }
k.elAt(\kn, \d, 0,0).action = { arg ...xx; "==%".format(xx).postln }
k.elAt(\kn, \t, 0)
k.elAt(\kn, \d, 0).action
k.elAt(\sl)
k.postElements;

""
MIDIOut(0).noteOn(0, 0, 43)

// test color transition
k.elAt(\bt, \clipColor, 0,0,0).value = 120/127
k.elAt(\bt, \clipColor, 0,0,14).value = 122/127
k.elAt(\bt, \clipColor, 0,0,0).value = 122/127;
k.elAt(\bt, \clipColor, 0,0,14).value = 120/127;
k.elAt(\bt, \clipColor, 0,0,0).value = 120/127
// i believe the stop transition doesnt work because there is no message from Pdef, but should investigate
//////////////

MIDIdef.noteOn(\bla, { arg ..xx; })
(
MIDIdef.noteOn(\track1, { arg ... args;
	args.postln;
	
});
)
0x41
0x50

k.elAt(\bt, \clip).do { arg pad, idx; [pad, idx].postln; }

////// test


FileSystemProject.load("libdef/tracks.scd")
TrackDef(\testapc, TrackTemplateDef(\playergrid))

ProtoDef(\apc_playergrid).grid = TrackDef(\testapc);
ProtoDef(\apc_playergrid).activate
ProtoDef(\apc_playergrid).map_rdn
ProtoDef(\testapc).edit

TrackDef(\testapc).childAt(0,0).source = Pdef(\kick);
TrackDef(\main).childAt(1,0).source = Pdef(\snare);
TrackDef(\main).childAt(2,0).source = Pdef(\hat);
TrackDef(\main).childAt(3,0).source = Pdef(\lide);
TrackDef(\main).childAt(4,0).source = Pdef(\hydro);
TrackDef(\main).childAt(4,1).source = Pdef('hydro.1');
TrackDef(\main).childAt(4,2).source = Pdef('hydro.2');

		ProtoDef(\simpleMixer).edit

(
Pdef(\kick, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
///////////////// old

(
ProtoDef(\apc40, (

	noteOn: { arg self ...args; // chan, num, val
		MIDIOut(0).noteOn(*args)
	},

	noteOff: { arg self ...args;
		MIDIOut(0).noteOff(*args)
	},

	cc: { arg self ...args;
		MIDIOut(0).control(*args)
	},

	clear_flats: { arg self;
		self.bank_names.do { arg name;
			self.noteOff(0, MIDIMap.controls[name][0]);
		}
	},

	bank_names:[ \device_left, \device_right, \bank_left, \bank_right ],
	bank_actions: IdentityDictionary.new,
	pads_actions: IdentityDictionary.new,

	midimap: { arg self, key, param;
		MIDIMap(key, param, false);
		self.cc(0, MIDIMap.controls[key][0], param.normGet*127);
	},

	activate_bank_selector: { arg self;
		self.bank_names.do { arg name, idx;
			MIDIMap(name, {
				self.clear_flats;
				self.noteOn(0, MIDIMap.controls[name][0]);
				self.bank_actions[idx].(self, idx)
			})
		}
	},

	startControl: { arg self;
		self.activate_bank_selector;
	},

	colors: (
		playing: 120,
		stopped: 121,
	),

	activate_pads: { arg self;
		MIDIdef.noteOn(\apcpad_on, { arg val, num, chan, src;
			var px, py;
			[val, num, chan, src].debug;
			if(num >= 0 and: { num < 48 }) {
				px = num % 8;
				py = ( num / 8 ).trunc;
				self.pads_actions[px][py].(self, num);
				self.noteOn(0, num, self.colors.playing);
			};
		}, nil, nil, ~apc_device_id);
	},

	

	mappad: { arg self, point, proxy;
		self.pads_actions[point.asSymbol] = {
			PlayerWrapper(proxy).play;
		};
		self.noteOn(0, num, self.colors.stopped);
	},

));
)
