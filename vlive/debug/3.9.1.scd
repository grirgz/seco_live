
(
Ndef(\plop).parentGroup = GroupDef(\bla, 1, \addAfter);
//Ndef(\plop).play;
Ndef(\plop).play(0, 2, GroupDef(\bla));
//Ndef(\plop).group= GroupDef(\bla, 1, \addAfter);
);

Ndef(\plop).play(0, 2, GroupDef(\bla));
Ndef(\plop).group = GroupDef(\bla);
Ndef(\plop).play
Ndef(\plop).clear

Ndef(\plop).monitor.group = GroupDef(\bla, 1, \addAfter);
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
});
)
