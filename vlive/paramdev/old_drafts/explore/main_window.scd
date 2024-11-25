// Moved to repeat/libdef/MainProject.Scd

// END

(
FileSystemProject('ex6', ProtoTemplateDef( \MainProject ));
WindowDef(\MainProject).front(FileSystemProject('ex6'));
)

(
)

TrackDef(\mygrid).clear
					TrackDef(\mygrid, TrackTemplateDef(\playergrid)).edit
					TrackDef(\mygrid).children
					TrackDef(\mygrid).childAtOffset(Point(0,0))
					TrackDef(\mygrid).childAt(0)
					TrackDef(\mygrid).childClass.new
					TrackTemplateDef(\playergrid).childClass

FileSystemProject.paths

ProtoDef(\simpleMixer).edit
ProtoDef(\playergrid).edit
TrackDef(\playergrid).edit

(
)
