
// sine cluster refix, kind of, a little bit, of Arvo Pärt, "Fratres"

(
{
b=fork{loop{h=[40,45,52].choose.midicps;play{Splay.ar({SinOsc.ar(exprand(h,h+(h/64)),0,0.2)}!16)*LFGauss.ar(9,1/4,0,0,2)};4.wait}};
{
5.do{[[72,69,64], [70,64,62], [67,60,70], [65,60,69], [64,60,67],[65,60,69]].do{|i| x=i.postln;10.wait;}};
10.wait;
c.stop;
4.wait;
b.stop;
}.fork;
0.1.wait;
c=fork{loop{h=x.choose.midicps;play{Splay.ar({SinOsc.ar(exprand(h-(h/128),h+(h/128)),0,0.1)}!16)*LFGauss.ar(6,1/4,0,0,2)};0.5.wait;}};
}.fork;
)


/*
*  Twilight Luminaries by Alexander Zhagun-Linnik
*  Moscow, 2019
*
*  Endless generative composition based on random polyphonic sequences.
*
*  etherguide@gmail.com
*/
(
Server.default = s;
o=s.options;
o.memSize;
o.sampleRate;
o.memSize = 2.pow(16);
o.sampleRate = 44100;
s.quit;
s.waitForBoot({
	~rseq = {Array.fill(~num = rrand(2, 8), {arg i; rrand(0, 12)})};
	~scale = Scale.at(Scale.names.choose);
	~time = 5;
	~root = rrand(0, 12);
	~maingain = 4;
	{
		SynthDef(\sin, {arg freq=440, amp = 0.9, gate=1, out=0, release=1, attack=0.01, maingain=4, decay=1, detune=0.01;
			var sig = Mix.fill(12, {arg i;
				SinOsc.ar(freq+(freq*Rand(detune.neg, detune)), Rand(0.0, 1.0), amp/12);
			});
			sig = (sig*maingain).softclip;
			sig = (sig * Env.adsr(attack, decay, 1.0, release).kr(2, gate));
			sig = Pan2.ar(sig, Line.kr(Rand(-1.0, 1.0), Rand(-1.0, 1.0), Rand(0.01, 3.0)));
			Out.ar(out, sig);
		}).add;
		SynthDef(\sim, {arg freq=440, out=0, release=1, maingain=4;
			var amp = Rand(0.0, 0.5);
			var sig = SinOsc.ar(freq, Rand(0.0, 1.0), amp/12);
			sig = (sig*maingain).softclip;
			sig = sig * Env.perc(0.0001, releaseTime: release, curve: -8).kr(2);
			sig = CombC.ar(sig, Rand(0.01, 0.4), Rand(0.01, 0.4), Rand(0.01, 0.3), Rand(0.01, 2));
			sig = Pan2.ar(sig, Line.kr(Rand(-1.0, 1.0), Rand(-1.0, 1.0), Rand(0.01, 3.0)));
			Out.ar(out, sig);
		}).add;
		SynthDef(\str, {arg freq=440, amp = 1.0, gate=1, out=0, verb=0.5, release=1, attack=0.01, maingain=4, decay=1, detune=0.01;
			var sig = Mix.fill(12, {
				VarSaw.ar(freq+(freq*Rand(detune.neg, detune)), Rand(0.0, 1.0), Rand(0.0, 1.0),  amp/12);
			});
			attack = attack*2;
			sig = (sig*maingain).softclip;
			sig = sig * Env.adsr(attack, decay, 1.0, release).kr(2, gate);
			sig = Pan2.ar(sig, Line.kr(Rand(-1.0, 1.0), Rand(-1.0, 1.0), Rand(0.01, 3.0)));
			Out.ar(out, sig);
		}).add;
		s.sync;
		loop{
			~rseq = {Array.fill(~num = rrand(2, 8), {arg i; rrand(0, 8)})};
			if(rrand(1, 5)==4, {
				~scale = Scale.at(Scale.names.choose);
			});
			if(rrand(1, 5)==4, {
				~root = rrand(0, 12);
			});
			Pdef(\main,
				Ppar(Array.fill(rrand(1, 8), {
					Pbind(
						\instrument, [\sin, \str, \sim].choose,
						\scale, ~scale,
						\dur, [2, 1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/3, 1/6, 1/12].choose*~time,
						\degree, Pseq(~rseq.value, inf),
						\octave, [2, 3, 4, 5, 6].choose,
						\type, Pfunc({[\note, \note, \rest].choose}),
						\verb, rrand(0.05, 0.8),
						\release, rrand(0.0, 4.0),
						\attack, rrand(0.001, 1.0),
						\root, ~root,
						\maingain, Pbrown(0.1, 6.0, Pfunc({rrand(0.1, 1.0)}), inf),
						\detune, rrand(0.005, 0.015),
						\decay, Pfunc({rrand(0.01, 2.0)}),
					)
				}))
			).play();
			Ndef(\proc, {
				var sig = FreeVerb.ar(
					In.ar(0, 2),
					rrand(0.01, 0.99),
					rrand(0.01, 0.99),
					rrand(0.01, 0.99)
				);
				Out.ar(0, sig);
			}).fadeTime_(rrand(0.1, 3.0));
			([8, 4, 2, 1].choose*~time).sleep;
		}
	}.fork;
});
)


// first things first: if you haven't done so already, please install the theory quark
(
Quarks.install("https://github.com/shimpe/theoryquark"); 
)

// then fire off the canon
(
o=s.options;
o.memSize = 2.pow(16);
o.maxNodes_(4096);
s.quit;

s.waitForBoot({
    // start of user definable code
    var scramble_first= true; // set to true for a wilder effect
    // how many different versions to generate from the base material
    var noVariations = 2;
    // melodic resolution is chromatic half tone; 1 = half tone; 3 = quarter tone; etc...
    var halfToneSubDiv = 1;
    // assign a transposition to every voice (array size determines the number of voices)
    var voice_transpositions = [ 0, 1, -1, 1 ]*12;
    // assign an instrument to every voice: same size as voice_transpositions
    var voice_instruments = [ \cheappiano, \cheappiano, \apad_mh, \flute];
    // generate base material according to this chord progression
    var chordnotes = [
        ["c4","eb4","g4", "c5"],
        ["d4","f4","ab4", "bb4"],
        ["eb4","g4","c5","d5"],
        ["f4","ab4","c5", "f5"],
        ["g4","bb4","d5", "f5"] ];
    var durations =  [2, 2/3, 2/3, 2/3, 2];
    var scale = TheoryScale.new("c", "minor", "c4 d4 eb4 f4 g4 ab4 bb4");
    // end of user modifiable code

    var serialized_chorddegrees;
    var serialized_durations;
    var zipped_deg_dur;
    var spiced = [];
    var pattern = [];
    var canon;
    var spiced_degs = [];
    var spiced_notes = [];
    var spiced_durs = [];
    var pseq = [];
    var chordmidinotes,chorddegrees;
    var chordnotes_scrambled;
    if ((scramble_first), {chordnotes_scrambled = chordnotes.collect({ |c| c.scramble })}, { chordnotes_scrambled = chordnotes} );

    SynthDef(\flute, {
        | out = 0, freq = 440, amp = 1.0, a = 0.1, r = 0.1|
        //var fmod = 1; // clean
        //var fmod = LFCub.kr(freq:1/12).range(1, LFNoise2.kr(freq:12.0).range(1,1.1)); // tone deaf flute
        var fmod = LFCub.kr(freq:1/12).range(1, LFNoise2.kr(freq:12.0).range(1,1.02)); // flute-like sound
        var env = EnvGen.ar(Env.perc(a, r), levelScale:0.5, doneAction:2);
        var snd = SinOsc.ar(freq * fmod)!2;
        Out.ar(bus:out, channelsArray:(env*(amp*snd).tanh));
    }).add;

    SynthDef(\apad_mh, {arg freq=880, amp=0.5, attack=0.4, decay=0.5, sustain=0.8, release=1.0, gate=1.0, out=0;
        var env,sig,mod1,mod2,mod3;
        env=EnvGen.kr(Env.adsr(attack,decay,sustain,release),gate,levelScale:amp,doneAction:2);
        mod1=SinOsc.kr(6).range(freq*0.99,freq*1.01);
        mod2=LFNoise2.kr(1).range(0.2,1);
        mod3=SinOsc.kr(rrand(4.0,6.0)).range(0.5,1);
        sig=SinOsc.ar([freq,mod1],0,env).distort;
        sig=sig*mod2*mod3;
        Out.ar(out,sig);
    },
    metadata:(
        credit: "A simple sustained sound with vibrato --Mike Hairston",
        tags: [\pad,\vibrato,\sustained]
    )).add;

    SynthDef(\cheappiano, { arg out=0, freq=440, amp=0.1, dur=1, pan=0;Ê
        var sig, in, n = 6, max = 0.04, min = 0.01, delay, pitch, detune, hammer;
        freq = freq.cpsmidi;
        hammer = Decay2.ar(Impulse.ar(0.001), 0.008, 0.04, LFNoise2.ar([2000,4000].asSpec.map(amp), 0.25));
        sig = Mix.ar(Array.fill(3, { arg i;
            detune = #[-0.04, 0, 0.03].at(i);
            delay = (1/(freq + detune).midicps);
            CombL.ar(hammer, delay, delay, 50 * amp)
        }) );

        sig = HPF.ar(sig,50) * EnvGen.ar(Env.perc(0.0001,dur, amp * 4, -1), doneAction:2);
        Out.ar(out, Pan2.ar(sig, pan));
    },
    metadata: (
        credit: "based on something posted 2008-06-17 by jeff, based on an old example by james mcc",
        tags: [\casio, \piano, \pitched]
    )).add;

    s.sync;

    u = (); // u stands for utils
    u.t = (); // u.t stands for utils.transform
    u.t.p = TheoryNoteParser.new;
    u.t.nop = { | degree, duration | [ [degree], [duration] ]; };
    u.t.one_to_three = {
        // transformation that transforms a single note into three notes keeping original duration
        | degree, duration |
        var durmod = [ [1, 1, 2], [2, 1, 1], [1, 2, 1], [1, 1, 1] ].collect({|el| el.normalizeSum}).choose;
        var direction = [ -1, 1, 2, -2, 4, -4].choose;
        [   [ degree, duration*(durmod[0])],
            [ degree+direction, duration*(durmod[1])],
            [ degree, duration*(durmod[2])]
        ]
    };
    u.t.two_to_three = {
        // transformation that transforms two notes into three notes keeping original duration
        | degree, duration, next_degree |
        var dur_subdiv =  [
            [ 1.0/3, 2.0/3],
            [ 2.0/3, 1.0/3],
            [ 0.5, 0.5    ],
            [ 0.75, 0.25  ],
            [ 0.25, 0.75  ]
        ].choose;
        var new_deg = ((degree + next_degree)/2.0).round(1/halfToneSubDiv);
        if ((new_deg == degree), {
            [ [degree, duration] ];
        }, {
            [
                [ degree, dur_subdiv[0]*duration ],
                [ new_deg, dur_subdiv[1]*duration ]
            ];
        });
    };
    u.t.two_to_four = {
        // transformation that transforms two notes into four notes keeping original duration
        | degree, duration, next_degree |
        var dur_subdiv = [
            [ 0.5, 0.25, 0.25 ],
            [ 0.25, 0.5, 0.25 ],
            [ 0.333, 0.333, 0.334 ],
        ].choose;
        var direction = [ 1, -1].choose;
        var mid_deg = ((degree + next_degree)/2.0).round(1/halfToneSubDiv);
        //"2-to-4".postln;
        if ((mid_deg == degree), {
            [
                [degree, duration*dur_subdiv[0]],
                [next_degree + direction, duration*dur_subdiv[1]],
                [next_degree-direction, duration*dur_subdiv[2] ]
            ];
        }, {
            [
                [degree, duration*dur_subdiv[0]],
                [mid_deg, duration*dur_subdiv[1]],
                [next_degree+direction, duration*dur_subdiv[2]]
            ];
        });
    };
    u.t.spiceup_singlenotes = {
        // runs over all notes and randomly replaces some notes with three notes
        | deg_dur, probability = 0.3 |
        var deg = deg_dur[0];
        var dur = deg_dur[1];
        probability.coin.if({
            u[\t][\one_to_three].value(deg, dur);
        }, {
            [ [deg, dur] ];
        });
    };
    u.t.spiceup_twonotes = {
        // runs over all notes and randomly replaces some consecutive notes with three or four notes
        | deg_dur, next_deg_dur, probability = 0.3, techniques = #[\two_to_three, \two_to_four] |
        var deg = deg_dur[0];
        var dur = deg_dur[1];
        var technique = techniques.choose;
        var next_deg = next_deg_dur[0];
        probability.coin.if({
            u[\t][technique].value(deg, dur, next_deg);
        }, {
            [ [deg, dur] ];
        });
    };

    chordmidinotes = chordnotes_scrambled.collect({|chord| u[\t][\p].asMidi(chord)});
    chorddegrees = chordmidinotes.collect({|chordmidi| scale.midiToDegreeNotNorm(chordmidi); });
    serialized_chorddegrees = chorddegrees.lace(chorddegrees.flat.size);
    serialized_durations = durations.wrapExtend(chorddegrees.flat.size);
    zipped_deg_dur = (chorddegrees.flat.size).collect({ |i| [serialized_chorddegrees[i], serialized_durations[i]] });

    // first make a collection of noVariations copies of the base material
    noVariations.do({
        | i |
        spiced = spiced.add(zipped_deg_dur);
    });

    // now spice up the base material
    // some transformations require at least one previous note (hence i>1), or two previous notes (hence i>2)
    // whether a transformation is done or not is left to coincidence
    noVariations.do({
        | i |

        if ((i > 0), {

            spiced[i] = spiced[i].collect({
                |el|
                u[\t][\spiceup_singlenotes].value(el, 0.6);
            }).flatten(1);

            spiced[i] = spiced[i].collect({
                |el, idx|
                u[\t][\spiceup_twonotes].value(el, spiced[i].foldAt(idx+1), 0.5, [\two_to_four]);
            }).flatten(1);
        });

        if ((i > 1), {

            spiced[i] = spiced[i].collect({
                |el|
                u[\t][\spiceup_singlenotes].value(el);
            }).flatten(1);

            spiced[i] = spiced[i].collect({
                |el, idx|
                u[\t][\spiceup_twonotes].value(el, spiced[i].foldAt(idx+1), 0.3, [\two_to_three, \two_to_four]);
            }).flatten(1);
        });

        if ((i > 2), {
            spiced[i] = spiced[i].collect({
                |el|
                u[\t][\spiceup_singlenotes].value(el);
            }).flatten(1);
            0.33.coin.if({
                spiced[i] = spiced[i].collect({
                    |el, idx|
                    u[\t][\spiceup_twonotes].value(el, spiced[i].foldAt(idx+1), 0.3, [\two_to_three, \two_to_four]);
                }).flatten(1);
            });
        });
    });

    // unfold the chords into canon melodies
    noVariations.do({
        | i |
        spiced_degs = spiced_degs.add(spiced[i].lace(spiced[i].size * 2).keep(spiced[i].size));
        spiced_notes = spiced_notes.add(scale.degreeNotNormToMidi(spiced_degs[i]));
        spiced_durs = spiced_durs.add(spiced[i].lace(spiced[i].size * 2).drop(spiced[i].size));
    });

    // collect all material into patters
    noVariations.do({
        | i |
        pattern = pattern.add(Pbind(
            \instrument, \melody2,
            \midinote, Pseq(spiced_notes[i], 3*noVariations),
            \dur, Pseq(spiced_durs[i], 3*noVariations),
            \amp, 0.1,
            \a, Pkey(\dur),
        ));
    });

    // apply transpositions for the different voices
    noVariations.do({
        |v|
        var sz = voice_transpositions.size;
        voice_transpositions.do({
            |t, i|
            var idx = ((v*sz)+i);
            pseq = pseq.add(idx*durations.sum);
            pseq = pseq.add(Pbindf(pattern[v], \ctranspose, t, \instrument, voice_instruments[i]));
        });
    });

    // put all material in parallel to get the final canon
    canon = Ptpar(pseq);

    // play the canon
    canon.play;
});
)
