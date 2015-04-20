
(
	~make_fx.();
	Ndef(~name+++\fx).put(50, \filter -> { arg in, freeze=0;
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
	Ndef(~name+++\fx).addSpec(\freeze, ControlSpec(0,1,\lin,1))
)
