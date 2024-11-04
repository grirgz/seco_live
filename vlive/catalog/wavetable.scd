(
WavetableDef(\mywt, { 

			var env=Env([0]++ Array.rand(10,-1.0,1.0).normalize(-1,1)++[0],Array.rand(11,0.01,1),Array.rand(11,-4.0,4.0));
			var wt=env.discretize(2.pow(12)).asWavetable;
			i.postln;
			wt;
}.value);
)
WavetableDef(\mywt).plotWavetable


(
SynthDef(\wt, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Osc.ar(\wavetable.kr(0), freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \wt,
			\wavetable, WavetableDef(\mywt),
			\note, Pseq([
				[0,4,7,4+12],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\vosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = VOsc3.ar(\wavetable.kr(0), freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
WavetableDef(\swip, [
	//WavetableDef(\wt),
	~bufs[0],
	~bufs[1],
	~bufs[2],
	~bufs[3],
	~bufs[4],
])
)
WavetableDef(\swip)

///////// stolen

//this will take a second
//make 100 different buffers
(
    {
        ~bufs = List.newClear;
        100.do{|i|
            var env=Env([0]++ Array.rand(10,-1.0,1.0).normalize(-1,1)++[0],Array.rand(11,0.01,1),Array.rand(11,-4.0,4.0));
            var wt=env.discretize(2.pow(12)).asWavetable;
            i.postln;
            ~bufs.add(Buffer.loadCollection(s, wt));
            s.sync;
        };
        "I'm done".postln;
    }.fork
)

//make the synth
(
a = {|buf|
    var left = Mix(Osc.ar(buf, 200*[0.125, 0.25, 0.5, 2, 3/2, 4/3, 5/4, 6/5, 7/6, 8/7, 9/8, 11/10], 0, 0.04));
    var right = Mix(Osc.ar(buf, 201*[0.125, 0.25, 0.5, 2, 3/2, 4/3, 5/4, 6/5, 7/6, 8/7, 9/8, 11/10], 0, 0.04));
    Out.ar(0, [left, right])
}.play(s, args:[\buf, ~bufs[0]]);
)

//change the buffer every second
(
Routine({
	inf.do{
		a.set(\buf, ~bufs.choose);
		1.wait;
	}
}).play

)
