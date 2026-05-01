///////////// SingleOscOS

// create a wavetable (or use your own)
(
t = Signal.sineFill(2048, [1], [0]);
u = Signal.sineFill(2048, 1.0/((1..512)**2)*([1,0,-1,0]!128).flatten);
w = Signal.sineFill(2048, 1.0/(1..512)*([1,0]!256).flatten);
x = Signal.sineFill(2048, 1.0/(1..512));
v = t.addAll(u).addAll(w).addAll(x);

~buffer = Buffer.loadCollection(s, v);
)

(
{
    var cyclePos, phase, sig;
    
    cyclePos = SinOsc.ar(0.1, 1.5pi).linlin(-1, 1, 0, 1);
    phase = Phasor.ar(DC.ar(0), 440 * SampleDur.ir);

    sig = SingleOscOS.ar(
        bufnum: ~buffer,
        phase: phase,
        numCycles: BufFrames.kr(~buffer) / 2048,
        cyclePos: cyclePos,
        oversample: 0,
    );
    
    sig = LeakDC.ar(sig);
    sig!2 * 0.1;
}.play;
)

(
SynthDef(\oscos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
    var cyclePos, phase, sig;
    
    cyclePos = SinOsc.ar(0.4, 1.5pi).linlin(-1, 1, 0, 1);
    phase = Phasor.ar(DC.ar(0), freq * SampleDur.ir);

    sig = SingleOscOS.ar(
        bufnum: bufnum,
        phase: phase,
        numCycles: \numCycles.kr(1),
        cyclePos: cyclePos,
        oversample: 0,
    );
    
    sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscos,
			\bufnum, ~buffer,
			\numCycles, 4,
			\note, Pseq([
				[0,3,7],
				[-1,3,7],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


BufDef.reload(\bla, "wavetable/akwf/AKWF_vgame/AKWF_vgame_0131.wav")
BufDef(\piano1, "wavetable/akwf/AKWF_piano/AKWF_piano_0001.wav")


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscos,
			\bufnum, BufDef(\piano1),
			\cycleSize, 1,
			\note, Pseq([
				[0,3,7],
				[-1,3,7],
			],inf),
			\octave, 4,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscos,
			\bufnum, BufDef(\piano1),
			\cycleSize, 1,
			\note, Pseq([
				[0,3,7],
				[-1,3,7],
			],inf),
			\strum, 0.3,
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

// check if working correctly
(
SynthDef(\sine, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

BufDef(\sine, "wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav")

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscos,
			\bufnum, BufDef(\sine),
			\cycleSize, 1,
			\note, Pseq([
				0
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
(
// check ok, really the same
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sine,
			\note, Pseq([
				0
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


////////////////

(
// scale modulation depth of modulators between 0 and 1
var modScaleBipolarUp = { |modulator, value, amount|
    value + (modulator * (1 - value) * amount);
};

SynthDef(\dualOscOS, {
    
    var param, calcWavetableData;
    var wavetableDataA, wavetableDataB;
    var sigs, sig;
    
    // Global parameter function
    param = { |chainID, name, default, spec|
        var paramName = "%_%".format(name, chainID).asSymbol;
        NamedControl.kr(paramName, default, lags: 0.02, fixedLag: true, spec: spec);
    };
    
    // Function to calculate wavetable data
    calcWavetableData = { |chainID, phaseOffset|
        
        var tableIndexMF, tableIndexMod, tableIndex;
        var wavetable, sizeOfTable, pmIndex, pmFltRatio;
        var freq, phase;
        
        freq = param.(chainID, \freq, 440, spec: ControlSpec(1, 1000, \exp));
        phase = Phasor.ar(DC.ar(0), freq * SampleDur.ir);
        
        /////////////////////////////////////////////////////////////////////////////////
        
        // Create table index modulation
        tableIndexMF = param.(chainID, \tableIndexMF, 0.1, ControlSpec(0.1, 1));
        tableIndexMod = { |phase|
            SinOsc.ar(tableIndexMF, phase + phaseOffset * pi)
        };
        
        tableIndex = modScaleBipolarUp.(
            modulator: tableIndexMod.(0.5),
            value: param.(chainID, \tableIndex, 0, ControlSpec(0, 1)),
            amount: param.(chainID, \tableIndexMD, 1, ControlSpec(0, 1))
        );
        
        // table params
        wavetable = param.(chainID, \sndBuf, 0);
        sizeOfTable = BufFrames.kr(wavetable) / 2048;
        
        // Phase modulation params
        pmIndex = param.(chainID, \pmIndex, 0, ControlSpec(0, 5));
        pmFltRatio = param.(chainID, \pmFltRatio, 1, ControlSpec(1, 5));
        
        /////////////////////////////////////////////////////////////////////////////////
        
        (
            phase: phase,
            pmIndex: pmIndex,
            pmFltRatio: pmFltRatio,
            wavetable: wavetable,
            sizeOfTable: sizeOfTable,
            tableIndex: tableIndex
        );
        
    };
    
    wavetableDataA = calcWavetableData.(\A, 0);
    wavetableDataB = calcWavetableData.(\B, 1);
    
    sigs = DualOscOS.ar(

        bufnumA: wavetableDataA[\wavetable],
        phaseA: wavetableDataA[\phase],
        numCyclesA: wavetableDataA[\sizeOfTable],
        cyclePosA: wavetableDataA[\tableIndex],

        bufnumB: wavetableDataB[\wavetable],
        phaseB: wavetableDataB[\phase],
        numCyclesB: wavetableDataB[\sizeOfTable],
        cyclePosB: wavetableDataB[\tableIndex],

        pmIndexA: wavetableDataA[\pmIndex],
        pmIndexB: wavetableDataB[\pmIndex],
        pmFilterRatioA: wavetableDataA[\pmFltRatio],
        pmFilterRatioB: wavetableDataB[\pmFltRatio],

        oversample: 0
    );

    sig = XFade2.ar(sigs[0], sigs[1], \chainMix.kr(0.5, spec: ControlSpec(0, 1)) * 2 - 1);
    
    sig = Pan2.ar(sig, \pan.kr(0));
    sig = sig * \amp.kr(-25, spec: ControlSpec(-35, -5)).dbamp;
    sig = sig * Env.asr(0.001, 1, 0.001).ar(Done.freeSelf, \gate.kr(1));

    sig = LeakDC.ar(sig);
    sig = Limiter.ar(sig);
    Out.ar(\out.kr(0), sig);
}).add;
)

// create a wavetable (or use your own)
(
t = Signal.sineFill(2048, [1], [0]);
u = Signal.sineFill(2048, 1.0/((1..512)**2)*([1,0,-1,0]!128).flatten);
w = Signal.sineFill(2048, 1.0/(1..512)*([1,0]!256).flatten);
x = Signal.sineFill(2048, 1.0/(1..512));
v = t.addAll(u).addAll(w).addAll(x);

~buffer = Buffer.loadCollection(s, v);
)

(
x = Synth(\dualOscOS, [
    
    \sndBuf_A, ~buffer,    
    \freq_A, 440, 
    
    \tableIndexMF_A, 420.1,
    \tableIndexMD_A, 1,
    \tableIndex_A, 0,
    
    \pmFltRatio_A, 1, 
    \pmIndex_A, 2,
    
    ///////////////////////
    
    \sndBuf_B, ~buffer,
    \freq_B, 550, 

    \tableIndexMF_B, 0.1, 
    \tableIndexMD_B, 1, 
    \tableIndex_B, 0,
    
    \pmFltRatio_B, 2, 
    \pmIndex_B, 1, 
    
    ///////////////////////
    
    \chainMix, 0.5,
    \pan, 0,
    \amp, -25,
    \out, 0,
    
]);
)

x.free;

// load multi-cycle wavetable
(
t = Signal.sineFill(2048, [1], [0]);
u = Signal.sineFill(2048, 1.0/((1..512)**2)*([1,0,-1,0]!128).flatten);
w = Signal.sineFill(2048, 1.0/(1..512)*([1,0]!256).flatten);
x = Signal.sineFill(2048, 1.0/(1..512));
v = t.addAll(u).addAll(w).addAll(x);
~oscBuf = Buffer.loadCollection(s, v);
~modBuf = Buffer.loadCollection(s, v);
)

// Basic cross-modulated pulsar
(
{
    var events, overlap, windowRate, sig;

    events = SchedulerCycle.ar(\tFreq.kr(100));

    overlap = \overlap.kr(4);
    windowRate = events[\rate] / max(0.001, overlap);

    sig = DualPulsarOS.ar(
        trig: events[\trigger],
        triggerFreq: windowRate,
        subSampleOffset: events[\subSampleOffset],
        oscFreq: \oscFreq.kr(440),
        modFreq: \modFreq.kr(440),
        pmIndexOsc: \pmIndexOsc.kr(1),
        pmIndexMod: \pmIndexMod.kr(0.5),
        pmFilterRatioOsc: 1,
        pmFilterRatioMod: 1,
        warpOsc: 0.5,
        warpMod: 0.5,
        oscBuffer: ~oscBuf,
        oscNumCycles: 4,
        oscCyclePos: 0,
        modBuffer: ~modBuf,
        modNumCycles: 4,
        modCyclePos: 0,
        skew: 0.5,
        index: 0,
        oversample: 0,
    );

    sig = LeakDC.ar(sig);
    sig ! 2 * 0.1;
}.play;
)

// Phase increment distortion — pitch glide within grains
(
{
    var events, overlap, windowRate, sig;

    events = SchedulerCycle.ar(\tFreq.kr(5));

    overlap = \overlap.kr(1);
    windowRate = events[\rate] / max(0.001, overlap);

    sig = DualPulsarOS.ar(
        trig: events[\trigger],
        triggerFreq: windowRate,
        subSampleOffset: events[\subSampleOffset],
        oscFreq: 800,
        modFreq: 400,
        pmIndexOsc: 1,
        pmIndexMod: 0,
        warpOsc: \warpOsc.kr(0),
        warpMod: 0.5,
        oscBuffer: ~oscBuf,
        oscNumCycles: 4,
        oscCyclePos: 0,
        modBuffer: ~modBuf,
        modNumCycles: 4,
        modCyclePos: 0,
        skew: 0.5,
        index: 0,
        oversample: 0,
    );

    sig = LeakDC.ar(sig);
    sig ! 2 * 0.3;
}.play;
)

//////////////////////// Disperser

(
{
    var sig = Impulse.ar(2);
    Disperser.ar(
        input: sig,
        freq: 500,
        resonance: 0,
        mix: 1.0,
        feedback: 0.0
    )!2;
}.play;
)

(
{
    var sig = Saw.ar(32.midicps);
    Disperser.ar(
        input: sig,
        freq: MouseX.kr(10,1000),
        resonance: 0,
        mix: 0.5,
        feedback: 0.85,
    )!2 * 0.1
}.play;
)

(
{
    var sig = Saw.ar(32.midicps * (2 ** TIRand.ar(-1, 1, Dust.ar(2))));
    Disperser.ar(
        input: sig,
        freq: MouseX.kr(60,6000),
        resonance: MouseY.kr(0,1),
        mix: 0.5,
        feedback: 0.85,
    )!2 * 0.1
}.play;
)


(
SynthDef(\sawdisp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq) * 100;
	sig = LFPulse.ar(freq * [1,1.001] + mod1).bipolar;
	sig = Disperser.ar(sig, \lpf.kr(300), 0.8, 1.0, 0.86);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawdisp,
			\note, Pseq([
				0,4,3,
			],inf),
			\lpf, PmodEnv(Pseq([100,4004,10000],1), 8,\exp).loop,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawdisp,
			\note, Pseq([
				[0,3,7],
				[-1,3,7],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4004,10000],1), 8,\exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


