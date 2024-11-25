//// stepseq param

(
FileSystemProject.loadOnce("sndlib/buflib.scd");
FileSystemProject.loadOnce("libdef/synthplayrec.scd");
Pdef(\seqme, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[435].value,
		//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			Pkeyd(\kitseq,1),
			//1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	) <>
	Pbindef(\seq, \bla, 1),
).play;
);

(
// MultiSliderView
WindowDef(\win, { arg def;
	var defaultSize = 8;
	var prop = \kitseq;
	var defaultVal = 0;
	var pdef = Pdef(\seq);
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	VLayout (
		PlayerWrapper(Pdef(\seqme)),
		Param(pdef, prop -> \stepseq, \unipolar).asView
	)
	
}).front;
)

(
// BoolButton
// use controllerTargetCursor
WindowDef(\win, { arg def;
	var defaultSize = 8;
	var prop = \kitseq;
	var defaultVal = 0;
	var pdef = Pdef(\seq);
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	VLayout (
		PlayerWrapper(Pdef(\seqme)),
		HLayout(*Param(pdef, prop -> \stepseq, \unipolar).collect { arg subparam, pidx;
			subparam.asButton(" ").followChange(subparam.parent.controllerTargetCursor, \cursor, { arg but, obj, msg, idx, val;
				[but, obj, msg, idx, val].debug("args");
				if(pidx == idx) {
					defer {
						but.label = if(val == 1) {
							"O";
						} {
							" ";
						}
					}
				};
			});
		});
	)
	
}).front;
)

(
// BoolButton unique follower
WindowDef(\win, { arg def;
	var defaultSize = 8;
	var prop = \kitseq;
	var defaultVal = 0;
	var pdef = Pdef(\seq);
	var layout;
	var buttons;
	var param = Param(pdef, prop -> \stepseq, \unipolar);
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	buttons = param.collect { arg subparam, pidx;
		subparam.asButton(" ");
	};
	layout = VLayout (
		PlayerWrapper(Pdef(\seqme)),
		HLayout(*buttons),
		//nil
	);
	buttons.first.followChange(param.controllerTargetCursor, \cursor, { arg but, obj, msg, idx, val;
		[but, obj, msg, idx, val].debug("args");
		if(idx.notNil) {
			defer ({
				but = buttons[idx];
				but.label = if(val == 1) {
					"O";
				} {
					" ";
				}
			}, Server.default.latency)
		}
	});
	layout
	
}).front;
)

(
// BoolButton test builtin cursor
WindowDef(\win, { arg def;
	var defaultSize = 8;
	var prop = \kitseq;
	var defaultVal = 0;
	var pdef = Pdef(\seq);
	var layout;
	var buttons;
	var param = Param(pdef, prop -> \stepseq, \unipolar);
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	buttons = param.collect { arg subparam, pidx;
		subparam.subIndex.debug("sub");
		subparam.controllerTargetCursor.debug("target");
		subparam.accessor.key.debug("target");
		subparam.asButton(" ");
	};
	layout = VLayout (
		PlayerWrapper(Pdef(\seqme)),
		HLayout(*buttons),
		//nil
	);
	layout
	
}).front;
)

(
// BoolButton unique follower
// for cookbook

// problem: how to be sure of order of keys ?

Pbindef(\myseq,
    \instrument, \saw,
    \degree, PstepSeq([4,1,0,2],inf),
	\isNote, PstepSeq(true!4,inf),
    \muter, Pif(Pkey(\isNote), 0,\rest),
    \dur, 1/2,
    \amp, 0.1,
).play;

WindowDef(\help, { arg def, pdef;
	var defaultSize = 8;
	var prop = \isNote;
	var defaultVal = 0;
	var buttons;
	var param = Param(pdef, prop -> \stepseq, ParamBoolSpec());

	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	buttons = param.collect { arg subparam, pidx;
		subparam.asButton(" ");
	};
	buttons.first.followChange(param.controllerTargetCursor, \cursor, { arg but, obj, msg, idx, val;
		[but, obj, msg, idx, val].debug("args");
		if(idx.notNil) {
			{
				but = buttons[idx];
				but.label = if(val == 1) {
					"O";
				} {
					" ";
				}
			}.defer(Server.default.latency)
		}
	});
	VLayout (
		PlayerWrapper(pdef),
		HLayout(*buttons),
		nil
	);
	
}).front(Pbindef(\myseq));
)

s.latency = 0.2;

~p = Param(Pdef(\seq), \kitseq -> \stepseq, \unipolar)
~p.size
~p.accessor.key
~p.at(0).accessor.key
~p.at(0).controllerTargetCursor
BaseAccessorParam.associationToArray(~p.at(0).property)
~ps = Param(Pdef(\seq), \kitseq -> \source, \unipolar)
~ps.get
~p.at(0).property.value
~p.at(0).get
~p.get
Param(pdef, prop -> \source, \unipolar)

////////////////////////////////////////////////////
// setting list size


~p = Param(Pdef(\seq), \kitseq -> \stepseq, \unipolar)
~p.set(~p.get.wrapExtend(16))
~p.set(~p.get.wrapExtend(6))
~p.get
~p.at(10).get
~p.at(10).default
(
// BoolButton test builtin cursor
WindowDef(\win, { arg def;
	var defaultSize = 8;
	var prop = \kitseq;
	var defaultVal = 0;
	var pdef = Pdef(\seq);
	var layout;
	var buttons;
	var param = Param(pdef, prop -> \stepseq, \unipolar);
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	buttons = param.collect { arg subparam, pidx;
		subparam.subIndex.debug("sub");
		subparam.controllerTargetCursor.debug("target");
		subparam.accessor.key.debug("target");
		subparam.asButton(" ");
	};
	layout = VLayout (
		PlayerWrapper(Pdef(\seqme)),
		HLayout(*buttons),
		//nil
	);
	layout
	
}).front;
)



////////////////////////////////////////////////////
//// StepList (old concept)
// seems broken

~sl = StepList[0,0,1]

(
WindowDef(\win, { arg def;
	StepListView(~sl)
}).front;
)
