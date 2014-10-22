
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	sig = DynKlang.ar(Ref([\klangfreq.kr({700.rand+50}!32), \klangamp.kr({ 0.1 }!32), \klangphase.kr({ 0 }!32)]));
	//sig.postln;
	sig = sig / 1;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

(
Ndef(~name+++\fx).put(1, \set -> Pbind(
	\prog, Pseq((1..128),inf),
	\klangfreq, Pseq([
		Pfunc({ arg ev;
			var res;
			//[( {900.0.rand+450}!32 )];
			res = 8.collect { arg x;
				var res;
				var res1;
				var res2;
				var res3;
				var res4;
				res1 = cos(x * ev[\prog] ).abs * 100 + 70;
				res2 = cos(res1).abs * 100 + (4*70);
				res3 = cos(res2).abs * 100 + (8*70);
				res4 = cos(res3).abs * 100 + (12*70);
				res = [res1, res2, res3, res4];
				res.postln;
				res;
			};
			res = res.flatten;
			[res];
		})
	],inf),
	\dur, 1,
));
);

(8*70)
