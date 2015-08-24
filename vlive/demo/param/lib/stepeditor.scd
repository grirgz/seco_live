(
"/home/ggz/code/sc/seco/vlive/demo/param/lib/base.scd".load;
"Init stepeditor.scd".postln;

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

~tracks = [
	Pdef(\plop1),
	Pdef(\plop2),
	Pdef(\plop3),
];

//~tracks[2].play;

//~make_sequencer.( ~tracks );

//~selector = (
//	selected_color: Color.red,
//	deselected_color: Color.yellow,
//	new: { arg self, selector_count=8, action;
//		self = self.deepCopy;
//	
//		"aA.".debug;
//		self.selector_count = selector_count;
//		self.selected_index = 0;
//		
//		self.views = selector_count.collect({ arg x;
//			XSimpleButton.new
//				.minWidth_(15) 
//				.action_({
//					self.select_item(x);
//					action.(x);
//				})
//				.background_(self.deselected_color).debug("WWWTTTFF");
//		}).debug("WTF");
//
//		self.select_item(0);
//	
//		"xr.".debug;
//		self.views.debug("wtf");
//		self.debug("self!!!");
//		self;
//	},
//
//	select_item: { arg self, x;
//		self.views[self.selected_index].background_(self.deselected_color);
//		self.views[x].background_(self.selected_color);
//		self.selected_index = x;
//	},
//
//	selected_view: { arg self;
//		self.views[self.selected_index]
//	},
//
//);

~class_score_manager = (
	new: { arg self, track_count=4, delta=1/8, duration=1;
		self = self.deepCopy;
	
		self.score_delta = delta;
		self.score_duration = duration;
		self.selector_count = 8;
		self.banks = {BankList.new} ! track_count;
		self.superbank = BankList.newFrom(self.selector_count.collect({ 
			ParDictStepList.newFrom(0!8).dicts_(self.banks)
		}));
		self.track_count = track_count ? 4;
		self.selected = 0;
		self.banks.debug("wtf");
		
		self.add_score;

	
		self;
	},

	asArchiveData: { arg self;
		var data = ();
		[
			\score_delta,
			\score_duration,
			\track_count,
			\banks,
			\superbank,
		].collect({ arg x; data[x] = self[x] });

		(
			load: { arg self;
				var inst = ~class_score_manager.new;
				inst.putAll(self.data);
				inst.setStepSpec(self.spec);
				inst;
			},
			spec: self.getSpec(\list),
			data: data
		)
	},

	make_row: { arg self;
		StepList.newFrom(0!( self.score_duration/self.score_delta ))
			.addSpec(\list, this.getSpec(\list));
	},

	setStepSpec: { arg self, spec;
		self.banks.do { arg bank;
			bank.do { arg list;
				list.addSpec(\list, spec);
			}
		};
		self.addSpec(\list, spec);
	},

	add_score: { arg self;
		self.banks.do { arg bank;
			bank.add( self.make_row );
			bank.index = bank.size-1;
		};
		self.refresh_grid;
	},

	remove_score: { arg self;
		if(self.scores.size > 1) {
			self.scores.removeAt(self.current_score);
			self.current_score = self.current_score.clip(0, self.scores.size-1);
			self.refresh_grid;
		};

	},

	add_row: { arg self, pos;
		pos = pos ? self.current_score;
		( self.score_duration/self.score_delta ).debug("row size");
		self.scores[pos].add(
			List.newFrom(0!( self.score_duration/self.score_delta ))
		);
		self.refresh_grid;
	},

	remove_row: { arg self, x;
		self.scores[self.current_score].removeAt(x);
		self.selected = self.selected.clip(0, self.scores[self.current_score].size-1);
		self.refresh_grid;
	},

	select_score: { arg self, x;
		self.banks.do { arg bank;
			bank.index = x;
		};
	},

	as_pattern: { arg self;
		self.track_count.collect({ arg x;
			Prout({ arg ev;
				if(self.mode.isNil) {
					self.set_mode(\seq)
				};
				[x, self.mode, ev].debug("x, mode, ev");
				switch(self.mode,
					\seq, {
						self.banks[x].current.debug("current");
						ev = self.banks[x].current.embedInStream(ev);
					},
					\part, {
						block { arg break;
							self.superbank.current.asValuePattern.do({ arg val;
								val.debug("val=============");
								if(self.mode != \part) {
									break.value;
								};
								ev = self.banks[x][val].embedInStream(ev);
							});
						}
					},
					{
						ev = Pseq([1,1,5,5]).embedInStream(ev);
					}
				)
			})
		});
	},

	refresh_grid: { arg self;
		if(self.score_select_view.notNil) {
			var val;
			//val = self.score_select_view.value;
			self.score_select_view.items_( (0..self.banks[0].size-1) );
			self.banks.debug("bordel");
			self.score_select_view.value = self.banks[0].index;
		};
		self.selected = self.selected.clip(0, self.banks.size-1);
		if(self.gridview.notNil) {
			self.select_row_buttons = List.new;
			self.buttonrows = List.new;
			self.scores.debug("scores");
			self.current_score.debug("curscore");

			self.gridview.removeAll;
			self.gridview.layout = GridLayout.rows(*
				self.banks.collect({ arg bank, x;
					[
						StaticText.new.string_("track "++(x+1)),

						self.select_row_buttons.add(
							XSimpleButton.new
								.background_({
									if(self.selected == x) {
										ParamView.color_ligth;
									} {
										Color.white;
									}
								}.value)
								.maxWidth_(10)
								.action_({
									self.old_selected = self.selected ? 0;
									self.selected = x;

									self.select_row_buttons[self.old_selected].background_(Color.white);
									self.select_row_buttons[self.selected].background_(ParamView.color_ligth);
								})
						); 
						self.select_row_buttons.last,

						self.buttonrows.add( 
							StepListView.new(bank.current).addCursor({ arg view, x, param, val;
								var color = view.color;
								val.debug("val");
								color[0] = if(val.notNil and: {val > 0.5}) {
									ParamView.color_dark;
								} {
									ParamView.color_ligth;
								}; 
								view.color = color;
							}, { arg view;
								var color = view.color;
								color[0] = Color.clear;
								view.color = color;
							}) 
						);
						self.buttonrows.last.view,
					]
				})
			);
		}
	},

	make_layout: { arg self;
		// TODO: find the file where I defined a widget which is a row of button corresponding to a Param(\list) and make it a Class
		var buttonrows;
		var gridlayout;
		var scrollview;
		var layout;
		var mode_selector = ~selector.new(2, { arg x;
			self.set_mode([\seq, \part][x])
		});
		scrollview = ScrollView.new;
		self.gridview = View.new;
		scrollview.canvas = self.gridview;
		layout = VLayout(
			HLayout(
				PlayerWrapperView(Pdef(\score)).layout,
				self.score_select_view = PopUpMenu.new // score chooser
					.items_( (0..self.scores.size-1) )
					.action_({ arg view;
						//buttonrows[view.value].mapParam(self.scores[self.current_score][view.value])
						self.select_score(view.value);
						self.refresh_grid;
					});
					self.score_select_view,
				//XSimpleButton.new.label_("t+") // track add
				//	.action_({
				//		self.add_row;
				//	}),
				//XSimpleButton.new.label_("t-") // track delete
				//	.action_({
				//		self.remove_row(self.selected);
				//	}),
				XSimpleButton.new.label_("s+") // score add
					.action_({
						self.add_score;
					}),
				XSimpleButton.new.label_("s-") // score delete
					.action_({
						self.remove_score(self.current_score);
					}),
				mode_selector.views[0].label_("Seq"), // score add
				mode_selector.views[1].label_("Part"), // score add
			),

			[scrollview, stretch:1], // seq grid
			self.make_super_layout,
			nil

		);
		self.refresh_grid;

		layout;

	},

	set_mode: { arg self, mode;
		self.mode = mode;
	},

	select_super: { arg self, val;
		self.superbank.index = val;
	},

	make_super_layout: { arg self;
		self.superlistview = ParDictStepListView(self.superbank.current);
		self.superlistview.view.onChange(self.superbank, \index, {
			self.superlistview.mapStepList(self.superbank.current);
			self.superlistview.addCursor({ arg view;
				"-------------------popup cursor!!".debug;
				view.background = ParamView.color_ligth;
			}, { arg view;
				"deselex-------------------popup cursor!!".debug;
				view.background = Color.clear;
			});
		});
		self.superbank.changed(\index);
		
		self.score_selectors = ~selector.new(self.superbank.size, { arg x; self.select_super(x) });
		self.score_selectors.debug("1ca");
		self.score_selectors.views.debug("views");
		self.score_selectors.views.do({ arg view, x; view.label_(x) });
		self.super_layout = VLayout(
			XSimpleButton.new.label_("Refresh")
				.action_({
					self.refresh_score;
				}),
			HLayout(
				self.superlistview.view,
				HLayout(*
					self.score_selectors.views
				).spacing_(1)
			);
		);
		self.refresh_score;
		self.super_layout;
	},

	make_window: { arg self;
		var window = Window.new;
		var layout;
		layout = self.make_layout;
		window.layout = layout;
		window.onClose_({
			StepSeq.save;
		});
		//window.alwaysOnTop = true;
		window.front;
	}
);

//~sm = ~class_score_manager.new(4);
//if(~saveme.isNil) { 
//	~saveme = [~sm.banks, ~sm.superbank];
//} {
//	~sm.banks = ~saveme[0]; ~sm.superbank = ~saveme[1];
//};
//~sm.make_window;


//~tracks = [
//	Pdef(\plop1, Pbind(
//		\instrument, \default,
//		\degree, Pseq([0],inf),
//		\dur, 1,
//		\amp, 0.1
//	)),
//	Pdef(\plop2, Pbind(
//		\instrument, \default,
//		\degree, Pseq([1],inf),
//		\dur, 1,
//		\amp, 0.1
//	)),
//	Pdef(\plop3, Pbind(
//		\instrument, \default,
//		\degree, Pseq([3],inf),
//		\dur, 1,
//		\amp, 0.1
//	)),
//	Pdef(\plop4, Pbind(
//		\instrument, \default,
//		\degree, Pseq([5],inf),
//		\dur, 1,
//		\amp, 0.1
//	)),
//];
//
//Pdef(\score, Ppar(
//	~tracks.reverse.collect({ arg pat, x;
//		Pbind(
//			\isRest, ~sm.as_pattern[x].coin.not,
//			\dur, 1/4,
//		) <> pat;
//	})
//).loop);

//Pdef(\score).play;
//~sm.as_pattern[0].asStream.nextN(10, Event.default);

);

//Pdef(\score).play;
