["cs", "xx"].replace("cs", "az")
[1, "cs", "xx"].replace(1, "az")
[1, [1,2],"cs", "xx"].replace([1,2], "az")
[1, "cs", "xx"].replace(1, [3,3,[6,3],3])

Array.replace


{Splay.ar(Ringz.ar(Impulse.ar([2, 1, 4], [0.1, 0.11, 0.12]), 140, [0.1, 0.1, 0.5])) * EnvGen.kr(Env([1, 1, 0], [120, 10]), doneAction: 2)}.play

8,7,7,7,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,
(
~spiral = {
	var dir = [1,0];
	var list = List.new;
	var idx = [-1,0];
	var size = 8;
	size.do { arg x;
		[x, size].debug("x,s");
		if(x==0, 1, 2).do {
			(size-x).debug("seg").do {
				idx = idx + dir;
				list.add(idx.debug("idx"));
			};
			debug("rotate");
			dir = [ -1 * dir[1], dir[0] ]; // rotate
		};
		debug("endseq");
	};
	list;
};
~spiral.();
)

~launchpad_device_id
(
MIDIClient.init;
MIDIIn.connectAll;
~lpOut = MIDIOut(0);
~lpNoteNums = Array.fill([8,8], {|i,j| j+(i*16) });
)

~lpNoteNums.at(0,1)
~lpNoteNums[0,1]

(
var path = {
	var dir = [1,0];
	var list = List.new;
	var idx = [-1,0];
	var size = 8;
	size.do { arg x;
		if(x==0, 1, 2).do {
			(size-x).do {
				idx = idx + dir;
				list.add(idx);
			};
			dir = [ -1 * dir[1], dir[0] ]; // rotate 
		};
	};
	list;
}.value.collect({ arg x; x[0]+(x[1]*16) });

r = Routine({
	inf.do{
		var velocity = [127, 120, 107].choose;
		path.do{|note, i|
			~lpOut.noteOn(~lpChan, note, velocity);
			0.015.wait;
			~lpOut.noteOff(~lpChan, note, velocity);
		}
	}
});
TempoClock.default.sched(0, r);
)


(
var path = {
	var dir = [1,0];
	var list = List.new;
	var idx = [-1,0];
	var size = 8;
	size.do { arg x;
		if(x==0, 1, 2).do {
			(size-x).do {
				idx = idx + dir;
				list.add(idx);
			};
			dir = [ -1 * dir[1], dir[0] ]; // rotate 
		};
	};
	list;
}.value.collect({ arg x; x[0]+(x[1]*16) });
r = Routine({
	inf.do{
		var velocity = 0;
		path.do{|note, i|
			~lpOut.noteOn(~lpChan, note, velocity);
			velocity = ( velocity + 4 );
			if(velocity > 16) {
				velocity = velocity % 16 + 2;
			};
			0.015.wait;
			//~lpOut.noteOff(~lpChan, note, velocity);
		}
	}
});
TempoClock.default.sched(0, r);
)




//////////////////////////////////////////////////////////////////////////////////////

[1,0]
[0,1]
[-1,0]
[0,-1]

cos(-pi/2)
sin(-pi/2)

~rot = { arg d; [ d[0]*0 - ( d[1]*1 ), d[0]*( -1 ) + ( d[1]*0 ) ] } // anti
~rot = { arg d; [ d[1], -1 * d[0] ] }

~rot = { arg d; [ d[0]*0 - ( d[1]*1 ), d[0]*( 1 ) + ( d[1]*0 ) ] }
~rot = { arg d; [ -1 * d[1], d[0] ] }

~rot = { arg d; [ d[0]*0 - ( d[1]*1 ), d[0]*( -1 ) - ( d[1]*( -1 ) ) ] }
~rot.([1,0])
~rot.([0,1])
~rot.([-1,0])


(
~primes = [ 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063,
	1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153,
	1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237,
	1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319,
	1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429, 1433,
	1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499,
	1511, 1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, 1597,
	1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669,
	1693, 1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777,
	1783, 1787, 1789, 1801, 1811, 1823, 1831, 1847, 1861, 1867, 1871, 1873,
	1877, 1879, 1889, 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979,
	1987, 1993, 1997, 1999, 2003, 2011, 2017, 2027, 2029, 2039, 2053, 2063,
	2069, 2081, 2083, 2087, 2089, 2099
]; 
~t = 1;

Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tr = Dust.kr(4);
	var in;
	tr = TDuty.kr(1/8/~t, 0, Dseq([
		1,0,1,1,
		1,1,1,0,
	],inf));
	freq = 440 / 2 * Duty.kr(1/~t, 0, Dseq([
		1,0,4,0,
	],inf)).midiratio;


	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq*1/4) * 1 )));
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*4/8 * ( 1 + ( SinOsc.ar(freq * 2/3) * 0.1 ))) * 1 )));
	sig = sig * EnvGen.kr(Env.perc(TExpRand.kr(0.01,0.1, tr),0.45), tr);
	in = sig;
	//sig = { AllpassN.ar(sig, 0.05, ~primes.choose / 2000000 * ( 1 + ( SinOsc.kr(1/4) * 0 )), 50 ) } ! 4;
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	//sig = AllpassN.ar(sig, 0.05, ~primes.choose / 200000);
	3.do{ arg i;
		sig = AllpassN.ar(sig, 0.05, {~primes.choose!2}!2 / 200000 * Rand(1,0.1) * ( 1 + ( SinOsc.ar((i+1)/2) * 0 )),0.1).sum + sig; 
		//sig = sig.clip2(0.4) / 3;
		//sig = sig.tanh;
	};
	sig = sig * 8;
	sig = LeakDC.ar(sig);
	sig.debug("sig");
	sig = Limiter.ar(sig);
	sig = SelectX.ar(\mix.kr(1.0), [in, sig]);
	//{ sig = AllpassN.ar(sig, 0.05, 0.05.rand, 5 ) + sig } ! 6;

	sig = Pan2.ar(sig, pan, amp).sum;
}).play;
);
Ndef(\plop).clear

Pspawner({arg sp;
        loop{
                var deg=5.rand;
                sp.seq(
                        Pbind(\degree,deg , \dur, Pn(0.45,5) ).trace
                );
        }
}).play


(
Pspawn(
        Pbind(
                \degree, Pseq([0,1,2]),
                \pattern, Pfunc{ arg ev;
                        Pbind(\degree, ev.degree, \dur, Pn(0.45,5) ).trace
                },
                \dur, 0,
                \method, \seq,
        )
).play
)


(
Ndef(\grai, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var clk, bufnum, pitch_stretch=1, pos=0, dur=0.1;
	var xf;
	xf = 500 * SinOsc.kr(1/13).range(1/34,1);
	xf = 77;
	clk = Impulse.ar(xf);
	bufnum = BufDef.mono(\oeuf, "field/oeuf.flac");
	bufnum = BufDef.mono(\crepe, "field/crepe.flac");
	bufnum = BufDef.mono(\scream, "vipere/scream.flac");
	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	bufnum = BufDef.mono(\amen, "vipere/amenbreak.wav");
	pos = SinOsc.kr(1/2).range(0,0.01) + SinOsc.kr(1/43).range(0,1);
	pos = LFNoise1.kr(1).range(0,0.01) + SinOsc.kr(1/143).range(0,1);
	pos = Latch.ar(SinOsc.kr(1/12).range(0,0.01), clk) + SinOsc.kr(1/43).range(0,1);
	pos = Demand.ar(clk, 0, Dseq([
		SinOsc.kr(1/4).range(0,0.01),
		SinOsc.kr(1/15).range(0,0.1),
		SinOsc.kr(1/7).range(0,0.01),
	],inf))+ LFSaw.kr(1/43).range(0,1);
	pos = Demand.ar(clk, 0, Dseq(
		{ LFNoise1.kr(1/122).range(0.0,1.0) + rrand(0.31,0.01) } ! 4
	,inf));
	pos = SinOsc.kr(1/2).range(0,0.01) + SinOsc.kr(1/43).range(0,1);
	pos = 0.3;
	pos = MouseX.kr(0,1);
	//pos.poll;
	pitch_stretch = LFNoise1.ar(1)/10 + 1;
	pitch_stretch = 1;
	dur = SinOsc.kr(1/7).exprange(0.1,1);
	dur = 0.1;
	sig = TGrains3.ar(2, clk, bufnum, pitch_stretch, pos , dur, pan, 1);
	sig = sig * 1;
	sig= Limiter.ar(sig, 1);
}).play;
);


s.sendMsg(\b_allocRead, 10, "sounds/a11wlk01.wav");

(
{
    var b = 10, trate, dur, clk;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    clk = Dust.kr(trate);
    TGrains2.ar(2, clk, 10, 1.0, LFNoise2.kr(0.5).range(0, BufDur.kr(b)), dur, 0, TRand.kr(0.1, 0.2, clk), MouseX.kr(0.003, 0.01), 0.007, 4);
}.play;
)



{ LFPulse.ar(100) }.plot(4/100)
{ LFPulse.ar(100, 0, MouseX.kr(0,1)) ! 2 * 0.1 }.play


- lasagnes
- spaget
- pizza
- viande comme hier raté + riz

- oeuf + patate
- omelette + patate



(
x = Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, inf,
	\amp, 0.1
);
)

~s = x.asStream;
~e = ~s.next(Event.default).play;
~e.release
~e
EventPlayer
Event



flopTogether(34, [1,2])

Ndef

12.midiratio
{ ( 400 * ( LFNoise0.kr(1).poll * 12 ).midiratio ).poll }.play
400 * ( 1 * 12 * 1).midiratio

(
//you must have run this code before any of the examples below
f= BBCutBuffer(Platform.resourceDir +/+ "sounds/break.aiff",8);

TempoClock.default.tempo_(2.4);
)

(   //default index function (free random choice)

BBCut2(CutBuf2(f),MotifCutProc.new(
[           //array of Motifs
[[1/2],[1/8]], //first Motif
]
)).play;

)



TempoClock.default.tempo = 2
(   //defaults
var sf;

Routine.run({
sf= BBCutBuffer(Platform.resourceDir +/+ "sounds/break2.aiff",4);

s.sync;

//3.33bps= 200 bpm
BBCut2(CutBuf2(sf),SQPusher2.new).play(TempoClock.default);

});
)

Quarks.install("BBCut")
Quarks.install("https://github.com/snappizz/BBCut")



(
var sf;

Routine.run({

sf= BBCutBuffer(Platform.resourceDir +/+ "sounds/break.aiff", 8);

s.sync; //this forces a wait for the Buffer to load

BBCut2(CutBuf2(sf, 0), ChooseBlockProc(16, 32), BBCutQuantise1(1/8)).play(1.6);
});

)

f= BBCutBuffer(Platform.resourceDir +/+ "sounds/break.aiff", 8);

(   //init settings
~plength= 1;
~subfunc= {[8, 16].choose};
~permfunc= {|i| i%7%3};
~stutfunc= {|i| i%8};
)

a= BBCut2(CutBuf2(f), BBCPPermute(~plength, {~subfunc.value}, {|i, n| ~permfunc.value(i, n)}, {|i| ~stutfunc.value(i)})).play(2.3)

(
~cnt= 0;
~subfunc= {~cnt= ~cnt+1; [4, 8][(~cnt%8).div(7)]};
~permfunc= {|i| i%7%5};
~stutfunc= {|i| i%5};
)

(
~plength= 4;
~subfunc= {1.rrand(8)};
~permfunc= {|i, n| (8%n/(i+1)).asInteger};
~stutfunc= {|i| i|4};
)

(
~plength= 1;
~subfunc= 20;
~permfunc= {|i, n| [n-i, n][i.div(6)%2]};
~stutfunc= {|i| [i, 0].wchoose([0.97, 0.03])};
)

(
//wait for it to grow
~cnt= 0;
~plength= 8;
~subfunc= 4;
~permfunc= {|i, n| i};
~stutfunc= {|i| ~cnt= ~cnt+1; ~cnt+i%(~cnt.div(64)+2)};
)

a.end


f= BBCutBuffer(Platform.resourceDir +/+ "sounds/break.aiff", 8);

(   //init settings
~blockfunc= 1;
~cutfunc= 24;
~bpsd= {|i| i%8/4};
)

a= BBCut2(CutBuf2(f), ChooseBlockProc({|left, len| ~blockfunc.value(left, len)}, {|len| ~cutfunc.value(len)}, {|i| ~bpsd.value(i)})).play(2.4);

(
~blockfunc= 4;
)

(
~cutfunc= {2.rrand(12)};
~bpsd= {|i| i%4/4};
)

(
~blockfunc= {[2, 3].wchoose([0.9, 0.1])};
~cutfunc= {|len| 1+len};
~bpsd= {|i| [3, 1, 3, 1, 3, 1, 4].wrapAt(i)};
)

(   //practice the drums
~cnt= 1;
~blockfunc= 1;
~cutfunc= {~cnt};
~bpsd= {|i| ~cnt= i%8+1; ~cnt.div(2)+1}
)

(
~blockfunc= {[2, 4, 8][~cnt%3]};
~bpsd= {|i| ~cnt= ~cnt+i%8+1; 4.div(~cnt)+1}
)

a.end



(
var sf, clock;

clock= ExternalClock(TempoClock(2.5));

clock.play;

Routine.run({

sf= BBCutBuffer(Platform.resourceDir +/+ "sounds/break.aiff",8);

s.sync; //this forces a wait for the Buffer to load

BBCut2(CutBuf1(sf), BBCutProc11.new).play(clock);
});

)


(
~a_function = { arg item;
	item.debug("value of item");
	~a_var = 4;
	item.debug("value after assign of item");
};
~a_var = 10;
~a_var.debug("value before function");
~a_function.value(~a_var);
~a_var.debug("value after end of function");
)


(
~a_function = { arg item;
	item.debug("value of item");
	item = 4;
	item.debug("value after assign of item");
};
~a_var = 10;
~a_var.debug("value before function");
~a_function.value(~a_var);
~a_var.debug("value after end of function");
)


O
(
c =[[]];
10.do {
    c.collect { |item i|
        item.debug(\item_before_add_ ++ i);
        c[i] = item.add([0,1].choose).debug("arr");
        item.debug(\item_after_add_ ++ i);
        item;
    };
}
)


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(100 * 100 * XLine.kr(0.001,40,10));
	sig = sig + SinOsc.ar(200);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

100 * 100 

(
SynthDef("AM", { arg freq = 440, modfreq = 5, amp = 0.5, attack = 0.01, decay = 0.3, release = 0.1, pos = 0, gate = 1, phaserfreq = 0, phaserdepth = 0.3;
       var phaser, carrier, modulator, env;
       phaser = SinOsc.ar(freq: phaserfreq, mul: phaserdepth*modfreq, add: modfreq);
       modulator = SinOsc.ar(phaser).range(0, 1);
       carrier = SinOsc.ar(freq: freq, mul: modulator);
       env = Env.adsr(
       attackTime: attack,
       decayTime: decay,
       sustainLevel: 0.8,
       releaseTime: release).kr(doneAction: 2, gate: gate);
       carrier = carrier * env * amp;
       Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
 Pdef(\am, Pbind(
      \instrument, "AM",
      \dur, 1/1 * Pseq([1,1/2,1/4,Pn(1/8,8)],inf).stutter(8),
      \degree, Pseq([0,3,5,7,5,3], inf),
      \ctranspose,Pseq([Pseq([0],24),Pseq([3],24),Pseq([5],24)],inf),
      \modfreq,  Pwhite(100,7200.0), // try higher numbers here
      \pmindex, Pwhite(2, 13),
      \amp, 0.3,
      \attack, 1,
      \release, Pwhite(0.1, 0.3),
      \pos,Pseq([Pseq([1],8),Pseq([1],8),Pseq([1],8),Pseq([1],8)],inf),
)).play;
)


(
SynthDef(\bass, { arg freq = 440, amp = 0.5, gate = 1;
	var snd, env, oscfreq, output;
	var lfo;
	oscfreq = {freq * LFNoise2.kr(Rand(0.0001,0.5)).range(0.98, 1.02)}!13;
	lfo = { SinOsc.kr({ 1/Rand(2,52) }!13) };
	env = Env.adsr(0.07, 1, 0.9, 0.1).kr(doneAction:2, gate: gate);
	output = LFSaw.ar(oscfreq, mul: lfo.value.range(0,1));
	output = RLPF.ar(output, (env*freq) + 1*freq * lfo.value.range(1/4,2), lfo.value.range(0.1,1));
	output = Splay.ar(output, lfo.value.range(0,1));
	output = output * env * amp;
	Out.ar(0, output);
	}).add;
)

Pdef(\bass, Pbind(
	\instrument, \bass,
	\tempo, 113/60,
	\ctranspose, -26,
	\degree, Pseq([Pseq([3, 5, 1, 3, 5, 8, 1], 2), Pseq([3, 2, 5, -1], 1), Pseq([3, 2, 5, 0], 1), Pseq([1, 5, 0,1,2,5,4], 2), Pseq([1, 0,2],2), 3],inf),
	\dur, Pseq([Pseq([8, 4, 4, 8, 4, 2, 2], 2), Pseq([8,4,2, 2], 2),Pseq([8, 4, 4, 8, 4, 2, 2], 2), Pseq([8, 4, 4], 2), 16], inf),
	\legato, 1.0,
	\amp, 0.6,
)).play;

Pdef(\bass, Pmono(\bass,
	\tempo, 113/60,
	\ctranspose, -26,
	\degree, Pseq([Pseq([3, 5, 1, 3, 5, 8, 1], 2), Pseq([3, 2, 5, -1], 1), Pseq([3, 2, 5, 0], 1), Pseq([1, 5, 0,1,2,5,4], 2), Pseq([1, 0,2],2), 3],inf),
	\dur, Pseq([Pseq([8, 4, 4, 8, 4, 2, 2], 2), Pseq([8,4,2, 2], 2),Pseq([8, 4, 4, 8, 4, 2, 2], 2), Pseq([8, 4, 4], 2), 16], inf),
	\legato, 1.0,
	\amp, 0.6,
)).play;


(
// parametric filling algorithm,
n = 100 ; // just use a square
~matrix = Array.fill(n, {|i|
Array.fill(n, {|j|
if (j <= i){1}{-1};
}).postln
}).collect{|i, j| if (j%2==1){i.neg}{i}}
)

(
// plot func
p = 60 ; // plot step
w = Window("alternando", Rect(100, 100, (p+1)*n.sqrt, (p+1)*n.sqrt)).front ;

~uv = Array.fill(n, {|i|
var col = i%n.sqrt *(p+1);
var row = (i/n.sqrt).trunc *(p+1);
UserView(w, Rect(col, row, p, p)).background_(Color.rand)
.drawFunc_{
~matrix[i].do{|k, j|
var x = j%n.sqrt *(p/n.sqrt);
var y = (j/n.sqrt).trunc *(p/n.sqrt);
Pen.fillColor = if (k == -1){Color.black}{Color.white};
Pen.strokeColor = Color.black ;
Pen.addRect(Rect(x, y, p/n.sqrt, p/n.sqrt)) ;
Pen.fillStroke
}
}

})
)
// here you do operations on matrix, i.e. the placing algorithm
~matrix = ~matrix.collect{|i| i.scramble} // simple scrambling
w.refresh // and refresh


Veco.

Main.version
a = MIDIOut(0)
a.noteOn(0,6, 0x0f)
(
var n = 2, baseFreq = 45.midicps;
var lsin, rsin, arg1, arg2, sig;
var bus, busIndex, scale, freq, freqIndex, amp;
var responder;

scale = Scale.nikriz.ratios * baseFreq;

bus = Bus.control( s, 2 * n  );
bus.setn( { 1.0.rand2 } ! ( 2 * n ) );
busIndex = bus.index;

freq = Bus.control( s, n );
freqIndex = freq.index;

responder = OSCFunc({ | id |
	freq.setAt( id[2] , scale.choose * 1.rrand( 3 ) );
},'/tr', s.addr);

CmdPeriod.doOnce { [ bus, freq, responder ].free; };

n.do {|i|
	freq.setn( { scale.choose  * rrand( 1, 3) } ! n );
	{
		#arg1, arg2 = In.kr( 2 * i +  busIndex, 2 );

		#lsin, rsin = SinOsc.kr( [ arg1, arg2 ], { 2.0.rrand(20.0) } ! 2  * [ arg2, arg1 ] ); 

		sig = Formant.ar( 
			LFNoise0.kr( 0.05, 2.5, 7) * arg1, 
			arg2,
			500.0.rrand(700) 
		);

		ReplaceOut.kr( 2 * i  + busIndex, [ rsin, lsin ] );

		sig = Pluck.ar( 
			BrownNoise.ar(0.5), 
			sig, 
			0.025, 
			freq.kr( 1, i ).reciprocal, 
			3.7
		) * 0.6;

		amp = Line.kr( dur: rrand( 1.0, 20.0) ) * max( 0, LFNoise1.kr( 0.05, 0.6, 0.4 ) ) ;
		sig =  sig * amp;
		SendTrig.kr( amp <= 0, i, i );

		Pan2.ar( sig, 0.8.rand2 )
	}.play
}
)

(

SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, t_trig=1,
		arg1=100, arg2=200, decay=0.01, flag=0.1, pluckdecay=3.1;
	var sig;
	sig = Formant.ar( 
		LFNoise0.kr( 0.05, 2.5, 7) * arg1, 
		arg2,
		500.0.rrand(700) 
	) * Trig.kr(t_trig, decay);


	sig = Pluck.ar( 
		BrownNoise.ar(0.5), 
		sig, 
		0.025, 
		freq.reciprocal.lag(flag), 
		pluckdecay
	) * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.4,0.1,0.8,7.1)),t_trig,doneAction:0);
	EnvGen.ar(Env.adsr(0.4,0.1,0.8,7.1),gate,doneAction:2);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

~baseFreq = 220;
~scale = Scale.nikriz.ratios * ~baseFreq;
//~scale = Scale.dorian.ratios * ~baseFreq;
//~scale = Scale.minor.ratios * ~baseFreq;

8.do { arg nn;
	var nnn = nn+1;

Pdef(\plop+++nn, Pmono(
	//\instrument, \plop,
	\plop,
	\arg1, 100,
	\arg2, Pwhite(40,4000),
	\arg2, 3000,
	\decay, Pwhite(0.01,0.1),
	\decay, 0.01*nnn,
	\decay, 0.1/nnn,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,3.3) ],
	],inf), 
	\freq, Pwhite(100,1500),
	\freq, Prand([100,1500,200,500,100],inf) * 0.7,
	\freq, Prand([100,1500,200,500,100],inf) * 1,
	\freq, Prand([100,1000,200,500,300,1000],inf) * 1,
	\freq, Pseq([100,1500,200,500,2000,100,250],inf),
	\freq, Pseq([
		100,1500,200,500,
	],inf),
	\freq, Pseq([
		100,1500,200,500,
		100,1500,200,500,
		100,1500,200,500,
		1000,100,1000,
	],inf) * Pseq([1.7,0.2,0.7,0.5],inf) * 1.0,
	\freq, Pseq([
		90,250,470,
		110,150,270,

		90,150,270,
		110,750,270,
	],inf) * Pseq([
		3,1,4,1.5,
		6,4,0.8,1.5,
	],inf) * Pseq([1,0.8,0.5,1.2],inf).stutter(32),
	\freq, Pseq([
		//Pser([100,1000],16),
		//Pser([100,2000],16),
		//Pser([200,1000*nnn],16),
		Pser([200,100]*nnn,16),
		Pser([200,400]*nnn,16),
		Pser([20,40]*nnn,16),
		//100*nnn
	],inf),
	\freq, Pseq([
		//200*log(nnn+1)
		Pser([Pfuncn({~scale.foldAt(nn)},1)],inf) * Pseq([1,2,1/6],1).stutter(16),

		Pser([200,100]*nnn,16),
		Pser([200,400]*nnn,16),
		Pser([20,40]*nnn,16),

		Pser([log(nnn+7)*200],32),
	],inf),
	\flag, Pseq([
		Prand([

		//Pser([1,0.1,1,0.1],16),
		//Pser([1,0.1,1,0.1]/2+0.3,16),
		0.05*nnn,
		0.1,
		//0.7*nnn,
		],inf)
		//Pser([1.12],16),
		//Pser([0.08],16),

	],inf),
	\lag, Pseg(Pseq([0,0.31],inf), 8)*nn,
	\arg2, Pkey(\freq),
	\arg1, Pkey(\freq),
	\sustain, 0.4,
	\dur, Pwhite(0.1,0.4) * 0.8,
	\dur, Pseq([0.5,1,1,0.5],inf) * 0.2,
	\dur, Pseq([0.5,1,1,0.5],inf) * Pseg(Pseq([3,0.2,0.1],inf), 16),
	\amp, min(1,Pkey(\dur)*3) * 1.7
)).play;

}
)

log(2)

MIDIClient.init
MIDIClient.restart
MIDIClient.sources
NdefGui
VecoLib.load_lib
Veco.force_init

//load the Synth

(
k = ControlSpec(5, -128, \lin);
e = ControlSpec(0.01, 0.5, \exp);
p = ControlSpec(65536, 0.25, \exp);
c = ControlSpec(-23, 0, \lin);
h = ControlSpec(1/2, 2/1, \exp);

SynthDef(\Motorklang, {arg speed=0.0, time=0.0, rpm=0.0, t_tr=1;
	var sig, speedch, rpmch;
		speedch = EnvGen.kr(Env([0, speed], [time]), t_tr);
		rpmch = EnvGen.kr(Env([0, h.map(rpm/6000);], [time]), t_tr);
		sig = Mix.fill(8, {arg i;
			var freq, aspeed, env, curve1, curve2, phase;
			curve1 = k.map(speedch).max(1);
			aspeed = p.map(speedch/75) * curve1;
			env = e.map(speedch/75);
			curve2 = c.map(speedch/75);
			freq = 300 + (i/4);
			phase = i/8;
			Mix.fill(32, {arg i;
				var freqsq;
				freqsq = ((((i+1)*freq).cpsmidi*rpmch) - (freq.cpsmidi*rpmch-freq.cpsmidi)).midicps.min(22050);
				SinOsc.ar(freqsq, 0, 0.1/(i+1))
				*
				EnvGen.ar(Env.perc(env, 1-env, 1, curve2),
					Impulse.ar(freq*(1+i)/aspeed, phase), timeScale: 1/(freq*(1+i)/aspeed));
				});
			});
		Out.ar(0, Mix.new(sig) ! 2);
	}).load(s);
)

//Test it
(
x = Synth(\Motorklang);
x.set(\speed, 40, \rpm, 3000, \time, 0, \t_tr, 1);
)
x.free

//A simple interface to check the sound limits of the engine

(
x = Synth.newPaused(\Motorklang);
w = Window.new("Motor", Rect(150, 266, 950, 300)).front;
q = StaticText(w, Rect(835, 20, 100, 100));
y = StaticText(w, Rect(838, 140, 100, 100));
q.string = "km/h";
y.string = "rpm";
c = NumberBox(w, Rect(830, 90, 40, 20));
n = NumberBox(w, Rect(830, 210, 40, 20));
b = ControlSpec(0, 75, \linear, 0.1);
m = ControlSpec(0, 6000, \linear, 1);
a = Slider(w, Rect(50, 75, 700, 50)).value_(0).action_({
		x.run.set(\speed, b.map(a.value), \t_tr, 1);
		c.string_(b.map(a.value).asString)});
d = Slider(w, Rect(50, 200, 700, 50)).value_(0).action_({
		x.run.set(\rpm, m.map(d.value), \t_tr, 1);
		n.string_(m.map(d.value).asString)});
c.value = 0;
n.value = 0;
)

(

// a slightly modified version of the excellent example patch by James Harkins.

// I added some grid lines for the samples, an adjustable sampling rate, and changed some colors.

// Jascha Narveson



var screen = Window.screenBounds,

	height = (screen.height - 120).asInteger,

	width = (screen.width - 120).asInteger,

win = Window(\aliasing, Rect.aboutPoint(screen.center, width / 2, height / 2 + 60)).background_(Color.white),

	sinPts = 400, sampPts = 20, sr,

	freq = 1, fsl,

	sinColor = Color.red, sampColor = Color.blue, lineColor = Color.grey;



win.drawHook = {

	var pt;

	pt = Point(0, height/2);

	Pen.color_(sampColor)

		.moveTo(pt);

	(1..sampPts).do { |x|

		Pen.moveTo(pt);

		pt = Point(x * (width / sampPts), sin(x * freq / sampPts * 2pi).linlin(-1, 1, height, 0));

		Pen.lineTo(pt).stroke

			.fillRect(Rect.aboutPoint(pt, 3, 3));

	};



	Pen.color_(sinColor)

		.moveTo(Point(0, height/2));

	(1..sinPts).do { |x|

		Pen.lineTo(Point(

			x * (width / sinPts),

			sin(x * freq / sinPts * 2pi).linlin(-1, 1, height, 0)

		));

	};



	Pen.stroke;



	Pen.color_(lineColor);

	(1..sinPts).do({|x|

		var xpos = x * (width / sampPts);

		Pen.moveTo(Point(xpos, 0));

		Pen.lineTo(Point(xpos, height));

		Pen.stroke;

	});



};



fsl = EZSlider(

	win,

	Rect(5, height + 10, width-10, 20),

	"freq of input wave (red):",

	ControlSpec(1, 40, 'lin', 0, 20),

	{|slider| freq = slider.value; win.refresh },

	1,

	labelWidth: 200,

	initAction: true

);



sr = EZSlider(

	win,

	Rect(5, height + 30, width-10, 20),

	"samp rate (output wave in blue):",

	ControlSpec(1, 44, 'lin', 1, 20),

	{|slider| sampPts = slider.value; win.refresh },

	1,

	labelWidth: 200,

	initAction: true

);

win.front;

)
(
var screen = Window.screenBounds,
	height = (screen.height * 0.8).asInteger,
	width = (screen.width * 0.8).asInteger,
	win = Window(\aliasing, Rect.aboutPoint(screen.center, width / 2, height / 2 + 20)),
	sinPts = 400, sampPts = 20,
	freq = 1, fsl,
	sinColor = Color.red, sampColor = Color.black;

win.drawHook = {
	var pt;
	pt = Point(0, height/2);
	Pen.color_(sampColor)
		.moveTo(pt);
	(1..sampPts).do { |x|
		Pen.moveTo(pt);
		pt = Point(x * (width / sampPts), sin(x * freq / sampPts * 2pi).linlin(-1, 1, height, 0));
		Pen.lineTo(pt).stroke
			.fillRect(Rect.aboutPoint(pt, 3, 3));		
	};

	Pen.color_(sinColor)
		.moveTo(Point(0, height/2));
	(1..sinPts).do { |x|
		Pen.lineTo(Point(
			x * (width / sinPts),
			sin(x * freq / sinPts * 2pi).linlin(-1, 1, height, 0)
		));
	};
	Pen.stroke;
};

fsl = EZSlider(win, Rect(5, height+10, width-10, 20), "freq:", [1, 20], { |view| freq = view.value; win.refresh }, 1, initAction: true);

win.front;
)


MIDIIn.connectAll;
MIDIOut.connectAll;
MIDIClient.sources;
MIDIIn.findPort ("Launchpad")
~launchpad_device_id = MIDIIn.findPort ("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1").uid
~icon_device_id = MIDIIn.findPort ("iCON iControls V2.00-iCON iControls V2.00 MIDI 1", "iCON iControls V2.00-iCON iControls V2.00 MIDI 1").uid
MIDIClient.destinations;
~launchpad_in_device_endpoint = MIDIEndPoint("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1")
MIDIOut(0).connect( MIDIClient.destinations.detectIndex { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" } ) // good

VecoLib.load_lib
Veco.force_init



MIDIClient.list
MIDIIn.connect(0, ~launchpad_device_id)
MIDIIn.connect(0, ~icon_device_id)
MIDIOut.connect(~launchpad_in_device_id, 0)
MIDIIn.connect( ~launchpad_in_device_id, 0)
MIDIOut(0).connect(), MIDIClient.destinations.detect { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" }.uid ).connect
MIDIOut(0, 10).connect
MIDIOut.newByName("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1").connect(2)
MIDIOut(0,~launchpad_in_device_endpoint.uid)
MIDIClient.destinations.detect { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" }.uid

1
kkkjkk

(

q = q ? ();


q.numChans = 2; 


// add a sound source

ProxyChain.add(

\dust, \mix -> { |dens=20, dustdec=0.02, dustfreq= 600| 

Ringz.ar(Dust.ar(dens).lag(0.0001), dustfreq, dustdec)  ! 2

}

);


// an association with \filter becomes a filter,

// and creates a wet/dry balance on the output.

// several funcs can be added as key1, func1, key2, type -> func2, etc.

ProxyChain.add(	

\ringmod, \filter -> { |in, randrate=5| 

//in.asArray[0] // force mono inputs
in

* SinOsc.ar(LFNoise0.kr([randrate, randrate]).exprange(300, 3000)).sum 

}, 

\dist, \filter -> { |in, drive=10, amp=0.2| 
	//(in.asArray[0]
	(in
	* drive).clip2(0.5) * amp }

);

// an association with \filterIn also becomes a filter,

// but creates the wet/dry balance control on the filter input, 

// on on the output like \filter. this can be useful for delays, reverbs etc.

ProxyChain.add(

\riseComb5, \filterIn -> { arg in, delay = 0.023, dlDrift = 0.02, spread=0.5, mypan=0, 

decayRise=0.5, decayFall=100;

var delayscales = 2 ** ((0 .. q.numChans - 1) * 2 / (q.numChans - 1) - 1 * spread); 

var dels = delayscales.scramble.collect { |dscale| 

var timedrift = LFDNoise3.kr(0.3, dlDrift, 1) * dscale;

var ampcomp = (20 * decayRise).dbamp * (decayFall ** -0.25);

var combs; 

in = in.asArray[0] * ampcomp.lag(0.2);

combs = (decayFall * [ 1, decayRise]).collect { |decay| 

CombL.ar(in, 1, delay * dscale, decay * delay) 

};

combs[0] - combs[1];	// combs come in slowly, like formlet. 

};

Splay.ar(dels, 1,1,mypan);

}, 

\ampFin, \filter -> { |in, drive=1, ampLimit=1, lAmp=1| 

Limiter.ar(in * drive, ampLimit) * lAmp;

}

);


// add specs for the controls used (for NodeProxyEditor).

Spec.add(\dens, [0.1, 1000, \exp]);

Spec.add(\dustamp, [0, 1, \amp]);

Spec.add(\dustdec, [0.0001, 0.1, \exp]); 

Spec.add(\dustfreq, \freq); 


Spec.add(\dt, [0.001, 0.2, \exp]); 

Spec.add(\dc, [0.01, 100, \exp]); 


Spec.add(\drive, [1, 100, \exp]); 


Spec.add(\spread, [0, 1, \amp]); 

Spec.add(\decayRise, [0, 0.9, \amp]); 

Spec.add(\decayFall, [1, 1000, \exp]); 

Spec.add(\dlDrift, [0, 0.1, \amp]); 
Spec.add(\mypan, \bipolar.asSpec); 


s.boot;

)

// the functions can be sources (func, \mix -> func) 

// or	 filters (\filter -> func, \filterIn -> func)

(

	c = ProxyChain(\alpha2, [\dust, \ringmod, \dist, \riseComb5, \test]);

	c.play;// play the proxy

	g = c.gui(22);		// make a gui for it with 12 slots - see ProxyChainGui


)

ProxyChain(\alpha2).proxy.set(\delay, 1)


// these methods are passed through to the proxy:

c.play;

c.stop;

c.playN;

c.end(2);



*from(proxy, slotNames)make a proxychain from an existing N	odeProxy or Ndef.

Ndef(\bla).ar(2);

ProxyChain.from(Ndef(\bla), [\dust, \ringmod, \dist, \riseComb5, \test]);

ProxyChain(\bla).play;

ProxyChain(\bla).add(\dust);


ProxyChain.all;


add(key, wet)add a sou	nd or filter function, wet is dry/wet balance


c.add(\dust, 0.123);

c.add(\dust, 0.2);

c.add(\ringmod, 0.5);

c.add(\dist, 1);



// the automatically generated mix/wet balance names are

// "mix" for sources and "wet" for filters, with an added 

// index of 10, 20, 30, etc. 


ProxyChain(\xyz, [

	\dust, // the first node is a source, so "mix", and here: "mix10",

	\ringmod, // filters become "wet", so here, "wet20"

	\dist// and "wet30";


]);



c.proxy.fadeTime = 	2;

c.add(\riseComb5, 0.2);// \filterIn not show correctly in NodeProx	yEditor yet.


// add a local version of a source -

// this overrides the global version of \dust.

(

	c.add(\dust, nil, \mix -> { |dens=20, dustdec=0.02, dustfreq= 600| 
	
	Ringz.ar(Dust.ar(dens).lag(0.0001), dustfreq * [0.62, 1, 1.62], dustdec).mean 

});


)

c.sources.postcs;

c.sources.put(\dust, nil);// back to global dust

c.add(\dust);

c.sources.postcs;


remove(ke	y)remove a sound or filter function.

c.remove(\dist);// nodemap remo		ves settings as well, so ...

c.remove(\ringmod);

c.remove(\riseComb5);// sometimes misses current value - why?


c.slotNames;// all slotnames t		hat are available, in the order they are in;

c.slotsInUse;// which on	es are playing now?


c.remove(\dust);



gui(name, buttonList, nSliders)

make a ProxyChainGui window for controlling the slots, and possible additional functions.


// by default, buttonList nil is replaced with control buttons for all slots.

c.gui(20);


// if specified, can be friendlier

(

	g = c.gui(20,
	
	[ 
	
	[ \generators, 	\label  ],  // a label only

[ \dust, \slotCtl, 0.25  ], // a control for a slot, starting level


[ '1 > 1', \label  ],  

[ \ringmod, \slotCtl  ], // 0 - dry  by default

[ \dist, \slotCtl, 1  ], // 1 - all wet


[ '1 > 5', \label  ],  

[ \riseComb5, \slotCtl  ], 

[  ],

// extras:

// e.g. an editor with more space for controls

[\phatEdit, \extra, { c.makeEdit('Test', 40)  } ],

// or maybe bigger buttons play, end buttons

[\play, \extra, { c.playN  } ], 	

[\end, \extra, { c.end(2, true)  } ],

]

)


)






60/4.0
(

	Spec.add(\dens, [1, 1000, \exp]);

	Spec.add(\ring, [0.0001, 100, \exp]);


	a = Ndef(\a, { |freq=300, dens=10, ring = 0.03, amp= 0.25| 
	
	Ringz.ar(Dust.ar(dens ! 2, (1/dens.max(1)).sqrt * amp), (freq * [1.01, 0.99]).lag(0.2), ring) 

}).play;


// make a preset for Ndef(\a)

// - stored by the Ndef's name in NdefPreset.all

z = NdefPreset(Ndef(\a));


w = Window("NdefPreset test", Rect(200, 200, 420, 250)).front;

w.addFlowLayout;

// a gui for the NdefPreset

g = ProxyPresetGui(z, parent: w);

// and one for the Ndef

b = NdefGui(a, 8, parent: w);


)

//create buffer. I want the equation z = 2*(((x/100)**2) + ((abs(sin(10*y))/50)**(1/3)))-1
//over a 100 by 50 area

//2d to 1d conversion follows index= y*rowlength+ x
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

2*(((x)**2) + ((abs(sin(10*y)))**(1/3)))-1

});


b.sendCollection(a, 1);
)
b=Buffer.sendCollection(s, a, 1);


//test scanning; you can't move fast enough... scan controls should also be audio rate!
{WaveTerrain.ar(b.bufnum,MouseX.kr(0.0,1.0), MouseY.kr(0.0,1.0),100,50) ! 2}.play

(
Ndef(\wt, {
	WaveTerrain.ar(b.bufnum,LFSaw.ar(MouseX.kr(0.0,200.0)).abs, SinOsc.ar(MouseY.kr(0.0,100.0)).abs,100,50) ! 2
}).play

)

(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	pos1 = MouseY.kr(1,120);
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50) ! 2;
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);
}).play

)

(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	pos1 = MouseY.kr(1,120);
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50) ! 2;
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);
}).play

)


(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	var chain;
	pos1 = MouseY.kr(1,120);
	pos1 = 100;
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50);
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);

	    chain = FFT(LocalBuf(2048), sig);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		sig = 0.8 * IFFT(chain);


		sig = Squiz.ar(sig, MouseX.kr(1, 10, 1), zcperchunk: MouseY.kr(1, 10), mul:0.1);

		sig = sig ! 2;
		sig;
}).play

)


{var n= 1024; WaveletDaub.ar(Saw.ar(MouseY.kr(50,10000, 'exponential'),0.5), n, MouseX.kr(0,n)) ! 2}.play

BufDef(\moeten, "voices/02_moeten.flac");
(
	Ndef(\rah, {var n= 1024; 
		var sig;
		var chain;
		var posy = MouseX.kr(0.1,2);

		//sig = PlayBuf.ar(2, BufDef(\moeten), 1, loop:1);
		sig = PlayBuf.ar(2, BufDef(\moeten), MouseX.kr(0.01,3), loop:1);
		//sig = PlayBuf.ar(2, BufDef(\moeten),  SinOsc.kr(10*posy).range(0.1,2.7), loop:1);
		//sig = SinOsc.ar(200);
		//sig = WaveletDaub.ar(sig, n, MouseX.kr(0,n));
		chain = FFT(LocalBuf(2048), sig);
		//chain = PV_PhaseShift(chain, MouseX.kr(0,360));
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_MagBelow(chain, MouseX.kr(0,60));
		//chain = PV_MagAbove(chain, MouseX.kr(0,60));
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		//chain = PV_PhaseShift(chain, LFNoise2.kr(1, 180, 180));
		sig = IFFT(chain);

		sig ! 2;
	}).play
)

(
	//trig with MouseY
	SynthDef("help-magFreeze2", { arg out=0, soundBufnum=2;
	    var in, chain;
	    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	    chain = FFT(LocalBuf(2048), in);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
	    Out.ar(out, 0.1 * IFFT(chain).dup);
	}).play(s,[\soundBufnum, b]);

)


//LFNoise adds some drift to explore the landscape more
{WaveTerrain.ar(b.bufnum,SinOsc.ar(MouseX.kr(1,200,'exponential')).abs + LFNoise2.ar(2),SinOsc.ar(MouseY.kr(1,300,'exponential'),pi*0.5).abs,100,50) ! 2}.play





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((cos(5*x+1.7))**3) - ((abs(sin(23*y)))**(1/3)))

});

b.sendCollection(a);
)





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((1.3*(cos(rrand(1,2)*x+1.7))**2) - ((abs(sin(rrand(1.2,4.9)*y)))**(1/2)))).max(-1.0).min(1.0)

});

b.sendCollection(a);
)


s.quit

{ Formlet.ar(Impulse.ar(20, 0.5), 1000, 0.01, 0.1) }.play;

{ Formlet.ar(Blip.ar(XLine.kr(10,400,8), 1000, 0.1), 1000, 0.01, 0.1) ! 2 }.play;

(
// modulating formant frequency
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in, XLine.kr(1500,700,8), 0.005, 0.04) ! 2;
}.play;
)

(
// mouse control of frequency and decay time.
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1) ! 2;
    Formlet.ar(in,
        MouseY.kr(700,2000,1),
        0.005, MouseX.kr(0.01,0.2,1));
}.play;
)

(
// mouse control of frequency and decay time.
{
    var freq;
    freq = Formlet.kr(
        Dust.kr(10 ! 2),
        MouseY.kr(7,200,1),
        0.005, MouseX.kr(0.1,2,1)
    );
    SinOsc.ar(freq * 200 + [500, 600] - 100) * 0.2 ! 2
}.play;
)

(
SynthDef(\fatsaw,
	{
		arg freq=440, amp=0.3, fat=0.0033, ffreq=2000, atk=0.001, dec=0.3, sus=0.5, rls=0.1,gate=1;

		var f1,f2,f3,f4,synth;

		f1=freq-(freq*fat);
		f2=freq-(freq*fat/2);
		f3=freq+(freq*fat/2);
		f4=freq+(freq*fat);

		synth = LFSaw.ar([f1,f2,f3,f4],[0,0.001,0.002,0.004,0.008]);
		synth = synth * EnvGen.kr(Env([0,1,sus,0],[atk,dec,rls],'lin',2),gate,doneAction:0);
		synth=Splay.ar(synth,0.7);
		synth=RLPF.ar(synth,ffreq*Linen.kr(gate,0.1,0.4,0.2,0),0.4);
		Out.ar(0,synth*amp);
},[0.1,0.3,4,2]).add;
)
(
TempoClock.default = TempoClock.new(2);
fork{

	z = Synth(\fatsaw,[\gate,0,\ffreq,500,\fat,0.5]);

	a=Pseq([0,7,12,5],inf).asStream; // musical degrees
	c = Pseq([40,38,45,47],inf).asStream; // root midi notes
	e = Pseq([0.825,0.375,0.25,0.25],inf).asStream; // note durations
	f = Pseq([1000,1500,2000,2500],inf).asStream; // filter freq value

	0.1.wait;
	z.set(\gate,1);

	//set first root note
	d = c.next;

	8.do{

		// move filter freq once every 4 notes
		z.set(\ffreq, f.next);
		4.do {
			z.set(\gate,1);
			z.set(\freq,(a.next + d).midicps);
			x=[0.451,0.45,0.449].choose;
			x.wait;
			z.set(\gate,0);

			e.next.wait;
		};

		d = c.next;
	};
	2.wait;
	z.free;
};
)



/* 140103_1504 (pluck piece)



by Nathan Thomas

http://www.afternoondust.co.uk



This piece uses code from Bruno Ruviaro (pluck pattern), published on SCCode.org: 

http://sccode.org/1-4Vn



Don't forget to update the path to the audio sample on line 26.



Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License:

http://creativecommons.org/licenses/by-nc-sa/3.0/



*/



(

Server.default = s = Server.internal;

s.options.memSize = 655360;

s.options.sampleRate = 96000.000;

s.options.blockSize = 128;

)



s.boot;



c = Buffer.read(s, "insert/path/to/file/here/leaves_twigs_decode_004_edit.wav");



(

   SynthDef("playamp", { arg krBus;

       var sig, amp, trig, thresh;

       thresh = MouseX.kr((-15),(-60));

       sig = PlayBuf.ar(2,c,0.99,loop:inf);

       amp = Amplitude.kr(sig).ampdb;

       trig = amp >= thresh;

       Out.kr(krBus,trig);

    }).add;



   SynthDef("plucking", {arg amp = 1, freq = 440, decay = 5, coef = 0.1, krBus, outBus=0;

        var env, snd;

        env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);

        snd = Pluck.ar(

            in: Mix.new([WhiteNoise.ar(amp), SinOsc.ar(freq,0,amp)]),

            trig: Gate.ar(Impulse.ar(1),In.kr(krBus,1)),

            maxdelaytime: 0.1,

            delaytime: freq.reciprocal,

            decaytime: decay,

            coef: coef,

            mul: amp);

            Out.ar(outBus, [snd, snd]);

    }).add;



    SynthDef("playbuf", { arg outBus=0;

        var play;

        play = PlayBuf.ar(2,c,loop:inf);

        Out.ar(outBus,play);

    }).add;



    SynthDef("bass", {arg amp = 1, freq = 220, decay = 1, outBus=0;

        var env, snd, pan, env2, splay, phase;

        env = EnvGen.kr(Env.linen(1, decay, 1,1), doneAction: 2);

        phase = Array.fill(4, { do({ [0, 0.5, 0.7, 1].choose }) });

        snd = SinOsc.ar([freq, freq + phase],[0,phase],amp/4).sum * env;

        splay = Splay.ar(snd,0.4);

        Out.ar(outBus, splay);

    }).add;

)



z = Synth(\bass);



// Groups



(

    ~sources = Group.new;

    ~control = Group.after(~sources);

    ~bus1 = Bus.control(s,1);

    ~bus2 = Bus.audio(s,2);

)





x = Synth(\playamp,[\krBus,~bus1],~control); y = Synth(\playbuf);



// Pluck

(

    var dur;

    dur = Prand([0.2, 0.4, 0.8], inf);



    a = Pbind(

        \instrument, "plucking",

        \krBus, ~bus1,

        \scale, Scale.dorian,

        \degree, Prand([8, 17, 9, 7, 15, 12, 13, 1, 5, 14], inf),

        \coef, dur,

        \dur, dur,

        \amp, Pwhite(0.3, 0.6),

        \decay, 3

   ).play;

)



// bass



(

    b = Task({

    var delta, dur, note; 

    dur = Prand([10, 15], inf).asStream;

    note = Pwrand([145, 290], [0.8,0.2], inf).asStream;



    while {

            delta = dur.next;

            delta.notNil

        } {

            Synth(\bass,[freq: note.next,decay:4]);

            delta.yield;

        }

    }).play(quant:TempoClock.default.beats+1.0);

)





a.stop;

b.stop;

x.free;

y.free;

~sources.free;~effects.free;~bus1.free;



s.boot



//////////////////
// Ducking example
///////////////////

// Compander with
// low threshold (like 0.01)
// slopeBelow: leave at 1 (default)
// slopeAbove: small value (means input signal will be attenuated a LOT when control kicks in)
// clampTime and releaseTime: small (e.g., 0.1)
// but release time can be a bit more


/////////////////////////
// Kick and Low Synth Bass
/////////////////////////

(
Ndef(\plop,{
    var in, snd, control ;
    in = LPF.ar(Saw.ar(90*[0.990,1,1.0001]), 5500);
    control = Ringz.ar(
        in: LPF.ar(
            in: Impulse.ar(MouseY.kr(0,8).round(1)),
            freq: 30),
        freq: 30,
        decaytime: 0.15,
        mul: 7).tanh.sin*2;
    snd = Compander.ar(
        in: in,
        control: control,
        //thresh: 0.01,
        thresh: MouseX.kr(0.001,0.3),
        slopeBelow: 1,
        slopeAbove: 0.1,
        clampTime: 0.01,
        // longer release
        relaxTime: 0.1
    );
    Splay.ar([snd, control, snd])
}).play;
)



(

SynthDef(\aSynth, { |rel = 0, choose = 0, amp = 0|

    var klank, env;



    klank = Klank.ar(`[choose ! 12, {Rand(0.128, 0.7)} ! 12], BrownNoise.ar(0.7));

    env   = EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);

    Out.ar(0, klank * env.dup * amp);

}).add;

)



(

{

    42.do{

        x = [70, 90, 120].choose;

        y = rrand(0.01, 5);

        // attack

        Synth(\aSynth, [\rel, y, \choose, x, \amp, 128e-6]);

        // resonance

        Synth(\aSynth, [\rel, 1, \choose, x, \amp, 128e-5]);

        y.wait;

    }

}.fork;

)


(
	w = Window("test", Rect(800, 200, 200, 100));
	w.layout = HLayout(
		        //n = NumberBox.new.fixedWidth_(60),
		        n = NumberBox.new::,
				        l = Slider.new.orientation_(\horizontal)

	);
	w.front;

)

// This gets the *appearance* I want.
n.fixedHeight = l.bounds.height;



SelectX.ar(keyfollow_amount, [ pitch ], [modulated_parameter])

~amount = 0.5;
~pitch = (0..10)/10;
~param = 0.2;
(~amount * ~pitch) + ((1 - ~amount) * ~param)
~amount = 0.1;

{ LFSaw.ar(100 + [0,0]).sum ! 2 * 0.1 }.play;
{ LFSaw.ar(100 + [0,0.7]).sum ! 2 * 0.1 }.play;

// one octave detuning
{ LFSaw.ar([100,200] + [0,0]).sum ! 2 * 0.1 }.play;
{ LFSaw.ar([100,200] + [0,0.7]).sum ! 2 * 0.1 }.play;

{ LFSaw.ar(100 + [0,0]) }.play;

~x = [\bla, \plop];

~s = Pbindef(~x[0],
 \dur, 0.5
).asCompileString;

"{ % }".format(~s)


p = Pmono(\default, \dur, 0.2, \freq, Pwhite(1,8) * 100 ).play

	SynthDef(\default,{
		arg freq =400,gate=1;
		var env = EnvGen.kr(Env.adsr(0.0,0.1,0.1,0.01),gate,doneAction:2);
		var sig = SinOsc.ar(freq)*env ! 2;
		Out.ar(0,sig);
	}).add


Pbind(\instrument,\default, \dur, 0.2, \freq, Pwhite(1,8.0) * 100 ,\isRest,0).play
Pbind(\instrument,\default, \dur, 0.4, \freq, Pwhite(1,8.0) * 100 ,\isRest,0).play
{ SinOsc.ar(200) ! 2 * 0.1}.play;

(
Pdef(\plop, Ppar([

	Pbind(\instrument,\default, \dur, 0.2, \freq, Pwhite(1,8.0) * 100 ,\isRest,0),
	Pbind(\lag, 0.2.rand, \instrument,\default, \dur, 0.4, \freq, Pwhite(1,8.0) * 100 ,\isRest,0),
	Pbind(\lag, 0.2.rand, \instrument,\default, \dur, 0.6, \freq, Pwhite(1,8.0) * 100 ,\isRest,0),
])).play
)



// For more SynthDefs and examples please head to: https://mycelialcordsblog.wordpress.com/ 

(
	SynthDef(\hasherTest,
		{
			arg rate = 1, freq = 60, index = 1000, tRate = 100,
			out = 0, fRate = 0.1;

			var t_trig = LFPulse.kr(0.5/fRate, 0.5);
			var random = LFNoise0.ar(rate, add:1);
			var noise = Hasher.ar(random);
			var sound = Saw.ar((freq+(noise*index)), Decay.kr(Impulse.kr(tRate), noise*0.001)).tanh;
			sound = Pan2.ar(sound, noise-0.3*2);
			FreeSelf.kr(t_trig);
			//sound = sound * \amp.kr(0.1);
			sound = sound.clip2(\amp.kr(0.1));
			Out.ar(out, sound);

		}).store;

)

(
	Pbind(
		\instrument, \hasherTest,
		\dur, 5,
		\rate, Pfuncn({100.rand}, inf),
		\freq, Pfuncn({10000.rand}, inf),
		\index, Pfuncn({20000.rand}, inf),
		\tRate, Pfuncn({1000.rand}, inf),
		\amp, 0.01,
		\fRate, 5,

	).play;

)








(
var paddlePositions = [0.5,0.5]; // Paddle position from 0 (left) to 1 (right)
var paddleWidths = [100, 100];
var paddleSpeed = 0.005;
var paddleMaxSpeed = 0.02;
var paddleMovements = [0,0];
var friction = 1.15;
var width = 600, height = 700;
var ballPosition = Point(width/2, height/2);
var ballSize = 10;
var ballXMovement = rand2(1.5);
var ballYMovement = 3.0*((rand(2)*2)-1);
var ballMaxSpeed = 30;
var scores = [0,0];
var notes = Scale.phrygian.degrees+60;

k = Set[]; // keep track of held keys

// SynthDef
SynthDef(\bounce, {
	|out=0, gain=0.5, length=1, freq=200, depth=20|
	var bounce, freqenv, ampenv;
	freqenv = EnvGen.kr(Env.perc(0.01,length,depth));
	ampenv = EnvGen.kr(Env.perc(0.01,length,1.0),doneAction:2);
	bounce = SinOsc.ar(freq+freqenv)!2 * ampenv * gain;
	bounce = Limiter.ar(bounce, gain, 0.001);
	Out.ar(out,bounce);
}).add;

// GUI
w = Window("Pong", Rect((Window.screenBounds.width/2)-(width/2), (Window.screenBounds.height/2)-(height/2), width, height), false).front;
u = UserView(w, Rect(0, 0, width, height));
u.background = Color.white;
u.animate = true;
u.frameRate = 60;
u.drawFunc = {
	// update paddle position
	2.do{|i|
		if(paddleMovements[i]<0,{
			//  left bounds
			// if holding left, increase left speed
			if(  (paddleMovements[i].abs < paddleMaxSpeed)
				&& (k.includes((i*(16777234-65))+65)),{
					paddleMovements[i] = paddleMovements[i]-0.001;
			});
			if((paddlePositions[i]*width - paddleWidths[i]) >= 40,
				{
					paddlePositions[i] = paddlePositions[i] + paddleMovements[i];
				}
			);
		},{
			// right bounds
			// if holding right, increase right speed
			if(  (paddleMovements[i].abs < paddleMaxSpeed)
				&& (k.includes(i*(16777236-68)+68)),{
					paddleMovements[i] = paddleMovements[i]+0.001;
			});
			if((paddlePositions[i]*width + paddleWidths[i]) <= (width-40),
				{
					paddlePositions[i] = paddlePositions[i] + paddleMovements[i];
				}
			);
		});
	};
	if((k.includes(65) || (k.includes(68))).not,
		{
			paddleMovements[0] = paddleMovements[0] / friction;
	});
	if((k.includes(16777234) || (k.includes(16777236))).not,
		{
			paddleMovements[1] = paddleMovements[1] / friction;
	});
	// update ball position
	ballPosition.x = ballPosition.x + ballXMovement;
	ballPosition.y = ballPosition.y + ballYMovement;
	// collision detection
	// top
	if ((ballPosition.y < 45) && (ballPosition.y > (35-(ballYMovement.abs))),
		{
			if(  (ballPosition.x > (paddlePositions[0]*width-paddleWidths[0]))
				&& (ballPosition.x < (paddlePositions[0]*width+paddleWidths[0])),
				{
					var ballRelPos = ((ballPosition.x-(paddlePositions[0]*width)) / (paddleWidths[0]*2));
					Synth(\bounce, [\freq, notes.choose.midicps]);
					ballYMovement = ballYMovement.abs;
					if (ballYMovement <= ballMaxSpeed,
						{ballYMovement = ballYMovement * (1.1);}
					);
					ballXMovement = ballRelPos*16;
				}
			);
		}
	);
	// bottom
	if ((ballPosition.y > (height-45)) && (ballPosition.y < (height-35+ballYMovement.abs)),
		{
			if(  (ballPosition.x > (paddlePositions[1]*width-paddleWidths[1]))
				&& (ballPosition.x < (paddlePositions[1]*width+paddleWidths[1])),
				{
					// change angle based on distance from center of paddle
					var ballRelPos = ((ballPosition.x-(paddlePositions[1]*width)) / (paddleWidths[1]*2));
					Synth(\bounce, [\freq, notes.choose.midicps]);
					ballYMovement = ballYMovement.abs * (-1);
					if (ballYMovement.abs <= ballMaxSpeed,
						{ballYMovement = ballYMovement * (1.1);}
					);
					ballXMovement = ballRelPos*16;
				}
			);
		}
	);

	// wall bounce
	if (ballPosition.x > (width-40),
		{
			Synth(\bounce, [\freq, (notes.choose-12).midicps]);
			ballXMovement = ballXMovement.abs * (-1);
		}
	);
	if (ballPosition.x < 40,
		{
			Synth(\bounce, [\freq, (notes.choose-12).midicps]);
			ballXMovement = ballXMovement.abs;
		}
	);

	// out detection
	// out top
	if (ballPosition.y < (0-ballYMovement.abs),
		{
			scores[1] = scores[1]+1;
			Synth(\bounce, [\freq, 10, \length, (4), \depth, 100]);
			ballPosition = Point(width/2, height/2);
			ballXMovement = rand2(1.5);
			ballYMovement = 3.0;
		}
	);
	// out bottom
	if (ballPosition.y > (height+(ballYMovement.abs)),
		{
			scores[0] = scores[0]+1;
			Synth(\bounce, [\freq, 10, \length, (4), \depth, 100]);
			ballPosition = Point(width/2, height/2);
			ballXMovement = rand2(1.5);
			ballYMovement = -3.0;
		}
	);
	Pen.use {
		// draw bounds
		Pen.line(Point(40,40),Point(40,height-40));
		Pen.line(Point(width-40,40),Point(width-40,height-40));
		Pen.strokeColor = Color.green;
		Pen.width = 3;
		Pen.stroke;
		// draw paddles
		Pen.line(
			Point(paddlePositions[0]*width-paddleWidths[0], 40),
			Point(paddlePositions[0]*width+paddleWidths[0], 40)
		);
		Pen.line(
			Point(paddlePositions[1]*width-paddleWidths[1], (height-40)),
			Point(paddlePositions[1]*width+paddleWidths[1], (height-40))
		);
		Pen.strokeColor = Color.black;
		Pen.width = 5;
		Pen.stroke;
		// draw ball
		Pen.fillOval(Rect(ballPosition.x-(ballSize/2),ballPosition.y-(ballSize/2),ballSize,ballSize));
		// Draw score
		(scores[0]+"").drawAtPoint(
			Point(width/2,height/2-100),
			Font("Courier", 30),
			Color.blue(0.3, 0.5));
		(scores[1]+"").drawAtPoint(
			Point(width/2,height/2+100),
			Font("Courier", 30),
			Color.blue(0.3, 0.5));
	};
};

w.view.keyDownAction = {
	arg view, char, modifiers, unicode, keycode, key;
	if(k.includes(key).not,{
		k.add(key); // add keystroke to list of keys being held
		switch(key,
			65, {paddleMovements[0] = paddleSpeed*(-1)},  // left player 0
			68, {paddleMovements[0] = paddleSpeed},  // right player 0
			16777234, {paddleMovements[1] = paddleSpeed*(-1)},  // left player 1
			16777236, {paddleMovements[1] = paddleSpeed}  // right player 1
		);
	});
};
w.view.keyUpAction_({
	arg view, char, mod, uni, keycode, key;
	switch(key,
		65, {if(k.includes(68),{paddleMovements[0] = paddleSpeed})},  // left
		68, {if(k.includes(65),{paddleMovements[0] = paddleSpeed*(-1)})},  // right
		16777234, {if(k.includes(16777236),{paddleMovements[1] = paddleSpeed})},  // left
		16777236, {if(k.includes(16777234),{paddleMovements[1] = paddleSpeed*(-1)})},  // right
	);
	k.remove(key); // remove keystroke from list of keys being held
});
)





//////////////////////////////////////////////////////////////////////



// Rumush
// https://mycelialcordsblog.wordpress.com/
// https://fungorumush.bandcamp.com/releases
// https://soundcloud.com/fungorum

(
f = {
	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	Mix.fill(n,
		{
			var detune = 5.rand;
			var sin = SinOsc.ar(x.choose, 4.rand, 0.25);
			var saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand).tanh;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) }
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;




// Rumush
// https://mycelialcordsblog.wordpress.com/
// https://fungorumush.bandcamp.com/releases
// https://soundcloud.com/fungorum

(
f = {
	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	Mix.fill(n,
		{
			var detune = 5.rand;
			var sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose) * x.choose/5001 )), 4.rand, 0.25);
			var saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand).tanh;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) 
		}
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;


(
f = {
	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	var fac1 = [1,10,100,1000].choose;
	var fac2 = [1,10,100,1000].choose;
	var fac3 = [1,10,100,1000].choose;
	Mix.fill(n,
		{
			var detune = 5.rand;
			var saw;
			var sin;
			detune = XLine.kr(0.1,1+250.0.rand ,2+9.0.rand) * 2.0.rand* [1,-1].choose;
			sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose/fac1) * x.choose/fac2 )) + detune, 4.rand, 0.25);
			saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand);
			saw = [
				saw,
				saw.fold2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw.wrap2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw *  SinOsc.ar(x.choose/2),
				( saw *  SinOsc.ar(x.choose/fac3).range(1,20) ).tanh/2,
			].choose;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) 
		}
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;



(
    Pbind(
        \instrument, \default,
        \degree, Pwalk(#[c, e, g, c],1, Prand([-1,1],inf).stutter(Pwhite(1,10))) +
            Pseq([Pn(0,64),
                Prand([
                    0,
                    [0,2,3],
                ],inf)
            ]),
        \root, Pwhite(0,-8).stutter(32),
        \mtranspose, Pwhite(-8,8).stutter(8),
        \dur, 1/8,
        \isRest, Pwrand([0,1], [0.1,1],inf).coin.not,
        \legato, Pwhite(0.1,1.2),
        \amp, 0.1
    ).play;
)






Pbind(
  \freq, Pseq([100, 200],inf),
  \draw, Pfunc({ arg ev; // 'draw' is an arbitrary name, ev is the current event
      {
		ev[\freq].postln;
        // put here some code interacting with GUI
      }.defer; // defer is needed to interact with GUI in a tempoclock thread
  })
).play
