(
SynthDef(\gri, {arg out=0, slave = 200.1, soft = 100.1, hard = 50.1, mod = 150.1, gate=1;
	var soft_sync = ToggleFF.ar((Impulse.ar(soft))) * 2 - 1;
	var freq = slave * soft_sync * RadiansPerSample.ir;
	var phasor = Phasor.ar(Impulse.ar(hard), freq, end: 2pi);
	var pm = SinOsc.ar(mod) * 2pi;
	var sig = SinOsc.ar(0, phasor + pm);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig);
	Out.ar(out, sig);
}).add
)

(
Pdef(\rich, {
	Ppar(1.collect {
		Pbind(
			\instrument, \gri,
			\slave, Pwhite(10,1000),
			\soft, Pwhite(10,1000),
			\hard, Pwhite(10,1000),
			\mod, Pwhite(10,1000),
			\legato, 1,
			\dur, 1/4,
		)
	})
}).play
)

on commence avec un PresetEvent pour tester le synthdef
ensuite on ajoute un sequencage (isRest ou timeline)
puis on met le tout sur une clip timeline (chaque clip est un sequencage)
on veut plusieurs sequencages pour avoir le choix dans la cliptimeline
comment on fait pour avoir plusieurs presets differents ? une track pour chaque preset ?
ou met on les modulators sur la timeline ? si on les met dans les sequencers, ca veut dire qu'on peut pas avoir un modulator qui fait plusieurs clips ?
	ou alors le modulator fait toute la timeline
et pour les fx ?
	insert fx, on pourrait le mettre dans le track
		track = PresetEvent + NotePattern + StepEvent + Modulation + InsertFx + SendFx + Mixer
			each part can be a timeline
			modulation can modulate InsertFx, SendFx, Mixer
			sideband: Modulation + InsertFx + Mixer

		NotePattern can be a StepList or noteTimeline

	model for multi instrument:
		track = [PresetEvent] + [StepEvent] + NotePattern + [Modulation] + InsertFx + SendFx + Mixer

		what if we want to include a preset in each event in NotePattern timeline
