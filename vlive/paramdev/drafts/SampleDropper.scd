
// goal: drag&drop sample file to ClipTimeline, list com/ directory
(
WindowDef(\SampleDropper, { arg def;
	var tv = TreeView.new;
	var item;
	tv.addItem(["kick"]);
	tv.addItem(["snare"]);
	item = tv.addItem(["hat"]);
	item.addChild(["hat 2"]);
	item.addChild(["hat 3"]);
	tv.beginDragAction = {
		tv.currentItem.strings;
	};
	VLayout (
		tv,
		TextField.new,
	)
	
}).front;
)

NoteTimeline(\bla).edit
