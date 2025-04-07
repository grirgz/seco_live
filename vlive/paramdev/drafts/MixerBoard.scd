
(
WindowDef(\MixerBoard, { arg def, mixerlist;
	mixerlist = mixerlist.collect { arg item, idx;
		if(item.isKindOf(Symbol)) {
			TrackMixerDef(item)
		} {
			item
		};
	};
	HLayout (
		*mixerlist ++ [nil]
	)

});
);

// END

// create two pattern each playing in its own mixer bus
(
Pdef(\block1,
	Ppar([
		Pbind(
			\instrument, \default,
			\octave, 3,
			\note, Pseq([
				0,6,4,-3,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\out, TrackMixerDef(\bass),
		),
		Pbind(
			\instrument, \default,
			\octave, 5,
			\note, Pseq([
				6,0,0,4,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
			\out, TrackMixerDef(\hi),
		),
		
	])
)).play;
);

TrackMixerDef(\bass).edit; // edit mixer \bass

(
// build a GUI with both mixers
WindowDef(\mixer, { arg def;
	HLayout (
		TrackMixerDef(\bass),
		TrackMixerDef(\hi),
		nil
	)
}).front;
)


WindowDef(\MixerBoard).front([\bass, \hi]);
