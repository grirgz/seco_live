// moved to Proto/timeline.sc

// stub:

WindowDef(\OverlayMenu, { arg def, menuView, view, x=600, y=600;
	var inview, layout;
	[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 200,100);
		win.endFrontAction = { win.close };
	};
	menuView.(def, view, x, y);
	
}).border_(false);



///////// use lib
(
	WindowDef(\overlaydemo, {

		BasicButton.new.string_("open menu").mouseDownAction_({ arg but, x, y, modifiers, buttonNumber, clickCount;
			[but, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

			if(buttonNumber == 1) { // if right-click

				WindowDef(\OverlayMenu).front({ arg def;
					BasicButton.new.string_("entry 1").action_({
						def.closeWindow;
					})
				}, but, x, y )

			}
		})

	}).front;
)


//////////////////////////////////////////////////////////////////:
//////////////////////////////////////////////////////////////////:
//////////////////////////////////////////////////////////////////:

ContextMenuWindow {
	var <>list;
	var <>action;
	classvar <>window;

	// new(list)
	// list: list of string/symbols as the menu
	// action type: action(contextMenuWindow, selected string)
	
	*new { arg list;
		^super.new.init(list);
	}

	init { arg xlist;
		list = xlist
	}

	close {
		if(window.notNil and: { window.isClosed.not }) {
			window.close;
		};
		window = nil;
	}

	attach { arg view, initAction;
		view.mouseUpAction = {  arg vie, x, y, modifiers, buttonNumber, clickCount;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseUpAction");
			initAction.value(this, view);
			this.front(vie, x, y, buttonNumber)
		};
	}
	
	front { arg view, x, y, mouseButton;
		// FIXME: window width is hardcoded
		var bo = view.absoluteBounds;
		this.close;
		if(mouseButton.notNil and: { mouseButton != 1 }) {
			^this
		};
		window = Window("Context menu",Rect(x+bo.origin.x,Window.screenBounds.height - view.absoluteBounds.top - y,200,200), border:false);
		//[x,y, view.absoluteBounds, view.bounds, Window.screenBounds].debug("BOUDS");
		window.endFrontAction = {
			this.close;
		};
		window.layout_(
			VLayout(
				ListView.new.items_(list).mouseDownAction_({

					//{ win.close }.defer(1);
				}).selectionAction_({ arg me;
					me.selection.debug("context menu selected item");
					if(me.selection.size > 0) {
						try {
							action.(this, me.selection[0]);
						} { arg ex;
							ex.reportError;
							"Exception in context menu action.".postln;
						};
						this.close;
					}
				}).selection_(nil).selectionMode_(\single)
			).margins_(0).spacing_(0)
		);
		window.front;
	}
}

/////////////////////////////////

(
	WindowDef()
	~w = WindowDef(\TimelinePianoKeyboard).front(Pdef(\def))
	NoteTimeline(\no, Pdef(\def)).edit
	NoteTimeline(\no, Pdef(\def)).param.target
	~w.window.bounds

	(
	Pdef(\def, 
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1,
		)
	).play;
	);


ClipTimeline(\lba).edit
ClipTimeline(\lba).clear
NoteTimeline(\hihi).edit
NoteTimeline(\hihi).clear
NoteTimeline(\hihi).wrapper.elAt(60).play
NoteTimeline(\hihi).wrapper.elAt(60).stop
NoteTimeline(\hihi).recorder.startRecording
NoteTimeline(\hihi).recorder.stopRecording
NoteTimeline(\hihi).presetCompileString.editorInsert
Pdef(\NoteTimeline_default).play
(
NoteTimeline('hihi').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \midinote: 77.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.125, \midinote: 73.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.25, \midinote: 68.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 70.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.375, \midinote: 83.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.125, \midinote: 75.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.25, \dur: 0.25, \midinote: 63.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.125, \midinote: 76.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.0, \midinote: 73.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.25, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 77.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

NoteTimeline(\nono).edit
NoteTimeline(\nono).clear
NoteTimeline(\hihi).clear
NoteTimeline(\nono).presetCompileString.editorInsert
(
NoteTimeline('nono').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 37.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 46.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.0, \midinote: 48.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 48.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 39.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.0, \midinote: 49.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 43.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 40.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.125, \midinote: 46.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.25, \midinote: 49.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 45.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1.5, \dur: 0.5, \midinote: 49.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


// FAIL!!!
(
KitTimeline(\kiki, [
	NoteTimeline(\hihi), 
	NoteTimeline(\hoho), 
]).edit
)


FileSystemProject.load("libdef/drumkit.scd")
FileSystemProject.load("libdef/synthplayrec.scd")
KitTimeline(\jojo, PatKitDef(\jaja)).edit
KitTimeline(\jojo).clear


SampleTimeline(\ss);
SampleTimeline(\ss).buffer = BufDef('voices/feynman.flac');
SampleTimeline(\ss).edit
NoteTimeline(\ss).edit



SampleTimeline(\ss).recorder
Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('voices/feynman.flac'),
	\dur, 1,
	\gain, 1,
)

ProtoTemplateDef(\SampleTimelineRecorder).new(SampleTimeline(\ss))


{ SinOsc.ar(700 * ( SinOsc.kr(1/3) * 1 + 1 )) ! 2 * 0.1}.play;
