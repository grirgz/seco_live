// In Qt GUI:
// To zoom in/out: Shift + right-click + mouse-up/down
// To scroll: right-click + mouse-left/right
(
w = Window.new("soundfile test", Rect(200, 300, 740, 100));
a = SoundFileView.new(w, Rect(20,20, 700, 60));

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
f.inspect;

a.soundfile = f;
a.read(0, f.numFrames);
a.elasticMode = true;

a.timeCursorOn = true;
a.timeCursorColor = Color.red;
a.timeCursorPosition = 2050;
a.drawsWaveForm = true;
a.gridOn = true;
a.gridResolution = 0.2;

w.front;
)

f.numFrames
(
w = Window.new("soundfile test", Rect(200, 300, 740, 100));
a = SoundFileView.new(w, Rect(20,20, 700, 60));

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");

a.soundfile = f;
a.read(0, f.numFrames);
a.elasticMode = true;
a.drawsWaveForm = true;
a.timeCursorOn = true;
a.timeCursorColor = Color.red;
a.timeCursorPosition = 2050;

w.front;
)

a.setSelectionStart(0, 7345);

( // make a simple SoundFileView
y = Window.screenBounds.height - 120;
w = Window.new("soundfile test", Rect(200, y, 740, 100)).alwaysOnTop_(true);
w.front;
a = SoundFileView.new(w, Rect(20,20, 700, 60));

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
// f.inspect;

a.soundfile = f;            // set soundfile
a.read(0, f.numFrames);     // read in the entire file.
a.refresh;                  // refresh to display the file.
)

// In Qt GUI:
// To zoom in/out: Shift + right-click + mouse-up/down
// To scroll: right-click + mouse-left/right

// reading file
a.read(0, f.numFrames / 2).refresh; // read first half
a.read.refresh;                     // read entire file by default
a.read(f.numFrames / 2).refresh;    // read second half
a.read(0, -1).refresh;              // -1 also reads entire file, like buffer.

// In Qt GUI, the resolution of the view is always infinite;
// you can always zoom in until you see a single sample.

// In other GUI kits, 'block' sets the resolution of the view (default is 64).
// i.e. the view keeps peak values for each block of e.g. 64 samples
// rather than the entire waveform.
a.read(0, -1, block: 32).refresh;
a.read(0, -1, block: 24).refresh;
a.read(0, -1, block: 16).refresh;

// for longer files, you can use:
a.readWithTask;

// zoom is relative
a.zoom(0.2).refresh;
a.zoom(2).refresh;
a.zoom(2).refresh;
a.zoomToFrac(0.5); // zoom to half file size
a.zoomAllOut;

a.gridOn = true;            // time grid, 1 second by default,
a.gridResolution = 0.2;     // or set resolution in seconds
a.gridColor = Color.cyan;   // color is changeable.
a.gridOffset_(0.1);         // not sure if this is working?

a.timeCursorOn = true;          // a settable cursor
a.timeCursorPosition = 2050;    // position is in frames.
a.timeCursorColor = Color.white;

// toggle drawing on/off
a.drawsWaveForm = false;
a.drawsWaveForm = true;

// these methods should return view properties:
a.gridOn
a.gridResolution
a.gridColor
a.timeCursorOn
a.timeCursorPosition
a.timeCursorPosition = 180140
a.timeCursorColor

// Selections: multiple selections are supported.
// e.g. use selection 0:
a.setSelectionColor(0, Color.red);  // set...( index, value )
a.selectionStart(0);                // at index
a.setSelectionStart(0, 12345);
a.setSelectionSize(0, 12345);

a.setSelectionStart(0, 1234);
a.selectionStart(0);

// now selection 1
a.setSelectionColor(1, Color.white);
a.setSelectionStart(1, 1234).setSelectionSize(1, 1234 * 2);
a.selectionStart(1);
a.setSelectionStart(0, 12345);

// the current selection gets changed when click/dragging in view.
a.currentSelection;     // index of current selection;
a.currentSelection_(0); // switch current selection - try click/drag white now.
a.currentSelection;

a.selections.size;      // 64 selections
a.selections[0];
a.selections[1];
a.selections;
a.selections.size;

// setSelection (index, selection);
a.setSelection(0, [4234, 2345]);
a.selection(1); // returns [start, size].


a.elasticMode = true;   // not sure if this is working yet?

(       // mouseUpAction
a.mouseUpAction = {
    ("mouseUp, current selection is now:"
        + a.selections[a.currentSelection]).postln;
};
)
// lock selection 0:
a.currentSelection_(0);
a.setEditableSelectionStart(0, false);
a.setEditableSelectionSize(0, false);


// unlock selection 0:
a.setEditableSelectionStart(0, true);
a.setEditableSelectionSize(0, true);

a.selectionStartTime(0);
a.selectionDuration(0);


a.setSelectionStart(0, 12345);
a.setSelectionSize(0, 12345);
a.readSelection.refresh;
a.readSelection(16).refresh;    // in higher resolution
a.read.refresh;                 // go back to entire file.


a.dataNumSamples;   // visual data have this many points
a.data.plot;
a.setData(a.data.reverse);


a.zoom(0.25);       // scrolling is normalized
a.scrollTo(0.5);    //
a.scrollTo(0.6);    //
a.scroll(12);       // scroll is in viewFrames.

a.zoom(4);

w.close;
ParaSpace



(
w = Window.new("ParaSpace", Rect(10, 500, 400, 300)).front;
a = ParaSpace.new(w, bounds: Rect(15, 15, 360, 260));
)



(
var data;
w = Window.new("ParaSpace", Rect(10, 500, 400, 300)).front;
a = ParaSpace.new(w, bounds: Rect(20, 20, 360, 260));
a.inspect


a.nodeTrackAction_({arg node;
	a.setNodeLoc1_(node.spritenum, a.getNodeLoc1(node.spritenum)[0], 0.5 )
});
)

(
~fun = {
	var data;
	var win;
	var space;
	var layout;
	var but;
	var soundview;
	var mwidth = 600;
	var soundfile;
	var update_selections;

	update_selections = {
		space.paraNodes.do { arg node, idx;
			var ux = node.nodeloc.x / mwidth;
			node.nodeloc.debug("nodeloc")
			soundview.setSelectionStart(idx, ux * soundfile.numFrames)

		}
	};

	win = Window.new("yeah ParaSpace").front;
	space = ParaTimeline.new(nil, Rect(0,0,mwidth,50));
	//space = ParaTimeline.new;
	//space.userView.minHeight = 100;
	space.userView.minSize = 70;

	soundview = SoundFileView.new;
	soundview.fixedWidth = mwidth;

	soundfile = SoundFile.new;
	soundfile.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
	soundview.soundfile = soundfile;
	soundview.drawsWaveForm = true;
	soundview.read(0, soundfile.numFrames);

	soundview.timeCursorOn = true;
	soundview.timeCursorColor = Color.red;

	layout = VLayout.new;
	win.layout = layout;
	but = Button.new;
	//layout.add(but);
	layout.add(soundview);
	layout.add(space.userView);



	space.mouseDownAction = { arg me, x, y, mod;
		[x,y,x/mwidth * soundfile.numFrames].debug("x,y");
		if(mod.isCtrl) {
			space.createNode(x,y);
			soundview.timeCursorPosition_(x/mwidth * soundfile.numFrames);
		};
		update_selections.();
	
	};

	space.nodeTrackAction_({arg node;
		var x, y;
		x = space.getNodeLoc1(node.spritenum)[0];
		y = space.getNodeLoc1(node.spritenum)[1];
		[x,y,x/mwidth * soundfile.numFrames].debug("track:x,y");
		space.setNodeLoc1_(node.spritenum, x, 0.5 );
		soundview.timeCursorPosition_(x * soundfile.numFrames);
	});
	
};
~fun.value;
)
