
(
	~make_fx.();
	Ndef(~name+++\fx).put(50, \filter -> { arg in, freeze=0;
		var sig;
		var chain;
		var chain2;
		var trig;
		in.debug("FUICL");
		sig = in;
		chain = FFT({LocalBuf(2048)}!2, in);
		// moves in and out of freeze
		freeze = Duty.kr(1/4/~t, 0, Dseq([
			0,1,0,1,
		],inf));
		trig =  freeze > 0;
	    chain = PV_Diffuser(chain,trig );
		//chain = PV_MagFreeze(chain, freeze );
		sig = IFFT(chain);

		sig;
	});
	Ndef(~name+++\fx).addSpec(\freeze, ControlSpec(0,1,\lin,1))
)
