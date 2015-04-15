b= BufDef(\scream, "vipere/scream.flac");
b= BufDef.mono(\scream, "vipere/scream.flac");

 (
SynthDef(\Grains,
{arg grainRate, gate = 1, sndbuf, panpos, outbus = 0;
var env, trig, dur, rate, pos, pan, grains, out;
env = EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], \sin, 1), gate, 1, doneAction: 2);
trig = Impulse.kr(grainRate);
dur = LFNoise0.kr(20).range(0,1);
rate = LFNoise2.kr.range(0.25, 1.5);
pos = LFNoise1.kr(0.1).range(0, 1);
pan = Dust2.kr(panpos);
grains = GrainBuf.ar(2, trig, dur, sndbuf, rate, pos, 2, pan);
out = Out.ar(outbus, grains) * env;
}).add;
)

Synth(\Grains, [\sndbuf, b, \grainRate, 10, \panpos, 500]);
{ SinOsc.ar(200) !2}.play



Current features:

    map any Ndef of Pdef parameter to a GUI object, including arrays and envelopes parameters
    map any Ndef of Pdef parameter to a MIDI control
    write easily a GUI showing current parameters mapped to your MIDI controls
    save and load presets, persistent across SC reboot
    morph between selected presets
    switch quickly between normal mode and bus mode in patterns (bus mode is the way to continuously control a parameter)*


(

//run each at same time in tandem using synth set below

~fth = 1.4142135623729;

SynthDef(\gsineicf, {arg graindur = 0.04, dur = 2000, atk = 0.007, rel = 0.01, gate = 1, amp = 1, i = 1, vol = 0.7, rate = 20,
	a, b, c, d, e, f, g, u, v, w, x, y, z;
	var s1, out, env1, s2, dseq, freq;
	dseq = Dseq([
	/*1*/	[ a , b , c , d , e , f],
	/*2*/	[ u = a/~fth, v = b/~fth, w = c/~fth, x = d/~fth, y = e/~fth, z = f/~fth ],
	/*3*/	[ a = u,      b = v*~fth, c = w,      d = x,      e = y,      f = z*~fth  ],
	/*4*/	[ u = a*~fth, v = b/~fth, w = c,      x = d,      y = e*~fth, z = f/~fth  ],
	/*5*/	[ a = u/~fth, b = v*~fth, c = w,      d = x*~fth, e = y,      f = z*~fth ],
	/*6*/	[ u = a*~fth, v = b,      w = c*~fth, x = d/~fth, y = e,      z = f  ],
	/*7*/	[ a = u/~fth, b = v/~fth, c = w/~fth, d = x,      e = y,      f = z ],
	/*8*/	[ u = a,      v = b*~fth, w = c,      x = d,      y = e/~fth, z = f ],
	/*9*/	[ a = u*~fth, b = v,      c = w,      d = x*~fth, e = y*~fth, f = z*~fth ],
	/*10*/	[ u = a,      v = b,      w = c*~fth, x = d/~fth, y = e,      z = f ],
	/*11*/	[ a = u/~fth, b = v/~fth, c = w/~fth, d = x*~fth, e = y,      f = z ],
	/*12*/	[ u = a*~fth, v = b*~fth, w = c*~fth, x = d/~fth, y = e/~fth, z = f/~fth ],
	/*13*/	[ a = u,      b = v,      c = w,      d = x*~fth, e = y,      f = z*~fth ],
	/*14*/	[ u = a,      v = b/~fth, w = c,      x = d,      y = e*~fth, z = f],
	/*15*/	[ a = u/~fth, b = v,      c = w/~fth, d = x,      e = y/~fth, f = z/~fth ],
	/*16*/	[ u = a,      v = b,      w = c*~fth, x = d/~fth, y = e,      z = f ],
	/*17*/	[ a = u,      b = v*~fth, c = w,      d = x,      e = y,      f = z*~fth],
	/*18*/	[ u = a*~fth, v = b/~fth, w = c/~fth, x = d*~fth, y = e*~fth, z = f/~fth ],
	/*19*/	[ a = u/~fth, b = v,      c = w,      d = x/~fth, e = y,      f = z*~fth ],
	/*20*/	[ u = a*~fth, v = b*~fth, w = c,      x = d,      y = e/~fth, z = f/~fth ],
	/*21*/	[ a = u,      b = v*~fth, c = w*~fth, d = x,      e = y,      f = z*~fth ],
	/*22*/	[ u = a,      v = b,      w = c/~fth, x = d*~fth, y = e,      z = f ],
	/*23*/	[ a = u,      b = v,      c = w,      d = x/~fth, e = y,      f = z/~fth ],
	/*24*/	[ u = a/~fth, v = b,      w = c,      x = d,      y = e,      z = f*~fth ],
	/*25*/	[ a = u*~fth, b = v*~fth, c = w*~fth, d = x,      e = y,      f = z*~fth ],
	/*26*/	[ u = a,      v = b/~fth, w = c/~fth, x = d/~fth, y = e/~fth, z = f ],
	/*27*/	[ a = u,      b = v,      c = w,      d = x/~fth, e = y/~fth, f = z ],
	/*28*/	[ u = a/~fth, v = b*~fth, w = c*~fth, x = d*~fth, y = e*~fth, z = f/~fth ],
	/*29*/	[ a = u,      b = v,      c = w/~fth, d = x/~fth, e = y,      f = z ],
	/*30*/	[ u = a*~fth, v = b/~fth, w = c*~fth, x = d*~fth, y = e/~fth, z = f*~fth ],
	/*31*/	[ a = u/~fth, b = v*~fth, c = w,      d = x,      e = y,      f = z/~fth ],
	/*32*/	[ u = a,      v = b/~fth, w = c,      x = d,      y = e*~fth, z = f ],
	/*33*/	[ a = u*~fth, b = v*~fth, c = w,      d = x,      e = y/~fth, f = z ],
	/*34*/	[ u = a/~fth, v = b/~fth, w = c,      x = d,      y = e*~fth, z = f*~fth ],
	/*35*/	[ a = u*~fth, b = v,      c = w,      d = x/~fth, e = y/~fth, f = z/~fth ],
	/*36*/	[ u = a/~fth, v = b,      w = c/~fth, x = d*~fth, y = e,      z = f*~fth ],
	/*37*/	[ a = u*~fth, b = v*~fth, c = w,      d = x,      e = y,      f = z ],
	/*38*/	[ u = a,      v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f ],
	/*39*/	[ a = u/~fth, b = v*~fth, c = w/~fth, d = x*~fth, e = y/~fth, f = z/~fth ],
	/*40*/	[ u = a,      v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f ],
	/*41*/	[ a = u*~fth, b = v,      c = w/~fth, d = x,      e = y,      f = z*~fth ],
	/*42*/	[ u = a,      v = b*~fth, w = c,      x = d,      y = e/~fth, z = f ],
	/*43*/	[ a = u/~fth, b = v,      c = w*~fth, d = x*~fth, e = y*~fth, f = z ],
	/*44*/	[ u = a,      v = b*~fth, w = c,      x = d,      y = e,      z = f/~fth ],
	/*45*/	[ a = u/~fth, b = v,      c = w,      d = x/~fth, e = y/~fth, f = z ],
	/*46*/	[ u = a,      v = b/~fth, w = c/~fth, x = d*~fth, y = e*~fth, z = f ],
	/*47*/	[ a = u,      b = v*~fth, c = w*~fth, d = x/~fth, e = y,      f = z ],
	/*48*/	[ u = a,      v = b,      w = c/~fth, x = d*~fth, y = e,      z = f ],
	/*49*/	[ a = u,      b = v,      c = w*~fth, d = x,      e = y/~fth, f = z*~fth ],
	/*50*/	[ u = a*~fth, v = b/~fth, w = c,      x = d,      y = e*~fth, z = f/~fth ],
	/*51*/	[ a = u/~fth, b = v,      c = w,      d = x/~fth, e = y/~fth, f = z*~fth ],
	/*52*/	[ u = a*~fth, v = b,      w = c/~fth, x = d*~fth, y = e,      z = f/~fth ],
	/*53*/	[ a = u,      b = v*~fth, c = w,      d = x,      e = y,      f = z ],
	/*54*/	[ u = a/~fth, v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f*~fth ],
	/*55*/	[ a = u,      b = v,      c = w,      d = x*~fth, e = y/~fth, f = z ],
	/*56*/	[ u = a*~fth, v = b,      w = c,      x = d,      y = e,      z = f*~fth ],
	/*57*/	[ a = u,      b = v*~fth, c = w/~fth, d = x,      e = y*~fth, f = z ],
	/*58*/	[ u = a/~fth, v = b,      w = c*~fth, x = d/~fth, y = e,      z = f*~fth ],
	/*59*/	[ a = u*~fth, b = v,      c = w/~fth, d = x,      e = y,      f = z/~fth ],
	/*60*/	[ u = a/~fth, v = b,      w = c,      x = d,      y = e,      z = f*~fth ],
	/*61*/	[ a = u*~fth, b = v,      c = w,      d = x,      e = y,      f = z ],
	/*62*/	[ u = a/~fth, v = b/~fth, w = c*~fth, x = d*~fth, y = e/~fth, z = f/~fth ],
	/*63*/	[ a = u,      b = v*~fth, c = w/~fth, d = x,      e = y,      f = z*~fth ],
	/*64*/	[ u = a*~fth, v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f/~fth ]], inf);
	s1 = GrainSin.ar(2, LFPulse.kr(dur.reciprocal), dur, Demand.ar(LFPulse.ar(dur.reciprocal), 0, dseq));
	s1 = (s1.dup);
	s1 = s1*vol;
	Out.ar(0, s1);
}).load(s);

SynthDef(\gsineicr, {arg graindur = 0.04, dur = 2000, atk = 0.007, rel = 0.01, gate = 1, amp = 1, i = 1, vol = 0.7, rate = 20,
	a, b, c, d, e, f, g, u, v, w, x, y, z;
	var s1, out, env1, s2, dseq, freq;
	dseq = Dseq([
	/*1*/	[ a , b , c , d , e , f],
	/*2*/	[ u = a/~fth, v = b/~fth, w = c/~fth, x = d/~fth, y = e/~fth, z = f/~fth ],
	/*3*/	[ a = u,      b = v*~fth, c = w,      d = x,      e = y,      f = z*~fth  ],
	/*4*/	[ u = a*~fth, v = b/~fth, w = c,      x = d,      y = e*~fth, z = f/~fth  ],
	/*5*/	[ a = u/~fth, b = v*~fth, c = w,      d = x*~fth, e = y,      f = z*~fth ],
	/*6*/	[ u = a*~fth, v = b,      w = c*~fth, x = d/~fth, y = e,      z = f  ],
	/*7*/	[ a = u/~fth, b = v/~fth, c = w/~fth, d = x,      e = y,      f = z ],
	/*8*/	[ u = a,      v = b*~fth, w = c,      x = d,      y = e/~fth, z = f ],
	/*9*/	[ a = u*~fth, b = v,      c = w,      d = x*~fth, e = y*~fth, f = z*~fth ],
	/*10*/	[ u = a,      v = b,      w = c*~fth, x = d/~fth, y = e,      z = f ],
	/*11*/	[ a = u/~fth, b = v/~fth, c = w/~fth, d = x*~fth, e = y,      f = z ],
	/*12*/	[ u = a*~fth, v = b*~fth, w = c*~fth, x = d/~fth, y = e/~fth, z = f/~fth ],
	/*13*/	[ a = u,      b = v,      c = w,      d = x*~fth, e = y,      f = z*~fth ],
	/*14*/	[ u = a,      v = b/~fth, w = c,      x = d,      y = e*~fth, z = f],
	/*15*/	[ a = u/~fth, b = v,      c = w/~fth, d = x,      e = y/~fth, f = z/~fth ],
	/*16*/	[ u = a,      v = b,      w = c*~fth, x = d/~fth, y = e,      z = f ],
	/*17*/	[ a = u,      b = v*~fth, c = w,      d = x,      e = y,      f = z*~fth],
	/*18*/	[ u = a*~fth, v = b/~fth, w = c/~fth, x = d*~fth, y = e*~fth, z = f/~fth ],
	/*19*/	[ a = u/~fth, b = v,      c = w,      d = x/~fth, e = y,      f = z*~fth ],
	/*20*/	[ u = a*~fth, v = b*~fth, w = c,      x = d,      y = e/~fth, z = f/~fth ],
	/*21*/	[ a = u,      b = v*~fth, c = w*~fth, d = x,      e = y,      f = z*~fth ],
	/*22*/	[ u = a,      v = b,      w = c/~fth, x = d*~fth, y = e,      z = f ],
	/*23*/	[ a = u,      b = v,      c = w,      d = x/~fth, e = y,      f = z/~fth ],
	/*24*/	[ u = a/~fth, v = b,      w = c,      x = d,      y = e,      z = f*~fth ],
	/*25*/	[ a = u*~fth, b = v*~fth, c = w*~fth, d = x,      e = y,      f = z*~fth ],
	/*26*/	[ u = a,      v = b/~fth, w = c/~fth, x = d/~fth, y = e/~fth, z = f ],
	/*27*/	[ a = u,      b = v,      c = w,      d = x/~fth, e = y/~fth, f = z ],
	/*28*/	[ u = a/~fth, v = b*~fth, w = c*~fth, x = d*~fth, y = e*~fth, z = f/~fth ],
	/*29*/	[ a = u,      b = v,      c = w/~fth, d = x/~fth, e = y,      f = z ],
	/*30*/	[ u = a*~fth, v = b/~fth, w = c*~fth, x = d*~fth, y = e/~fth, z = f*~fth ],
	/*31*/	[ a = u/~fth, b = v*~fth, c = w,      d = x,      e = y,      f = z/~fth ],
	/*32*/	[ u = a,      v = b/~fth, w = c,      x = d,      y = e*~fth, z = f ],
	/*33*/	[ a = u*~fth, b = v*~fth, c = w,      d = x,      e = y/~fth, f = z ],
	/*34*/	[ u = a/~fth, v = b/~fth, w = c,      x = d,      y = e*~fth, z = f*~fth ],
	/*35*/	[ a = u*~fth, b = v,      c = w,      d = x/~fth, e = y/~fth, f = z/~fth ],
	/*36*/	[ u = a/~fth, v = b,      w = c/~fth, x = d*~fth, y = e,      z = f*~fth ],
	/*37*/	[ a = u*~fth, b = v*~fth, c = w,      d = x,      e = y,      f = z ],
	/*38*/	[ u = a,      v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f ],
	/*39*/	[ a = u/~fth, b = v*~fth, c = w/~fth, d = x*~fth, e = y/~fth, f = z/~fth ],
	/*40*/	[ u = a,      v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f ],
	/*41*/	[ a = u*~fth, b = v,      c = w/~fth, d = x,      e = y,      f = z*~fth ],
	/*42*/	[ u = a,      v = b*~fth, w = c,      x = d,      y = e/~fth, z = f ],
	/*43*/	[ a = u/~fth, b = v,      c = w*~fth, d = x*~fth, e = y*~fth, f = z ],
	/*44*/	[ u = a,      v = b*~fth, w = c,      x = d,      y = e,      z = f/~fth ],
	/*45*/	[ a = u/~fth, b = v,      c = w,      d = x/~fth, e = y/~fth, f = z ],
	/*46*/	[ u = a,      v = b/~fth, w = c/~fth, x = d*~fth, y = e*~fth, z = f ],
	/*47*/	[ a = u,      b = v*~fth, c = w*~fth, d = x/~fth, e = y,      f = z ],
	/*48*/	[ u = a,      v = b,      w = c/~fth, x = d*~fth, y = e,      z = f ],
	/*49*/	[ a = u,      b = v,      c = w*~fth, d = x,      e = y/~fth, f = z*~fth ],
	/*50*/	[ u = a*~fth, v = b/~fth, w = c,      x = d,      y = e*~fth, z = f/~fth ],
	/*51*/	[ a = u/~fth, b = v,      c = w,      d = x/~fth, e = y/~fth, f = z*~fth ],
	/*52*/	[ u = a*~fth, v = b,      w = c/~fth, x = d*~fth, y = e,      z = f/~fth ],
	/*53*/	[ a = u,      b = v*~fth, c = w,      d = x,      e = y,      f = z ],
	/*54*/	[ u = a/~fth, v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f*~fth ],
	/*55*/	[ a = u,      b = v,      c = w,      d = x*~fth, e = y/~fth, f = z ],
	/*56*/	[ u = a*~fth, v = b,      w = c,      x = d,      y = e,      z = f*~fth ],
	/*57*/	[ a = u,      b = v*~fth, c = w/~fth, d = x,      e = y*~fth, f = z ],
	/*58*/	[ u = a/~fth, v = b,      w = c*~fth, x = d/~fth, y = e,      z = f*~fth ],
	/*59*/	[ a = u*~fth, b = v,      c = w/~fth, d = x,      e = y,      f = z/~fth ],
	/*60*/	[ u = a/~fth, v = b,      w = c,      x = d,      y = e,      z = f*~fth ],
	/*61*/	[ a = u*~fth, b = v,      c = w,      d = x,      e = y,      f = z ],
	/*62*/	[ u = a/~fth, v = b/~fth, w = c*~fth, x = d*~fth, y = e/~fth, z = f/~fth ],
	/*63*/	[ a = u,      b = v*~fth, c = w/~fth, d = x,      e = y,      f = z*~fth ],
	/*64*/	[ u = a*~fth, v = b/~fth, w = c*~fth, x = d/~fth, y = e*~fth, z = f/~fth ]].reverse, inf);
	s1 = GrainSin.ar(2, LFPulse.kr(dur.reciprocal), dur, Demand.ar(LFPulse.ar(dur.reciprocal), 0, dseq));
	s1 = (s1.dup);
	s1 = s1*vol;
	Out.ar(0, s1);
}).load(s);
)

Synth(\gsineicf, [\dur, 1/103.55417528, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicr, [\dur, 1/103.55417528, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicf, [\dur, 1/103.55417528*3, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicr, [\dur, 1/103.55417528*3, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicf, [\dur, 1/103.55417528*6, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicr, [\dur, 1/103.55417528*6, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);



Synth(\gsineicf, [\dur, 1/10.55417528, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicr, [\dur, 1/1.55417528, \a, 987, \b,  876, \c, 765, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicf, [\dur, 1/5.55417528, \a, 97, \b,  86, \c, 75, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicf, [\dur, Ndef(\lfo1, { 1/SinOsc.kr(1).range(1,10)  }).asMap, \a, 97, \b,  86, \c, 75, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicr, [\dur, Ndef(\lfo1, { 1/SinOsc.kr(1.2).range(1,10)  }).asMap, \a, 97, \b,  86, \c, 75, \d, 654, \e, 543, \f, 789, \vol, 0.007]);
Synth(\gsineicr, [\dur, Ndef(\lfo1, { 1/LFNoise1.kr(0.4).range(4,30)  }).asMap, \a, 97, \b,  86, \c, 75, \d, 654, \e, 543, \f, 789, \vol, 0.007]);

