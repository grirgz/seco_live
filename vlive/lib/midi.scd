
(
~class_midi_macro_manager = (
	level_spec: ControlSpec(0,1,'lin',0,1),
	new: { arg self;
		self = self.deepCopy;
	
		
		self.main = { Veco.main };
		self.make_responder;
	
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

	map_node_macro_to_knobs: { arg self, node;
		8.do { arg mx;
			if(node.lib.macros.notNil) {
				var mapping = node.lib.macros[mx];
				var key = (\k++(mx+1)).asSymbol;
				[x, mapping, mx].debug("map_node_by_rel_index");
				if(mapping.notNil) {
					MIDIBoard.map(key, *mapping);
				} {
					MIDIBoard.unmap(key);
				}
			}
		};
		
	},

	map_node_by_index: { arg self, idx;
		var node = self.main.get_node_by_index(idx);
		self.map_node_macro_to_knobs(node)
	},

	map_node_by_rel_index: { arg self, x;
		var ofx = self.main.clip_offset.x;
		var idx = ofx+x;
		self.map_node_by_index(idx);
	},

	map_send_to_knobs: { arg self, index;
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
					MIDIBoard.map(key, Ndef((uname++'mixer').asSymbol), (\send++index).asSymbol, self.level_spec);
				} {
					debug("no mixer so no send");
					MIDIBoard.unmap(key);
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			}
		};
	},

	map_faders_to_fx_vol: { arg self;
		var ofx = 0;
		ofx.debug("map_faders_to_fx_vol");
		[~tfx1, ~tfx2, ~tfx3, ~tfx4].do { arg uname, x;
			var node = self.main.get_node_by_uname(uname);
			var ndef;
			if(node.is_present) {
				ndef = Ndef((uname++'mixer').asSymbol);
				if(ndef.source.notNil) {
					MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), self.mixer_key, self.level_spec);
				} {
					debug("TODO: set node amp");
					MIDIBoard.unmap((\s++(x+1)).asSymbol);
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			} {
				MIDIBoard.unmap((\s++(x+1)).asSymbol);
			}
		} 
	},

	update_faders: { arg self;
		var ofx = self.main.clip_offset.x;
		ofx.debug("update_faders");
		8.do { arg x;
			var node = self.main.get_node_by_index(ofx+x);
			var uname = node.uname;
			var ndef;
			if(node.is_present) {
				ndef = Ndef((uname++'mixer').asSymbol);
				if(ndef.source.notNil) {
					MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), self.mixer_key, self.level_spec);
				} {
					debug("TODO: set node amp");
					MIDIBoard.unmap((\s++(x+1)).asSymbol);
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			} {
				MIDIBoard.unmap((\s++(x+1)).asSymbol);
			}
		} 
	},

	set_all_faders_to_max: { arg self, key, val=1;
		var ofx = self.main.clip_offset.x;
		ofx.debug("update_faders");
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
		if(self.mixer_key == \preamp) {
			self.set_mixer_mode(\amp);
		} {
			self.set_mixer_mode(\preamp);
		}
	},

	set_gen_mode: { arg self;
		self.map_pianopads_to_node_selector;
		self.update_faders;
	},

	set_fx_mode: { arg self;
		self.map_pianopads_to_fx_node_selector;
		self.map_faders_to_fx_vol;
	},
);


~class_midi_macro_manager_view = (
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
				~make_class_responder.(self, self.responder_anchor[key], control, [
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
		[sender.name].debug("map responder");
		self.update_knob(key, control);
	},

	refresh_knobs: { arg self;
		self.knobs_do { arg key, x;
			self.update_knob(key, self.get_control(key));
		}
	},

	get_control: { arg self, key;
		var control = MIDIBoard.controls[key];
		if(control.isNil 
			or: { control.target.isNil 
			or: { control.target_norm_get.isNil  
			or: { control.target_get.isNil }
			or: { control.target_spec.isNil }
		 }}) {
			control = (
				target_string: "_",
				target_get: 0,
				target_norm_get: 0,
			);
		};
		if(control.target_string.isNil) {
			control.debug("control");
			"WTF!!!============================ target_string is nil".debug;
		};
		control;
	},

	update_knob: { arg self, key, control;
		var knob = self.knob_views[key];

		[key, control.target_string].debug("update_knob");
		control = self.get_control(key);
		//var target_string;
		control = control.deepCopy;
		if(control.target_string.isNil) {
			"WTF!!!============================ target_string is nil".debug;
		};

		{
			"kj".debug;
			knob.label.string = control.target_string.tr($ , $\n);
			"1kj".debug;
			knob.val_label.string = control.target_get.asFloat.asStringPrec(self.string_precision);
			"2kj".debug;
			knob.knob.value = control.target_norm_get;
			"3kj".debug;
		}.defer;
	},

	make_view: { arg self;
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
				[key, control.target].debug("make_view: control");
				[key, control.target_get].debug("make_view: control");

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
			}
		};
		self.window.layout = self.vlayout;
		self.window.front;
		
	},

);

~midi_macro_manager !? (_.destructor);
~midi_macro_manager = ~class_midi_macro_manager.new;
~midi_macro_manager.map_pianopads_to_node_selector;
MIDIBoard.map(\c1, {~midi_macro_manager.map_send_to_knobs(1)});
MIDIBoard.map(\c2, {~midi_macro_manager.map_send_to_knobs(2)});
MIDIBoard.map(\c3, {~midi_macro_manager.map_send_to_knobs(3)});
MIDIBoard.map(\c4, {~midi_macro_manager.map_send_to_knobs(4)});
MIDIBoard.map(\left, {~midi_macro_manager.set_gen_mode});
MIDIBoard.map(\right, {~midi_macro_manager.set_fx_mode});
MIDIBoard.map(\record, {
	~midi_macro_manager.toggle_mixer_mode
});
MIDIBoard.map(\loop, { 
	{
		if( ~midi_macro_manager_view.notNil ) {
			~midi_macro_manager_view.window.close;
		};

		~midi_macro_manager_view = ~class_midi_macro_manager_view.new(~midi_macro_manager);
	}.defer;
});
//MIDIBoard.map(\left, {"hihih".postln});
);

//~midi_macro_manager_view.new(~midi_macro_manager);
//
//~midi_macro_manager.unmap_faders
//~midi_macro_manager.set_all_faders_to_max
//MIDIBoard.map(\b1, {~midi_macro_manager.map_send_to_knobs(1)});
//MIDIBoard.map(\b2, {~midi_macro_manager.map_send_to_knobs(2)});
//MIDIBoard.map(\s1, Ndef('1mixer'), \preamp);
//~midi_macro_manager.map_send_to_knobs(2)
//
//{
//	
//}
