

//////////// init

(
TrackDef(\grid1, TrackDef(\playergrid));

PatKitDef(\kit1, [
	StepEvent.newFrom((instrument: 'playersec', speed: 1.0, gain: 1.7381005971439, amp: 0.14200373466296, adsr: Env([ 0, 1, 1, 0 ], [ 0.001, 0, 0.1 ], [ -4, -4, -4 ], 2), pos: 0.04, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/simplekick.flac'))),
	StepEvent.newFrom((pos: 0.04, freq: 192.59125049198, speed: 0.77052049180328, instrument: 'playersec', bufnum: BufDef('snare2'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('hat'), pos: 1.2125623582766, sustain: 0.39431594860166)),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 1.1705204918033, bufnum: BufDef('hat'))),
	StepEvent.newFrom((gain: 0.20574427961076, pos: 4.3691383219955, speed: -0.5, instrument: 'playersec', bufnum: BufDef('rocksteady'), sustain: 1)),
	StepEvent.newFrom((pos: 0.0073922902494331, instrument: 'playersec', gain: 0.25, bufnum: BufDef('hat2'), sustain: 1)),
	StepEvent.newFrom((gain: 0.15669805278867, pos: 0.33269841269841, speed: 0.78144808743169, instrument: 'playersec', bufnum: BufDef('hat2'), sustain: 1)),
	StepEvent.newFrom((pos: 1.519387755102, instrument: 'playersec', gain: 0.25, bufnum: BufDef('hat2'), sustain: 1)),
	StepEvent.newFrom((pos: 3.925306122449, instrument: 'playersec', speed: -1.3, bufnum: BufDef('tmp4b'), sustain: 1)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/bigindusbass.flac'))),
	StepEvent.newFrom((pos: 1.6077643488251, instrument: 'playersec', gain: 0.69481122578873, speed: -1, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/bigindusbass.flac'))),
	StepEvent.newFrom((instrument: 'playersec', speed: 0.9, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/simplekick.flac'), pos: 0.04)),
	nil,
	nil,
	nil,
	nil,
]);
KitTimeline('smp2', PatKitDef(\kit1)).eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 9.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 10.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 4.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 4.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.25, \kitIndex: 10.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.5, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 6.625, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.375, \kitIndex: 1.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 7.375, \dur: 0.625, \kitIndex: 9.0, \midinote: 0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0.5, \kitIndex: 9.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 8.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.0, \dur: 0.5, \kitIndex: 1.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.5, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 9.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 10.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.0, \kitIndex: 10.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 10.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 12.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 12.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 13.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 13.0, \dur: 0.625, \kitIndex: 8.0, \midinote: 0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.25, ),
	(\absTime: 13.625, \dur: 0.125, \kitIndex: 10.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 14.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 14.0, \dur: 0.25, \kitIndex: 10.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 14.25, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 14.25, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.5, ),
	(\absTime: 14.625, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 15.0, \dur: 0.375, \kitIndex: 1.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 15.375, \dur: 0.125, \kitIndex: 9.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 15.5, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 15.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);


KitTimeline('smp', PatKitDef(\kit1)).eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 9.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 2.0, ),
	(\absTime: 0.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 10.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 2.0, ),
	(\absTime: 2.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0.5, \kitIndex: 9.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 2.0, ),
	(\absTime: 4.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.25, \kitIndex: 10.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 1.0, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.5, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 6.625, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.375, \kitIndex: 1.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 7.375, \dur: 0.375, \kitIndex: 9.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 7.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0.5, \kitIndex: 9.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 2.0, ),
	(\absTime: 8.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 9.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 9.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 10.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 10.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 10.5, \dur: 0.5, \kitIndex: 10.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 11.0, \dur: 0.5, \kitIndex: 10.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 11.5, \dur: 0.0, \kitIndex: 10.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 11.5, \dur: 0.25, \kitIndex: 10.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 11.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 12.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 12.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 12.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 13.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 13.0, \dur: 0.75, \kitIndex: 10.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 1.0, ),
	(\absTime: 13.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 14.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.375, ),
	(\absTime: 14.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 14.0, \dur: 0.5, \kitIndex: 10.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 14.5, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 14.5, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 15.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.5, ),
	(\absTime: 15.0, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 15.25, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 15.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 16.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 16.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 16.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 17.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 17.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 18.0, \dur: 0.0, \kitIndex: 10.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 18.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 18.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, ),
	(\absTime: 18.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 19.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 19.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 20.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 20.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 20.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 21.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 21.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 21.25, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 21.5, \dur: 0.125, \kitIndex: 9.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.5, ),
	(\absTime: 21.625, \dur: 0.125, \kitIndex: 0.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 21.75, \dur: 0.25, \kitIndex: 11.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 22.0, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 22.0, \dur: 0.0, \kitIndex: 10.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 22.0, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 22.375, \dur: 0.375, \kitIndex: 0.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 22.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 23.0, \dur: 0.375, \kitIndex: 1.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 23.375, \dur: 0.0, \kitIndex: 11.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 23.375, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.375, ),
	(\absTime: 23.625, \dur: 0.375, \kitIndex: 11.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 24.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 24.0, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 24.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 25.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 25.75, \dur: 0.25, \kitIndex: 0.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 26.0, \dur: 0.0, \kitIndex: 10.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, ),
	(\absTime: 26.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 26.0, \dur: 0.5, \kitIndex: 8.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 1.0, ),
	(\absTime: 26.5, \dur: 0.5, \kitIndex: 0.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 27.0, \dur: 0.75, \kitIndex: 1.0, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 27.75, \dur: 0.25, \kitIndex: 9.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 28.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.0, ),
	(\absTime: 28.0, \dur: 1.0, \kitIndex: 0.0, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.25, ),
	(\absTime: 29.0, \dur: 0.0, \kitIndex: 9.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 29.0, \dur: 0.375, \kitIndex: 1.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 29.375, \dur: 0.125, \kitIndex: 9.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 29.5, \dur: 0.5, \kitIndex: 9.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 30.0, \dur: 0.375, \kitIndex: 10.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 30.375, \dur: 0.375, \kitIndex: 10.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.125, ),
	(\absTime: 30.75, \dur: 0.25, \kitIndex: 10.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 31.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 31.0, \dur: 0.5, \kitIndex: 10.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 31.5, \dur: 0.5, \kitIndex: 10.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 32.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

RandDelayNetwork('multifbdel').make('fx2', "5-4TE1-1QBJ");
Ndef('fx2').put(100, \pset -> Pbind(
	'wet5', 1.0,
	'verbmix', 0.0,
	'room', 0.1,
	'damp', 0.4,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.16408640428749,
	'fb', 0.0001,
	'delay', 0.2297970969047,
	'delay2', 0.0111,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.4787641409844,
	'pitchlag', 0.098083654454067,
	'pitchmix', 0.60504201680672,
	'fb1', 0.1,
	'fb2', 0.1,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'deltran1', 1.7778781329233,
	'deltran2', 2.1035399003061,
	'deltran3', 1.8387036641027,
	'fbdistamp', 0.50815299962112,
	'fbdistmix', 0.65126050420168,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
);

/////////// build preset


PatKitDef(\kit1).asPresetCompileString.editorInsert
KitTimeline(\smp).presetCompileString.editorInsert
RandDelayNetwork(\multifbdel).getPresetCompileString(\fx2).editorInsert
RandDelayNetwork(\default).getPresetCompileString(\fx2).editorInsert


///////////////////////////////

(
(
RandDelayNetwork('default').make('fx2', "4-SR83-A5PF");
Ndef('fx2').put(100, \pset -> Pbind(
	'wet5', 1.0,
	'verbmix', 0.0,
	'room', 0.1,
	'damp', 0.4,
	'wet10', 1.0,
	'fb', 0.0018310461426494,
	'delay', 0.0001123104501833,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 7.0615797528893,
	'pitchlag', 0.77011329653568,
	'pitchmix', 0.33193277310924,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 3.9234346672443,
	'fbdistmix', 0.65126050420168,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.19375658492644,
	'deltran1', 0.077838586969681,
	'deltran2', 0.033569982446549,
	'deltran3', 0.024800665545529,
	'indelay', 0.04,
	'gain', 0.051970528904376,
	'fb1', 0.1,
	'fb2', 0.1,
	'mix', 1.0,
).keep(1));
);

);


RandDelayNetwork(\deltrans).getPresetCompileString(\fx2).editorInsert
(
RandDelayNetwork('deltrans').make('fx2', "5-SDU0-K1S3");
Ndef('fx2').put(100, \pset -> Pbind(
	'wet5', 1.0,
	'verbmix', 0.0,
	'room', 0.14318998610132,
	'damp', 0.4,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.29156160276546,
	'fb', 0.0001,
	'delay', 0.0012860080806106,
	'delay2', 0.0017526592085368,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.36579990580413,
	'pitchlag', 0.68570048047962,
	'pitchmix', 0.0,
	'fb1', 0.1,
	'fb2', 0.1,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'deltran1', 1.2700021513418,
	'deltran2', 0.87719706872926,
	'deltran3', 0.84817881054218,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.67226890756303,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Ndef(\fx2).put(110, \pset -> Pbind(
	\instrument, \default,
	\delay2, Pseq([
		//0.0001, 0.0001, 0.0001, 0.042,
		//0.0001, 0.0001, 0.0001, 0.742,
		0.0001, 0.0001, 0.242,0.0001, 
		0.0001, 0.0001, 0.212,0.0001, 
		0.0001, 0.0181, 0.212,0.0001, 
		0.0041, 0.0001, 0.392,0.0111, 
		//0.742, 0.742, 0.742, 0.742,
	
	],inf),
	\lag, 1 + ( 7/8 ),
	\dur, Pseq([
		2
	],inf),
	\amp, 0.1
));
)

(
Ndef(\fx2).put(110, \pset -> Pbind(
	\instrument, \default,
	\delay2, Pseq([
		//0.0001, 0.0001, 0.0001, 0.042,
		//0.0001, 0.0001, 0.0001, 0.742,
		0.0001, 0.0001, 0.0001, 0.0001,
		0.0001, 0.0001, 0.242,0.0001, 
		0.0001, 0.0001, 0.0001, 0.0001,
		0.0001, 0.0001, 0.212,0.0001, 
		0.0001, 0.0001, 0.0001, 0.0001,
		0.0001, 0.0181, 0.212,0.0001, 
		0.0001, 0.0001, 0.0001, 0.0001,
		0.0041, 0.0001, 0.392,0.0111, 
		//0.742, 0.742, 0.742, 0.742,
	
	],inf),
	\lag, 1 + ( 7/8 ),
	\dur, Pseq([
		2
	],inf),
	\amp, 0.1
));
)

	KitTimeline(\smp, ~kit1).edit
	KitTimeline(\smp2, ~kit1).edit
	KitTimeline(\smp, ~kit1).repeatCount = inf
	KitTimeline(\smp2, ~kit1).repeatCount = inf

TrackDef(\grid1).clear

TrackDef(\grid1).edit
~kit1.edit
~kit1
ProtoDef(\recorder).edit
		KitTimeline(\smp3, ~kit1).edit

		~patKitDef
		ParamProto.init(true)

(
);

PatKitDef(\kit1).edit
PatKitDef(\kit1).children
PatKitDef(\kit1).elAt(0).target
(
PatKitDef(\kit1).source = [
	StepEvent.newFrom((instrument: 'playersec', speed: 1.0, gain: 1.7381005971439, amp: 0.14200373466296, adsr: Env([ 0, 1, 1, 0 ], [ 0.001, 0, 0.1 ], [ -4, -4, -4 ], 2), pos: 0.04, bufnum: BufDef('/home/ggz/Musique/sc/reckit/fix2/simplekick.flac'))),
	
]
)
PatKitDef(\kit1).elAt(1).target
~kit1.elAt(1).target
PatKitDef(\kit1).all.clear

///////////////////////// GUI

~childmodel.target

TrackDef(\grid1).edit;
TrackDef(\grid1).childAt(Point(0,0)).source.edit
ProtoDef(\recorder).edit;
PatKitDef(\kit).edit;
KitTimeline(\smp).edit;
KitTimeline(\smp2).edit;
KitTimeline(\smp3, PatKitDef(\kit1)).edit;


PatKitDef(\rep, nil ! 16)
PatKitDef(\rep).edit

		KitTimeline(\rep, PatKitDef(\rep))
///////////////////////////// play

(
TrackDef(\grid1).source = [
	[
		KitTimeline(\smp),
		KitTimeline(\smp2),
		KitTimeline(\rep),
	],
	[
		KitTimeline(\smp3),
	],
	[
		nil,
	],
	[
		Ndef(\fx2)
	],
	[
		ProtoDef(\basicrecorder)
		//Ndef(\fx1)
	]
	//[
	//	NoteTimeline(\note1),
	//	NoteTimeline(\note2),
	//	Pdef(\noteseq),
	//],
]
)


(
Pdef(\main, Pseq([
	KitTimeline(\smp).asPattern,
	KitTimeline(\smp2).asPattern,
],inf)).play;
)

/////////////////////////////// draft

ProtoDef(\basicrecorder).edit
ProtoDef(\basicrecorder).play
ProtoDef(\basicrecorder).label
ProtoDef(\basicrecorder).isPlaying
PlayerWrapper(ProtoDef(\basicrecorder)).play

RandDelayNetwork(\default).
