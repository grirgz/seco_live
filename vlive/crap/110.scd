// make a JITView: value, parent, bounds
j = JITView(123, nil, Rect(10, Window.screenBounds.height - 100, 300, 40));

// much of its internals are in a dict
j.dict;

// set its label (on the top left);
j.label_(\yo);
j.label_(\yoyoYO);

// if its parent is a window:
j.parent.name_("My JITView window");

// set its value - can be anything
j.value_(\symbol);
j.value_(nil);
j.value_( Pdefn(\abc, 123) );

j.value_(30);
// floats are shown as floats
j.value_(30.0);
j.value_([30, 300]);
j.value_([30, 300, 3000]);


// checkNum is a utility used to determine whether a value object
// is a number or numbers; in effect, whether it can be rounded:
// 0 if not a number, 1 if a single number, 2 if array of all numbers.
// (arrays of arrays of numbers not supported yet)
j.checkNum(12);     // -> 1, can round
j.checkNum(nil); // -> 0
j.checkNum([12, 12]); // -> 2, can round

j.value_(10.123456); //default round is 0.0001
j.putDict(\round, 0.01).refresh;
j.putDict(\round, nil).refresh; //back to default 0.0001
j.putDict(\round, 0).refresh; // no rounding

j.action.add(\test, { |jv| "jv value is: %\n".postf(jv.value) });

// hitting enter on the view does action, or this:
j.doAction;

// BASIC display mode of JITView is \code;
// subclasses like MView have others, such as \number.
// as there is only one mode, there is no real need to switch to others
j.mode_(\code);
// shortcut: typing alt-c on the view also switches to code mode.
// or code shortcut:
j.code;

/* in code mode, one can enter any valid bit of code as value,
    and it will be shown as a compileString.
    -> tab to display current value as editString
    -> backspace to delete char,
    -> shift-backspace to clear editString
    -> return to try to enter:
        if ok:
            editStr becomes new value, doAction is called
        if it does not compile, nothing happens
            but a doAction on the previous value.
*/

// JITView can be hilited with a custom string and color,
// e.g. to show a mapping to a control source
j.hilite("sl1");
j.nohilite;
// customize hilite font and color
j.putDict(\hiFontCol, Color.magenta(1.0, 0.6));
j.putDict(\hiFont, Font("Inconsolata", 24));
j.hilite("sl1");
j.nohilite;

j.value = Pdef(\bla, Pbind(\instrument, \default, \freq, 100))
j.value = "Pdef(\\bla, Pbind(\\instrument, \\default, \\freq, 100))"


// to follow - see also
MView.openHelpFile

// switch to a mode that only displays label,
// i.e. no code string, no editing
j.mode_(\nameOnly);
j.mode_(\code);



// make a JITView: value, parent, bounds
m = MView(123, nil, Rect(10, Window.screenBounds.height - 100, 300, 40));
// needs a spec to display proper number range
m.putDict(\myspec, \freq.asSpec.copy.step_(0.01)).refresh;
m.label_(\freq);

// now set its mode:
m.mode_(\number);
m.mode_(\code);
m.mode_(\number);

// \number mode works as follows:
// value can be a single number, or an array of numbers.
m.value_(30.0);
m.value_([30, 300]);
m.value_([30, 300, 3000]);

m.action.add(\boing, { |mv| [\boing, mv.value].postcs });

/* single number behavior:
*    grabbing slider and moving it sets value and does action
*    x sets to minval,
    m to maxval,
    c to center,
    r to random value
*/
m.valueAction_(666);
m.uv.keyDown($r);
m.uv.keyDown($c);


// multi-number behavior:
m.valueAction = [60, 600, 6000];
m.uv.keyDown($r);
m.uv.keyDown($c);
m.uv.keyDown($R);
m.uv.keyDown($C);

/*
*    one can change values in one of these modes:
*    click-dragging onto a single dot moves just that number within in the array
*     click-dragging on the right margin area rescales values by maxval
*     click-dragging on the left margin area rescales values by minval
*     click-dragging anywhere else shifts range of entire array of values

* key actions:
    x = shift all vals so that minItem is minval
    m = shift all vals so that maxItem becomes maxval
    c = shift range so mean(minItem, maxItem) becomes center of range (norm 0.5)
    r = move range of values as is by a random amount

    X = set all vals to minval
    M = set all vals to maxval
    C = set all vals to center of range (norm. 0.5)
    R = randomize all values

*/
//
m.putDict(\shiftMode, \clip);
m.putDict(\shiftMode, \stop);


m.putDict(\knobCol, Color.grey(0.4, 0.7));
m.putDict(\knobCol, Color.red(alpha:0.2));

///////////////////////////////////////////////////////

Pdef(\test, Pbind(\dur, 0.25)).play;

// try the different click-drag modes,
// and try typing in different values
m.action.add(\setPdef, { |mv| Pdef(\test).set(\freq, mv.value) });


/* MView can show ghost values.
    this is helpful when using controllers whose physical position
    may differ from the param they are controlling.
    (e.g. after switching presets, etc etc)
*/

(
// make an MView
m = MView(123, nil, Rect(10, Window.screenBounds.height - 100, 300, 40));
m.putDict(\myspec, \freq.asSpec.copy.step_(0.01)).refresh;
m.label_(\freq);
m.action.add(\boing, { |mv| [\boing, mv.value].postcs });
)

// use MView to control an Ndef:

// make an Ndef
Ndef(\x, { VarSaw.ar(\freq.kr(100).lag(0.1) + [-0.1, 0.1]) * 0.2 }).play;
// test setting directly:
Ndef(\x).set(\freq, exprand(100, 500));
// use MView to set Ndef freq param
m.action.add(\set_x, { Ndef(\x).set(\freq, m.value.postln) });
// make a skipjack to set MView to ndefs freq value
z = SkipJack({ m.value = Ndef(\x).get(\freq); }, 0.1);

// try setting Ndef freq -> mview gets updated
Ndef(\x).set(\freq, exprand(100, 500));

/*
   When using a controller like a faderbox,
   physical slider controls may be far away from the
   current value of the process param they control.
   In this case, one can use Softset to approach the proper
   physical position and only take over control then.
SoftSet.openHelpFile
*/


// use an EZSlider as a fake physical slider -
// when used directly, it will introduce jumps:
e = EZSlider(nil, nil, \slider1, \freq, { |sl| Ndef(\x).set(\freq, sl.value); });

// better - use SoftSet to only take over when close enough
e.action = { |sl| SoftSet(Ndef(\x), \freq, sl.value); };

(
// even better - use lastVals too, see SoftSet for explanations
e.action = { |sl|
    var lastFreq = e.getHalo(\lastFreq);
    SoftSet(Ndef(\x), \freq, sl.value, lastVal: lastFreq);
    e.addHalo(\lastFreq, sl.value);
};
)

// would be nice to see the failing softsets value on the MView...

    // enable ghost slider to appear, but nothing to show yet:
m.drawFunc.enable(\ghost); m.refresh;
    // show just the label
m.putDict(\ghostLabel, 'sl1').refresh;
    // label + ghost slider (value for ghostPos between 0.0 and 1.0)
m.putDict(\ghostPos, 0.3).refresh;
    // show just the slider
m.putDict(\ghostLabel, nil).refresh;
m.putDict(\ghostLabel, 'sl1').refresh;

(
// Now, show the sliders physical value on mview as ghost,
// so as to know where to move to connect:

e.action = { |sl|
    var lastFreq = e.getHalo(\lastFreq);
    m.putDict(\ghostPos, e.sliderView.value);
    SoftSet(Ndef(\x), \freq, sl.value, lastVal: lastFreq);
    e.addHalo(\lastFreq, sl.value);
};
)

