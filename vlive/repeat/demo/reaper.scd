

MIDIClient.init
(
	~keys = nil!127;
MIDIdef.noteOn(\track1, { arg ... args;
	var midinote;
	args.postln;
	midinote = args[1];
	if(~keys[midinote].notNil) {
		~keys[midinote].release;
	};
	~keys[midinote] = Synth(\default, [\freq, args[1].midicps])
	
});
MIDIdef.noteOff(\track1_off, { arg ... args;
	var midinote;
	args.postln;
	midinote = args[1];
	~keys[midinote].release; 
	~keys[midinote] = nil;
	
});
)

//////////////////:



(
~connectTrack = { arg trackid, player;
	
}
)


//////////////////////////////////////
// proof of concept for recording sc synth in reaper
// must connect sc output to reaper
// in reaper options/parametres/osc: choose device ip/port
// set port of sc (57120) and local ip 127.0.0.0


(
SynthDef(\sintest, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq/2 * ( SinOsc.ar(10) * 1 + 1 ) ) * 0.51 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
OSCdef(\rPlay, { | msg |
	msg.debug("osc");
	if(msg[1] == 1) {
		s.makeBundle(s.latency, {
			~syn = Synth(\sintest);
		});
	} {
		s.makeBundle(s.latency, {
			~syn.release;
		});
	}
},\play);
)



////////////////////////////////////////////
// osc reaper test


n = NetAddr("127.0.0.1", 57120);

(
SynthDef(\sTrig, {
    | outBus=0, amp = 1 |
    var env, sig;
    env = Env.perc(0.01,0.1).ar(Done.freeSelf);
    sig = Pulse.ar(0.5, 0.5);
	SendTrig.kr(Impulse.kr(0),0,0.9);
    sig = sig * env;
    sig = sig % 2;
	sig = sig / 10;
    sig = sig * amp;
    Out.ar(outBus, Limiter.ar(sig));
}).add;
)

(
~dur = Routine({

    loop {
        0.4.wait;
        0.8.wait;
    };
}
);
)
~dur = 1;

(
~amp1 = 1; //kick
~amp2 = 1; //other
)


~dur.next

(
OSCdef(\rPlay, { | msg |
    msg.postln;
    if ( msg[1] == 1, {
        //msg.postln;
        s.makeBundle(s.latency, {
            ~seq1.play;
        });
        'seq playing'.postln;
    },
    {
        //~seq1.stop;
        //~seq1.reset;
        'seq stopped'.postln;
    };
    );

}, \play);

~seq1 = Routine({

    var dur;

    loop {

        dur = ~dur.next;

		[ TempoClock.default.beats,TempoClock.default.seconds, TempoClock.default.elapsedBeats  ].debug("first:");
        s.makeBundle(s.latency, {
            Synth(\sTrig, [
                //\outBus, 2,
                \amp, ~amp1,
            ]);
        });

        [1,2].do({
            s.makeBundle(s.latency, {
                Synth(\sTrig, [
                    //\outBus, 3,
                    \amp, ~amp2,
                ]);
            });
            dur.wait;
        });

        (dur * 2).wait;

    };

});
)

(
~seq1 = Routine({

	var dur;

	loop {

		dur = 1;

		[ TempoClock.default.beats,TempoClock.default.seconds, TempoClock.default.elapsedBeats  ].debug("first:");
		s.makeBundle(s.latency, {
			Synth(\sTrig, [
				//\outBus, 2,
				//\amp, ~amp1,
			]);
		});

		[1,2].do({
			s.makeBundle(s.latency, {
				Synth(\sTrig, [
					//\outBus, 3,
					//\amp, ~amp2,
				]);
			});
			dur.wait;
		});

		(dur * 2).wait;

	};

});
)
(
	o = OSCFunc({ arg msg, time;
		["hoho:", time, msg, time - ~time].postln;
	},'/tr', s.addr);
	TempoClock.schedAbs( TempoClock.default.nextTimeOnGrid(1), {

		[ TempoClock.default.beats,TempoClock.default.seconds  ].debug("sched:");
		~time = TempoClock.default.seconds; 
		~seq1.reset;
		~seq1.play;
		nil
	} )
)
	temp
	~t
	TempoClock.default.tempo

s.latency
Synth(\sTrig)

OSCdef

sched:: [ 3924.0, 3924.894171584  ]
first:: [ 3924.0, 3924.894171584, 3924.000902316  ]
[ hoho:, 3925.031390299, [ /tr, 5000, 0, 0.89999997615814  ], 0.13721871500002  ]
[ hoho:, 3925.032401541, [ /tr, 4999, 0, 0.89999997615814  ], 0.13822995700002  ]
[ hoho:, 3926.030292161, [ /tr, 5001, 0, 0.89999997615814  ], 1.1361205769999  ]
k

~seq1.seconds
~seq1.reset
TempoClock.default.seconds
SendTrig
(
	SynthDef("help-SendTrig",{
		    SendTrig.kr(Dust.kr(1.0),0,0.9);

	}).add;

	// register to receive this message
	o = OSCFunc({ arg msg, time;
       [time, msg].postln;
   },'/tr', s.addr);
)



///


OSCdef

(
SynthDef(\sintest, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq/2 * ( SinOsc.ar(10) * 1 + 1 ) ) * 0.51 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

1
(
OSCdef(\rPlay, { | msg |
	msg.debug("osc");
	if(msg[1] == 1) {
		s.makeBundle(s.latency, {
			~syn = Synth(\sintest);
		});
	} {
		s.makeBundle(s.latency, {
			~syn.release;
		});
	}
},\play);
)

(
OSCdef.newMatching(\rPlay, { | msg |
	msg.debug("osc");

},'/*');
)


//////////


/// not working
(
SynthDef(\sTrig, {
    | outBus=0, amp = 1 |
    var env, sig;
    env = Env.perc(0.01,0.1).ar(Done.freeSelf);
    sig = Pulse.ar(0.5, 0.5);
	SendTrig.kr(Impulse.kr(0),0,0.9);
    sig = sig * env;
    sig = sig % 2;
	sig = sig / 10;
    sig = sig * amp;
    Out.ar(outBus, Limiter.ar(sig));
}).add;
)

(
~seq1 = Routine({

	var dur;

	loop {

		dur = 1;

		[ TempoClock.default.beats,TempoClock.default.seconds, TempoClock.default.elapsedBeats  ].debug("first:");
		s.makeBundle(s.latency, {
			Synth(\sTrig, [
				//\outBus, 2,
				//\amp, ~amp1,
			]);
		});

		[1,2].do({
			s.makeBundle(s.latency, {
				Synth(\sTrig, [
					//\outBus, 3,
					//\amp, ~amp2,
				]);
			});
			dur.wait;
		});

		(dur * 2).wait;

	};

});
)

(
OSCdef(\rPlay, { | msg |
	msg.postln;
	if ( msg[1] == 1 ) {
		~seq1.reset;
		~seq1.play;
		'seq playing'.postln;
	} {
		~seq1.stop;
		'seq stopped'.postln;
	};

}, \play);
)

/// working
(
SynthDef(\sTrig, {
    | outBus=0, amp = 1 |
    var env, sig;
    env = Env.perc(0.01,0.01).ar(Done.freeSelf);
    sig = SinOsc.ar(100, 0.5);
	SendTrig.kr(Impulse.kr(0),0,0.9);
	//sig = Impulse.ar(0);
    sig = sig * env;
    sig = sig % 2;
	//sig = sig / 10;
    sig = sig * amp;
    OffsetOut.ar(outBus, Limiter.ar(sig));
}).add;
)

(
~seq1 = Routine({

	var dur;

	loop {

		dur = 1/2;

		[ TempoClock.default.beats,TempoClock.default.seconds, TempoClock.default.elapsedBeats  ].debug("first:");
		s.makeBundle(s.latency, {
			Synth(\sTrig);
		});
		dur.wait;

	};

});
)

(
OSCdef(\rPlay, { | msg |
	msg.postln;
	if ( msg[1] == 1 ) {
		~seq1.reset;
		~seq1.play;
		'seq playing'.postln;
	} {
		~seq1.stop;
		'seq stopped'.postln;
	};

}, \play);
)

/// not working: debug
(
SynthDef(\sTrig, {
    | outBus=0, amp = 1 |
    var env, sig;
    env = Env.perc(0.01,0.1).ar(Done.freeSelf);
    sig = Pulse.ar(0.5, 0.5);
	SendTrig.kr(Impulse.kr(0),0,0.9);
    sig = sig * env;
    sig = sig % 2;
	sig = sig / 10;
    sig = sig * amp;
    Out.ar(outBus, Limiter.ar(sig));
}).add;
)

(
~seq1 = Routine({

	var dur;

	loop {

		dur = 1;

		[ TempoClock.default.beats,TempoClock.default.seconds, TempoClock.default.elapsedBeats  ].debug("first:");
		s.makeBundle(s.latency, {
			Synth(\sTrig);
		});

		2.do({
			s.makeBundle(s.latency, {
				Synth(\sTrig);
			});
			dur.wait;
		});

		(dur * 2).wait;

	};

});
)

(
OSCdef(\rPlay, { | msg |
	msg.postln;
	if ( msg[1] == 1 ) {
		~seq1.reset;
		~seq1.play;
		'seq playing'.postln;
	} {
		~seq1.stop;
		'seq stopped'.postln;
	};

}, \play);
)


///////// test timestamp

(
OSCdef(\rPlay, { | msg ...args |
	[msg, args].debug("rplay");
	if ( msg[1] == 1 ) {
		~seq1.reset;
		~seq1.play;
		'seq playing'.postln;
	} {
		~seq1.stop;
		'seq stopped'.postln;
	};

}, \play);
)

Date.localtime
Date.getDate.rawSeconds
time from reaper: 403297705.11024,
Main.elapsedTime



Synth("help-SendTrig")
(
	SynthDef("help-SendTrig",{
		    SendTrig.kr(Dust.kr(1.0),0,0.9);

	}).add;

	// register to receive this message
	o = OSCFunc({ arg msg, time;
       [time, msg].postln;
   },'/tr', s.addr);
)

/// try to compute reaper timestamp


TempoClock.tempo = 2; // 120bpm like in reaper

(
OSCdef(\rPlay, { | msg, time |
	~timediff = time - TempoClock.seconds;
	[time, TempoClock.seconds, ~timediff].debug("time");
	[msg, time].debug("rplay");
	if ( msg[1] == 1 ) {
		s.makeBundle(s.latency, {
			~syn = Synth(\sTrig);
		});
		'seq playing'.postln;
	} {
		~syn.release;
		'seq stopped'.postln;
	};

}, \play);
)
