
~make_fx.();

(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;

	sig = Fb({ arg fb;
		var del;
		var freqshift;
		fb = sig + (fb * 0.97) * \fb.kr(1);
		freqshift = \freqshift.kr(1);
		fb.debug("hey");
		//fb = fb.tanh * 1.4;
		//fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
		//fb = AllpassL.ar(fb, 0.01,\passdelay.kr(0.1),\decay.kr(0)) + fb;
		fb = LPF.ar(fb, \lpf.kr(1000));
		fb.debug("h1y");
		fb;

	},\delay.kr(0.1));
	sig = Fb({ arg fb;
		var del;
		var freqshift;
		fb = sig + (fb * 0.97) * \fb.kr(1);
		freqshift = \freqshift.kr(1);
		fb.debug("hey");
		//fb = fb.tanh * 1.4;
		//fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
		//fb = AllpassL.ar(fb, 0.01,\passdelay.kr(0.1),\decay.kr(0)) + fb;
		fb = LPF.ar(fb, \lpf.kr(1000));
		fb.debug("h1y");
		fb;

	},\delay.kr(0.1)*[1,2,4,8].mirror2.clump(2));
	sig.postln;
	sig = Normalizer.ar(sig, 0.99,0.001);
	sig = sig / 1;
	
	sig;
});
);

// END
(0-[1,2,3,4,5,6,7,8,9].scramble) *.t [1,1]
~set_macro.(\k9, Ndef(~name+++\fx), \fb, \unipolar.asSpec);
