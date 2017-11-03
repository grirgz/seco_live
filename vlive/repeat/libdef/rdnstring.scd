

(
	~rdn_to_string = { arg rdn;
		var tree;
		tree = ~simplify_tree.(rdn.tree);
		tree.asCompileString.postln;
		~tree_to_string.(tree, rdn.dict, ());
	};
	~rdn_to_fbstring = { arg rdn;
		var str = ~rdn_to_string.(rdn);
		var pbindcode = rdn.getPbindCompileString;
		"
		SynthDef(\\rdnfx, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\\inbus.kr(BusDef(\\fx1, \\audio)), 2); 

			thisThread.randSeed = %;

			sig = LocalIn.ar(2) * \\fb.kr(0.1) + in;
			si = sig;
			sig = %
			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \\eqmid1b.kr(12000), \\eqrq1b.kr(1), \\eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \\eqmid2b.kr(7000), \\eqrq2b.kr(1), \\eqdb2b.kr(0));
			//sig = HPF.ar(sig, \\ehpf.kr(140), \\ehprq.kr(1));
			//sig = LPF.ar(sig, \\elpf.kr(10000), \\elprq.kr(1));
			sig = SelectX.ar(\\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \\spread.kr(1), 1, \\pan.kr(0));
			sig = sig * \\gain.kr(1);
			sig = sig * EnvGen.kr(\\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

		%
		".format(rdn.class.codeToSeeds(rdn.code)[2], str, pbindcode)
	};
	~tree_to_string = { arg tree, dict, envir, level=0;
		var str = "";
		if(tree.isKindOf(Association)) {
			switch(tree.key, 
				\par, {
					"[\n%\n].mean".format(
						tree.value.collect({ arg el;
							level.collect({"\t"}).join ++ ~tree_to_string.(el, dict, envir, level+1)
						}).join(",\n")
					)
				},
				\seq, {
					tree.value.do({ arg el;
						var child = ~tree_to_string.(el, dict, envir, level+1);
						//if(el.isKindOf(Association).not) {
							//child = child.replace("{ arg si }")
						//}
						str = "%%si = %;\n".format(str, level.collect({"\t"}).join, child )
					});
					"%{ arg si, env;\n%}.value(si, env);\n".format(level.collect({"\t"}).join, str);
				}
			)
		} {
			var ss = dict[tree].asCompileString;
			//ss.debug("ss:"++tree);
			//"%".format(ss.drop(2).drop(-7).replace("arg si;", "").replace("arg si, env;", "")).replace("\t", "").drop(1);
			"%".format(ss.drop(2).replace("arg si;", "").replace("arg si, env;", "")).replace("\t", "").drop(1).drop(-3);
			//"%.value(si, env)".format(dict[tree].asCompileString.replace("\t\t", ""));

		}
	};
	~simplify_tree = { arg tree;
		var rule = { arg tree, el; el.isKindOf(Association) and: { el.key == tree.key } };
		var applyRule = { arg tree;
			if(tree.isKindOf(Association)) {
				var treeval = tree.value.collect({ arg el;
					if(rule.(tree, el)) {
						applyRule.(el).value
					} {
						applyRule.(el)
					}
				}).flat;
				treeval.remove(\end);
				tree = tree.key -> treeval;
				tree;
			};
			tree
		};
		applyRule.(tree);
	};
	//~rdn_to_string.(RandDelayNetwork(\deldefault)).editorInsert
//	~rdn_to_fbstring.(RandDelayNetwork(\deldefault));

)

// END
RandDelayNetwork(\deldefault).make(\fx1, "5--")
RandDelayNetwork(\deldefault).tree
RandDelayNetwork(\del3full).tree

	~rdn_to_fbstring.(RandDelayNetwork(\deldefault)).editorInsert
	~rdn_to_fbstring.(RandDelayNetwork(\del3)).editorInsert
	~rdn_to_fbstring.(RandDelayNetwork(\del3full)).editorInsert

	~rdn_to_fbstring.(RandDelayNetwork(\del3full))




	~s = RandDelayNetwork(\del3).dict[\shift].asCompileString
	~s = RandDelayNetwork(\del3).dict[\delay].asCompileString

			"%".format(~s.drop(2).drop(-7).replace("arg si;", "").replace("arg si, env;", "")).replace("\t", "").drop(1);
			"%".format(~s.drop(2).replace("arg si;", "").replace("arg si, env;", "")).replace("\t", "").drop(1).drop(-3);
			~s
			~s.keep(~s.findRegexp("}$")[0][0])
	Main.version


(
	// POC syntax

{
	var si;
	si = 2;
	si = [
		{ arg si;
			si.debug("si");
			si = si + 7;
		}.value(si),
		{ arg si;
			si = si * 2;
		}.value(si),
	].sum;
	si;
}.value
)


///////////////



(
	Ndef(\rdnfx, {
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 10321;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;

		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			//si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			//si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			//si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				}.value(si, env);

			].mean;
		}.value(si, env);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);
		sig = sig * \gain.kr(1);
		sig;

	}).play;

);


Ndef(\rdnfx).edit

(
Pdef(\test, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1, \audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
)



(
	Ndef(\rdnfx, {
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 10105;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;

		sig = { arg si, env;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr * LFSaw.kr(0.4).range(1,2)) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr * Amplitude.kr(si)/10) + si;
			//si = AllpassC.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr, 0.01) + si;

			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay.kr) + si;
			//si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			//si = BPF.ar(si, exprand(100,16000), 0.5.rand + 0.01) + ( si / 4 );
			//si = FreqShift.ar(si, 0.001) + sig;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = (si * 10.rand * \distamp.kr).tanh / 2;
			//si = [
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
					//si = (si * 10.rand * \distamp.kr).tanh / 2;
				//}.value(si, env);
				//,
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
				//}.value(si, env);

			//].mean;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay.kr) + si;
			si = LeakDC.ar(si);
			si = MidEQ.ar(si, \eqmid1.kr(12000), \eqrq1.kr(1), \eqdb1.kr(1));
			si = MidEQ.ar(si, \eqmid2.kr(12000), \eqrq2.kr(1), \eqdb2.kr(1));
		}.value(si, env);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);

		sig = sig * \gain.kr(1);
		sig;

	}).play;

);




(
	SynthDef(\rdnfx, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 


		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;

		sig = { arg si, env;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr * LFSaw.kr(0.4).range(1,2)) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr * Amplitude.kr(si)/10) + si;
			//si = AllpassC.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr, 0.01) + si;

			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay.kr) + si;
			//si = BRF.ar(si, 7000 * SinOsc.kr(2*~t).range(2,1), 0.4) + ( si / 4 );
			//si = BPF.ar(si, exprand(100,16000), 0.5.rand + 0.01) + ( si / 4 );
			//si = FreqShift.ar(si, 0.001) + sig;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = (si * 10.rand * \distamp.kr).tanh / 2;
			//si = [
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
					//si = (si * 10.rand * \distamp.kr).tanh / 2;
				//}.value(si, env);
				//,
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
				//}.value(si, env);

			//].mean;
			si = DelayL.ar(si, 0.8,  \delay1.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8,  \delay3.kr) + si;
					si = DelayL.ar(si, 0.8, \delay4.kr) + si;
					si = (si * 1 * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8,   \delay5.kr) + si;
					si = DelayL.ar(si, 0.8,   \delay6.kr) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8,  \delay7.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay8.kr) + si;
			si = LeakDC.ar(si);
			si = MidEQ.ar(si, \eqmid1.kr(12000), \eqrq1.kr(1), \eqdb1.kr(1));
			si = MidEQ.ar(si, \eqmid2.kr(7000), \eqrq2.kr(1), \eqdb2.kr(1));
		}.value(si, env);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));

		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		sig;
		Out.ar(out, sig);

	}).add;

);


(
Pdef(\test, 
	Ppar([
		Pmono( \rdnfx,
			\freq, 200,
			[\delay1, \delay2, \delay3, \delay4], Pseq([
//				rrand(0.01,0.8!4).asCompileString.editorInsert
				[ 0.000029597123265266, 0.00077669047355652, 0.00052289094924927, 0.0008009934902191 ]
				[ 0.000079597123265266, 0.00017669047355652, 0.00052289094924927, 0.0008009934902191 ]
			],inf).stutter(8) * Pseg(Pseq([0,1,2,4].dup(4).flop,inf),8),
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//rrand(0.01,0.08!4).asCompileString.editorInsert
				[ 0.0000034518146515, 0.00048690888881683, 0.00065039986371994, 0.00043064266443253 ],
				[ 0.00040134518146515, 0.0048690888881683, 0.00065039986371994, 0.0003064266443253 ],
				[ 0.00010134518146515, 0.00048690888881683, 0.00065039986371994, 0.00043064266443253 ],
			],inf).stutter(8),
			\fb, Pseq([0.03,0.01,0.1,0.01],inf) * Pseg(Pseq([0,1,2,4,8,16],inf),8),
			\distamp, Pseq([4,2,11,2],inf) * Pseg(Pseq([0,1,2,4,8],inf),8),
			\eqmid1, 4000,
			\eqdb1, 4,
			\dur, 1/4,
			\gain, 0.2,
			\mix, 0.4,
			\amp, 0.1
		),
		Pmono( \rdnfx,
			\freq, 200,
			[\delay1, \delay2, \delay3, \delay4], Pseq([
//				rrand(0.01,0.8!4).asCompileString.editorInsert
				[ 0.000029597123265266, 0.00077669047355652, 0.00052289094924927, 0.0008009934902191 ]
				[ 0.000079597123265266, 0.00017669047355652, 0.00052289094924927, 0.0008009934902191 ]
			],inf).stutter(8) *100* Pseg(Pseq([0,1,2,4].dup(4).flop,inf),8),
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//rrand(0.01,0.08!4).asCompileString.editorInsert
				[ 0.0010134518146515, 0.00048690888881683, 0.00065039986371994, 0.00043064266443253 ],
				[ 0.00040134518146515, 0.0048690888881683, 0.00065039986371994, 0.0003064266443253 ],
				[ 0.00010134518146515, 0.00048690888881683, 0.00065039986371994, 0.00043064266443253 ],
			],inf).stutter(8) * 1,
			\fb, Pseq([0.03,0.01,0.1,0.01],inf) * Pseg(Pseq([8,16],inf),8),
			\distamp, Pseq([4,2,11,2],inf) * Pseg(Pseq([4,8],inf),8),
			\eqmid1, 9000,
			\eqdb1, 4,
			\eqmid2, 5000,
			\eqdb2, 2,
			\inbus, BusDef(\fx2, \audio, 2),
			\dur, 1/4,
			\gain, 0.1/2,
			\mix, 0.5,
			\amp, 0.1
		),
		Pbind(
			\instrument, \siren,
			\out, BusDef(\fx2, \audio),
			\freq, 200,
			\dur, 1,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			//\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
			//],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1, \audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		//PatKitDef(\sample1).asPattern(Pbind(
			//\kitIndex, 1,
			//\isRest, Pseq({[
				//1,0,1,0, 0,0,0,0,
				//1,0,0,1, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,1,0,
			//].clump(8).choose}.dup(8).flat,inf).coin.not,
			//\sustain, 0.1,
			//\lag, 0.04,
			//\dur, 1/8,
			//\amp, 0.1,
		//)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
)



(
Pdef(\test, 
	Ppar([
		Pmono( \rdnfx,
			\freq, 200,
			[\delay1, \delay2, \delay3, \delay4], Pseq([
				[ 0.00097991525055216, 0.00064640859711667, 1.3285603153012e-05, 1.162944684652e-05 ]

			],inf).stutter(8),
			[\delay5, \delay6, \delay7, \delay8], Pseq([
//				exprand(0.00001,0.008!4).asCompileString.editorInsert(false)
[ 1.0272168142487e-05, 0.00027316959143652, 0.00010930292692079, 0.00022255799423243 ],
[ 1.0272168142487e-05, 0.01027316959143652, 0.00010930292692079, 0.00022255799423243 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(8),
			\fb, Pseq([0.03,0.01,0.1,0.01],inf) * Pseg(Pseq([0,1,2],inf),8),
			\distamp, Pseq([4,2,11,2],inf) * Pseg(Pseq([0,1],inf),8),
			\fb, 0.01,
			\distamp, Pseq([1,1,1,70.1],inf) * Pseq([1,2,4,8],inf).stutter(8),
			\eqmid1, 8000,
			\eqdb1, 4,
			\eqmid2, 600,
			\eqdb2, 4,
			\dur, 1/4,
			\gain, 0.2,
			\mix, 0.4,
			\spread, 0.01,
			\amp, 0.1
		),
		Pmono( \rdnfx,
			\freq, 200,
			[\delay1, \delay2, \delay3, \delay4], Pseq([

[ 0.0061257460851587, 6.4757768859376e-05, 0.0012539922079618, 0.00050567865908589 ]
			],inf).stutter(8),
			[\delay5, \delay6, \delay7, \delay8], Pseq([
//				exprand(0.00001,0.008!4).asCompileString.editorInsert(false)
[ 0.0012028675522597, 0.00057865463806498, 1.7149869113534e-05, 0.00069617971075739 ],
[ 0.0012028675522597, 0.00047865463806498, 0.7149869113534e-05, 0.00069617971075739 ],
[ 0.0012028675522597, 0.00067865463806498, 1.7149869113534e-05, 0.00069617971075739 ],
[ 0.0070610911055802, 2.624320581896e-05, 0.00012072760018441, 4.246078283486e-05 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(8),
			\fb, Pseq([0.03,0.01,0.1,0.01],inf) * Pseg(Pseq([0,1,2,10],inf),8),
			\distamp, Pseq([4,2,11,2],inf) * Pseg(Pseq([0,1,10],inf),8),
			\fb, 0.001,
			\distamp, 70.1,
			\eqmid1, 1600,
			\eqdb1, -4,
			\eqmid2, 9000,
			\eqdb2, 4,
			\dur, 1/4,
			\inbus, BusDef(\fx2, \audio, 2),
			\gain, 0.1/2,
			\mix, 1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \o3bass2,
			\degree, Pseq([
				0, 1s, 1, 0, 
			],inf),
			\osc1voices, [[2,1,1.01]],
			\osc2voices, [[2,1,1.01]],
			\osc3voices, [[2,1,1.01]],
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\lpenv, Pseq([
				[ Env([4,1/4,1,1],[0.04,0.14,0.8]) ],
			],inf),
			\octave, 3,
			\out, BusDef(\fx1, \audio),
			\dur, 1,
			\amp, 0.1
		),
		Pmono( \siren,
			\out, BusDef(\fx2, \audio),
			\fm, Pseg(Pseq([2,4]*~t,inf),8),
			\freq, Pseg(Pseq([1200,4000],inf),16),

			\dur, 1/2,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				0,0,1,1,0,0,1,0,
			],inf),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			//\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
			//],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1, \audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		//PatKitDef(\sample1).asPattern(Pbind(
			//\kitIndex, 1,
			//\isRest, Pseq({[
				//1,0,1,0, 0,0,0,0,
				//1,0,0,1, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,1,0,
			//].clump(8).choose}.dup(8).flat,inf).coin.not,
			//\sustain, 0.1,
			//\lag, 0.04,
			//\dur, 1/8,
			//\amp, 0.1,
		//)),
		Pseq([

			Pfindur(7,Pbind(
				\instrument, \o3bass2,
				\degree, Pseq([
					0, 1s, 1, 0, 
				],inf).stutter(8),
				\legato, 0.4,
				\osc1voices, [[2,1,1.01]],
				\osc2voices, [[2,1,1.01]],
				\osc3voices, [[2,1,1.01]],
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\lpenv, Pseq([
					[ Env([4,1/4,1,1],[0.04,0.14,0.8]) ],
				],inf),
				\octave, 3,
				\octave, 5 + Prand([0,1,0,0,0,0,],inf),
				\out, BusDef(\fx1, \audio),
				\dur, 1/8,
				\amp, 0.1
			)),
			Pfindur(1,Pbind(
				\instrument, \o3bass2,
				\degree, Pseq([
					0, 1s, 1, 0, 
					\r, \r, \r, \r, \r, \r, \r, \r,
					0, 1s, 1, 0, 
				],inf).stutter(1),
				\legato, 0.4,
				\osc1voices, [[2,1,1.01]],
				\osc2voices, [[2,1,1.01]],
				\osc3voices, [[2,1,1.01]],
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1) ],
				],inf),
				\lpenv, Pseq([
					[ Env([4,1/4,1,1],[0.04,0.14,0.8]) ],
				],inf),
				\octave, 3,
				\octave, 5 + Prand([0,1,-1,0,0,0,],inf),
				\out, BusDef(\fx1, \audio),
				\dur, 1/16,
				\amp, 0.1
			)),
		],inf),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
)

(
SynthDef(\siren, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq* EnvGen.kr(Env([1,2,1]/10+1,[0.1,0.8]), Impulse.kr(1/10));
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(\fm.kr(4*~t) * [1/2,1,1.04]) * \fmamp.kr(1) )));
	sig = FreqShift.ar(sig, SinOsc.kr(1/13).range(0,100));
	sig = sig * SinOsc.kr(1/14 * [1,1.1]).range(0,1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\o3bass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var osc1detune=\osc1detune.kr(0), osc1voices=\osc1voices.kr([1,1,1]), osc1gain=1, osc1amps = \osc1amps.kr([1,1,1]);
	var osc2detune=\osc2detune.kr(0), osc2voices=\osc2voices.kr([1,1,1]), osc2gain=1, osc2amps = \osc2amps.kr([1,1,1]);
	var osc3detune=\osc3detune.kr(0), osc3voices=\osc3voices.kr([1,1,1]), osc3gain=1, osc3amps = \osc3amps.kr([1,1,1]);
	env1 = EnvGen.kr(\lpenv.kr(Env([2,1.2,1,1/2],[0.011,0.1,1.7])), 1);
	sig = Saw.ar(freq * osc1voices + osc1detune) * osc1amps * osc1gain;
	sig = sig + SinOsc.ar(freq * osc2voices + osc2detune) * osc2amps * osc2gain;
	sig = sig + Pulse.ar(freq * osc3voices + osc3detune) * osc3amps * osc3gain;
	sig = sig /3;
	sig = LPF.ar(sig, \lpfr.kr(2.1) * env1 * freq);
	sig = ( sig*2 ).tanh * 2;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.4,0.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: XEnvSpec( ControlSpec(0,8,\lin) ),
	lpfr: ControlSpec(0,8,\lin),
	osc1amps: XArraySpec(\unipolar),
	osc2amps: XArraySpec(\unipolar),
	osc3amps: XArraySpec(\unipolar),
	osc1detune: ControlSpec(-10,10,\lin),
	osc2detune: ControlSpec(-10,10,\lin),
	osc3detune: ControlSpec(-10,10,\lin),
))).add;
);
