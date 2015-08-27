
Param(Pdef(\plop, Pbind()), \freq).edit
~p = Param(Pdef(\plop, Pbind()), \xfreq, XDoneActionSpec.new)
~p.get
~p.normGet
~p.type
Param(Pdef(\plop, Pbind()), \doneAction).spec
Param(Pdef(\plop, Pbind()), \out).spec
Param((out:0), \out).spec
Param(Pdef(\plop, Pbind()), \doneAction).type
Param(Pdef(\plop, Pbind()), \out).type
Param((out:0), \out).type
Param(Pdef(\plop, Pbind()), \freq).type
Param((out:0), \out).spec
DrumRack(\test).edit
DrumRack(\test).drumrack.get_pad(2).list.first.paramlist.do({ arg x; "% -- % -- %".format(x.property, x.spec, x.type).postln })
DrumRack(\test).drumrack.get_pad(2).list.first.paramlist.do({ arg x; "% -- % -- %".format(x.property, x.spec, x.type).postln })
~pt = DrumRack(\test).drumrack.get_pad(2).list.first.params
Param(~pt, \ffreqtab, ).edit
~ptspec = DrumRack(\test).drumrack.get_pad(2).list.first.paramlist.detect({ arg x; x.property.debug("prop") == \ffreqtab }).spec
Param(~pt, \ffreqtab, ~ptspec).edit
Param(~pt, \ffreqtab, XArraySpec(\freq!8)).edit
Param(~pt, \ffreqtab, XArraySpec(\freq!8)).type
~pt[\ffreqtab].dump


Param(Pdef(\plop), \tab, XArraySpec(\freq!8)).edit
Param((tab:0!8), \tab, XArraySpec(\freq!8)).edit


~m = (freq:[[100,300,500]])
~m.addHalo(\nestMode, true)
Param(~m, \freq, XArraySpec(\freq!3)).edit
Param(~m, \freq, XArraySpec(\freq!3)).get
Param(~m, \freq, XArraySpec(\freq!3)).type
Param((), \freq, XArraySpec(\freq!3)).type
Param((), \freq, XArraySpec(\freq!3)).get

Param(Pdef(\plop, Pbind()), \ffreqtab, XArraySpec(\freq!8)).edit
Param(Pdef(\plop, Pbind()), \ffreqtab, XArraySpec(\freq!8)).edit



~a = (bla:300, chien: { arg self, v; self[\bla]}, chien_:{ arg self, val; self[\bla] = val });
~m = Message(~a);
~p = Param(~m, \chien, \freq);
Param(~m, \chien, \freq).edit
Param(~m, \chien, \freq).controllerTarget
Param(~m, \chien, \freq).target.receiver

Param.defaultUpdateMode = \polling
~a
~a.chien = 150
~a.changed(\set)
~a.changed(\set)
~m.changed(\set)

WindowLayout({ NumberBox.new.mapParam(~p) })





(
w = Window.new("The Eightfold Path").front;
m = PopUpMenu(w, Rect(10, 10, 180, 20));

m.items = [
 "right view", "right thinking", "right mindfulness", "right speech",
 "right action", "right diligence", "right concentration", "right livelihood"
];

m.background_(Color.green(0.7));  // only changes the look of displayed item
m.stringColor_(Color.white);   // only changes the look of displayed item
//m.font_(Font("Courier", 13));   // only changes the look of displayed item
m.action = { arg menu;
 [menu.value, menu.item].postln;
};
)

m.stringColor_(Color.white);   // only changes the look of displayed item
m.stringColor_(Color.black);   // only changes the look of displayed item

m.font
f= m.font;
f= Font("Arial", 13)
m.font = f
m.font = Font.default
f.size = 14
f = f.boldVariant
f.dump
f.bold = false
f.bold = true
f.italic = true
Window.font
m.font_(Font("Courier", 13));   // only changes the look of displayed item
m.font_(Font("Arial", 13));   // only changes the look of displayed item
m.value;   // returns the index of the current item;
m.item;    // returns the String or Symbol of the current item

m.value_(2);  // changes the displayed item, but does not evaluate the action
m.valueAction_(3); // evaluates the action.


////////////////////////////////////////////// sample chooser


(
	~p = Param(Pdef(\plop, Pbind()), \bufnum);
	WindowLayout({
		var pathfield = TextField.new;
		var waveview = SoundFileView.new;
		VLayout(
			waveview,
			HLayout(
				pathfield,
				Button.new.action_( {
					Dialog.openPanel({ arg path;
						var soundfile;
						var buf;
						path.postln;
						buf = BufferPool.get_stereo_sample(\param, path);
						pathfield.string = path;
						soundfile = SoundFile(path);
						waveview.readFile(soundfile);
						soundfile.close;
						~p.set(buf);
					},{
						"cancelled".postln; 
					});
				})
			)
		)

	});
)

~p.get
~p.set(3)
~p

FileDialog
Dialog

(
	~p = Param(Pdef(\plop, Pbind()), \bufnum);
	WindowLayout({
		~scv = SampleChooserView.new.mapParam(~p); ~scv.view
		//SampleChooserView.new.view

	});
)

~scv.action
~scv.value
~scv.view.action.()
~scv.view.action = { "yiy".debug }

(
	~p = Param(Pdef(\plop, Pbind()), \bufnum);
	WindowLayout({
		~p.asView
		//SampleChooserView.new.view

	});
)
