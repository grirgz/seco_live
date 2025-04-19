
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject("sun/sun85").open.edit;
)
FileSystemProject.load("libdef/controllers.scd");
FileSystemProject("sun/sun85").edit
FileSystemProject("sun/sun85").mainTrackList.play
FileSystemProject("sun/sun85").open

(
Pdef(\ggg, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,2,4],inf),
		\haha, 123,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);



Pdef(\ggg).edit
