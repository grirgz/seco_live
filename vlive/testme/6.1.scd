
(
SynthDef(\sawman, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.001,0.9,1,0.999,1.01]);
	sig = LFTri.ar(freq * (SinOsc.ar(freq*10) * 0.9 + 1)) + sig;
	sig = RLPF.ar(sig, ffreq * [0.7,0.6,1.2], rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(\plop, Pbind());
Pdef(\main, Pdef(\plop) <> Pbind(\instrument, \sawman)).play;
)
Env

~macro = VecoLib.lib[\class_rack].new(\plop, \bla, [[Pdef(\plop), \freq, ControlSpec(100,10000,\exp, 0, 100)]]);
~macro.map_midi
~macro.params

8.do { arg x; x=x+1; MIDIBoard.unmap(\k+++x) }

(
~macro = VecoLib.lib[\class_rack].new(\plop, \bla, [
	[Pdef(\plop), \freq, ControlSpec(100,10000,\exp, 0, 100)],
	[Pdef(\plop), \ffreq, ControlSpec(100,10000,\exp, 0, 100)]
]);
);

~macro.make_window

~macro.controllers.values[0].target_get
MIDIBoard.permanent

~macro.new_from_object(Pdef(\plop))
VecoLib.lib[\class_rack].new_from_object(Pdef(\plop)).make_window
Pdef(\plop).envir
~a = Pbind()
~a.play
~a.set(\freq, 700)

\freq.asSpec.default
Pdef(\plop).clear
Pdef(\plop).setBusMode(\freq)
Pdef(\plop).setBusMode(\ffreq)
Pdef(\plop).set(\rq, 0.3)
Pdef(\plop).set(\ffreq, 1000.3)
Pdef(\plop).set(\freq, 1000.3)
VecoLib.lib[\make_view_from_macrokey].([Pdef(\plop), \ffreq, \freq.asSpec])
VecoLib.lib[\make_view_from_macrokey].([Pdef(\plop), \rq, \rq.asSpec])
~macro = VecoLib.lib[\new_macro].([Pdef(\plop), \ffreq, \freq.asSpec])
VecoLib.lib[\].([Pdef(\plop), \ffreq, \freq.asSpec])
VecoLib.lib[\class_rack_control_scalar_view].new(~macro);
VecoLib.load_lib
VecoLib.lib[\make_view_from_macrokey].(1)

(

	{
		var win;
		var layout;
		var k1, k2;
		var but;
		win = Window.new;

		k1 = VecoLib.lib[\make_view_from_macrokey].([Pdef(\plop), \ffreq, \freq.asSpec]);
		k2 = VecoLib.lib[\make_view_from_macrokey].([Pdef(\plop), \rq, \rq.asSpec]);
		//layout.add(k1.make_layout);
		//layout.add(k2.make_layout);

		//but = Slider.new;
		//k1.layout.debug("jkkjkjkjkj");
		//layout = HLayout.new(k1.make_layout, k2.make_layout);
		layout = VLayout.new(k1.make_layout, k2.make_layout);

		win.layout = layout;
		win.front;

	}.value;
)
