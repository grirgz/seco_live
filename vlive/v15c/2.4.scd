Pdef(~name +++ \pre, Pbind(

	\isRest, Veco(~namex).isrest(32),
	\rester,  Pseq([ 
		1,1,1,1,
		1,1,1,0,
	],inf).stutter(8),
	\isRest, Pfunc { arg ev;
		if(ev[\rester] == 1) {
			ev[\isRest]
		} {
			true
		}
	},
	\freq, 100,
));
