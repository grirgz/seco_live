
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var route;

	freq = 120 * Duty.kr(1/~t, 0, Dseq([
		[0,3,7,12,-12],
	],inf)).midiratio *.x [1/2,1,2]
	* Duty.kr(4/~t, 0, Dseq([
		0,2,
	],inf)).midiratio
	;

	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq) * ( SinOsc.kr(1/7/5 * (1..8)/8).range(0,4) ) )));
	sig.debug("sig");

	route = [
		[0,0,0],
		[0,0,0],
		[0,0,0],
		[0,0,0],
	];

	fxs = [
		{ arg in; in.fold2(SinOsc.kr(1).range(0.5,1)) },
		{ arg in; in.fold2(SinOsc.kr(1).range(0.5,1)) },
		{ arg in; in.fold2(SinOsc.kr(1).range(0.5,1)) },
	];

	outs = [0,0,0]

	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;

		fxs.do { arg fx, x;
			var sigfx = fx.(ins[x]);
			outs[x] = sigfx * route[3];
			outs[x] = sigfx * route[3];
		
		}

		route.do { arg stage;
			stage.do { arg x;
				outs[x] = fxs[x].()

			
			}
		
		};

		isig = Limiter.ar(isig);
		isig;
		outs;
	};

	sig.debug("sig");

	//sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.001,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	pan = 1;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig;
});

Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([2],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,1.73) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		1,1,
	],inf),
	\dur, 1,
));
)

