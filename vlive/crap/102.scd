(
Ndef(\bla, {
  var trig, snd, melody, bass, active, ff, wanderfreq, wander, lead, delay, baseSnd, env0, env1, env1m, son, bassGate;
  delay = 0;
  active = LFSaw.kr(1/1, 1)<0.75;
  trig = Impulse.ar(17, 0, active) * SinOsc.ar(331);
  snd = GVerb.ar(trig, 2, 1, spread: 50) * RLPF.ar(LFSaw.ar(333), LFNoise1.kr(2, 4, 100).midicps);
  snd = Select.ar(
    SetResetFF.ar(Impulse.ar(7) * SinOsc.ar(11.326)),
    [snd, Compander.ar(snd * LFPulse.ar(3000))]
  );
  baseSnd = snd;

  // borrowing from Nathnainiel's melodic idea here
  lead = snd + FreeVerb.ar(
    AllpassC.ar(Ringz.ar(Impulse.ar(17, mul: 0.075),
      Select.kr(
        SinOsc.kr(4).range(0, 5), // try different freqs for SinOsc [4, 8, etc.] and max ranges...5, 10, 20
        [329.63, 493.88, 392.00, 587.33, 659.25]
      ),
      0.2), 0.02, 0.02, 4, 4), 0.1, 0.5, 0.5);
  lead = lead * (Sweep.kr(0, 1.0) > (1 * delay)) * 0.7;
  snd = snd + lead;

  // nice, backseatviolinist. made a few small edits to make it thinner
  wanderfreq = LFSaw.kr(1/(14*1), 0).exprange(0.05, 3);
  wander = PitchShift.ar(
    snd,
    110.001,
    Gendy1.kr(1, 1, 1, 1, wanderfreq, wanderfreq, initCPs: 0).exprange(1, 4),
    // wait two phrases before turning this on
    mul: (Sweep.kr(0, 1.0) > (14 * delay * 2)) * 0.7
  );
  snd = snd + wander;

  // Glen's wonky bass
  bass = PMOsc.ar(
    SinOsc.kr(7/2, 0, 12, 52 + LFNoise0.kr(7/6, 4)).round(4).midicps * [1, 1.01],
    [165, 168.3],
    SinOsc.kr([1/7, 1/3]).exprange(0.25, 4),
    0,
    // LFPulse.kr(7/2, [0.5, 0], LFDNoise0.kr(7/32, 0.4, 0.5!2), -15.dbamp)
    LFPulse.kr(7/2, [0.5, 0], 0.15, -15.dbamp)
  );
  bass = bass * (LFPulse.kr(8/14, 0, 0.25) + LFPulse.kr(14, 0, 0.25)).clip(0,1);
  ff = active;
  bass = BLowPass.ar(bass, 200, 1, 6) * ff + (1 - ff * HPF.ar(bass, 200, -6.dbamp));
  bass = bass * (Sweep.kr(0, 1.0) > (14 * delay * 0)) * 0.7;
  snd = snd + bass;

  // top elementia
  melody = baseSnd + FreeVerb.ar(
    AllpassN.ar(Ringz.ar(Impulse.ar([7/2, 7], [0.5, 0], mul: 0.1),
      Select.kr(
        LFCub.kr(4).range(0, 20),
        [329.63, 392.00, 493.88, 587.33, 659.25] * 1.5
      ),
      0.2
  ), 0.02, 0.02, 4, 4), 0.1, 0.5, 0.5);
  melody = melody * (Sweep.kr(0, 1.0) > (14 * delay * 3)) * 0.7;
  snd = snd + melody;

  // borrowing a kick from rukano: http://sccode.org/1-4Ek
  bassGate = Impulse.ar(11, 0) * SinOsc.ar(131); // derived from 'active' above
  env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), gate: bassGate);
  env1 =  EnvGen.ar(Env.new([070, 59, 29], [0.005, 0.29], [-4, -5]), gate: bassGate);
  env1m = env1.midicps;
  son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
  son = son + WhiteNoise.ar(1);
  son = LPF.ar(son, env1m*1.5, env0);
  son = son + SinOsc.ar(env1m, 0.5, env0);
  son = son * (Sweep.kr(0, 1.0) > (14 * delay * 4)) * 0.7;
  son = son * 0.75;
  son = son.clip2(1);

  snd = snd + son;
  Limiter.ar(snd);

}).play;
)



// Rumush
// Facebook: https://www.facebook.com/rumushproduction
// SoundCloud: https://soundcloud.com/rumushproduction
// YouTube: https://www.youtube.com/channel/UCs_Cn1R4iFrYOyc8liFucSQ
// Blog: https://mycelialcordsblog.wordpress.com/
// GitHub: https://github.com/RumushMycelialCords

(
{
	var pulse = 0.25;
	var control = Duty.ar(1/pulse*4,0,Dseq([0,2,4,3,2,0],1),2);
	var del = DemandEnvGen.ar(Dbrown(0.05,0.25,0.005),Dseq([2,2,4,1,1,1,1],inf));
	var src1 = Blip.ar(pulse!2,control,0.25) ring4: Hasher.ar(LFSaw.ar(1,0,100).abs);
	var src2 = Blip.ar((pulse*2)!2,control+2,0.25) ring4: Hasher.ar(LFSaw.ar(2,0,100).abs);
	var src3 = Blip.ar((pulse+3.rand)!2,control+3,0.25) ring4: Hasher.ar(LFSaw.ar(3,0,100).abs);
	var src4 = Blip.ar((pulse*2.05)!2,control+4,0.25) ring4: Hasher.ar(LFSaw.ar(4,0,100).abs);
	var out = src1+src2+src3+src4*LFPulse.ar(pulse*2,0,0.5,0.75,0.25);
	out ring1: Splay.arFill(8,{Pulse.ar([rrand(300,500),rrand(300,500)])})
}.play
)
(
{
	var pulse = 0.25;
	var control = Duty.ar(1/pulse*4,0,Dseq([0,2,4,3,2,0],1),2);
	var del = DemandEnvGen.ar(Dbrown(0.05,0.25,0.005),Dseq([2,2,4,1,1,1,1],inf));
	var src1 = Blip.ar(pulse!2,control,0.25) ring4: Hasher.ar(LFSaw.ar(1,0,100).abs);
	var src2 = Blip.ar((pulse*2)!2,control+2,0.25) ring4: Hasher.ar(LFSaw.ar(2,0,100).abs);
	var src3 = Blip.ar((pulse+3.rand)!2,control+3,0.25) ring4: Hasher.ar(LFSaw.ar(3,0,100).abs);
	var src4 = Blip.ar((pulse*2.05)!2,control+4,0.25) ring4: Hasher.ar(LFSaw.ar(4,0,100).abs);
	var out = src1+src2+src3+src4*LFPulse.ar(pulse*2,0,0.5,0.75,0.25);
	var outC = CombC.ar(out*Decay.ar(Impulse.ar(pulse*2,2),0.25),0.5,del,16,0.5);
	out+outC ring1: Splay.arFill(8,{Pulse.ar([rrand(300,500),rrand(300,500)])})
}.play
)
(
{
	var pulse = 1;
	var control = Duty.ar(1/pulse*4,0,Dseq([0,2,4,3,2,0],1),2);
	var del = DemandEnvGen.ar(Dbrown(0.005,0.05,0.005),Dseq([2,2,4,1,1,1,1],inf));
	var src1 = Blip.ar(pulse!2,control,0.25) ring4: Hasher.ar(LFSaw.ar(1,0,100).abs);
	var src2 = Blip.ar((pulse*4.rand)!2,control+2,0.25) ring4: Hasher.ar(LFSaw.ar(2,0,100).abs);
	var src3 = Blip.ar((pulse*4.rand)!2,control+3,0.25) ring4: Hasher.ar(LFSaw.ar(3,0,100).abs);
	var src4 = Blip.ar((pulse*4.rand)!2,control+4,0.25) ring4: Hasher.ar(LFSaw.ar(4,0,100).abs);
	var out = src1+src2+src3+src4*LFPulse.ar(pulse*2,0,0.5,0.75,0.25);
	out ring3: Splay.arFill(8,{HenonC.ar([rrand(300,15000),rrand(300,15000)],rrand(1.0,1.4))})
}.play
)
(
{
	var pulse = LFNoise0.ar(4).range(0.5,20);
	var control = Duty.ar(1/pulse*4,0,Dseq([0,2,4,3,2,0],inf),2);
	var del = DemandEnvGen.ar(Dbrown(0.005,0.05,0.005),Dseq([2,2,4,1,1,1,1],inf));
	var src1 = Blip.ar(pulse!2,control,0.25) ring4: Hasher.ar(LFSaw.ar(1,0,100).abs);
	var src2 = Blip.ar((pulse*4.rand)!2,control+2,0.25) ring4: Hasher.ar(LFSaw.ar(2,0,100).abs);
	var src3 = Blip.ar((pulse*4.rand)!2,control+3,0.25) ring4: Hasher.ar(LFSaw.ar(3,0,100).abs);
	var src4 = Blip.ar((pulse*4.rand)!2,control+4,0.25) ring4: Hasher.ar(LFSaw.ar(4,0,100).abs);
	var out = src1+src2+src3+src4*LFPulse.ar(pulse*2,0,0.5,0.75,0.25);
	out ring3: Splay.arFill(16,{HenonC.ar([rrand(300,15000),rrand(300,15000)],rrand(1.0,1.4))})
}.play
)
(
{
	var pulse = LFNoise0.ar(16).range(50,250);
	var control = Duty.ar(1/pulse*4,0,Dseq([0,2,4,3,2,0],inf),2);
	var del = DemandEnvGen.ar(Dbrown(0.005,0.05,0.005),Dseq([2,2,4,1,1,1,1],inf));
	var src1 = Blip.ar(pulse!2,control,0.25) ring4: Hasher.ar(LFSaw.ar(1,0,100).abs);
	var src2 = Blip.ar((pulse*4.rand)!2,control+2,0.25) ring4: Hasher.ar(LFSaw.ar(2,0,100).abs);
	var src3 = Blip.ar((pulse*4.rand)!2,control+3,0.25) ring4: Hasher.ar(LFSaw.ar(3,0,100).abs);
	var src4 = Blip.ar((pulse*4.rand)!2,control+4,0.25) ring4: Hasher.ar(LFSaw.ar(4,0,100).abs);
	var out = src1+src2+src3+src4*LFPulse.ar(pulse*2,0,0.5,0.75,0.25);
	out ring3: Splay.arFill(16,{HenonC.ar([rrand(300,15000),rrand(300,15000)],rrand(1.0,1.4))})
}.play
)
