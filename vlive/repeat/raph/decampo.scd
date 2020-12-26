
// shepard tones
// alberto de campo
(
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
}.play;

)


////////////////////////
(
	// original with Ndef
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
WindowDef(\plotter, {
	var freqview = View.new.fixedSize_(300@300);
	var ampview = View.new.fixedSize_(300@300);

	Plotter.new(parent:freqview).value_(freqTable);
	Plotter.new(parent:ampview).value_(ampTable);
	VLayout(
		freqview,
		ampview,
	)
}).front;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
	// original with Ndef with only first channel
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
WindowDef(\plotter, {
	var freqview = View.new.fixedSize_(300@300);
	var ampview = View.new.fixedSize_(300@300);

	Plotter.new(parent:freqview).value_(freqTable);
	Plotter.new(parent:ampview).value_(ampTable);
	VLayout(
		freqview,
		ampview,
	)
}).front;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
freqTable = Signal.newClear(1024).waveFill({ arg i; 
	i * sin(i) * 1000 + 100
}, 0, 10);
WindowDef(\plotter, {
	var freqview = View.new.fixedSize_(300@300);
	var ampview = View.new.fixedSize_(300@300);

	Plotter.new(parent:freqview).value_(freqTable);
	Plotter.new(parent:ampview).value_(ampTable);
	VLayout(
		freqview,
		ampview,
	)
}).front;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
freqTable = Signal.newClear(1024).waveFill({ arg i; 
	i * 1500 - 3500
}, 0, 10);
WindowDef(\plotter, {
	var freqview = View.new.fixedSize_(300@300);
	var ampview = View.new.fixedSize_(300@300);

	Plotter.new(parent:freqview).value_(freqTable);
	Plotter.new(parent:ampview).value_(ampTable);
	VLayout(
		freqview,
		ampview,
	)
}).front;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
	// original with Ndef
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
WindowDef(\plotter, {
	var freqview = View.new.fixedSize_(300@300);
	var ampview = View.new.fixedSize_(300@300);

	Plotter.new(parent:freqview).value_(freqTable);
	Plotter.new(parent:ampview).value_(ampTable);
	VLayout(
		freqview,
		ampview,
	)
}).front;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1 * MouseX.kr(-20,20);	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)


///////:

// A.Broz: Shepard-Risset glissando demo (2020-10-31)

(
/*
                 ,
                /
             `\_\
                 \
                /O\
               '   '
*/
SynthDef(\shepard, #{ |freq=440, dur=20, direction=1, amp=0.2|
	var partialCount = 4;
	var octRange = 2 ** (partialCount / 2);
	var cycle = 1 / (partialCount * dur);
	var width = if(direction >= 0, 1, 0);
	var mouse = MouseX.kr(-2,2)*200;
	var sig = partialCount.collect { |n|
		var offset = n / partialCount;
		var phase = (3 * pi / 2) + (2 * pi * offset);
		var vol = SinOsc.kr(cycle, phase).range(0, 1);
		var ratio = VarSaw.kr(cycle * mouse, offset, width).exprange(1/octRange, octRange);
		SinOsc.ar(freq * ratio) * vol;
	}.sum;
	sig = sig!2 * (amp / partialCount) * Line.kr(0, 1, 5); // fade in
	sig = JPverb.ar(sig); // reverb
	Out.ar(0, sig);
}).add;

~playShep = #{ |fund=300, chord=([1, 5/4, 3/2]), dir=(-1), dur=40, amp=0.1|
	chord.collect { |r| (
		instrument: \shepard,
		freq: fund * r,
		dur: dur,
		direction: dir,
		amp: amp,
	).play };
};
)

// falling chord
~shep = ~playShep.value;

// rising chord
~shep = ~playShep.(300, [1, 4/3, 16/9], 1, 70, 0.1);

// free all
~shep do: _.free;




//////////////////// to send to email



////////////////////////

(
	// original with Ndef
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.4;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
}).play;

)

(
	// original with Ndef with only first channel
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 
	i * sin(i) * 1000 + 100
}, 0, 10);
FreqScope.new; // regarder les sin qui montent et qui descendent
freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
	// tentative lineaire : ca marche mais moins harmonique
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
freqTable = Signal.newClear(1024).waveFill({ arg i; 
	i * 1500 - 3500
}, 0, 10);
freqTable.plot;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)

(
	// moduler le rate avec la souris
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);
WindowDef(\plotter, {
	var freqview = View.new.fixedSize_(300@300);
	var ampview = View.new.fixedSize_(300@300);

	Plotter.new(parent:freqview).value_(freqTable);
	Plotter.new(parent:ampview).value_(ampTable);
	VLayout(
		freqview,
		ampview,
	)
}).front;

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

Ndef(\decampo,{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1 * MouseX.kr(-20,20);	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.ar(SinOsc.ar(freqs) * amps) * 0.1;
	//SinOsc.ar(freqs[0]) * amps[0] * 1.1;
}).play;

)


///////:

// A.Broz: Shepard-Risset glissando demo (2020-10-31)

(
/*
                 ,
                /
             `\_\
                 \
                /O\
               '   '
*/
SynthDef(\shepard, #{ |freq=440, dur=20, direction=1, amp=0.2|
	var partialCount = 4;
	var octRange = 2 ** (partialCount / 2);
	var cycle = 1 / (partialCount * dur);
	var width = if(direction >= 0, 1, 0);
	var mouse = MouseX.kr(-2,2)*200;
	var sig = partialCount.collect { |n|
		var offset = n / partialCount;
		var phase = (3 * pi / 2) + (2 * pi * offset);
		var vol = SinOsc.kr(cycle, phase).range(0, 1);
		var ratio = VarSaw.kr(cycle * mouse, offset, width).exprange(1/octRange, octRange);
		SinOsc.ar(freq * ratio) * vol;
	}.sum;
	sig = sig!2 * (amp / partialCount) * Line.kr(0, 1, 5); // fade in
	sig = JPverb.ar(sig); // reverb
	Out.ar(0, sig);
}).add;

~playShep = #{ |fund=300, chord=([1, 5/4, 3/2]), dir=(-1), dur=40, amp=0.1|
	chord.collect { |r| (
		instrument: \shepard,
		freq: fund * r,
		dur: dur,
		direction: dir,
		amp: amp,
	).play };
};
)

// falling chord
~shep = ~playShep.value;

// rising chord
~shep = ~playShep.(300, [1, 4/3, 16/9], 1, 70, 0.1);

// free all
~shep do: _.free;
