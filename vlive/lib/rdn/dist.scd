
(
~bank_size = 16;
~shaper_buffers = ~shaper_buffers ?? {
	16.collect({ arg x;
		Buffer.alloc(s, 1024, 1);
	})
};
~tables = ~bank_size.collect { Signal.chebyFill(513,{ arg x; sin(x+0.31.rand) } ! 6) };
~tables.debug("tables");
~tables.do({ arg table, x;
	~shaper_buffers[x].sendCollection(table.asWavetableNoWrap);  
});
	RandDelayNetwork(\shaper, {
		var block, algo;
		block = [
			//\delay!8,
			//\bpf,
			//\brf,
			\delay!3,
			\delay2!3,
			//\delayrev,
			//\fm2,
			\shaper,
			\shaper2,
			//\add,
			//\comb,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.5,0.5].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	},
	IdentityDictionary.newFrom([
		\shaper, { arg si;
			si = (si * 2.0.rand * \distamp.kr);
			//si = LPF.ar(si, 1000*16.rand) + si;
			Shaper.ar(~shaper_buffers.[~bank_size.rand], si) / 2;
		},
		\shaper2, { arg si;
			si = (si * 2.0.rand * \distamp2.kr);
			Shaper.ar(~shaper_buffers.[~bank_size.rand], si) / 2;
		},
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		},
		\delayrev, { arg si;
			var sig = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.11.rand] * \delay2.kr) + si;
			sig.reverse;
		},
		\delayt, { arg si;
			DelayL.ar(si, 2.8, { [1,2,3,4,5,6,7,8].choose }!2 / ~t * \delay.kr) + si;
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]));
	RandDelayNetwork(\shaper).make(\fx1, "5--", BusDef(\fx1, \audio));

)
RandDelayNetwork(\shaper).make(\fx1, "5--", BusDef(\fx1, \audio));
Ndef(\fx1).play
Ndef(\fx1).edit
Pdef(\perc_scar2).play
Pdef(\perc_scar2).stop

Ndef(\fx1).put(100, \pset -> Pbind(\degree, Pseq([0,2,4,2],inf), \dur, 2))
Ndef(\fx1).clear
