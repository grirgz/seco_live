//////////////// original PdefGUI version
(

// SynthDef:
SynthDef(\bassPluck, {
	arg out=0, freq=55, gate=1, amp=1.3, pan=0, atk=0.006, dec=0.35, sus=0.4, rel=0.3, atkCf=0.004, relCf=0.4, ampBody=1.0, driftBodySemi=0.0, cfBodySemi=55, baseCfSemi=24, driftCfSemi=0.0, envCfSemi=48.0, cfMin=20, cfMax=18000, res=2.0, drive=1.8;
	var envAmp, envCf, cfBody, cf, sig;
	envAmp = Env.adsr(atk, dec, sus, rel, curve: [-4, -2, -2]).ar(2, gate);
	envCf = Env.perc(atkCf, relCf, curve: -4).ar(0, gate);
	cfBody = (freq * cfBodySemi.midiratio).clip(20, 18000);
	sig = LPF.ar(Saw.ar(freq * driftBodySemi.midiratio, ampBody), cfBody);
	sig = LeakDC.ar((sig * drive).tanh);
	cf = (freq * (baseCfSemi + driftCfSemi + (envCf * envCfSemi)).midiratio).clip(cfMin, cfMax);
	sig = MoogFF.ar(sig, cf, res);
	sig = LeakDC.ar(sig);
	sig = sig * envAmp * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;


// Specs:
Spec.add(\amp, [0.0, 2.0, \lin, 0.01, 1.3]);
Spec.add(\pan, [-1.0, 1.0, \lin, 0.01, 0.0]);
Spec.add(\atk, [0.001, 3.0, \exp, 0.001, 0.006]);
Spec.add(\dec, [0.001, 6.0, \exp, 0.001, 0.35]);
Spec.add(\sus, [0.0, 1.0, \lin, 0.01, 0.4]);
Spec.add(\rel, [0.001, 8.0, \exp, 0.001, 0.3]);
Spec.add(\atkCf, [0.001, 3.0, \exp, 0.001, 0.004]);
Spec.add(\relCf, [0.001, 6.0, \exp, 0.001, 0.4]);
Spec.add(\ampBody, [0.0, 2.0, \lin, 0.01, 1.0]);
Spec.add(\cfBodySemi, [-24, 108, \lin, 0.1, 55]);
Spec.add(\baseCfSemi, [-72, 108, \lin, 0.1, 24]);
Spec.add(\envCfSemi, [-72, 108, \lin, 0.1, 48.0]);
Spec.add(\cfMin, [20, 2000, \exp, 1, 20]);
Spec.add(\cfMax, [2000, 20000, \exp, 1, 18000]);
Spec.add(\res, [0.0, 4.0, \lin, 0.01, 2.0]);
Spec.add(\drive, [0.1, 20.0, \exp, 0.01, 1.8]);


// Pdef-Umgebung:
Pdef(\bassA).set(\amp, 1.3);
Pdef(\bassA).set(\pan, 0.0);
Pdef(\bassA).set(\atk, 0.006);
Pdef(\bassA).set(\dec, 0.35);
Pdef(\bassA).set(\sus, 0.4);
Pdef(\bassA).set(\rel, 0.3);
Pdef(\bassA).set(\atkCf, 0.004);
Pdef(\bassA).set(\relCf, 0.4);
Pdef(\bassA).set(\ampBody, 1.0);
Pdef(\bassA).set(\cfBodySemi, 55);
Pdef(\bassA).set(\baseCfSemi, 24);
Pdef(\bassA).set(\envCfSemi, 48.0);
Pdef(\bassA).set(\cfMin, 20);
Pdef(\bassA).set(\cfMax, 18000);
Pdef(\bassA).set(\res, 2.0);
Pdef(\bassA).set(\drive, 1.8);


// Pattern:
Pdef(\bassA,
	Pbind(
		\instrument, \bassPluck,
		\scale, Scale.minor,
		\root, 0,
		\degree, Pseq([0, 0, -2, 0, 3, 0, -5, -2], inf),
		\octave, 3,
		\dur, Pseq([0.5, 0.5, 0.75, 0.5, 0.5, 0.75], inf),
		// Optional: \legato, 0.7,
		\driftBodySemi, Pbrown(-0.15, 0.15, 0.03, inf),
		\driftCfSemi, Pbrown(-1.5, 1.5, 0.08, inf)
	)
);

Pdef(\bassA).play;


// GUI:
~guiBassA = PdefGui(Pdef(\bassA), 16);

{
	~guiBassA.envirGui.editKeys.do {
		arg key, i;
		var paramView;
		paramView = ~guiBassA.envirGui.paramViews[i];

		if([\atk, \dec, \rel, \atkCf, \relCf].includes(key)) {
			paramView.slider.numberView.decimals_(3);
		};

		paramView.slider.value_(Pdef(\bassA).envir[key]);
	};
}.defer;

)




////////////////////////// original custom GUI version
(

// SynthDef:
SynthDef(\bassPluck, {
	arg out=0, freq=55, gate=1, amp=1.3, pan=0, atk=0.006, dec=0.35, sus=0.4, rel=0.3, atkCf=0.004, relCf=0.4, ampBody=1.0, driftBodySemi=0.0, cfBodySemi=55, baseCfSemi=24, driftCfSemi=0.0, envCfSemi=48.0, cfMin=20, cfMax=18000, res=2.0, drive=1.8;
	var envAmp, envCf, cfBody, cf, sig;
	envAmp = Env.adsr(atk, dec, sus, rel, curve: [-4, -2, -2]).ar(2, gate);
	envCf = Env.perc(atkCf, relCf, curve: -4).ar(0, gate);
	cfBody = (freq * cfBodySemi.midiratio).clip(20, 18000);
	sig = LPF.ar(Saw.ar(freq * driftBodySemi.midiratio, ampBody), cfBody);
	sig = LeakDC.ar((sig * drive).tanh);
	cf = (freq * (baseCfSemi + driftCfSemi + (envCf * envCfSemi)).midiratio).clip(cfMin, cfMax);
	sig = MoogFF.ar(sig, cf, res);
	sig = LeakDC.ar(sig);
	sig = sig * envAmp * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;


// Lokale Specs:
~bassAGuiSpecs = IdentityDictionary();
~bassAGuiSpecs[\amp] = ControlSpec(0.0, 2.0, \lin, 0.01, 1.3);
~bassAGuiSpecs[\pan] = ControlSpec(-1.0, 1.0, \lin, 0.01, 0.0);
~bassAGuiSpecs[\atk] = ControlSpec(0.001, 3.0, \exp, 0.001, 0.006);
~bassAGuiSpecs[\dec] = ControlSpec(0.001, 6.0, \exp, 0.001, 0.35);
~bassAGuiSpecs[\sus] = ControlSpec(0.0, 1.0, \lin, 0.01, 0.4);
~bassAGuiSpecs[\rel] = ControlSpec(0.001, 8.0, \exp, 0.001, 0.3);
~bassAGuiSpecs[\atkCf] = ControlSpec(0.001, 3.0, \exp, 0.001, 0.004);
~bassAGuiSpecs[\relCf] = ControlSpec(0.001, 6.0, \exp, 0.001, 0.4);
~bassAGuiSpecs[\ampBody] = ControlSpec(0.0, 2.0, \lin, 0.01, 1.0);
~bassAGuiSpecs[\cfBodySemi] = ControlSpec(-24, 108, \lin, 0.1, 55);
~bassAGuiSpecs[\baseCfSemi] = ControlSpec(-72, 108, \lin, 0.1, 24);
~bassAGuiSpecs[\envCfSemi] = ControlSpec(-72, 108, \lin, 0.1, 48.0);
~bassAGuiSpecs[\cfMin] = ControlSpec(20, 2000, \exp, 1, 20);
~bassAGuiSpecs[\cfMax] = ControlSpec(2000, 20000, \exp, 1, 18000);
~bassAGuiSpecs[\res] = ControlSpec(0.0, 4.0, \lin, 0.01, 2.0);
~bassAGuiSpecs[\drive] = ControlSpec(0.1, 20.0, \exp, 0.01, 1.8);


// Pdef-Umgebung:
~bassAGuiSpecs.keysValuesDo { |guiEntry, guiControlSpec|
	Pdef(\bassA).set(guiEntry, guiControlSpec.default);
};


// Pattern:
Pdef(\bassA,
	Pbind(
		\instrument, \bassPluck,
		\scale, Scale.minor,
		\root, 0,
		\degree, Pseq([0, 0, -2, 0, 3, 0, -5, -2], inf),
		\octave, 3,
		\dur, Pseq([0.5, 0.5, 0.75, 0.5, 0.5, 0.75], inf),
		\sustain, 0.3,
		\driftBodySemi, Pbrown(-0.15, 0.15, 0.03, inf),
		\driftCfSemi, Pbrown(-1.5, 1.5, 0.08, inf)
	)
);

Pdef(\bassA).play;


// GUI:
~bassAGuiEntries1 = [
	"Global", \amp, \pan,
	"Amplitude Envelope", \atk, \dec, \sus, \rel,
	"Body / Saw", \ampBody, \cfBodySemi
];

~bassAGuiEntries2 = [
	"Filter Envelope", \atkCf, \relCf, \baseCfSemi, \envCfSemi, \cfMin, \cfMax, \res,
	"Sättigung mit tanh", \drive
];

~bassAGuiFineNumberKeys = [\atk, \dec, \rel, \atkCf, \relCf];

~bassAGuiColumn1 = List(); ~bassAGuiColumn2 = List();

~bassAGuiWindow.notNil.if { ~bassAGuiWindow.close };

~bassAGuiWindow = Window("bassA", Rect(0, 0, 2 * 540, ~bassAGuiEntries1.size.max(~bassAGuiEntries2.size) * 30)).front;

~bassAGuiBuildColumns = { |guiEntries, guiColumn|

	guiEntries.do { |guiEntry|

		if(guiEntry.class == String) {

			var guiSectionText;

			guiSectionText = StaticText()
			.string_(guiEntry)
			.align_(\center)
			.stringColor_(Color.new(0, 0, 0.5))
			.background_(Color.gray(0.7, 1))
			.font_(Font.default.boldVariant);

			guiSectionText.fixedHeight_(25);

			guiColumn.add(guiSectionText);

		} {
			var guiEzSlider;

			guiEzSlider = EZSlider(
				parent: ~bassAGuiWindow,
				bounds: 500 @ 20,
				label: guiEntry.asString,
				controlSpec: ~bassAGuiSpecs[guiEntry],
				action: { |guiEzSliderView|
					Pdef(\bassA).set(guiEntry, guiEzSliderView.value);
				},
				initVal: Pdef(\bassA).envir[guiEntry],
				labelWidth: 120,
				numberWidth: 60,
				layout: \horz
			);

			guiEzSlider.view.fixedHeight_(20);

			guiEzSlider.numberView.decimals_(~bassAGuiFineNumberKeys.includes(guiEntry).if(3, 2));

			guiEzSlider.value_(Pdef(\bassA).envir[guiEntry]);
			guiEzSlider.view.refresh;

			guiColumn.add(guiEzSlider.view);
		};
	};
};


~bassAGuiBuildColumns.(~bassAGuiEntries1, ~bassAGuiColumn1);
~bassAGuiBuildColumns.(~bassAGuiEntries2, ~bassAGuiColumn2);

~bassAGuiWindow.layout_(HLayout(VLayout(*~bassAGuiColumn1), VLayout(*~bassAGuiColumn2)));


// Snapshots:

// Funktionsdefinition zum Öffnen eines Snapshots aller Pdef-Umgebungsparameter in einem neuen Dokument.
~bassAGuiSnapshotPdefEnvir = {
	Document.new(
		"bassA Snapshot / Pdef Envir",
		String.streamContents { |snapshotStream|
			snapshotStream << "(\n";

			Pdef(\bassA).envir.keysValuesDo { |guiEntry, pdefValue|
				snapshotStream << "Pdef(\\bassA).set(\\"
				<< guiEntry.asString
				<< ", "
				<< pdefValue.asCompileString
				<< ");\n";
			};

			snapshotStream << ")\n";
		}
	);
};

// Funktionsdefinition zum Öffnen eines Snapshots aller GUI-Parameter in GUI-Reihenfolge in einem neuen Dokument.
~bassAGuiSnapshotGuiEntries = {
	Document.new(
		"bassA Snapshot / GUI Entries",
		String.streamContents { |snapshotStream|
			snapshotStream << "(\n";

			(~bassAGuiEntries1 ++ ~bassAGuiEntries2).do { |guiEntry|
				if(guiEntry.class == String) {
					snapshotStream << "\n// " << guiEntry << ":\n";
				} {
					snapshotStream << "Pdef(\\bassA).set(\\"
					<< guiEntry.asString
					<< ", "
					<< Pdef(\bassA).envir[guiEntry].asCompileString
					<< ");\n";
				};
			};

			snapshotStream << ")\n";
		}
	);
};

)


// Manuelle Snapshot-Aufrufe:
~bassAGuiSnapshotPdefEnvir.();
~bassAGuiSnapshotGuiEntries.();




///////////////////// first idea
(
SynthDef(\bassPluck, {
	arg out=0, freq=55, gate=1, amp=1.3, pan=0, atk=0.006, dec=0.35, sus=0.4, rel=0.3, atkCf=0.004, relCf=0.4, ampBody=1.0, driftBodySemi=0.0, cfBodySemi=55, baseCfSemi=24, driftCfSemi=0.0, envCfSemi=48.0, cfMin=20, cfMax=18000, res=2.0, drive=1.8;
	var envAmp, envCf, cfBody, cf, sig;
	envAmp = Env.adsr(atk, dec, sus, rel, curve: [-4, -2, -2]).ar(2, gate);
	envCf = Env.perc(atkCf, relCf, curve: -4).ar(0, gate);
	cfBody = (freq * cfBodySemi.midiratio).clip(20, 18000);
	sig = LPF.ar(Saw.ar(freq * driftBodySemi.midiratio, ampBody), cfBody);
	sig = LeakDC.ar((sig * drive).tanh);
	cf = (freq * (baseCfSemi + driftCfSemi + (envCf * envCfSemi)).midiratio).clip(cfMin, cfMax);
	sig = MoogFF.ar(sig, cf, res);
	sig = LeakDC.ar(sig);
	sig = sig * envAmp * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;


Pdef(\bassA,
	Pbind(
		\instrument, \bassPluck,
		\scale, Scale.minor,
		\root, 0,
		\degree, Pseq([0, 0, -2, 0, 3, 0, -5, -2], inf),
		\octave, 3,
		\dur, Pseq([0.5, 0.5, 0.75, 0.5, 0.5, 0.75], inf),
		\sustain, 0.3,
		\driftBodySemi, Pbrown(-0.15, 0.15, 0.03, inf),
		\driftCfSemi, Pbrown(-1.5, 1.5, 0.08, inf)
	)
);


~bassAGuiSpecs = IdentityDictionary();
~bassAGuiSpecs[\amp] = ControlSpec(0.0, 2.0, \lin, 0.01, 1.3);
~bassAGuiSpecs[\pan] = ControlSpec(-1.0, 1.0, \lin, 0.01, 0.0);
~bassAGuiSpecs[\atk] = ControlSpec(0.001, 3.0, \exp, 0.001, 0.006);
~bassAGuiSpecs[\dec] = ControlSpec(0.001, 6.0, \exp, 0.001, 0.35);
~bassAGuiSpecs[\sus] = ControlSpec(0.0, 1.0, \lin, 0.01, 0.4);
~bassAGuiSpecs[\rel] = ControlSpec(0.001, 8.0, \exp, 0.001, 0.3);
~bassAGuiSpecs[\atkCf] = ControlSpec(0.001, 3.0, \exp, 0.001, 0.004);
~bassAGuiSpecs[\relCf] = ControlSpec(0.001, 6.0, \exp, 0.001, 0.4);
~bassAGuiSpecs[\ampBody] = ControlSpec(0.0, 2.0, \lin, 0.01, 1.0);
~bassAGuiSpecs[\cfBodySemi] = ControlSpec(-24, 108, \lin, 0.1, 55);
~bassAGuiSpecs[\baseCfSemi] = ControlSpec(-72, 108, \lin, 0.1, 24);
~bassAGuiSpecs[\envCfSemi] = ControlSpec(-72, 108, \lin, 0.1, 48.0);
~bassAGuiSpecs[\cfMin] = ControlSpec(20, 2000, \exp, 1, 20);
~bassAGuiSpecs[\cfMax] = ControlSpec(2000, 20000, \exp, 1, 18000);
~bassAGuiSpecs[\res] = ControlSpec(0.0, 4.0, \lin, 0.01, 2.0);
~bassAGuiSpecs[\drive] = ControlSpec(0.1, 20.0, \exp, 0.01, 1.8);


// Pdef-Umgebung:
~bassAGuiSpecs.keysValuesDo { |guiEntry, guiControlSpec|
	Pdef(\bassA).addSpec(guiEntry, guiControlSpec);
};

//Pdef(\bassA).edit
WindowDef(\bassA, {
	var target = Pdef(\bassA);
	
	~bassAGuiEntries1 = [
		"Global", \amp, \pan,
		"Amplitude Envelope", \atk, \dec, \sus, \rel,
		"Body / Saw", \ampBody, \cfBodySemi
	];

	~bassAGuiEntries2 = [
		"Filter Envelope", \atkCf, \relCf, \baseCfSemi, \envCfSemi, \cfMin, \cfMax, \res,
		"Sättigung mit tanh", \drive
	];

	~bassAGuiBuildColumns = { |guiEntries, guiColumn|

		guiEntries.do { |guiEntry|

			if(guiEntry.class == String) {

				var guiSectionText;

				guiSectionText = StaticText()
				.string_(guiEntry)
				.align_(\center)
				.stringColor_(Color.new(0, 0, 0.5))
				.background_(Color.gray(0.7, 1))
				.font_(Font.default.boldVariant);

				guiSectionText.fixedHeight_(25);

				guiColumn.add(guiSectionText);

			} {
				var guiEzSlider;

				guiEzSlider = Param(target, guiEntry).asView;

				guiColumn.add(guiEzSlider);
			};
		};
	};

	~bassAGuiColumn1 = List(); ~bassAGuiColumn2 = List();
	~bassAGuiBuildColumns.(~bassAGuiEntries1, ~bassAGuiColumn1);
	~bassAGuiBuildColumns.(~bassAGuiEntries2, ~bassAGuiColumn2);

	HLayout(VLayout(*~bassAGuiColumn1), VLayout(*~bassAGuiColumn2))


}).front;
)

// slider show default value of synthdef instead of default value of spec
// because synthdef will play with theses default values, not the ones of the specs
Param(Pdef(\bassA),\amp).spec
Param(Pdef(\bassA),\amp).default
Param(Pdef(\bassA),\amp).get
Param(Pdef(\bassA),\atk).instrument




/////////////////////// second idea
(
// SynthDef:
SynthDef(\bassPluck, {
	arg out=0, freq=55, gate=1, amp=1.3, pan=0, atk=0.006, dec=0.35, sus=0.4, rel=0.3, atkCf=0.004, relCf=0.4, ampBody=1.0, driftBodySemi=0.0, cfBodySemi=55, baseCfSemi=24, driftCfSemi=0.0, envCfSemi=48.0, cfMin=20, cfMax=18000, res=2.0, drive=1.8;
	var envAmp, envCf, cfBody, cf, sig;
	envAmp = Env.adsr(atk, dec, sus, rel, curve: [-4, -2, -2]).ar(2, gate);
	envCf = Env.perc(atkCf, relCf, curve: -4).ar(0, gate);
	cfBody = (freq * cfBodySemi.midiratio).clip(20, 18000);
	sig = LPF.ar(Saw.ar(freq * driftBodySemi.midiratio, ampBody), cfBody);
	sig = LeakDC.ar((sig * drive).tanh);
	cf = (freq * (baseCfSemi + driftCfSemi + (envCf * envCfSemi)).midiratio).clip(cfMin, cfMax);
	sig = MoogFF.ar(sig, cf, res);
	sig = LeakDC.ar(sig);
	sig = sig * envAmp * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;


// Lokale Specs:
~bassAGuiSpecs = IdentityDictionary();
~bassAGuiSpecs[\amp] = ControlSpec(0.0, 2.0, \lin, 0.01, 1.3);
~bassAGuiSpecs[\pan] = ControlSpec(-1.0, 1.0, \lin, 0.01, 0.0);
~bassAGuiSpecs[\atk] = ControlSpec(0.001, 3.0, \exp, 0.001, 0.006);
~bassAGuiSpecs[\dec] = ControlSpec(0.001, 6.0, \exp, 0.001, 0.35);
~bassAGuiSpecs[\sus] = ControlSpec(0.0, 1.0, \lin, 0.01, 0.4);
~bassAGuiSpecs[\rel] = ControlSpec(0.001, 8.0, \exp, 0.001, 0.3);
~bassAGuiSpecs[\atkCf] = ControlSpec(0.001, 3.0, \exp, 0.001, 0.004);
~bassAGuiSpecs[\relCf] = ControlSpec(0.001, 6.0, \exp, 0.001, 0.4);
~bassAGuiSpecs[\ampBody] = ControlSpec(0.0, 2.0, \lin, 0.01, 1.0);
~bassAGuiSpecs[\cfBodySemi] = ControlSpec(-24, 108, \lin, 0.1, 55);
~bassAGuiSpecs[\baseCfSemi] = ControlSpec(-72, 108, \lin, 0.1, 24);
~bassAGuiSpecs[\envCfSemi] = ControlSpec(-72, 108, \lin, 0.1, 48.0);
~bassAGuiSpecs[\cfMin] = ControlSpec(20, 2000, \exp, 1, 20);
~bassAGuiSpecs[\cfMax] = ControlSpec(2000, 20000, \exp, 1, 18000);
~bassAGuiSpecs[\res] = ControlSpec(0.0, 4.0, \lin, 0.01, 2.0);
~bassAGuiSpecs[\drive] = ControlSpec(0.1, 20.0, \exp, 0.01, 1.8);


// Pdef-Umgebung:
~bassAGuiSpecs.keysValuesDo { |guiEntry, guiControlSpec|
	Pdef(\bassA).set(guiEntry, guiControlSpec.default);
	Pdef(\bassA).addSpec(guiEntry, guiControlSpec); // add spec to this Pdef for Param to retrieve
};


// Pattern:
Pdef(\bassA,
	Pbind(
		\instrument, \bassPluck,
		\scale, Scale.minor,
		\root, 0,
		\degree, Pseq([0, 0, -2, 0, 3, 0, -5, -2], inf),
		\octave, 3,
		\dur, Pseq([0.5, 0.5, 0.75, 0.5, 0.5, 0.75], inf),
		\sustain, 0.3,
		\driftBodySemi, Pbrown(-0.15, 0.15, 0.03, inf),
		\driftCfSemi, Pbrown(-1.5, 1.5, 0.08, inf)
	)
);

Pdef(\bassA).play;
	 
WindowDef(\LabelBox, { arg def, name, params;
	var guiSectionText = StaticText()
	.string_(name)
	.align_(\center)
	.stringColor_(Color.new(0, 0, 0.5))
	.background_(Color.gray(0.7, 1))
	.font_(Font.default.boldVariant);

	VLayout (
		guiSectionText.fixedHeight_(25),
		params.asView,
	)
});
WindowDef(\bassA, {
	var target = Pdef(\bassA);
	var group = target.asParamGroup;
	
	HLayout (
		VLayout (
			WindowDef(\LabelBox).asView("Global", group.selectByProperty([ \amp,\pan ])),
			WindowDef(\LabelBox).asView("Amplitude Envelope", group.selectByProperty([ \atk,\dec,\sus,\rel ])),
			WindowDef(\LabelBox).asView("Body / Saw", group.selectByProperty([ \ampBody,\cfBodySemi ])),
		),
		VLayout (
			WindowDef(\LabelBox).asView("Filter Envelope", group.selectByProperty([ \atkCf, \relCf, \baseCfSemi, \envCfSemi, \cfMin, \cfMax, \res ])),
			WindowDef(\LabelBox).asView("Sättigung mit tanh", group.selectByProperty([ \drive ])),
		),
	);
}).front;
)

Pdef(\bassA).presetCompileString; // save string



