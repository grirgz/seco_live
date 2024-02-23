
/// golden ratio

(
	WindowDef(\farfalle, {
		var csize = 700;
		var canvas = UserView.new;
		var model = ProtoClass((posfac:0.41,rotfac:1,diamfac:1));
		var paramgroup = ParamGroup(
			[\posfac, \rotfac, \diamfac].collect({ arg key;
				Param(Message(model),key,\unipolar)
			})
		);
		var paramgroupview = paramgroup.collect { arg param, idx;
			var pview = param.asView;
			var slider = pview.slider;
			slider.orientation_(\horizontal);
			slider.action_(slider.action.addFunc({
				//["kjkj", model].postln;
				canvas.refresh;
			}));
			pview;

		};
		model.fac = 1/20;
		canvas.drawFunc = {
			var ipos = 200@100;
			Pen.strokeColor = Color.red;
			Pen.fillColor = Color.blue;
			//Pen.moveTo(2000@1000);
			Pen.translate(csize/2,csize/2);
			500.do { arg item, idx;
				var fac = idx * 1/model.posfac.linlin(0,1,1,60);
				var diamfac = model.diamfac.linlin(0,1,0.1,100);
				//Pen.strokeOval(Rect(10+ipos.x,10+ipos.y,10,10));
				Pen.strokeOval(Rect(10*fac,10*fac,10*diamfac,10*diamfac));
				Pen.rotate(model.rotfac.linlin(0,1,24,24.1));
			};


			//Pen.stroke;
			//Pen.fill;
			Pen.draw(3);
		};
		VLayout (
			canvas.background_(Color.grey).minSize_(csize@csize),
			VLayout(*paramgroupview),

		)
	}).front;
)


////////// circular score viewer

(
ProtoDef(\viscore, (
	posfac:0.41,rotfac:1,diamfac:1,
	score: List.new,
	addEvent: { arg self, ev;
		ev = ev.copy;
		ev.time = TempoClock.default.beats;
		self.score.add(ev);
		self.changed(\refresh);
		true
	},
	clearScore:	{ arg self;
		self.score = List.new;
	}
));
)
ProtoDef(\viscore).clearScore;

(
WindowDef(\viscore, { arg me, model;
	var csize = 700;
	var canvas = UserView.new;
	//var model = ProtoClass((posfac:0.41,rotfac:1,diamfac:1));
	var paramgroup;
	var paramgroupview;
	model = model ?? ProtoDef(\viscore);

	canvas.followChange(model, \refresh, {
		defer {
			canvas.refresh;
		}
	});

	paramgroup = ParamGroup(
		[\posfac, \rotfac, \diamfac].collect({ arg key;
			Param(Message(model),key,\unipolar)
		})
	);
	paramgroupview = paramgroup.collect { arg param, idx;
		var pview = param.asView;
		var slider = pview.slider;
		slider.orientation_(\horizontal);
		slider.action_(slider.action.addFunc({
			//["kjkj", model].postln;
			canvas.refresh;
		}));
		pview;

	};
	model.fac = 1/20;
	canvas.drawFunc = {
		var ipos = 200@100;
		Pen.strokeColor = Color.red;
		Pen.fillColor = Color.blue;
		//Pen.moveTo(2000@1000);
		Pen.translate(csize/2,csize/2);
		//500.do { arg item, idx;
			//var fac = idx * 1/model.posfac.linlin(0,1,1,60);
			//var diamfac = model.diamfac.linlin(0,1,0.1,100);
			////Pen.strokeOval(Rect(10+ipos.x,10+ipos.y,10,10));
			//Pen.strokeOval(Rect(10*fac,10*fac,10*diamfac,10*diamfac));
			//Pen.rotate(model.rotfac.linlin(0,1,24,24.1));
		//};
		model.score.do { arg item, idx;
			var freq;
			var fac;
			var diamfac;
			//freq = item.use { ~freq.value }.cpsmidi ?? 60 / 40;
			freq = 1/ item.use { ~freq.value } * 20;
			diamfac = model.diamfac.linlin(0,1,0.01,10) * freq ;
			fac = idx * 1/model.posfac.linlin(0,1,1,60);
			//[freq, diamfac].debug("fac");
			//Pen.strokeOval(Rect(10+ipos.x,10+ipos.y,10,10));
			Pen.use {
				Pen.rotate(model.rotfac.linlin(0,1,0.1,4.1) * ( item.time % 8 ) * ( TempoClock.default.beats % 128 / 128 + 1 ));
				Pen.fillColor = Color.yellow;
				Pen.fillOval(Rect(10*fac,10*fac,10*diamfac*8,10*diamfac*8));
				Pen.fillColor = Color.blue;
				Pen.fillOval(Rect(10*fac,10*fac,10*diamfac*4,10*diamfac*4));
				Pen.fillColor = Color.red;
				Pen.strokeOval(Rect(10*fac,10*fac,10*diamfac*4,10*diamfac*4));
				Pen.fillColor = Color.red;
				Pen.fillOval(Rect(10*fac,10*fac,10*diamfac,10*diamfac));
			};
			
		};


		//Pen.stroke;
		//Pen.fill;
		Pen.draw(3);
	};
	VLayout (
		canvas.background_(Color.grey).minSize_(csize@csize),
		VLayout(*paramgroupview),

	)
}).front;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,3,5,10,
			],inf),2),
			\viscore, Pfunc({ arg ev;
				ProtoDef(\viscore).addEvent(ev);
			}),
			\dur, 1/4 * PdurStutter(Pseq([1,4,2,8],inf), 2),
			\amp, 0.1,
		).trace,
		
	])
)).play;
);

ProtoDef(\viscore).score



(
ProtoDef(\viscore).clearScore;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,3,5,10,
				0,3,5,10,
				0,3,5,10,
				0,0,7,12,
			],inf),2),
			\octave, Pseq([3,4,5],inf).stutter(5),
			\viscore, Pfunc({ arg ev;
				ProtoDef(\viscore).addEvent(ev);
			}),
			\dur, 1/4 * PdurStutter(Pseq([1,4,1,1,2,8],inf), 2),
			\amp, 0.1,
		).trace,
		
	])
)).play;
);


/////////
// handle rests

(
WindowDef(\viscore, { arg me, model;
	var csize = 700;
	var canvas = UserView.new;
	//var model = ProtoClass((posfac:0.41,rotfac:1,diamfac:1));
	var paramgroup;
	var paramgroupview;
	model = model ?? ProtoDef(\viscore);

	canvas.followChange(model, \refresh, {
		defer {
			canvas.refresh;
		}
	});

	paramgroup = ParamGroup(
		[\posfac, \rotfac, \diamfac].collect({ arg key;
			Param(Message(model),key,\unipolar)
		})
	);
	paramgroupview = paramgroup.collect { arg param, idx;
		var pview = param.asView;
		var slider = pview.slider;
		slider.orientation_(\horizontal);
		slider.action_(slider.action.addFunc({
			//["kjkj", model].postln;
			canvas.refresh;
		}));
		pview;

	};
	model.fac = 1/20;
	canvas.drawFunc = {
		var ipos = 200@100;
		Pen.strokeColor = Color.red;
		Pen.fillColor = Color.blue;
		//Pen.moveTo(2000@1000);
		Pen.translate(csize/2,csize/2);
		//500.do { arg item, idx;
			//var fac = idx * 1/model.posfac.linlin(0,1,1,60);
			//var diamfac = model.diamfac.linlin(0,1,0.1,100);
			////Pen.strokeOval(Rect(10+ipos.x,10+ipos.y,10,10));
			//Pen.strokeOval(Rect(10*fac,10*fac,10*diamfac,10*diamfac));
			//Pen.rotate(model.rotfac.linlin(0,1,24,24.1));
		//};
		model.score.select({ arg ev; ev[\isRest] == false}).do { arg item, idx;
			var freq;
			var fac;
			var diamfac;
			//freq = item.use { ~freq.value }.cpsmidi ?? 60 / 40;
			freq = 1/ item.use { ~freq.value } * 20;
			diamfac = model.diamfac.linlin(0,1,0.01,10) * freq ;
			fac = idx * 1/model.posfac.linlin(0,1,1,60);
			//[freq, diamfac].debug("fac");
			//Pen.strokeOval(Rect(10+ipos.x,10+ipos.y,10,10));
			Pen.use {
				Pen.rotate(model.rotfac.linlin(0,1,0.1,4.1) * ( item.time % 8 ) * ( TempoClock.default.beats % 128 / 128 + 1 ));
				Pen.fillColor = Color.yellow;
				Pen.fillOval(Rect(10*fac,10*fac,10*diamfac*8,10*diamfac*8));
				Pen.fillColor = Color.blue;
				Pen.fillOval(Rect(10*fac,10*fac,10*diamfac*4,10*diamfac*4));
				Pen.fillColor = Color.red;
				Pen.strokeOval(Rect(10*fac,10*fac,10*diamfac*4,10*diamfac*4));
				Pen.fillColor = Color.red;
				Pen.fillOval(Rect(10*fac,10*fac,10*diamfac,10*diamfac));
			};
			
		};


		//Pen.stroke;
		//Pen.fill;
		Pen.draw(3);
	};
	VLayout (
		canvas.background_(Color.grey).minSize_(csize@csize),
		VLayout(*paramgroupview),

	)
}).front;
)


(
ProtoDef(\viscore).clearScore;
Pdef(\part, Pdef(\zedpart, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	)<>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1236].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,

				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\viscore, Pfunc({ arg ev;
				ProtoDef(\viscore).addEvent(ev);
			}),
			\dur, 1/8,
			\gain, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[257].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,0, 1,1,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],1),
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,1, 1,1,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,1, 
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0, 1,1,1,1, 1,1,1,1, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,1,0,

				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0, 1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseq([ 0, ],8*7+64),
				Pseq((0..7),1),
				
			],inf).midiratio,
			\dur, 1/8,
			\gain, 0.10,
		),
		Pdef(\bass1, 
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,5,2,10,9,7,5,
						],1)+12,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,10,9, 5,4,5+12,4+12,
						],1)+12,
					],1),1/4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1.2,1.2,1,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.9,
				\ringTime, 100,
				//\durr, 0.01,
				\lag, -0.04,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				\out, BusDef(\chainin, \audio),
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
				//\isRest, true,
			),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[689].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\lag, -0.04,
				\lag, -0.04,
				\out, BusDef(\sendbus2, \audio),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[1].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\chainin, \audio),
			\sideinbus, BusDef(\chainside, \audio),
			\addAction, \addToTail,
			//\lag, 0.0009,
			\cprelax, 0.1,
			\cpt, 0.005,
			\cpabove, 0.000001,
			\cpclamp, 0.01,
			\gain, 1.5,
			\mix, 1,
			\sidegain, 1,
			\dur, 1,
		),
		
	])
)).play;
);
