
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01,1.001, 1+0.1.rand]);
	sig = RLPF.ar(sig, \lpf.kr(400), \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\plop1, Pbind(
	\instrument, \plop,
	\degree, Pseq([0,4,5,8],inf),
	\dur, 1/8,
	\amp, 0.1
));

Pdef(\plop2, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2],inf),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
));

Pdef(\plop3, Pbind(
	\instrument, \default,
	\degree, Pseq([0,7,7,7,7,2],inf),
	\octave, 5,
	\dur, 1/4,
	\amp, 0.1
));

~instruments = [
	Pdef(\plop1),
	Pdef(\plop2),
	Pdef(\plop3),
];

~class_preset = (
	eventClass: \preset,
	new: { arg self, instr;
	
		if(instr.tryPerform(\eventClass) == \preset) {
			instr.clone;
		} {
			self = self.deepCopy;

			self.instr = instr;
			self.params = ();

			self
		}
	},

	as_pattern: {
		self.params <> self.instr
	}
);

~class_drumpad = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.presets = IdentityDictionary.new;
		self.pads = List.newClear(128);
	
		self;
	},

	add_to_pad: { arg self, padidx, instr;
		self.pads[padidx] = self.pads[padidx].add(~class_preset.new(instr));
	},

	padstream: { arg self, idx;
		if(self.padstreams[idx].isNil)
			if(self.pads[idx].notNil and: { self.pads[idx].size > 0 }) {
				self.padstreams[idx] = self.pads[idx].collect({ arg x;  x.as_pattern.asStream });
			} {
				self.padstreams[idx] = [(isRest: true).asStream];
			};
			self.padstreams[idx];
		} {
			self.padstreams[idx];
		}
	},

	as_pattern: { arg self, score;
		if(score.notNil) {
			Prout({ arg ev;
				score.do { arg scoreev;
					if(self.pads[ev[\midinote]].notNil) {
						var padevs;
						padevs = self.padstream(ev[\midinote]).next;
						ev = padevs.collect{ arg padev;
							padev.composeEvent(scoreev).yield(ev);
						};
					}
				}

			})
			
		} {

	
		};
	},

	as_seqpattern: { arg self, seq;
	
	}
);

)
