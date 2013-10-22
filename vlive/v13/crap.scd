
(
// simple morph
~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var proxies = ();
	var bind = List.new;
	var proxy;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%.%".format(~name, mainkey, key).asSymbol;
		ndefkey.debug("ndefkey");
		proxies[key] = Ndef(ndefkey, { 
			Line.kr(Ndef(ndefkey).kr, val, lagtime)
		});
		//proxy = proxies[key];
		proxy = Ndef(ndefkey);
		bind.add(key);
		bind.add(proxy.bus.asMap);
	};
	Pbind(*bind)
}
)


Pdef(~name).play;

(
~a = Pdef(~name, ~morph.(\bla, 2.1, Pbind(
	\freq, 100,
	\ffreq, 1300,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));
);

(
~a = Pdef(~name, ~morph.(\bla, 1, Pbind(
	\freq, 1500,
	\ffreq, 200,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));
);





////////////////////////////////////////////////

(
//dynmorph
~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var proxies = ();
	var bind = List.new;
	var proxy;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%.%".format(~name, mainkey, key).asSymbol;
		ndefkey.debug("ndefkey");
		proxies[key] = Ndef(ndefkey, { arg val;
			Lag.kr(val, lagtime)
		});
		//proxy = proxies[key];
		proxy = Ndef(ndefkey);
		bind.add(key);
		bind.add(Pfunc{ arg ev;
			[ev[key], key].debug("pfunc");
			proxy.set(\val, ev[key]);
			proxy.bus.asMap;
		});
	};
	Pbind(*bind)
}
)

(
// simple morph
~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var proxies = ();
	var bind = List.new;
	var proxy;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%.%".format(~name, mainkey, key).asSymbol;
		ndefkey.debug("ndefkey");
		proxies[key] = Ndef(ndefkey, { 
			Line.kr(Ndef(ndefkey).kr, val, lagtime)
		});
		//proxy = proxies[key];
		proxy = Ndef(ndefkey);
		bind.add(key);
		bind.add(proxy.bus.asMap);
	};
	Pbind(*bind)
}
)

(
// freqmorph
~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var proxies = ();
	var bind = List.new;
	var proxy;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%.%".format(~name, mainkey, key).asSymbol;
		ndefkey.debug("ndefkey");
		proxies[key] = Ndef(ndefkey, { 
			Line.kr(Ndef(ndefkey).kr, val, lagtime)
		});
		//proxy = proxies[key];
		proxy = Ndef(ndefkey);
		bind.add(key);
		if(key == \freq) {
			bind.add(proxy.bus.asMap);
		} {
			bind.add(proxy);
		}
	};
	Pbind(*bind)
}
)

(
// NOfreqmorph
~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var proxies = ();
	var bind = List.new;
	var proxy;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%.%".format(~name, mainkey, key).asSymbol;
		ndefkey.debug("ndefkey");
		proxies[key] = Ndef(ndefkey, { 
			Line.kr(Ndef(ndefkey).kr, val, lagtime)
		});
		//proxy = proxies[key];
		proxy = Ndef(ndefkey);
		if(key == \freq) {
			//bind.add(proxy.bus.asMap);
		} {
			bind.add(key);
			bind.add(proxy);
		}
	};
	Pbind(*bind)
}
)

Pdef(~name).play;
(
~a = Pdef(~name, ~morph.(\bla, 2.1, Pbind(
	\freq, 100,
	\ffreq, 300,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));
);

(
~a = Pdef(~name, ~morph.(\bla, 1, Pbind(
	\freq, 500,
	\ffreq, 700,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));
);


(
~a = Pdef(~name, 

	(
Pbind(
	\freq, 200,
) <>
~morph.(\bla, 1, Pbind(
	\ffreq, 400,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, Pbind(
	//\freq, 300,
	\ffreq, 1400,
)) <> Pbind(
	\freq, 300,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, Pbind(
	\freq, 800,
	\ffreq, 400,
)) <> Pbind(
	//\freq, 500,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, Pbind(
	\freq, 800,
	\ffreq, 400,
)) <> Pbind(
	//\freq, 500,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

Pdef(~name).play;



(
~a = Pbind(
	\instrument, ~name,
	\freq, Ndef(\bla, { SinOsc.kr(1).range(50,500) }).bus.asMap,
	\ffreq, 300,
	\dur, 1,
);
~a.play
);

(
~a = Pcollect( {
	arg ev;
	ev.postln;
} ) <> Pbind(
	\freq, Pseq([100,200],inf));
~a.play
)



(
Pbind(
	//\freq, 100,
	\ffreq, 200,
).asStream.next(())
)


(
	
	~a = Pbind(
		\ffreq, Ndef(\rah1, { SinOsc.kr(1).range(100,500) }),
	) <> Pbind(
		\instrument, ~name,
	);
	~a.play;
)

(
	
	~a = Pbind(
		\ffreq, Ndef(\rah1, { Line.kr(Ndef(\rah1).kr, 500) }),
	) <> Pbind(
		\instrument, ~name,
	);
	Pdef(\pd, ~a).play;
)

(
	
	~a = Pbind(
		\ffreq, Ndef(\rah1, { Line.kr(Ndef(\rah1).kr, 100) }),
	) <> Pbind(
		\instrument, ~name,
	);
	Pdef(\pd, ~a).play;
)



(
// pkey NOfreqmorph event
~morph = { arg mainkey, lagtime, event;
	var base = event;
	var proxies = ();
	var bind = List.new;
	var proxy;
	bind.add(\freq);
	bind.add(Pkey(\freq));
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%.%".format(~name, mainkey, key).asSymbol;
		ndefkey.debug("ndefkey");
		proxies[key] = Ndef(ndefkey, { 
			Line.kr(Ndef(ndefkey).kr, val, lagtime)
		});
		//proxy = proxies[key];
		proxy = Ndef(ndefkey);
		if(key == \freq) {
			//bind.add(proxy.bus.asMap);
		} {
			bind.add(key);
			bind.add(proxy);
		}
	};
	Pbind(*bind)
}
)

Pdef(~name).play;
(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, (
	freq: 300,
	ffreq: 1400,
)) <> Pbind(
	//\freq, 300,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, (
	freq: 300,
	ffreq: 400,
)) <> Pbind(
	//\freq, 300,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, (
	//freq: 100,
	flute: 100,
	ffreq: 400,
)) <> Pbind(
	\freq, 300,
	\rih, 20,
	\instrument, ~name,
	\dur, 1,
)).trace);
);


///////////////////:


(
// pkey NOfreqmorph event
~morph = { arg mainkey, lagtime, event;
	var base = event;
	var proxies = ();
	var bind = List.new;
	var proxy;
	var ndefkey;
	var val = 500;
	ndefkey = "%.%.%".format(~name, mainkey, \ffreq).asSymbol;
	Ndef(ndefkey, { 
		Line.kr(Ndef(ndefkey).kr, val, lagtime)
	});
	Pbind(
		\freq, 200,
		\ffreq, Ndef(ndefkey),
	)
}
)

Pdef(~name).play;
(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, (
	freq: 300,
	ffreq: 1400,
)) <> Pbind(
	//\freq, 300,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, (
	freq: 300,
	ffreq: 400,
)) <> Pbind(
	//\freq, 300,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

(
~a = Pdef(~name, 
	(
~morph.(\bla, 1, (
	//freq: 100,
	flute: 100,
	ffreq: 400,
)) <> Pbind(
	\freq, 300,
	\rih, 20,
	\instrument, ~name,
	\dur, 1,
)).trace);
);

/////////////////////////////


	Pdef(~name).play;
(
	
	~a = Pbind(
		\ffreq, Ndef(\rah1, { Line.kr(Ndef(\rah1).kr, 100) }),
	) <> Pbind(
		\instrument, ~name,
	);
	Pdef(~name, ~a);
)

(
~mo = {
	var ndefkey = "h.bl.ffreq".asSymbol;
	Pbind(
		\ffreq, Ndef(ndefkey, { Line.kr(Ndef(ndefkey).kr, 500) }),
	)
};
)

(
~mo = {
	var ndefkey = "h.bla.ffreq".asSymbol;
	Pbind(
		\ffreq, Ndef(ndefkey, { Line.kr(Ndef(ndefkey).kr, 500) }),
	)
};
)

(
~mo = {
	var ndefkey = "%.%.%".format(~name, \bla, \ffreq).asSymbol;
	Pbind(
		\ffreq, Ndef(ndefkey, { Line.kr(Ndef(ndefkey).kr, 500) }),
	)
};
)

(
	
	~a =  ~mo.() <> Pbind(
		\instrument, ~name,
	);
	Pdef(~name, ~a);
)
