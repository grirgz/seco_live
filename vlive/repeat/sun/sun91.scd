
~t = 185/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			8.collect { arg item, idx;
				Pbind(
					\instrument, \sh101,
					\degree, Pwhite(0,7).stutter(8),
					//\degree, Pseq([0,2,4,2],inf) + Prand([-1,0,0,0,0,0,0,0,0,0,0,0,1,0.5,-0.5],inf),
					\octave, Pwhite(3,7),
					\mtranspose, Pstep(Pseq([0,3,4,3],inf),2),
					\envamt, Pwhite(0.1,4),
					\dur, Prand((1..8)/8,inf),
					\amp, 0.1/2 * Pwhite(0.1,1.3,inf).stutter(60),
				)
			};
		)
		
	])
)).play;
);
(
Pdef(\zed, 
	Ppar([
		
	]),
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


TrackDef('simpleProject_mainTrackList').elAt(1).source.source.identityHash
TrackDef('simpleProject_mainTrackList').elAt(2).source.source.identityHash
TrackDef('simpleProject_mainTrackList').elAt(3).source.source.identityHash
TrackDef('simpleProject_mainTrackList').elAt(4).source.source.identityHash

TrackDef('simpleProject_mainTrackList').elAt(1).source.source.at(\envamt).identityHash
TrackDef('simpleProject_mainTrackList').elAt(2).source.source.at(\envamt).identityHash
TrackDef('simpleProject_mainTrackList').children.asArray.size
~ch = TrackDef('simpleProject_mainTrackList').children;
~ch = TrackDef('bla').children;
~ch.asArray[0..~ch.asArray.size - ~ch.asArray.reverse.detectIndex { arg x; x.isEmpty.not } -1].size


TrackDef(\bla, \TrackList).editGrid
TrackDef(\bla, \TrackList).edit
TrackDef(\bla).firstChildren
TrackDef(\bla).savePresetCompileString
TrackDef(\newname, TrackDef(\bla))
TrackDef(\newname).savePresetCompileStringDialog
TrackDef(\newname).edit
Window.closeAll
