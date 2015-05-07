

(
~t = ~t ? 1;
Ndef(\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var spread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var route;
	var outs, ins, realouts, fxs;
	var inlevels, fblevels;
	var in;

	freq = \freq.kr(120) * Duty.kr(1/~t, 0, Dseq([
		[0,3,7,12,-12],
	],inf)).midiratio *.x [1/2,1,2]
	* Duty.kr(4/~t, 0, Dseq([
		0,2,
	],inf)).midiratio
	;

	//sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq) * ( SinOsc.kr(1/7/5 * (1..8)/8).range(0,4) ) )));
	sig = SinOsc.ar(freq);
	sig.debug("sig");

	route = [
		[1,1,1], // in
		[1,1,1], // fb

		// routing
		[0,0,0],
		[0,0,0],
		[0,0,0],

		[0,0,1], // real out
	];
	route.flatten.clump(3).debug("route equi");

	route = \route.kr(route.flatten).clump(3);
	route.debug("route clumped");
	//route.poll;

	inlevels = route.removeAt(0);
	fblevels = route.removeAt(0);

	fxs = [
		{ arg in; in.fold2(SinOsc.kr(1).range(0.5,1)) },
		{ arg in; in * LFSaw.ar(100) },
		//{ arg in; in + FreqShift.ar(in, 100) },
		{ arg in; in  },
	];

	outs = [0,0,0];
	realouts = [0,0,0];
	sig.debug("begin sig");
	sig = sig.sum;
	sig.debug("summed sig");
	in = sig;

	sig = Fb ({ arg fb;
		var isig;
		ins = ( fb.debug("fb") * \fb.kr(1) * fblevels ) + ( sig * inlevels ) ;

		ins.debug("ins");

		fxs.do { arg fx, fxidx;
			var sigfx = fxs[fxidx].(ins[fxidx]);
			sigfx.debug("sigfx");
			outs.do { arg ou, outidx;
				[fxidx, outidx].debug("fxidx, outidx");
				outs[outidx] = outs[outidx] + ( sigfx * route[outidx][fxidx].debug("route") );
			};
			sigfx.debug("sigfx2");
			realouts[fxidx] = sigfx * route.last[fxidx].debug("master");
			sigfx.debug("sigfx3");
		};

		outs = Limiter.ar(outs);
		outs.debug("outs");
	}, numChannels:3);
	sig = SelectX.ar(\mix.kr(0), [realouts, in!2]);

	sig.debug("sig");

	//sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.001,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	spread = \spread.kr(1);
	pan = \pan.kr(0);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * spread + pan, amp).mean;
	sig;
}).play;


)

// END

(
	~p  = Param( Ndef(\fx), \route, XArraySpec(\unipolar ! ( 3*(3+3) )) );
	~gui = { arg route_param, additional_params;

		var win;
		var layout;
		var rowlayout;
		var labels = ["In", "Feedback", "fx0", "fx1", "fx2", "Out"];
		var grid;
		var grid2;
		win = Window.new;
		layout = HLayout.new;

		grid = GridLayout.rows(*
			[["", "fx0", "fx1", "fx2"].collect({ arg lab;
				StaticText.new.string_(lab).align_(\center)
			})] ++
			route_param.collect({ arg x; x.asKnob; }).clump(3).collect({ arg row, x;
				[StaticText.new.string_(labels[x])] ++ row;
			});
		);

		grid2 = GridLayout.rows(*
			additional_params.collect({ arg param;
				VLayout(
					param.asStaticTextLabel.align_(\center),
					param.asKnob.fixedWidth_(50),
					param.asStaticText.align_(\center)
				)
			}).clump(4);
		);
		grid = View.new.layout_(grid);
		//grid.minWidth = 300;
		win.view.minWidth = 600;
		grid2 = View.new.layout_(VLayout(grid2, nil));
		grid.background = Color.new(0.8,0.9,0.9);
		grid2.background = Color.new(0.8,0.9,0.8);
		layout.spacing = 15;
		//layout.background = Color.red;
		layout.add(grid);
		layout.add(grid2);
		win.layout = layout;
		win.front;
	};
	~gui.(~p, [
		Param( Ndef(\fx), \fb, ControlSpec(0,2,\lin) ),
		Param( Ndef(\fx), \freq, \freq),
		Param( Ndef(\fx), \pan, \bipolar),
		Param( Ndef(\fx), \spread, \bipolar),
	]);
)
