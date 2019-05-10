
// http://frodebeats.com/drums

// basic bass drum

(
SynthDef(\basic_bass_drum, { arg out=0, gate=1;
	var adsr_freq, adsr_amp, osc, vca, filter;
	adsr_freq = EnvGen.kr(Env.adsr(0.001,0.01,0.1,0.1), gate, doneAction:0);
	adsr_amp = EnvGen.kr(Env.adsr(0.01,0.01,0.8,0.1), gate, doneAction:2);
	osc = SinOsc.ar(adsr_freq * 500);
	vca = osc * adsr_amp;
	filter = LPF.ar(vca) ! 2;
	filter = filter / 8;
	Out.ar(out, filter);
}).add;
);

(
Pdef(\kick, 
	Pbind(
		\instrument, \basic_bass_drum,
		\sustain, 0.1,
		\dur, 1,
		\amp, 0.1
	)
).play;
)

// BASS DRUM WITH BATTER CLICK


(
SynthDef(\bass_drum_batter_click, { arg out=0, gate=1;
	var adsr_freq, adsr_amp, osc, vca, filter;
	var osc2, osc3;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	adsr_freq = EnvGen.kr(\adsr_freq.kr( Env.adsr(0.001,0.01,0.1,0.1) ), gate, doneAction:0);
	adsr_amp = EnvGen.kr(\adsr_amp.kr( Env.adsr(0.01,0.01,0.8,1.3) ), gate, doneAction:2);
	osc = SinOsc.ar(adsr_freq * \freq.kr(500));
	vca = osc * adsr_amp;
	filter = LPF.ar(vca) ! 2;
	sig1 = filter;
	sig1 = sig1 * \gain_body.kr(1);

	sig2 = SinOsc.ar(\freqtab.kr([1000, 1234, 4321,   3123.23, 2134, 2234]+0.123/1) *\freqfac.kr(1)) * \amptab.kr(1!6);
	sig2 = sig2.sum;
	sig2 = sig2 * EnvGen.kr(\adsr_click.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:0);
	sig2 = LPF.ar(sig2, \lpf_click.kr(2000));
	sig2 = HPF.ar(sig2, \hpf_click.kr(2000));
	sig2 = sig2 * \gain_click.kr(1);

	
	sig = sig1 + sig2;
	sig = sig / 8;
	
	Out.ar(out, sig);
}, metadata:(specs:(
	amptab: XArraySpec(\amp),
	freqtab: XArraySpec(\freq),
	adsr_freq: XEnvSpec.adsr,
	adsr_amp: XEnvSpec.adsr,
	adsr_click: XEnvSpec.adsr,
))).add;
);

(
Pdef(\kick, 
	Pbind(
		\instrument, \bass_drum_batter_click,
		\sustain, 0.1,
		\dur, 1,
		\amp, 0.1
	)
).play;
)

WindowDef(\PdefEditor).front(Pdef(\kick))
Pdef(\kick).asParamGroup.presetCompileString
Pdef(\kick).asParamGroup.save(\current).presetCompileString.editorInsert
(
~p = ParamGroup([
	Param(Pdef('kick'), 'dur'),
	Param(Pdef('kick'), 'legato'),
	Param(Pdef('kick'), 'adsr_freq'),
	Param(Pdef('kick'), 'adsr_amp'),
	Param(Pdef('kick'), 'freq'),
	Param(Pdef('kick'), 'gain_body'),
	Param(Pdef('kick'), 'freqtab'),
	Param(Pdef('kick'), 'freqfac'),
	Param(Pdef('kick'), 'amptab'),
	Param(Pdef('kick'), 'adsr_click'),
	Param(Pdef('kick'), 'lpf_click'),
	Param(Pdef('kick'), 'hpf_click'),
	Param(Pdef('kick'), 'gain_click')
]).presets_(IdentityDictionary[
	'current' -> [ 1.0, 0.8, Env([ 0.0, 1.0, 0.30555556548966, 0.0 ], [ 0.020823787897825, 0.016607931482766, 0.073568282049921 ], [ -4.0, -4.0, -4.0 ], 2.0), Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.010000000166908, 0.010000000166908, 0.45653542382608 ], [ -4.0, -4.0, -4.0 ], 2.0), 219.52926502922, 1.0, [ 3556.5588200778, 1012.9206708643, 3556.5588200778, 9122.6470428519, 7797.2272510948, 1898.0288273047 ], 0.13260721908384, [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ], Env([ 0.0, 1.0, 0.0, 0.0 ], [ 0.0, 0.026512015758632, 0.21477484315765 ], [ -4.0, -4.0, -4.0 ], 2.0), 14054.682404717, 40.230210966376, 0.05 ]
]).load(\current);

);


~p.getPbindCompileString.editorInsert
