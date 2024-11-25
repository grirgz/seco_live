// i have not tested but i guess it is possible to have several synth in a single group and each synth listen to the bus, if it receive an impulse, it write 0 to the bus so the next synth doesn't see the impulse. If the synth is already playing a file, it does not write 0 and the next synth in group will process the input

(
SynthDef(\trigplayer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum,speed=1, pos=0, trigbus=0, loop=0;
	var sig;
	var doneplaying;
	var trig;
	var bufgate;
	var reset;
	var isBusy;
	var bufenv;
	var donegate;
	donegate = LocalIn.kr(1, 0);
	trig = In.kr(trigbus,1);
	donegate.poll;
	~pollgui.(trig, "trig");
	~pollgui.(donegate, "donegate");
	~pollgui.(PulseCount.kr(trig), "trigcount");
	//~pollgui.(isBusy, "isBusy");
	//reset.poll;
	//trig.poll;
	//isBusy.poll;
	trig = trig * donegate.clip(0,1);
	//Out.kr(trigbus, trig * donegate.clip(0,1));
	Out.kr(trigbus, trig);
	~pollgui.(trig * donegate, "trig*donegate");
	bufgate = ( PulseCount.kr(trig) > 0 );
	//bufgate.poll;
	~pollgui.(bufgate, "bufgate");
	//bufenv = EnvGen.ar(Env.adsr(0.1,0.1,1,0.1,1),bufgate,doneAction:0);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trig, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	doneplaying = Done.kr(sig.first);
	sig = sig * bufgate;
	~pollgui.(doneplaying, "doneplaying");
	~pollgui.(1-doneplaying, "doneplaying inv");
	LocalOut.kr([doneplaying ]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\trigplayer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum,speed=1, pos=0, trigbus=0, loop=0;
	var sig;
	var doneplaying;
	var trig;
	var bufgate;
	var reset;
	var isBusy;
	var bufenv;
	var donegate;
	var nexttrig;
	donegate = LocalIn.kr(1, 0);
	trig = In.kr(trigbus,1);
	donegate.poll;
	~pollgui.(trig, "trig");
	~pollgui.(donegate, "donegate");
	~pollgui.(PulseCount.kr(trig), "trigcount");
	//~pollgui.(isBusy, "isBusy");
	//reset.poll;
	//trig.poll;
	//isBusy.poll;
	trig = trig.clip(-1,1);
	nexttrig = PulseDivider.kr(trig, 20);
	//trig = trig * donegate.clip(0,1);
	//Out.kr(trigbus, trig * donegate.clip(0,1));
	~pollgui.(trig * donegate, "trig*donegate");
	bufgate = ( PulseCount.kr(trig) > 0 );
	//bufgate.poll;
	~pollgui.(bufgate, "bufgate");
	//bufenv = EnvGen.ar(Env.adsr(0.1,0.1,1,0.1,1),bufgate,doneAction:0);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trig, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	doneplaying = Done.kr(sig.first);
	ReplaceOut.kr(trigbus, trig * ( 1-doneplaying ) );
	sig = sig * bufgate;
	~pollgui.(doneplaying, "doneplaying");
	~pollgui.(doneplaying, "doneplaying2");
	~pollgui.(1-doneplaying, "doneplaying inv");
	LocalOut.kr([1-doneplaying ]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

~smp = BufDef(\moeten, "voices/02_moeten.flac")

BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
(
GroupDef(\triggroup);
(\instrument: \trigplayer, trigbus: BusDef(\tt, \control, 1), sustain:inf, bufnum: ~smp, group: GroupDef(\triggroup)).play;
(\instrument: \trigplayer, trigbus: BusDef(\tt, \control, 1), sustain:inf, bufnum: ~smp, group: GroupDef(\triggroup)).play;
(\instrument: \trigplayer, trigbus: BusDef(\tt, \control, 1), sustain:inf, bufnum: ~smp, group: GroupDef(\triggroup)).play;
)

WindowDef(\PollGui).front
BusDef(\tt).set(0)
(\instrument: \trigplayer, trigbus: BusDef(\tt, \control, 1), sustain:inf, bufnum: ~smp).play
Ndef(\starter,{ Out.kr(BusDef(\tt),Impulse.kr(1/2)) }).send;
Pbind(
	\instrument, \playersec,
	\bufnum, ,
	\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\gain, 0.1,
),
Pbind(
	\instrument, \playersec,
	\bufnum, BufDef('voices/feynman.flac'),
	\pos, 0,
	\legato, 1,
	\dur, 1,
	\gain, 1,
)



///////////


(
SynthDef(\trigplayer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum,speed=1, pos=0, trigbus=0, loop=0;
	var sig;
	var doneplaying;
	var trig;
	var bufgate;
	var reset;
	var isBusy;
	var bufenv;
	var donegate;
	donegate = LocalIn.kr(1, 0);
	donegate.poll;
	~pollgui.(donegate, "donegate");
	doneplaying = Done.kr(Line.kr(0,1,1));
	LocalOut.kr([doneplaying ]);
	sig = SinOsc.ar(freq) * 0.01; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);
(\instrument: \trigplayer, trigbus: BusDef(\tt, \control, 1), sustain:inf, bufnum: ~buflib.kick[1010].value).play
