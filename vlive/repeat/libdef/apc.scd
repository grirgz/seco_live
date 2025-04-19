// faut que je revois le truc depuis zero, car je doit utiliser les listener pour que ca fonctionne bien
// et aussi gerer les \userStopped, etc
// et adapter modality pour gerer tout ca
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
	//displayMode: \pan,

	clearAll: { arg self;
		//self.ktl.sendSpecialMessage(\clearAll);
		//self.ktl.sendSpecialMessage(\enableFlashMode);
	},


	colors: ProtoClass((
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
	)),

	color_modes: (
		//normal: 0,
		//blink: 13,
		normal: \normal,
		blink: \blink,
	),

	gridsize: Point(8,5),

	gridOffset_: { arg self, val;
		self.grid.gridOffset = val;
		//self.render_grid;
	},

	gridOffset: { arg self;
		self.grid.gridOffset;
	},

	ktl: { 
		MKtl(\apc, "akai-apc40mkii");
	},

	padAt: { arg self, pos;
		pos.debug("padAt");
		//self.ktl.elAt(\pad, pos.x+( pos.y*self.gridsize.x ));
		self.ktl.elAt(\bt, \clip, pos.y, pos.x);
	},

	setColorAt: { arg self, pos, color, mode;
		mode = mode ? 0;
		[pos, color, mode].debug("setColorAt");
		self.ktl.elAt(\bt, \clipColor, pos.y, pos.x, mode).value = color/127; // disabled new desc
	},

	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var child = self.childAtOffset(pos);
		pos.debug("render_cell");
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
		0;
	},

	render_scene_button: { arg self, idx;
		var clip = self.grid.linePlayerAtOffset(idx);
		//var ridx = 4 - idx; // MKtl mapping is reversed
		//"rlb1".debug;
		if(clip.isEmpty.not) {
			//"rlb2".debug;
			if(clip.isPlaying) {
				self.ktl.elAt(\bt, \scene, idx, \on).value = self.colors.green/127;
			} {
				self.ktl.elAt(\bt, \scene, idx, \on).value = self.colors.red/127;
			}
		} {
			//"rlb3".debug;
			self.ktl.elAt(\bt, \scene, idx, \on).value = self.colors.off;
		};
		//"rlb4".debug;
	},

	render_scene_buttons: { arg self;
		self.gridsize.y.do { arg idx;
			self.render_scene_button(idx)
		};
	},

	render_trackbutton: { arg self, idx;
		var clip = self.grid.childAtOffset(idx);
		idx.debug("render_trackbutton");
		//"rtb1".debug;
		if(clip.isPlaying) {
			//"rtb2".debug;
			self.ktl.elAt(\bt, \clipS, idx, \on).value = self.colors.green/127;
		} {
			//"rtb3".debug;
			self.ktl.elAt(\bt, \clipS, idx, \on).value = self.colors.off.debug("color off");
		};
		//"rtb4".debug;
	},

	render_track_selection_button: { arg self, idx;
		// only one color available in [ \bt,\selection ]
		var oldidx = self.selectedTrackIndex ? 0;
		switch(self.displayMode,
			\pan, { 
				self.selectedTrackIndex = self.grid.activeIndex ? 0;
			},
			\sends, { 
				self.selectedTrackIndex = self.selected_send_idx ? 0;
			},
			\user, { 
				if(self.selectedUserPanelIndex.isNil) {
					self.selectedUserPanelIndex = 0;
				};
				self.selectedTrackIndex = self.selectedUserPanelIndex;
			},
		);
		if(idx == self.selectedTrackIndex) {
			self.ktl.elAt(\bt, \selection, idx, \on).value = self.colors.green/127;
			if(oldidx != idx) {
				self.ktl.elAt(\bt, \selection, oldidx, \on).value = self.colors.off.debug("color off");
			};
		} {
			self.ktl.elAt(\bt, \selection, idx, \on).value = self.colors.off.debug("color off");
		};
	},

	render_grid: { arg self;
		"render_grid a".debug;
		self.gridsize.x.do { arg x;
			self.gridsize.y.do { arg y;
				var pos = Point(x, y);
				self.render_cell(pos);
				self.listenAt(pos);
			}
		};
		"b".debug;
		self.map_scene_buttons;
		self.map_clipStop_buttons;
		self.render_displayMode;

		self.gridsize.x.do { arg x;
			x.debug("render_grid, render_trackbutton");
			self.render_trackbutton(x);
			self.render_track_selection_button(x);
		};
		//"c".debug;
		self.makeListeners;
		//"d".debug;
		self.gridsize.x.do { arg idx;
			self.render_mixer_button(\muteMode, idx, true);
			self.render_mixer_button(\soloMode, idx);
		};
		"render_grid end".debug;
	},

	render_mixer_button: { arg self, key, idx, reverse=false;
		var kind = switch(key,
			\muteMode, { \activ },
			\soloMode, { \solo },
		);
		var mix = self.grid.childAtOffset(idx).mixer;
		//mix.asParam(\muteMode).normGet.debug("wuuuutt");
		if(mix.notNil) {
			if(reverse == true) {
				self.ktl.elAt(*[\bt, \track, kind, idx,\on]).value = ( 1 - mix.asParam(key).normGet );
			} {
				self.ktl.elAt(*[\bt, \track, kind, idx,\on]).value = mix.asParam(key).normGet;
			}
		}
	},

	render_displayMode: { arg self;
		if(self.displayMode.isNil) {
			self.displayMode = \pan;
		};
		[\pan, \sends, \user].do { arg item, idx;
			self.ktl.elAt(\bt, \control, item, \on).value = if(item == self.displayMode) {
				1
			} {
				0
			};
		};
		
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
		pos.debug("listenAt");
		if(self.controllers[pos.x][pos.y].notNil) {
			self.controllers[pos.x][pos.y].remove;
		};
		self.controllers[pos.x][pos.y] = player.makeListener({ arg me, msg, args;
			//{
			[msg, args].debug("listenat!!");
				self.render_cell(pos, msg == \play, self.color_modes.blink);
				player.doWithQuant {
					self.render_cell(pos);
				};
			//}.defer(1)
		});
	},

	listenAtMixerParam: { arg self, key, idx, param, action;
		self.controllers_dict[\mixer] = self.controllers_dict[\mixer] ?? { IdentityDictionary.new };
		self.controllers_dict[\mixer][key] = self.controllers_dict[\mixer][key] ?? { List.newClear(self.gridsize.x) };
		if(self.controllers_dict[\mixer][key][idx].notNil) {
			self.controllers_dict[\mixer][key][idx].remove;
		};
		if(param.notNil) {
			self.controllers_dict[\mixer][key][idx] = param.makeListener({ arg me, msg, args;
				//{
				//[msg, args].debug("listenat!!");
				action.()
				//}.defer(1)
			});
		}
	},

	makeListeners: { arg self;
		if(self.controllers_dict[\gridOffset].notNil) {
			self.controllers_dict[\gridOffset].remove;
		};
		self.controllers_dict[\gridOffset] = SimpleController(self.grid).put(\gridOffset, {
			//self.map_track_mixer_mute;
			self.activate_trackmixer;
			self.render_grid;
		});
	},

	mapParam: { arg self, ktlpath, param, toggleMode;
		[ktlpath, param].debug("mapParam");
		self.ktl.elAt(*ktlpath).mapParam(param, toggleMode);
		//self.ktl.elAt(*ktlpath).value = param.normGet;
		//if(param.isNil) {
			//self.ktl.elAt(*ktlpath).action = { arg me; };
			//self.ktl.elAt(*ktlpath).value = 0;
		//} {
			//self.ktl.elAt(*ktlpath).action = { arg me;
				//param.normSet(me.value)
			//};
			//self.ktl.elAt(*ktlpath).value = param.normGet;
		//};
	},

	unmapParam: { arg self, ktlpath;
		self.mapParam(ktlpath, nil)
	},

	mapToggleButtonParam: { arg self, ktlpath, param;
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
		switch(self.displayMode,
			\pan, { 
				self.grid.childAtOffset(point);
			},
			\sends, { 
				self.grid.childAtOffset(point);
			},
			\user, { 
				var fun;
				self.selectedUserPanelIndex = self.selectedUserPanelIndex ? 0;
				self.userPanels = self.userPanels ?? { nil!self.gridsize.x };
				fun = self.userPanels[self.selectedUserPanelIndex];
				if(fun.notNil) {
					fun.value(self, point);
				} {
					ProtoClass((
						isActive: true,
						isPlaying: false,
						isEmpty: false,
					))
				};
				//self.action_select_track(idx);
			},
		);
	},

	activate: { arg self, grid;
		var move_in_grid;
		if(grid.notNil and: { grid.isEmpty.notNil }) {
			self.grid = grid;
			if(FileSystemProject.current.notNil) {
				FileSystemProject.current.current_trackgrid = { self.grid };
			};
			//self.ktl.elAt(\bt, \bt_user2).action = { arg el;
			//self.edit_mode = ( el.value != 0 );
			//self.edit_mode.debug("edit mode!");
			//};
			//self.ktl.elAt(\bt, \bt_mixer).action = { arg el;
			//self.modifier_mixer = ( el.value != 0 );
			//self.modifier_mixer.debug("mixer mode!");
			//};

			"1--".debug;

			self.ktl.sendSpecialMessage(\abletonLiveMode);

			"2--".debug;


			self.map_clip_buttons;

			"3--".debug;

			self.map_scene_buttons;
			self.map_clipStop_buttons;

			"4--".debug;

			self.map_quant_chooser; // disabled because can't find

			"5--".debug;

			self.ktl.elAt(\bt, \shift, \on).action =  { arg me;
				"kjkjk".debug;
				self.shiftModifier = true;
			};
			self.ktl.elAt(\bt, \shift, \off).action = { arg me;
				"aaakjkjk".debug;
				self.shiftModifier = false;
			};
			self.ktl.elAt(\bt, \bank, \on).action =  { arg me;
				"kjkjk".debug;
				self.bankModifier = true;
			};
			self.ktl.elAt(\bt, \bank, \off).action = { arg me;
				"aaakjkjk".debug;
				self.bankModifier = false;
			};

			"6--".debug;

			self.ktl.elAt(\bt, \master, \on).action = { arg me;
				if(self.shiftModifier) {
					{
						self.grid.edit;
						//ProtoDef(\simpleMixer).edit
					}.defer;
				}{
					~master.()
				};
				self.render_grid;
			};

			"7--".debug;

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

			"9--".debug;
			self.ktl.elAt(\bt, \transport, \play,\on).mapPlayer(PlayerWrapper(self.grid));

			[\pan, \sends, \user].do { arg item, idx;
				var fun;
				self.ktl.elAt(\bt, \control, item, \on).action = {
					self.displayMode = item;
					self.render_displayMode;
					self.render_grid;
					//self.modifier_send = true;
					//self.map_track_mixer_sends(self.selected_send_idx ? 0);
				};
			};

			self.ktl.elAt(\bt, \bankselect, \up,\on).action = { arg el; move_in_grid.(el, Point(0,-1)) }; // down
			self.ktl.elAt(\bt, \bankselect, \down,\on).action = { arg el; move_in_grid.(el, Point(0,1)) }; // up
			self.ktl.elAt(\bt, \bankselect, \left,\on).action = { arg el; move_in_grid.(el, Point(-1,0)) }; // left
			self.ktl.elAt(\bt, \bankselect, \right,\on).action = { arg el; move_in_grid.(el, Point(1,0)) }; // right
			self.ktl.elAt(\bt, \tempo, \metronome).mapPlayer(PlayerWrapper(Pdef(\metronome)));

			//self.clearAll;
			"10--".debug;

			//self.activate_bank_selector; 
			"11--".debug;
			self.activate_trackmixer;
			"12--".debug;
			self.map_rdn;
			"13--".debug;
			if(self.grid.notNil) {
				self.render_grid;
			};
			"14--".debug;
		};
	},

	startControl: { arg self, model;
		self.activate(model);
	},

	///// custom

	map_clip_buttons: { arg self;
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
								PlayerWrapper(node).doWithQuant {
									self.render_scene_buttons;
								}
							}
						}
					}
				};
				pad.elAt(\off).action = {
					var point = Point(colidx, rowidx);
					var node = self.childAtOffset(point);
					if(node.playMode == \gate) {
						point.debug("pad gate stop");
						node.debug("pad gate stop");
						node[\stop].asCompileString.debug("hoo");
						PlayerWrapper(node).stop;
					} {
						// NOOP
					}
				};
			};
		};
	},

	clear_flats: { arg self;
		self.bank_names.do { arg name;
			self.ktl.elAt(\bt, \flat, name, \on).value=0;
		}
	},

	bank_names:[ \devleft, \devright, \bankleft, \bankright ],
	bank_actions: IdentityDictionary.new,

	activate_bank_selector: { arg self;
		self.bank_names.do { arg name, idx;
			self.ktl.elAt(\bt, \device, 0, name, \on).action = {
				self.clear_flats;
				self.ktl.elAt(\bt, \device, 0, name, \on).value=1;
				self.bank_actions[idx].(self, idx);
				//self.map_track_mixer_sends(idx);
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
					self.mapParam([ \kn, \d, 0, idx ], param);
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
					self.mapParam([ \kn, \d, 0, idx ], param);
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
					self.mapParam([ \kn, \d, 0, idx ], param); 
				});
			};
		};
	},

	map_sendMode_fx: { arg self, idx;
		if(idx.notNil and: { idx > 0 }) {
			var fxkey = ProtoDef(\FxManager).fxKeys[idx-1];
			[fxkey.asCompileString, idx, fxkey.asString.contains("rdn")].debug("map_sendMode_fx");
			if(fxkey.asString.contains("rdn")) {
				var proxy = Ndef(fxkey);
				[idx, proxy].debug("mapping sendmode fx");
				[
					Param(proxy, \delay),
					Param(proxy, \delay2),
					Param(proxy, \fb),
					Param(proxy, \distamp),

					Param(proxy, \posthpf),
					Param(proxy, \postlpf),
					nil,
					Param(proxy, \gain),
				].collect({ arg param, idx;
					self.mapParam([ \kn, \d, 0, idx ], param);
				});

				self.ktl.elAt(\bt, \device, 0, \detail, \on).action = {
					{
						ProtoDef(fxkey).edit;
					}.defer;
				};
				self.ktl.elAt(\bt, \device, 0, \devonoff, \on).mapPlayer(PlayerWrapper(ProtoDef(fxkey)));
			} {

			}
		};
			
	},

	map_clipStop_buttons: { arg self;
		self.ktl.elAt(\bt, \clipS).do { arg pad, idx;
			var player = self.grid.childAtOffset(idx);
			//idx = 7-idx;
			pad.elAt(\on).mapPlayer(PlayerWrapper(player), { 
				//{self.render_trackbutton(idx)}.defer(player.quant + 1) 
				"clipS pushed".debug(idx);
				self.render_trackbutton(idx)
			})

			//pad.elAt(0).action = {
			//PlayerWrapper(self.grid.childAtOffset(idx)).stop;
			//};
		};
	},

	map_scene_buttons: { arg self;
		self.ktl.elAt(\bt, \scene).do { arg pad, idx;
			var player;
			//idx = 4-idx;
			player = PlayerWrapper(self.grid.sectionAt(idx + self.gridOffset.y));
			//pad.elAt(\on).mapPlayer(PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)), { self.render_scene_button(idx) }  );
			pad.elAt(\on).action = {
				var res = self.callback_scene_button(idx);
				if(res != false) {
					player.togglePlay;
				};
				self.render_scene_button(idx);
				player.doWithQuant {
					self.render_scene_buttons;
				}
			};
			//pad.elAt(\on).getHalo(\ParamListener) !? _.remove;
			//pad.elAt(\on).addHalo(\ParamListener, player.makeListener({ arg me, msg ...args;
				// do not work because nobody send stopped signal for sections
				//[ idx, msg, args, player, player.isPlaying.asInteger ].debug("map_scene_buttons.mapPlayer listener: receive ************##############");
				//self.render_scene_button(idx);
			//}));
			self.render_scene_button(idx);
			//pad.elAt(0).action = {
				//PlayerWrapper(self.grid.linePlayerAt(idx + self.gridOffset.y)).togglePlay;
				//self.render_scene_button(idx);
			//};
		};
		
	},

	action_select_track: { arg self, idx;
		// or quant chooser
		var oldidx = self.selectedTrackIndex ? 0;
		self.selectedTrackIndex = idx;
		self.render_track_selection_button(idx);
		self.render_track_selection_button(oldidx);
	},

	map_quant_chooser: { arg self;
		self.quant_list = [0, 8, 4, 2,  1, 1/4, 1/8, 1/16];
		8.do { arg idx;
			var iidx = idx;
			self.ktl.elAt(\bt, \selection, idx, 0).action = { arg me;
				self.displayMode.debug("map_quant_chooser: displayMode");
				if(self.shiftModifier == true) {
					self.quant_list[iidx].debug("set quant to");
					Pdef.defaultQuant = self.quant_list[iidx];
				} {
					if(self.bankModifier == true) {
						if(self.gridBank.notNil) {
							var grid = self.gridBank[idx];
							if(grid.notNil) {
								self.activate(grid);
							};
						};
					} {
						self.displayMode.debug("map_quant_chooser: displayMode2");
						switch(self.displayMode,
							\pan, { 
								var oldidx = ( self.grid.activeIndex ? 0 ) - self.gridOffset.x;
								self.grid.activeIndex = self.grid.childAtOffset(iidx).index;
								self.render_track_selection_button(idx);
								//self.action_select_track(idx);
							},
							\sends, { 
								var oldidx = ( self.selected_send_idx ? 0 );
								self.selected_send_idx = idx;
								self.selected_send_idx.debug("map_quant_chooser: selected_send_idx");
								self.map_track_mixer_sends(self.selected_send_idx);
								self.render_track_selection_button(idx);
								//self.action_select_track(idx);
							},
							\user, { 
								self.selectedUserPanelIndex = idx;
								self.selectedUserPanelIndex.debug("map_quant_chooser: selectedUserPanelIndex");
								self.render_track_selection_button(idx);
								self.render_grid;
								//self.action_select_track(idx);
								// TODO
							},
						);
					};
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
	map_simplemixer_sends: { arg self ...args; self.map_simplemixer_send(*args) },

	map_simplemixer_faders: { arg self;
		var mixer = ProtoDef(\simpleMixer);
		8.do { arg idx;
			self.mapParam([\sl, 0, idx], mixer.tracks[idx].asParam(\postfader));
		}
	},

	map_track_mixer_faders: { arg self;
		8.do { arg idx;
			var mix = self.grid.childAtOffset(idx).mixer;
			[idx, mix].debug("map_track_mixer_faders");
			if(mix.notNil) {
				[idx, mix].debug("map_track_mixer_faders notnil");
				self.mapParam([\sl, 0, idx], mix.asParam(\postfader));
			} {
				self.unmapParam([\sl, 0, idx]);
			}
		};
		self.mapParam([\sl, \master], Param(Server.default.volume, \volume));
	},

	map_track_mixer_mute: { arg self;
		8.do { arg idx;
			var mix = self.grid.childAtOffset(idx).mixer;
			[idx, mix].debug("map_track_mixer_mute");
			if(mix.notNil) {
				[idx, mix].debug("map_track_mixer_mute notnil");
				//self.mapParam([\bt, '5', 0, idx,\on], mix.asParam(\muteMode), true);
				//self.mapParam([\bt, '5', 1, idx,\on], mix.asParam(\soloMode), true);
				self.mapParam([\bt, \track, \activ, idx], mix.asParam(\muteMode), true);
				self.mapParam([\bt, \track, \solo, idx], mix.asParam(\soloMode), true);
				self.listenAtMixerParam(\muteMode, idx, mix.asParam(\muteMode), {
					mix.asParam(\muteMode).normGet.debug("wuuuutt");
					//self.ktl.elAt(*[\bt, '5', 0, idx,\on]).value = ( 1 - mix.asParam(\muteMode).normGet );
					self.render_mixer_button(\muteMode, idx, true);
				});
				self.listenAtMixerParam(\soloMode, idx, mix.asParam(\soloMode), {
					//self.ktl.elAt(*[\bt, '5', 1, idx,\on]).value = mix.asParam(\soloMode).normGet;
					self.render_mixer_button(\soloMode, idx);
				});
			} {
				self.unmapParam([\bt, \track, \activ, idx]);
				self.unmapParam([\bt, \track, \solo, idx]);
				self.listenAtMixerParam(\muteMode, idx);
				self.listenAtMixerParam(\soloMode, idx);
			}
		}
	},

	map_track_mixer_sends: { arg self, send=0;
		8.do { arg idx;
			var mix = self.grid.childAtOffset(idx).mixer;
			if(mix.notNil) {
				self.mapParam([\kn, \t, idx], mix.asParam(\send+++send));
			} {
				self.unmapParam([\kn, \t, idx]);
			}
		};
		self.map_sendMode_fx(self.selected_send_idx);
	},

	activate_simplemixer: { arg self;
		self.map_simplemixer_send;
		self.map_simplemixer_faders;
	},

	activate_trackmixer: { arg self;
		self.map_track_mixer_faders;
		self.map_track_mixer_sends;
		self.map_track_mixer_mute;
		
	},

));

///// user panels


ProtoDef(\apc40).userPanels = ProtoDef(\apc40).userPanels ?? { nil ! 8 };
// additional launch grid
ProtoDef(\apc40).userPanels[0] = { arg apc, point;
	var extra = apc.extra_playergrid ?? {
		TrackDef("%_extra".format(apc.grid.trackKey).asSymbol, \PlayerGrid)  
	};
	extra.childAt(point);
};

// quickpad
ProtoDef(\apc40).putAll((
	quickpad: { arg self;
		var name = \quickpad;
		self['property_'+++name] ?? {
			self['property_'+++name] = { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 );
			self['property_'+++name]
		}
	},

	quickpad_: { arg self, val;
		var name = \quickpad;
		self['property_'+++name] = val
	},
));
ProtoDef(\apc40).userPanels[1] = { arg self, point;
	ProtoClass((
		isActive: false,
		isPlaying: false,
		playMode: \gate,
		isEmpty: {
			self.quickpad[point.x][point.y].isNil;
		},
		play: { arg cellself;
			//"play me please".debug;
			//self.quickpad.debug("quickpad");
			//self.quickpad[point.x][point.y].asCompileString.debug("fun");
			self.quickpad[point.x][point.y].value(self, point);
		},
	))
};

// fx pad
ProtoDef(\apc40).putAll((
	quickfxpad: { arg self;
		var name = \quickfxpad;
		self['property_'+++name] ?? {
			self['property_'+++name] = nil ! ( self.gridsize.y+1 );
			self['property_'+++name]
		}
	},

	quickfxpad_: { arg self, val;
		var name = \quickfxpad;
		self['property_'+++name] = val
	},

	quickfxpad_objects: { arg self;
		var name = \quickfxpad_objects;
		self['property_'+++name] ?? {
			self['property_'+++name] = { nil ! ( self.gridsize.y+1 ) } ! ( self.gridsize.x+1 );
			self['property_'+++name]
		}
	},

	quickfxpad_objects_: { arg self, val;
		var name = \quickfxpad_objects;
		self['property_'+++name] = val
	},
));
ProtoDef(\apc40).userPanels[2] = { arg self, point;
	if(self.quickfxpad_objects[point.x][point.y].isNil) {
		self.quickfxpad_objects[point.x][point.y] = ProtoClass((
			isActive: false,
			isPlaying: false,
			playMode: \gate,
			isEmpty: {
				self.quickfxpad[point.y].isNil;
			},
			play: { arg cellself;
				self.quickfxpad[point.y].value(cellself, self, self.grid.childAtOffset(point.x), point);
			},
		))
	};
	self.quickfxpad_objects[point.x][point.y];
};

//////// debug

ProtoDef(\apc40).activate(TrackDef(\split)); // debug
);

// END

			self.ktl.sendSpecialMessage(\setLiveMode);

			FileSystemProject.load("libdef/pdeftrack.scd");
			FileSystemProject.load("libdef/apc.scd");
			Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
			Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
			TrackDef(\pdefgrid).edit
			ProtoDef(\apc40).activate(TrackDef(\pdefgrid));
			
			ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2]);
			ProtoDef(\apc40).activate_bank_selector
			MKtl.find(\midi); // when was not connected
			k=MKtl(\apc, "akai-apc40mkii");
			k.sendSpecialMessage(\setLiveMode)
		)
TrackDef(\mygrid).isEmpty
ProtoDef(\apc40).activate(TrackDef(\mygrid)); // debug
ProtoDef(\apc40).activate; // debug
ProtoDef(\apc40).ktl.elAt(\bt, \flat)
ProtoDef(\apc40).grid
ProtoDef(\apc40).map_track_mixer_mute
ProtoDef(\apc40).startControl(nil)
Param.trace = true
MKtl(\apc).resetActions

TrackDef(\mygrid).elAt(0).mixer.edit
TrackDef(\mygrid).elAt(24).mixer
TrackDef(\mygrid).elAt(0).mixer.getParam(\muteMode).normSet(1)
TrackDef(\mygrid).elAt(0).mixer.getParam(\muteMode).get
TrackDef(\mygrid).elAt(0).mixer.getParam(\muteMode).spec
TrackDef(\mygrid).elAt(0).mixer.getParam(\muteMode).normGet == 0
TrackDef(\mygrid).elAt(0).mixer.clear
TrackDef(\mygrid).elAt(0).mixer_obj = nil
TrackDef(\mygrid).elAt(4,0).proxy
TrackDef(\mygrid).elAt(4,0).clearTrack
TrackDef(\mygrid).edit
TrackDef(\mygrid).elAt(0).label
TrackDef(\mygrid).isEmpty


/////////////

MKtl(\apc).elements
MKtl(\apc).elAt(\bt).elements.collect(_.postln)
MKtl(\apc).elAt(\bt, '5', 0, 0).elements.collect(_.postln) // activ
MKtl(\apc).elAt(\bt, '5', 1, 0).elements.collect(_.postln) // solo
MKtl(\apc).elAt(\bt, '5', 1, 0, \on).action.asCompileString
MKtl(\apc).elAt(\bt, '5', 1, 0, \off).action.asCompileString
MKtl(\apc).elAt(\bt, '5', 1, 0,\off).value = 1;
MKtl(\apc).elAt(\bt, \scene, 1,\on).value = ProtoDef(\apc40).colors.green/127;
MKtl(\apc).elAt(\bt, \clip, 0,1,\on).value = ProtoDef(\apc40).colors.green/127;
MKtl(\apc).elAt(\bt, \clipS, 0,\on).value = ProtoDef(\apc40).colors.green/127;
MKtl(\apc).elAt(\bt, \clipS, 0,\on).value = 0
MKtl(\apc).elAt(\bt, \flat, \play,\on).value = 1
MKtl(\apc).elAt(\bt, \selection, 0,\on).value = ProtoDef(\apc40).colors.green/127;
MKtl(\apc).elAt(\bt, \selection, 0,\on).value = 120;
MKtl(\apc).elAt(\bt, \selection, 7,\on).value = 120;
MKtl(\apc).elAt(\sl, \master)
MKtl(\apc).trace



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

//(
//ProtoDef(\apc40, (

	//noteOn: { arg self ...args; // chan, num, val
		//MIDIOut(0).noteOn(*args)
	//},

	//noteOff: { arg self ...args;
		//MIDIOut(0).noteOff(*args)
	//},

	//cc: { arg self ...args;
		//MIDIOut(0).control(*args)
	//},

	//clear_flats: { arg self;
		//self.bank_names.do { arg name;
			//self.noteOff(0, MIDIMap.controls[name][0]);
		//}
	//},

	//bank_names:[ \device_left, \device_right, \bank_left, \bank_right ],
	//bank_actions: IdentityDictionary.new,
	//pads_actions: IdentityDictionary.new,

	//midimap: { arg self, key, param;
		//MIDIMap(key, param, false);
		//self.cc(0, MIDIMap.controls[key][0], param.normGet*127);
	//},

	//activate_bank_selector: { arg self;
		//self.bank_names.do { arg name, idx;
			//MIDIMap(name, {
				//self.clear_flats;
				//self.noteOn(0, MIDIMap.controls[name][0]);
				//self.bank_actions[idx].(self, idx)
			//})
		//}
	//},

	//startControl: { arg self;
		//self.activate_bank_selector;
	//},

	//colors: (
		//playing: 120,
		//stopped: 121,
	//),

	//activate_pads: { arg self;
		//MIDIdef.noteOn(\apcpad_on, { arg val, num, chan, src;
			//var px, py;
			//[val, num, chan, src].debug;
			//if(num >= 0 and: { num < 48 }) {
				//px = num % 8;
				//py = ( num / 8 ).trunc;
				//self.pads_actions[px][py].(self, num);
				//self.noteOn(0, num, self.colors.playing);
			//};
		//}, nil, nil, ~apc_device_id);
	//},

	

	//mappad: { arg self, point, proxy;
		//self.pads_actions[point.asSymbol] = {
			//PlayerWrapper(proxy).play;
		//};
		//self.noteOn(0, num, self.colors.stopped);
	//},

//));
//)




