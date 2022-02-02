
(
/* This script will create a global variable, ~gm, which is a dictionary,

containing both global graphical variables
such as main color, font, etc...

and functions dedicated to create custom Userviews
such as buttons, sliders, etc...

Yon can then get the created objects by using
~gm.at( \function_symbol ).value( arg: value );

*/

// Reference the actual folder name
var currentDir = thisProcess.nowExecutingPath.dirname ++ "/";

~gm = (
	mainColor: Color( 0.75, 0, 0.333 ),
	secondaryColor: Color( 0.5, 0, 0.111 ),
	borderColor: Color( 0.666, 0, 0.125 ),
	backgroundColor: Color( 0, 0, 0 ),
	mainFont: Font.default.size_( 22 ),
	fontColor: Color( 0, 0, 0 ),
	borderSize: 2,
	hasBorderInset: true
);

~gm.put( \simpleButton,
	this.executeFile( ( currentDir ++ "simple_button.scd" ).standardizePath ) );

~gm.put( \closeButton,
	this.executeFile( ( currentDir ++ "close_button.scd" ).standardizePath ) );

~gm.put( \feedbackButton,
	this.executeFile( ( currentDir ++ "simple_feedback_button.scd" ).standardizePath ) );

~gm.put( \switch,
	this.executeFile( ( currentDir ++ "switch_button.scd" ).standardizePath ) );

~gm.put( \multiButton,
	this.executeFile( ( currentDir ++ "multi_button.scd" ).standardizePath ) );

~gm.put( \faderSlider,
	this.executeFile( ( currentDir ++ "fader_slider.scd" ).standardizePath ) );

~gm.put( \diamondSlider,
	this.executeFile( ( currentDir ++ "diamond_slider.scd" ).standardizePath ) );

~gm.put( \simpleTracker,
	this.executeFile( ( currentDir ++ "simple_tracker.scd" ).standardizePath ) );

~gm.put( \multiSlider,
	this.executeFile( ( currentDir ++ "multi_slider.scd" ).standardizePath ) );

~gm.put( \spaceMultiSlider,
	this.executeFile( ( currentDir ++ "space_multi_slider.scd" ).standardizePath ) );

~gm.put( \duoTracker,
	this.executeFile( ( currentDir ++ "duo_tracker.scd" ).standardizePath ) );

~gm.put( \diamondChaosPad,
	this.executeFile( ( currentDir ++ "diamond_chaospad.scd" ).standardizePath ) );

~gm.put( \colorPicker,
	this.executeFile( ( currentDir ++ "color_picker.scd" ).standardizePath ) );
)