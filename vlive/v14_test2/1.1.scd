(
	~morphtime = 8;
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\woodshop);
~buf = BufDef(\moeten);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, (
	Pbind(
		\bufnum, ~buf,
		\freq, 300,
	) <>
	//~morph.(~name+++\morph2, 1.3, Sdef(~name, \mypreset).pdef <> Pbind(\amp, 0.5))
	//Sdef(~name, \mypreset).getsub(2).pbind
	//Sdef(~name, \mypreset).get(0,2).pbind
	//Sdef(~name, \mypreset).get(0,1).pbind
//	Sdef(~name, \mypreset).getsub(0).pbind
	//~morphpat.(Sdef(~name, \mypreset).get(0).pbind <> Pbind(\amp, 0.5), Sdef(~name, \mypreset).get(1).pbind <> Pbind(\amp, 0.5), 1)
//~morphpat.(Sdef(~name, \mypreset).get(0).pbind , Sdef(~name, \mypreset).get(1).pbind , 1)
//~morphpat.(Sdef(~name, \mypreset).getsub(0).pbind , Sdef(~name, \mypreset).getsub(1).pbind , Plast(Pseries(0,1/32,32)))
	~morphpat.(Sdef(~name, \mypreset).get(1).pbind , Sdef(~name, \mypreset).get(0).pbind , Pseg(Plast(Pseq([0,1])),~morphtime))
	<>
	Pbind(

	)
));
)

// END

Sdef(~name, \mypreset).rebuild
Sdef(~namex, \mypreset).edit
Sdef(~name, \mypreset).rebuild(true)
a = IdentityDictionary.new; a.putPairs( Sdef(~namex, \mypreset).specs ); a[\fshift]
Sdef(~namex, \mypreset).get(0,0)
Sdef(~name, \mypreset).active_subindex
Sdef(~name, \mypreset).all[0][0] = nil
~score_storage.all['1'][\mypreset] = nil

Pdef.all.do { arg x; x.postln; }

Pdef('1.0.mypreset').source.asCompileString
Pdef('1.0.mypreset').play

	~morphpat.(Sdef(~name, \mypreset).get(0).pbind<> Pbind(\amp, 0.5), Sdef(~name, \mypreset).get(1).pbind<> Pbind(\amp, 0.5), 1).play
	Sdef(~name, \mypreset).get(1).pbind.asCompileString
	.pbind<> Pbind(\amp, 0.5), Sdef(~name, \mypreset).get(1).pbind<> Pbind(\amp, 0.5), 1)



	(
		
		Pdef(\test,
		
			Pbind(\instrument, \oscsampler) <> ~morphpat.(Sdef(~name, \mypreset).get(0).pbind , Sdef(~name, \mypreset).get(1).pbind , 1.0) 

		).play
	)

	(
		
		Pdef(\test,
		
			Pbind(\instrument, \oscsampler)

		).play
	)

(
SynthDef(\test, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

	(
		
		Pdef(\test,
		
			 ~morphpat.(Pbind(\ffreq, 300) , Pbind(\ffreq, 3000) , 0.5) <> Pbind(\instrument, \test)

		).play
	) 


  
(
~wrapper = { arg pat;
    Prout { arg in;
        var str = pat.asStream;
        var ev = str.next(in);
        while( { ev.notNil } ) {
            var evc = ev.copy;
            evc[\dur] = 0.8 * ev[\dur];
            evc.yield;
            evc[\dur] = 0.2 * ev[\dur];
            in = evc.yield;
            ev = str.next(in);
        };
        nil;
    };
};

~pat = Pbind(\freq, Pseq([100,200],4));
(~wrapper.(~pat) <> Pbind(\bla, Pseq([10,20,30],inf))).trace.play;
//(~wrapper.(~pat)).trace.play;
)





Pdef(~name +++ \pre, (
	Pbind(
		\bufnum, ~buf,
		//\freq, 300,
	) <>
	//~morph.(~name+++\morph2, 7.3, Sdef(~name, \mypreset).pdef <> Pbind(\amp, 0.5))
	Sdef(~name, \mypreset).get(1).pbind
	//~morphpat.(Sdef(~name, \mypreset).get(0).pbind <> Pbind(\amp, 0.5), Sdef(~name, \mypreset).get(1).pbind <> Pbind(\amp, 0.5), 1)
	//~morphpat.(Sdef(~name, \mypreset).get(0).pbind , Sdef(~name, \mypreset).get(1).pbind , 1)
	<>
	Pbind(
	\freq, 100,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, 0.412,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\fshift, 0,
	\fshift, Pseq([0,48,-40],inf),
	\fshift, -148,
	\lpmix, 0.11,
	\rq, 0.4,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.004,0.0009,0.0071].integrate.postln,[0.02,0.4]) ],
	],inf),
	//\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.0001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\bufnum, ~buf,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
	\ffreqtab, Pseq([[Array.geom(8,0.1,1.2).postln]],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.21) ],
	],inf),
	\legato, 0.5,
	\amp, 1 * Pkey(\amp),

	).trace
));
)


(
	
	~a = Pseq([1,2,3,4,5]);
	~a.asStream.nextN(10);
)
~plast = { arg pat, len;
	Pclutch(pat, Pseq([Pn(1,len),Pn(0)]));

} 
(
	
	~a = Pclutch(Pseq([1,2,3,4,5]), Pseq([Pn(1,5),Pn(0)]));
	~a.asStream.nextN(10);
)
Plast
(
	
	~a = Plast(Pseq([1,2,3,4,5]),2);
	~a.asStream.nextN(10);
)

(
	
	~a = Prout({ arg in;
		loop {
			if(in.isNil) {
				"in is nil".debug;
			};
			in.debug("in");
			in = in.yield;
		}
	}) <> Pseq([1,2,3,4,5]);
	~a.asStream.nextN(10);
)

{ SinOsc.ar(200) }.play

Pdef(\plop, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
));
