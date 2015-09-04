
// I need a pattern which is
// - parallel
// - recursif
// - generous
// - dropdur
// - Pfindur

// no! parallel and generous is mathematically impossible, they never need to be together

// I need a pattern which is
// - parallel
// - recursif
// - dropdur
// - Pfindur

// then I need a pattern which is
// - generous
// - recursif
// - dropdur
// - Pfindur




(
~dereference_event = { arg spawner, ev; 
	switch(ev[\eventType] ? ev[\nodeType] ? ev[\type],
		\pattern, {
			var pat = ev[\pattern].value ?? (ev[\key] !? { Pdef(ev[\key]) } );
			spawner.par(Pfindur(ev[\sustain], ~timeline_pattern.(pat)));
			spawner.wait(ev[\dur]);
		},
		//\player, {
		//	spawner.seq(Pseq([
		//		ev
		//	]))
		//},
		{
			spawner.seq(Pseq([
				ev
			]))
		}
	);

};

~split_event = { arg val;
	val.use {
		if(val.notNil) {
			var suboffset = val[\stream_dropdur];
			if(suboffset == 0) {
				// we are on a border, do nothing;
				val.debug("we are on a border, do nothing; ");
			} {
				if( suboffset > val.sustain ) {
					// we are on a rest
					val[\dur] = val.dur - suboffset;
					val[\sustain] = val.sustain - suboffset;
					val.debug("we are on a rest");
				} {
					// we are on a note
					val[\dur] = val.dur - suboffset;
					val[\sustain] = val.sustain - suboffset;
					val[\PtimeGatePunch_drop] = suboffset;
					val.debug("we are on a note");
				};
			}
		};
	};
};

~stream_dropdur = { arg drop_time, stream;
	var current_offset = 0;
	var previous_offset = 0;
	var val;
	var crossing_line = List.new;
	if(drop_time.notNil) {

		while (
			{
				current_offset <= drop_time and: {
					val = stream.next(());
					val.notNil;
				}
			},
			{
				val.use {
					previous_offset = current_offset;
					current_offset = current_offset + val.dur;
					if(
						current_offset <= drop_time and: {
							( previous_offset + val.sustain ) > drop_time
						}
					) {
						val[\stream_dropdur] = drop_time - previous_offset;
						crossing_line.add(val);
					};
					[current_offset, previous_offset, val].debug("mangling");
				}
			}
		);

		crossing_line = crossing_line.collect({ arg ev; ~split_event.(ev) });
		val = ~split_event.(ev);

	} {
		val = stream.next(());
	};

	val;
};

~timeline_pattern = { arg pat;
	Pspawner({ arg spawner;
		var stream = pat.asStream;
		pat.debug("timeline_pattern: start");

		stream.do({ arg ev;
			ev.debug("timeline_pattern");
			~dereference_event.(spawner, ev);
			//spawner.wait(ev[\dur]);
		}, ())

	})
};

~pplay = { arg pat;
	var ppat;
	var punchIn = 0;
	var punchOut = 10;
	ppat = ~timeline_pattern.(pat);
	ppat = 
		Pbind(
			\before, Pseq((0..64)),
		)
		<>
		ppat
		<>
		Pbind(
			\after, Pseq((0..64)),
		);
	ppat = ppat.trace;
	ppat = Pfindur(punchOut - punchIn, ppat);
	ppat.play;
};


)

(
// parallel subpattern
~pplay.(
	Pseq([
		(
			eventType: \pattern,
			dur: 1,
			sustain: 2.5,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22)+10,
					\dur, 1/8,
				)
			),
		),

		
	])
);

)

// simple notes
~pplay.(
	Pbind(
		\degree, Pseq([1,2,3,4],2),
		\dur, 1/2,
	);
);

(
// subpattern
~pplay.(
	Pseq([
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22)+10,
					\dur, 1/8,
				)
			),
		),

		
	])
);

)

/////////////////////

(

~pat =	Pseq([
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],2),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],2)+10,
					\dur, 1/8,
				)
			),
		),

		
	]);

	~str = ~pat.asStream;
	~str.nextN(10,());
)
