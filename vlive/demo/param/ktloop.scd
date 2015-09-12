KtlLoop can recorded events from input controllers, and play them back with the time manipulations of EventLoop. It can use those events to set an object's params based on a ktlMap. It can further rescale the recorded events in equally flexible ways - scaling, shifting, inversion.<pre class='code prettyprint lang-sc'>// make a sound to control 
(
Ndef(\form, { |freq = 50, shape = 0.9, ffreq = 200, amp = 0.1, lag = 0.1|
    var snd = VarSaw.ar(freq.lag(lag) + [0.1, -0.1], 0, shape.lag(lag));
    Formlet.ar(snd * amp.lag(lag), ffreq.lag(lag), 0.003, 0.03).softclip;
}).play(vol: 0.2);
// add specs for its unusual params:
Ndef(\form).addSpec(\shape, [0, 1]);
Ndef(\form).addSpec(\ffreq, \freq);
)

// make a KtlLoop for it
(
k = KtlLoop(\form);

// tell it which params will be recorded for control input:
k.paramsToRecord_([\lx, \ly, \rx, \ry]);

// simple usage case:
// tell it which object will be controlled 
k.object_(Ndef(\form));

// and declare which input params set which object params
k.ktlMap_((lx: \freq, ly: \shape, rx: \ffreq, ry: \amp));

)

// make 4 channel controller:
    // put params into an event, store it, 
    // and set the object from it

(
w = Window("KtlLoop.help", Rect(0,500, 400, 550)).front;
w.view.addFlowLayout;
Slider2D(w, Rect(0,0,190,190))
    .action_({ |sl|

        // put params into an event, 
    var event = (lx: sl.x, ly: sl.y);
        // store it, 
    k.recordEvent(event.put(\type, \set));
        // and set the object from it
    k.setuObj(event);
});
Slider2D(w, Rect(0,0,190,190))
    .action_({ |sl|
    var event = (rx: sl.x, ry: sl.y);
    k.recordEvent(event.put(\type, \set));
    k.setuObj(event);
});

// make an eventloopgui for KtlLoop
KtlLoopGui(k, parent: w, bounds: 260@180);

// and an NdefGui for the Ndef
NdefGui(Ndef(\form), 6, w);
)

// try recording: 
k.startRec;
// ...
// now move the two sliders
// ...
// ...

k.stopRec;

k.listInfo;

k.play;


// Rescaling Gestures - all recorded controller values 
// can be scaled, shifted, and inverted. 

k.rescaled = false;
k.rescaled = true;
// decrease range toward center
k.scaler = 0.5;
k.scaler = 0.25;
// shift up or down
k.shift = 0.1;
k.shift = -0.1;

// invert range
k.invert;
k.up;
k.flipInv;

k.dontRescale(\lx);
k.doRescale(\lx);

k.postKtlInfo;


/////////////////////////////////////////////////////////////////////////////

k.looped = true

k.list.print



Param(Ndef(\form), \freq, \freq).edit
Param(Ndef(\form), \freq, \freq).record(EventList)

~el = EventList.new


k.object_(Ndef(\form))
k.ktlMap(\freq, \freq)

~kl = Ktloop
~kl.mapParam(Param(Ndef(\form), \freq, \freq))

~kl.

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

// je pense que la meilleure facon de replay les enregistrement, c'est au meme niveau que Param.set, comme le fait les knob et sliders
// donc Pdef(\plop).set et Ndef(\plop).set
// chaque ktloop correspondrait a un param

// comme dans ableton, un pattern sous forme de pitch timeline peut avoir plusieurs lignes d'automation correspondant a chacun des parametres qu'on veut automatiser
// je pense qu'il faut un conteneur pour contenir tous ces params automatisés, une sorte de ParamGroup

// ParamRecord serait la classe correspondant a KtlLoop ? ou ParamLoop ? c'est coherent avec le nom du quark mais est-ce vraiment un loop ? c'est plus un enregistrement

~pl = ParamLoop(\yep, Param(Ndef(\form), \freq, \freq) )
~pl.startRec

// ce ParamLoop met un SimpleController sur le target qui enregistre tout dans l'eventlist

//on peut le rejouer avec
~pl.play
//on peut l'avoir sous forme de pattern qu'on pourrait mettre dans un 
Ndef(\plop).set(\set -> Pn(~pl))
// ou
Pdef(\myside,
	Pn(~pl)
)

mais l'un est un simple pattern, l'autre doit setter un bus, ce serait ptet mieux d'avoir un equivalent de \set -> mais pour Pdef
on peut regarder aussi du coté de misclib qui a normalement un pattern qui peut setter different param d'un Pbind a une frequence differente


On aurait donc dans le clip:

Pdef(~name,
	Pdef(~name+++\macro) // ici on peut controller les patterns avec un midi ou gui ou bien si on play un ParamLoop, l'effet apparait la
	<>
	Pbind(
		....
	)

)

~pl.play

par contre pour les Ndef c'est plus simple

(
Ndef(~name+++\fx, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

~pl.play;


le .play du KtlLoop (et EventLoop) est un TaskProxy donc il agit comme un Ndef ou Pdef ce qui est plutot une bonne chose

(
	~freqenvTimeline = (
		new: { arg self, eventloop;
			self = self.deepCopy;
		
			self.eventloop = eventloop;
			
		
			self;
		},

		makeLayout: { arg self;
			var layout;
			var vlayout, timeline, vrange, hrange, size;
			var eventloop = self.eventloop;
			"AZE".debug;
			layout = HLayout.new;
			self.layout = layout;
			vlayout = VLayout.new;
			timeline = TimelineEnvView.new;
			layout.add(vlayout);
			hrange = RangeSlider.new;
			hrange.orientation = \horizontal;
			vrange = RangeSlider.new;
			vrange.orientation = \vertical;
			layout.add(
				VLayout(
					vrange,
					HLayout(
						XSimpleButton.new.label_("<").action_({
							timeline.areasize = timeline.areasize - Point(4,0);
							timeline.refresh;
						}).fixedSize_(Point(10,20)),
						XSimpleButton.new.label_(">").action_({
							timeline.areasize = timeline.areasize + Point(4,0);
							timeline.refresh;
						}).fixedSize_(Point(10,20)),
					).spacing_(0)
				)
			);
			vlayout.add(timeline.view);
			vlayout.add(hrange);

			timeline.viewport = Rect(0,0,1,1);
			vrange.action = { arg slider;
				var range = slider.range.clip(0.0001,1); // prevent division by 0
				timeline.viewport.top = (1-slider.hi) / range;
				timeline.viewport.height = range;
				[timeline.viewport, slider.hi, slider.lo, slider.range].debug("range action");
				timeline.refresh;
			};
			hrange.action = { arg slider;
				var range = slider.range.clip(0.0001,1); // prevent division by 0
				timeline.viewport.left = slider.lo / range;
				timeline.viewport.width = range;
				[timeline.viewport, slider.hi, slider.lo, slider.range].debug("range action");
				timeline.refresh;
			};

			size = 8@128;
			timeline.view.refresh;
			//timeline.viewport = Rect(0,0,0.1,0.1);
			//timeline.viewport = Rect(0,0,1,20/128);
			timeline.areasize = size;
			timeline.mapEventList(eventloop.list);
			timeline.refresh;
			self.timeline = timeline;
			self.layout = layout;
			"iiAZE".debug;
			layout;
		},

		refresh: { arg self;
			self.timeline.mapEventList(self.eventloop.list);
		},
	);
	~recorder = { arg eventloop;

		var window = Window.new;
		var layout;
		var recb, stopb, playb;
		var updateRecState = {
			var view = recb;
			if(eventloop.isRecording) {
				view.background = Color.red;
			} {
				view.background = Color.white;
			};
		};
		var timeline;
		var newevent = { arg midival;
			var ev;
			var playev;
						"youfuck!!!".debug;
			ev = (midinote:midival);
			eventloop.recordEvent(ev);
		};
		"hii	".debug;
		timeline = ~freqenvTimeline.new(eventloop);
		"iihii	".debug;
		~timeline = timeline;

		layout = 
		VLayout (
			timeline.makeLayout,
			HLayout (
				recb = XSimpleButton.new.action_({ arg view;
					eventloop.startRec(false);
					timeline.refresh;
					updateRecState.();
				})
				.label_("Rec"),
				XSimpleButton.new.action_({
					eventloop.stopRec;
					timeline.refresh;
					updateRecState.();
				})
				.label_("Stop"),
				XSimpleButton.new.action_({
					eventloop.play;
				})
				.label_("Play"),
			),
			HLayout.new(
				Param(Ndef(\freqenv), \midinote, ControlSpec(0,127,\lin)).asSlider
					.orientation_(\horizontal)
					.onChange(Ndef(\freqenv), \set, { arg ... args;
						args.debug("args");
						newevent.(Ndef(\freqenv).get(\midinote))
					})
			),
		);
		"iiiiihii	".debug;

		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;
	};
	~recorder.(XEventLoop(\e));

)

XEventLoop(\e).list.print
