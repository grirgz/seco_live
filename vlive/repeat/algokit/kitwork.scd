

(
Ndef(\saro, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [0,3,7,9,13].midiratio;
	sig1 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr((1..8)/148 * ( 1 + ( SinOsc.kr(1/124 * (1..8)) * 1 ))) * 0.01 )));
	sig2 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr((1..8)/148 + 0.0001) * 0.01 )));
	sig3 = SinOsc.ar(freq*[1/2,1/4,2,1/8,4]);
	sig = sig1 + sig2 + sig3;
	sig = sig * LFPulse.kr((1..8).scramble/4+0.001).range(0,1);
	//sig = BPF.ar(sig, SinOsc.kr((1..8)/20).range(140,9001));
	sig = BPF.ar(sig, SinOsc.kr((1..8)/40 * ( 1 + ( SinOsc.kr(1/98 * (1..8)) * 1 ))).range(freq/1.2,freq*1.2), 0.17) + (sig/4 );
	sig = LPF.ar(sig, 5000);
	pan = pan + SinOsc.ar((1..8)/100, mul:0.3);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play(BusDef(\sendbus0,\audio).index,2);
);

8.do { arg x; BufDef(\rec16_t+++x, 16*s.sampleRate/~t); }

PatKitDef(\rdnfx).edit

(
SynthDef(\playersec_hlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = LPF.ar(sig, \lpf.kr(19000));
	sig = HPF.ar(sig, \hpf.kr(40));
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\playersec_hlpf);
)


(
	Pdef(\main, Ppar([
		4.collect({
			PdrumStep(PatKitDef(\rdnfx).targets, Pbind(
				\kitIndex, rrand(0,2),
				\freq, 200,
				[\legato, \isRest], Plazy({
					var rest, leg;

					rest = Pseq({ [
						7,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						1,0,4,0, 0,0,0,0,
						0,0,4,0, 0,0,0,0,
						1,1,1,3, 0,0,0,0,
						0,0,0,0, 1,1,0,1,
					].clump(8).choose }.dup(4).flat,4);
					leg = rest;
					Ptuple([leg.linlin(0,20,1,20), rest.coin.not]);
				}).loop,
				\dur, 1/1,
				\amp, 0.1
			), 1, key:\kitIndex);
		})
	].flat)).play;
)

FileSystemProject.load("algokit/PatKitDef_scapkit.scd")

ParamProto.init(true)
PatKitDef(\scapkit).edit
PatKitDef(\scapkit).savePresetCompileString("algokit/PatKitDef_scapkit.scd")
Spec.specs[\lag] = nil;
Spec.specs[\lag].default;
KitTimeline(\scapline, PatKitDef(\scapkit))
KitTimeline(\scapline).edit
PatKitDef(\scapkit).targets.first.target
PatKitDef(\scapkit).targets.first
SparseArray[12,122].first
KitTimeline(\scapline).clear
Log(\Param).debug("kjkj");
Log(\Param).level = \debug


////////////////////////////// algokit

(
Pdef(\drums, 
	Plazy({
		var kickline, hatline;
		kickline = {
			var seqs;
			var seq = {[
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			].clump(8).choose};

			seqs = seq ! 8;

			Pseq(

				( 
					//seq.value ! 3 ++ seq.value 
					//++ 
					//seq.value ! 3 ++ seq.value 
					//++ 
					//seq.dup(2) ++ seq.dup(2) 
					seqs[0] ++ seqs[1]
					++
					seqs[0] ++ seqs[2]
					//++
					//seqs[3] ++ seqs[2]
					//++
					//seqs[4] ++ seqs[5]
				).flat
				,inf
			).coin.not;
		};
		hatline = {Pser({[
			1,1,1,1, 1,1,1,1,
			1,1,0,0, 1,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,1,1, 0,0,1,1,
			1,0,1,0, 1,0,1,0,
			0,0,1,0, 1,1,1,0,
			1,0,1,0, 1,1,0,1,
			1,0,0,0, 1,0,0,0,
			1,1,0,0, 1,0,0,0,
			0,0,1,0, 0,0,1,0,
		].clump(8).choose}.dup(16).flat,inf).coin.not};


		Pseq([
			PdrumStep(PatKitDef(\scapkit).targets, Ppar([
				Pbind(
					\kitIndex, 0,
					\isRest, kickline.value,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 1,
					//\isRest, kickline.value,
					\gain,  Pseq([
						0.7, 0.7, 1, 0.7,
					],inf),
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 0,0,1,0,
						0,0,0,1, 0,0,0,0,
						0,0,1,0, 0,0,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,1,1,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\speed, 1.8,
					\sustain, 0.051,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 1,
					\isRest, kickline.value,
					\gain,  Pseq([
						0.7, 0.7, 0.7, 1
					],inf)/1.2,
					\lag, 0.01,
					\sustain, 0.2,
					\speed, 1.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, hatline.value,
					\sustain, 0.04,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, hatline.value,
					\sustain, 0.05,
					\isRest, Pseq({[
						1,0,1,0, 0,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
						0,1,0,1, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\speed, 1.5,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 10,
					\isRest, hatline.value,
					\sustain, 0.18,
					\speed, 0.9,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 4,
					\freq, 200,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 5,
					\freq, 200,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0.2,0,
						0,0,0,0, 1,0,0,0,
						0,0.2,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0.4,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\sustain, Pseq([0.1,0.2,0.05,0.3,0.1],inf),
					\dur, 1/8,
					\amp, 0.1
				),
			]), 1, key:\kitIndex)

		])
	})
).play;
)


Pdef(\drums).set(\out, BusDef(\sendbus0, \audio))
ProtoDef(\rdn).edit
ProtoDef(\rdn).play
