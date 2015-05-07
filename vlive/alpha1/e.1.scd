
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
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
	sig = sig * EnvGen.ar(Env.perc(0.1,0.1),Impulse.kr(2),doneAction:0);
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
		{ arg in; in * LFSaw.ar(\freq2.kr(100)) },
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
		ins = ( fb * \fb.kr(1) * fblevels ) + ( sig * inlevels ) ;

		fxs.do { arg fx, fxidx;
			var sigfx = fxs[fxidx].(ins[fxidx]);
			outs.do { arg ou, outidx;
				outs[outidx] = outs[outidx] + ( sigfx * route[outidx][fxidx] );
			};
			realouts[fxidx] = sigfx * route.last[fxidx];
		};

		outs = Limiter.ar(outs);
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
});


)

// END

(
	~p  = Param( Ndef(~name+++\fx), \route, XArraySpec(\unipolar ! ( 3*(3+3) )) );
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
			route_param.wrapper.collect({ arg x; x.asKnob; }).clump(3).collect({ arg row, x;
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
		win.view.minWidth = 700;
		grid2 = View.new.layout_(VLayout(grid2,nil));
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
		Param( Ndef(~name+++\fx), \fb, ControlSpec(0,2,\lin) ),
		Param( Ndef(~name+++\fx), \freq, \freq),
		Param( Ndef(~name+++\fx), \pan, \bipolar),
		Param( Ndef(~name+++\fx), \spread, \bipolar),
		Param( Ndef(~name+++\fx), \freq2, \freq),
	]);
)


////////////////// garbage

~p.spec.size
~p.edit;
~p.at(0).spec
~p.at(0).normGet
~p.asParamList
~p.class
~p.wrapper.collect({ arg x; x.get.postln })
~p.set(0 ! 18)

~p.spec.unmap(0)

(
	~gui = { arg param;

		var win;
		var layout;
		var rowlayout;
		var size = 3;
		win = Window.new;
		layout = VLayout.new;
		win.layout = layout;
		size.do { arg rowidx;
			rowlayout = HLayout.new;
			layout.add(rowlayout);
			size.do { arg colidx;
				var knob = param.at(rowidx*size+colidx).asKnob;
				rowlayout.add(knob)
			};

		};
		win.front;
	};
	~gui.(~p);
)


Ndef(~name+++\fx).clear
Ndef(~name+++\fx).edit

(
~p.set([
		[0,0,0],
		[0,0,0],
		[0,0,0],

		[0,0,1],
	].flatten
)
)


in1 = 
out1 = fx1 * \x1.kr(1) + fx2 + fx3 + fx4in+


SinOsc.ar(freq) * InFeedback.kr(in1) * \fb1 + 
Out(1, )
