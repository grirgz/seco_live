(
	Ndef(~name+++\fx).put(70, \filterIn -> { arg in; 
		Greyhole.ar(in, \delayTime.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \feedback.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(0.61))
	});
)
// END

(
	Ndef(~name+++\fx).put(50, \filter -> { arg in, freqshift=0, freeze=0;
		var sig;
		var chain;
		var chain2;
		in.debug("FUICL");
		sig = in;
		chain = FFT({LocalBuf(2048)}!2, in);
		// moves in and out of freeze
		chain = PV_MagFreeze(chain, freeze );
		sig = IFFT(chain);

		sig;
	});
)
