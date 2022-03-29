////////////////  Chopin Prelude in Em OP.28,No.4   ///////////////// 

(
 SynthDef(\mdapiano, { |out=0, freq=440, gate=1,
	                        vel= 100, decay= 0.8, release= 0.8, hard= 0.8,
		                    velhard= 0.8, muffle= 0.8, velmuff= 0.8, velcurve= 0.8, stereo= 0.5,
		                    tune= 0.5, random= 0.1, stret= 0.1, sus= 0|

   var son = MdaPiano.ar(freq, gate, vel,  decay, release, hard,
		                        velhard, muffle, velmuff, velcurve, stereo,
		                        tune, random, stret, sus);
	FreeSelf(1-gate);
    Out.ar(out, son );
}).add;
)



(  //                 1      2      3     4      5      6      7         8
var tNotes = [ 59,71, 71,72, 71,72, 71,72, 71,70, 69,71, 69,71, 69,71,69, 69,68,
  //          9                     10     11        12
	          67,69,71,74,72,64,69, 66,69, 66,71,69, 67,66,60,59,63,66,74,72,71,
 //           13     14     15     16                             17
	          71,72, 71,72, 71,72, 71,70,70,71,70,69,70,79,78,76, 76,75,84,75,75,76,79,71,
 //	          18                    19        20     21     22     23
	          74,72,76,64,69,66,69, 66,71,69, 66,64, 64,66, 64,66, 64,\r,
 //           24                           25
	          [52,54,59,64],[51,54,59,63], [52,55,59,64],
             ];
 //                     1    2    3    4    5    6    7          8
var tDur   = [ 3/4,1/4, 3,1, 3,1, 3,1, 3,1, 3,1, 3,1, 3,3/4,1/4, 3,1,
 //            9                          10   11         12
               1,1/2,1/2,1/2,1/2,1/2,1/2, 3,1, 3,1/2,1/2, 1/2,1/2,1/2,1/2,1/2,1/2,1/3,1/3,1/3,
 //            13   14   15   16                                     17
	           3,1, 3,1, 3,1, 3/4,1/4,1/2,1/8,1/8,1/8,1/8,1,3/4,1/4,  1/2,1/2,1/2,1/2,1/2,1/2,1/2,1/2,
 //            18                           19         20        21   22   23
               1/2,1/2,1/3,1/3,1/3,3/2,1/2, 3,1/2,1/2, 15/4,1/4, 3,1, 3,1, 2,2,
//             24   25
	           2,2, 4,
	         ];

//                 1                     2
var bNotes = [ \r, Pseq([[55,59,64]],8), Pseq([[54,57,64]],4),Pseq([[54,57,63]],4),
//            3
	          Pseq([[53,57,63]],4),Pseq([[53,57,62]],2),Pseq([[53,56,62]],2),
//            4
	          Pseq([[52,56,62]],4),Pseq([[52,55,62]],2),Pseq([[52,55,61]],2),
//            5                                          6
	          Pseq([[52,55,60]],4),Pseq([[52,54,60]],4), Pseq([[52,54,60]],4),Pseq([[51,54,60]],4),
//            7                     8
	          Pseq([[50,54,60]],8), Pseq([[50,53,60]],4),Pseq([[50,53,59]],4), // bar 7,8
//            9                                          10
	          Pseq([[48,52,59]],2),Pseq([[48,52,57]],6), Pseq([[47,52,57]],2),Pseq([[47,51,57]],2),Pseq([[48,52,57]],4),
//            11                                         12
	          Pseq([[47,51,57]],4),Pseq([[48,52,57]],4), Pseq([[47,51,57]],2),Pseq( [\r], 6),
//            13                    14
	          Pseq([[55,59,64]],8), Pseq([[54,57,64]],4),Pseq([[53,57,63]],4),  // bar 13, 14
//            15
	          Pseq([[53,56,63]],2),Pseq([[53,56,62]],2),Pseq([[52,56,62]],4),
//            16
	          Pseq([[52,55,62]],2),Pseq([[52,55,61]],2),Pseq([[49,52,58]],2),Pseq([[48,52,57]],2),
//            17
		      [23,47],Pseq([[57,60,66,69]],3),[55,59,63,66],Pseq([[55,59,64]],3),
//            18
	          Pseq([[57,60,64]],2),45,[52,54,60],Pseq([[47,52,59]],2),Pseq([[48,52,57]],2),
//            19
	          Pseq([[47,52,59]],4),Pseq([[48,52,57]],4),
//            20
	          Pseq([[47,52,59]],4),Pseq([[47,51,59]],2),Pseq([[47,51,57]],2),
//            21
      	      Pseq([[48,55]],4), Pseq([[48,58]],2),Pseq([[48, 52, 57]],2),
//            22
              Pseq([[47,52,57]],2), Pseq([[47,52,56]],2),Pseq([[47,52,55]],4),
//            23             24                  25
	          [46,48,55],\r, [35,47],[35,42,47], [30,42]
             ];

//               1-22               23   24   25
var bDur   = [1, Pseq([1/2], 22*8), 2,2, 2,2, 4];

var instr = \mdapiano;

var bA = Pbind(\instrument, instr ,\midinote, Pseq(bNotes), \dur, Pseq(bDur),
	 \legato, 0.8, \vel, 60, \random, 0.0, \stret, 0.0);

var tA = Pbind(\instrument, instr ,\midinote, Pseq(tNotes), \dur, Pseq(tDur),
	\legato, 0.8, \vel, 90, \random, 0.0, \stret, 0.0);

~score = Ppar([bA,tA]);
~score.play(TempoClock(50/60));
)

//////////////////////////

Here is my problem. In piano music, 
a chord is held down simultaneously.  But then
some voices can move while other notes are still held down.
i.e the chord notes have different durations? Does anyone
know an elegant way to deal with this?

thanks, Stewart


/////////


(
Routine.new{
	var current;
	var episode_seq = Pseq([
		~episode2a,
		~episode2b,
	],inf).asStream;
	({
		~episode1.play;
		150.wait;
		current = episode_seq.next;
		current.play;
		~episode1.stop;
		150.wait;
		~episode3.play;
		current.stop;
		150.wait;
		~episode4.play;
		~episode3.stop;
		150.wait;
	}).loop;
}.play;
)


///////

// Prepare a list of scales. This is your lead-sheet.
~scalePerBeat = List();
~scalePerBeat.add(Dictionary.newFrom([
    'root', 2,
    'scale', Scale.dorian,
]));
~scalePerBeat.add(Dictionary.newFrom([
    'root', 7,
    'scale', Scale.mixolydian,
]));
2.do({
~scalePerBeat.add(Dictionary.newFrom([
    'root', 0,
    'scale', Scale.ionian,
]));
});

// Code to draw the right chords per bar
~harmony = Pbind(
    \root, Pfunc({
        var idx;
        idx = TempoClock.default.bar % ~scalePerBeat.size;
        ~scalePerBeat.at(idx)['root'];
    }),
    \scale, Pfunc({
        var idx;
        idx = TempoClock.default.bar % ~scalePerBeat.size;
        ~scalePerBeat.at(idx)['scale'].degrees;
    }),
);

// Now prepare some patterns
(
Pdef('chords', Pbindf(~harmony,
    \degree, Pdup(2, Pser([[2, 6], [2, -1]], inf)),
    \dur, 1/0.25,
    \amp, Pwhite(0.05, 0.2),
    \octave, 5,
    \legato, Pwhite(0.15, 0.25, inf),
));
Pdef('chords').quant_(4); // use e.g. [4, 1] to offset the pattern
)

(
Pdef('bass', Pbindf(~harmony,
    \degree, Pseq([0, 2, 4, 6], inf),
    \dur, 1,
    \amp, Pwhite(0.05, 0.2),
    \octave, 3,
));
Pdef('bass').quant_(4);
)

(
Pdef('impro', Pbindf(~harmony,
    \degree, Prand([0, 2, 4, 6].reverse, inf),
    \dur, 0.25,
    \amp, Pwhite(0.05, 0.2),
    \octave, 6,
));
Pdef('impro').quant_(4);
)

// Now use `play` and `stop` to play music. Also redefine the patterns above on the fly, especially the `\degree` parts.
(
Pdef('impro').play;
Pdef('chords').play;
Pdef('bass').play;
)
