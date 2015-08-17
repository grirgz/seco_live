
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01,1.001, 1+0.1.rand]);
	sig = RLPF.ar(sig, \lpf.kr(400), \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\plop1, Pbind(
	\instrument, \plop,
	\degree, Pseq([0,4,5,8],inf),
	\dur, 1/8,
	\amp, 0.1
));

Pdef(\plop2, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
));

Pdef(\plop3, Pbind(
	\instrument, \default,
	\degree, Pseq([0,7,7,7,7,2],inf),
	\octave, 5,
	\dur, 1/4,
	\amp, 0.1
));

~instruments = [
	Pdef(\plop1),
	Pdef(\plop2),
	Pdef(\plop3),
];

~selector = (
	// this selector version added possibility to regenere the views if they have been removed
	selected_color: Color.red,
	deselected_color: Color.yellow,
	new: { arg self, selector_count=8, action;
		self = self.deepCopy;
	
		"aA.".debug;
		self.selector_count = selector_count;
		self.selected_index = 0;
		self.action = action;
		
		self.select_item(0);
	
		"xr.".debug;
		self.views.debug("wtf");
		self.debug("self!!!");
		self;
	},

	views: { arg self;
		if(self.pr_views.isNil or: { self.pr_views.size > 0 and: {self.pr_views.first.isClosed }}) {
			[self.selector_count, self.selected_index].debug("refreshing selector.pr_views");
			self.pr_views = self.selector_count.collect({ arg x;
				XSimpleButton.new
					.minWidth_(15) 
					.action_({
						self.select_item(x);
						self[\action].(x);
					})
					.background_(self.deselected_color).debug("WWWTTTFF");
			}).debug("WTF");
			self.select_item(self.selected_index, self.pr_views);
			self.pr_views;
		} {
			self.pr_views
		}
	},

	resize: { arg self, size;
		size.debug("selector.resize");
		self.selector_count = size;
		self.selected_index = self.selected_index.clip(0, size-1);
		self.pr_views = nil; // don't know what bug can be caused by having a no more referenced views
			// but must find a way to update views because there is more or less now
	},

	select_item: { arg self, x, views;
		views = views ?? {self.views};
		if(views.size > 0) {
			views[self.selected_index].background_(self.deselected_color);
			views[x].background_(self.selected_color);
			self.selected_index = x;
		}
	},

	selected_view: { arg self;
		self.views[self.selected_index]
	},

);

~class_preset = (
	eventClass: \preset,
	new: { arg self, instr;
	
		if(instr.tryPerform(\eventClass) == \preset) {
			instr.clone;
		} {
			self = self.deepCopy;

			self.instr = instr;
			self.params = (amp: 0.1, pan:0);

			self
		}
	},

	clone: { arg self;
		var preset;
		preset = ~class_preset.new(self.instr);
		preset.params = self.params.deepCopy;
		preset;
	},

	paramlist: { arg self;
		[
			Param(self.params, \amp, \amp),
			Param(self.params, \pan, \pan),
		]
	},

	as_pattern: { arg self;
		Pn(self.params) <> self.instr
	}
);

~class_presetgroup = (
	new: { arg self;
		self = self.deepCopy;
	
		self.list = List.new;
		self.proxy = PatternProxy.new;
		self.update_proxy;
	
		self;
	},

	groupsize: { arg self;
		self.list.size;
	},

	clone: { arg self;
		var pg = ~class_presetgroup.new;
		pg.list = self.list.collect({ arg x; x.clone });
		pg.update_proxy;
		pg;
	},

	add_preset: { arg self, preset;
		self.list.add(preset);
		self.update_proxy;
	},

	add_from_lib: { arg self, lib, key;
		lib.lib[key].list.collect({ arg x; self.list.add(x.clone) });
		self.update_proxy;
	},

	remove_preset_at: { arg self, idx;
		self.list.removeAt(idx);
		self.update_proxy;
	},

	update_proxy: { arg self;
		self.proxy.source = if(self.list.size == 0) {
			Ptuple([(isRest: true, type: \rest)])
		} {
			Ptuple(self.list.collect({ arg item;
				item.as_pattern;
			}))
		};
	},

	as_stream: { arg self;
		self.proxy.asStream;
	},

	remove_all_preset: { arg self;
		self.list = List.new;
		self.update_proxy;
	},

	play_preset: { arg self, ev=(), no_latency=false;
		if(no_latency != false) {
			var nola, note;
			nola = Pn((latency: Ref(nil)),inf).asStream.next(ev);
			note = self.proxy.asStream.next(ev);
			[nola, note].debug("nola, note");
			nola.composeEvents( note ).debug("WAAAA play_preset");
			note.collect({ arg no; no.composeEvents(nola) }).debug("WAAAA play_preset").play;
		} {
			self.as_stream.next(ev).play;
		}
	},
);


~class_drumrack = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.presets = IdentityDictionary.new;
		self.pads = List.newClear(128).collect({
			~class_presetgroup.new;
		});
		self.padstreams = List.newClear(128);
	
		self;
	},

	clone: { arg self;
		var res = ~class_drumrack.new;
		res.rackpreset_lib = self.rackpreset_lib;
		res.drumpreset_lib = self.drumpreset_lib;
		res.pads = self.pads.collect({ arg x; x.clone });
		res;
		
	},

	add_to_pad: { arg self, padidx, instr;
		self.pads[padidx] = self.pads[padidx].add(~class_presetgroup.new(instr));
	},

	set_pad: { arg self, padidx, presetgroup;
		self.pads[padidx] = presetgroup;
	},

	get_pad: { arg self, idx;
		self.pads[idx];
	},

	pad_is_empty: { arg self, idx;
		self.pads[idx].isNil or: { self.pads[idx].list.size == 0 }
	},

	play_pad: { arg self, idx, ev;
		ev = ev ?? { () };
		idx.debug("play_pad!!");
		Ppar(
			self.pdrumstep.dictNext(idx, ev).collect({ arg x; Pn((latency: Ref(nil))) <> Pn(x,1) }),
		).play
	},
	

	padstream: { arg self, idx;
		if(self.padstreams[idx].isNil) {
			if(self.pads[idx].notNil and: { self.pads[idx].groupsize > 0 }) {
				self.padstreams[idx] = self.pads[idx].as_stream;
			} {
				self.padstreams[idx] = [(isRest: true).asStream];
			};
			self.padstreams[idx];
		} {
			self.padstreams[idx];
		}
	},

	pdrumstep: { arg self;
		if(self.pr_pdrumstep.isNil) {
			self.pr_pdrumstep = PdrumStep(self.pads, Pbind());
			self.pr_pdrumstep;
		} {
			self.pr_pdrumstep;
		}
	},

	as_pattern: { arg self, score;
		if(score.notNil) {
			PdrumStep(self.pads, score);
		} {
			nil
		};
	},

);

~class_drumrack_proxy = (
	new: { arg self, drumrack;
		self = self.deepCopy;
	
		self.drumrack = drumrack;
	
		self;
	},

	set_drumrack: { arg self, drumrack;
		self.drumrack = drumrack;
		if(self.current_pdrumstep.notNil) {
			self.current_pdrumstep.dict = drumrack.pads;
		};
	},

	as_pattern: { arg self, score;
		if(score.notNil) {
			self.current_pdrumstep = PdrumStep(self.drumrack.pads, score);
			self.current_pdrumstep;
		} {
			nil
		};
	},
);

~class_drumrack_view = (
	new: { arg self, drumrackproxy;
		self = self.deepCopy;

		self.drumrackproxy = drumrackproxy;
	
		self.pad_size = Point(4,4);
		self.make_window;
		self.select_drumpad(0);
	
		self;
	},

	select_drumpad: { arg self, idx;
		self.set_drumpad(self.drumrack.get_pad(idx));
		self.selected_drumpad_index = idx;
	},

	set_drumrack: { arg self, drumrack;
		self.drumrackproxy.set_drumrack(drumrack);
	},

	drumrack: { arg self;
		self.drumrackproxy.drumrack;
	},

	set_drumpad: { arg self, drumpad;
		// currently edited drumpad
		if(drumpad.notNil) {
			self.drumpad = drumpad;
			self.drumpad_row_selector = ~selector.new(self.drumpad.list.size, { });
			self.refresh_drumpad;
		} 
	},

	make_drumpreset_layout: { arg self, drumpreset, rowidx;
		HLayout(*
			[
				StaticText.new.string_("part " + rowidx),
				self.drumpad_row_selector.views[rowidx],
			]
			++
			drumpreset.paramlist.keep(8).collect({ arg param, x;
				[x, param].debug("Param");
				self.make_knob(param.property).mapParam(param);
			})
		)
	},

	refresh_drumpad: { arg self;
		if(self.drumpad_view.notNil) {
			if(self.drumpad.notNil) {
				self.drumpad_view.removeAll;
				self.drumpad_row_selector.resize(self.drumpad.list.size);
				self.drumpad_view.layout = VLayout(*
					self.drumpad.list.collect({ arg preset, x;
						self.make_drumpreset_layout(preset, x)
					})
				)
			} {
				self.drumpad_view.removeAll;
			}
		}

	},

	make_window: { arg self;
		var window = Window.new;
		var layout;
		layout = self.make_layout;
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	make_knob: { arg self, label;
		ParamView.label_knob(label);
	},

	refresh_pads: { arg self;
		self.pad_views.do { arg view, x;
			if(self.drumrack.pad_is_empty(x)) {
				view.background = Color.white;
			} {
				view.background = Color.yellow;
			}
		}
	},

	refresh_drumpreset_popup: { arg self;
		if(self.drumpreset_popup.notNil) {
			var idx = self.drumpreset_popup.value;
			self.drumpreset_popup.items_(self.drumrack.drumpreset_lib.get_list);
			self.drumpreset_popup.value = idx;
			self.selected_drumpreset_to_add = self.drumpreset_popup.items[self.drumpreset_popup.value];
		}
	},

	refresh_rackpreset_popup: { arg self;
		if(self.rackpreset_popup.notNil) {
			var idx = self.rackpreset_popup.value;
			self.rackpreset_popup.items_(self.drumrack.rackpreset_lib.get_list);
			self.rackpreset_popup.value = idx;
		}
	},

	make_save_drumpreset_window: { arg self, drumpad;
		var window = Window.new;
		var layout;
		var preset_name_view;
		var lib = self.drumrack.drumpreset_lib;
		layout = VLayout(
			preset_name_view = TextField.new,
			ListView.new.items_( lib.get_list ).value_(nil).action_({ arg view;
				preset_name_view.value = view.items[view.value];
			}),
			HLayout(
				XSimpleButton.new.label_("Cancel").action_({
					window.close;
				}),
				XSimpleButton.new.label_("Save").action_({
					var name = preset_name_view.value;
					if(name != "" and: { drumpad.notNil }) {
						lib.save_preset(name.asSymbol, drumpad.clone);
						window.close;
						self.refresh_drumpreset_popup;
					};
				}),
			)
			
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	make_load_drumpreset_window: { arg self, drumpad;
		var window = Window.new;
		var layout;
		var preset_name_view;
		var lib = self.drumrack.drumpreset_lib;
		layout = VLayout(
			preset_name_view = TextField.new,
			ListView.new.items_( lib.get_list ).value_(nil).action_({ arg view;
				preset_name_view.value = view.items[view.value];
				self.drumrack.drumpreset_lib.lib[preset_name_view.value.asSymbol].play_preset((), true);
			}),
			HLayout(
				XSimpleButton.new.label_("Cancel").action_({
					window.close;
				}),
				XSimpleButton.new.label_("Load").action_({
					var name = preset_name_view.value;
					if(name != "" and: { drumpad.notNil }) {
						self.drumpad.remove_all_preset;
						self.drumrack.get_pad(self.selected_drumpad_index).add_from_lib(
							self.drumrack.drumpreset_lib,
							name.asSymbol
						);
						self.refresh_drumpad;
						self.refresh_pads;
						window.close;
					};
				}),
			)
			
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	make_save_rackpreset_window: { arg self;
		var window = Window.new;
		var layout;
		var preset_name_view;
		var drumrack = self.drumrack;
		var lib = drumrack.rackpreset_lib;
		layout = VLayout(
			preset_name_view = TextField.new,
			ListView.new.items_( lib.get_list ).value_(nil).action_({ arg view;
				preset_name_view.value = view.items[view.value];
			}),
			HLayout(
				XSimpleButton.new.label_("Cancel").action_({
					window.close;
				}),
				XSimpleButton.new.label_("Save").action_({
					var name = preset_name_view.value;
					if(name != "" and: { drumrack.notNil }) {
						lib.save_preset(name.asSymbol, drumrack.clone);
						window.close;
						self.refresh_rackpreset_popup;
					};
				}),
			)
			
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	make_new_rackpreset_window: { arg self;
		var window = Window.new;
		var layout;
		var preset_name_view;
		var drumrack = self.drumrack;
		var lib = drumrack.rackpreset_lib;
		var based_on;
		layout = VLayout(
			preset_name_view = TextField.new,
			StaticText.new.string_("Based on:"),
			ListView.new.items_( ["--- None --- "] ++ lib.get_list ).value_(0).action_({ arg view;
				if(view.value == 0) {
					based_on = nil;
				} {
					based_on = view.items[view.value].asSymbol;
				}
			}),
			HLayout(
				XSimpleButton.new.label_("Cancel").action_({
					window.close;
				}),
				XSimpleButton.new.label_("New").action_({
					var name = preset_name_view.value;
					if(name != "" and: { drumrack.notNil }) {
						lib.save_preset(name.asSymbol, self.make_new_rack(based_on));
						self.refresh_rackpreset_popup;
						self.load_rackpreset(name.asSymbol);
						window.close;
					};
				}),
			)
			
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	load_rackpreset: { arg self, rackpreset;
		var rack = self.drumrack.rackpreset_lib.lib[rackpreset];
		self.current_rackpreset = rackpreset;
		//rack = rack.clone; // loaded racks are independent of the saved rack
		self.set_drumrack(rack);
		//[self.keys, self.drumpreset_lib.lib.keys, self.rackpreset_lib.lib.keys].debug("make_new_rack: self rack");
		//[rack.keys, rack.drumpreset_lib.lib.keys, rack.rackpreset_lib.lib.keys].debug("make_new_rack: self rack");
		self.set_drumpad(self.drumrack.get_pad(self.selected_drumpad_index));
		self.refresh_drumpad;
		self.refresh_pads;
		self.rackpreset_popup.value = self.rackpreset_popup.items.detectIndex({ arg x; x.asSymbol == self.current_rackpreset });
	},

	make_new_rack: { arg self, basename;
		var rack;
		if(basename.notNil) {
			rack = self.drumrack.rackpreset_lib.lib[basename];
			rack = rack.clone; // loaded racks are independent of the saved rack
			rack;
		} {
			rack = ~class_drumrack.new;
			rack.drumpreset_lib = self.drumrack.drumpreset_lib;
			rack.rackpreset_lib = self.drumrack.rackpreset_lib;
			//[self.keys, self.drumpreset_lib.lib.keys, self.rackpreset_lib.lib.keys].debug("make_new_rack: self rack");
			//[rack.keys, rack.drumpreset_lib.lib.keys, rack.rackpreset_lib.lib.keys].debug("make_new_rack: self rack");
			rack;
		}
		
	},

	make_layout: { arg self;
		var padlayout, paramlayout;
		var padheader, paramheader;
		var pm = PopUpMenu.new;
		self.drumpreset_popup = pm;
		self.rackpreset_popup = PopUpMenu.new;

		self.drumpad_selector = ~selector.new(self.pad_size.x * self.pad_size.y, { arg idx, idx2;
			[idx, idx2].debug("selecting pad !!!");
			self.select_drumpad(idx)
		});

		self.pad_views = List.new;

		padlayout = GridLayout.rows(*
			self.pad_size.x.collect({ arg x;
				self.pad_size.y.collect({ arg y;
					var idx = (x*self.pad_size.x+y);
					VLayout(
						self.pad_views.add( 
							XSimpleButton.new.label_((idx).asString).fixedSize_(Point(64,64-20))
							.action_({
								self.drumrack.play_pad(idx)
							}));
							self.pad_views.last,
						self.drumpad_selector.views.collect({ arg view, vidx;
							view.fixedSize_(Point(64,20));
							view.label_("edit");
						}).at(idx)
					).spacing_(0)
				})
			})
		);

		self.drumpad_view = View.new;
		paramlayout = ScrollView.new.canvas_(self.drumpad_view);

		padheader = HLayout(
			PlayerWrapperView(Pdef(\main)).view,
			{
				var rpp = self.rackpreset_popup;
				rpp.items = self.drumrack.rackpreset_lib.get_list;
				rpp.action = {
					rpp.items[rpp.value].debug("load rackpreset!!!");
					self.load_rackpreset(rpp.items[rpp.value]);
				};
				rpp;
			}.value,
			XSimpleButton.new.label_("New Rack").action_({
				//self.make_save_rackpreset_window;
				self.make_new_rackpreset_window;
			})
		);

		paramheader = HLayout(
			{
				pm.items = self.drumrack.drumpreset_lib.get_list;
				pm.action = {
					self.selected_drumpreset_to_add = pm.items[pm.value];
				};
				self.selected_drumpreset_to_add = pm.items[pm.value];
				//pm.onChange(subparam.target, \set, {
				//	var val;
				//	//"there is change! my lord!".debug;
				//	pm.value = pm.items.detectIndex({ arg x; x == subparam.get })
				//});
				//pm.value = pm.items.detectIndex({ arg x; x == subparam.get });
				pm;
			}.value,
			XSimpleButton.new.label_("+").action_({ 
				if(self.selected_drumpreset_to_add.notNil) {
					self.drumrack.get_pad(self.selected_drumpad_index).add_from_lib(
						self.drumrack.drumpreset_lib,
						self.selected_drumpreset_to_add
					);
					self.refresh_drumpad;
					self.refresh_pads;
				}
			}),
			XSimpleButton.new.label_("-").action_({ 
				self.drumrack.get_pad(self.selected_drumpad_index).remove_preset_at(
					self.drumpad_row_selector.selected_index
				);
				self.refresh_drumpad;
				self.refresh_pads;
			}),
			XSimpleButton.new.label_("Save preset").action_({ 
				self.make_save_drumpreset_window(self.drumpad);
			}),
			XSimpleButton.new.label_("Load preset").action_({ 
				self.make_load_drumpreset_window(self.drumpad);
			}),
		);

		self.layout = GridLayout.columns(
			[
				padheader,
				padlayout,
			],
			[
				paramheader,
				paramlayout,
			],
		);

		self.refresh_pads;

		self.layout;
	},

);

~class_drumpreset_lib = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.lib = IdentityDictionary.new;
	
		self;
	},

	save_preset: { arg self, name, preset;
		self.lib[name] = preset;
	},

	get_list: { arg self;
		self.lib.keys.asArray.sort;
	},
);

~class_drumrack_lib = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.lib = IdentityDictionary.new;
	
		self;
	},

	save_preset: { arg self, name, preset;
		self.lib[name] = preset;
	},

	get_list: { arg self;
		self.lib.keys.asArray.sort;
	},

);

~dl = ~class_drumpreset_lib.new;
~rl = ~class_drumrack_lib.new;
~dp = ~class_drumrack.new;
~dp.drumpreset_lib = ~dl;
~dp.rackpreset_lib = ~rl;
~pg = ~class_presetgroup.new;
~pg2 = ~class_presetgroup.new;
~p1 = ~class_preset.new(Pbind(\degree, 1));
~p2 = ~class_preset.new(Pbind(\degree, 4));
~p3 = ~class_preset.new(Pbind(\degree, 8));

~pg.add_preset(~p1);
~pg.add_preset(~p2);
~pg2.add_preset(~p3);
~dl.lib[\note1] = ~pg;
~dl.lib[\note2] = ~pg2;

~dp.set_pad(0, ~pg.clone);
~dp.set_pad(1, ~pg2.clone);
~rl.lib[\base] = ~dp.clone;

~drp = ~class_drumrack_proxy.new(~dp);

//~pat = ~dp.as_pattern(
//	Ppar([
//		Pbind(\midinote, 1, \dur, 1/4,  \legato, 0.2, \isRest, Pseq([1,0,1,0],inf).coin.not),
//		Pbind(\midinote, 0, \dur, 1/3*2, \legato, 0.2, \isRest, Pseq([1,1,1,0],inf).coin.not),
//	]),
//);
//~pat = ~dp.as_pattern(Pdef(\score));
//~pat = ~dp.as_pattern(Pbind(\midinote, Pseq([0,\r,1,1,0,0,0,1],inf), \dur, 1));

Pdef(\main, ~drp.as_pattern(Pdef(\score)).trace);
//Pdef(\main).play;

~dpv = ~class_drumrack_view.new(~drp);


)

(
Pdef(\score, 
	Pbind(\midinote, Pseq([0,0,1,1,4,4,4,4],inf), \dur, 1/4)
);
)

(
"/home/ggz/code/sc/seco/vlive/demo/param/lib/stepeditor.scd".load;
)
~dpv = ~class_drumrack_view.new(~drp);
~saveme = nil;
(
~sm = ~class_score_manager.new(4);

if(~saveme.isNil) { 
	~saveme = [~sm.banks, ~sm.superbank];
} {
	~sm.banks = ~saveme[0]; ~sm.superbank = ~saveme[1];
};

~sm.make_window;

Pdef(\score, Ppar(
	~sm.as_pattern.collect({ arg pat, x;
		Pbind(
			\whatthefuck, Pfunc{ arg ev; ev.debug("EV!!!"); \non },
			\isRest, pat.coin.not,
			\midinote, x,
			\dur, 1/4,
		).loop;
	})
).loop);
)
