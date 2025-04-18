
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject("sun/sun85").open.edit;
)
FileSystemProject("sun/sun85").edit
FileSystemProject("sun/sun85").mainTrackList.play
FileSystemProject("sun/sun85").open
