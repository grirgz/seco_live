(
	Ndef(~name+++\fx).put(50, \filter -> { arg in, freqshift=0, freeze=0, pvcutoff=0;
		var sig, sigB;
		var chain;
		var chain2;
		var chainB;
		var trig;
		in.debug("FUICL");
		sig = in;
		chain = FFT({LocalBuf(2048)}!2, in);
		chainB = PV_Copy(chain, {LocalBuf(2048)}!2);
		// moves in and out of freeze
		//chain = PV_MagSmooth(chain, 0.9 );
		//chain = SelectX.ar(freeze.lag(0.0561), [chain,chain2]);
    //chain = PV_BrickWall(chain, SinOsc.kr(2.0)*0.05);
    //chain = PV_BrickWall(chain, pvcutoff);
	//trig =  MouseY.kr > 0.5;
		trig =  freeze > 0;
	    chain = PV_Diffuser(chain,trig );
	    chainB = PV_Diffuser(chainB, trig);

		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );


		sig = IFFT(chain);
		sigB = IFFT(chainB);
		sig = SelectX.ar(freeze.lag(0.0561), [sigB,sig]);

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
