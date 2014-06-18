Pdef(~name +++ \pre, Pbind(
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
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.11], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	//\amp, Pfunc({ arg ev;
	//	var amp = ev[\amp];
	//	if( ev[\isRest1] and: ev[\isRest2].not ) {
	//		amp = amp * 0.5;
	//	};
	//	amp
	//}),
	\cuspfreq, Pseq([500,3000],inf).stutter(2) + Prand([Pwhite(0,100),Pwhite(5000,6000)],inf).stutter(4),
	\amp, Pkey(\amp),
	\cuspfreq, Pseq([100,200],inf)  + Pseq([0,1000,5000,500],inf).stutter(16),
	\cuspfreq, Pseq([
		Pser([100,200],16),
		Pser([1000,4200],4),
	],inf),
	\cuspfreq, ~switchsplit.(
		[
			Pser([100,200,500,100],inf),
			Pser([7000,4200],inf),
		],
		3/4,
		64,
	),
	\isRest, Pseq([
		1,0.2,0.5,0.2, 1,0,0.5,0,
		1,0,0,0.2, 0,0,0.5,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0,0.5,0, 1,0,0.5,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,1,1.0,1, 0.5,0,0.5,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0.81,1.0,1, 1,0.91,1.0,1, 
		1.0,0,0.5,0, 0.5,0,0.5,0,
		1.0,0,0.5,0, 0.5,0,0.5,0,
		1.0,0,0.5,0, 0.5,0,0.5,0,
	],inf).coin.not,
	\legato, 0.4,
	\timeScale, Pseq([
		Pseq([
			Pseq([0.1,1,0.2,1.5],4),
			Pseq([0.1,1,0.2,1.5],1).stutter(4),
		],1),
		Pseq([
			Pseq([0.1,1,0.2,1.5],4),
			Pseq([0.1,1,0.2,1.5],1).stutter(4),
		],1) * Pseq([1,1.4],inf),
	],inf),
	\timeScale, Pseq([
		Pseq([0.7,0.2, 0.7,0.2]),
		Pseq([0.7,0.2, 0.7,0.2]),
		Pseq([1.7,1.2, 1.7,1.2]),
		Pseq([1.7,1.2, 1.7,1.2]),
	],inf),
	\lag, 0.15,
	\lag, Pseq([0,0.15,0.010,0.05],inf).stutter(32),
	\lag, Pseq([0,0.01],inf)/t,
	\dur, 1/8,
));

// END

[0.6]

(
~switchsplit = { arg arr, split, size, repeat=inf;
	//Pswitch1(arr, prob*size)
	[(split*size).floor, ( 1-split*size +0.5).floor, (split*size).floor+ ( 1-split*size +0.5).floor].debug("switchsplit");
	Pswitch1(arr, Pseq([Pn(0,(split*size).floor), Pn(1, (1-split*size +0.5).floor)],repeat))
};
~switchsplit.([Pseq([100],inf),Pseq([2000,inf])], 3/4, 8);
)

prob*size


~f.("Pdef(\dfkjflk
sdfdksj	
	j)")



	~fun = {arg code; code.postln;}
// silly but simple: understand a Saw for every SinOsc
this.preProcessor = { |code| code.postln };

{ SinOsc.ar(200) * 0.1 }.play;

preProcessor = nil; // reset to nil.


(
	var text = "Tous ces nombres paraissent bien concrets";
	t = TextView(bounds: Rect(300, 400));
	t.string = text;
	t.front;
	fork {
		loop {
			        2.0.rand.wait;
					defer {
						            t.setFont(Font("Times", rrand(12, 48)), rand(text.size - 1), rrand(3, 17));
									            t.setStringColor(Color.rand, rand(text.size - 1), rrand(3, 17));

												        
					}
					    
		}

	};

)
