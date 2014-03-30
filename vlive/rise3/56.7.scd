(
	Ndef(~name+++\fx).put(60, \filter -> { arg in, ffreq=4000, rq=0.3, modfreq=8, modrange=0.8;
		var sig, sigB;
		var chain;
		var chain2;
		var chainB;
		var trig;
		in.debug("FUICL");
		sig = in;
		ffreq = SinOsc.ar(modfreq) * modrange + 1 * ffreq;
		sig = RLPF.ar(sig, ffreq, rq);

		sig;
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
