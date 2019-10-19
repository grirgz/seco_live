
(
SynthDef(\analyzeAmp, { arg out=0, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env;
	sig = In.kr(\ampbus.kr(0), 1);
	sig1 = sig < \minLevel.kr(0.01);
	sig2 = sig > \maxLevel.kr(100.1);
	//sig.poll;
	env = EnvGen.kr(Env([0,0,1,1,0],[0.1,0.01,2.8,0.01]), 1);
	SendTrig.kr(Trig1.kr(sig1, 0.2) * env, \trigid.kr(0), 0);
	SendTrig.kr(Trig1.kr(sig2, 0.2) * env, \trigid.kr(0), 1);
	sig = sig * EnvGen.kr( Env([0,1,0],[0.01,0.8]), 1, doneAction:2);
}).add;
);

(
ProtoClassDef(\geneticfb_organism, (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.keynum = rrand(0,1000000);
		self.key = self.keynum.asSymbol;
		self.synthDefName = \gen_ +++self.key;
		self.gen;
	
		self;
	},

	ampBus: { arg self;
		BusDef(\genbus_ +++self.keyamp, \control, 1)
	},

	isAlive: true,

	analyzeAmp: { arg self;
		Synth(\analyzeAmp, [\ampbus, self.ampBus, \trigid, self.keynum]);
		self.oscfunc = OSCFunc({ arg msg, time;
			//[time, msg].postln;
			if(msg[2] == self.keynum) {
				if(msg.last == 1 or: { msg.last == 0 }) {
					//"synth % is dead.".format(self.synthnode).postln;
					self.isAlive = false;
					self.synthnode.free(false);
					self.oscfunc.clear;
				};
			}
		},'/tr', s.addr);
	},

	gen_simple: { arg self;
		SynthDef(self.synthDefName, { arg out=0, amp=0.1, pan=0, freq=200;
			var sig;
			sig = SinOsc.ar(freq);
			sig = sig * EnvGen.kr(Env([0,1,0],[0.001,1.8]), 1);
			sig = sig + ( LocalIn.ar(1) * \fb.kr(0.9) );
			sig = DelayL.ar(sig, 0.1, 0.01) + sig;
			LocalOut.ar(sig);
			Out.kr(self.ampBus, Amplitude.kr(sig));
			//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
			sig = sig * EnvGen.kr( Env([0,1,0],[0.01,5.8]), 1, doneAction:2);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);
		}).add;
	},

	gen: { arg self;
		var static = self.adn.static;
		SynthDef(self.synthDefName, { arg out=0, amp=0.1, pan=0, freq=200;
			var sig;
			sig = SinOsc.ar(freq);
			sig = sig * EnvGen.kr(Env([0,1,0],[0.001,1.8]), 1);
			sig = sig + ( LocalIn.ar(1) * \fb.kr(0.9) );

			sig = static.numpar.collect({ 
				static.numdelays.do {
					sig = DelayL.ar(sig, 0.1, 0.01) + sig;
				};
				sig;
			}).sum;
			LocalOut.ar(sig);
			Out.kr(self.ampBus, Amplitude.kr(sig));
			//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
			sig = sig * EnvGen.kr( Env([0,1,0],[0.01,5.8]), 1, doneAction:2);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);
		}).add;
	},

	adn: (
		params: (
			fb: 0.9,
			delay: 0.01,
		),
		specs: (
			fb: ControlSpec(0.0,0.5,\lin),
			delay: ControlSpec(0.0,0.1,\lin),
		),
		static:  (
			numdelays: 2,
			numpar: 2,
			
		),
		staticSpecs: (
			numdelays: ControlSpec(1,5,\lin),
			numpar: ControlSpec(1,5,\lin),
		),
	),

	randomize: { arg self;
		self.adn.params.keys.do { arg key;
			var spec = self.adn.specs[key];
			self.adn.params[key] = rrand(spec.clipLo, spec.clipHi);
		};
		self.adn.static.keys.do { arg key;
			var spec = self.adn.staticSpecs[key];
			self.adn.static[key] = rrand(spec.clipLo, spec.clipHi);
		};
	},

	mutate: { arg self, factor;
		self.adn.params.keys.do { arg key;
			self.adn.params[key] = self.adn.specs[key].constrain(self.adn.params[key] + ( [-1, 1].choose * factor * rrand(0.1,0.9) * ( self.adn.params[key]/2 ) ));
		};
		self.adn.static.keys.do { arg key;
			self.adn.static[key] = self.adn.staticSpecs[key].constrain(self.adn.static[key] + ( [-1, 1].choose * factor * rrand(0.1,0.9) * ( self.adn.static[key]/2 ) ));
		};
	},

	fission: { arg self;
		2.collect({ arg x;
			var sub = ProtoInst(\geneticfb_organism);
			sub.adn = self.adn.deepCopy;
			sub.mutate(x/2 + 0.01);
			sub;
		})
	},

	run: { arg self;
		"pop".debug;
		self.synthnode = Synth(self.synthDefName, self.adn.params.asPairs.debug("pairs"));
	},


));

ProtoClassDef(\geneticfb_world, (
	new: { arg self;
		self = self.deepCopy;
	
		
		self;
	},

	spontaneousGeneration: { arg self;
		self.population = 10.collect({
			ProtoInst(\geneticfb_organism);
		});
		self.population.collect(_.randomize);
		
	},

	run: { arg self;
		Tdef(\runworld, {
			30.do  {
				"start of spring".postln;
				if(self.population.size == 0) {
					"==================================== spontaneousGeneration".debug;
					self.spontaneousGeneration;
					1.wait;
				};
				if(self.population.size > 30) {
					"too crowded, some organism die: %".format(self.population.size).postln;
					self.population = self.population.scramble.keep(20);
				};
				self.population.do { arg organism;
					organism.run;
					organism.analyzeAmp;
				};
				3.wait;
				"end of winter".postln;
				self.newPopulation = List.new;
				self.population.do { arg organism;
					if(organism.isAlive) {
						"organism % is alive.".format(organism.synthnode).postln;

						self.newPopulation.addAll(organism.fission);
					}
				};
				self.population = self.newPopulation;
				"new population: %".format(self.population.collect(_.keynum)).postln;
			}


		}).play;
		
	},
	
));
)
free
(
	s.bind {
		~w = ProtoInst(\geneticfb_world);
		s.sync;
		~w.run;
	}
)

~o.adn
~o.adn.params.keys
~o.adn.specs.fb.clipHi
~o.adn.params[\fb] = 1
~o.randomize

(
	s.bind {
		~o = ProtoInst(\geneticfb_organism);
		~o.gen;
		s.sync;
		~o.run;
		~o.analyzeAmp;
	}
)
