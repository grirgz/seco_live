Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	//\bufnum, Sdef(~namex, \myaudio).bufnum;
));
[~name, ~namex, ~index].debug("index");

// END
Sdef(~namex, \myaudio).record(4);
Sdef(~namex, \myaudio).bufnum;
~namex
