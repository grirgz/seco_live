
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
		
		self.scores = List.new;
		self.add_score;
	
		self;
	},

	add_score: { arg self;
		self.scores.add(
			self.track_count.do { arg x;
				self.add_row;
			}
		);
		self.refresh_grid;
	},

	add_row: { arg self;
		self.scores[self.current_score].add(
			List.newFrom(0!( self.score_duration/self.score_delta ))
		);
		self.refresh_grid;
	},

	remove_row: { arg self, x;
		self.scores[self.current_score].removeAt(x);
		self.refresh_grid;
	},

	refresh_grid: { arg self;
		if(self.score_select_view.notNil) {
			var val;
			val = self.score_select_view.value;
			self.score_select_view.items_( (1..self.scores.size) );
			self.score_select_view.value = val;
		};
		if(self.gridview.notNil) {
			self.gridview.layout = GridLayout.rows(*
				self.buttonrows = List.new;
				self.scores[self.current_score].collect({ arg score, x;
					[
						StaticText.new.string_("track "++(x+1)),
						XSimpleButton.new
						.action_({
							self.selected = x
						}),
						self.buttonrows.add(~make_sequencer_line.(score)); self.buttonrows.last,
					]
				})
			)
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

		);
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

);



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

