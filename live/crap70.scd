(
{
var sig, mod1, mod2, mod3, mod4, mod5;
var fsig, interval, fmod1, fmod2, fmod3, fmod4, fmod5;
var asig, amod;
var phase, phase2, phase3, env, trig;
var deg;

trig = 5;

deg = Array.series(405, 1, 5).normalize.scramble.post;
deg = Demand.kr(Impulse.kr(trig), 0, Dseq(deg, inf));
fmod1 = Demand.kr(Impulse.kr(trig), 0, Dseq([5252, 1009, 20, 100, 600, 100, 2, 4023], inf));
fmod2 = fmod1 + 12.5;
fmod3 = fmod1 + 20.5;
fmod4 = fmod3 + 10.25;
fmod5 = fmod2 + fmod3;

amod = 1;

fsig = 240*deg;
fsig = Lag2.kr(fsig, deg);

asig = 1;
interval = 1;

mod1 = SinOsc.ar(fmod1, 0, amod);
mod2 = SinOsc.ar(fmod2, deg*1.23121, amod + 0.25) * mod1;
mod3 = SinOsc.ar(fmod3, deg*1.2123, amod + 0.5);
mod4 = SinOsc.ar(fmod4, deg*0.7182, amod + 0.75);
mod5 = SinOsc.ar(fmod5, deg, amod + 1) * mod4;

phase = mod1+mod2+mod3+mod4+mod5;
phase2 = mod1+mod2;
phase3 = mod2+mod3+mod5;

sig = SinOsc.ar(fsig * interval, [phase, mod2], asig) + SinOsc.ar(fsig * interval, [phase2, phase], asig*0.75) +
SinOsc.ar(fsig * interval, [phase3, mod5], asig*0.5);
8.do({sig = AllpassN.ar(sig, deg, deg, 5)});
4.do({sig = AllpassN.ar(sig, 0.1, 0.2, 0.4)});

//sig = RLPF.ar(sig, 5500, deg*1.15);
sig = LeakDC.ar(Limiter.ar(sig, 0.65), 0.995);
sig = Pan2.ar(sig, 0);

sig;
}.play;
)
