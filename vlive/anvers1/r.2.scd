(
Ndef(~name+++\lfo1).quant = 2;
Pdef(~name +++ \preset1, 
	Pbind(
		//\fratioc, Pwhite(0.1,1),

	) <>

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, Veco(~namex).isrest(32),
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(8),
	\fratio, 2,
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	//\modamp, Ndef(~name+++\lfo1),
	\rq, 0.9,
));
//Ndef(~name+++\lfo1, { SinOsc.ar(2*t).range(0.2,1) });

Veco.do { arg name;

	Pdef(~name+++\pre, 
	
		Pbind(
			\isRest, Prout({ arg ev;
				var beats = 8;
				var dur = 4;
				var cover = 4;
				var lagparts = 4;

				var size = beats * dur;
				var seq;
				var seq2;
				seq2 = [
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				] ! 2;
				seq2 = seq2.flat;
				10000.do {
					var pos;
					var spread = 2.rand + 1;
					seq = 0 ! (size);
					pos = (size/8).asInteger.rand * 8;
					(4.rand).do { arg x;
						seq.wrapPut(pos + (x*spread), 1);
					};
					[(size/4).dump, pos, seq+seq2].debug("seq");
					size.do { arg x;
						ev = (seq[x] < 1 and: { seq2[x] < 1 }).yield;
					};
				}

			}),
			\isRest, Prand([
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,1,0,0, 1,0,0,0]),
				//Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,1,0,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,1, 0,0,1,0]),
				Pseq([1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0]),
			],inf) < 1,
			\isRest, Pseq([
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,1,0, 1,0,0,0, 1,0,0,0, 0,0,0,0]),
			],inf) < 1,
			\isRest, Prand([
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,1,0, 1,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
			],inf) < 1,
			\isRest, Pseq([
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,   0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,1,0,   0,0,1,0, 1,0,0,0, 1,0,0,0, 0,0,0,0]),
			],inf) < 1,
			\isRest, Prand([
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,   0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,   0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0,   0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,   0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,1,0,   0,0,1,0, 1,0,0,0, 1,0,0,0, 0,0,0,0]),
				Pseq([0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,   0,1,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0]),
				//Pseq([0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,   0,0,1,0, 0,0,1,0, 1,0,0,0, 0,0,0,0]),
			],inf) < 1,


		)
		<> Pdef(~name+++\preset1) 
	);

}
)

// END

Veco.do { arg name;

	Pdef(~name+++\pre, Pspawner({ arg sp;

		100000.do { arg x;
			var beats = 8;
			var dur = 4;
			var cover = 4;
			var lagparts = 4;
			sp.par(
				Pbind(
					\dur, Pn(1/8,beats*dur*cover ),
					//\pos, Pkey(\pos) + 0.1.rand,
					//\legato, 0.1,
					//\ffreq, (80.0.rand + 40).midicps,
					\isRest, Pseq(
						(1 ! (8.rand + 1)).extend(beats*dur, 0)
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

}

Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset).get_active_score.valpbind.asCompileString
Sdef(~name, \mypreset).get_active_score.print_pbind.replace(" '", "\n\t'").replace("Pbind(", "Pbind(\n\t").drop(-1) ++ "\n)"
Sdef(~name, \mypreset).get_active_score.print_pbind; nil

(
Pdef(\heyi,
Pbind(  
		\instrument, ~name,
        'amp', 0.2,
        'pan', 0.0,
        'fratio', 0.38510476728503,
        'rq', 2.0,
        'fratiob', 0.32249949601659,
        'dmix', Pwhite(0.0,1),
        'rqc', 1.568461287356,
        'fratioc', 0.67942016044464,
        'dmix2', Pwhite(0.0,0.5),
        'pwidth', 0.5,
        'driveamp', 1.1054302325581,
        'distmix', 0.74127906976744,
        'drive', 2.0348837209302,
        'cliplevel', 0.69853488372093,
        'doneActiona', 0.0,
        'doneActionb', 0.0,
        'doneActionc', 0.1,
        'env0', [ Env([ 0.001, 1.0000001392097, 0.50000000352667, 0.001 ], [ 0.01, 0.07406809444692, 0.23484117149916 ], [ -4, -2, -4 ]) ],
        'env1', [ Env([ 5.0, 125.31636619568, 5.0 ], [ 0.01, 6.0147651653305 ], [ -4, 5 ]) ],
        'env0c', [ Env([ 0.001, 8.0, 7.9133244676473, 0.001 ], [ 0.01, 0.048770101334993, 0.12467354721218 ], [ -4, -2, -4 ]) ],
        'env1c', [ Env([ 5.0, 90.195294566435, 5.0 ], [ 0.038442061266311, 0.86278728174395 ], 1.296) ],
        'env0b', [ Env([ 0.001, 3.9192986051749, 8.0, 0.001 ], [ 0.01, 0.03183850023695, 0.28514530228853 ], [ -4, -2, -4 ]) ],
        'env1b', [ Env([ 73.65636363636, 29.79045527469, 27.14 ], [ 0.10947448794399, 1.8549443678928 ], -2.34) ]
)
).play;
)


(
Pdef(\heyi,
Pbind(  
		\instrument, ~name,
        'amp', 0.2,
        'pan', 0.0,
        'fratio', 0.38510476728503,
        'rq', 2.0,
        'fratiob', 0.32249949601659,
        'dmix', 0.48255813953488,
        'rqc', 1.568461287356,
        'fratioc', 0.67942016044464,
        'dmix2', 0.16279069767442,
        'pwidth', 0.5,
        'driveamp', 1.1054302325581,
        'distmix', 0.74127906976744,
        'drive', 2.0348837209302,
        'cliplevel', 0.69853488372093,
        'doneActiona', 0.0,
        'doneActionb', 0.0,
        'doneActionc', 0.1,
        'env0', [ Env([ 0.001, 1.0000001392097, 0.50000000352667, 0.001 ], [ 0.01, 0.07406809444692, 0.23484117149916 ], [ -4, -2, -4 ]) ],
        'env1', [ Env([ 5.0, 125.31636619568, 5.0 ], [ 0.01, 6.0147651653305 ], [ -4, 5 ]) ],
        'env0c', [ Env([ 0.001, 8.0, 7.9133244676473, 0.001 ], [ 0.01, 0.048770101334993, 0.12467354721218 ], [ -4, -2, -4 ]) ],
        'env1c', [ Env([ 5.0, 90.195294566435, 5.0 ], [ 0.038442061266311, 0.86278728174395 ], 1.296) ],
        'env0b', [ Env([ 0.001, 3.9192986051749, 8.0, 0.001 ], [ 0.01, 0.03183850023695, 0.28514530228853 ], [ -4, -2, -4 ]) ],
        'env1b', [ Env([ 73.65636363636, 29.79045527469, 27.14 ], [ 0.10947448794399, 1.8549443678928 ], -2.34) ]
)
).play;
)