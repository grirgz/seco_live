
(
~list = List[1,0,1,1,0,0,0,1];
~listoflist = [
	List[1,0,1,0,1,0,0,1],
	List[1,0,1,0,0,1,0,1],
	List[1,0,1,1,0,0,0,0],
];
~legato = 3.collect({ List.newFrom(0.5 ! 8) });

~p = Param(~list, \list, \unipolar);

~pg = ParamGroup(
	~listoflist.collect({ arg x;
		Param(x, \list, \unipolar) 
	})
);
~pglegato = ParamGroup(
	~legato.collect({ arg x;
		Param(x, \list, ControlSpec(0.1,2,\lin)) 
	})
);

)

(

	~make_cursor_line = { arg param;
		HLayout(*
			param.collect({ arg subparam, x;
				Button.new
				.enabled_(false)
				.maxHeight_(10)
				.onChange(param.target, \cursor, { arg view ...args;
					[args[2], x].debug("bbb");
					if(args[2] == x) {
						Task{
							s.latency.wait;
							if(args[3] == 1) {
								view.value = 1;
							} {
								view.value = 0;
							};
							nil
						}.play(AppClock);
					};
					args.debug("cursor!!");
				})
				.states_([
					["", Color.black, Color.white],
					["", Color.black, Color.yellow],
				]);
			})
		)
	};

	~make_sequencer_line = { arg param;
		HLayout(*
			param.collect({ arg subparam;
				subparam.asButton;
			})
		)
	};

	~make_slider_line = { arg param;
		HLayout(*
			param.collect({ arg subparam;
				subparam.asSlider;
			})
		)
	};

	~make_gui = { arg pg, pglegato;
		var win = Window.new;
		var layout;
		layout = VLayout(*
			(
				[ ~make_cursor_line.(pg[0]) ]
				++
				pg.collect({ arg param;
					~make_sequencer_line.(param)
				})
				++
				pglegato.collect({ arg param;
					~make_slider_line.(param)
				})
			)
		);
		win.layout = layout;
		win.alwaysOnTop = true;
		win.front;
	};


	~make_gui.(~pg, ~pglegato);


)

(
Pdef(\plop, 
	
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1/4,
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([3],inf),
			\dur, 1/4,
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([7],inf),
			\dur, 1/4,
			\amp, 0.1
		),
	].collect({ arg pat, x;
		Pbind(
			\cursor, PseqCursor(~listoflist[0]),
			\isRest, Plazy({ Pseq(~listoflist[x]) }).loop.coin.not,
			\legato, Plazy({ Pseq(~legato[x]) }).loop,
		) <>
		pat
	})),
).play;
);

~pg.edit

Pdef(\plop).stop

////////////////////////////////

(
	~make_pbind_param
	~model = [
		\isRest, \coin,
		\legato, ControlSpec(0.1,2,\lin),
		\defree, ControlSpec(-8,8,\lin,0,1),
	];
	~data = ();
	~modellist = List.new;
	~size = 8;
	~model.pairsDo { arg pair;
		var list;
		var pat;
		~modellist.add(pair[0]);
		list = List.newFrom(pair[1].default ! ~size);
		pat = Plazy({ Pseq(list) }).loop;
		if(pair[0] == \coin) {
			pat = pat.coin.not;
		};
		~modellist.add(seq);
	};
	ParamGroupDef(\)

	~pp = PseqParam(
		\isRest, \coin,
		\legato, ControlSpec(0.1,2,\lin),
		\defree, ControlSpec(-8,8,\lin,0,1),
	);

	~pplist = { 
		PseqParam(
			\isRest, \coin,
			\legato, ControlSpec(0.1,2,\lin),
			\defree, ControlSpec(-8,8,\lin,0,1),
		)
	} ! 3;

	~pplist[0].keys.collect { arg key;
		~pplist.collect { arg pp;
			pp.at(key).asSlider
		}
	};


)
