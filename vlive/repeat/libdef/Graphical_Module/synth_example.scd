
(
var win = Window(
	"GM Example",
	Rect(
		100,
		100,
		300,
		150
	)
);

var slider = ~gm.at( \diamondSlider ).value(
	minVal: 55,
	value: 110,
	maxVal: 880,
	setGrowthType: \exp
);

var synth;

SynthDef( \sine, {
	| out = 0, freq = 110, amp = 0.25 |
	var snd = SinOsc.ar( freq, mul: amp );
	Out.ar( out, [ snd, snd ] )
} ).add;

slider.bindFunction( { | newValue |
	synth.set( \freq, newValue );
	( "You slided to " ++ newValue.asString ).postln } );

win.layout_(
	VLayout(
		slider
	)
);

SystemClock.sched( 0.01, { synth = Synth( \sine ) } );

win.front;
)