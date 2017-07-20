
FileSystemProject.load("lib/synth.scd");
[\zoscsampler].do({ arg x; MenuSpecDef(\patkitdef_synthdefs).addUnique(x) });

FileSystemProject.load("algokit/kits/PatKitDef_drumwork.scd");
FileSystemProject.load("algokit/lines/KitTimeline_drumwork.scd");
PatKitDef(\drumwork).edit
PatKitDef(\drumwork).clear
KitTimeline(\drumwork, PatKitDef(\drumwork)).edit
KitTimeline(\drumwork2, PatKitDef(\drumwork)).edit
KitTimeline(\drumwork).clear
KitTimeline(\drumwork).outBus = BusDef(\sendbus0, \audio)
ProtoDef(\rdn).edit

StepEvent.newFrom((\instrument:\bli, \fmfs:[ [2,3,4,5] ])).play

(
SynthDef(\bli, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(\fmf.kr(1) * ( 1 + ( SinOsc.ar(\fmfs.kr([1,1,1,1])) * \fmamps.kr([1,1,1,1]) ))) * \fmamp.ar(1) )));
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
MenuSpecDef(\patkitdef_synthdefs).addUnique(\bli);
);

PatKitDef(\drumwork_test).edit
PatKitDef(\drumwork_test).clear
Log(\Param).level = \debug


(
SynthDef(\zoscsampler, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh * \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou.debug("oscsampler4");
	ou = ou.clump(2).flop.collect({
		DelayL.ar(ou, 0.02,0.02.rand * \delay.kr(0.01)) + ou;
	})/3;
	ou.debug("oscsampler4, 2");
	ou = ou.flat;
	ou.debug("oscsampler4, 3");
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	posenv: XEnvSpec.new,
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).store;
)
