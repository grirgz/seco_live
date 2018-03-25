(
{
var freq, trig = Dust.kr(3);
freq = TRand.kr(300, 3000, trig);
freq.poll; // reveals changing freq value
SinOsc.ar(freq
) * 0.1
}.play;
)
(
///////////////////////////////////
{
var trig, env, noise, rand;
trig = Impulse.ar(1.5);
rand = TRand.kr(0, 5000, trig);
rand.poll; // reveals a fixed single random value
env = Decay2.ar(trig, 0.008, 0.04);
// would like a random freq val for LFNoise2
// each time it's triggered
noise = LFNoise2.ar(rand, 1);
}.scope
)
