
(
var win = Window(
	"GM demo",
	Rect(
		0,
		0,
		1024,
		600
	)
);

var stackLayoutView = UserView();
var topMenuView = UserView();
var uiView = UserView();
var musicView = UserView();
var trackerView = UserView();
var multiSliderView = UserView();

// Top Menu

var multiButton = ~gm.at(
	\multiButton ).value(
	labels: [ "UI", "Music", "Trackers", "MultiSliders" ],
	borderSize: 0
);

var closeButton = ~gm.at(
	\closeButton ).value(
	borderSize: 0
);

// UI
var button = ~gm.at(
	\simpleButton ).value(
	text: "I'm a simple button!"
);

var feedbackButton = ~gm.at(
	\feedbackButton ).value(
	text: "Button with visual feedback!"
);

var switch = ~gm.at( \switch ).value();

var colorPicker = ~gm.at( \colorPicker ).value();

// Music
var faderSlider = ~gm.at(
	\faderSlider ).value(
	orientation: \vertical
);

var verticalDiamondSlider = ~gm.at(
	\diamondSlider ).value(
	orientation: \vertical,
	minVal: 20,
	value: 100,
	maxVal: 16000,
	growthType: \exp
);

var diamondChaosPad = ~gm.at( \diamondChaosPad ).value();

// Trackers
var simpleTracker = ~gm.at( \simpleTracker ).value();
var duoTracker = ~gm.at( \duoTracker ).value();

// MultiSliders

var multiSlider = ~gm.at(	\multiSlider ).value();

var verticalMultiSlider = ~gm.at(
	\multiSlider ).value(
	orientation: \vertical,
	sliderColor: Color( 0.2, 0.2, 1 )
);

var spaceMultiSlider = ~gm.at(
	\spaceMultiSlider ).value(
	orientation: \horizontal,
	origin: 1,
	end: 0
);

var spaceMultiSlider2 = ~gm.at(
	\spaceMultiSlider ).value(
	orientation: \vertical,
	origin: 1,
	end: 0
);

// Layout setups
win.background_( ~gm.at( \backgroundColor ) ).value();

topMenuView.layout_(
	HLayout(
		[ multiButton, stretch: 9 ],
		[ closeButton, stretch: 1 ]
	)
);

uiView.layout_(
	HLayout(
		[ VLayout(
			button,
			feedbackButton,
			switch
		), stretch: 1 ],
		[ colorPicker, stretch: 1 ]
	)
);

musicView.layout_(
	HLayout(
		VLayout(
			faderSlider,
			verticalDiamondSlider
		),
		diamondChaosPad
	)
);

trackerView.layout_(
	VLayout(
		simpleTracker,
		duoTracker
	)
);

multiSliderView.layout_(
	VLayout(
		HLayout(
			multiSlider,
			verticalMultiSlider
		),
		HLayout(
			spaceMultiSlider,
			spaceMultiSlider2
		)
	)
);

stackLayoutView.layout_(
	StackLayout(
		uiView,
		musicView,
		trackerView,
		multiSliderView
	)
);

win.layout_(
	VLayout(
		[ topMenuView, stretch: 1 ],
		[ stackLayoutView, stretch: 9 ]
	)
);

// Bindings and additionnal setups
button.bindFunction( { "You clicked me!".postln } );
feedbackButton.bindFunction( { "You clicked me!".postln } );

switch.setState( 1 );
switch.bindFunction( { | state |
	case
	{ state == 0 } { "Thing is ON".postln }
	{ state == 1 } { "Thing is OFF".postln }
} );

multiButton.bindFunction( { | state |
	stackLayoutView.layout.index = state;
} );

colorPicker.bindFunction( { | color | win.background_( color ) } );

faderSlider.bindFunction( { | newValue |
	( "You slided to " ++ newValue.asString ).postln } );

verticalDiamondSlider.bindFunction( { | newValue |
	( "You slided to " ++ newValue.asString ).postln } );

diamondChaosPad.bindFunction( { | newValue |
	( "You slided to " ++ newValue.asString ).postln } );

simpleTracker.setTrack( [ 1, 0, 0.25, 1, 0, 0.5, 1, 0 ] );
simpleTracker.bindFunction( { | newValues |
	( "Track is now " ++ newValues.asString ).postln } );

duoTracker.bindFunction( { | newValues |
	( "Track 2 is now " ++ newValues.asString ).postln } );

multiSlider.bindFunction( { | newValues |
	( "Env is now " ++ newValues.asString ).postln } );

verticalMultiSlider.bindFunction( { | newValues |
	( "Env 2 is now " ++ newValues.asString ).postln } );

spaceMultiSlider.bindFunction( { | newValues |
	( "Env 3 is now " ++ newValues.asString ).postln } );

spaceMultiSlider2.bindFunction( { | newValues |
	( "Env 4 is now " ++ newValues.asString ).postln } );

closeButton.bindFunction( {
	"R-R-Ragequit!".postln;
	win.close;
} );

win.front;
)

Window.closeAll