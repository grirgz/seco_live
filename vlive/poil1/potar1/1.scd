~name = '1';

(
SynthDef(~name, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5|
	var env0, env1, env1m, son;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Pan2.ar(son, pan);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	env0: \env -> [4, ControlSpec(0.001,8,\exp, 0, 1), nil, nil, Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2])],
	env1: \env -> [3, ControlSpec(5,128,\lin, 0, 50), nil, nil, Env.new([210, 29, 59], [0.105, 0.29], [-4, -5])],
))).add;
);

Sdef(~name, \mypreset, \preset, ~name);
Sdef(~name, \morph, \preset, [\morph, \unipolar.asSpec, \mdur, ControlSpec(0,7,\lin,1,1)]);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(32),
	\fratio, 2,
	\dur, 1/8,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);


(
Veco(~name).lib.macros = [
	[Sdef(~name, \morph), \morph],
	//[Sdef(~name, \morph), \mdur],
];
);

// END

Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset).delete
().delete
MIDIdef.noteOn(\test, { arg ... args; args.debug("plop"); });
MIDIdef.cc(\test, { arg ... args; args.debug("plop"); });

(
MIDIBoard.define(0, [
	\home, 34,
	\left, 35,
	\right, 36,
	\end, 37,
	\stop, 38,
	\play, 39,
	\pause, 40,
	\record, 41,
	\hold, 42,
	\b1, 43,
	\b2, 44,
	\b3, 45,
	\b4, 46,
]);
MIDIBoard.permanent = true;
)

(
MIDIBoard.map(\record, { 
	~record_button_state = 1;
	~record_button_state.debug("statex");
}, {
	~record_button_state = 0;
	~record_button_state.debug("state");
});

MIDIBoard.map(\play, { 
	if(~record_button_state == 1) {
		Sdef(~name, \mynotes).record(inf, 16)
	} {
		Veco(~namex).response_on;
	}
});

MIDIBoard.map(\stop, { 
	if(~record_button_state == 1) {
		Sdef(~name, \mynotes).stop_record
	} {
		Veco(~name).stop_node(true);
	}
});

MIDIBoard.map(\pause, { 
	if(~record_button_state == 1) {
		//Sdef(~name, \mynotes).cancel_record
	} {
		Veco(~name).stop_node;
	}
});
)

Veco.force_init
VecoLib.load_lib
