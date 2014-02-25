(
	~k1 = ~midi.(\k1).valpattern;
	~k2 = ~midi.(\k2, nil, ControlSpec(0.005,4)).valpattern;
	~k3 = ~midi.(\k3, nil, ControlSpec(0.1,2)).valpattern;
	~k4 = ~midi.(\k4, nil, ControlSpec(0.01,0.8)).valpattern;
	~k5 = ~midi.(\k5, nil, ControlSpec(0.1,2)).valpattern;
	~k6 = ~midi.(\k6, nil, ControlSpec(0.001,0.1)).valpattern;
	~k7 = ~midi.(\k7, nil, ControlSpec(0.1,2)).valpattern;
	~k8 = ~midi.(\k8, nil, ControlSpec(0.01,0.3)).valpattern;
	~k9 = ~midi.(\k9, nil, ControlSpec(0.41,2.3)).valpattern;
);
(
8.do { arg nn;
	var nnn = nn+1;

	Pdef(~name +++ nn, Pmono(
		~name,
			\arg1, 100,
			\arg2, Pwhite(40,4000),
			\arg2, 3000,
			\decay, Pwhite(0.01,0.1),
			\decay, 0.1/nnn,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.3) ],
			],inf), 
			\freq, Pwhite(100,1500),
			\freq, Prand([100,1500,200,500,100],inf) * 0.7,
			\freq, Prand([100,1500,200,500,100],inf) * 1,
			\freq, Prand([100,1000,200,500,300,1000],inf) * 1,
			\freq, Pseq([100,1500,200,500,2000,100,250],inf),
			\freq, Pseq([
				100,1500,200,500,
			],inf),
			\freq, Pseq([
				100,1500,200,500,
				100,1500,200,500,
				100,1500,200,500,
				1000,100,1000,
			],inf) * Pseq([1.7,0.2,0.7,0.5],inf) * 1.0,
			\freq, Pseq([
				90,250,470,
				110,150,270,

				90,150,270,
				110,750,270,
			],inf) * Pseq([
				3,1,4,1.5,
				6,4,0.8,1.5,
			],inf) * Pseq([1,0.8,0.5,1.2],inf).stutter(32),
			\freq, Pseq([
				//Pser([100,1000],16),
				//Pser([100,2000],16),
				//Pser([200,1000*nnn],16),
				Pser([200,100]*nnn,16),
				Pser([200,400]*nnn,16),
				Pser([20,40]*nnn,16),
				//100*nnn
			],inf),
			\freq, Pseq([
				//200*log(nnn+1)
				Pser([Pfuncn({~scale.foldAt(nn)},1)],inf) * Pseq([1,2,1/6],1).stutter(16),

				Pser([200,100]*nnn,16),
				Pser([200,400]*nnn,16),
				Pser([20,40]*nnn,16),

				Pser([log(nnn+7)*200],32),
			],inf),
			\flag, Pseq([
				Prand([

				//Pser([1,0.1,1,0.1],16),
				//Pser([1,0.1,1,0.1]/2+0.3,16),
				0.05*nnn,
				0.1,
				//0.7*nnn,
				],inf)
				//Pser([1.12],16),
				//Pser([0.08],16),

			],inf),
			\decay, ~k4/(nnn/~k5),
			\freq, ~k1 * (nnn*~k2),
			\flag, ~k6/(~k7*nnn) ,
			\lag, Pseg(Pseq([0,0.31],inf), 8)*nn,
			\lag, ~k8*(nnn/~k9) * Pwhite(0.1,2),
			\arg2, Pkey(\freq),
			\arg1, Pkey(\freq),
			\sustain, 0.4,
			\dur, Pwhite(0.1,0.4) * 0.8,
			\dur, Pseq([0.5,1,1,0.5],inf) * 0.2,
			\dur, Pseq([0.5,1,1,0.5],inf) * Pseg(Pseq([3,0.2,0.1],inf), 16),
			\dur, ~k3,
		//\freq, 100,
	));
}
);
