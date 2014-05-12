
(
	~randpseq = { arg size, step, len;
		Pseq( (1 ! (len)).extend(size, 0).collect({ arg aa, num; 
			if(aa==1) {
				if(num % step == 0) { 1 } { 0 }  
			} { 
				0;
			}
		}), inf );

	};
	~spawner = { arg basepat, preset, beats=8, dur=4, cover=4, lagparts=8, pseqs;
		if(pseqs.isNil) {
			pseqs = { arg size; [
				~randpseq.(size, 1, (16.rand + 1)),
				~randpseq.(size, 2, (16.rand + 1)),
			]};
		};
		
		Pspawner({ arg sp;
			var spawn = {
					basepat.value <>
					Pbind(
						\dur, Pn(1/8,beats*dur*cover ),
						\isRest, pseqs.(beats*dur).choose < 1,
						\lag, lagparts.rand / lagparts * dur / t,
					) <>
					preset
			};

			(cover-1).do {
				sp.par( spawn.value );
			};

			100000.do { arg x;
				sp.par( spawn.value );
				dur.wait;
			};
			
		});
	}
)
