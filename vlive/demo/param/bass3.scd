
(
~a = Prout({ arg ev; 
	var str = Pbind(\freq, 250).asStream; 
	while({ev.notNil}) {
		ev = str.next(ev);
		ev.yield;
	};
});
~s = ~a.asStream;
)
~s.next(Event.default)
~a.play

(
	Pdef(\test, Prout({
		arg ev;
		var ret;
		var bind = List.new;
		var str;
		ev.keysValuesDo { arg key, val;
			bind.add(key);
			if(val.isSequenceableCollection) {
				bind.add(Pseq(val,inf));
			} {
				bind.add(val);
			}
		};
		ev.debug("ev");
		bind.debug("bind");
		str = Pbind(*bind).asStream;

		while({ev.notNil}) {
			ev = str.next(ev);
			ev.yield;
		};
		
	})).play;
);

Pdef(\test).set(\freq, List[100,200,300])
Pdef(\test).get(\freq)
~p = Param(Pdef(\test).get(\freq), \freq, \freq);
~p.edit

(
	Pdef(\testnest, Prout({
		arg ev;
		var ret;
		var bind = List.new;
		var str;
		ev.keysValuesDo { arg key, val;
			if(val.isSequenceableCollection) {
				bind.add(key);
				bind.add(Pseq(val[0].debug("what?")));
			} {
				//bind.add(val);
			}
		};
		ev.debug("ev");
		bind.debug("bind");
		//str = Pbind(*bind).asStream;

		//while({ev.notNil}) {
		//	ev = str.next(ev);
		//	ev.yield;
		//};
		Pbind(*bind).embedInStream(ev);
		
	})).play;
);

(
	(
	Pdef(\plop, 
		Pdef(\testnest).loop <>
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1/4,
			\amp, 0.1
		)
	).play;
	);
)
Pdef(\testnest).envir

~p = Param(Pdef(\testnest), \freq, XArraySpec(\freq!3));
~p.set([100,2500,600])
~p.set([100,2500,600,700,800])
~p.edit
~p.edit
~p.at(0).edit
~p.set(10)
~p.get

Pdef(\bla).source
Pdef.all
PdefSeq(\nii).source
PdefSeq(\nii)
Pdef(\nii).source

(
	(
	Pdef(\plop, 
		(
			PbindSeqDef(\nii).loop <>
			Pbind(
				\instrument, \default,
				\degree, Pseq([0],inf),
				\dur, 1/4,
				\amp, 0.1
			)
		)
	).play;
	);
)
Pb
PbindSeqDef(\nii).class
PbindSeqDef(\nii).get(\freq)
PbindSeqDef(\nii).source = nil
PbindSeqDef(\nii).envir
PbindSeqDef(\nii).asStream.next
PbindSeqDef(\nii).unset(\freq)
PbindSeqDef(\nii).setVal(\legato, 1/3)
PbindSeqDef(\nii).setVal(\legato, [1,2,3,4,0.3])
~pl = Param(PbindSeqDef(\nii), \legato, ControlSpec(0,3,\lin));
~pl.get
~pl.edit

(
ParamGroup([
	Param(PbindSeqDef(\nii), \legato, ControlSpec(0,3,\lin)),
	Param(PbindSeqDef(\nii), \freq),
]).edit
)

~p = Param(PbindSeqDef(\nii), \freq, \freq);
~p.set([100,2500,600])
~p.set(500)
~p.set(300)
~p.set([100,2500,600,700,800])
~p.edit
~p.edit
~p.at(0).edit
~p.get
~p.type
~p.spec
1.size

~p.type
~p.spec
~p.get
~p.wrapper.target.get(\freq)
XArraySpec


~p.type
~p.spec
~p.wrapper
PbindSeqDef(\nii)
Pdef(\nii).source
Pdef.all

PbindSeqDef(\kas)
PbindSeqDef(\bli)
Pdef(\kas)
Pdef(\bli)
What(\blaa).source = Pbind(\freq, 4100)
What(\blaa).play
What.all
Pdef(\blaa).source
Pdef(\blaa).source = Pbind(\freq, 4100)
Pdef(\blaa).play




(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.3));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpf: \freq,
	rq: \rq,
	adsr: XEnvSpec.adsr,
))).add;
);

(
Pdef(\plop, 
	
	PbindSeqDef(\yo1).loop <>
	Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	//\degree, [[1,2,3,4]],
	\dur, 1/4,
	\amp, 0.1
)).play;
);

PbindSeqDef(\yo1).clear
PbindSeqDef(\yo1).addHalo(\instrument, \plop)
PbindSeqDef(\yo1).set(\lpf, [[1,2,3,4,5,6]]*100)
PbindSeqDef(\yo1).set(\freq, [[1,2,3,4,5,6]]*80)
PbindSeqDef(\yo1).set(\rq, [ 0.3!6 ])
PbindSeqDef(\yo1).unset(\freq)

(
	ParamGroup([
		Param(PbindSeqDef(\yo1), \freq),
		Param(PbindSeqDef(\yo1), \lpf),
		Param(PbindSeqDef(\yo1), \rq),
		Param(PbindSeqDef(\yo1), \legato),
		Param(PbindSeqDef(\yo1), \adsr),
	]).edit
)

PbindSeqDef(\yo1).envir.keysValuesDo{ arg k,v; [k,v].debug("kv111") }



b.free;
b = Buffer.alloc(s, 1024, 1);

(
a = {   var     sig, phase, writer, done;
        sig = SinOsc.kr(1 * XLine.kr(1,100,100));
        phase = Phasor.kr(1, 1, 0, BufFrames.kr(b));
		phase.poll;
        writer = BufWr.kr(sig, b, phase, loop: 0);
}.play;
)
a.free;
b.plot;


~p  = ParamValue.new(\freq.asSpec)
~p.set(1000)
~p.get
~p.edit
~p.spec
~p.spec = \freq.asSpec
Param(~p).edit
Param(~p)


(
~combinator = (
	new: { arg self, param;
		var rsize = 3;
		self = self.deepCopy;
	
		
		self.ranges = List.newFrom( 0!rsize );
		self.inputs = List.newFrom( 0!rsize );
		self.param = param;
		self.base_value = ParamValue(param.spec).set(param.get);

		self.controllers = SimpleController(self.ranges).put(\set, {
			"yaaaaaaaaaaat".debug;
			self.compute_final_value;
		});

		self.controllers = SimpleController(self.inputs).put(\set, {
			"yaaaaaaaaaaat2".debug;
			self.compute_final_value;
		});

		self.controllers = SimpleController(self.base_value).put(\set, {
			"yaaaaaaaaaaat3".debug;
			self.compute_final_value;
		});

	
		self;
	},

	get_final_value: { arg self;
		self.compute_final_value;
		self.param.get
	},

	get_norm_final_value: { arg self;
		self.compute_final_value;
		self.param.normGet
	},

	get_norm_base_value: { arg self;
		self.param.spec.unmap(self.get_base_value);
	},

	get_base_value: { arg self;
		self.base_value.get;
	},

	set_range: { arg self, idx, val;
		self.ranges[idx] = val;
		self.ranges.changed;
		self.compute_final_value;
	},

	set_input: { arg self, idx, val;
		self.inputs[idx] = val;
		self.inputs.changed;
		self.compute_final_value;
	},

	compute_final_value: { arg self;
		var fval;
		fval = self.get_norm_base_value;
		self.inputs.do { arg in, x;
			fval = fval + (in * self.ranges[x])
		};
		self.set_norm_final_value(fval);
	},

	set_norm_final_value: { arg self, val;
		val.debug("set_norm_final_value");
		self.param.normSet(val);
	},

	edit: { arg self;
		var window = Window.new;
		var layout;
		var modknob;
		modknob = ModKnob.new(window)
			.onChange(self.ranges, \set, { arg view;
				self.ranges.do { arg val, x;
					modknob.set_range(x, val);
				};
				modknob.refresh;
			})
			.onChange(self.base_value, \set, { arg view;
				modknob.value = self.base_value.normGet;
			})
			.onChange(self.param.target, \set, { arg view;
				modknob.midi_value = self.param.normGet;
				modknob.refresh;
			})
			.action_({
				self.base_value.normSet(modknob.value)
			})
			;
		layout = HLayout(
			modknob,
			ParamGroupLayout.two_panes(ParamGroup([
				self.base_value,
				Param(self.ranges, \list, \bipolar),
				Param(self.inputs, \list, \unipolar),
				self.param,
			].flatten)),
		);
		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;
	},

);

Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;

~combi = ~combinator.new( Param(Ndef(\plop), \freq, \freq) );
~combi.edit;
)

~combi.compute_final_value

~combi = ParamCombinator.new( Param(Ndef(\plop), \freq, \freq) );
~combi.edit

~a1 = [1,2,3,4]
~a2 = [1,2,3,4]
~a1.hash
~a2.hash
~a1.dump
kk
~a1.identityHash
~a2.identityHash


// - final value
// - base value
// - range 1
// - range 2
// - macro 1
// - macro 2

(
	~x = {
		var window = Window.new;
		var layout;
		//layout = HLayout(
			~m = ModKnob.new(window);
		//);
		//window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;

	}.value;

)
