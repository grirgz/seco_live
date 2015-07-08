
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

~class_score_manager = (
	new: { arg self, track_count, delta=1/8, duration=1;
		self = self.deepCopy;
	
		self.score_delta = delta,
		self.score_duration = duration,
		
		self.scores = List.new;
		self.add_score;
	
		self;
	},

	add_score: { arg self;
		self.scores.add(
			List.newFrom(0!( self.score_duration/self.score_delta ))
		)
	},

	make_layout: { arg self;
		// TODO: find the file where I defined a widget which is a row of button corresponding to a Param(\list) and make it a Class
		VLayout(
			HLayout(
				PopUpMenu.new // score chooser
					.action_({ arg view;
						buttonrows[view.value].mapParam(self.scores[view.value])
					}),
				XSimpleButton.new.label_("+") // add
					.action_({

					}),
				XSimpleButton.new.label_("-") // delete
					.action_({

					}),
			),

			GridLayout.rows(*
				self.scores.collect({ arg score, x;
					[
						StaticText.new.string_("track "++(x+1)),
						ButtonRow.new.mapParam(score)
					]
				})
			)
		)


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

