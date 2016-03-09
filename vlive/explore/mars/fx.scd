
RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play;
Ndef(\fx1).edit;
RandDelayNetwork(\default).make(\fx1, "5-T1KJ-J6JA5", BusDef(\fx1, \audio)); // cool distobass


MIDIMap(\k1, Param(Ndef(\fx1), \fb));
MIDIMap(\k2, Param(Ndef(\fx1), \delay));
MIDIMap(\k3, Param(Ndef(\fx1), \delay2));
MIDIMap(\k4, Param(Ndef(\fx1), \shift));
MIDIMap(\k4, Param(Ndef(\fx1), \shift));
(
[
	\fb,
	\delay,
	\delay2,
	\distamp,

	\pitchmix,
	\pitchlag,
	\shift,
	\shift2,

	\mamp,

	\prelpf,
	\prehpf,
	\lpf,
	\hpf,

	\postlpf,
	\posthpf,
	\fbdistamp,
	\fbdistmix,
].collect({ arg key, x; 
	var tt = (1..9).collect({ arg x; \k+++x }) ++ (1..9).collect({ arg x; \s+++x });
	MIDIMap(tt[x].debug("fdf"), Param(Ndef(\fx1), key));
});

MIDIMap(\a1, { Ndef(\fx1).set(\shift, 0, \shift2, 0) });
MIDIMap(\a2, { Pdef(\main, Pdef(\part1_dry)).play; });
MIDIMap(\a3, {
	Ndef(\fx1).play;
	Pdef(\main, Pdef(\part2_wet)).play;
});
MIDIMap(\a4, {
	Pdef(\main, Ppar([Pdef(\part1_dry), Pdef(\part2_wet)])).play;
});
MIDIMap(\a5, {
	Pdef(\main, Ppar([Pdef(\part1_wet), Pdef(\part2_dry)])).play;
});
MIDIMap(\a6, {
	Pdef(\main, Ppar([Pdef(\part3_dry), Pdef(\part2_wet)])).play;
});
MIDIMap(\a7, {
	Pdef(\main, Ppar([Pdef(\part3_wet), Pdef(\part2_dry)])).play;
});
MIDIMap(\loop, {
	RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1, \audio));
});
MIDIMap(\c1, {
	RandDelayNetwork(\default).make(\fx1, "5-FIN-A7H1", BusDef(\fx1, \audio));
});
MIDIMap(\c2, {
	RandDelayNetwork(\default).make(\fx1, "5-33RR-LVPC", BusDef(\fx1, \audio));
});
MIDIMap(\c3, {
	RandDelayNetwork(\default).make(\fx1, "5-7F1H-7PLR", BusDef(\fx1, \audio));
});
	
)
MIDIMap(\a1, { "hello" })
RandDelayNetwork(\default).code
Ndef(\fx1).set(\delay, 0)
Param(Ndef(\fx1), \delay).set(1)

MIDIdef.cc(\m1, { arg x; x.debug("hello") })
MIDIdef.cc(\test3, {arg ...args; args.postln}, (1..100)); // match cc 1-10

Pdef(\part1).stop
Pdef(\part1).stop


/////////////



(
x = SynthDef( "hoover", { |freq = 220, amp = 0.1, lgu = 0.1, lgd = 1,
gate = 1|
    var pwm, mix, env;

    freq = freq.cpsmidi.lag(lgu,lgd).midicps;
    freq = SinOsc.kr( { 2.9 rrand: 3.1 }!3, {2pi.rand}!3 ).exprange(
0.995, 1.005 ) * freq;
    pwm = SinOsc.kr( {2.0 rrand: 4.0}!3 ).range(0.125,0.875);

    // the saw/pulses
    mix = (LFSaw.ar( freq * [0.25,0.5,1], 1 ).range(0,1)
        * (1 - LFPulse.ar(freq * [0.5,1,2], 0, pwm))).sum * 0.1;

    // the bass
    mix = mix + LFPar.ar( freq * 0.25, 0, 0.1 );

    // eq for extra sharpness
    mix = BPeakEQ.ar( mix, 6000, 1, 3 );
    mix = BPeakEQ.ar( mix, 3500, 1, 6 );

    // kind of chorus
    mix = mix + CombC.ar( mix.dup, 1/200,
        SinOsc.kr( 3, [0.5pi, 1.5pi] ).range(1/300,1/200),
        0.0 ) * 0.5;

    env = EnvGen.kr( Env.asr, gate );

    Out.ar( 0, mix * env * amp );
}).add;
)

this is a hoover sound fetched from this list,
which after a further discussion I had in here I managed to run and
alter while running with the bellow approach
(
p = PbindProxy(\amp, 0.1, \lgu, 0.1, \lgd, 1, \dur, 0.2, \midinote, 80);
q = Pchain(Pmono(\hoover, \dummy, 0), p).play;
~dur = Pseq([0.2, 2, 0.2, 0.5] * 0.125, inf);
~lgu = Pseq([0, 5, 1.15, 2], inf);
~lgd = Pseq([ 1.1, 5.1, 0.5, 2.1], inf);
~midinote = Pseq([25, 120, 92, 70] , inf);
)
(
p.set(\amp, 0.1, \dur, ~dur, \lgu, ~lgu, \lgd, ~lgd, \midinote, ~midinote);
)
p.quant = 2

up to here everything is understandable and works as expected.
but when I run the bellow code multiple times (really fast or not) I get
different sound results!
Why? I get that it wouldn't be in sync, so each time I fire it'll I
brake the previous cycle, but why the sound result is different? What I
am missing?
(
~dur = Pseq([0.5, 1, 0.4, 0.1] * 0.125, inf);
p.set(\dur, ~dur);
)

(
x = SynthDef( "hoover", { |freq = 220, amp = 0.1, lgu = 0.1, lgd = 1,
gate = 1|
    var pwm, mix, env;

    freq = freq.cpsmidi.lag(lgu,lgd).midicps;
    freq = SinOsc.kr( { 2.9 rrand: 3.1 }!3, {2pi.rand}!3 ).exprange(
0.995, 1.005 ) * freq;
    pwm = SinOsc.kr( {2.0 rrand: 4.0}!3 ).range(0.125,0.875);

    // the saw/pulses
    mix = (LFSaw.ar( freq * [0.25,0.5,1], 1 ).range(0,1)
        * (1 - LFPulse.ar(freq * [0.5,1,2], 0, pwm))).sum * 0.1;

    // the bass
    mix = mix + LFPar.ar( freq * 0.25, 0, 0.1 );

    // eq for extra sharpness
    mix = BPeakEQ.ar( mix, 6000, 1, 3 );
    mix = BPeakEQ.ar( mix, 3500, 1, 6 );

    // kind of chorus
    mix = mix + CombC.ar( mix.dup, 1/200,
        SinOsc.kr( 3, [0.5pi, 1.5pi] ).range(1/300,1/200),
        0.0 ) * 0.5;

    env = EnvGen.kr( Env.asr, gate );

    Out.ar( 0, mix * env * amp );
}).add;
)

this is a hoover sound fetched from this list,
which after a further discussion I had in here I managed to run and
alter while running with the bellow approach
(
p = PbindProxy(\amp, 0.1, \lgu, 0.1, \lgd, 1, \dur, 0.2, \midinote, 80);
q = Pchain(Pmono(\hoover, \dummy, 0), p).play;
~dur = Pseq([0.2, 2, 0.2, 0.5] * 0.125, inf);
~lgu = Pseq([0, 5, 1.15, 2], inf);
~lgd = Pseq([ 1.1, 5.1, 0.5, 2.1], inf);
~midinote = Pseq([25, 120, 92, 70] , inf);
)
(
p.set(\amp, 0.1, \dur, ~dur, \lgu, ~lgu, \lgd, ~lgd, \midinote, ~midinote);
)

up to here everything is understandable and works as expected.
but when I run the bellow code multiple times (really fast or not) I get
different sound results!
Why? I get that it wouldn't be in sync, so each time I fire it'll I
brake the previous cycle, but why the sound result is different? What I
am missing?
(
~dur = Pseq([0.5, 1, 0.5, 0.8] * 0.125, inf);
p.set(\dur, ~dur);
)
