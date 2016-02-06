/////////////////// rand-n-step

( 
var w, buttons, data, synths, dims = [16,16], resolution = 4; 
w = Window("rand-n-step", Rect(50,250,dims[0]*22 + 10,dims[1]*22+10)); 

synths = Array.fill(dims[1], { |i|
	SynthDef('rstp'++i, {
		var sig = Pan2.ar(
			PMOsc.ar(80.exprand(10000), 1.exprand(200), 1.exprand(20)),
			-1.0.rand2,
			EnvGen.kr(Env(Array.rand(4, 0, 0.1.rrand(0.5)).add(0), Array.rand(3, 0.1, 0.3).add(0.1), -5.rrand(5)), doneAction: 2)
		);
		Out.ar(0, sig);
	}).add.name;
});

data = Array2D(dims[1],dims[0]);
buttons = Array.fill(dims[1], { |l|
	Array.fill(dims[0], { |i| 
		Button( w, Rect( 5 + (22*i), 5 + (22*l), 20, 20) ).states_([ ['-'], ['+'], ['%'] ]).action_({ |b| data[l,i] = b.value }); 
	})
}); 

AppClock.play({
	inf.do({|i|
		dims[1].do({ |l|
			(buttons[l] @@ i).font_(Font("sans", 20));
			(buttons[l] @@ (i-1)).font_(Font("sans", 14));
			switch( data[l,i.mod(dims[0])],
				1, { Synth(synths[l]) },
				2, { 0.5.coin.if({ Synth(synths[l]) }) }
			);  
		});
		(TempoClock.default.tempo.reciprocal / resolution).yield;
	});
}.asRoutine);
w.front; 
)

////////////////////////////////////////////////

(
SynthDef(\turtle, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(freq * (1..4)/2) * 1 ));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(900), \rq.kr(0.5));
	sig = DelayL.ar(sig, 0.1, (1..5)/\rdel.kr(1000)) + sig;
	sig = sig / 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.7),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
~dim = Point(32,12);
~data = { 0 ! ~dim.x } ! ~dim.y;
);

(
Pdef(\turtle,
	Ppar(
		~dim.y.collect({ arg note;
			Pbind(
				\instrument, \turtle,
				\note, Pseq([note],inf),
				//\isRest, Plazy({ Pseq(~data[note]).coin.not }).loop,
				\isRest, Prout({ 
					~dim.x.do { arg x;
						~data.changed(\pos, x);  
						~data[note][x].coin.not.yield;
					}
				}).loop,
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1
			)
		})
	)
).play;
)


(
~win = Window.new.front;
~font = Font("sans", 14);
~font_sel = Font("sans", 20);
~buttons = ~dim.y.collect({ arg y;
	~dim.x.collect({ arg x;
		var but = Button.new;
		but.maxSize = Point(20,20);
		but.states_([
			[ "-" ],
			[ "#" ],
		]);
		but.font = ~font;
		but.action_({
			~data[y][x] = but.value;
			~data[y].debug("set!");
		});
		but.value = ~data[y][x];
		but;
	});
});
if(~ctrl.notNil) { ~ctrl.remove };
~ctrl = SimpleController(~data).put(\pos, { arg me, msg, now;
	if(~win.isClosed) { 
		me.remove; 
	} {
		{
			~buttons.do({ arg row, y;
				[now, y].debug("now");
				row[now].font = ~font_sel;
				row.wrapAt(now-1).font = ~font;
			});
		}.defer;
	};
});
~win.layout = GridLayout.rows( * ~buttons ).spacing_(0);
)

(
/// add a slider to control rdel
~win = Window.new.front;
~font = Font("sans", 14);
~font_sel = Font("sans", 20);
~buttons = ~dim.y.collect({ arg y;
	~dim.x.collect({ arg x;
		var but = Button.new;
		but.maxSize = Point(20,20);
		but.states_([
			[ "-" ],
			[ "#" ],
		]);
		but.font = ~font;
		but.action_({
			~data[y][x] = but.value;
			~data[y].debug("set!");
		});
		but.value = ~data[y][x];
		but;
	});
});
if(~ctrl.notNil) { ~ctrl.remove };
~ctrl = SimpleController(~data).put(\pos, { arg me, msg, now;
	if(~win.isClosed) { 
		me.remove; 
	} {
		{
			~buttons.do({ arg row, y;
				[now, y].debug("now");
				row[now].font = ~font_sel;
				row.wrapAt(now-1).font = ~font;
			});
		}.defer;
	};
});
~win.layout = VLayout(
	GridLayout.rows(*
		[
			[\rdel, ControlSpec(100,10000)],
			[\rq, ControlSpec(0.1,0.9)],
			[\lpf, \freq],
		].collect({ arg param;
			[
				StaticText.new.string_(param[0]),
				Slider.new.orientation_(\horizontal).action_({ arg view; 
					Pdef(\turtle).set(param[0], param[1].map(view.value))
				}),
			]
		})
	),
	GridLayout.rows( * ~buttons ).spacing_(0),
);
~win.front;
)


////////////////////////////////////////////////////////////////////////////////



(


~make_slider = { arg obj, key, spec;
	var textfield;
	var val = obj.get(key) ? spec.default; // for init
	var normalized_val = spec.unmap(val);
	
	textfield = TextField.new
		.fixedSize_(90@20)
		.string_(val.asStringPrec(6))
		.action_({ arg me;
			obj.set(key, spec.map(me.value))
		});

	HLayout(
		StaticText.new
			.fixedSize_(50@20)
			.string_(key),
		Slider.new
			.orientation_(\horizontal)
			.fixedSize_(170@20)
			.value_(normalized_val)
			.action_({ arg me;
				var val = spec.map(me.value);
				obj.set(key, val);
				textfield.string = val.asStringPrec(6);
			}),
		textfield,
	).spacing_(0)
};


SynthDef(\turtle, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(freq * (1..4)/2) * 1 ));
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(900), \rq.kr(0.5));
	sig = DelayL.ar(sig, 0.1, (1..5)/\rdel.kr(1000)) + sig;
	sig = sig / 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.7),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\turtle, Pbind(
	\instrument, \turtle,
));

)


(
~win = Window.new("yep", Rect(500,500,100,100));
//~win.view.minSize_(10@10);
~win.front;
~win.alwaysOnTop = true;

~win.layout = VLayout(
	//Button.new.states_([["play"],["pause"]]).action_({ arg me;
	//	if(me.value == 0) {
	//		Pdef(\turtle).play;
	//	} {
	//		Pdef(\turtle).stop;
	//	}
	//}),
	~make_slider.(Pdef(\turtle), \freq, \freq.asSpec),
	~make_slider.(Pdef(\turtle), \lpf, \freq.asSpec),
	~make_slider.(Pdef(\turtle), \rq, \rq.asSpec),
	~make_slider.(Pdef(\turtle), \hpf, \freq.asSpec),
);

)

