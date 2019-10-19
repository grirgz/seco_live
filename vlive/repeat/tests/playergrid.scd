
FileSystemProject.load("libdef/tracks.scd")
TrackDef(\mygrid, TrackTemplateDef(\playergrid))
TrackDef(\mygrid).edit
TrackDef(\mygrid).childAt(0).activeIndex
