/*
 A SuperCollider implementation of the synth sound described here:
 "http://www.attackmagazine.com/technique/synth-secrets/detuned-pad/"
*/

// Chord seq:
// 1. (E1, E2, B3, D4, G4)
// 2. (G1, G2, B3, D4, F#4, A4)
// 3. (G1, G2, B3, D4, F#4, A4, B4)
// 4. (A1, A2, C4, E4, G4)
// 5. (C1, C2, G3, E4, G4)

(
// sequence
~crdStr = [["E1", "E2", "B3", "D4", "G4"],
	["G1", "G2", "B3", "D4", "F#4", "A4"],
	["B4"],
	["A1", "A2", "C4", "E4", "G4"],
	["C1", "C2", "G3", "E4", "G4"]
];

// Map from chord names to midi notes
~noteToMidi = {
	arg noteStr;
	var notes = Dictionary[
	"C"  -> 0,
	"C#" -> 1,
	"D"  -> 2,
	"D#" -> 3,
	"E"  -> 4,
	"F"  -> 5,
	"F#" -> 6,
	"G"  -> 7,
	"G#" -> 8,
	"A"  -> 9,
	"A#" -> 10,
	"B"  -> 11];
	var octave = noteStr.last.digit;
	var degree = notes[noteStr[..noteStr.size-2].postln];
	octave*12 + degree;
};

~crdArray = ~crdStr.collect{
	arg crd;
	crd.collect{|c| ~noteToMidi.(c)};
};
)

// STEP 1: a simple synth
(
// Init synth
SynthDef(\simpSaw1, {|freq, gate=1|
	var env = EnvGen.ar(Env.adsr(0.01,0.3,0.5,0.1), gate, doneAction:2);
	var snd = Saw.ar(freq!2);
	Out.ar(0, env*snd);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw1,
	\freq, Pseq(~crdArray + 24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.55*Pseq([1, 1, 0.625, 1, 1], 1)
).play;
)

// STEP2: add voices/detune/de-phase

(
SynthDef(\simpSaw2, {|freq, gate=1|
	var adsr = EnvGen.ar(Env.adsr(0.25,0.01,0.75,0.25), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 10, detune2 = 5;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var saw = LFSaw.ar(m * freq/2);
		DelayC.ar(saw, 0.02, freq.reciprocal.rand);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var saw = LFSaw.ar(m * freq);
		DelayC.ar(saw, 0.02, freq.reciprocal.rand);
	}.dup(nvoices2);

	Out.ar(0, Splay.ar(osc1 + osc2 * adsr)/4);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw2,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play;
)


// STEP3: add LFO
(
SynthDef(\simpSaw3, {|freq, gate=1|
	var adsr = EnvGen.ar(Env.adsr(0.25,0.01,0.75,0.25), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 10, detune2 = 5;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(Saw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(Saw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	Out.ar(0, Splay.ar(osc1 + osc2 * adsr)/4);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw3,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play;
)

// STEP4: add filter
(
SynthDef(\simpSaw4, {|freq, gate=1|
	var adsr = EnvGen.ar(Env.adsr(1e-8,1e-6,0.75,0.125), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 12, detune2 = 8;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	var snd = BLowPass4.ar(osc1, 800, 0.5) + osc2 / 4;
	Out.ar(0, Splay.ar(snd*adsr));
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw4,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play(quant: 1);
)

// Now Let's hear each version one at a time:
(
{
	~list = [\simpSaw1, \simpSaw2, \simpSaw3, \simpSaw4];
	4.do{
		arg i;
		Pbind(
			\instrument, ~list[i],
			\freq, Pseq(~crdArray+24, inf).midicps,
			\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
			\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
		).play(quant: 1);
		(2.5*[1, 0.375, 0.625, 1, 1].sum + 0.125).wait;
	};
}.fork;
)





s.boot;
(
var maxWidth=15, maxHeight = 15;
var z=40, ready = false;
var newValues=Array2D.new(maxWidth + 2, maxHeight + 2);
var oldValues=Array2D.new(maxWidth + 2, maxHeight + 2);
var go, total;


/*There is a decreasing linear connection between log(freq) and location in array: h+(maxWidth*v).
Highest location-value in array = maxWidth*maxHeight
log(freq)=log(maxfreq)-((log(maxfreq)-log(minfreq))*(h+(maxWidth*v))/(maxWidth*maxHeight), so
freq=exp(log(maxfreq)-((log(maxfreq)-log(minfreq))*(h+(maxWidth*v))/(maxWidth*maxHeight)
Furthermore freq depends on value, which is either 0 or 1. 
freq=freq+(freq*value) or freq=(1+value)*freq
Combining those 2:
freq=(exp(log(maxfreq)-((log(maxfreq)-log(minfreq))*(h+(maxWidth*v))/(maxWidth*maxHeight))*(1+value)

*/

SynthDef(\beeper, { arg h, v, p, maxWidth, maxHeight;
	var maxfreq=5000, minfreq=50;
	Out.ar(
		0, 
		Pan2.ar(
			Pulse.ar(exp(log(maxfreq)-((log(maxfreq)-log(minfreq))*(h+(maxWidth*v))/(maxWidth*maxHeight)))*(1+p), 0.5, 0.3), 
			2*h/maxWidth-1, //pan depends on column in array
			1
		)
	);
	
}).add;

w=Window("Confetti3", Rect(400, 300, z*(maxWidth+2), z*(maxHeight+2))).front;
w.view.background_(Color.white);
w.front;

w.drawFunc = {
		for (1, maxHeight, {arg v;
			for (1, maxWidth, {arg h;
				if (newValues[h,v]==0, 
					{Pen.fillColor=Color.white},
					{Pen.fillColor=Color.black}
				);
				Pen.addRect(Rect(h*z, v*z, z, z));
				Pen.fill;
			});
		});
};

go=Routine({
	//make random pattern
	for (1, maxWidth, {arg h;
		for (1, maxHeight, {arg v;
			newValues[h,v]=[0, 1].choose;
			{w.refresh}.defer;
			p=newValues[h,v];
			b=Synth("beeper",[p: p, h: h, v: v, maxWidth: maxWidth, maxHeight: maxHeight]);
			0.1.wait;
			b.free;
		})
	});
	while ({ready==false},{
		//copy edges of board to edges of array
		for(1, maxWidth, {arg h;
			newValues[h,0]=newValues[h, maxHeight];
			newValues[h, maxHeight+1]=newValues[h, 1];
		});
		for(1, maxHeight, {arg v;
			newValues[ 0, v]=newValues[maxWidth, v];
			newValues[maxWidth+1, v]=newValues[1, v];
		});
		newValues[0,0]=newValues[maxWidth, maxHeight];
		newValues[0, maxHeight+1]=newValues[maxWidth, 1];
		newValues[maxWidth+1, 0]=newValues[1, maxHeight];
		newValues[maxWidth+1, maxHeight+1]=newValues[1,1];
		//copy newValues to oldValues (including edges)
		for (0, maxWidth+1, {arg h;
			for (0, maxHeight+1, {arg v;
				oldValues[h,v]=newValues[h,v];
			})
		});
		//adapt
		for (1, maxWidth,{arg h;
			for (1, maxHeight, {arg v;
				total=oldValues[h-1,v-1] + oldValues[h,v-1] + oldValues[h+1,v-1] + oldValues[h-1,v]+						oldValues[h+1,v] + oldValues[h-1,v+1] + oldValues[h,v+1] + oldValues[h+1,v+1];
					if(
					(total<=1 )|| (total > 3),
					{newValues[h,v]=0}
				);
				if(
					total==3,
					{newValues[h,v]=1}
				);
				{w.refresh}.defer;
				if (newValues[h,v]!=oldValues[h,v],{
					p=newValues[h,v];
					b=Synth("beeper",[p: p, h: h, v: v, maxWidth: maxWidth, maxHeight: maxHeight]);
					0.1.wait;
					b.free;
				});
			})
		});
		//check if ready
		ready=true;
		for (1, maxWidth,{arg h;
			for (1, maxHeight, {arg v;
				if (oldValues[h,v]!=newValues[h,v], {ready=false});
			})
		});
	});
});


go.play;
)


~s = ControlSpec(1/16,4,\exp, 1/16)
~s.map((0..50)/50)
