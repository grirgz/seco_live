

(
ProtoDef(\GlobalLibrary, (
	edit: { arg self;
		WindowDef(\GlobalLibrary).front;
	},

	libIdToTarget: { arg self;
		
	},

	libIdToStrings: { arg self, libid;
		libid.first
		
	},

	libIdToTrackInstrument: { arg self, libid;
		
	},
));

//TagSpecDef(\SynthDef).clear; // to debug;

TagSpecDef(\SynthDef, {
	SynthDescLib.all.values.asList.collect({arg lib; lib.synthDescs.asAssociations}).flat;
});

TagSpecDef(\SynthDef_user, {
	SynthDescLib.all.values.asList.collect({arg lib; lib.synthDescs.asAssociations}).flat.reject({ arg item;
		item.key.asString.beginsWith("system_")
   
	});
});

TagSpecDef(\Pdef, {
	Pdef.all.asAssociations;
});

TagSpecDef(\Ndef, {
	Pdef.all.asAssociations;
});

TagSpecDef(\SampleTimeline, {
	SampleTimeline.proto.all.asAssociations;
});

TagSpecDef(\BusDef, {
	[\0->0] ++ BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k).index }) 
});

TagSpecDef(\BufDef, {
	[\0->0] ++ BufDef.all.keys.as(Array).sort.collect({ arg k; k -> BufDef(k).bufnum }) 
});

TagSpecDef(\Sample).list.size == 0 and: { 
	TagSpecDef(\Sample, {
		BufDef.paths.collect({ arg path;
			"find '%' -iname '*.wav'".format(path).unixCmdGetStdOut.split($\n)
		}).flatten.collect( { arg file;
			PathName(file).fileName -> file;
		})
	}.value);
};

TagSpecDef(\BusDefDefault, {
	[\default -> nil] ++ TagSpecDef(\BusDef).list
});

TagSpecDef(\GlobalLibraryType, [
	\BusDef,
	\BufDef,
	//\SynthDef,
	\SynthDef_user,
	\Pdef,
	\Ndef,
	\NoteTimeline,
	\TrackTimeline,
	\KitTimeline,
	\SampleTimeline,
	\ClipTimeline,
	\PatKitDef,
	\Sample,
]);

TagSpecDef(\GlobalLibraryCategory, [
	\TrackInstrument,
	\Effect,
	\Score,
	\Preset,
]);

TagSpecDef('GlobalLibrary.type.TrackInstrument', [
	\SynthDef_user,
	\Pdef,
	\Ndef,
	\PatKitDef,
	\BufDef,
]);

WindowDef(\GlobalLibrary, { arg def, lib, selectedCallback;


	var resultView;
	var searchBox;
	var typeView;
	var categoryView;
	var lay;
	searchBox = TextField.new.action_({
		"action!".debug;
			def.changed(\search);
			def.changed(\category);
	}).keyUpAction_({ arg me, key, modifiers, unicode, keycode;
		[me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
		def.changed(\results);
	});

	typeView = ListView.new
		.items_(
			TagSpecDef(\GlobalLibraryType).list.collect ({ arg superitem;
				//Log(\Param).debug("superitem %", superitem);
				//TagSpecDef(superitem.value).list.collect { arg item;
				//Log(\Param).debug("item %", item);
				superitem.key;
				//}

			}).flat.asArray
		)
		.selection_([])
		.action_({ arg view;
			view.selection.debug("cat action");
			def.changed(\results);
		})
		.selectionMode_(\multi)
		.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			view.selection.debug("cat mouse up");
			def.changed(\results);
			
		})
	;

	categoryView = ListView.new
		.items_(
			TagSpecDef(\GlobalLibraryCategory).list.collect ({ arg superitem;
				superitem.key;
			}).flat.asArray
		)
		.selection_([])
		.action_({ arg view;
			view.selection.debug("cat action");
			def.changed(\results);
		})
		.selectionMode_(\multi)
		.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			view.selection.debug("cat mouse up");
			def.changed(\results);
			
		})
	;


	resultView = TreeView.new
		.columns_(["Name", "Type", "Category", "Tags"])
		.followChange(def, \results, { arg view, model, msg, arg1;
			var superitem;
			var selectedTypes = typeView.selection.collect({ arg idx; typeView.items[idx] });
			var selectedCategories = categoryView.selection.collect({ arg idx; categoryView.items[idx] });
			var filteredTypes;
			var itemIds = List.new;
			if(selectedTypes.size == 0) {
				selectedTypes = MenuSpecDef(\GlobalLibraryType).keyList;
			};
			filteredTypes = selectedTypes;
			if(selectedCategories.size > 0) {
				filteredTypes = selectedTypes.asSet.sect(
					selectedCategories.collect({ arg superkey;
						MenuSpecDef("GlobalLibrary.type.%".format(superkey).asSymbol).keyList;
					}).flat.asSet
				).asList;
			};
			view.clear;

			[model, view, msg, selectedTypes, selectedCategories, filteredTypes].debug("category change");
			itemIds = filteredTypes.collect({ arg typeitem;
				//Log(\Param).debug("typeitem %", typeitem);
				TagSpecDef(typeitem.value).list.collect ({ arg item;
					//Log(\Param).debug("item %", item);
					[typeitem, item];
				})
			});
			itemIds.collect({ arg id;
				lib.libIdToStrings(id);
			}).select({ arg strings;
				if(searchBox.string.trim != "") {
					strings.join(" ").toLower.contains(searchBox.string.toLower)
				} {
					true
				}
			})
			}).flatten.do { arg strings;
				view.addItem(strings)
			}
		})
		.selection({ arg view;
			selectedCallback.(itemIds[view.currentItem.index], view.currentItem.strings)
		})
	;
	lay = VLayout (
		searchBox,
		[resultView, stretch:3],
		[HLayout (
			typeView,
			categoryView,
			ListView.new,
		), stretch:1]
	);
	lay;


});

WindowDef(\ClipList_NewInstrument,{ arg def;
	var namefield = TextField.new;
	var trackInstrumentLabel = StaticText.new;
	var lib = ProtoDef(\GlobalLibrary);
	var selectedCallback = { arg libid, strings;
		"selectedCallback".debug;
		trackInstrumentLabel.string = strings.join("   ");
	};
	VLayout(
		HLayout(
			StaticText.new.string_("Track name:"),
			namefield,
		),
		VLayout (
			HLayout (
				StaticText.new.string_("Track instrument:"),
				trackInstrumentLabel,
			),
			WindowDef(\GlobalLibrary).asView(lib, selectedCallback),
		),
		HLayout(
			BasicButton.new.string_("Cancel"),
			BasicButton.new.string_("OK"),
		)
	)

	
});

WindowDef(\ClipList_NewInstrument).front
)
WindowDef(\GlobalLibrary).front(ProtoDef(\GlobalLibrary));
WindowDef(\GlobalLibrary).clear
~xx
TagSpecDef(\SynthDef).list.collect(_.key.postln)
TagSpecDef(\Pdef).list.collect(_.key.postln)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

SampleTimeline(\bla)

Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('voices/feynman.flac'),
	\dur, 1,
	\gain, 1,
)
