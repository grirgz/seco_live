


~a = EventStreamPlayer();
Pdef(\xxx, Pbind(\freq, 200, \dur, Pn(1/4,2)));
~a.stream = (Prout({ arg ev;
	100.do {
		ev = Pdef(\xxx).embedInStream(ev); // embed some pattern
		ev[\legato] = 0.1; // remove or add some key
		ev = ev.yield; // yield received event and get next
	};
	ev;
}) <> Pdef(\keys, Pbind()) <> Pdef(\base, Pbind(\freq, Pseq([400,500],inf))) ).asStream;
~a.play;

Pdef(\keys, Pbind(\freq, 1000)); // mask some key
Pdef(\keys, Pbind()); // unmask


(
	Pdef(\zed, 
		Prout({ arg ev;
			100.do {
				ev[\legato] = 0.1; // remove or add some key
				Pdef(\xxx).embedInStream(ev); // embed some pattern
				//ev = ev.yield(ev);
				ev = ev.yield
			};
			ev;
		}) <> Pdef(\keys, Pbind()) <> Pdef(\base, Pbind(\freq, 400)) 
).play;
);




(
SynthDef (\sine) {
	arg freq = 440;
	var sig = SinOsc.ar (freq);
	sig = Pan2.ar (sig, 0, 0.2);
	Out.ar (0, sig);
}.add;

TempoClock.tempo_ (91 / 60);

Pmono (\sine,
	\delta, 1 / 4,
	\freq, Pdefn (\arpeggio),
).play;
)

(
Pdefn (\freq_array) {
	{ ([ 0, 3, 7, 10, 19] + 57).midicps.yield }.loop;
};

Pdefn (\arpeggio) {
	Pseq (([ 0, 3, 7, 10, 19] + 57).midicps, inf); // works
	// Pseq (Pdefn (\freq_array), inf);  // doesn't work
};
)

Pdefn(\freq_array).asStream.next


(
Pdefn (\freq_array) {
	{ ([ 0, 3, 7, 1,10, 19] + 57).midicps.yield }.loop;
};

Pdefn (\arpeggio, 
	Prout({ arg ev;
		Pdefn(\freq_array).asStream.do({ arg arr;
			Pseq(arr).embedInStream
			//arr.do({ arg val; val.yield }) // alternate way
		})
	})
);
)

Pdefn(\freq_array).asStream.collect({  })
(
Pdefn (\freq_array) {
	{ ([ 0, 3, 7, 1,10, 19] + 57).midicps.yield }.loop;
};

Pdefn (\arpeggio) {
	Pdefn(\freq_array).asStream.do({ arg arr;
		Pseq(arr).embedInStream
		//arr.do({ arg val; val.yield }) // alternate way
	})
}
)
