
/////// features
// - preview
// - save/keep
// - remove
// - apply operation to selection
///// nice to have
// - rename (or add label ?)
// - save as
// - add/record

(
	WindowDef(\SampleTimelineManager, {
		var list, refresh;
		var timelines;
		list = ListView.new;
		refresh = {
			var sel = list.selection;
			list.items = TagSpecDef(\SampleTimeline).list.collect({ arg x; 
				if(x.value.recordedFileIsKept) {
					"% (kept)".format(x.value.label)
				} {
					x.value.label
				}
			});
			timelines = TagSpecDef(\SampleTimeline).list.collect(_.value);
			list.selection = sel;
		};
		list.selectionMode = \extended;
		refresh.();
		VLayout(
			HLayout (
				BasicButton.new.string_("play").action_({
					list.selection.do { arg i;
						timelines[i].play;
					};
				}),
				BasicButton.new.string_("stop").action_({
					list.selection.do { arg i;
						timelines[i].stop;
					};
				}),
				BasicButton.new.string_("label").action_({
					list.selection.first !? { arg x; 
						var tl = timelines[x];
						WindowDef(\SampleTimelineManager_RenameDialog, WindowDef(\RenameDialog).front(
							"Change timeline label ?\n\nCurrent label: %\nKey: %\nBuffer: %".format(tl.label, tl.key, tl.buffer.asCompileString),
							tl.label,
							{ arg newlabel;
								tl.label = newlabel;
								refresh.();
							}
						))
					}
				}),
				BasicButton.new.string_("keep").action_({
					list.selection.do { arg i;
						timelines[i].keepRecordedFile;
					};
					refresh.();
				}),
				BasicButton.new.string_("clipboard preset").action_({
					"\n(\n%\n)\n".format(list.selection.collect { arg i;
						timelines[i].presetCompileString;
					}.join("\n\n")).pbcopy;
				}),
				BasicButton.new.string_("remove").action_({
					var flist = list.selection.collect { arg i;
						timelines[i].key
					};
					WindowDef(\SampleTimelineManager_ConfirmDialog, WindowDef(\ConfirmDialog)).front(
						"Are you sure you want to delete theses timelines ?\n\n%".format(flist.collect(_.asString).join("\n")),
						{
							list.selection.do { arg i;
								SampleTimeline.proto.all[timelines[i].key] = nil; // should remove .proto after recompile
							};
							refresh.();
						}
					)
				}),
			),
			list
		)
	});
)
