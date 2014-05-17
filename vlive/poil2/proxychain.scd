
(

q = q ? ();


q.numChans = 2; 


ProxyChain.add(	
	\infx4, \mix -> { arg inbus;
		var in = InFeedback.ar(inbus, 2);
		//var in = In.ar(inbus, 2);
		in;
	},

	\dust, \mix -> { |dens=20, dustdec=0.02, dustfreq= 600| 
		Ringz.ar(Dust.ar(dens).lag(0.0001), dustfreq, dustdec)  ! 2
	},

	\ringmod, \filter -> { |in, randrate=5| 
		//in.asArray[0] // force mono inputs
		in * SinOsc.ar(LFNoise0.kr([randrate, randrate]).exprange(300, 3000)).sum 
	}, 

	\dist, \filter -> { |in, drive=10, amp=0.2| 
		//(in.asArray[0]
		(in * drive).clip2(0.5) * amp 
	},

	\riseComb5, \filterIn -> { arg in, delay = 0.023, dlDrift = 0.02, spread=0.5, mypan=0, decayRise=0.5, decayFall=100;

		var delayscales = 2 ** ((0 .. q.numChans - 1) * 2 / (q.numChans - 1) - 1 * spread); 
		var dels = delayscales.scramble.collect { |dscale| 
			var timedrift = LFDNoise3.kr(0.3, dlDrift, 1) * dscale;
			var ampcomp = (20 * decayRise).dbamp * (decayFall ** -0.25);
			var combs; 

			in = in.asArray[0] * ampcomp.lag(0.2);
			combs = (decayFall * [ 1, decayRise]).collect { |decay| 
				CombL.ar(in, 1, delay * dscale, decay * delay) 
			};

			combs[0] - combs[1];	// combs come in slowly, like formlet. 
		};

		Splay.ar(dels, 1,1,mypan);
	}, 

	\ampFin, \filter -> { |in, drive=1, ampLimit=1, lAmp=1| 
		Limiter.ar(in * drive, ampLimit) * lAmp;
	},

	\rlpf, \filter -> { |in, rlpfreq=500, rlprq=0.3| 
		RLPF.ar(in, rlpfreq, rlprq);
	}

);


// add specs for the controls used (for NodeProxyEditor).

Spec.add(\dens, [0.1, 1000, \exp]);
Spec.add(\dustamp, [0, 1, \amp]);
Spec.add(\dustdec, [0.0001, 0.1, \exp]); 
Spec.add(\dustfreq, \freq); 
Spec.add(\dt, [0.001, 0.2, \exp]); 
Spec.add(\dc, [0.01, 100, \exp]); 
Spec.add(\drive, [1, 100, \exp]); 
Spec.add(\spread, [0, 1, \amp]); 
Spec.add(\decayRise, [0, 0.9, \amp]); 
Spec.add(\decayFall, [1, 1000, \exp]); 
Spec.add(\dlDrift, [0, 0.1, \amp]); 
Spec.add(\mypan, \bipolar.asSpec); 
Spec.add(\rlpfreq, \freq.asSpec); 
Spec.add(\rlprq, \rq.asSpec); 

);
