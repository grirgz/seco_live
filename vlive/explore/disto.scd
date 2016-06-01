(
Ndef(\source, {
	var sig = SoundIn.ar([0,1]);
	sig.debug("soundin");
}).play(BusDef(\fx1, \audio).index, 2);
)

(
Ndef(\disto, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	in.debug("in");
	sig = in;
	sig = sig * 400;
	sig = sig.distort  / 4;
}).play;
);
Ndef(\disto).clear

VarDef
EnvInit(\yep, { "sds" })
~y
~yep.value
~shaper_buffers
(
// shaper
~bank_size = 8;
~shaper_buffers = ~shaper_buffers ?? {
	~bank_size.collect({ arg x;
		Buffer.alloc(s, 1024, 1);
	})
};
~tables = ~bank_size.collect { Signal.chebyFill(513,{ 1.0.rand } ! 4) };
~tables.debug("tables");
//~table = Signal.chebyFill(513,[1, 0.5, 0.1, 0.725]);

~shaper_buffers.do({ arg buf, x;
	buf.sendCollection(~tables[x].asWavetableNoWrap);  
});
Ndef(\disto, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	in.debug("in");
	sig = in;
	~shaper_buffers.do { arg buf, x;
		sig.debug("sig"++x);
		sig = sig * 10;
		//sig = LPF.ar(sig, ( ( ( ~bank_size - x ) )**2 * 100 ).debug("fx").clip(20,1800)  );
		sig = Shaper.ar(buf, sig) / 1 + ( sig / 4 );
	};
	sig * 1;
	//sig = sig.distort  / 4;
}).play;
);

b = Buffer.alloc(s, 1024, 1);

//size must be power of two plus 1
t = Signal.chebyFill(513,[1, 0.5, 0.1, 0.725]);

// linear function
t.plot

// t.asWavetableNoWrap will convert it to the official Wavetable format at next power of two size
b.sendCollection(t.asWavetableNoWrap);  // may also use loadCollection here

b.plot

(
{     var    sig = Shaper.ar(b, SinOsc.ar(440, 0, 0.4));
    sig ! 2
}.scope;
)

b.free;

////////////////////////////////////////////////////////////



(
// shaper
~bank_size = 4;
~shaper_buffers = ~shaper_buffers ?? {
	~bank_size.collect({ arg x;
		Buffer.alloc(s, 1024, 1);
	})
};
~tables = ~bank_size.collect { Signal.chebyFill(513,{ 2.0.rand } ! 4) };
~tables.debug("tables");
~tables.do({ arg table, x;
	~shaper_buffers[x].sendCollection(table.asWavetableNoWrap);  
});
Ndef(\disto, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var sigs;
	in.debug("in");
	sig = in;
	sigs = ~tables.collect { arg table, x;
		var isig;
		var base = 1200;
		sig.debug("sig"++x);
		isig = sig * 1180;
		isig = LPF.ar(isig, ( ( ( ~bank_size - x ) )**2 * base ).debug("fx").clip(20,1800)  );
		isig = HPF.ar(isig, ( ( ( ~bank_size - x - 1 ) )**2 * base ).debug("hfx").clip(20,1800)  );
		isig = Shaper.ar(~shaper_buffers[x], isig) / 1 + ( isig / 4 );
		isig.debug("eisig");
		isig;
	};
	sigs.debug("sigs");
	sig = sigs.mean;
	sig = sig / 4;
	sig = Limiter.ar(sig);
	sig = sig / 4;
	sig.debug("endsig");
	//sig = sig.distort  / 4;
}).play;
);

(
~tables = ~bank_size.collect { Signal.chebyFill(513,{ arg x; sin(x+0.31.rand) } ! 6) };
~tables.debug("tables");
~tables.do({ arg table, x;
	~shaper_buffers[x].sendCollection(table.asWavetableNoWrap);  
});
)


(
Ndef(\source, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7].midiratio);
	sig = AllpassL.ar(sig, 1.1, \del.kr(1.01), \dec.kr(1)) + sig;
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, 0.01, amp, pan);
}).play(BusDef(\fx1, \audio).index, 2);
);

Ndef(\source).stop

(
SynthDef(\simple, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = AllpassL.ar(sig, 1.1, \del.kr(1.01), \dec.kr(1)) + sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,\rel.kr(1.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\source, Pbind(
	\instrument, \simple,
	\degree, Pseq([0, 2+7, 4, 1],inf) * Pseq([ [0,0], [1,0], [1,2], [1,4]],inf),
	\octave, 4,
	\sustain, 0.1,
	\pan, Prand([0,0.1,-0.1,Pwhite(0.1,-0.1,1)],inf),
	\dur, 1/2,
	\out, BusDef(\fx1),
	\amp, 0.1/2
)).play;
);
Pdef(\source).set(\freq, nil)
Pdef(\source).clear

Pdef(\source).addHalo(\instrument, \simple)
Pdef(\source).asParamGroup.edit

Ndef(\source).edit
Ndef(\disto).edit

(
Ndef(\disto, { arg freq=200, pan=0, amp=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var sigs;
	in.debug("in");
	sig = in;
	sigs = List.new;
	~tables.do { arg table, x;
		var isig;
		var base = 1200;
		sig.debug("sig"++x);
		isig = sig * \dist.kr(10) * SinOsc.kr(1/(x+ 123 )).range(1.110,1);
		//isig = LPF.ar(isig, ( ( ( ~bank_size - x ) )**2 * base ).debug("fx").clip(20,1800)  );
		//isig = HPF.ar(isig, ( ( ( ~bank_size - x - 1 ) )**2 * base ).debug("hfx").clip(20,1800)  );
		isig = Shaper.ar(~shaper_buffers[x], isig) / 1 + ( isig / 4 );
		isig.debug("eisig");
		sigs.add(sig);
		sig = sig + isig;
	};
	sigs.debug("sigs");
	//sig = sigs.mean;
	sig = sig / 4;
	sig = sig + LPF.ar(sig, 200, 4);
	sig = Limiter.ar(sig);
	sig = sig / 4;
	sig.debug("endsig");
	sig = SelectX.ar(\mix.kr(0.0), [in, sig]);
	sig = sig * amp;
	//sig = sig.distort  / 4;
}).play;
)
