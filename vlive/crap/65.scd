(
SynthDef.new(\blip, {
arg out, out2;
var freq, trig, sig;
freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
sig = Saw.ar(freq) * 0.25;
trig = Dust.kr(2);
sig = sig*EnvGen.kr(Env.perc(0.01, 1.2), trig);
sig = Pan2.ar(sig, LFNoise1.kr(10));
Out.ar(out, sig);
Out.ar(out2, sig);
}).add;

SynthDef.new(\reverb, {
arg in, out=0;
var sig;
sig = In.ar(in, 2);
//sig = SVF.ar(in, LFDNoise0.ar(20, 400, 900), 0.1);
sig = CombL.ar(sig, 0.5,0.5,2) + sig;
//sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
Out.ar(out, sig);
}).add;
)

~groupa=Group.new;
~groupb = Group.after(~groupa);
~reverbBus = Bus.audio(s, 2);
x = Synth.new(\blip, [\out, [~reverbBus], \out2, [0]], ~groupa);

y = Synth.new(\reverb, [\in, ~reverbBus], ~groupb);
y.free
