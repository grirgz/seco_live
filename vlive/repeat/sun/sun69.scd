~t = 127/2/60; TempoClock.default.tempo = ~t;
(
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)
(
	// generate fmc
	~genfmc_long = {

		SynthDef(\fmc_ambientchords, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			var num=20;
			thisThread.randSeed = 100000.rand.debug("seed");
			sig = num.collect { arg idx;
				var isig;
				var oscgen = {
					[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
				};
				var harms = [1,2,4,1/2,1/4];
				var fenv;
				isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
				isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2)),gate,doneAction:0);
				fenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2)),gate,doneAction:0);
				fenv = fenv * rrand(0.1,8) + rrand(0.1,2);
				isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), \rq.kr(0.5));
				isig;
			};
			sig = sig.clump(2).flop.mean;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
			//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
			sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
			Out.ar(out, sig);
		}).add;
	};
	~genfmc_long.();

	~genfmc = {

		SynthDef(\fmc_short, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			var num=10;
			sig = num.collect { arg idx;
				var isig;
				var oscgen = {
					[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
				};
				isig = oscgen.value.ar(oscgen.value.ar(freq * [1,2,1/2,1/4].choose) * freq * [1,2,1/2,1/4].choose + rrand(0.001,0.1));
				isig;
			};
			sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.5));
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
			//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
			sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
			//sig = HPF.ar(sig, freq/4);
			sig = sig * \gain.kr(1);
			Out.ar(out, sig);
		}).add;
	};
	~genfmc.();
);

(
Pdef(\mel1, 
	Pbind(
		\instrument, \fmc_ambientchords,
		\amp, 0.1/2,
	)
);
NoteTimeline('mel1').param = Param(Pdef('mel1'), 'midinote');
NoteTimeline('mel1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.013797058108594, \label: 'start', \playDur: 0.013797058108594, \relDur: 0.013797058108594, \sustain: 0, \type: 'start', ),
	(\absTime: 0.013797058108594, \clockTime: 3201.2137970581, \dur: 0.051654545958172, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 0.051654545958172, \relDur: 0.051654545958172, \sustain: 3.4087687020915, ),
	(\absTime: 0.065451604066766, \clockTime: 3201.2654516041, \dur: 3.305919993642, \instrument: 'fmclustergen', \kitIndex: 65, \midinote: 65, \playDur: 3.305919993642, \relDur: 3.305919993642, \sustain: 3.8149015650001, ),
	(\absTime: 3.3713715977087, \clockTime: 3204.5713715977, \dur: 0.5206925768498, \instrument: 'fmclustergen', \kitIndex: 71, \midinote: 71, \playDur: 0.5206925768498, \relDur: 0.5206925768498, \sustain: 0.57898819093316, ),
	(\absTime: 3.8920641745585, \clockTime: 3205.0920641746, \dur: 0.056809365891695, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 0.056809365891695, \relDur: 0.056809365891695, \sustain: 3.5184539994002, ),
	(\absTime: 3.9488735404502, \clockTime: 3205.1488735405, \dur: 3.4432251408834, \instrument: 'fmclustergen', \kitIndex: 64, \midinote: 64, \playDur: 3.4432251408834, \relDur: 3.4432251408834, \sustain: 3.8972028206836, ),
	(\absTime: 7.3920986813337, \clockTime: 3208.5920986813, \dur: 0.51127846372492, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74, \playDur: 0.51127846372492, \relDur: 0.51127846372492, \sustain: 0.4708438015582, ),
	(\absTime: 7.9033771450586, \clockTime: 3209.1033771451, \dur: 0.0052846605003651, \instrument: 'fmclustergen', \kitIndex: 63, \midinote: 63, \playDur: 0.0052846605003651, \relDur: 0.0052846605003651, \sustain: 3.9655557753749, ),
	(\absTime: 7.9086618055589, \clockTime: 3209.1086618056, \dur: 3.4970540792415, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 3.4970540792415, \relDur: 3.4970540792415, \sustain: 3.5009146273583, ),
	(\absTime: 11.4057158848, \clockTime: 3212.6057158848, \dur: 0.52357714266645, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74, \playDur: 0.52357714266645, \relDur: 0.52357714266645, \sustain: 0.48059966744995, ),
	(\absTime: 11.929293027467, \clockTime: 3213.1292930275, \dur: 0.0034972910752913, \instrument: 'fmclustergen', \kitIndex: 62, \midinote: 62, \playDur: 0.0034972910752913, \relDur: 0.0034972910752913, \sustain: 4.0306077831083, ),
	(\absTime: 11.932790318542, \clockTime: 3213.1327903185, \dur: 2.0361741587412, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 2.0361741587412, \relDur: 2.0361741587412, \sustain: 2.0657048337416, ),
	(\absTime: 13.968964477283, \clockTime: 3215.1689644773, \dur: 1.9621382599089, \instrument: 'fmclustergen', \kitIndex: 71, \midinote: 71, \playDur: 1.9621382599089, \relDur: 1.9621382599089, \sustain: 1.935719453209, ),
	(\absTime: 15.931102737192, \clockTime: 3217.1311027372, \dur: 0.029810304657985, \instrument: 'fmclustergen', \kitIndex: 65, \midinote: 65, \playDur: 0.029810304657985, \relDur: 0.029810304657985, \sustain: 3.9267712062165, ),
	(\absTime: 15.96091304185, \clockTime: 3217.1609130419, \dur: 3.4427050473087, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 3.4427050473087, \relDur: 3.4427050473087, \sustain: 3.3910851437749, ),
	(\absTime: 19.403618089159, \clockTime: 3220.6036180892, \dur: 0.52571112154965, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74, \playDur: 0.52571112154965, \relDur: 0.52571112154965, \sustain: 0.45166744502467, ),
	(\absTime: 19.929329210709, \clockTime: 3221.1293292107, \dur: 0.0038357862918019, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 0.0038357862918019, \relDur: 0.0038357862918019, \sustain: 2.166499682317, ),
	(\absTime: 19.933164997, \clockTime: 3221.133164997, \dur: 2.0210678643416, \instrument: 'fmclustergen', \kitIndex: 64, \midinote: 64, \playDur: 2.0210678643416, \relDur: 2.0210678643416, \sustain: 3.9316836265416, ),
	(\absTime: 21.954232861342, \clockTime: 3223.1542328613, \dur: 1.9999505424666, \instrument: 'fmclustergen', \kitIndex: 79, \midinote: 79, \playDur: 1.9999505424666, \relDur: 1.9999505424666, \sustain: 1.8220782350168, ),
	(\absTime: 23.954183403809, \clockTime: 3225.1541834038, \dur: 0.0051719099001275, \instrument: 'fmclustergen', \kitIndex: 79, \midinote: 79, \playDur: 0.0051719099001275, \relDur: 0.0051719099001275, \sustain: 3.497865005992, ),
	(\absTime: 23.959355313709, \clockTime: 3225.1593553137, \dur: 3.4310407968669, \instrument: 'fmclustergen', \kitIndex: 63, \midinote: 63, \playDur: 3.4310407968669, \relDur: 3.4310407968669, \sustain: 3.9701440631247, ),
	(\absTime: 27.390396110576, \clockTime: 3228.5903961106, \dur: 0.63746757613308, \instrument: 'fmclustergen', \kitIndex: 67, \midinote: 67, \playDur: 0.63746757613308, \relDur: 0.63746757613308, \sustain: 0.67950356013307, ),
	(\absTime: 28.027863686709, \clockTime: 3229.2278636867, \dur: 0.042729337325, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 0.042729337325, \relDur: 0.042729337325, \sustain: 1.9540998594666, ),
	(\absTime: 28.070593024034, \clockTime: 3229.270593024, \dur: 1.8861548689915, \instrument: 'fmclustergen', \kitIndex: 62, \midinote: 62, \playDur: 1.8861548689915, \relDur: 1.8861548689915, \sustain: 1.8180248659746, ),
	(\absTime: 29.956747893025, \clockTime: 3231.156747893, \dur: 0.025871896017179, \instrument: 'fmclustergen', \kitIndex: 71, \midinote: 71, \playDur: 0.025871896017179, \relDur: 0.025871896017179, \sustain: 2.0795205562586, ),
	(\absTime: 29.982619789042, \clockTime: 3231.182619789, \dur: 2.0053186991163, \instrument: 'fmclustergen', \kitIndex: 62, \midinote: 62, \playDur: 2.0053186991163, \relDur: 2.0053186991163, \sustain: 1.826785977908, ),
	(\absTime: 31.987938488159, \clockTime: 3233.1879384882, \dur: 0.012061511841239, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 0.012061511841239, \relDur: 0.012061511841239, \sustain: 2.2557466389085, ),
	(\absTime: 32.0, \dur: 0.036990467567193, \label: 'end', \playDur: 0.036990467567193, \relDur: 0.036990467567193, \type: 'end', ),
	(\absTime: 32.036990467567, \clockTime: 3233.2369904676, \dur: 1.9824673287662, \instrument: 'fmclustergen', \kitIndex: 65, \midinote: 65, \playDur: 1.9824673287662, \relDur: 1.9824673287662, \sustain: 3.6962124608749, ),
	(\absTime: 34.019457796333, \clockTime: 3235.2194577963, \dur: 0.90715073310867, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74, \playDur: 0.90715073310867, \relDur: 0.90715073310867, \sustain: 1.0479021491751, ),
	(\absTime: 34.926608529442, \clockTime: 3236.1266085294, \dur: 0.94011908855828, \instrument: 'fmclustergen', \kitIndex: 76, \midinote: 76, \playDur: 0.94011908855828, \relDur: 0.94011908855828, \sustain: 0.98806298873342, ),
	(\absTime: 35.866727618, \clockTime: 3237.066727618, \dur: 0.048569133874935, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74, \playDur: 0.048569133874935, \relDur: 0.048569133874935, \sustain: 1.0963251748417, ),
	(\absTime: 35.915296751875, \clockTime: 3237.1152967519, \dur: 0.99379413149154, \instrument: 'fmclustergen', \kitIndex: 64, \midinote: 64, \playDur: 0.99379413149154, \relDur: 0.99379413149154, \sustain: 4.0851427906669, ),
	(\absTime: 36.909090883367, \clockTime: 3238.1090908834, \dur: 1.1477063099087, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 1.1477063099087, \relDur: 1.1477063099087, \sustain: 1.2369549249083, ),
	(\absTime: 38.056797193276, \clockTime: 3239.2567971933, \dur: 0.88283017807498, \instrument: 'fmclustergen', \kitIndex: 69, \midinote: 69, \playDur: 0.88283017807498, \relDur: 0.88283017807498, \sustain: 0.84414478744975, ),
	(\absTime: 38.939627371351, \clockTime: 3240.1396273714, \dur: 0.98969037202505, \instrument: 'fmclustergen', \kitIndex: 67, \midinote: 67, \playDur: 0.98969037202505, \relDur: 0.98969037202505, \sustain: 0.97808634498324, ),
	(\absTime: 39.929317743376, \clockTime: 3241.1293177434, \dur: 0.050082035133073, \instrument: 'fmclustergen', \kitIndex: 63, \midinote: 63, \playDur: 0.050082035133073, \relDur: 0.050082035133073, \sustain: 4.1199924214579, ),
	(\absTime: 39.979399778509, \clockTime: 3241.1793997785, \dur: 1.5450133279255, \instrument: 'fmclustergen', \kitIndex: 69, \midinote: 69, \playDur: 1.5450133279255, \relDur: 1.5450133279255, \sustain: 1.621203365833, ),
	(\absTime: 41.524413106434, \clockTime: 3242.7244131064, \dur: 0.56069971785791, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 0.56069971785791, \relDur: 0.56069971785791, \sustain: 0.39213065464946, ),
	(\absTime: 42.085112824292, \clockTime: 3243.2851128243, \dur: 1.8776267427916, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74, \playDur: 1.8776267427916, \relDur: 1.8776267427916, \sustain: 1.9645785924254, ),
	(\absTime: 43.962739567084, \clockTime: 3245.1627395671, \dur: 0.0044764039253096, \instrument: 'fmclustergen', \kitIndex: 62, \midinote: 62, \playDur: 0.0044764039253096, \relDur: 0.0044764039253096, \sustain: 4.3300109096417, ),
	(\absTime: 43.967215971009, \clockTime: 3245.167215971, \dur: 1.995504310566, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72, \playDur: 1.995504310566, \relDur: 1.995504310566, \sustain: 2.0519503400415, ),
	(\absTime: 45.962720281575, \clockTime: 3247.1627202816, \dur: 0, \instrument: 'fmclustergen', \kitIndex: 71, \midinote: 71, \playDur: 0, \relDur: 0, \sustain: 2.1605144527757, ),
]);
);

(
Pdef(\mel2, 
	Pbind(
		\instrument, \fmc_ambientchords2,
		\amp, 0.1/2,
	)
);
NoteTimeline('mel2').param = Param(Pdef('mel2'), 'midinote');
NoteTimeline('mel2').eventList = TimelineEventList.newFrom([
	(\absTime: -0.012061511841239, \clockTime: 3233.1879384882, \dur: 0.012061511841239, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72.0, \playDur: 0.012061511841239, \relDur: 0.012061511841239, \sustain: 2.2557466389085, ),
	(\absTime: 0, \dur: 0.036990467567193, \label: 'start', \playDur: 0.036990467567193, \relDur: 0.036990467567193, \sustain: 0, \type: 'start', ),
	(\absTime: 0.036990467567193, \clockTime: 3233.2369904676, \dur: 1.9824673287662, \instrument: 'fmclustergen', \kitIndex: 65, \midinote: 65.0, \playDur: 1.9824673287662, \relDur: 1.9824673287662, \sustain: 3.6962124608749, ),
	(\absTime: 2.0194577963334, \clockTime: 3235.2194577963, \dur: 0.90715073310867, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74.0, \playDur: 0.90715073310867, \relDur: 0.90715073310867, \sustain: 1.0479021491751, ),
	(\absTime: 2.9266085294421, \clockTime: 3236.1266085294, \dur: 0.94011908855828, \instrument: 'fmclustergen', \kitIndex: 76, \midinote: 76.0, \playDur: 0.94011908855828, \relDur: 0.94011908855828, \sustain: 0.98806298873342, ),
	(\absTime: 3.8667276180004, \clockTime: 3237.066727618, \dur: 0.048569133874935, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74.0, \playDur: 0.048569133874935, \relDur: 0.048569133874935, \sustain: 1.0963251748417, ),
	(\absTime: 3.9152967518753, \clockTime: 3237.1152967519, \dur: 0.99379413149154, \instrument: 'fmclustergen', \kitIndex: 64, \midinote: 64.0, \playDur: 0.99379413149154, \relDur: 0.99379413149154, \sustain: 4.0851427906669, ),
	(\absTime: 4.9090908833668, \clockTime: 3238.1090908834, \dur: 1.1477063099087, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72.0, \playDur: 1.1477063099087, \relDur: 1.1477063099087, \sustain: 1.2369549249083, ),
	(\absTime: 6.0567971932755, \clockTime: 3239.2567971933, \dur: 0.88283017807498, \instrument: 'fmclustergen', \kitIndex: 69, \midinote: 69.0, \playDur: 0.88283017807498, \relDur: 0.88283017807498, \sustain: 0.84414478744975, ),
	(\absTime: 6.9396273713505, \clockTime: 3240.1396273714, \dur: 0.98969037202505, \instrument: 'fmclustergen', \kitIndex: 67, \midinote: 67.0, \playDur: 0.98969037202505, \relDur: 0.98969037202505, \sustain: 0.97808634498324, ),
	(\absTime: 7.9293177433756, \clockTime: 3241.1293177434, \dur: 0.050082035133073, \instrument: 'fmclustergen', \kitIndex: 63, \midinote: 63.0, \playDur: 0.050082035133073, \relDur: 0.050082035133073, \sustain: 4.1199924214579, ),
	(\absTime: 7.9793997785087, \clockTime: 3241.1793997785, \dur: 1.5450133279255, \instrument: 'fmclustergen', \kitIndex: 69, \midinote: 69.0, \playDur: 1.5450133279255, \relDur: 1.5450133279255, \sustain: 1.621203365833, ),
	(\absTime: 9.5244131064342, \clockTime: 3242.7244131064, \dur: 0.56069971785791, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72.0, \playDur: 0.56069971785791, \relDur: 0.56069971785791, \sustain: 0.39213065464946, ),
	(\absTime: 10.085112824292, \clockTime: 3243.2851128243, \dur: 1.8776267427916, \instrument: 'fmclustergen', \kitIndex: 74, \midinote: 74.0, \playDur: 1.8776267427916, \relDur: 1.8776267427916, \sustain: 1.9645785924254, ),
	(\absTime: 11.962739567084, \clockTime: 3245.1627395671, \dur: 0.0044764039253096, \instrument: 'fmclustergen', \kitIndex: 62, \midinote: 62.0, \playDur: 0.0044764039253096, \relDur: 0.0044764039253096, \sustain: 4.3300109096417, ),
	(\absTime: 11.967215971009, \clockTime: 3245.167215971, \dur: 1.995504310566, \instrument: 'fmclustergen', \kitIndex: 72, \midinote: 72.0, \playDur: 1.995504310566, \relDur: 1.995504310566, \sustain: 2.0519503400415, ),
	(\absTime: 13.962720281575, \clockTime: 3247.1627202816, \dur: 2.037279718425, \instrument: 'fmclustergen', \kitIndex: 71, \midinote: 71.0, \playDur: 2.037279718425, \relDur: 2.037279718425, \sustain: 2.1605144527757, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);
//////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1, 1,0, 1,1, 1,0,
				1,1, 1,0, 0,1, 1,0,
			],inf).stutter(4).coin.not,
			\dur, 1/8,
			\gain, 1/16,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1878].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			//\st, 184/4/60,
			\st, 183/4/60, // sound better, at 185bpm at least

			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\isRest, Pseq([
				1,1, 
			],inf).stutter(4).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		NoteTimeline(\mel1).asPattern,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).stutter(4).coin.not,
			\dur, 1/8,
			\gain, 1/16,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[25].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0.71,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,0.71,0,
				1,0,1,0, 1,0,0.71,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[280].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0.71,0,1,0, 1,0,0.51,
				0,1,0,1,0, 1,0,0.51,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pwhite(0.1,0.9),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[381].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			//\st, 184/4/60,
			\st, 183/4/60, // sound better, at 185bpm at least

			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\isRest, Pseq([
				1,1,0,0,
			],inf).stutter(4).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, Pseq([
				~fmgen_short.(234248),
				~fmgen_short.(234239),
				~fmgen_short.(234240),
				//~fmgen_cluster2.(24236,20),
			],inf),
			\timeScale, 0.1,
			\note, Pstep(Pseq([
				5,4,3,2,
			],inf),4)+12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\legato, 0.1/2 * Pseg(Pseq([1,10],inf),8),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmc_short,
			\sustain, 0.1,
		) <>
		NoteTimeline(\mel1).asPattern,
			Pbind(\instrument, \doublegran,
				\mbufnum, BufDef.mono("/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/ChapStickSlide_S08FO.567.wav"),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
				\mbufnum, BufDef.mono('voices/kaspi.flac'),
				\pos, Pseq([
					0.7,
					0.4,
					0.8,
					~pmodenv.(Pseq([0,1,0,0.5]+0.0,1), 4),
				],inf),
				//\pos, 0.40,
				//\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
				//\gdur, ~pmodenv.(Pseq([0.1,0.3,0.02],inf), 4),
				\gdur, 0.5,
				\gfreq, 440/2 * Pseq([
					0, -1, 2, 4,
				],inf).midiratio,
				//\gfreq, ~pmodenv.(Pseq([1,1.1]*16/2*~t,1), 8).loop,
				\dephase, 0.01,
				\gfreq, 8*~t,
				\gfreq, ~pmodenv.(Pseq([8,1],1), 8).loop,
				\asr, Pseq([
					[ Env.asr(0.1,0.8,2.1) ],
				],inf),
				\pitch_stretch, 1/2 * Pfunc({ arg ev; ev.use { ( ~freq.value.cpsmidi - (12*5) ).midiratio }  }).trace,
				\dur, 4,
				\legato, 0.3,
				\amp, 0.1,
			),
		
	])
)).play;
);
//////////////////////////////////////// draft



(
);

NoteTimeline(\mel1).edit
NoteTimeline(\mel1).presetCompileString.editorInsert

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				~fmgen_short.(234255),
				~fmgen_short.(234257),
				//~fmgen_short.(234239),
				//~fmgen_short.(234240),
				//~fmgen_cluster2.(24236,20),
			],inf),
			\timeScale, 0.1,
			\note, Pstep(Pseq([
				[0,-3],
				[0,-5],
				[0,-5, 3],
				[-5,-1,2],
			],inf),4)+12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\dur, 1/2,
			\legato, 0.1/2 * Pseg(Pseq([1,10],inf),8),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmc_short,
			\sustain, 0.1,
		) <>
		NoteTimeline(\mel1).asPattern,
		
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
				[-7,-3,0],
				[-8,-5,0],
				[0,-5, 3],
				[-5,-1,2],
		],inf),4),
		\arp, Plazy({ arg ev;
			if(ev[\arp].notNil) {
				ev[\arp]
			} {
				Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,8*16,
			\instrument, Pseq([
				~fmgen_short.(234264),
				//~fmgen_short.(234255),
				//~fmgen_short.(234255),
				//~fmgen_short.(234257),
				//~fmgen_short.(234258),
				//~fmgen_short.(234258),
				//~fmgen_short.(234258),
				//~fmgen_short.(234263),
				//~fmgen_short.(234239),
				//~fmgen_short.(234240),
				//~fmgen_cluster2.(24236,20),
			],inf),
			\arp, Pseq([
				0,0,0,0, 0,0,1,0,
				2,0,3,0, 4,0,5,0,
				0,0,0,0, 0,0,6,0,
				7,8,8,0, 9,0,10,0,
			],inf),
			\timeScale, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			\legato, 2,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pbind(
			\instrument, \fmc_short,
			\sustain, 0.1,
		) <>
		NoteTimeline(\mel1).asPattern,
		
	])
)).play;
)

(
Pdef(\melo, 
	Pbind(
		\instrument, \fmc_short,
		\instrument, ~fmgen_short.(24253),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.5) ],
		],inf),
		//\out, BusDef(\sendbus1, \audio),
		\amp, 0.1/2,
		\out, 0,
	)
)
);
(
Pdef(\melo, 
	Pbind(
		\instrument, \fmc_ambientchords,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))


MIDIMap(\apk9, Param(Pdef(\melo), \gain))
MIDIMap(\apend, { ~genfmc.() });
MIDIMap(\apright, { ~genfmc_long.() });
MIDIMap(\applay, { Pdef(\part).play });
MIDIMap(\apstop, { Pdef(\part).stop });
Param(Pdef(\melo), \gain).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmc_ambientchords,
			\note, Pseq([
				-2,-3,
			],inf),
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			2000.do {
				sp.par(
					Pbind(
						\instrument, \default,
						\note, Pseq([
							Prand([
								2,3,6,7,9,10
							],1),
						],1),
						\octave, Prand([4,5],inf),
						\dur, rrand(1/8,2),
						\sustain, 0.1,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					).keep(14),
				);
				sp.wait(exprand(0.01,0.1));
			};
		}),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pspawner({ arg sp;
			20000.do {
				sp.par(
					Pbind(
						\instrument, \fmc_short,
						\note, Pseq([
							Prand([
								//2,3,6,7,9,10
								//0,5,7,10,
								0,2,3,4,5,11,

							],1) + 0*1,
						],1),
						\octave, Prand([4,5,6,7],inf),
						\dur, rrand(1/8,2),
						\sustain, 0.1,
						\amp, 0.1,
						\adsr, Pseq([
							Pfunc({ arg ev;
								[ Env.adsr(0.01,0.1,0.8,4.1.rand) ];
								[ Env.adsr(0.01,0.1,0.8,0.1.rand) ];
								[ Env.adsr(0.1.rand,0.1,0.8,4.1.rand) ];
							}),
						],inf),
						\out, BusDef(\sendbus1, \audio),
					).keep(14),
				);
				sp.wait(exprand(0.1,1.1));
			};
		}),
		
	])
)).play;
);


NoteTimeline(\mel2, Pdef(\mel2)).edit
NoteTimeline(\mel2, Pdef(\mel2)).presetCompileString.editorInsert

(
);

(
SynthDef(\fmc_ambientchords2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=20;
	//thisThread.randSeed = 100000.rand.debug("seed");
	//thisThread.randSeed = 10019;
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse,LFCub].wchoose([1,0.1,0.1].normalizeSum)
		};
		var harms = [1,2,4,1/2,1/4];
		var fenv;
		var lfo1 = SinOsc.kr(rrand(0.01,1)).range(0,1) * 0.01 + 1;
		isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * lfo1 * harms.choose + rrand(0.01,0.2));
		isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.1,1),rrand(0.1,2)),gate,doneAction:0);
		fenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.1,1),rrand(0.1,2)),gate,doneAction:0);
		fenv = fenv * rrand(0.1,8) + rrand(0.1,2);
		isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), \rq.kr(0.5));
		isig;
	};
	sig = sig.clump(2).flop.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
)



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1248].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1895].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
Ndef(\rdn).map(\delay, Ndef(\lfo1, { XLine.kr(0.00001,0.005,16/~t) }));
);
