
WindowDef(\saver, {

}).front;

(
	ProtoDef(\base_saver, (
		eventList_presetCompileString: { arg self, eventList;
			var ret;
			ret = eventList.collect({ arg ev;
				self.event_presetCompileString(ev)
			}).join;
			res;
		},

		event_presetCompileString: { arg self, ev;
			"\t(%),\n".format(
				// ev.asCompileString return stuff from parent event, so looping manually
				ev.keys.as(Array).sort.collect({ arg key;
					"%%: %, ".format("\\",key, ev[key].asCompileString)
				}).join
			)
		},

		noteTimeline_presetCompileString: { arg self, object;
			var ret;

			ret = ProtoDef(\base_saver).eventList_presetCompileString(object.eventList);
			ret = "XEventList.newFrom([\n%]);".format(ret);
			"NoteTimeline(%).eventList = %".format(name.asCompileString, ret)

		}

	));

ProtoDef(\saver_NoteTimeline, (
	saveObject: { arg object, name, projectpath;
		var ret;
		ret = ProtoDef(\base_saver).noteTimeline_presetCompileString(objec);
		// FIXME: pseudo code
		File.use(FileSystemProject.resolve(projectpath+/+"data/NoteTimeline/%.scd".format(name)), "w", { arg file;
			file.write(ret)
		})
	},

	loadObject: { arg name, projectpath;
		File.use(FileSystemProject.load(projectpath+/+"data/NoteTimeline/%.scd".format(name))
	},
));

ProtoDef(\saver_projectgrid, (
	saveObject: { arg object, name, projectpath;
		var ret;
		ret = object.source.collect({ arg track;
			ProtoDef(\base_saver).noteTimeline_refCompileString(track);
		}).join(", ");
		"TrackDef(%, TrackDef(\projectgrid));".format(name);
		"TrackDef(%).source = %;".format(name, ret);
		// FIXME: pseudo code
		File.use(FileSystemProject.resolve(projectpath+/+"data/TrackClassDef_projectgrid/%.scd".format(name)), "w", { arg file;
			file.write(ret)
		})
	},

	copyObject: { arg name, newname, projectpath;
	
	},

	deleteObject: { arg name, newname, projectpath;
	
	},

	renameObject: { arg name, newname, projectpath;
	
	},

	loadObject: { arg name, projectpath;
		File.use(FileSystemProject.load(projectpath+/+"data/TrackClassDef_projectgrid/%.scd".format(name))
	},
));
)
