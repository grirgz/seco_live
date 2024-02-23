

(
SynthDef(\bloreg, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( Latoocarfian2DC.ar(minfreq: 115, maxfreq: 2050, a: 1, b: 3, c: 0.5, d: 0.5, x0: 0.34082301375036, y0: -0.38270086971332, mul: 1, add: 0.0).poll * 0.1 + 1 ));
	sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
~puntuple = { arg pat;
	var iter = (
		valStack: { arg self;
			self[\valStack] = SparseArray.new;
			self[\valStack]
		},
		stream: { arg self;
			self[\stream] = pat.asStream;
			self[\stream];
		},
		popStream: { arg self;
			self.curval = self.stream.next;
			self.curval.collect { arg item, idx;
				if(self.valStack[idx].isSequenceableCollection.not) {
					self.valStack[idx] = [];
				};
				self.valStack[idx] = self.valStack[idx].insert(0, item )
			};
		},
		nextItem: { arg self, tabidx;
			if(self.valStack[tabidx] == nil or: { self.valStack[tabidx].size == 0 }) {
				self.popStream;
			};
			self.valStack[tabidx].pop;
		}
	);
	iter.popStream;
	iter.valStack.size.collect { arg idx;
		Prout({ arg ev;
			iter.r
			
		}),
		Pfunc({ arg ev;
			idx.debug("idx");
			iter.nextItem(idx)
		})
	};
	//TODO: should return an object with a .build method that reset the pattern
	//iter

};
)

(
~a = ~puntuple.(Pseq([
				[0,3,7],
				[0,3,7]+10,
			],1))
)
~a[0].asStream.next;
~a.nextItem(0)
~a.nextItem(1)
~a.nextItem(2)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(

			~puntuple.(Pseq([
				[0,3,7],
				[0,3,7]+10,
			],1)).collect { arg item, idx;

				Pmono(\bloreg,
					\note, Pseq([
						item
					],inf),
					\dur, 1,
					\amp, 0.1,
				)
			};

		),
	])
)).play;
);
