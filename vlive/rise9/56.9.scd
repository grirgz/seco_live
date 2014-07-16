
~make_fx.();

(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;

	sig = Fb({ arg fb;
		var del;
		var freqshift;
		fb = sig + (fb * 0.97) * \fb.kr(1);
		freqshift = \freqshift.kr(1);
		freqshift = Duty.ar(1/4, 0, Dseq([10,0,-20,0]*1,inf) + Dstutter(8,Dseq([0,-50,0,50],inf)));
		fb.debug("hey");
		fb = fb + FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*freqshift)).sum/6;
		fb.debug("h1y");
		fb;

	},1/4,\delay.kr(1/4));
	sig.postln;
	sig = Normalizer.ar(sig, 0.99,0.001);
	sig = sig / 1;
	
	sig;
});
);

// END
(0-[1,2,3,4,5,6,7,8,9].scramble) *.t [1,1]
~set_macro.(\k9, Ndef(~name+++\fx), \fb, \unipolar.asSpec);



