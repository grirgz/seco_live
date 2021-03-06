
(

~class_midi_macro_manager = (
	level_spec: ControlSpec(0,1,'lin',0,1),

	controls: {
		8.collect { arg x; ( \k++( x+1 ) ).asSymbol  }
		++ 8.collect { arg x; ( \s++( x+1 ) ).asSymbol  }
	}.value,

	new: { arg self;
		self = self.deepCopy;
	
		
		self.main = { Veco.main };
		self.make_responder;
		self.current_node_index = 0;
	
		self;
	},

	mixer_key: \preamp,

	destructor: { arg self;
		self.onClose;
	},

	make_responder: { arg self;
		self.responder_anchor = self;
		~make_class_responder.(self, self.responder_anchor, self.main, [
			\clip_offset
		]);
		self.update_faders;
	},

	refresh: { arg self;
		"gni ?"	
	},

	clip_offset: { arg self;
		self.update_faders;
	},

	knobs_do: { arg self, fun;
		
		[\k, \s].do { arg prefix;

			9.do { arg x;
				var key;
				var control;
				var xx = x+1;
				key = (prefix++xx).asSymbol;
				fun.(key, x)
			}
		};
		
	},

	map_list: { arg self, list;
		[\k, \s].do { arg prefix, px;

			8.do { arg x;
				var key;
				var control;
				var xx = x+1;
				var elm = list[x+(px*8)];
				if(elm.notNil) {
					key = (prefix++xx).asSymbol;
					MIDIBoard.map(key, elm[0], elm[1], elm[2]);
				}
			}
		};
		
	},

	unmap_faders: { arg self;
		8.do { arg x;
			MIDIBoard.unmap((\s++(x+1)).asSymbol);
		} 
	},

	map_pianopads_to_node_selector: { arg self;
		8.do { arg x;
			MIDIBoard.map((\a++(x+1)).asSymbol, { self.map_node_by_rel_index(x) });
		} 
	},

	map_pianopads_to_fx_node_selector: { arg self;
		[~tfx1, ~tfx2, ~tfx3, ~tfx4].do { arg fx, x;
			MIDIBoard.map((\a++(x+1)).asSymbol, { self.map_node_macro_to_knobs(self.main.get_node_by_uname(fx)) });
		} 
	},

	map_ndef_to_knobs: { arg self, key, bindings, exclude;
		bindings = bindings ?? { (1..8).collect(\k+++_) };
		block { arg break;
			var x = 0;
			Ndef(key).controlNames.collect { arg con;
				//[exclude, con.name.dump,exclude.includes(con.name).not ].debug("exclude");
				if(exclude.includes(con.name).not) {
					MIDIMap(bindings[x], [Ndef(key), con.name]);
					x = x+1;
					if(x >= bindings.size) { break.value };
				};
			}
		};

	},

	map_node_to_knob_auto: { arg self, node, exclude, knob_only=false;
		var controls = self.controls;
		if(knob_only) {
			controls = controls.keep(8);
		};
		if(Ndef(node.uname+++\fx).notNil) {
			exclude = exclude ? [\out, \gate, \amp, \preamp, \gain];
			self.map_ndef_to_knobs(node.uname+++\fx, controls, exclude)
		}
	},

	map_node_macro_to_knobs: { arg self, node;
		if(node.lib.macros.notNil) {
			var macros = node.lib.macros.value;
			16.do { arg mx;
				var mapping = node.lib.macros[mx];
				var key;
				if(mx>=8) {
					key = (\s++(mx+1-8)).asSymbol;
				} {
					key = (\k++(mx+1)).asSymbol;
				};
				[key, mapping, mx].debug("map_node_macro_to_knobs");
				if(mapping.notNil) {
					MIDIMap(key, mapping);
				} {
					if(mx<8) {
						MIDIMap.free(key);
					}
				}
			}
		} {
			// create auto mapping on fx
			self.map_node_to_knob_auto(node);
		};
		
	},

	map_node_macro_to_knobs_knob_only: { arg self, node;
		if(node.lib.macros.notNil) {
			var macros = node.lib.macros.value;
			8.do { arg mx;
				var mapping = node.lib.macros[mx];
				var key = (\k++(mx+1)).asSymbol;
				[x, mapping, mx].debug("map_node_by_rel_index");
				if(mapping.notNil) {
					MIDIBoard.map(key, *mapping);
				} {
					MIDIBoard.unmap(key);
				}
			}
		} {
			// create auto mapping on fx
			self.map_node_to_knob_auto(node, nil, true);
		};
		
	},

	map_node_morphers_to_knobs: { arg self;
		8.do { arg x;
			var ofx = self.main.clip_offset.x;
			var idx = ofx+x;
			var node = self.main.get_node_by_index(idx);
			var morpher = self.get_node_morpher(node.uname);
			if(morpher.notNil) {
				MIDIMap(\k+++(x+1), morpher)
			}
		};
	},

	map_node_by_index: { arg self, idx;
		var node = self.main.get_node_by_index(idx);
		self.current_node_index = idx;
		self.map_node_macro_to_knobs(node);
		self.map_node_morpher(node);
	},

	map_node_by_rel_index: { arg self, x;
		var ofx = self.main.clip_offset.x;
		var idx = ofx+x;
		self.map_node_by_index(idx);
	},

	map_send_to_knobs: { arg self, index, prefix=\send;
		var ofx = self.main.clip_offset.x;
		ofx.debug("map_send_to_knobs");
		8.do { arg x;
			var node = self.main.get_node_by_index(ofx+x);
			var uname = node.uname;
			var ndef;
			var key = (\k++(x+1)).asSymbol;
			if(node.is_present) {
				ndef = Ndef((uname++'mixer').asSymbol);
				if(ndef.source.notNil) {
					MIDIBoard.map(key, Ndef((uname++'mixer').asSymbol), (prefix++index).asSymbol, self.level_spec);
				} {
					debug("no mixer so no send");
					MIDIBoard.unmap(key);
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			}
		};
	},

	// use ~veco_sendpad
	map_sendpad_to_faders: { arg self, index, midiprefix=\s;
		var ofx = self.main.clip_offset.x;
		ofx.debug("map_send_to_knobs");
		8.do { arg x;
			var node = self.main.get_node_by_index(ofx+x);
			var uname = node.uname;
			var ndef;
			var key = (midiprefix++(x+1)).asSymbol;
			if(node.is_present) {
				ndef = Ndef((uname++'mixer').asSymbol);
				if(ndef.source.notNil) {
					~veco_sendpad.install_sender(uname, index);
					MIDIMap(key, ~veco_sendpad.get_send_param(uname, index));
				} {
					debug("no mixer so no send");
					MIDIMap(key, nil);
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			}
		};
	},

	map_sendpad_to_knobs: { arg self, index;
		self.map_sendpad_to_faders(index, \k)
	},

	map_fader_to_vol: { arg self, node, uname, x;
		var ndef;
		//"map_fader_to_vol".debug(1);
		node.is_present;
		//"map_fader_to_vol".debug(1.01);
		if(node.is_present) {
			var mixer_key;
			//"map_fader_to_vol".debug(1.1);
			if(self.mode_global_mixer_key == true) {
			//"map_fader_to_vol".debug(1.2);
				mixer_key = self.mixer_key;
				if(mixer_key == \default) {
					mixer_key = \preamp;
				}
			} {

			//"map_fader_to_vol".debug(1.3);
				mixer_key = 
					case
						{ self.mixer_key == \default } {
							case
								{ node.mixer_mode == \default } { \preamp }
								{ node.mixer_mode == \preamp } { node.mixer_mode }
								{ node.mixer_mode == \amp } { node.mixer_mode }
								{ node.mixer_mode.asString.beginsWith("mix") } { \amp }
								{ node.mixer_mode.asString.beginsWith("premix") } { \preamp }
								{ \preamp }

						}
						{ self.mixer_key == \amp } { self.mixer_key }
						{ self.mixer_key == \preamp } { self.mixer_key }
			};
			//"map_fader_to_vol".debug(1);
			ndef = Ndef((uname++'mixer').asSymbol);
			if(ndef.source.notNil) {
				MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), mixer_key, self.level_spec);
			} {
				debug("TODO: set node amp");
				MIDIBoard.unmap((\s++(x+1)).asSymbol);
				//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
			}
		} {
			MIDIBoard.unmap((\s++(x+1)).asSymbol);
		};
			//"map_fader_to_vol".debug(2);
		
	},

	map_faders_to_fx_vol: { arg self;
		var ofx = 0;
		ofx.debug("map_faders_to_fx_vol");
		[~tfx1, ~tfx2, ~tfx3, ~tfx4].do { arg uname, x;
			var node;
			var ndef;
			if(uname.notNil) {
				uname.debug("uname");
				node = self.main.get_node_by_uname(uname);
				"plop".debug(1);
				self.map_fader_to_vol(node, uname, x);
				"plop".debug(2);
			}
		} 
	},

	update_faders: { arg self;
		var ofx = self.main.clip_offset.x;
		//ofx.debug("update_faders");
		8.do { arg x;
			var node = self.main.get_node_by_index(ofx+x);
			var uname = node.uname;
			var ndef;
			self.map_fader_to_vol(node, uname, x)
		} 
	},

	set_all_faders_to_max: { arg self, key, val=1;
		var ofx = self.main.clip_offset.x;
		//ofx.debug("update_faders");
		key = key ? self.mixer_node;
		8.do { arg x;
			var node = self.main.get_node_by_index(ofx+x);
			var uname = node.uname;
			var ndef;
			if(node.is_present) {
				ndef = Ndef((uname++'mixer').asSymbol);
				if(ndef.source.notNil) {
					Ndef((uname++'mixer').asSymbol).set(key, val);
				} {
					debug("TODO: set node amp");
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			}
		} 
	},

	set_mixer_mode: { arg self, key=\preamp;
		self.mixer_key = key;
		self.update_faders;
	},

	toggle_mixer_mode: { arg self;
		var modes = [\preamp, \amp, \default];
		self.set_mixer_mode(modes.wrapAt(modes.indexOf(self.mixer_key)+1 ?? 0));
	},

	set_gen_mode: { arg self;
		self.map_pianopads_to_node_selector;
		self.update_faders;
	},

	set_fx_mode: { arg self;
		self.map_pianopads_to_fx_node_selector;
		self.map_faders_to_fx_vol;
	},

	map_node_morpher: { arg self, node;
		var uname = node.uname;
		var morpher;
		morpher = self.get_node_morpher(uname);
		if(morpher.isNil) {
			MIDIMap.free(\k9)
		} {
			MIDIMap(\k9, morpher);
		}
	},

	get_node_morpher: { arg self, uname;
		var presets_size = 8; // size of the lauchpad
		if(ParamGroupDef(uname).isNil) {
			nil
		} {
			PresetListMorpherDef(uname, ParamGroupDef(uname), presets_size)
		}
	},

	edit_presets: { arg self;
		var preset_manager;
		var uname = self.main.get_node_by_index(self.current_node_index).uname;
		var morpher;
		morpher = self.get_node_morpher(uname);
		if(morpher.notNil) {
			uname.debug("edit_presets: edit uname preset");
			preset_manager = ~launchpad_scene_preset_manager.new(Veco.main);
			preset_manager.set_model(morpher);
			preset_manager.activate();
		} {
			uname.debug("edit_presets: No morpher!")
		}

	},
);



~class_midi_macro_manager_view_base = (
	string_precision: 6,

	new: { arg self, controller;
		self = self.deepCopy;
	
		self.make_view;
		self.responder_anchor = Dictionary.new;
		
		[\k, \s].do { arg prefix;

			9.do { arg x;
				var key;
				var control;
				x = x+1;
				key = (prefix++x).asSymbol;
				control = MIDIBoard.controls[key];
				self.responder_anchor[key] = ();
				// FIXME: what ?? anchor is an event ??
				// yes, onClose is called on the event
				~make_class_responder.(self, self.responder_anchor[key], control, [
				//~make_class_responder.(self, self.window, control, [
					\new_map, \map, \free_map, \val,
				])
			}
		};

	
		self;
	},

	release_all_responders: { arg self;
		self.responder_anchor.keysValuesDo { arg key, val;
			//if(val.notNil) {

				val.onClose;
			//}
		};
	},

	knobs_do: { arg self, fun;
		
		[\k, \s].do { arg prefix;

			9.do { arg x;
				var key;
				var control;
				var xx = x+1;
				key = (prefix++xx).asSymbol;
				fun.(key, x)
			}
		};
		
	},

	controls_do: { arg self, fun;
		[\k, \s].do { arg prefix;

			9.do { arg x;
				var key;
				var control;
				var xx = x+1;
				key = (prefix++xx).asSymbol;
				control = self.get_control(key);
				fun.(control, key, x);
			}
		};
	},

	new_map: { arg self, sender;
		var key = sender.name;
		var control = MIDIBoard.controls[key];
		[sender.name].debug("new_map responder");
		self.responder_anchor[key].onClose;
		self.responder_anchor[key] = ();
		~make_class_responder.(self, self.responder_anchor[key], control, [
			\init, \map, \destructor, \val
		]);
		self.update_knob(key, control);
	},

	free_map: { arg self, sender;
		var key = sender.name;
		var control = MIDIBoard.controls[key];
		[sender.name].debug("free_map responder");
		self.responder_anchor[sender.name].onClose;
		[sender.name].debug("free_map responder xx");
		self.update_knob(key, control);
	},

	map: { arg self, sender;
		var key = sender.name;
		var control = MIDIBoard.controls[key];
		[sender.name].debug("map responder");
		self.update_knob(key, control);
	},

	val: { arg self, sender;
		var key = sender.name;
		var control = MIDIBoard.controls[key];
		//[sender.name].debug("val responder");
		self.update_knob(key, control);
	},

	refresh_knobs: { arg self;
		self.knobs_do { arg key, x;
			self.update_knob(key, self.get_control(key));
		}
	},

	get_control: { arg self, key;
		var control = MIDIBoard.controls[key];
		if(control.is_mapped.not) {
			control = VecoLib.lib[\void_controller]
		};
		if(control.target_string.isNil) {
			control.debug("control");
			"WTF!!!============================ target_string is nil".debug;
		};
		control;
	},

	update_knob: { arg self, key, control;
		var knob = self.knob_views[key];

		//[key, control.target_string].debug("update_knob");
		control = self.get_control(key);
		//var target_string;
		control = control.deepCopy;
		if(control.target_string.isNil) {
			"WTF!!!============================ target_string is nil".debug;
		};

		{
			//"kj".debug;
			knob.label.string = control.target_string.tr($ , $\n);
			//"1kj".debug;
			knob.val_label.string = control.target_get.asFloat.asStringPrec(self.string_precision);
			//"2kj".debug;
			knob.knob.value = control.target_norm_get;
			//"3kj".debug;
		}.defer;
	},

	make_view: { arg self;
		Task({

			self.window = Window.new;
			self.vlayout = VLayout.new;
			self.knob_views = Dictionary.new;
			self.window.onClose = self.window.onClose.addFunc { 
				self.release_all_responders;
			};
			self.window.view.keyDownAction = { arg ... args;
				if(args[1] == $j) {
					self.refresh_knobs;
				};
				if(args[3].dump == 27) {
					"kk".debug;
					self.window.close;
				};
				args.debug("keyDownAction");
			};
			[\k, \s].do { arg prefix;
				var hlayout = HLayout.new;
				self.vlayout.add(hlayout);
				9.do { arg x;
					var butlay = VLayout.new;
					var knob = Knob.new;
					var label = StaticText.new;
					var val_label = StaticText.new;
					var control;
					var key;
					var view;
					var size = Point(70,180);
					var font;
					x = x+1;
					key = (prefix++x).asSymbol;
					control = self.get_control(key);

					view = View.new;
					font = Font.default;
					font.size = 11;

					view.minSize = size;
					view.maxSize = size;

					self.knob_views[key] = (
						knob: knob,
						label: label,
						val_label: val_label,
						control: control,
					);

					[key, control].debug("make_view: control");
					[key, control.target].debug("make_view: control.target");
					[key, control.target_get].debug("make_view: control.target_get");

					//label.string = control.target_string;
					//label.string = "kjk\ndkjf\nkjkj";
					label.font = font;
					label.align = \center;
					//val_label.string = control.target_get.asFloat.asStringPrec(self.string_precision);
					val_label.font = font;
					val_label.align = \center;
					//knob.value = control.target_norm_get;
					knob.action = { arg knob;
						control.target_norm_set(knob.value);
						val_label.string = control.target_get.asFloat.asStringPrec(self.string_precision);
					};
					self.update_knob(key, control);

					view.layout = butlay;
					hlayout.add(view);
					butlay.add(label);
					butlay.add(knob);
					butlay.add(val_label);

					0.01.wait;

				}
			};
			self.window.layout = self.vlayout;
			self.window.front;

		}).play(AppClock);
		
	},


);

~class_midi_macro_manager_view = (
	parent: ~class_midi_macro_manager_view_base,

	update_knob: { arg self, key;
		//debug("update_knob: no more method! hahahahah");
		self.knob_views[key].update_view;

	},

	make_view: { arg self;
		Task({

			self.window = Window.new;
			self.vlayout = VLayout.new;
			self.knob_views = Dictionary.new;
			self.window.onClose = self.window.onClose.addFunc { 
				self.release_all_responders;
			};
			self.window.view.keyDownAction = { arg ... args;
				if(args[1] == $j) {
					self.refresh_knobs;
				};
				if(args[3].dump == 27) {
					"kk".debug;
					self.window.close;
				};
				args.debug("keyDownAction");
			};
			[\k, \s].do { arg prefix;
				var hlayout = HLayout.new;
				self.vlayout.add(hlayout);
				9.do { arg x;

					var view;
					var control;
					var key = (prefix ++ (x+1)).asSymbol;
					var cview;
					var size = Point(70,180);

					view = View.new;
					view.minSize = size;
					view.maxSize = size;

					cview = VecoLib.lib[\class_rack_control_scalar_knob_view].new(MIDIBoard.controls[key], self);
					view.layout = cview.make_layout;
					self.knob_views[key] = cview;

					hlayout.add(view);

					0.01.wait;

				}
			};
			self.window.layout = self.vlayout;
			self.window.front;

		}).play(AppClock);
		
	},

);

~class_simple_param_view = (
	new: { arg self;
		var font;
		self = self.deepCopy;
	
		font = Font.default;
		font.size = 11;
		self.layout = VLayout.new;
		//self.label = StaticText.new.font_(font).minWidth_(150);
		self.label = StaticText.new.font_(font);
		self.knob = Knob.new;
		//self.val = TextField.new.font_(font).minWidth_(150);
		self.val = TextField.new.font_(font);
		self.layout.add(self.label, stretch:1);
		self.layout.add(self.knob);
		self.layout.add(self.val);
		self.layout.margins = 1;
		self.layout.spacing = 10;
	
		self;
	},
	mapMidi: { arg self, key;
		MIDIMap.mapStaticTextLabel(key, self.label);
		MIDIMap.mapView(key, self.knob);
		MIDIMap.mapView(key, self.val);
	},
	mapParam: { arg self, param;
		self.label.mapParamLabel(param);
		self.knob.mapParam(param);
		self.val.mapParam(param);
	},
	unmapParam: { arg self;
		self.label.unmapParam;
		self.knob.unmapParam;
		self.val.unmapParam;
	}
);

~class_midimap_icon_view = (
	// replace class_midi_macro_manager_view with Param: eat your own dog food
	//var keys = 
	//	( (_+1) ! 9 ).collect(\k++_)
	//	++ ( (_+1) ! 9 ).collect(\s++_);
	//MIDIMap.mapView(key, view)
	new: { arg self;
		self = self.deepCopy;
	
		
		self.make_view;
	
		self;
	},

	make_cview: { arg self;
		~class_simple_param_view.new;
	},

	make_view: { arg self;

		Task({

			self.window = Window.new;
			self.vlayout = VLayout.new;
			self.knob_views = Dictionary.new;
			self.window.onClose = self.window.onClose.addFunc { 
				self.release_all_responders;
			};
			self.window.view.keyDownAction = { arg ... args;
				if(args[1] == $j) {
					self.refresh_knobs;
				};
				if(args[3].dump == 27) {
					"kk".debug;
					self.window.close;
				};
				args.debug("keyDownAction");
			};
			[\k, \s].do { arg prefix;
				var hlayout = HLayout.new;
				self.vlayout.add(hlayout);
				9.do { arg x;

					var view;
					var control;
					var key = (prefix ++ (x+1)).asSymbol;
					var cview;
					var size = Point(90,150);

					view = View.new;
					view.minSize = size;
					view.maxSize = size;

					//cview = VecoLib.lib[\class_rack_control_scalar_knob_view].new(MIDIBoard.controls[key], self);
					cview = self.make_cview;
					cview.mapMidi(key);
					view.layout = cview.layout;
					self.knob_views[key] = cview;

					hlayout.add(view);

					0.01.wait;

				}
			};
			self.window.layout = self.vlayout;
			self.window.front;

		}).play(AppClock);
		
	}
);


~midi_macro_manager !? (_.destructor);
~midi_macro_manager = ~class_midi_macro_manager.new;
~midi_macro_manager.map_pianopads_to_node_selector;
//MIDIMap(\c1, {~midi_macro_manager.map_send_to_knobs(1)});
//MIDIMap(\c2, {~midi_macro_manager.map_send_to_knobs(2)});
//MIDIMap(\c3, {~midi_macro_manager.map_send_to_knobs(3)});
//MIDIMap(\c4, {~midi_macro_manager.map_send_to_knobs(4)});
MIDIMap(\left, {~midi_macro_manager.set_gen_mode});
MIDIMap(\right, {~midi_macro_manager.set_fx_mode});
MIDIMap(\stop, { ~midi_macro_manager.edit_presets; });
MIDIMap(\record, {
	~midi_macro_manager.toggle_mixer_mode
});
MIDIMap(\loop, { 
	{
		if( ~midi_macro_manager_view.notNil ) {
			if(~midi_macro_manager_view.window.notNil) {
				~midi_macro_manager_view.window.close;
			}
		};

		~midi_macro_manager_view = ~class_midimap_icon_view.new(~midi_macro_manager);
	}.defer;
});
);

