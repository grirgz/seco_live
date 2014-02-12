
(
Veco.do { arg name, namex;
	Pdef(~name +++ \pre, DebugPbind(
		\freq, Pseq([
			100,200,50,60,
			80,200,50,60,
			100,200,50,60,
			80,200,50,120,
		],inf),
		\distmix, 0.7,
		\distamp, 1.52,
		\freq, Pseq([
			50,50,70,60,
			50,50,80,50,
		],inf).stutter(8),
		\freq, Pseq([
			50,70,60,50,
		],inf).stutter(8),
		//\freq, Pswitch1([
		//	Pkey(\freq),
		//	Pseq([200,400],inf),
		//], Pseq([0,1],inf)),
		\freq, Place([
			Pkey(\freq),
			Pseq([200,400]/3,inf),
		],inf),
		\dur, 1/8,
		\legato, Pseq([0.5,1,1.1]*8,inf),
		//\isRest, Pn(Prout({ arg in;
		//	var str = Veco(~namex).isrest(16, 1).asStream;
		//	inf.do {
		//		in = str.next(in).yield;
		//		7.do { 
		//			in = true.yield;
		//		}
		//	}
		//})),
		\isRest, Pseq([
			Prout({ arg in;
				var str = Veco(namex).isrest(16, 1).asStream;
				block { arg break;
					inf.do {
						var ev = str.next(in);
						if(ev.isNil) {
							break.value;
						};
						in = ev.yield;
						7.do { 
							in = true.yield;
						}
					}
				}
			}),
		],inf),
	));


}
);

Ndef(~name+++\mixer).put(~rlpfindex, \filter -> { arg in; Out.ar(BusDef(~fxrlpf+++\fx), in); in; });
Ndef(~name+++\mixer).set(\xfade, 1);

// END

Ndef(~name+++\mixer).put(170, \filter -> { arg in; Out.ar(BusDef(~fxrlpf+++\fx), in); in; })
Ndef(~name+++\mixer).set(\xfade, 1);
Ndef(~name+++\mixer).set(\xfade, 0.4);
Ndef(~name+++\mixer).removeAt(170)
Ndef(~name+++\mixer).removeAt(70)
Ndef(~name+++\mixer).removeAt(200)
Ndef(~name+++\mixer).objects.indices
NodeProxy
