Ndef(~name+++\fx).put(50, \filter -> { |in, delay = 1, fb = 0.8, sep = 0.012|
	var input = in;
	var output = input + Fb({

		arg feedback; // this will contain the delayed output from the Fb unit

		var left,right;
		var magic = LeakDC.ar(feedback*fb * \fb2.kr(1) + input);
		magic = HPF.ar(magic, \hpf.kr(400)); // filter's on the feedback path
		magic = LPF.ar(magic, \lpf.kr(5000));
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		#left, right = magic; // let's have named variables for the left and right channels
		magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

	},1,delay);
	output;
});

// END

// Example Usage
~echo = Synth(\dubecho, [\length, TempoClock.default.tempo*(3/8), \fb, 0.7, \sep, 0.0012], addAction: \addToTail);
~echo.free;
~echo.set(\gate, 0);
~set_macro.(\k3, Ndef(~name+++\fx), \lpf, \freq.asSpec)
~set_macro.(\k4, Ndef(~name+++\fx), \hpf, \freq.asSpec)
~set_macro.(\k5, Ndef(~name+++\fx), \fb2, \unipolar.asSpec)
~set_macro.(\k6, Ndef(~name+++\fx), \sep, ControlSpec(0.001,0.024))
