(
	~tiePattern = { arg pat;
		Prout({ arg ev;
			var str = pat.asStream;
			var futurVal;
			var val;
			var tieCount = 0;
			val = str.next;
			loop {
				while({
					futurVal = str.next;
					futurVal == val
				}) {
					tieCount = tieCount + 1;
				};
				ev.legato = ev.legato + tieCount;
				ev = val.yield;
				tieCount.collect({
					ev[\type] = \rest;
					ev = val.yield;
				});
				tieCount = 0;
				val = futurVal;
			}
		});
	};

Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, ~tiePattern.(Pwhite(0,3)),
		\dur, 1/4,
		\amp, 0.1,
	).trace
).play;
);


///////////////////////////////
(
(Penvir((),
	Pbind(
		\sendGate, false,
		\id, Pfunc { s.nextNodeID },
		\tie, Pfunc { |ev|
			// ~lastDegree.postln;
			if(~lastDegree == ev.degree){
				ev.dur = Rest(ev.dur);
			}{
				~lastID !? {
					s.sendMsg("/n_set", "default", ~lastID + 1, "gate", 0);
				};
				~lastID = ev.id.postln;
			};
			~lastDegree = ev.degree;
			ev.postln
	})
) <> Pbind(\dur, 1/2, \degree, Pwhite(0,3))
).play
)

(
(Penvir((),
	Pbind(
		\sendGate, false,
		\id, Pfunc { s.nextNodeID },
		\tie, Prout { |ev|
			var lastDegree, lastID;
			// ~lastDegree.postln;
			loop {
				if(lastDegree == ev.degree){
					ev.dur = Rest(ev.dur);
				}{
					lastID !? {
						s.sendMsg("/n_set", "default", lastID + 1, "gate", 0);
					};
					lastID = ev.id.postln;
				};
				lastDegree = ev.degree;
				ev.postln;
				ev = 1.yield;
			}

	})
) <> Pbind(\dur, 1/2, \degree, Pwhite(0,3))
).play
)

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\finally, Prout({ arg ev;
			ev.id.postln;
			ev = 1.yield;
		}).loop,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

~pOracle = { arg inpat, filterpat;
	Prout({
		var str = inpat.asStream;
		var val, val1;
		val = str.next(ev);
		loop {
			val1 = str.next(ev);

			va


			val = val1.next(ev);
		}
		filterpat
	})
};

(
Pdef(\zed, 
	~pOracle.(
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\legato, Pfunc({ arg ev;
				var fdeg = ev.use { ev.futurEvent.degree };
				var deg = ev.use { ev.degree };
				if(deg == fdeg) {
					2
				}
			}),
		)
	)
).play;
);

(
~pOracle = { arg inpat, filterpat;
	Prout({
		var str = inpat.asStream;
		var val, val1;
		val = str.next(ev);
		loop {
			val1 = str.next(ev);
			if(val1.use {val1.degree} == val.use {val.degree}) {
				val.legato = val.legato + 1;
			}

			va


			val = val1.next(ev);
		}
		filterpat
	})
};
)


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Prout({ arg ev;
			var pat = Pwhite(0,3).asStream;
			var futurDegrees = List.new;
			var futurDegree;
			var degree;
			var tieCount = 0;
			degree = pat.next;
			loop {
				while({
					var fut = pat.next;
					futurDegrees.add(fut);
					futurDegree = fut;
					fut == degree
				}) {
					tieCount = tieCount + 1;
				};
				ev.legato = ev.legato + tieCount;
				ev = degree.yield;
				tieCount.collect({
					ev[\type] = \rest;
					ev = degree.yield;
				});
				tieCount = 0;
				degree = futurDegree;
			}
		}),
		\dur, 1/4,
		\amp, 0.1,
	).trace
).play;
);

Pdef(\zed).clear;

