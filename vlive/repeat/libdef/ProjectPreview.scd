
(
FileSystemProject.loadOnce("libdef/SeparatorLineView.scd");
ProtoTemplateDef(\ProjectPreview, (

));

WindowDef(\ProjectPreview, { arg def, proj;
	var view = ScrollView.new;
	var objlist = List.new;
	var objdict = IdentityDictionary.new;
	var mainObjects, mainObjectsKeys;
	var objToView;
	var tltypes = TagSpecDef('GlobalLibrary.category.Timeline').keyList;
	var tgtypes = TagSpecDef('GlobalLibrary.category.TrackGrid').keyList;
	var filePrefix = "   - ";
	var makeTitle = { arg txt;
		WindowDef(\SeparatorLineView).asView(txt)
		//HLayout (
			//[ StaticText.new.string_(txt), stretch:0 ],
			//[ WindowDef(\SeparatorLineView).asView, stretch:10, \align:\mid ],
		//)
	};

	objToView = { arg res, exclude;
		var id = ProtoDef(\GlobalLibrary).targetToLibId(res);
		var cat = id !? _.first;
		exclude = exclude ?? { [] };
		if(exclude.includes(res.key)) {
			// NOOP
		} {
			HLayout (
				PlayerWrapper(res).asView.rightClickEditorEnabled_(true),
				case(
					{ tltypes.includes(cat) }, {
						StaticText.new.string_("% events".format( res.eventList.size - 2 ))
					},
					{ tgtypes.includes(cat) }, {
						StaticText.new.string_("% tracks, % sections".format( 
							res.existingChildren.size,
							res.existingSections.size,
						))
					}, {

						StaticText.new.string_("-")
					}
				)
			)
		}
	};


	proj = proj ?? { FileSystemProject.current };

	proj.resources.do { arg res, idx;
		var id = ProtoDef(\GlobalLibrary).targetToLibId(res);
		if(id.notNil) {
			objdict[id.first] = objdict[id.first].add(id);
		};
	};
	////// main

	objlist.add(makeTitle.("Main"));
	
	// exclude fxManager because always there
	mainObjectsKeys = [\fxManager, \mainMixer, \mainTimeline, \mainTrackList, \mainTrackGrid];
	mainObjects = mainObjectsKeys.collect { arg key; proj.perform(key); };
	mainObjects.do { arg res, idx;
		if(res.notNil and: { res.isEmpty != true }) {
			var widget = objToView.(res, [ \FxManager ]);
			if(widget.notNil) {
				objlist.add(widget)
			}
		}
	};

	/////// resources

	objlist.add(makeTitle.("Resources"));
	proj.resources.do { arg res, idx;
		if(res.notNil and: { mainObjects.includes(res).not } and: { res.isEmpty != true }) {
			var widget = objToView.(res);
			if(widget.notNil) {
				objlist.add(widget)
			}
		}
	};
	/////// files
	// TODO: detect file type with prefix, then show playerwrapperview, load file button, open file button
	// exclude main files
	// project file can have buttons
	// buttons on MainProject window could be grey when isEmpty, and in this window, and for PlayerWrapperView

	objlist.add(makeTitle.("Files "));
	PathName(proj.path).folders.do { arg entry, idx;
			entry.debug("folder entry");
			objlist.add(StaticText.new.string_(filePrefix ++ entry.folderName ++ "/"))
	};
	PathName(proj.path).files.do { arg entry, idx;
			entry.debug("entry");
			objlist.add(StaticText.new.string_(filePrefix ++ entry.fileName))
	};

	objlist.add(makeTitle.("Data Files "));
	PathName(proj.dataPath).folders.do { arg entry, idx;
			entry.debug("data folder entry");
			objlist.add(StaticText.new.string_(filePrefix ++ entry.folderName ++ "/"))
	};
	PathName(proj.dataPath).files.do { arg entry, idx;
			entry.debug("data entry");
			objlist.add(StaticText.new.string_(filePrefix ++ entry.fileName))
	};

	//
	objlist.add(nil);

	view.canvas = View.new.layout_(VLayout(*objlist));


});
)

// END
TagSpecDef('GlobalLibrary.category.Timeline').keyList
~p = FileSystemProject.current
~p.mainwindow

~p.resources
~p.fxManager.isEmpty
~p.mainMixer.protoClass
~p.mainMixer.isEmpty
~p.mainTrackList.existingChildren.size
~p.mainTrackList.existingSections.size
(
~p.resources.do { arg res, idx;
	var id = ProtoDef(\GlobalLibrary).targetToLibId(res);
	"** %: % - % (%)".format(res.key, res.protoClass, res.eventType, id).debug;
};
)

ProtoDef(\sun38_mainMixer).keys
ProtoDef(\sun38_mainMixer).protoClass
ProtoDef(\sun38_mainMixer).classType
ProtoDef(\sun38_mainMixer).parent
ProtoDef(\sun38_mainMixer)
ProtoDef(\GlobalLibrary).targetToLibId(ProtoDef(\sun38_mainMixer))
ProtoDef(\GlobalLibrary).targetToLibId(~p.mainTrackList)


~p.mainMixer.tracks.first.isEmpty
~p.mainMixer.isEmpty
(
~p.mainMixer.tracks.first.asParamGroup.do { arg param, idx;
	"%: %".format(param.asString, param.isSet).debug;
	
};
)

