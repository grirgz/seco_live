// https://www.youtube.com/watch?v=KwvqoH4LPKM Breakcore + ambient techno in SuperCollider

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\bdur, 1,
			\amp, 0.1,
			//3
			//0 stut=8
			//1 fx=1
			//1 fx=0
			//4 sub=4 fx=1
			\score, "

			0
			6 sub=211 fx=1
			5 stut=4
			7
			",
			\tracker, Prout({ arg ev;
				var substream;
				var chartable = "0123456789abcdef";
				var nev = ();
				ev[\score].split($\n).collect { arg line, lidx;
					var notechar, cmdline;
					var note, cmds;
					var skipYield=false;
					line = line.stripWhiteSpace;
					if(line != "") {

						line.debug("line");
						notechar = line[0];
						cmdline = line[2..];
						cmdline.debug("cmdline");
						note = chartable.indexOf(notechar);
						nev[\degree] = note;
						cmds = cmdline.split($ ).collect { arg item, idx;
							var sp = item.split($=);
							sp.debug("sp");
							sp[0] -> sp[1];
						}.asDict;
						cmds.debug("cmds");
						cmds.keys.do { arg cmd;
							switch(cmd,
								"stut", { 
									var rep = cmds[cmd].asInteger;
									rep.debug("rep");
									substream = Routine({
										rep.do { 
											nev[\dur] = ev[\bdur]/rep;
											1.yield;
										};
									});
								},
								"sub", { 
									var sco = cmds[cmd];
									var rep;
									var seq;
									seq = sco.as(Array);
									rep = seq.size+1;
									substream = Routine({ 
										nev[\dur] = ev[\bdur]/rep;
										1.yield;
										seq.collect { arg notechar;
											note = chartable.indexOf(notechar);
											nev[\degree] = note;
											ev.debug("ev");
											nev[\dur] = ev[\bdur]/rep;
											1.yield;
										};
										//skipYield = true;
									});
								},
								"fx", { 
									var synth = [
										\fxdist,
										\fxam,
									][cmds[cmd].asInteger];
									nev[\out] = BusDef(\ifx1, \audio, 2);
									nev[\finish] = {
										(instrument: synth, inbus: BusDef(\ifx1, \audio, 2), dur: ev[\dur]).play;
									}
								},
							);

						};
						if(skipYield.not) {
							substream.debug("substream");
							if(substream.notNil) {
								substream.do { arg item, idx;
									[idx, nev].debug("sub");
									ev.putAll(nev);
									ev.debug("final ev");
									ev = 1.yield;
								};
								substream = nil;
								nev = ();
							} {
								nev.debug("xfinal nev");
								ev.putAll(nev);
								nev = ();
								ev.debug("final ev");
								ev = 1.yield;
							};
						} {
							skipYield = false;
						}
					};
				};
			}),
		).repeat(10),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[825].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
SynthDef(\fxdist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fxam, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * SinOsc.ar(\freq.kr(500));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
	~r = Routine({
		1.yield;
		2.yield;
	});
	~r.do { arg item, idx;
		item.postln;
		1.yield;
		
	};
)
