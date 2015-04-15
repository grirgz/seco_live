12.0.gauss(2.0)

(
// create a cluster of events around beat 12
var events = Array.fill(64, { arg i;
            // an Event object
            (
                // gaussian distribution with 2.0 standard deviations around beat 12.0
                beat: 12.0.gauss(2.0),
                degree: 20.rand,

                type: \instr,
                instr: "schelp.EventListPlayer",
                env: Env.perc
            )
    });

Instr("schelp.EventListPlayer", { arg freq=440, env;
    SinOsc.ar(freq) * EnvGen.kr(env, doneAction:2)
});

e = EventListPlayer.new(events);

// e.gui

x = Mx.new;
x.add(e);
x.gui;

)



// make a new EventList
a = EventList[];

// add some time-stamped events to it
a.start;
a.addEvent((absTime: 0, deg: 0));    // events should begin with time 0;
a.addEvent((absTime: 0.3, deg: 1));
a.addEvent((absTime: 0.52, deg: 2));
a.addEvent((absTime: 0.72, deg: 3));
a.addEvent((absTime: 0.93, deg: 4));
a.finish(1.88);

// printing is quite flexible:
a.print;
a.print([\dur]);
a.print([\dur], false);
a.print([\absTime, \dur], false);

a.quantizeDurs(0.25, 2).printAll;"";
a.totalDur;
a.playingDur;

// play the list by hand 
// ( usually one would use EventLoop )
(
fork { 
    a.do { |ev|
        var deg = ev[\deg];
        ev.postln;
        if (deg.notNil) { (degree: deg, sustain: 0.1).play; };
        ev[\relDur].wait;
    };
};
)



// Simplest example: use EventLoop to record a Pbind

e = EventLoop(\e);
e.startRec;

(
Pbind(
    \note, Pbrown(0, 12, 1, 40),
    \dur, 0.125,
    \rec, e
).play
)

e.stopRec;
e.listInfo;
e.play;

e.list.print;



    // more detail:

    // make a EventLoop with a name and a func 
    // the func expects numbers that work as degrees
e = EventLoop(\u, { |ev| (degree: ev[\deg], dur: 0.1).play; });

    // EventLoop expects lists of events, 
    // which have an absTime entry, and arbitrary other info.
    
    // for example: add a list of ascending notes
(    // (in typical use, the lists will be recorded in real time)
fork { 
    e.startRec;        // adds a start event
    e.recordEvent((deg: 0).postln); 1.wait;
    e.recordEvent((deg: 1).postln); 1.wait;
    e.recordEvent((deg: 2).postln); 0.45.wait;
    e.recordEvent((deg: 3).postln); 0.55.wait;
    e.recordEvent((deg: 4).postln); 0.3.wait;
    e.recordEvent((deg: 5).postln); 0.2.wait;
    e.recordEvent((deg: 6).postln); 0.22.wait;
    e.recordEvent((deg: 7).postln); 0.28.wait;
    e.stopRec;    
};
)
    // u has the recorded list as current,
    // and can play it
e.play;
e.looped_(true).play; // now loops

    // change tempo
e.tempo_(1.5);
e.tempo_(2);
e.tempo_(1);

    // quantize to a grid - not fully tested yet
e.quantize(0.25, 4);
e.quantize(0.125, 3);
e.quantize(0.1666666, 4);
e.unquantize;  

    // change direction
e.reverse;
e.flip;
e.forward;

    // change range within loop:
e.range = 0.25;        // first quarter
e.lpStart = 0.25;    // second quarter
e.lpStart = 0.5;    // center 50%
e.range = 0.5;        // second half
e.lpStart = 0.75;    // last quarter continues into first
e.resetLoop;        // reset loop params

    // jitter event order by % 
e.jitter = 0.25;
e.jitter = 0.5;
e.jitter = 0;
e.resetLoop;


    // if you record again, playback will stop
(
fork {
    e.startRec;
    10.do { |i|
        e.recordEvent((deg: i.neg + 7).postln); (1 / (i+1)).wait;
    };
    e.stopRec;    
};
)
e.play;

    // switch between the two lists 
e.setList(0); // the newest
e.setList(1); // back in time


e.collect(_.postln)


///////////////////////////////////////////////////


// make a sound to control 
(
Ndef(\form, { |freq = 50, shape = 0.9, ffreq = 200, amp = 0.1, lag = 0.1|
    var snd = VarSaw.ar(freq.lag(lag) + [0.1, -0.1], 0, shape.lag(lag));
    Formlet.ar(snd * amp.lag(lag), ffreq.lag(lag), 0.003, 0.03).softclip;
}).play(vol: 0.2);
// add specs for its unusual params:
Ndef(\form).addSpec(\shape, [0, 1]);
Ndef(\form).addSpec(\ffreq, \freq);
)

// make a KtlLoop for it
(
k = KtlLoop(\form);

// tell it which params will be recorded for control input:
k.paramsToRecord_([\lx, \ly, \rx, \ry]);

// simple usage case:
// tell it which object will be controlled 
k.object_(Ndef(\form));

// and declare which input params set which object params
k.ktlMap_((lx: \freq, ly: \shape, rx: \ffreq, ry: \amp));

)

// make 4 channel controller:
    // put params into an event, store it, 
    // and set the object from it

(
w = Window("KtlLoop.help", Rect(0,500, 400, 550)).front;
w.view.addFlowLayout;
Slider2D(w, Rect(0,0,190,190))
    .action_({ |sl|

        // put params into an event, 
    var event = (lx: sl.x, ly: sl.y);
        // store it, 
    k.recordEvent(event.put(\type, \set));
        // and set the object from it
    k.setuObj(event);
});
Slider2D(w, Rect(0,0,190,190))
    .action_({ |sl|
    var event = (rx: sl.x, ry: sl.y);
    k.recordEvent(event.put(\type, \set));
    k.setuObj(event);
});

// make an eventloopgui for KtlLoop
KtlLoopGui(k, parent: w, bounds: 260@180);

// and an NdefGui for the Ndef
NdefGui(Ndef(\form), 6, w);
)

// try recording: 
k.startRec;
// ...
// now move the two sliders
// ...
// ...

k.stopRec;

k.listInfo;

k.play;


// Rescaling Gestures - all recorded controller values 
// can be scaled, shifted, and inverted. 

k.rescaled = false;
k.rescaled = true;
// decrease range toward center
k.scaler = 0.5;
k.scaler = 0.25;
// shift up or down
k.shift = 0.1;
k.shift = -0.1;

// invert range
k.invert;
k.up;
k.flipInv;

k.dontRescale(\lx);
k.doRescale(\lx);

k.postKtlInfo;



~p = Param(Ndef(\ndef_scalar), \freq);
MIDIMap(\k1, ~p)

~er = EventRecorder
~er.paramsToRecord_([ ~p]);
~er.startRec
~er.stopRec
~er.eventlist.play;


(
	\type, \set,
	k
)
k.print
k.lists
NodeProxy


Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	
	sig = SinOsc.ar(\freq.kr(400)) ;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

Pdef(~name +++ \pre, Pbind(
	\freq, 100,
));

Scale.choose(7);



(
SynthDef(\toc, {
Out.ar(0, XLine.ar(1, 0.01, 0.02, doneAction: 2)
* SinOsc.ar([600, 1300, 4500], 0, [0.3, 0.2, 0.1]).postln);
}).add;
)

(instrument: \toc).play;

    // get more info posted
e.verbosity = 2;

e.startRec;
    // run this line this multiple times, in some rhythm
e.recordEvent((instrument: \toc)); (instrument: \toc).play;

e.stopRec;

    // post info on the recorded list
e.listInfo;
e.printLists;

e.play;

e.looped_(true).play;
z.tempo = 0.5;
z.tempo = 2;
z.tempo = 1;




e.func.asCompileString



/////////////////////////////////////



    // Construct long example of EventList use by hand:

    // make a EventLoop with a name and a func 
    // the func expects numbers that work as degrees
e = EventLoop(\u, { |ev| (degree: ev[\deg], dur: 0.1).play; });

    // EventLoop expects lists of events, 
    // which have an absTime entry, and arbitrary other info.
    
    // for example: add a list of ascending notes
    // (in actual use, the lists will be recorded)
(
l = EventList[
	(absTime: 0, type: \start), // required start event
	(absTime: 0, deg: 0), 
	(absTime: 1, deg: 1), 
	(absTime: 2, deg: 2), 
	(absTime: 2.5, deg: 3), 
	(absTime: 3, deg: 4), 
	(absTime: 3.25, deg: 5), 
	(absTime: 3.5, deg: 6), 
	(absTime: 3.75, deg: 7), 
	(absTime: 3.875, deg: 8),
	(absTime: 4, type: \end)	// required end event
];
)

l.calcRelDurs;    // now add delta and dur times into the events
l.setPlayDursToRelDur;
l.print;        // print in readable order

    // make l the current list of EventLoop u: 
e.list = l; 
    // add the current list to the beginning of the recorded lists 
e.addList; 

    // now play the events in the list, 
    // with the task in EventLoop u calling its function:
e.play;
    // stops after first time, unless:
e.looped_(true).play; // now loops


        EXAMPLE 2 // record rhythm only, play by hand

// a sound to use        
(
SynthDef(\toc, {
Out.ar(0, XLine.ar(1, 0.01, 0.02, doneAction: 2)
* SinOsc.ar([600, 1300, 4500], 0, [0.3, 0.2, 0.1]).postln);
}).add;
)

e = EventLoop(\toc);

(instrument: \toc).play;

    // get more info posted
e.verbosity = 2;

e.startRec;
    // run this line this multiple times, in some rhythm
e.recordEvent((instrument: \toc)); (instrument: \toc).play;
e.recordEvent

e.stopRec;

    // post info on the recorded list
e.listInfo;
e.printLists;

e.play;

e.looped_(true).play;
z.tempo = 0.5;
z.tempo = 2;
z.tempo = 1;

e.reset


(
Pbind(
	\first, Pfunc({ arg ev; 
		ev.debug("first key");
		\yep; // the value returned is assigned to \first
	}),
	\second, Pfunc({ arg ev; 
		ev.debug("second key"); 
		ev[\third].debug("third key is nil at this point"); 
		42 
	}),
	\third, Pfunc({ arg ev; 
		ev.debug("third key"); 
		ev[\hello] = "world"; // add another key to the event
		"!"
	}),
	\fourth, Pfunc({ arg ev; ev.debug("fourth key"); \yop }),
	// at the end, event is sent in the stream
).trace.play; // with trace, you see the final event
)

(
(
	Pbind(
		\first, Pfunc({ arg ev; ev.debug("see input event coming from the chained pattern"); \yep }),
	)
	<>
	Pbind(
		\a, 1,
		\b, 2,
	)
).play
)
