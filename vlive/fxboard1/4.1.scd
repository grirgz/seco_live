
Ndef(~name+++\fx).put(0, { arg amp=1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	sig = SelectX.ar(\mix.kr(0), [DC.ar(0), in]);
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4/~t),\damp.kr(0.6),\size.kr(1.1), \diff.kr(0.407) , \feedback.kr(0.79), \modDepth.kr(0.01), \modFreq.kr(8)
	);
	amp = amp * \gain.kr(1);
	amp = amp * \xamp.kr(1);
	sig = SelectX.ar(\postmix.kr(1), [in, sig]);
	sig = sig * amp;
	sig;
});

// END

~t

Ndef(~name+++\fx).set(\lpf, 100)

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).get(\inbus)
~name

(
~win = Window.new;
~sl = Knob.new(~win);
~sl2 = Knob.new(~win, Rect(50,50));
MIDIMap.mapView(\s1, ~sl);
MIDIMap.mapView(\s2, ~sl2);
~win.front;
)
MIDIMap(\s2, [Ndef(~name+++\fx), \amp]);



