Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\lag, -0.01,
	//\bufnum, Sdef(~namex, \myaudio).bufnum;
));
[~name, ~namex, ~index].debug("index");

// END
Sdef(~namex, \myaudio).record(8);
Sdef(~namex, \myaudio).record;
~namex
