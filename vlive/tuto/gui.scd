
// sound object we want to control
(
Ndef(\bourdon, { arg freq=100, amp=0.1;
	var sig;
	freq = (1..4)/ SinOsc.kr(1/45).range(10000,1) + 1 * freq;
	sig = SinOsc.ar(freq) + LFSaw.ar(freq); 
	sig = sig.wrap2( SinOsc.kr((1..4)/19).range(2,1) ) + sig;
	sig = Pan2.ar(sig, SinOsc.kr((1..4)/25) * 0.5, amp).mean;
}).play;
)

///////////////////////////////// Part I: basics

~win = Window.new;
~win.front;
~win.alwaysOnTop = true;

~button = Button.new;
~win.layout = VLayout(~button); // add button to window
~button.states = [["hello"]];
~button.action = { "pushed!!".postln }; // function is executed when button is pushed


~knob = Knob.new;
~knob.action = { arg x; x.value.postln; };
~win.layout = VLayout(~button, ~knob);

~freqspec = \freq.asSpec; // predefined spec for frequency
~freqspec = ControlSpec(20,18000,\exp); // custom spec
~freqspec.map(0.1); // transform a number in range 0..1 to 20..18000
~freqspec.map(0.9);
~freqspec.unmap(2500); // transform a number in range 20..18000 to 0..1


Ndef(\bourdon).play;
Ndef(\bourdon).set(\freq, 185);
Ndef(\bourdon).set(\freq, 90);

(
// now the knob control the frequency of Ndef
~knob.action = { arg x; 
	Ndef(\bourdon).set(\freq, ~freqspec.map(x.value));
};
)

/////////// Layouts

(
// vertical
Window.new.front.layout_(
	VLayout(
		Button.new,
		Slider.new,
		Knob.new,
	)
)
)

(
// horizontal
Window.new.front.layout_(
	HLayout(
		Button.new,
		Slider.new,
		Knob.new,
	)
)
)

(
// grid
Window.new.front.layout_(
	GridLayout.rows(
		[ Button.new, Slider.new, Knob.new ],
		[ Button.new, Slider.new, Knob.new ],
		[ Button.new, Slider.new, Knob.new ],
	)
)
)

(
// imbricated

Window.new.front.layout_(
	HLayout(
		StaticText.new.string_("hello"),
		Knob.new,
		VLayout(
			TextField.new.value_(pi),
			HLayout(
				Slider.new,
				Slider2D.new,
			),
			GridLayout.rows(
				[ Button.new, Button.new, Button.new ],
				[ Button.new, Button.new, Button.new ],
				[ Button.new, Button.new, Button.new ],
			)
		)
	)
)
)

///////////////////////////////// Part II: refreshing display

// it's better to keep your code in a function, so you can run it when you want and add parameters
(
~make_gui = {
  var win, layout, knob, spec;
  win = Window.new;
  knob = Knob.new;
  layout = HLayout.new;
  spec = ControlSpec(20,20000, \exp);

  // initialization
  knob.value = spec.unmap( Ndef(\mysynth).get(\freq) );

  // updating
  knob.action = { arg view;
    "the knob is moved!".postln;
    Ndef(\bourdon).set(\freq, spec.map(view.value))
  };

  layout.add(knob);
  win.layout = layout;
  win.front;
};
~make_gui.(); // run the function to show the GUI
)

///////////////////// MIDI

// control with your MIDI controller (all cc by default)
MIDIdef.cc(\mycontroller, { arg val;
  var spec = ControlSpec(20,20000, \exp);
  Ndef(\mysynth).set(\freq, spec.map(val))
});

MIDIdef.cc(\mycontroller).free; // stop this listener

// notice the controller doesn't update the gui (if you have no controller, try with two gui)
~make_gui.()
// you need code to update the gui, there is two different ways:
// - each time the \freq is changed, update the GUI Knob (synchronous method)
// - every second, read the \freq value and update the GUI Knob (poll method)

//////////////////// refresh: Syncronous method

(
~make_gui = {
  var win, layout, knob, spec;
  var sc;
  win = Window.new;
  knob = Knob.new;
  layout = HLayout.new;
  spec = ControlSpec(20,20000, \exp);

  // initialization
  knob.value = spec.unmap( Ndef(\mysynth).get(\freq) );

  // updating the model
  knob.action = { arg view;
    "the knob is moved!".postln;
	view.value.postln;
    Ndef(\mysynth).set(\freq, spec.map(view.value))
  };

  // updating the view
  sc = SimpleController(Ndef(\mysynth));
  sc.put(\set, {
    if(knob.isClosed) {
      // when view is closed, we need to remove the SimpleController, because the knob doesn't 
      // exist anymore and it will cause an error when calling .value
      sc.remove;
    } {
      knob.value = spec.unmap( Ndef(\mysynth).get(\freq) );
    }
  });

  layout.add(knob);
  win.layout = layout;
  win.front;
};
~make_gui.(); // run the function to show the GUI
)


/////////////////// refresh: Poll method

// sometime there is no signal sent to know the model has changed, so we use poll method

(
~make_gui = {
  var win, layout, knob, spec;
  var sc;
  win = Window.new;
  knob = Knob.new;
  layout = HLayout.new;
  spec = ControlSpec(20,20000, \exp);

  // initialization
  knob.value = spec.unmap( Ndef(\mysynth).get(\freq) );

  // updating the model
  knob.action = { arg view;
    "the knob is moved!".postln;
    Ndef(\mysynth).set(\freq, spec.map(view.value))
  };

  // updating the view
  SkipJack(
	  {
		  knob.value = spec.unmap( Ndef(\mysynth).get(\freq) );
	  },
	  1, // update every second
	  {
		  // if this function return true, the SkipJack instance will be removed
		  "is closed ? ".post;
		  knob.isClosed.postln;
	  }
  );

  layout.add(knob);
  win.layout = layout;
  win.front;
};
~make_gui.(); // run the function to show the GUI
)

////////////////////////////////////// Part III: simple sequencer


(
SynthDef(\bip, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, phase=0;
	var sig;
	freq = (1..4)/ SinOsc.kr(1/45, phase).range(10000,1) + 1 * freq;
	sig = SinOsc.ar(freq, phase) + LFSaw.ar(freq, phase); 
	sig = sig.wrap2( SinOsc.kr((1..4)/19, phase).range(2,1) ) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, SinOsc.kr((1..4)/25, phase) * 0.5, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
// exemple pattern
Pdef(\seq1, Pbind(
	\instrument, \bip,
	\degree, Pseq([3,0,4,1, 2b,0,4,1],inf),
	\phase, Pseg(Pseq([0,1],inf),16),
	\legato, 0.4,

	// some rest sequence
	\isRest, Pseq([
		1,0,1,1, 1,1,0,0,
	],inf).coin.not,

	\dur, 1/8,
	\amp, 0.1
)).play;
);


// define the model: where the sequence data is stored
~seq1 = List.newFrom([1,0,1,1, 1,1,0,0]);


(
// use the model as sequencer
Pdef(\seq1, Pbind(
	\instrument, \bip,
	\degree, Pseq([3,0,4,1, 2b,0,4,1],inf),
	\phase, Pseg(Pseq([0,1],inf),16),

	// with Plazy, we re-evaluate ~seq1 each time the Pseq reach the end
	\isRest, Plazy({
		Pseq(~seq1);
	}).loop.coin.not,

	\legato, 0.4,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

~seq1[0] = 0;
~seq1[0] = 1;

////// list manipulation

(
// iterate
~seq1.do({ arg val, idx; 
	[val, idx].postln;
});
)

(
// transform in new list
~new_seq = ~seq1.collect({ arg val, idx; 
	[val, idx].postln;
	val * 5; // return value
});
)
~new_seq.postln;

/////// lists in layouts

// instead of
(
HLayout(
	Button.new,
	Button.new,
)
)

// you can write

(
HLayout(*
	[
		Button.new,
		Button.new,
	]
)
)

(
	// create 8 button
	~win = Window.new.front;
	~win.layout = HLayout(*
		8.collect({ Button.new })
	)
)


/////////// full example of sequencer GUI

(

~make_gui = { arg list;
  var win, layout, spec;
  var butseq;
  win = Window.new;
  layout;

  // make a button for each slot in list
  butseq = list.collect({ arg val, idx;
	  var but = Button.new;

	  but.states_([
		  // [text, font color, background color]
		  ["", Color.black, Color.white],
		  ["", Color.black, Color.black],
	  ]);

	  // action: update the list when clicked
	  but.action = {
		  list[idx] = but.value;
	  };

	  // init
	  but.value = val;

  });

  layout = HLayout(*butseq);
  win.layout = layout;
  win.front;
};
~make_gui.(~seq1); // run the function to show the GUI
)



///////////////////////////////////// Part IV: MVC paradigm: Model / View / Controller


// Model is the data :
[1,0,1,1, 1,1,0,0]

// View is the GUI, it represent the data on screen :
~make_gui.(~seq1)

// Controller is the SimpleController or SkipJack used to communicate between Model and View

// you can have multiple view of the same data

(
// define a vertical variant of the view
~make_vertical_gui = { arg list;
  var win, layout, spec;
  var butseq;
  win = Window.new;
  layout;

  // make a button for each slot in list
  butseq = list.collect({ arg val, idx;
	  var but = Button.new;

	  but.states_([
		  // [text, font color, background color]
		  ["", Color.black, Color.white],
		  ["", Color.black, Color.black],
	  ]);

	  // action: update the list when clicked
	  but.action = {
		  list[idx] = but.value;
	  };

	  // init
	  but.value = val;

  });

  layout = VLayout(*butseq);  // <------ vertical layout
  win.layout = layout;
  win.front;
};
)

// MVC is important because you want to view the same data by different point of view 

~make_gui.(~seq1);
~make_vertical_gui.(~seq1); // notice view is refreshed only when closed and re-opened

// or you want to use same view to view different data

~seq1 = List.newFrom([1,0,1,1, 1,1,0,0]);
~seq2 = List.newFrom([1,1,1,0, 0,0,1,0]);

~make_gui.(~seq1);
~make_gui.(~seq2);

//////////////////////////////////////////// Part V: re-use code

(
~pdef_param_slider = { arg pdef, key, spec;
	var view = Slider.new;
	var sc;

	view.orientation = \horizontal;

	spec = spec ? key; // use key if no spec is defined
	spec = spec.asSpec; // transform symbol in spec
	
	// action
	view.action = {
		pdef.set(key, spec.map(view.value))
	};
	view.value = spec.unmap(pdef.get(key) ? 0); // init

	// updating the view
	sc = SimpleController(pdef);
	sc.put(\set, {
		if(view.isClosed) {
			// when view is closed, we need to remove the SimpleController, because the knob doesn't 
			// exist anymore and it will cause an error when calling .value
			sc.remove;
		} {
			view.value = spec.unmap( pdef.get(key) ? 0 );
		}
	});

	view;
};
)

~pdef_param_slider.(Pdef(\seq1), \freq);

(
~win = Window.new.front;
~win.layout = VLayout(
	~pdef_param_slider.(Pdef(\seq1), \freq),
	~pdef_param_slider.(Pdef(\seq1), \legato),
	~pdef_param_slider.(Pdef(\seq1), \phase),
)
)

// if a key is already defined in the Pbind, you can't modulate it

(
// remove phase and legato
Pdef(\seq1, Pbind(
	\instrument, \bip,
	\degree, Pseq([3,0,4,1, 2b,0,4,1],inf),
	//\phase, Pseg(Pseq([0,1],inf),16),

	// with Plazy, we re-evaluate ~seq1 each time the Pseq reach the end
	\isRest, Plazy({
		Pseq(~seq1);
	}).loop.coin.not,

	//\legato, 0.4,
	\dur, 1/8,
	\amp, 0.1
)).play;
);


// add labels

(
~make_gui = {
	var win = Window.new.front;
	win.layout = GridLayout.rows(
		[
			StaticText.new.string_("freq"),
			~pdef_param_slider.(Pdef(\seq1), \freq),
		],
		[
			StaticText.new.string_("legato"),
			~pdef_param_slider.(Pdef(\seq1), \legato),
		],
		[
			StaticText.new.string_("phase"),
			~pdef_param_slider.(Pdef(\seq1), \phase),
		],
	)
	
};
~make_gui.();
)


// avoid repetition by using a loop

(
~params = [
	\freq, \legato, \phase, \dur,
];

~make_gui = { arg pdef, paramlist;
	var win = Window.new.front;
	win.layout = GridLayout.rows(
		*paramlist.collect({ arg param;
			[
				StaticText.new.string_(param),
				~pdef_param_slider.(pdef, param),
			];
		})
	)
};
~make_gui.(Pdef(\seq1), ~params);
)

// let's add a value editor

(
~pdef_param_text = { arg pdef, key, spec;
	var view = TextField.new;
	var sc;

	// action
	view.action = {
		pdef.set(key, view.value)
	};
	view.value = pdef.get(key) ? 0; // init

	// updating the view
	sc = SimpleController(pdef);
	sc.put(\set, {
		if(view.isClosed) {
			// when view is closed, we need to remove the SimpleController, because the knob doesn't 
			// exist anymore and it will cause an error when calling .value
			sc.remove;
		} {
			view.value = pdef.get(key);
		}
	});

	view;
};
)

// undefine \dur
Pbindef(\seq1, \dur, Pkey(\dur))
// define a default spec for \dur
Spec.add(\dur, ControlSpec(1/16,4))

(
~params = [
	\freq, \legato, \phase, \dur,
];

~make_gui = { arg pdef, paramlist;
	var win = Window.new.front;
	win.layout = GridLayout.rows(
		*paramlist.collect({ arg param;
			[
				StaticText.new.string_(param),
				~pdef_param_slider.(pdef, param),
				~pdef_param_text.(pdef, param),
			];
		})
	)
};
~make_gui.(Pdef(\seq1), ~params);
)


// make a sequencer
(
~make_seq = { arg list;
	var layout, knob, spec;
	var butseq;
	layout;

	// make a button for each slot in list
	butseq = list.collect({ arg val, idx;
		var but = Button.new;

		but.states_([
			// [text, font color, background color]
			["", Color.black, Color.white],
			["", Color.black, Color.black],
		]);

		// action: update the list when clicked
		but.action = {
			list[idx] = but.value;
		};

		// init
		but.value = val;

	});

	layout = HLayout(*butseq);
	layout; // return layout

}
)


(
~params = [
	\freq, \legato, \phase, \dur,
];
~seq1 = List.newFrom([1,0,1,1, 1,1,0,0]);

~make_gui = { arg pdef, paramlist, seqlist;
	var win = Window.new.front;
	var paramlayout;
	var seqlayout;
	paramlayout = GridLayout.rows(
		*paramlist.collect({ arg param;
			[
				StaticText.new.string_(param),
				~pdef_param_slider.(pdef, param),
				~pdef_param_text.(pdef, param),
			];
		})
	);
	seqlayout = ~make_seq.(seqlist);
	win.layout = VLayout(
		paramlayout,
		seqlayout,
	);
};
~make_gui.(Pdef(\seq1), ~params, ~seq1);
)

// define a specific GUI:

(
	~my_cool_gui = {
		var seq1;
		var params;
		params = [
			\freq, \legato, \phase, \dur,
		];
		~make_gui.(Pdef(\seq1), params, ~seq1);
	};
)

~my_cool_gui.();


// now put all your functions in a file named "myfun.scd", put the file in 
Platform.userAppSupportDir
// then at the begining of your new music file, or in your startup.scd put this:
(Platform.userAppSupportDir +/+ "myfun.scd").load
// or
"~/path/to/myfun.scd".standardizePath.load
