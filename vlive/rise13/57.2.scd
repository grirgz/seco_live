
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var end1, end2, end3, end4, end5, end6;
	var sig1, sig2, sig3;
	var preamp;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var randclk;
	var pitch;
	var sr, phasor;
	var delay;
	
	sig1 = sig;

	sig1 = Fb({ arg fb;
		var ou;
		var val1, val2;
		var maxdelay = 2;
		//var sig1, sig2;
		var isig1, isig2;
		//ou = sig1 + (fb * 0.55 * \fb.kr(1));
		ou = SelectX.ar(\fb.kr(0.5)-0.01, [sig1, fb * 0.95 * \fbratio.kr(1)]);

		end1 = ou * 0;

		delay = 1/2/~t * \delay.kr(1).lag(0.1);
		ou = DelayL.ar(ou, maxdelay, delay);
		ou = RLPF.ar(ou, 2200 * SinOsc.kr(1/2*~t).range(0.5,3.1));
		//ou = FreqShift.ar(ou, 100);
		end2 = ou;


		//delay = 0.1;
		ou = DelayL.ar(ou, maxdelay, delay/2);
		ou = LPF.ar(ou, 2200 * SinOsc.kr(1/32*~t).range(0.5,2.1));
		//ou = ou * SinOsc.ar(Amplitude.kr(ou) + 50 *100);
		ou = Disintegrator.ar(ou, \disprob.kr(0), \disamp.kr(1));
		//ou = FreqShift.ar(ou, 700);
		end3 = ou;


		//ou = DelayL.ar(ou, maxdelay, delay);
		val1 = \shapelim.kr(1)+0.00001;
		val2 = \pdelay.kr(1).lag(0.1)+0.00001;
		ou = AllpassL.ar(ou, maxdelay, val2,val1);
		ou = FreqShift.ar(ou, \freqshift.kr(0)) + ou;
		//ou = ou * 2;
		//ou = SineShaper.ar(ou, \shapelim.kr(1)+0.001);
		//ou = ou.tanh;
		//ou = LPF.ar(ou, 7200 * SinOsc.kr(1/2*~t).range(0.5,2.1));
		end4 = ou;

		ou = DelayL.ar(ou, maxdelay, delay);
		isig1 = ou;
		isig1 = isig1 * 3;
		isig1 = isig1.tanh;
		ou = SelectX.ar(\mixdist.kr(0), [ou, isig1]);
		end5 = ou;

		//amp = LFTri.kr(1*~t).range(1,0.2) * amp;
		ou = 
			0
			+ end1 
			+ end2 
			+ end3 
			+ end4
			+ end5
			;
		ou = ou * 4;
		ou = Limiter.ar(ou);
		ou;
	});

	//sig1 = Normalizer.ar(sig1);
	
	sig1;
});

// END
//Ndef(~name+++\fx).addSpec(\fshift, Contract)
\fshift.asSpec
\freqshift.asSpec
