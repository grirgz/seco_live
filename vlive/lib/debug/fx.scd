
//////////////////////////////////////////////////////////////////// debug


steps
- load project
- launch fx
- launch synth

steps
- load project
- launch synth
- launch fx

steps
- load project
- launch synth
- define fx
- reload synth
- launch fx

steps
- load project
- launch fx
- define fx
- reload synth
- launch synth

steps
- load project
- define fx
- launch fx
- reload synth
- launch synth


//// steps for crashing server


steps
- boot sc
- load project
- cmd period
- launch synth
- launch fx
- define_effect // crash

steps 2
- reboot server
- load project
- cmd period
- launch synth
- launch fx
- define_effect // crash

step 3
- reboot server
- load project
- cmd period
- define_effect // no crash
- launch synth
- launch fx
- define_effect // crash

step 4
- reboot server
- load project
- cmd period
- define_effect // no crash
- launch fx
- define_effect // crash

step 5
- reboot server
- load project
- cmd period
- define_effect // no crash
- load fx node
	~fx_channel.();
	~make_fx.();
- define_effect // crash

step 6
- reboot server
- load project
- cmd period
- define_effect // no crash
- load fx node
	~make_fx.();
- define_effect // crash


step b1 ------------------------------
- boot sc
- load project
- cmd period
- launch fx
Ndef('testme_fx-56fx').set(\inbus, BusDef('testme_fxfx1')); // crash

step b2 ------------------------------
- boot sc
- load project
- cmd period
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);
BusDef('testme_fxfx1') // not nil
Ndef(\plop).set(\inbus, BusDef('testme_fxfx1')) // crash

step b3 ------------------------------
- boot sc
- cmd period
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);
BusDef('testme_fxfx1', \audio) // not nil
Ndef(\plop).set(\inbus, BusDef('testme_fxfx1')) // NO crash
- load project
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);
BusDef('testme_fxfx1', \audio) // not nil
Ndef(\plop).set(\inbus, BusDef('testme_fxfx1')) // crash

step b4 ------------------------------
- boot sc
- load project
- cmd period
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);
~bus1 = Bus.audio(s, 2);
Ndef(\plop).set(\inbus, ~bus1) // crash

step b5 ------------------------------
- boot sc
- load project
- cmd period
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);
~bus1 = Bus.audio(s, 2);
~bus1.index;
Ndef(\plop).set(\inbus, ~bus1.index) // NO crash
Ndef(\plop).set(\inbus, ~bus1) // NO crash
- cmd period
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);
Ndef(\plop).set(\inbus, ~bus1) // crash
// c'est sans .index que ca crash!!!!!
// mais pourquoi je doit loader le project pour que ca crash ???

step b6 ------------------------------

- boot sc
- load project
- cmd period
- launch fx
Ndef('testme_fx-56fx').set(\inbus, BusDef('testme_fxfx1').index); // NO crash
// ok j'ai mon workaround, meme si ca reste bizarre...






step 7 ------------------------------ BROKEN
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);

Ndef(\plop).set(\inbus, ~fx1)

step 8
(
~bus1 = Bus.audio(s, 2);
~bus2 = Bus.audio(s, 2);
)
(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(~bus1), 2);
	sigin = sigin * preamp;
	sigin;
});
);

Ndef(\plop).set(\inbus, ~bus2)
Ndef(\plop).clear
