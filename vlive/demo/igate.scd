
(
	Event.partialEvents.playerEvent.releaseCustomGate = #{ arg releaseTime, gateName;
		var sendGate, msg;
		if(~id.notNil) {

			releaseTime.debug("releaseTime");
			//releaseTime = if(releaseTime.isNil) { 0.0 } { -1.0 - releaseTime };
			~id.debug("id!!");

			~server.sendBundle(~server.latency + releaseTime,
				*["/n_set", ~id, gateName, 0].flop.debug("bundle")
			);
		} 
	};

	SynthDef(\party, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		//freq = freq * ( 1 + ( Env.adsr(0.01,0.1,0.8,0.1).kr(\igate.kr(1).poll, doneAction:0) * 4 ) );
		sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq * 1/3 * ( 1 + ( SinOsc.kr(1/23) * 1 ))) * 1 )));
		sig = sig * EnvGen.kr(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = sig * EnvGen.kr(Env.adsr(0.1,0.1,0.8,0.1), \igate.kr(1), doneAction:0, levelBias:0);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
);

(
	Pdef(\mimi, Pmono(
		\party,
		//\freq, Pseq([200,400],inf),
		\degree, Pseq([
			0,2,4,7
		].mirror,inf),
		\dur, 1,
		\amp, 0.1,
		\ilegato, 0.4,
		\legato, 1,
		\igate, 1,
		\finish, { arg ev;
			//ev.use { Event.partialEvents.playerEvent.eventTypes[\note].value }
			var releaseTime = ~ilegato.value * ~dur.value / thisThread.clock.tempo + ~lag;
			~freq.debug("freq");
			releaseTime.debug("rel");
			Event.partialEvents.playerEvent[\releaseCustomGate].(releaseTime, "igate");

			"gla".debug;
			//Event.partialEvents.playerEvent.play;
		}
	)).play;
)

s.sendBundle(0.2, ["/n_set", 1001, "igate", 0])
