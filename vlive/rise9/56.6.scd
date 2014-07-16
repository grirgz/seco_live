
~make_fx.();

(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;

	in.debug("kjkjkjkj");
	sig = Fb({ arg fb;
		var del;
		var freqshift;
		fb = sig + (fb * 0.97 * \fb.kr(1));
		freqshift = \freqshift.kr(1);
		freqshift = Duty.ar(1, 0, Dseq([10,0,-20,0]*1,inf) + Dstutter(8,Dseq([0,-50,0,50],inf)));
		fb.debug("hey");
		//fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
		//fb = AllpassL.ar(fb, 0.01,\passdelay.kr(0.1),\decay.kr(0)) + fb;
		fb = fb.tanh;
		//fb = fb / 2;
		fb = LPF.ar(fb,\lpf.kr(5000));
		fb.debug("h1y");
		fb;

	},\delay.kr(0.1) * [1,2,1/2]);
	sig.postln;
	sig = Normalizer.ar(sig, 0.99,0.001);
	sig = sig / 2;
	
	sig;
});
);

// END
(0-[1,2,3,4,5,6,7,8,9].scramble) *.t [1,1]
~set_macro.(\k9, Ndef(~name+++\fx), \fb, \unipolar.asSpec);
~set_macro.(\k5, Ndef(~name+++\fx), \decay, \unipolar.asSpec);
~set_macro.(\k6, Ndef(~name+++\fx), \lpf, \freq.asSpec);
