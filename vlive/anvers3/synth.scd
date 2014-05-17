(
SynthDef("snare", {	

		arg outBus=0, amp=0.8;

		var env0, env1, env2, env1m, oscs, noise, out;

		

		env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.03, 0.10], [-4, -2, -4]));

		env1 = EnvGen.ar(Env.new([110, 60, 49], [0.005, 0.1], [-4, -5]));

		env1m = env1.midicps;

		env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, 0.13], [-2, -2]), doneAction:2);

		

		oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);

		oscs = LPF.ar(oscs, env1m*1.2, env0);

		oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

		

		noise = WhiteNoise.ar(0.2);

		noise = HPF.ar(noise, 200, 2);

		noise = BPF.ar(noise, 6900, 0.6, 3) + noise;

		noise = noise * env2;

		

		out = oscs + noise;

		out = out.clip2(1) * amp;

			

		Out.ar(outBus, out.dup);

	}).add;

	

	SynthDef("clap", {	

		arg out=0, amp = 0.5, hpfreq1=4000, bpfreq1=1000, bprq1=2, hpfreq2=5000, bpfreq2=1000, bprq2=3, bpamp2=0.7, pan=0, timeScale1=1, timeScale2=1;

		var env1, env2, noise1, noise2;
		var out1;

		env1 = EnvGen.ar(Env.new([0, 1, 0, 1, 0, 1, 0, 1, 0], [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03], [0, -3, 0, -3, 0, -3, 0, -4]), timeScale: timeScale1);
		env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.3], [0, -4]), doneAction:2, timeScale: timeScale2);

		noise1 = WhiteNoise.ar(env1);
		noise1 = HPF.ar(noise1, hpfreq1 * [0.99,1.01]);
		noise1 = BPF.ar(noise1, bpfreq1, bprq1);

		noise2 = WhiteNoise.ar(env2);
		noise2 = HPF.ar(noise2, hpfreq2);
		noise2 = BPF.ar(noise2, bpfreq2, bprq2, bpamp2);

		out1 = noise1 + noise2;
		out1 = out1 * 2;
		out1 = out1.softclip * amp;
		out = Pan2.ar(out1, pan, amp);
		Out.ar(out, out1);

	}).add;

	

	SynthDef("hat", {	

		arg out=0, amp=0.3;

		var env1, env2, oscs1, noise, n, n2;
		var sig;

		

		n = 5;

		thisThread.randSeed = 4;

		

		env1 = EnvGen.ar(Env.new([0, 1.0, 0], [0.001, 0.4], [0, -12]));

		env2 = EnvGen.ar(Env.new([0, 1.0, 0.05, 0], [0.002, 0.05, 0.13], [0, -4, -4]), doneAction:2);

		

		oscs1 = Mix.fill(n, {|i|

			SinOsc.ar(

				( i.linlin(0, n-1, 42, 74) + rand2(4.0) ).midicps,

				SinOsc.ar( (i.linlin(0, n-1, 78, 80) + rand2(4.0) ).midicps, 0.0, 12),

				1/n

			)

		});

		

		oscs1 = BHiPass.ar(oscs1, 1000, 2, env1);

		n2 = 8;

		noise = WhiteNoise.ar;

		noise = Mix.fill(n2, {|i|

			var freq;

			freq = (i.linlin(0, n-1, 40, 50) + rand2(4.0) ).midicps.reciprocal;

			CombN.ar(noise, 0.04, freq, 0.1)

		}) * (1/n) + noise;

		noise = BPF.ar(noise, 1000, 0.9, 0.5, noise);

		noise = BLowShelf.ar(noise, 1000, 0.5, -6);

		noise = BHiPass.ar(noise, 800, 1.5, env2);

		

		sig = noise + oscs1;

		sig = sig.softclip;

		sig = sig * amp;

		

		Out.ar(out, sig.dup);

	}).add;

	

	SynthDef("acid", {	

		arg outBus=0, gate=1, pitch=50, amp=0.1;

		var env1, env2, out;

		pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);

		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);

		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);

		out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);

	

		out = RLPF.ar(out, (pitch + env2).midicps, 0.3);

		out = out * env1;

		

		Out.ar(outBus, out.dup);

	}).add;


)
