
(
~currentTrack.initPmono(\default,
	Pbind(
		 \note, Pseq([
			 0,Pwhite(0,12,3),
		 ],inf),
		 \legato, 1,
		 \dur, 1,
	)
);
)

// END
~currentTrack

Pdef(~name).isPlaying
Pdef(~name).play
Pdef(~name).stop
Pdef(~name).clear
