
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = DynKlang.ar(Ref([
		\klangfreq.kr({700.rand+50}!32) * ({ LFNoise1.kr(1/( 2 + 14.0.rand )).range(1.0,1.001) } ! 32),
		\klangamp.kr({ 0.1 }!32)* ({ SinOsc.kr(1/(1 + 4.0.rand)).range(0.0,1.001) } ! 32) ,
		\klangphase.kr({ 0 }!32) *  ({ LFNoise1.kr(1/( 2 + 14.0.rand )).range(1.0,1.001) } ! 32)
	]));
	sig.postln;
	sig = sig / 1;
	sig = FreqShift.ar(sig, -0.04 * SinOsc.kr(1/( {4+48.0.rand}!8 ))) + sig;
	sig = (sig * ( SinOsc.kr(1/( {4+48.0.rand}!8 )).range(Line.kr(1,41,10),0.1))).tanh / 1.8;
	sig = RLPF.ar(sig, 
		\lpf.kr(1100) * LFNoise1.kr(1/( {1+4.0.rand}!8 )).range(0.4,2.1) + XLine.kr(0.001,10000,15),
		\rq.kr(0.5));
	//sig = sig1/5 + BPF.ar(sig, \lpf.kr(4100) * LFNoise1.kr(1/( {4+48.0.rand}!8 )).range(0.4,2.1), \rq.kr(0.5));
	sig = HPF.ar(sig, 1000 * XLine.kr(1,0.02,20));
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
});

(
Ndef(~name+++\fx).put(1, \set -> Pbind(
	\prog, Pseq((1..128),inf),
	\klangfreq, Pseq([
		Pfunc({ arg ev;
			var res;
			res = List.new;
			8.do { arg x;
				var y;
				y = (x*3+(7*3) + (4.rand*2)).degreeToKey(Scale.major);
				y = y.midicps;
				res.add(y);
				res.add(y*( 1 + 0.001.rand ));
				res.add(y* ( 1 + 0.005.rand ));
				res.add(y* ( 1 + 0.01.rand ));
				res.add(y* ( 1 + 0.05.rand ));
				res.add(y* ( 1 + 0.1.rand ));
				res;
			};
			res = res[0..31];
			res.postln;
			[res.asArray];
			//[( {900.0.rand+450}!32 )];
		})
	],inf),
	\dur, 1,
));
);

