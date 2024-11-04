
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
					self.score_selectors.views
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
	Pdef(\hlscore).play;
~make_score.(0).play

	(
	Pdef(\hlscore, 
		Pspawn(Pbind(
			\method, \par,
			\delta, 1 + 
				Pseq([
					Pseq([Pn(0,3), 1/4],4),
					Pseq([Pn(0,3), 1/2],4),
					Pseq([Pn(0,3), 1/8],4),
					Pseq([Pn(0,3), 1/7],4),
				],inf),
			//\score, Pseq(~hlseq.hlscores[~hlseq.current_score].debug("cursc==="),inf),
			\pattern, Prout({ arg ev; 
					Pseq([
						`Pbind(\degree, Pwhite(-3,0,16)*4+3, \scale, Scale.kurd, \dur, 1/4 ),
						`Pbind(\degree, Pwhite(7,-5,16)*2+3, \scale, Scale.kurd, \dur, 1/2+(1/4) ),
					],8).embedInStream;
					Pseq([
						`Pbind(\degree, Pwhite(-3,0,16)*7-4, \scale, Scale.kurd, \dur, 1/4 ),
						`Pbind(\degree, Pwhite(0,-5,16)*3, \scale, Scale.kurd, \dur, 1/4 ),
					],8).embedInStream;
					Pseq([
						`Pbind(\degree, Pwhite(-3,0,16)*4+2, \scale, Scale.kurd, \dur, 1/4 ),
						`Pbind(\degree, Pwhite(0,-5,16)*3+2, \scale, Scale.kurd, \dur, 1/4 ),
					],8).embedInStream;
					Pseq([
						`Pbind(\degree, Pwhite(-10,10,16), \scale, Scale.kurd, \dur, 1/4 ),
						`Pbind(\degree, Pseries(-10-10.rand,1+3.rand,16), \scale, Scale.kurd, \dur, 1/6 ),
					],8).embedInStream;
					Pseq([
						`Pbind(\degree, Pwhite(-10,10,16)*2, \scale, Scale.kurd, \dur, 1/4 ),
						`Pbind(\degree, Pseries(-10,2,16), \scale, Scale.kurd, \dur, 1/4 ),
					],8).embedInStream;

			}).collect({ arg x; x.value <> Pdef(Pbind()) }).loop,
		))
	).play;
	)

	(
	Pdef(\hlscore, 
		Pspawn(Pbind(
			\method, \par,
			\delta, 1 + Plazy({ arg ev;
				Pseq(
					ev[\xdelta][0].collect { arg xdelta;
						xdelta.debug("xdeltaa");
						Pseq([Pn(0,3), xdelta],4);
					}
				,inf);
			}),
			//\delta, 1,
			//\score, Pseq(~hlseq.hlscores[~hlseq.current_score].debug("cursc==="),inf),
			\pattern, Prout({ arg ev; 
					Pseq([
						`Pbind(
							//\degree, Plazy({ arg ev;
							//	ev.use {
							//		Pwhite(~white_min, ~white_max, ~white_repeat) * ~white_scale + ~white_add;
							//	};
							//},1),
							\degree, Pwhite(Pkey(\white_min), Pkey(\white_max), Pkey(\white_repeat)) * Pkey(\white_scale) + Pkey(\white_add);
							\scale, Scale.kurd, \dur, 1/4 
						) <> Predef(\inpat1, Pbind(
							\white_min, -3,
							\white_max, 0,
							\white_repeat, 16,
							\white_scale, 4,
							\white_add, 3,
						)),
						`Pbind(
							//\degree, Plazy({ arg ev;
							//	ev.use {
							//		Pwhite(~white_min, ~white_max, ~white_repeat) * ~white_scale + ~white_add;
							//	};
							//},1),
							\degree, Pwhite(Pkey(\white_min), Pkey(\white_max), Pkey(\white_repeat)) * Pkey(\white_scale) + Pkey(\white_add);
							\scale, Scale.kurd, \dur, 1/4 
						) <> Predef(\inpat2, Pbind(
							\white_min, -3,
							\white_max, 0,
							\white_repeat, 16,
							\white_scale, 4,
							\white_add, 3,
						)),
					],8).embedInStream;
				}).collect({ arg x; 
					x.value <> Ppredef(\inpatbinder, Pbind(
						\white_min, -3,
						\white_max, 0,
						\white_repeat, 16,
						\white_scale, 4,
						\white_add, 3,

						\white_min2, -3,
						\white_max2, 0,
						\white_repeat2, 16,
						\white_scale2, 4,
						\white_add2, 3,
					));
				}).loop,
		)
		<> Ppredef(\outpatbinder, Pbind(
			\xdelta, [[0,0,0,1/2]],
		))
	)
	).play;
	)

	(
	ParamGroup([
		Param(Pdef(\inpatbinder), \white_min, ControlSpec(-20,20,\lin,1)),
		Param(Pdef(\inpatbinder), \white_max, ControlSpec(-20,20,\lin,1)),
		Param(Pdef(\inpatbinder), \white_repeat, ControlSpec(1,32,\lin,1)),
		Param(Pdef(\inpatbinder), \white_scale, ControlSpec(1/8,8,\lin,1/8)),
		Param(Pdef(\inpatbinder), \white_add, ControlSpec(-8,8,\lin,1)),

		Param(Pdef(\inpatbinder), \white_min2, ControlSpec(-20,20,\lin,1)),
		Param(Pdef(\inpatbinder), \white_max2, ControlSpec(-20,20,\lin,1)),
		Param(Pdef(\inpatbinder), \white_repeat2, ControlSpec(1,32,\lin,1)),
		Param(Pdef(\inpatbinder), \white_scale2, ControlSpec(1/8,8,\lin,1/8)),
		Param(Pdef(\inpatbinder), \white_add2, ControlSpec(-8,8,\lin,1)),

		Param(Pdef(\outpatbinder), \xdelta, XArraySpec(ControlSpec(0,2,\lin,1/16)!4)),

	]).edit
	)

	(
	~make_gui = {
		var window = Window.new;
		var layout;
		layout = HLayout(*
			[
				Ppredef(\inpat1),
				Ppredef(\inpat2),
			].collect({ arg pat;
				ParamGroupLayout.two_panes(
					ParamGroup([
						Param(pat, \white_min, ControlSpec(-20,20,\lin,1)),
						Param(pat, \white_max, ControlSpec(-20,20,\lin,1)),
						Param(pat, \white_repeat, ControlSpec(1,32,\lin,1)),
						Param(pat, \white_scale, ControlSpec(1/8,8,\lin,1/8)),
						Param(pat, \white_add, ControlSpec(-8,8,\lin,1)),
					])
				)
			})
		);
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value;
	)


	~whiter = { arg xmin, xmax, repeat, scale, add;
		Pbind(
			\degree, Plazy({ arg ev;
				ev.use {
					Pwhite(xmin, xmax, ~white_repeat) * ~white_scale + ~white_add;
				};
			},1),
			\scale, Scale.kurd, \dur, 1/4 
		),
	
	};
	
	Ppredef(\inpat1, Pbind(
		\white_min, -3,
		\white_max, 0,
		\white_repeat, 16,
		\white_scale, 4,
		\white_add, 3,
	))

	Pdef(\hlscore).clear

	Ppredef(\hey, Pbind(\degree, 7)).trace.play;
	Ppredef(\hey).set(\degree, 2)
	Ppredef(\hey).unset(\degree)
	Ppredef(\hey).set(\freq, 800)
	Ppredef(\hey).unset(\freq)
	Ppredef(\hey).envir.parent = nil
	Ppredef(\hey).envir
	Ppredef(\hey).envir.proto
	Ppredef(\hey)
	().parent

	~ev = ();
	~pat = Pseq([~ev],inf) <> Pbind(\degree, Pseq([7]));
	~ev
	~ev[\degree] = nil
	~pat.play;

(Pn(( 'degree': 1  )) <> Pbind(\degree, 0)).play
(Pfunc(( 'degreex': 7  )) <> Pbind(\degree, 0)).play
(Pbind(\degree, 0) <> ( 'degree': 1  ) ).play
	(
	Pdef(\plop, Pbind(
		\instrument, \default,
		\bla, Pseq([7,8,9,2,3,4,5],inf),
		\degree, Prout{
			arg ev;

			Pseq([ev[\bla], 1, ev[\bla]],inf).embedInStream;

		}.trace,
		\dur, 1,
		\amp, 0.1
	)).play;
	);

	Pseq([1,2,3,4]).do({ arg x; "xx".postln })
	Pseq([1,2,3,4]).collect({ arg x; "xx".postln })

(
	p = Pspawn(Pbind(          
		\pattern, Prout { 
			var xa = 4.rand + 4;
			var xr = [1/16,0,1/12].choose;
			var xr2 = [1/6, 1/14,0].choose;
			Pseq([
				`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, xa), \dur, 0.125),
				`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, xa), \dur, 0.125 + xr),
				`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, xa), \dur, 0.125),
				`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, xa), \dur, 0.125),
				`Pbind(\degree, Pseries(0, -4, 4), \dur, 0.125),
				`Pbind(\degree, Pseries(0, -4, 4), \dur, 0.125),
				`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, xa), \dur, 0.125+xr2),
				`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, xa), \dur, 0.125),
			]).embedInStream
}.loop,    \delta, 4 * 0.125,    \method, \par)).play;
)

(
	p = Pspawn(Pbind(          
		\pattern, Prout { 
	Pseq([
		`Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, 4), \dur, 0.125),
		`Pbind(\degree, Pseries(0, -4, 4), \dur, 0.125),
	]).embedInStream
}.loop,    \delta, 16 * 0.125,    \method, \seq)).play;
)

	Scale.insp
	Scale.all
	Scale.dorian
	Scale.names
	Tuning.all

(
Pdef(\j, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

Window.closeAll

////////////// TODO
// step sequencer

- make an object which given a 
	- track count
	- delta
	- length
	can make an arbitrary number of score

	2d stage :
		- make a special step sequencer where each step is a score number
		- make a special step sequencer of higher level where each step is a special step sequencer
	3rd stage :
		- make a timeline where each row correspond to a score object (maybe allow to edit the clip which is the special step sequencer)
2nd step:
	can choose between step sequencer or pianoroll
	can set different delta and length for each track

- make a gui for this object
- give this object a list of event patterns

3rd step

