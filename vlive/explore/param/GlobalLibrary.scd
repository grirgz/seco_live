

//moved to Proto/GlobalLibrary.scd

// END

WindowDef(\GlobalLibrary).front(ProtoDef(\GlobalLibrary));
WindowDef(\GlobalLibrary).clear
~xx
TagSpecDef(\SynthDef).list.collect(_.key.postln)
TagSpecDef(\Pdef).list.collect(_.key.postln)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

SampleTimeline(\bla)

Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('voices/feynman.flac'),
	\dur, 1,
	\gain, 1,
)

TagSpecDef(\Sample).list.size == 0 and: { 
	TagSpecDef(\Sample, {
		BufDef.paths.collect({ arg path;
			"find '%' -iname '*.wav'".format(path).unixCmdGetStdOut.split($\n)
		}).flatten.collect( { arg file;
			PathName(file).fileName -> file;
		})
	}));
};
