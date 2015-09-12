
///////// test newFrom

(

		~sub = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				\dur, 1/4,
				\amp, 0.3
			);
		);
		~sub.print
)

///////////// test parent event and Pev

(
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;

		~sub = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				\dur, 1/4,
				\amp, 0.3
			);
		);

		~el = XEventList.newFrom( 
			
				Pseq([
					Pev((
						parent: ~event_type_eventlist,
						//nodeType: \eventlist,
						eventlist: ~sub,
						sustain: 4.5,
						midinote: 0,
						dur: 7,
					)),
				],1)

		);

		XEventLoop(\pdef).list = ~el;

)

~sub.print

(
	Pseq([
		Pev((
			parent: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		))
	],1).asStream.nextN(1,Event.default).collect({ arg x; x.parent.keys.debug("x"); x.keys })
	//],1).asStream.nextN(1,Event.default).collect({ arg x;  x.keys })
)


////////////////////////////////////// parent event type



(
~bla = (
	xx: 3,
	parent: (xx:4, yy:5),
	zz: 10,
);
~bla.yy.debug("yy");
~bla.parent;
)

(
~bla = (
	xx: 3,
	proto: (xx:4, yy:5),
	zz: 10,
);
~bla.yy.debug("yy");
~bla.proto;
)

(
	Pseq([
		Pev((
			proto: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		))
	],1).asStream.nextN(1,Event.default).collect({ arg x; x.proto.keys.debug("x"); x.keys })
	//],1).asStream.nextN(1,Event.default).collect({ arg x;  x.keys })
)

(
	Pseq([
		(
			proto: ~event_type_eventlist,
			//nodeType: \eventlist,
			eventlist: ~sub,
			sustain: 4.5,
			midinote: 0,
			dur: 7,
		)
	],1).asStream.nextN(1,Event.default).collect({ arg x; x.proto.keys.debug("x"); x.keys })
	//],1).asStream.nextN(1,Event.default).collect({ arg x;  x.keys })
)

Event.default.use { Event.default.sustain }
