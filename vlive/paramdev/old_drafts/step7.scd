
// TODO:
// - if 
(
	Please don't use this anymore, use step8.scd
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
			Ptuple([(isRest: true)])
		} {
			Ptuple(self.list.collect({ arg item;
				item.as_pattern;
			}))
		};
	},

	as_stream: { arg self;
		self.proxy.asStream;
	},
);


~class_drumpad = (
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
		var res = ~class_drumpad.new;
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

~class_drumpad_view = (
	new: { arg self, drumrack;
		self = self.deepCopy;
	
		self.set_drumrack(drumrack);
		
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
		self.drumrack = drumrack;
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
					};
					window.close;
					self.refresh_drumpreset_popup;
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
					};
					window.close;
					self.refresh_rackpreset_popup;
				}),
			)
			
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	load_rackpreset: { arg self, rackpreset;
		var rack = self.drumrack.rackpreset_lib.lib[rackpreset];
		self.set_drumrack(rack);
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
					self.load_rackpreset(rpp.items[rpp.value]);
				};
				rpp;
			}.value,
			XSimpleButton.new.label_("Save Rack").action_({
				self.make_save_rackpreset_window;
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
~dp = ~class_drumpad.new;
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
Pdef(\score, 
	Pbind(\midinote, Pseq([0,0,1,1,4,4,4,4],inf), \dur, 1/4)
);
~pat = ~dp.as_pattern(
	Ppar([
		Pbind(\midinote, 1, \dur, 1/4,  \legato, 0.2, \isRest, Pseq([1,0,1,0],inf).coin.not),
		Pbind(\midinote, 0, \dur, 1/3*2, \legato, 0.2, \isRest, Pseq([1,1,1,0],inf).coin.not),
	]),
);
~pat = ~dp.as_pattern(Pdef(\score));
//~pat = ~dp.as_pattern(Pbind(\midinote, Pseq([0,\r,1,1,0,0,0,1],inf), \dur, 1));

Pdef(\main, ~pat.trace);
//Pdef(\main).play;

~dpv = ~class_drumpad_view.new(~dp);


)

~dl.lib.keys.asArray.sort
~dl.lib.keys.asArray
~dl.lib["plop"]
~dp
~dp.pads[4].as_stream.nextN(5)
~dp.pads[4].update_proxy

~dpv.select_drumpad(0)
~dpv.select_drumpad(1)

(
~ev = (amp: 0.1, pan:0);
~pl = [
	Param(~ev, \amp, \amp),
	Param(~ev, \pan, \pan),
];
WindowLayout({
	HLayout(*
		~pl.collect({ arg param;
			VLayout(
				StaticText.new.mapParamLabel(param),
				Knob.new.mapParam(param),
				TextField.new.mapParam(param),
				//ParamView.knob.mapParam(param).fixedSize_(Point(200,200)).background_(Color.blue),
				ParamView.label_knob(param.property).mapParam(param),
			)
		})
	)

});
)

~ev = (amp: 0.1);
~ev = ();
Param(~ev, \amp, \amp).edit;






Pdef(\score, Pbind(\midinote, Pseq([1,0,2,0,1,1,0,1],inf), \dur, 1/4));
Pdef(\score, Pbind(\midinote, Pseq([1,0,4,4,4,4,4,1],inf), \dur, 1/4));
~pgstr = ~pg.as_stream
~pgstr.collect({ arg x; x.next(()) })
~pg.list
~p1.as_pattern
~p1.as_pattern
~p1.params <> ~p1.instr
Pseq([()],inf) <> ~p1.instr


(
			~pr = Prout({ arg ev;
				var pads = [
					Pbind(\degree, 7),
					Pbind(\degree, 3),
					Pbind(\degree, 9),
				];
				var score = Pbind(
					\isRest, Pseq([1,1,0,0,1,1,1,0],inf).coin.not,
					\dur, 1/4,
				);
				"what".debug;
				pads = pads.collect({ arg x; x.asStream; });
				score.debug("score");
				score.asStream.do({ arg scoreev;
					//scoreev.debug("scoreev");
					if(true) {
						var padevs;
						padevs = pads.collect({ arg str; str.next(()) });
						padevs.debug("padevs");
						padevs.collect{ arg padev, x;
							if(x == ( padevs.size-1 )) {
								ev = padev.composeEvents(scoreev).yield(ev);
							} {
								var sc = scoreev.copy;
								sc[\delta] = 0;
								ev = padev.composeEvents(sc).yield(ev);
							}
						};
					}
				}, ())

			});

			~pr.trace.play;


)

Pbind(\degree, 0).play
(
	Pbind(
		\isRest, Pseq([1,1,0,0,1,1,1,0],1).coin.not,
		\dur, 1/4,
	).asStream.do( { arg x;
		x.debug("X");
	
	}, ());
)

(bla:4).composeEvents((rah:43))



{ SinOsc.ar(200) ! 2 * 0.1}.play;




(

SynthDef(\cake, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1;
	env1 = EnvGen.kr(Env([1,2,1/2],[0.4,0.4]/4), 1);
	sig = LFSaw.ar(freq * env1 * [8,1,2,4]);
	sig = RLPF.ar(sig, freq * env1 * 2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;

a = Pbind(\degree, Pn(0,4));
b = Pbind(\degree, Pn(3,4));
c = Pbind(\degree, Pn(7,4));
d = Pbind(\degree, Pn(9,4));

//Pdef(\main,
//	Pbind(
//		\instrument, \cake,
//		\out, BusDef(\myfx, \audio)) <>
//	Pseq([
//		Ppar([a, b, c], 1), Ppar([b, c, d], 1), Ppar([a, c, d], 1)
//	], inf);
//).play;

Pdef(\main2,
	Pbind(
		\instrument, \default,
		\degree, Pwhite(1,9),
		\legato, 0.1,
		\octave, Pseq([3],inf).stutter(4),
		\dur, 1/2,
		\out, BusDef(\myfx, \audio)
	)
).play;

Ndef(\myfx, { arg inbus, freq=200, pan=0, amp=0.1;
	var sig;
	var isig;
	sig = In.ar(inbus, 2);
	isig = sig;
	//sig = sig + DelayL.ar(sig, 0.1,0.0001);
	//sig = sig + DelayL.ar(sig, 0.1,0.001);
	sig = sig + CombL.ar(sig, 0.1, 1/Tartini.kr(sig).flop[0].clip(60,18000),1.7);
	sig = LPF.ar(sig, 7500);
	sig = sig + CombL.ar(sig, 0.1, 1/Tartini.kr(sig).flop[0].clip(60,18000)/2,1.7);
	sig = sig * 1;
	//sig = sig.wrap2(0.4) + ( sig*0.2 );
	//sig = ( sig.abs < 1.0 ) * sig;
	sig = sig * 7;
	sig = sig.clip2(0.9);
	sig = sig * 7;
	sig = sig.clip2(0.9);
	sig = sig * 7;
	sig = sig.clip2(0.9);
	sig = sig * 7;
	sig = sig.clip2(0.9);
	sig = sig + CombL.ar(isig, 0.1, 1/Tartini.kr(isig).flop[0].clip(60,18000)/2,0);
	//sig = sig.clip2(0.8);
	//sig = sig * DelayL.ar(sig, 0.1,[0,0.001]).clip2(0.4);
	//sig = sig * sig.clip2(0.4);
	//sig = sig * (1+ sig.clip2(0.4) );
	//sig = sig * SinOsc.ar(Tartini.kr(sig).flop.debug("x")[0].poll);
	//sig = sig * SinOsc.ar(Tartini.kr(sig).flop.debug("x")[0].poll);
	//sig = sig * SinOsc.ar(Tartini.kr(sig).flop.debug("x")[0].poll);
	//sig = sig * SinOsc.ar(Tartini.kr(sig).flop[0]);
	//sig = sig * SinOsc.ar(Pitch.kr(sig).flop[0]);
	//sig = sig + (sig * SinOsc.ar(ZeroCrossing.ar(sig).debug("x").poll) * 0.4);
	sig = sig * 2;
	sig;
}).play;
Ndef(\myfx).set(\inbus, BusDef(\myfx, \audio));
)
Ndef(\myfx).clear

///////////////////////////////////////////////////// PdrumStep

(
	Pdef(\main,
	
		Ptrace(
			PdrumStep(
				[
					Pbind(\degree, 0, \dur, 1/8),
					Pbind(\degree, 4),
					Pbind(\degree, 8),
					Ptuple([
						Pbind(\degree, 8),
						Pbind(\degree, 5),
					]),
				], 
				Pbind(
					\midinote, Pseq([2,1,0,3,3,1,0,1,3,0],1),
					\dur, 1/4,
				),
				repeats:1
			)
			<>
			Pbind(
				\bla, Pseq((1..30),inf)
			)
		),
	).play;


)

///// out of bound

(
	Pdef(\main,
	
		Ptrace(
			PdrumStep(
				[
					Pbind(\degree, 0, \dur, 1/8),
					Pbind(\degree, 4),
					Pbind(\degree, 8),
					Ptuple([
						Pbind(\degree, 8),
						Pbind(\degree, 5),
					]),
				], 
				Pbind(
					\midinote, Pseq([2,2,1,0,13,13,13,13,13,13,13,13,0,0,0,3],inf),
					\dur, 1/4,
				),
				repeats:1
			)
			<>
			Pbind(
				\bla, Pseq((1..30),inf)
			)
		),
	).play;


)

///// Par

(
	Pdef(\main,
	
		Ptrace(
			PdrumStep([
				Pbind(\degree, 0, \dur, 1/8),
				Pbind(\degree, 4),
				Pbind(\degree, 8),
				Ptuple([
					Pbind(\degree, 8),
					Pbind(\degree, 5),
				]),
			], 
			Ppar([
				Pbind(
					\midinote, Pseq([2,0,1,0],inf),
					\isRest, Pseq([1,0.3,0.8,0.4],inf).coin.not,
					\dur, 1/8,
				), 
				Pbind(
					\midinote, Pseq([\r,\r,0,0,\r,2,0,\r,3,\r,1,3],inf),
					\legato, 0.1,
					\dur, 1/2,
				)
			])
			, repeats:10)
			<>
			Pbind(
				\bla, Pseq((1..30),inf)
			)
		),
	).play;


)

///// Pdef

(
	Pdef(\score, Pbind(\midinote, Pseq([0,1,2,3,4],inf), \dur, 1/4));
	Pdef(\main,
	
		Ptrace(
			PdrumStep([
				Pbind(\degree, 0, \dur, 1/8),
				Pbind(\degree, 4),
				Pbind(\degree, 8),
				Pdefn(\megakick, 
					Ptuple([
						Pbind(\degree, 8),
						Pbind(\degree, 5),
					]),
				)
			], 
			Pdef(\score),
			repeats:1)
			<>
			Pbind(
				\bla, Pseq((1..30),inf)
			)
		),
	).play;


)
				(
				Pdefn(\megakick, 
					Ptuple([
						Pbind(\degree, 8),
						Pbind(\degree, 2),
						Pbind(\degree, 1),
						Pbind(\degree, 5),
					]),
				)
				)

				(
				Pdefn(\megakick, 
					Ptuple([
						Pbind(\degree, 7),
						Pbind(\degree, 0),
						Pbind(\degree, 3),
					]),
				)
				)

	Pdef(\score, Pbind(\midinote, Pseq([1,0,3,3,100,1,0,\r,3],2), \dur, 1/4));

	Pfindur
