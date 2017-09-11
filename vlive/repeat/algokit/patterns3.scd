
Pdef(\drums).clear
Pdef(\algopat_3p2).play

(
	Pdef(\drums, Pdef(\algopat_3p1, 
		Plazy({
			var lists = nil ! 8;
			var kicks = 8.collect({ [~kitlib.klak.kick, ~kitlib.trap.kick, ~kitlib.hiphop.kick].choose });
			var snares = 8.collect({ [~kitlib.trap.snare].choose });
			var hats = 8.collect({ [~kitlib.trap.hat, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			var trackgen = {[
				3.collect {
					~kitlib.hiphop.kick;
				},
				3.collect {
					~kitlib.hiphop.snare;
				},
				3.collect {
					~kitlib.hiphop.hat;
				},
			].flat};
			var tracks1 = trackgen.value;
			var tracks2 = trackgen.value;
			//var voices = 8.collect({ [~kitlib.he, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			//var kicks = 8.collect({ [~kitlib.hiphop.kick].choose });
			//var snares = 8.collect({ [~kitlib.hiphop.snare].choose });
			//var hats = 8.collect({ [~kitlib.hiphop.hat] });
			//var others = 8.collect({ [~kitlib.heavy.] });
			"oooox".postln;
			Pseq([
				Ppar(
					(0..tracks1.size-1).scramble.collect { arg idx;
						var timefac = 1/4;
						Pseq([
							Pfindur(2**idx*timefac*3,tracks1[idx]),
							Pfindur(2**idx*timefac,tracks2[idx]),
						],inf);
					}
				)
			],1);
		})
	));
)

(
	Pdef(\drums, Pdef(\algopat_3p2, 
		Plazy({
			var lists = nil ! 8;
			var kicks = 8.collect({ [~kitlib.klak.kick, ~kitlib.trap.kick, ~kitlib.hiphop.kick].choose });
			var snares = 8.collect({ [~kitlib.trap.snare].choose });
			var hats = 8.collect({ [~kitlib.trap.hat, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			var speeder = { arg x; 
				x = x ? [1/4,1/2,1/2,1,1,1,1,1,1,1,2,2,4].choose;
				Pbind(\dur, Pkey(\dur) * x) 
			};
			var trackgen = {[
				3.collect {
					speeder.value <> ~kitlib.hiphop.kick;
				},
				3.collect {
					speeder.value([1,2,1/2,1,1,1].choose) <> ~kitlib.hiphop.snare;
				},
				3.collect {
					speeder.value <> ~kitlib.hiphop.hat;
				},
			].flat};
			var tracks1 = trackgen.value;
			var tracks2 = trackgen.value;
			var tracks3 = trackgen.value;
			//var voices = 8.collect({ [~kitlib.he, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			//var kicks = 8.collect({ [~kitlib.hiphop.kick].choose });
			//var snares = 8.collect({ [~kitlib.hiphop.snare].choose });
			//var hats = 8.collect({ [~kitlib.hiphop.hat] });
			//var others = 8.collect({ [~kitlib.heavy.] });
			"oooox".postln;
			Pseq([
				Ppar(
					(0..tracks1.size-1).scramble.clump(2).collect { arg idxs, groupidx;
						var time = 2**groupidx*1/4;
						Ppar(idxs.collect({ arg idx;
							Pseq([
								//Rest(time*4),
								Pseq([
									Prand([
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Rest(time*3),
									]),
									Prand([
										Pfindur(time,tracks2[idx]),
										Pfindur(time,tracks2[idx]),
										Rest(time),
									]),
									
									Prand([
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Rest(time*3),
									]),
									Prand([
										Pfindur(time,tracks3[idx]),
										Rest(time),
									]),
								],inf),
							],inf);
						}))
					}
				)
			],1);
		})
	));
)

(
	Pdef(\drums, Pdef(\algopat_3p3, 
		Plazy({
			var lists = nil ! 8;
			var kicks = 8.collect({ [~kitlib.klak.kick, ~kitlib.trap.kick, ~kitlib.hiphop.kick].choose });
			var snares = 8.collect({ [~kitlib.trap.snare].choose });
			var hats = 8.collect({ [~kitlib.trap.hat, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			var speeder = { arg x; 
				x = x ? [1/4,1/2,1/2,1,1,1,1,1,1,1,2,2,4].choose;
				Pbind(\dur, Pkey(\dur) * x, \gain, Pkey(\gain) * x.linlin(1/4,4, 1/4,1)) 
			};
			var trackgen = {[
				3.collect { arg x;
					//speeder.value(( x+1 )/2) <> ~kitlib.hiphop.kick;
					speeder.value <> ~kitlib.hiphop.kick;
				},
				3.collect { arg x;
					//speeder.value(( x+1 )/2) <> ~kitlib.hiphop.snare;
					speeder.value() <> ~kitlib.hiphop.snare;
				},
				3.collect { arg x;
					//speeder.value(( x+1 )/2) <> ~kitlib.hiphop.hat;
					speeder.value() <> ~kitlib.hiphop.hat;
				},
			].flat};
			var tracks1 = trackgen.value;
			var tracks2 = trackgen.value;
			var tracks3 = trackgen.value;
			//var voices = 8.collect({ [~kitlib.he, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			//var kicks = 8.collect({ [~kitlib.hiphop.kick].choose });
			//var snares = 8.collect({ [~kitlib.hiphop.snare].choose });
			//var hats = 8.collect({ [~kitlib.hiphop.hat] });
			//var others = 8.collect({ [~kitlib.heavy.] });
			"oooox".postln;
			Pseq([
				Ppar(
					(0..tracks1.size-1).scramble.clump(2).collect { arg idxs, groupidx;
						var time = 2**groupidx*1/4;
						Ppar(idxs.collect({ arg idx;
							Pseq([
								//Rest(time*4),
								Pseq([
									Prand([
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Rest(time*3),
									]),
									Prand([
										Pfindur(time,tracks2[idx]),
										Pfindur(time,tracks2[idx]),
										Rest(time),
									]),
									
									Prand([
										Pfindur(time*3,tracks1[idx]),
										Pfindur(time*3,tracks1[idx]),
										Rest(time*3),
									]),
									Prand([
										Pfindur(time,tracks3[idx]),
										Rest(time),
									]),
								],inf),
							],inf);
						}))
					}
				)
			],1);
		})
	));
)

Pdef(\drums).play;
Pdef(\drums).set(\out, nil)
2**9
