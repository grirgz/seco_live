
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2;
	var osize = 40;
	freq = osize.collect { arg x;
		var ou;
		//ou = freq * (SinOsc.ar(4+4.0.rand)*(0.1+0.1.rand)*SinOsc.kr(1/8).range(0.01,2)+1) + 1.0.rand;
		//ou = freq * (x+1) + x;
		ou = freq * (x+1);
		ou; 
	};
	//freq = [120,325];
	sig = LFSaw.ar(freq).collect({ arg in, x;
		var ti = 8;
		//in = in * SinOsc.kr(1/4, x/osize * pi).unipolar;
		//in = in * SinOsc.kr(1/((x+1)/osize*osize)).unipolar;
		in = RLPF.ar(in, freq[x]*2);
		in;
		//in = in * LFPulse.kr(1/ti).lag((x+1)/osize * ti);
	});
	sig = sig.clump(2).mean * 2;
	//sig1 = CombL.ar(sig, 0.1,(0.1*MouseY.kr(0,1)).poll,0)*SinOsc.ar(80).range(-1,1) + sig;
	sig = SinOsc.ar(100);
	sig = LFSaw.ar(100);
	//sig1 = SinOsc.ar(MouseX.kr(1,200)).range(-1,1) * sig;
	sig1 = SelectX.ar(SinOsc.ar(MouseY.kr(1,300)).unipolar, [
		DC.ar(1),
		LFSaw.ar(MouseX.kr(1,200)).range(-1,1),
	]);
	//sig1 = SelectX.ar(MouseY.kr(0,2), [
	//	SinOsc.ar(MouseX.kr(1,200)).range(-1,1),
	//	DC.ar(1),
	//	LFSaw.ar(MouseX.kr(1,200)).range(-1,1),
	//]);
	sig1 = sig1 * sig;
	//sig1 = CombL.ar(sig, 0.1,(0.1*MouseY.kr(0,1)).poll,0)*1/2 + sig;
	//sig = SelectX.ar(MouseX.kr(0,1), [sig, sig1/2]);
	sig = sig1;
	sig = RLPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp);
	//sig = Splay.ar(sig.sum, 0.1, amp, pan);
}).play;
);



(
Pbind(
	\play, Pseq([
		{ "1".postln; },
		{ "2".postln; },
	],inf),
).play
)

(
Pbind(
	\dummy, Pseq([
		{ "1".postln; },
		{ "2".postln; },
	],inf).collect(_.value),
).play
)




//first we load a couple of functions from my library of functions
v=();
//math sigma
v[\sigma]=
{arg arrayin=[], start=0, end=arrayin.size;
var array=arrayin[start..end], total=0;
    {arg it;
        total=total+array[it]}!array.size;
    total
};

v[\sigmacomp]={arg arrayin=[]; var total=0; {|it|total=total+arrayin[it]}!arrayin.size};
v[\deltacomp]=
{arg arrayin= []; var array=arrayin.copy;
    {|it| array[it+1]=array[it+1]-v[\sigma].(array, end:it)}!(array.size-1); array};

//and now we begin
(var
freqras=[0,0,0], ampras=[0,0,0],
envep=[[0,0,0, 0,0,0, 0,0,0],[0,0,0, 0,0,0, 0,0,0],[0,0,0, 0,0,0, 0,0,0]],
envet=[[1,3,2, 1,1,1, 1,1,1],[1,1,1, 1,1,1, 1,1,1],[1,1,1, 1,1,1, 1,1,1]],
curves=[[0,0,0, 0,0,0, 0,0,0],[0,0,0, 0,0,0, 0,0,0],[0,0,0, 0,0,0, 0,0,0]],

relenvet=
{arg envet; var timesize=v[\sigma].(envet), rescaled=envet/timesize; v[\sigmacomp].(rescaled)},

prenodes=Array.newClear(3),
timesize={|it| v[\sigma].(envet[it])}!3,

totalwidth=1300, totalheight=500,
envwidth=400, envheight=200,
rawidth=40, raheight=30,
curvwidth=20, curvheight=20,
absleft=5, abstop=50,
sep=5,
//leftmul, topmul,

wendy=Window(name: "Trienvedit", bounds: Rect(left:10, top:10, width: totalwidth, height:totalheight)),


envel=
{|it| var env=
    EnvelopeView(parent: wendy, bounds:
        Rect(left:(it/3)*totalwidth+absleft, top: abstop, width: envwidth, height: envheight));

    env.setEnv(Env(levels:envep[it],
        times:envet[it]/timesize[it],
//v[\sigmacomp].(envet[it]/timesize[it]),
        curve: curves[it]));
   
    env.editable=true;

}!3,

curvfield=
{|ut|
    {|it| var field =
        TextField(parent: wendy,
        bounds:Rect(left:absleft+((it/9)*envwidth)+((ut/3)*totalwidth)+5,
            top: envheight+15+abstop, width:curvwidth, height: curvheight));
        field.value_(curves[ut][it]);
        field.action_({arg in; curves[ut][it]=in.value;});
    }!9
}!3,

freqrafield=
{|it| var field =
    TextField(parent: wendy,
    bounds:Rect(left:(it/3)*totalwidth+absleft,
        top: abstop-raheight-10, width: rawidth, height: raheight));
    field.value_(freqras[it]);
    field.action_({arg in; freqras[it]=in.value.compile.value;});
}!3,

amprafield=
{|it| var field =
    TextField(parent: wendy,
    bounds:Rect(left:(it/3)*totalwidth+absleft+(envwidth-rawidth),
        top: abstop-raheight-10, width: rawidth, height: raheight));
    field.value_(ampras[it]);
    field.action_({arg in; ampras[it]=in.value.compile.value;});
}!3,

postbutton=Button(parent: wendy, bounds: Rect(left:10, top:400, width:50, height:50)
).action_(
    {var resul=
        {|it| v[\deltacomp].( envel[it].value[0])*timesize[it]}!3;
       
        resul.postln
    }
)
;

~envel = envel;
wendy.front;
)


~envel[0].value

~envel[1].setEnv(Env([1,2,4]/4,[1,0.5], [-1,0]))
~envel[1].value

(
	~env = Env([1,2,4]/8,[1,0.5], [-1,0]);
	~env.asCompileString.debug("start");
	~envview = EnvelopeView.new;
	~envview.setEnv(~env); // [levels, times]
	~xylist = ~envview.value.deepCopy; // [times, levels]
	~xylist.debug("view result");
	~xylist[1] = ~xylist[1] * 8; // scale back levels
	~xylist[0] = ~xylist[0] * ~env.times.sum; // scale back times
	~xylist.debug("scaled");
	~levels = ~xylist[1];
	~times = ~xylist[0].differentiate; // absolute to relative time
	~times = ~times.drop(1); // drop the starting point (always 0)
	Env(~levels, ~times, ~env.curves).asCompileString("end");
)
~env.curves
EnvelopeView

v[\sigmacomp].([ 0, 0.67, 1  ])
v[\deltacomp].([ 0, 0.67, 1  ])
#
~env.times



~reverb = Bus.audio(s, 2);

(

var reverb, delay;
reverb = Bus.audio(s, 2);
delay = Bus.audio(s, 2);


SynthDef(\reverb, {arg out = 0, in=0;
    var sig = In.ar(in, 2);
    sig = FreeVerb.ar(sig,0.5,0.5);
    ReplaceOut.ar(out, sig);
}).add;

SynthDef(\delay, {arg out = 0, in;
    var sig = In.ar(in, 2) + LocalIn.ar(2);
    LocalOut.ar(DelayL.ar(sig, 0.5, 0.1)*0.8);
    Out.ar(out, sig);
}).add;

fork{
   
100.do({|i|
    var name;  
    name = "perc"++i;
    SynthDef(name, { arg out = 0;
                        var freq = [24, 57, 68, 29, 87, 39, 70].choose.midicps;
                        var decay =  rrand(0.1, 0.5);
                        var pan = rrand(-1.0, 1.0);
            var sig = [SinOsc, Saw].choose.ar(freq + (SinOsc.ar([0, 1, 2, 3, 4].choose*freq*rrand(1, 30))))*0.1;
        var env = EnvGen.kr(Env.perc(0.01, decay), doneAction: 2);
            Out.ar(out, Pan2.ar(LPF.ar(sig*env, 3000), pan));
    }).add;
    });
   

s.sync;

        Synth.tail(1,\reverb);
    Synth(\delay, [\in: delay]);
   
    inf.do({
    i = rrand(0, 99);
        Synth("perc"++i, [\out: [reverb, delay].choose]);
    rrand(0.1, 0.4).wait;
})
}
)



(
	TempoClock.default.tempo = 1;
	
	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/4,
		\octave, 4,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..24)).asStream;
			var lenstr = Pseq([4,3],inf).asStream;
			var buf = Array.fill(16,{List.new});
			var deg, len;

			len = lenstr.next;

			inf.do { 

				var i = ev[\index];
				var n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1];
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace.play
)

(
// change the rules a bit
	
Pdef(\mol,
	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/4,
		//\root, Pseq([2,0],inf),
		\mtranspose, Pseq([0,3,4,3],inf).stutter(8),
		\octave, 4,
		\scale, Scale.dorian,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..13),inf).asStream;
			var lenstr = Pseq([3,8,2],inf).asStream;
			var buf = Array.fill(16,{List.new});
			var keep = 3; // max note per chord
			var deg, len;

			len = lenstr.next;

			inf.do { 

				var i = ev[\index];
				var n;
				buf[i] = buf[i].keep(0-keep);
				n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1]/2;
						//ev[\legato] = 1;
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace
).play;
)



(
// change the rules a bit
	
Pdef(\mol,
	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/8,
		//\root, Pseq([2,0],inf),
		//\mtranspose, Pseq([0,3,4,3],inf).stutter(8),
		\octave, 4,
		\scale, Scale.minor,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..13),inf).asStream;
			var lenstr = Pseq([6,5,4,3,2,1],inf).asStream;
			var patstr;
			var buf = Array.fill(16,{List.new});
			var keep = 3; // max note per chord
			var pat, len;

			patstr = 
				Pseq([
					Pbind(
						\instrument, Pn(\simple,4)
					),
					Pbind(
						\instrument, Pn(\saw,4),
						\ffreq, Pseq([5000,1000,200,2000],inf)
					),
				],inf) 
				<>
				Pbind(
					\degree, Pseq([
						Pseq((0..13)),
						Pseq((10..1)),
						Pseq((10..1)*2),
					],inf),
				);

			pat = patstr.asStream;

			len = lenstr.next;

			inf.do { 

				var i = ev[\index];
				var n;
				buf[i] = buf[i].keep(0-keep);
				n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				pat = patstr.next(Event.default);
				pat[\legato] = len/2;
				n.add(pat);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						k
						pat.keysValuesDo { arg key,val;
							ev[key] = val;
						};
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1]/2;
						//ev[\legato] = 1;
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace
).play;
)

/////////////////////////////////////////////////////////

(
Pdef(\mol, 

	Prout({ arg ev;
	
		var lenstr = Pseq([4.5,8],inf).asStream;
		var patstr;
		var quant = 16;
		var buf = Array.fill(quant,{List.new});
		var keep = 3; // max note per chord
		var pat, len;
		var i;
		var basepat;

		// the pattern sequence
		patstr = 
			Pseq([
				Pbind(
					\instrument, Pn(\simple,4),
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.4) ],
						[ Env.adsr(0.4,0.4,0.6,0.2) ],
					],inf),
				),
				Pbind(
					\instrument, Pn(\saw,4),
					\ffreq, Pseq([5000,1000,200,2000],inf),
					\adsr, Pseq([
						[ Env.adsr(0.1,0.4,0.4,0.3) ],
					],inf),
				),
			],inf) 
			<>
			Pbind(
				\degree, Pseq([
					Pseq((0..13)),
					Pseq((0..10)-4),
					Pseq((5..1)),
					Pseq((0..5)*2),
					Pseq((20..10)),
					Pseq((0..10)-10),
				],inf),
			);

		patstr = patstr.asStream;

		len = lenstr.next;

		i = 0;
		inf.do {
			var n;
			buf[i] = buf[i].keep(0-keep);
			n = buf[i];

			if(n.size != 0) {
				// previous note found, change note length
				len = lenstr.next;
			};

			basepat = ev;
			basepat[\legato] = len/2;
			pat = patstr.next(basepat);
			pat.debug("first pat");
			n.add(Pn(pat,1));

			len.do {
				var n = buf[i];

				if(n.size != 0) {
					n.debug("embed");
					ev = Ppar(n).embedInStream;
				} {
					var myev;
					myev = ev.deepCopy;
					myev[\isRest] = true;
					ev = Pn(myev,1).embedInStream;
				};
				i = (i+1) % quant;
			};
		}
	})
	<>
	Pbind(
		\dur, 1/4,
		\scale, Scale.minor,

	)

).play;

)
//////////////////////// =========
(
~molecular_box = { arg lenpat, quant=16, keep=3, pattern;

	Prout({ arg ev;
	
		var lenstr = lenpat.asStream;
		var patstr;
		var buf = Array.fill(quant,{List.new});
		var pat, len;
		var i;
		var basepat;

		patstr = pattern.asStream;

		len = lenstr.next;

		i = 0;
		inf.do {
			var n;
			buf[i] = buf[i].keep(0-keep);
			n = buf[i];

			if(n.size != 0) {
				// previous note found, change note length
				len = lenstr.next;
			};

			basepat = ev;
			basepat[\legato] = len;
			pat = patstr.next(basepat);
			n.add(Pn(pat,1));

			len.do {
				var n = buf[i];

				if(n.size != 0) {
					ev = Ppar(n).embedInStream;
				} {
					var myev;
					myev = ev.deepCopy;
					myev[\isRest] = true;
					ev = Pn(myev,1).embedInStream;
				};
				i = (i+1) % quant;
			};
		}
	})
};
);

(
SynthDef(\simple, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq * [1,1.01,2.01,1.02,1/2] * (SinOsc.kr(3)*0.01+1));
	sig = sig + LFTri.ar(freq * [1,1/2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	sig = LFSaw.ar(freq * [1,1.01,2.01,1.02]);
	sig = Pulse.ar(freq * [1,1.01,2,2.01,1.002]) + sig;
	env = EnvGen.ar(Env.adsr(0.4,0.3,0.31,0.1),gate,doneAction:0);
	sig = RLPF.ar(sig, \ffreq.kr(1000) * (env+0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\reverb, {arg out = 0, in=0;
    var sig = In.ar(in, 2);
    sig = FreeVerb.ar(sig,0.5,0.7);
    ReplaceOut.ar(out, sig);
}).add;
);

Synth.tail(1,\reverb); // if you want

(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,8],inf), 16, 3,
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
			Pbind(
				\instrument, Pn(\saw,4),
				\ffreq, Pseq([5000,1000,200,2000],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((0..13)),
				Pseq((0..10)-4),
				Pseq((5..1)),
				Pseq((0..5)*2),
				Pseq((20..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\scale, Scale.minor,
	)

).play;

)

(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,2,5,1],inf), 16, 3,
		Pbind(
			\legato, Pseq([
				Pfuncn({ arg ev; ev[\legato] },16),
				Pser([0.5],16)
			],inf)
		)
		<>
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) * Pseq([0.2,0.8,1.2],inf).stutter(3),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pseq([5000,1000,700],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pkey(\freq) * 4,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((5..1)),
				Pseq((0..3)),
				Pseq((0..10)-4),
				Pseq((0..5)*3),
				Pseq((2..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\mtranspose, 2,
		\root, 4,
		\scale, Scale.aeolian,
	)

).play;
)

(

Pdef(\mol, 

	~molecular_box.(Pseq([3,4],inf), 16, 3,
		Pbind(
			\legato, Pseq([
				Pfuncn({ arg ev; ev[\legato] },16),
				Pser([0.5],16)
			],inf)
		)
		<>
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) * Pseq([0.2,0.8,1.2],inf).stutter(3),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pseq([5000,1000,700],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pkey(\freq) * 4,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				//Pseq([1,2,3,2,1,4,5,7,8,5,4,1,2,3,4,5]),
				Pseq((0..8))
			],inf) + Pseq([0,4,8,12]).stutter(4),
		);

	)
	<>
	Pbind(
		\dur, 1/8,
		\octave, 4,
		\mtranspose, 2,
		\root, 4,
		\scale, Scale.aeolian,
	)

).play;
)

////////////////////////////////////////////////////////

(
	Prout({ arg ev;
		var pat1, pat2, pats;
		pats = [
			Pbind(
				\instrument, \default,
				\degree, Pseq([0,1]),
			),
			Pbind(
				\instrument, \default,
				\degree, Pseq([3,3,3,4]),
			),
		].collect(_.asStream);
		inf.do {
			Ppar( pats.collect{ arg x; Pn(x.next(ev),1) } ).embedInStream;
		}
	
	}).play
)


[1,2,3,4,5,6,7].keep(-4)


	(
	Pbind(
		\instrument, \default,
		\bla, [1,2,3],
		\freq, 200,
		\dur, 1,
		\amp, 0.1
	).play;
	)
