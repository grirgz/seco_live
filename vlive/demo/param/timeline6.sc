
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

/////////////////////////////////////////////////////////////////
// ------------ Important code -----------
///////////////////////// add Event type player!!!!!/////////////
Event.addEventType(\player, {
	var method = ~method ? \play;
	var args = ~arguments ? [];
	var receiver = ~receiver.value;
	var quant;
	[method, args, receiver].debug("player EventType: method, args, receiver");
	if(~disableQuant != false) {
		quant = receiver.tryPerform(\quant);
		receiver.tryPerform(\quant_, 0);
	};
	receiver.perform(method, *args);
	if(~disableQuant != false) {
		receiver.tryPerform(\quant_, quant);
	};
	if(method == \play) {
		TempoClock.default.sched(~sustain.value(currentEnvironment), {
			if(~disableQuant != false) {
				quant = receiver.tryPerform(\quant);
				receiver.tryPerform(\quant_, 0);
			};
			receiver.perform(\stop, *args);
			if(~disableQuant != false) {
				receiver.tryPerform(\quant_, quant);
			};
			
		}.inEnvir);
	};

});
////////////////////////////


	Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
		var sig;
		sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(8) * 1 )));
		sig = Pan2.ar(sig, pan, amp);
	});

	Ndef(\plop2, { arg freq=200, pan=0, amp=0.1;
		var sig;
		sig = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(4) * 1 )));
		sig = Pan2.ar(sig, pan, amp);
	});

	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;



	////////////////////////

~dereference_event = { arg spawner, ev; 
	[spawner, ev].debug("entering ~dereference_event");
	switch(ev[\eventType] ? ev[\nodeType] ? ev[\type],
		\pattern, {
			var pat;
			debug("dereference_event: sub pattern type");
			pat = ev[\pattern].value ?? (ev[\key] !? { Pdef(ev[\key]) } );
			if(ev[\pattern].isNil) {
				pat.debug("pat!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			};
			spawner.par(Pfindur(ev[\sustain], ~timeline_pattern.(pat, ev[\event_dropdur])));
			spawner.wait(ev[\dur]);
		},
		//\player, {
		//	spawner.seq(Pseq([
		//		ev
		//	]))
		//},
		{
			debug("dereference_event: simple event type");
			spawner.seq(Pseq([
				ev
			]))
		}
	);

};

~split_event = { arg val;
	[val].debug("entering ~split_event");
	val.use {
		if(val.notNil) {
			var suboffset = val[\event_dropdur];
			if(suboffset == 0) {
				// we are on a border, do nothing;
				val.debug("we are on a border, do nothing; ");
			} {
				if( suboffset > val.sustain ) {
					// we are on a rest
					val[\sustain] = val.sustain - suboffset;
					val[\dur] = val.dur - suboffset;
					val[\isRest] = true;
					val.debug("we are on a rest");
				} {
					// we are on a note
					val[\sustain] = val.sustain - suboffset;
					val[\dur] = val.dur - suboffset;
					//val[\event_dropdur] = suboffset;
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
	[drop_time, stream].debug("entering ~stream_dropdur");
	if(drop_time.notNil) {

		while (
			{
				current_offset <= drop_time and: {
					val = stream.next(Event.default);
					val.notNil;
				}
			},
			{
				val.use {
					val.debug("stream_dropdur: val");
					[val.dur, val.sustain].debug("stream_dropdur: val: dur, sustain");
					previous_offset = current_offset;
					current_offset = current_offset + val.dur; 
					if(
						current_offset <= drop_time and: {
							( previous_offset + val.sustain ) > drop_time
						}
					) {
						val[\event_dropdur] = drop_time - previous_offset;
						val.debug("stream_dropdur: added to crossing_line");
						crossing_line.add(val);
					};
					[current_offset, previous_offset, val].debug("mangling");
				}
			}
		);
		// now current_offset point to the end of current event, ie: past the drop_time line


		if(val.notNil) {
			val[\event_dropdur] = drop_time - previous_offset;
			val = ~split_event.(val);

			crossing_line = crossing_line.collect({ arg ev; 
				ev = ~split_event.(ev);
				ev[\dur] = 0;
				ev.debug("stream_dropdur: transformed crossing_line");
			});

			Pseq(
				crossing_line ++
				[
					val,
					stream
				]
			).asStream;
		} {
			// if there is only one event crossing the line but it's not the last to start 
			// (meaning his dur < sustain), val will be nil, but not crossing_line
			if(crossing_line.size > 0) {
				val = crossing_line.pop;
				val = ~split_event.(val);
				crossing_line = crossing_line.collect({ arg ev; 
					ev = ~split_event.(ev);
					ev[\dur] = 0;
					ev.debug("stream_dropdur: transformed crossing_line");
				});
				Pseq(
					crossing_line 
					++
					[
						val;
					]
				).asStream;
			} {
				nil
			}
		}

		// first yield all the splitted event concurrent with current val, then val, then remaining stream

	} {
		stream;
	};
};

~timeline_pattern = { arg pat, drop_time, model;
	Pspawner({ arg spawner;
		var stream = pat.asStream;
		[pat, drop_time].debug("timeline_pattern: start");

		stream = ~stream_dropdur.(drop_time, stream);

		if(stream.notNil) {

			//model.changed(\cursor, \play);
			stream.do({ arg ev;
				ev.debug("timeline_pattern");
				~dereference_event.(spawner, ev);
				//spawner.wait(ev[\dur]);
			}, Event.default)
		};

	})
};

~pplay = { arg pat;
	var ppat;
	var punchIn = 5.0;
	var punchOut = 16.72;
	ppat = ~timeline_pattern.(pat, punchIn);
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
	// TODO: rewrite Pfindur to cut events in two instead of pruning them
	// 		or maybe fix \player event type to use event cleanup
	ppat = Pfindur(punchOut - punchIn, ppat); 
	ppat.play;
};

// parallel subpattern + ndef + sub-sub pattern
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
			dur: 1,
			sustain: 4.5,
			pattern: Ref(
				Pseq([
					(
						eventType: \pattern,
						dur: 1,
						sustain: 2.5,
						pattern: Ref(
							Pbind(
								\instrument, \plop,
								\degree, Pseq([1,2,3,4],22),
								\dur, 1/3,
							)
						),
					),
					(
						eventType: \pattern,
						dur: 2,
						sustain: 6,
						pattern: Ref(
							Pbind(
								\instrument, \plop,
								\degree, Pseq([1,2,3,4],22)+10,
								\dur, 1/4,
							)
						),
					),

					
				])
			),
		),
		(
			type: \player,
			receiver: Ref(Ndef(\plop)),
			sustain: 4,
			dur: 1,
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

/////////////////////////////////////////////// test scores

(
// parallel subpattern + ndef
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
			type: \player,
			receiver: Ref(Ndef(\plop)),
			sustain: 4,
			dur: 1,
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

(
// simple notes
~pplay.(
	Pbind(
		\degree, Pseq((0..3),2),
		\dur, 1/2,
	);
);
)

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
/// put back values in a stream
~pat = Pseq([1,2,3,4,5]);
~str = ~pat.asStream;
~str2 = Pseq([10,20,~str]).asStream;
~str2.nextN(10);
)

(
/// put back values in a stream
~pat = Pseq([1,2,3,4,5]);
~str = ~pat.asStream;
~str2 = Pseq([10,20,~str]).asStream;
~str2.nextN(10);
)

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


~ev = (dur: 0.125, degree:1)
Pseq([~ev]).asStream.nextN(2,())
Pseq([~ev]).asStream.next(Event.default)

Stream
~ev.play
~ev.use({ arg ev; ev.sustain })
~ev.use({ arg ev; ev[\legato] })

(
~pat = Pbind(
	\instrument, \default,
	\degree, Pseq((0..10)),
	\dur, 1,
	\amp, 0.1
);
~str = ~pat.asStream;
~ev = ~str.next(Event.default);
)

~ev = ();
~ev[\sustain]
().sustain
~ev~ev.sustain
~ev.parent
TempoClock
Event.default.parent
