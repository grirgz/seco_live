Pdef(~name +++ \preset1, Pbind(
	\isRest1, Veco(~namex).isrest(32),
	\isRest2, Pseq([
		Pseq([
			0.2,0.9,0.9,0.9,
			0.9,0.9,0.9,0.9,
		].coin)
	],inf),
	\isRest2, Plazy({
		Pseq([
			0.9, 0.95
		].coin)
	}).loop,
	\isRest, Pfunc{ arg ev;
		(ev[\isRest1].not or: ev[\isRest2].not).not
	},
	\isRest, Pkey(\isRest1),
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	//\amp, Pfunc({ arg ev;
	//	var amp = ev[\amp];
	//	if( ev[\isRest1] and: ev[\isRest2].not ) {
	//		amp = amp * 0.5;
	//	};
	//	amp
	//})
));


Pdef(~name+++\pre, Pspawner({ arg sp;

	var name = ~name;
	100000.do { arg x;
		var beats = 8;
		var dur = 4;
		var cover = 4;
		var lagparts = 4;
		sp.par(
			Pbind(
				\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.4], [-4, -2, -4]) ],
				\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
				\dur, Pn(1/8,beats*dur*cover ),
				//\pos, 1.0.rand,
				\amp, 1.1,
				\legato, 1.1,
				\ffreq, (100.0.rand + 10).midicps,
				\isRest, Pseq(
					(1 ! (4.rand + 1)).extend(beats*dur, 0)
				,inf) < 1,
				\isRest, [
					Pseq( (1 ! (4.rand + 1)).extend(beats*dur, 0), inf ),
					Pseq( (1 ! (8.rand + 1)).extend(beats*dur, 0).collect({ arg aa, num; 
						if(aa==1) {
							if(num.odd) { 0 } { 1 }  
						} { 
							0;
						}
					}), inf ),
					Pseq( (1 ! (8.rand + 1)).extend(beats*dur, 0).collect({ arg aa, num; 
						if(aa==1) {
							if(num % 3 == 0) { 1 } { 0 }  
						} { 
							0;
						}
					}), inf ),
				].choose < 1,
				\lag, lagparts.rand / lagparts * dur / t,
			) <>
			Pdef(name+++\preset1)
		);
		dur.wait;
	};
	
}));


// END

[0.6]
1.odd
