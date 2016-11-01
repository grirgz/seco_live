
~recmodel.edit
~recmodel.genfx;
(
~loadbufs.([\kick, \kick2, \kick3, \snare, \snare2, \snare3, \hat], "fix1");
~recmodel[\fxkey] = \fx2; ~recmodel[\fxdef] = \multifbdel;
~recmodel.recbus = BusDef(\fx2);
Ndef('fx2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.071428571428571,
	'gain', 1,
	'fb', 0.00034014403432308,
	'delay', 0.0002006878167665,
	'delay2', 0.0002086064493472,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.6072103808883,
	'pitchlag', 0.125,
	'pitchmix', 0.12605042016807,
	'fb1', 0,
	'fb2', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'deltran1', 0.41848760755187,
	'deltran2', 0.49514382564655,
	'deltran3', 0.40464376119517,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.67226890756303,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
BufDef(\kick, s.sampleRate * 4);
BufDef(\kick2, s.sampleRate * 4);
BufDef(\kick3, s.sampleRate * 4);
BufDef(\tmp4, s.sampleRate * 4);
BufDef(\snare, s.sampleRate * 4);
BufDef(\snare2, s.sampleRate * 4);
BufDef(\snare3, s.sampleRate * 4);
BufDef(\hat, s.sampleRate * 4);
BufDef(\tmp16, s.sampleRate * 16);
BufDef(\bass, s.sampleRate * 4);
BufDef(\melo, s.sampleRate * 4);
BufDef(\melo2, s.sampleRate * 4);

BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");

Spec.add(\verbmix, \unipolar);
Spec.add(\adsr, XEnvSpec.adsr);


Ndef(\fx2).put(5, \filter -> { arg in;
	var sig = in;
	FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));

});
ParamProto.init;
);

ParamProto.init(true);

~recmodel.edit
~kitTimeline.new(\smp, ~ppg).edit
Pdef(\main, Pbind(\out, BusDef(\fx1)) <> ~kitTimeline.new(\smp, ~ppg).asPattern).play
~kitTimeline.new(\smp2, ~ppg).edit
~kitTimeline.new(\smp, ~ppg).clear
~kitTimeline.new(\smp, ~ppg).getPresetCompileString.editorInsert
(
~kitTimeline.new('smp').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 1.0, \kitIndex: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 1.0, \kitIndex: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 1.0, \kitIndex: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 6.5, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 1.0, \kitIndex: 1.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 1.0, \kitIndex: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 9.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 10.0, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.375, \kitIndex: 0.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 10.875, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.055555555555556, ),
	(\absTime: 11.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 12.0, \dur: 0.375, \kitIndex: 0.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 12.375, \dur: 0.375, \kitIndex: 0.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 12.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 13.5, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.0, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 14.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 15.0, \dur: 1.0, \kitIndex: 1.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 16.0, \dur: 0.0, \kitIndex: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 16.0, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.25, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.5, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.75, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 17.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 17.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 18.0, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 18.5, \dur: 0.5, \kitIndex: 4.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 19.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 19.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 19.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 19.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.0, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 20.5, \dur: 0.25, \kitIndex: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 20.75, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.5, \dur: 0.0, \kitIndex: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 21.5, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 21.75, \dur: 0.0, \kitIndex: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 21.75, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 22.0, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.25, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.5, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 23.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.25, \dur: 0.25, \kitIndex: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 24.0, \dur: 1.0, \kitIndex: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 25.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 25.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.0, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 26.25, \dur: 0.375, \kitIndex: 1.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 26.625, \dur: 0.375, \kitIndex: 0.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 27.0, \dur: 0.5, \kitIndex: 1.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 27.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 27.75, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.0, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 28.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.5, \dur: 0.25, \kitIndex: 4.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 29.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.0, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.25, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 30.75, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.0, \dur: 0.0, \kitIndex: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 31.0, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 31.25, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 31.5, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 31.75, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 32.0, \dur: 1.0, \kitIndex: 0.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 33.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 33.25, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 33.75, \dur: 0.25, \kitIndex: 3.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 34.0, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 34.5, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 35.0, \dur: 1.0, \kitIndex: 1.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 36.0, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 36.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 36.5, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 36.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 37.0, \dur: 0.25, \kitIndex: 1.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 37.25, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 37.5, \dur: 0.5, \kitIndex: 4.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 38.0, \dur: 0.375, \kitIndex: 0.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 38.375, \dur: 0.375, \kitIndex: 0.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 38.75, \dur: 0.25, \kitIndex: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 39.0, \dur: 0.5, \kitIndex: 1.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 39.5, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 39.75, \dur: 0.25, \kitIndex: 2.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 40.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

~kitTimeline.new(\smp, ~ppg).eventList.print

~ppg.elAt(6).target.asPattern.asStream.next(()).play
~ppg.edit;
( 'instrument': \playersec, 'speed': 2.711043715847, 'bufnum': BufDef(\moeten), 'pos': 2.8020634920635, 'sustain': 0.87440665154951 ).play

~ppg = ~parPlayerGroup.new({ nil } ! 16);
~ppg.edit;
~ppg.asPresetCompileString.editorInsert(true)
(
~ppg.targets = [
	StepEvent.newFrom((out: Bus('audio', 20, 2, s), instrument: 'playersec', pos: 0.04, bufnum: BufDef('kick'))),
	StepEvent.newFrom((pos: 0.04, freq: 192.59125049198, speed: 0.77052049180328, instrument: 'playersec', bufnum: BufDef('snare2'), out: Bus('audio', 20, 2, s))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('hat'), pos: 1.2125623582766, sustain: 0.39431594860166)),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 1.1705204918033, bufnum: BufDef('hat'))),
	StepEvent.newFrom((speed: -0.5, bufnum: BufDef('rocksteady'), instrument: 'playersec', out: Bus('audio', 20, 2, s), gain: 0.20574427961076, pos: 4.3691383219955, sustain: 1)),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
];
)


~ppg.elAt(0).target
~ppg.elAt(0).play
~ppg.children.reject(_.isNil).do(_.reboot)

(reset:34).reset
(
~ppg = ~ppg ?? {~parPlayerGroup.new({ nil } ! 16)};
~ppg.startControl;
~ppg.targets = [
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', bufnum: BufDef('kick'))),
	StepEvent.newFrom((pos: 0.04, instrument: 'playersec', freq: 192.59125049198, speed: 0.77052049180328, bufnum: BufDef('snare2'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('hat'), pos: 1.2125623582766, sustain: 0.39431594860166)),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 1.1705204918033, bufnum: BufDef('hat'))),
	StepEvent.newFrom((gain: 0.20574427961076, pos: 4.3691383219955, speed: -0.5, instrument: 'playersec', bufnum: BufDef('rocksteady'), sustain: 1)),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
];
)


Ndef(\fx2).play

(
Ndef('fx2').put(110, \filter -> { arg in;
	in + ( HPF.ar(in, \xhpfreq.kr(2000))*\xhpamp.kr(4) );
});
)

//////////////////////// double

(
~double = { arg el;
	var oldendidx;
	var elcopy = el.copy;
	elcopy.do( { arg ev, idx;
		if(ev.type == \start) {
			// NOOP
		} {
			ev = ev.copy;
			ev[\absTime] = ev[\absTime] + elcopy.last[\absTime];
			el.add(ev);
			el.setRelDurInPrev(ev, el.lastIndex);
		};
		if(ev.type == \end) {
			oldendidx = idx;
		};
	} );
	el.removeAt(oldendidx);
	el.reorder;
	el.changed(\refresh);
};
)
ParamProto.init(true)
~double.(~kitTimeline.new(\smp).eventList)
~ppg.edit
~ppg.children.do(_.reboot)
~kitTimeline.new(\smp).edit
~kitTimeline.new(\smp).areasize * Point(2,1)
Font.new.bold_(true)

~kitTimeline.new(\smp, ~ppg).edit
~kitTimeline.new(\smp, ~ppg).eventLoop.lists.first
~kitTimeline.new(\smp).eventList.size
~kitTimeline.new(\smp).eventList.reorder
~kitTimeline.new(\smp).getPresetCompileString.editorInsert
(
~kitTimeline.new('smp').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 0, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 0, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 1.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 0, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 0, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 1.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

//////// original
(
~kitTimeline.new('smp').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 0, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 0, \midinote: 0.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 1.0, \midinote: 1.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


~kitTimeline.new(\smp).clear
