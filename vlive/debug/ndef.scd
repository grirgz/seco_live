


Buffer.readChannel( s,  Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff",
channels:[0],
action:{|buffer|
~pbuf = Ndef(\pbuf, {|rate = 1.0, loop = 1|
PlayBuf.ar(buffer.numChannels, buffer, rate.lag(0.3), loop:loop)});
}
);

//:

~pbuf.fadeTime = 2;

~pbuf.play;

~pbuf.stop;
Ndef(\pbuf).play
Ndef(\pbuf).stop
Ndef(\pbuf).end
~pbuf2 = Ndef(\pbuf)
~pbuf2.play;


Ndef(\bla, { SinOsc.ar(100)!2 })
Ndef(\bla).play(fadeTime:2)
Ndef(\bla).play
Ndef(\bla).end
Ndef(\bla).stop(fadeTime:2)
Ndef(\bla).stop
Ndef(\bla).fadeTime = 2;

Ndef(\bla2, { SinOsc.ar(100)!2 })
Ndef(\bla2).play(fadeTime:2)
Ndef(\bla2).play
Ndef(\bla2).end
Ndef(\bla2).stop(fadeTime:2)
Ndef(\bla2).stop
Ndef(\bla2).fadeTime = 2;
NodeProxy
CmdPeriod.run


(
CmdPeriod.run;
Ndef(\bla2, { SinOsc.ar(100)!2 });
Ndef(\bla2).play
	
)

(
CmdPeriod.run;
Ndef(\bla, { SinOsc.ar(100)!2 });
Ndef(\bla).play
	
)

Ndef(\bla).fadeTime
Ndef(\bla).monitor.fadeTime
Ndef(\bla2).monitor.fadeTime
