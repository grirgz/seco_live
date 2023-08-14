// gui for cutting drum loop

~t = 156/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\dloop1, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//(0..15),
				//(0..15)+16,
				//(0..15),

				(0..7),
				(0..7)+8,

				(0..3)+5,
				(0..3)+4,
				(0..3)+8,
				(0..3)+8+4,

				//(0..7),
				//(0..3)+9,
				//(0..3)+8+4,
			].flat/8,inf) / Pkey(\st),
			\rep, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
			],inf),
			\repeat, Prout({ arg ev;
				var mem = ev[\pos];
				10000.do { arg item, idx;
					if(ev[\rep] == 1) {
						ev[\pos] = mem;
					} {
						mem = ev[\pos];
					};
					ev = 1.yield;
				};
			}),
			\pos, Plazy({PstepSeq(~scoremodel.pat/8)}).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		)),
	])
)).play;
);

(
~scoremodel = ProtoClass((
	pat: (0..7)
));
)

(
WindowDef(\samplescore, { arg def, model;
	var smodel = ~scoremodel;
	model = model ?? Pdef(\dloop1);
	Param(Message(smodel), \pat, ParamArraySpec( ControlSpec(0,smodel.pat.size,\lin,1))).asView;
	
}).front;
)


///////




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\dloop1, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				//(0..15),
				//(0..15)+16,
				//(0..15),

				(0..7),
				(0..7)+8,

				(0..3)+5,
				(0..3)+4,
				(0..3)+8,
				(0..3)+8+4,

				//(0..7),
				//(0..3)+9,
				//(0..3)+8+4,
			].flat/8,inf) / Pkey(\st),
			\rep, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
			],inf),
			\repeat, Prout({ arg ev;
				var mem = ev[\pos];
				10000.do { arg item, idx;
					if(ev[\rep] == 1) {
						ev[\pos] = mem;
					} {
						mem = ev[\pos];
					};
					ev = 1.yield;
				};
			}),
			\supidx, Pstep(Pseq((0..7),inf),1),
			\pos, Plazy({ arg ev;
				var supidx = ev[\supidx];
				//supidx.debug("sup");
				//~scoremodel.patlist[supidx].pat.debug("pat");
				//Pseq([1,0],4);
				Pseq(~scoremodel.patlist.wrapAt(~scoremodel.superpat.wrapAt(supidx)).pat/8);
			}).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		)),
	])
)).play;
);

(
~scoremodel = ProtoClass((
	patlist: {(pat:(0..7))}!8,
	superpat: (0..7),
));
)

(
WindowDef(\samplescore, { arg def, model;
	var smodel = ~scoremodel;
	model = model ?? Pdef(\dloop1);
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\part)).asView
		),

		HLayout (
			* smodel.patlist.clump(4).collect { arg patsublist, idx;
				VLayout(
					* patsublist.collect { arg patobj, subidx;
						var pa = Param(patobj, \pat, ParamArraySpec( ControlSpec(0,16,\lin,1)));
						VLayout (
							StaticText.new.string_("pat %".format(subidx+(4*idx))),
							pa.asMultiSlider,
							pa.asTextField,
						)
					};
				)
			};
		),
		Param(Message(smodel), \superpat, ParamArraySpec( ControlSpec(0,16,\lin,1))).asView
	)
	
}).front;
)

~scoremodel


(
Pbindef(\myseq,
	\instrument, \default,
	\degree, PstepSeq([4,1,0,2],inf),
	\isNote, PstepSeq(true!4,inf),
	\muter, Pif(Pkey(\isNote), 0,\rest),
	\dur, 1/8,
	\amp, 0.1,
).play;
)

(
// quick GUI creation using ParamGroup
ParamGroup([
	Param(Pbindef(\myseq), \degree -> \stepseq, ControlSpec(0,12,\lin,1)),
	Param(Pbindef(\myseq), \isNote -> \stepseq, ParamBoolSpec()), // notice the spec to have boolean values
]).edit
)

Param(Pbindef(\myseq), \degree -> \stepseq, ControlSpec(0,12,\lin,1)).get
Param(Pbindef(\myseq), \degree -> \stepseq -> 0, ControlSpec(0,12,\lin,1)).get
Param(Pbindef(\myseq), \degree -> \source).get
Param(Pbindef(\myseq), \degree).get

Pbindef(\bla, \rah, PstepSeq([ PstepSeq([11,12]), PstepSeq([21,22]) ]))
Pbindef(\bla).asStream.nextN(10,())

Param(Pbindef(\bla), \rah -> \stepseq -> 1 -> \stepseq).get

Pbindef(\bla, \env, [ Env([1,2,1],[0.1,0.8]) ])
Pdef(\rah,Pbind(\env1, [ Env([1,2,1],[0.1,0.8]) ]))
Pdef(\rah,Pbind(\env1, Env([1,2,1],[0.1,0.8])))
Param(Pbindef(\bla), \env -> \source).get
Param(Pdef(\rah), \env1).get
Param(Pdef(\rah), \env1, ParamEnvSpec()).get
/////////////:




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\dloop1, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			//\rep, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,1,1, 0,0,1,1,
			//],inf),
			//\repeat, Prout({ arg ev;
				//var mem = ev[\pos];
				//10000.do { arg item, idx;
					//if(ev[\rep] == 1) {
						//ev[\pos] = mem;
					//} {
						//mem = ev[\pos];
					//};
					//ev = 1.yield;
				//};
			//}),
			//\supidx, Pstep(Pseq((0..7),inf),1),
			//\pos, Plazy({ arg ev;
				//var supidx = ev[\supidx];
				////supidx.debug("sup");
				////~scoremodel.patlist[supidx].pat.debug("pat");
				////Pseq([1,0],4);
				//Pseq(~scoremodel.patlist.wrapAt(~scoremodel.superpat.wrapAt(supidx)).pat/8);
			//}).loop / Pkey(\st),
			//\posseq, Pswitch(
				//{ PstepSeq((0..7)) }.dup(8),
				//PstepSeq((0..7),inf).trace
			//),
			//\posseq, 0,
			\pos, 0 / 8 / Pkey(\st),
			\pos, Pkey(\posseq) / 8 / Pkey(\st),
			//\pos, 0,
			\dur, 1/8,
			\gain, 1/8,
		)) <> Pbindef(\dloop1seq),
	])
)).play;
);

(
	// init and reset sequencer
	Pbindef(\dloop1seq,
		\posseq, Pswitch(
			{ PstepSeq((0..7)) }.dup(8),
			PstepSeq((0..7),inf)
		),
	)
)

Pdef(\dloop1).clear
~p = Pswitch([ Pseq([1,2]) ], Pseq([3,4]))
~p.inspect

Pbindef(\dloop1).source.at(\posseq).source.which
Param(Pbindef(\dloop1seq).source.at(\posseq).source.which, \list).edit
Param(Message(Pbindef(\dloop1seq).source.at(\posseq).source.which), \list).edit
Pbindef(\dloop1).inspect
Param(Pbindef(\dloop1).at(), \pos -> \which)
(
~scoremodel = ProtoClass((
	patlist: {(pat:(0..7))}!8,
	superpat: (0..7),
));
)

(
WindowDef(\samplescore, { arg def, model;
	var smodel = ~scoremodel;
	var listspec = ParamArraySpec( ControlSpec(0,16,\lin,1));
	model = model ?? Pdef(\dloop1seq);
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\part)).asView
		),

		HLayout (
			* smodel.patlist.clump(4).collect { arg patsublist, idx;
				VLayout(
					* patsublist.collect { arg patobj, subidx;
						var pa;
						var fullidx = subidx + (4*idx);
						pa = Param(Message(model.source.at(\posseq).source.list[fullidx]), \list, listspec);
						VLayout (
							StaticText.new.string_("pat %".format(subidx+(4*idx))),
							pa.asMultiSlider,
							pa.asTextField,
						)
					};
				)
			};
		),
		Param(Message(model.source.at(\posseq).source.which), \list, listspec)
	)
	
}).front;
)



		(
		Pbindef(\dloop1,
			\st, 129/4/60,
		)
		)
