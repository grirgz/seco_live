
~make_fx.();

(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;

	sig = Fb({ arg fb;
		var del;
		fb = sig + (fb * 0.99) * \fb.kr(1);
		8.do {
			del = TRand.kr(0.01,Impulse.kr(1));
			fb = fb + DelayL.ar(fb, del,del);
			fb = fb / 2;
		};
		fb.debug("hey");
		//fb = FreqShift.ar(fb, (0-[1,2,3,4,5,6,7,8,9].clump(2).scramble*0.2)).sum/9;
		fb.debug("h1y");
		fb;

	},\delay.kr(0.1));
	sig.postln;
	sig = Normalizer.ar(sig, 0.99,0.1);
	sig = sig * 4;
	
	sig;
});
);

// END
(0-[1,2,3,4,5,6,7,8,9].scramble) *.t [1,1]
~set_macro.(\k1, Ndef(~name+++\fx), \fb, \unipolar.asSpec);
