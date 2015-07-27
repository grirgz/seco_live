
(
	// save
	~xsm = ~pss.scoreman;
	~xhlsm = ~pss.hlscoreman
)
(
	// load
	~pss.scoreman = ~xsm;
	~pss.hlscoreman = ~xhlsm;
)

(
	// final concept class
	~class_par_step_sequencer = (
		new: { arg self, tracks;
			self = self.deepCopy;
		
			self.tracks = tracks;
			self.proxy = EventPatternProxy.new ! tracks.size;
			self.mode = \step; // [\steps, part, song]
			self.scoreman = ~class_score_manager.new(self.tracks.size);
			self.hlscoreman = ~make_hl_seq.new(self.scoreman);
			
			self;
		},

		set_mode: { arg self, mode;
			self.mode = mode;
		},
		

		make_layout: { arg self;
			self.mode_layout = HLayout(
				XSimpleButton.new.label_("step")
					.action_({
						self.set_mode(\step)
					}),
				XSimpleButton.new.label_("part")
					.action_({
						self.set_mode(\part)
					}),
				XSimpleButton.new.label_("song"),
			);

			self.layout = VLayout(
				self.scoreman.make_layout,
				self.hlscoreman.make_layout,
				self.mode_layout,
			);

			self.layout;
			
		},

		make_window: { arg self;
			var window = Window.new;
			var layout;
			layout = self.make_layout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
			
		},

		edit: { arg self;
			
			self.make_window;
		},

		do_play: { arg self;
			Ppar
			
		},

		make_score_pattern: { arg self, scoreidx, trackidx;
			var sm = self.scoreman;
			[scoreidx, trackidx].debug("make_score_pattern");
			Pseq([

				Pbind(
					\isRest, Plazy({
						"new row".debug("new row");
					[scoreidx, trackidx, sm.scores[scoreidx]].debug("scores at ");
						Pseq(sm.scores[scoreidx][trackidx].debug("whatttttt")).coin.not;
					}),
					\dur, 1/8,
				);
			])
		},

		as_pattern: { arg self, idx;
			self.proxy[idx].source = Prout({ arg ev;
				var sm = self.scoreman;
				var hlseq = self.hlscoreman;
				switch(self.mode,
					\step, {
						"embeding step".debug;
						ev = self.make_score_pattern(sm.current_score, idx).embedInStream(ev);
					},
					\part, {
						"embeding part".debug;
						ev = Pspawn(Pbind(
							\method, \seq,
							//\legato, 1,
							\delta, 0,
							\score, Plazy({
								Pseq(hlseq.hlscores[hlseq.current_score].debug("cursc==="), 1);
							}),
							\pattern, Pfunc({ arg ev; 
								self.make_score_pattern(ev[\score], idx)
							}),
						)).embedInStream(ev);


					}, {
						"embeding useless shit".debug;
						Pbind(
							\insrument, \default,
							\degree, Pseq([0,1,2,3,2,1,0,20,21,22],2),
							\dur, 1/8,
						).embedInStream;
					},
				)
			}).repeat(130)
			
		},
	);


	// final concept usage
	~pss = ~class_par_step_sequencer.new([
		Pdef(\plop1),
		Pdef(\plop2),
		Pdef(\plop3),
	]);
	~pss.scoreman = ~xsm;
	~pss.hlscoreman = ~xhlsm;
	//~pss.asPattern(0);

SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01,1.001, 1+0.1.rand]);
	sig = RLPF.ar(sig, \lpf.kr(400), \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\plop1, ~pss.as_pattern(0) <> Pbind(
	\instrument, \plop,
	//\degree, Pseq([0,4,5,8],inf),
	\degree, 1,
	\legato, 1/4,
	\dur, 1/8,
	\amp, 0.1
));

Pdef(\plop2, ~pss.as_pattern(1) <> Pbind(
	\instrument, \default,
	//\degree, Pseq([0,2],inf),
	\degree, 4,
	\octave, 3,
	\legato, 1/4,
	\dur, 1/4,
	\amp, 0.1
));

Pdef(\plop3, ~pss.as_pattern(2) <> Pbind(
	\instrument, \default,
	//\degree, Pseq([0,7,7,7,7,2],inf),
	\degree, Pseq([7,8],inf),
	\octave, 4,
	\legato, 1/6,
	\dur, 1/4,
	\amp, 0.3
));

~pss.edit;

Pdef(\main, Ppar([
	Pdef(\plop1),
	Pdef(\plop2),
	Pdef(\plop3),
])).play;


)


// (at:{arg self; self+100}).at(5) // at dont work in events


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

~tracks = [
	Pdef(\plop1),
	Pdef(\plop2),
	Pdef(\plop3),
];

//~tracks[2].play;

~make_timeline_sequencer = { arg tracks;
	var window = Window.new;
	var layout;
	layout = GridLayout.rows(*
		tracks.collect({ arg track;
			var el;
			el = EventList.new;
			el.start;
			el.finish(1);
			[
				XSimpleButton.new.label_("track"+track.key),
				TimelinePreview.new.mapEventList( el ).view
			]
		
		})
	);
	layout.setColumnStretch(1,1);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
	
};
//~make_sequencer.( ~tracks );

~make_sequencer_line = { arg param;
	var butlist;
	var mapParam;
	HLayout(*
		butlist = param.collect({ arg subparam;
			subparam.asButton;
		})
	).addUniqueMethod(\mapParam, { arg param;
		butlist.do { arg but, n; 
			but.mapParam(param.at(n));
		}
	})
};

~class_score_manager = (
	new: { arg self, track_count, delta=1/8, duration=1;
		self = self.deepCopy;
	
		self.score_delta = delta;
		self.score_duration = duration;
		self.current_score = 0;
		self.track_count = track_count ? 4;
		self.selected = 0;
		
		self.scores = List.new;
		self.add_score;

	
		self;
	},

	add_score: { arg self;
		self.scores.add(List.new);
		self.current_score = self.scores.size-1;
		self.track_count.do { arg x;
			self.add_row;
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
		self.current_score = x;
	},

	refresh_grid: { arg self;
		if(self.score_select_view.notNil) {
			var val;
			//val = self.score_select_view.value;
			self.score_select_view.items_( (1..self.scores.size) );
			self.score_select_view.value = self.current_score;
		};
		self.selected = self.selected.clip(0, self.scores[self.current_score].size-1);
		if(self.gridview.notNil) {
			self.select_row_buttons = List.new;
			self.buttonrows = List.new;
			self.scores.debug("scores");
			self.current_score.debug("curscore");

			self.gridview.removeAll;
			self.gridview.layout = GridLayout.rows(*
				self.scores[self.current_score].debug("scores").collect({ arg score, x;
					[
						StaticText.new.string_("track "++(x+1)),

						self.select_row_buttons.add(
							XSimpleButton.new
								.background_({
									if(self.selected == x) {
										Color.yellow;
									} {
										Color.white;
									}
								}.value)
								.maxWidth_(10)
								.action_({
									self.old_selected = self.selected ? 0;
									self.selected = x;

									self.select_row_buttons[self.old_selected].background_(Color.white);
									self.select_row_buttons[self.selected].background_(Color.yellow);
								})
						); 
						self.select_row_buttons.last,

						self.buttonrows.add(~make_sequencer_line.(Param(score, \list, \unipolar)));
						self.buttonrows.last,
					]
				})
			);
		}
	},

	make_layout: { arg self;
		// TODO: find the file where I defined a widget which is a row of button corresponding to a Param(\list) and make it a Class
		var buttonrows;
		var gridlayout;
		var layout;
		layout = VLayout(
			HLayout(
				self.score_select_view = PopUpMenu.new // score chooser
					.items_( (1..self.scores.size) )
					.action_({ arg view;
						//buttonrows[view.value].mapParam(self.scores[self.current_score][view.value])
						self.current_score = view.value;
						self.refresh_grid;
					});
					self.score_select_view,
				XSimpleButton.new.label_("t+") // track add
					.action_({
						self.add_row;
					}),
				XSimpleButton.new.label_("t-") // track delete
					.action_({
						self.remove_row(self.selected);
					}),
				XSimpleButton.new.label_("s+") // score add
					.action_({
						self.add_score;
					}),
				XSimpleButton.new.label_("s-") // score delete
					.action_({
						self.remove_score(self.current_score);
					}),
			),

			self.gridview = View.new; self.gridview, // seq grid
			nil

		);
		//self.gridview.layout = VLayout(
		//	XSimpleButton.new.label_("what"),
		//	XSimpleButton.new.label_("what"),
		//);
		//self.gridview.removeAll;
		//self.gridview.layout = VLayout(
		//	XSimpleButton.new.label_("whxat"),
		//	XSimpleButton.new.label_("whxat"),
		//);
		self.refresh_grid;

		layout;

	},

	make_window: { arg self;
		var window = Window.new;
		var layout;
		layout = self.make_layout;
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}
);

~sm = ~class_score_manager.new;
~sm.make_window;

~selector = (
	selected_color: Color.red,
	deselected_color: Color.yellow,
	new: { arg self, selector_count=8, action;
		self = self.deepCopy;
	
		"aA.".debug;
		self.selector_count = selector_count;
		self.selected_index = 0;
		
		self.views = selector_count.collect({ arg x;
			XSimpleButton.new
				.minWidth_(15) 
				.action_({
					self.select_item(x);
					action.(x);
				})
				.background_(self.deselected_color).debug("WWWTTTFF");
		}).debug("WTF");
	
		"xr.".debug;
		self.views.debug("wtf");
		self.debug("self!!!");
		self;
	},

	select_item: { arg self, x;
		self.views[self.selected_index].background_(self.deselected_color);
		self.views[x].background_(self.selected_color);
		self.selected_index = x;
	},

	selected_view: { arg self;
		self.views[self.selected_index]
	},

);

///// higher level sequencer
~make_hl_seq = (
	new: { arg self, score_man;
		self = self.deepCopy;
	
		self.scores = { score_man.scores };
		self.step_count = 8;
		self.hlscores = List.new;
		self.selector_count = 8;
		self.selector_count.do {
			self.hlscores.add(0 ! self.step_count);
		};
		self.current_score = 0;
		self.score_count = 8;
	
		self;
	},

	make_layout: { arg self;
		self.views = self.step_count.collect({
			PopUpMenu.new
		}); 
		self.score_selectors = ~selector.new(self.selector_count, { arg x; self.select_score(x) });
		self.score_selectors.debug("1ca");
		self.score_selectors.views.debug("views");
		self.score_selectors.views.do({ arg view, x; view.label_(x+1) });
		self.layout = VLayout(
			XSimpleButton.new.label_("Refresh")
				.action_({
					self.refresh_score;
				}),
			HLayout(*
				self.views
				++
				[HLayout(*

					self.score_selectors.views
				).spacing_(1)]
			);
		);
		self.refresh_score;
		self.layout;
	},

	select_score: { arg self, x;
		self.current_score = x;
		self.refresh_score;
	},

	refresh_score: { arg self;
		var alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		var items;
		alpha = alpha.as(Array).collect({ arg x; x.asString });
		items = alpha.keep(self.scores.size);
		self.views.do { arg view, x;
			view.items = items;
			view.value = self.hlscores[self.current_score][x];
			view.action = { arg view;
				"fuck".debug;
				self.hlscores[self.current_score][x] = view.value;
				self.refresh_score;
			};
		}
	},

	make_window: { arg self;
		var window = Window.new;
		var layout;
		layout = self.make_layout;
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}
);
~hlseq = ~make_hl_seq.new(~sm);
~hlseq.make_window;

~tracks = [
	Pdef(\plop1, Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1
	)),
	Pdef(\plop2, Pbind(
		\instrument, \default,
		\degree, Pseq([1],inf),
		\dur, 1,
		\amp, 0.1
	)),
	Pdef(\plop3, Pbind(
		\instrument, \default,
		\degree, Pseq([3],inf),
		\dur, 1,
		\amp, 0.1
	)),
	Pdef(\plop4, Pbind(
		\instrument, \default,
		\degree, Pseq([5],inf),
		\dur, 1,
		\amp, 0.1
	)),
];

Pdef(\score, Ppar(
	~tracks.collect({ arg pat, x;
		Pbind(
			\isRest, Plazy({
				Pseq(~sm.scores[~sm.current_score][x].debug("whatttttt")).coin.not;
			}),
			\dur, 1/4,
		) <> pat;
	})
).loop);

~make_score = { arg curscore;
	Ppar(
		~tracks.collect({ arg pat, x;
			Pbind(
				\isRest, Plazy({
					Pseq(~sm.scores[curscore][x].debug("xwhatttttt")).coin.not;
				}),
				\dur, 1/4,
			) <> pat;
		})
	)
};

Pdef(\hlscore, 
	Pspawn(Pbind(
		\method, \seq,
		\delta, 1,
		\score, Pseq(~hlseq.hlscores[~hlseq.current_score].debug("cursc==="),inf),
		\pattern, Plazy({ arg ev; ~make_score.(ev[\score]) }),
	))
);

Pdef(\score).play;
//Pdef(\hlscore).play;

)

////////////////////////////////////////////// draft

(
	{

	var window = Window.new;
	var layout;
	layout = HLayout(
	//XSimpleButton.new.label_("1")
	Button.new.states_([["1"]]),
	Button.new.states_([["1"]]),
	Button.new.states_([["1"]]),
	Button.new.states_([["1"]]),
	Button.new.states_([["1"]]),
		
	);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;

	}.value;
)


(
	~bla = [1,2,5,4];
Pdef(\plop, Pbind(
	\instrument, \default,
	//\degree, PLseq(\bla),
	\freq, ~a.asPattern.loop,
	\freq, Pseq([~a, ~b],inf),
	\freq, Pseq([~lol.at(0), ~lol.at(1)]),
	\dur, 1,
	\amp, 0.1
)).play;
);


~a = StepList.new
~a = StepList[1, 2, 3, 5];
~a.edit
~a.addAll([1,2,3])
~b = StepList[100,500,300];

~lol = { [StepList.new, StepList.new] } ! 8;

(
WindowLayout({
	var current_score = 0;
	~lol.
	VLayout(
		StepListView.new,
		StepListView.new,
	)
	~pv = PagerView(~lol, { arg page;
		page.do { arg li, x;
			layout[x].map
		
		}
		stepSeq.mapParam(page[0])

		VLayout(
			Param(page[0], \list, \freq).asView,
			Param(page[1], \list, \freq).asView,
		)
	});
	VLayout(
		~pv.kk
		~pv,
	)

})
)

~a = VLayout(Button.new,StaticText.new)
~a.children
~

(
WindowLayout({
	~xv = XVLayout(
		Button.new,
		Button.new,
	);
	~xv.list.debug("list");
	~xv;

})
)

~lol
P
Pdef

(
ParamGroup([
	Param(~a, \list, \freq),
	Param(~b, \list, \freq),
]).edit;
)

~banka = StepSeqBank.new;
~bankb = StepSeqBank.new;

SLSelect.new

(
WindowLayout({
	VLayout(
		Param(~a, \list, \freq).asView,
		Param(~b, \list, \freq).asView,
	)
})
)
WindowDef
~b
~p = Param(~b, \list, \freq)
~p.edit
~p.spec
~p.wrapper

(
	~bla = [1,2,5,4];
Pdef(\plip, Pbind(
	\instrument, \default,
	//\degree, PLseq(\bla),
	//\freq, ~a.asPattern.loop,
	//\freq, Pseq([~a, ~b],inf),
	//\freq, Pseq([~lol.at(0), ~lol.at(1)]),
	\dur, 1,
	\amp, 0.1
)).trace.play;
);
Pdef(\plip).set(\freq, Pseq([100,200,500],inf))


(
Instr(\bla, { arg val=3, val2=10;
	[val, val2].debug("val");
	SynthDef(\bla, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(freq ! val);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp).flop;
		Out.ar(out, sig);
	}).add;
	
})
)
Instr(\bla).value()
Instr(\bla).set(3)

///////////////////////////// EventSeq

(
Pdef(\plop, 
	~es <>
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1
	)
).play;
);

~es = EventSeq.new(Pdef(\plop));
~es.edit;

EventSeqBank.new(
	
)

////////////////////////

- for StepList, there is no bank, only preset because they can be grouped in ParamGroup
- EventSeq


/////////////////////

~a = 1;

~a.dump


Pbindef

Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1
		).play

		a
		b
		~b

(
Pdict(
	(
		hel: Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1/4,
			\amp, 0.1
		),
		llo: Pbind(
			\instrument, \default,
			\freq, 400,
			\dur, 1/4,
			\amp, 0.1
		)
	),
	Pseq([\g, \llo]).trace
).trace.play
)

\g.asPattern.asStream.nextN(10)

(
Pdef(\plop, 
	Pseq([
		Pbind(
			\instrument, \default,
			\limit, Pn(1,128-16),
			\degree, Pseq(#[c, e, g, c],inf),
			\root, Pwhite(0,-8).stutter(32),
			\mtranspose, Pwhite(-8,8).stutter(8),
			\dur, 1/8,
			\isRest, Pwrand([0,1], [0.1,1],inf).coin.not,
			\legato, Pwhite(0.1,1.2),
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\limit, Pn(1,16),
			\degree, Pseq(#[e],inf),
			\root, Pwhite(0,-8).stutter(32),
			\mtranspose, Pwhite(-8,8).stutter(8),
			\dur, 1/8,
			\isRest, Pseq([1,0,1,0],inf).coin.not,
			\legato, Pwhite(0.1,1.2),
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\limit, Pn(1,128-16),
			\degree, Pwalk(#[c, e, g, c],1, Prand([-1,1],inf).stutter(Pwhite(1,10))),
			\root, Pwhite(0,-8).stutter(32),
			\mtranspose, Pwhite(-8,8).stutter(8),
			\dur, 1/8,
			\isRest, Pwrand([0,1], [0.1,1],inf).coin.not,
			\legato, Pwhite(0.1,1.2),
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\limit, Pn(1,16),
			\degree, Pseq(#[c],inf),
			\root, Pwhite(0,-8).stutter(32),
			\mtranspose, Pwhite(-8,8).stutter(8),
			\dur, 1/8,
			\isRest, Pseq([1,0,1,0],inf).coin.not,
			\legato, Pwhite(0.1,1.2),
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pwalk(#[c, e, g, c],1, Prand([-1,1],inf).stutter(Pwhite(1,10))) +
				Pseq([Pn(0,64),
					Prand([
						0,
						[0,2,3],
					],inf)
				]),
			\root, Pwhite(0,-8).stutter(32),
			\mtranspose, Pwhite(-8,8).stutter(8),
			\dur, 1/8,
			\isRest, Pwrand([0,1], [0.1,1],inf).coin.not,
			\legato, Pwhite(0.1,1.2),
			\amp, 0.1
		)

	])
).play;
);

(
	Pdef(\bla,
	Pbind(
		\instrument, \default,
		\degree, Pwalk(#[c, e, g, c],1, Prand([-1,1],inf).stutter(Pwhite(1,10))) +
			Pseq([Pn(0,64),
				Prand([
					0,
					[0,2,3],
				],inf)
			]),
		\root, Pwhite(0,-8).stutter(32),
		\mtranspose, Pwhite(-8,8).stutter(8),
		\dur, 1/8,
		\isRest, Plazy({
			Pwrand([0,1], [~rest,1 - ~rest],1).coin.not;
		}).loop,
		\legato, Pwhite(0.1,1.2),
		\amp, 0.1
	)
).play;
)
(
~rest = 0.0;
~list = [100,200,300,400,500];
	Pdef(\bla,
		Pdef(\hey, Pbind()) <>
	Pbind(
		\instrument, \default,
		\degree, Pwalk(#[c, e, g, c],1, Prand([-1,1],inf).stutter(Pwhite(1,10))) +
			Pseq([Pn(0,64),
				Prand([
					0,
					[0,2,3],
				],inf)
			]),
			\freq, Plazy({
				Pseq(~list)
			}).loop,
		\root, Pwhite(0,-8).stutter(32),
		\mtranspose, Pwhite(-8,8).stutter(8),
		\dur, 1/2,
		\isRest, Plazy({
			Pwrand([0,1], [~rest,1 - ~rest],1).coin.not;
		}).loop,
		\legato, Pwhite(0.1,1.2),
		\amp, 0.1
	)
).play;
)
~list

~rest
Param(currentEnvironment, \rest, \unipolar).edit
Param(currentEnvironment, \list, XArraySpec(\freq!5)).edit
Param(currentEnvironment, \list, XArraySpec(\freq!5)).at(0)
(
	ParamGroup([
		Param(Pdef(\hey), \dur, ControlSpec(1/8,2,\lin,1/8)),
		Param(currentEnvironment, \rest, \unipolar),
		Param(currentEnvironment, \list, XArraySpec(\freq!5)),

	]).edit
)
v = VarGui([\rest, \unipolar]).gui;
VarGui

(e = (    a: Pbind(\dur, 0.1, \degree, Pseq([0, 5, 4, 3, 2])),    b: Pbind(\dur, 0.06, \degree, Pseq([7, 8, 7, 8])),    c: Pbind(\dur, 0.3, \degree, Pseq([0, 1, 2], 2)));
x = Pdict(e, Pseq([            \a, \b,            Prand([\a, \c])        ], 4)    );x.play;)



(
	e = (    a: Pbind(\dur, 0.1, \degree, Pseq([0, 5, 4, 3, 2])),    b: Pbind(\dur, 0.06, \degree, Pseq([7, 8, 7, 8])),    c: Pbind(\dur, 0.3, \degree, Pseq([0, 1, 2], 2)));
x = Pdict(e, Pseq([            \a, \b,            Prand([\a, \c])        ], 4)    );x.play;
)


{ SinOsc.ar(200) ! 2 * 0.1}.play;


(
Pdef(\rah, 
	Pbindef(\hey, \bla, 1) <>
	
	Pbind(
	\instrument, \default,
	\degree, Pseq([0,12,2,3],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

Pbindef(\rah, \degree, 1)
Pbindef(\rah, \degree, nil)

Pbindef(\hey, \degree, 1)
Pbindef(\hey, \degree, 0)
Pbindef(\hey, \degree, nil)


Pdefn(\ctran, 1)
(
Pdef(\xplop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		0,0,1,0.1, 0,0,0.8,1,
		0,1,0,1,
	],inf).coin.not,
	\mtranspose, Pdefn(\ctran),
	\legato, 0.1,
	\sustain, 0.01,
	\dur, 1/12*2,
	\amp, 0.1
)).play;
Pdef(\xlba, Pbind(
	\instrument, \default,
	\degree, Pseq([
		-3,-5,-7
	],inf).stutter(2),
	\isRest, Pseq([
		1,0,
		1,0,
		1,0,
		1,0,
		1,1,
	],inf).coin.not,

	\mtranspose, Pdefn(\ctran),
	\legato, 0.1,
	\sustain, 0.01,
	\dur, 1/24,
	\amp, 0.1,
	\amp, Pseq([
		0.3,1,0.5,
	],inf) * 0.1,
)).play;
Pdef(\xcri, Pbind(
	\instrument, \default,
	\degree, Pseq([
		2,2,2,4,
	],inf),
	\isRest, Pseq([
		1,1,1,
		1,1,1,
		1,1,1,

		0,0,0,
		0,0,0,
		0,0,0,

		0,0,0,
		0,0,0,
		0,0,0,
	],inf).coin.not,

	\mtranspose, Pdefn(\ctran),
	\legato, 0.1,
	\sustain, 0.01,
	\dur, 1/12/2,
	\amp, 0.1,
	\amp, Pseq([
		0.3,1,0.5,
	],inf) * 0.1/2,
)).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \boom,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		0,0,1,0.1, 0,0,0.8,1,
		0,1,0,1,
	],inf).coin.not,
	\mtranspose, Pdefn(\ctran),
	\legato, 0.1,
	\sustain, 0.01,
	\dur, 1/12,
	\amp, 0.1,
)).play;
Pdef(\lba, Pbind(
	\instrument, \boom,
	\start, 800,
	\nstart, 15000,
	\nend, 10000,
	\env, Pseq([
		[ Env([0,1,0],[0.01,1.8].normalizeSum, 0) ],
	],inf),
	\nsustain, 0.1,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
		[ Env.adsr(0.1,0.1,0.8,0.2) ],
	],inf),
	\degree, Pseq([
		-3,-5,
	],inf).stutter(2),
	\isRest, Pseq([
		1,0,
		1,0,
		1,0,
		1,0,
		1,1,
	],inf).coin.not,

	\mtranspose, Pdefn(\ctran),
	\legato, 0.1,
	\sustain, 0.01,
	\dur, 1/24,
	\amp, 0.1,
	\amp, Pseq([
		0.3,1,0.5,
	],inf) * 0.4,
)).play;
Pdef(\cri, Pbind(
	\instrument, \boom,
	\start, 100,
	\nstart, 15000,
	\nend, 10000,
	\degree, Pseq([
		2,2,2,4,
	],inf),
	\isRest, Pseq([
		1,1,1,
		1,1,1,
		1,1,1,

		0,0,0,
		0,0,0,
		0,0,0,

		0,0,0,
		0,0,0,
		0,0,0,
	],inf).coin.not,

	\mtranspose, Pdefn(\ctran),
	\legato, 0.1,
	\sustain, 0.01,
	\dur, 1/12/2,
	\amp, 0.1,
	\amp, Pseq([
		0.3,1,0.5,
	],inf) * 0.1/2*1,
)).play;
);

(
SynthDef(\boom, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, doneAction=2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(XLine.kr(\start.kr(4400),\end.kr(10),\len.kr(0.01)));
	sig = BRF.ar(sig, \start.kr,1.9);
	sig = LPF.ar(sig, \start.kr/8);
	sig1 = WhiteNoise.ar(1);
	sig1 = LPF.ar(sig1, Line.kr(\nstart.kr(10000),\nend.kr(5000),\nlen.kr(0.1/2)),0.1);
	sig1 = HPF.ar(sig1, 100);
	sig1 = sig1 * EnvGen.kr(\env.kr(Env([0,2,0],[0.01,0.8].normalizeSum, -2)), gate, timeScale:\nsustain.kr(0.5));
	sig1 = sig1 * 0.5;
	sig = sig + sig1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

TempoClock.default.tempo = 0.27
1/0.27*60

(
Pdef(\boom, Pbind(
	\instrument, \boom,
	\degree, Pseq([0],inf),
	\sustain, 0.1,
	\dur, 1/6,
	\amp, 0.1
)).play;
);


~b = Buffer.read(s, "/usr/local/bin/sclang")



		(	// define a conductor using the default controlspecs

			Conductor.specs[\spT] = ControlSpec(-60, 700, 'linear', 0, 33);

			a = Conductor.make{ | con, freq1, db, pan, dur, spT3, s3pT, sp3T|	

				con.name_("example 1");

				con.pattern_(Pbind(*[freq: freq1, db: db, pan: pan, dur: dur]) );

			};

			a.show;

		)

		(

			a.play;

			a[\freq].value = 700;

		)

	


(	
	a = Conductor.new;										// create the conductor

		

		a.addCV(\cv1);											// add some CVs

		a.addCV(\cv2);

		a.addCV(\cv3);

	

		w = a.show; 
		defer( { Document.current.front}, 0.05);	// display it

)		

(	
	a[\cv1]	.sp(440, 20, 20000, 0, 'exp');			// set the range of cv1

		a[\cv2]	.sp(0.1, 0.01, 1, 0, 'exp');			// now cv2

)		

(
	w.close;												// close the display window

		defer({

			a[\cv3].value = 1/(1..128);						// and change cv3 to represent an array

			w = a.show	

		}, 0.1);												// and show it now

)		

(		w.close;

		defer({

			a.useInterpolator;										// add the use of an interpolator

			a[\cv3].value = 1/(1..128); 			a.preset.addPreset;	// save some presets

			a[\cv3].value = 1/(1..128).reverse; 	a.preset.addPreset;

			a.preset.presetCV.value_(0);

			w = a.show;   


		}, 0.1);

)		

(

		Task { 													// interpolate between the presets

			loop {

				a.preset.targetCV.value_(1);

				100.do {|  i | a.preset.interpCV.value_(i/100); 0.01.wait };

				a.preset.targetCV.value_(0);

				100.do {|  i | a.preset.interpCV.value_(i/100); 0.02.wait }; 

			}

		}.play(AppClock);

)

		w.close;

	

		(

		// Changing CV ranges

			c = Conductor.make { |conductor, a, b, c, d | 

				a	.spec_(\freq);

				b	.spec_(\freq, 880);

				c	.sp(1, 0, 15, 1);

				d	.spec_(\unipolar,1/(1..128));

			};    

			c.show;

		)




		Event.addEventType(\pdef, {
			~object.play;
		})

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);
		
		(
		a = (
			type: \pdef,
			object: Pdef(\plop),
			finish: {
				Pdef(\plop).stop
			}
		).play
	)
	a.stop

		(
		a = Pbind(
			\instrument, \default,
			\finish, {
				"pooooooooooooooo".debug;
				
			},
			\freq, 200,
			\dur, 1,
			\amp, 0.1
		).play;
		)
