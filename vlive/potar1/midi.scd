
MIDIBoard.map(\k2, Sdef(\1, \morph), \morph);
//MIDIBoard.map(\k1, Sdef(~name, \morph), \mdur)
MIDIBoard.map(\k3, Sdef(\2, \mypreset), \dmix);
MIDIBoard.map(\k4, Sdef(\2, \mypreset), \dmix2);
MIDIBoard.map(\k5, Sdef(\3, \mypreset), \decay);
MIDIBoard.map(\k6, Sdef(\3, \mypreset), \freqfactor);

MIDIBoard.map(\k7, Ndef('5lfo1'), \freq, \lofreq.asSpec);
MIDIBoard.map(\k8, Ndef('5lfo1'), \mul, \unipolar.asSpec);

MIDIBoard.map(\k1, Sdef(\5, \mypreset), \shift, \freq.asSpec);
MIDIBoard.map(\k2, Sdef(\5, \pat), \legato);

MIDIBoard.map(\s1, Ndef('1mixer'), \amp, \unipolar.asSpec);
MIDIBoard.map(\s2, Ndef('2mixer'), \amp, \unipolar.asSpec);
MIDIBoard.map(\s3, Ndef('3mixer'), \amp, \unipolar.asSpec);
MIDIBoard.map(\s5, Ndef('5mixer'), \amp, \unipolar.asSpec);

// END

MIDIBoard.map(\a1, { "plopSDFSDF".debug });

(
~class_midi_macro_manager = (
	level_spec: ControlSpec(0,1,'lin',0,1),
	new: { arg self;
		self = self.deepCopy;
	
		
		self.main = { Veco.main };
		self.make_responder;
	
		self;
	},

	destructor: { arg self;
		self.onClose;
	},

	make_responder: { arg self;
		self.responder_anchor = self;
		~make_class_responder.(self, self.responder_anchor, self.main, [
			\clip_offset
		]);
	},

	clip_offset: { arg self;
		self.update_faders;
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

	map_node_by_rel_index: { arg self, x;
		var ofx = self.main.clip_offset.x;
		var idx = ofx+x;
		var node = self.main.get_node_by_index(ofx+x);
		node.lib.macros.do { arg mapping, mx;
			[x, mapping, mx].debug("map_node_by_rel_index");
			MIDIBoard.map((\k++(mx+1)).asSymbol, *mapping);
		}
	},

	map_send_to_knobs: { arg self, index;
		var ofx = self.main.clip_offset.x;
		ofx.debug("map_send_to_knobs");
		8.do { arg x;
			var node = self.main.get_node_by_index(ofx+x);
			var uname = node.uname;
			var ndef;
			if(node.is_present) {
				ndef = Ndef((uname++'mixer').asSymbol);
				if(ndef.source.notNil) {
					MIDIBoard.map((\k++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), (\send++index).asSymbol, self.level_spec);
				} {
					debug("no mixer so no send");
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
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
					MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \preamp, self.level_spec);
				} {
					debug("TODO: set node amp");
					//MIDIBoard.map((\s++(x+1)).asSymbol, Ndef((uname++'mixer').asSymbol), \amp, \unipolar.asSpec);
				}
			}
		} 
	},

	set_all_faders_to_max: { arg self, key=\amp, val=1;
		var ofx = self.main.clip_offset.x;
		ofx.debug("update_faders");
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
);
~midi_macro_manager !? (_.destructor);
~midi_macro_manager = ~class_midi_macro_manager.new;
~midi_macro_manager.map_pianopads_to_node_selector;
MIDIBoard.map(\b1, {~midi_macro_manager.map_send_to_knobs(1)});
MIDIBoard.map(\b2, {~midi_macro_manager.map_send_to_knobs(2)});
)
~midi_macro_manager.unmap_faders
~midi_macro_manager.set_all_faders_to_max
MIDIBoard.map(\b1, {~midi_macro_manager.map_send_to_knobs(1)});
MIDIBoard.map(\b2, {~midi_macro_manager.map_send_to_knobs(2)});
~midi_macro_manager.map_send_to_knobs(2)

{
	
}
