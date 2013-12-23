Pdef(~name +++ \pre, Sdef(~name, \mynotes).pbind <> Pbind(
	\freq, Pseq([100,200,300],inf),
));


// END

Sdef(~name, \mynotes).record;

s.latency = 0


Veco.force_init
(
Sdef(~name, \mynotes, \notes);
Sdef(~name, \mynotes).record;
)
Sdef(~name, \mynotes)
Sdef(~name, \mynotes).get(0)
Sdef(~name, \mynotes).get(0)[\set_data].asCompileString
Sdef(~name, \mynotes).get(0).event_score
Sdef(~name, \mynotes).get(0).is_present
Sdef(~name, \mynotes).get(0).slices
Sdef(~name, \mynotes).get(0).record;

(
Sdef('1', 'mynotes').get(0).set_data([
	( 'start_silence': 0.77239684263895, 'time': 0, 'dur': 0.77239684263895, 'end_offset': 0, 
  'sustain': 0, 'midinote': 'rest', 'start_offset': 0, 'slotnum': 'rest', 'type': 'rest', 
  'end_silence': 1.958733359972 ),
	( 'event_key': 55, 'time': 0.77239684263895, 'dur': 0.6676106651621, 'sustain': 0.199034512043 ),
	( 'event_key': 60, 'time': 1.4400075078011, 'dur': 0.55435138940811, 'sustain': 0.13807314634323 ),
	( 'event_key': 59, 'time': 1.9943588972092, 'dur': 0.72793716192245, 'sustain': 0.11232221126556 ),
	( 'event_key': 58, 'time': 2.7222960591316, 'dur': 1.040056347847, 'sustain': 0.11242526769638 ),
	( 'event_key': 60, 'time': 3.7623524069786, 'dur': 0.45947541793248, 'sustain': 0.1297206679983 ),
	( 'event_key': 59, 'time': 4.2218278249111, 'dur': 0.55441854397395, 'sustain': 0.12092264493276 ),
	( 'event_key': 58, 'time': 4.776246368885, 'dur': 0.47673052549362, 'sustain': 0.11242061853409 ),
	( 'event_key': 56, 'time': 5.2529768943787, 'dur': 0.78828974564931, 'sustain': 0.094993233680725 ),
	( 'event_key': 55, 'time': 6.041266640028, 'dur': 1.958733359972, 'sustain': 0.086669941742912 ),
]);
)

(
~bla = (

	record: { arg self, record_dur, slice_dur;
			self.recorder = ~piano_recorder.new;
			self.recorder_view = ~class_recorder_view.new(self.recorder);
			self.recorder.start_recording(record_dur, slice_dur);
			//self.activate_display;
		
	},
);
~bla.record;
)

a = ()
a.recorder = 1
a.recorder

(
	~pat = Sdef(~name, \mynotes).pbind <> Pdef(~name);
	~pat.play;
)

(
	~pat = Sdef(~name, \mynotes).pbind;
	~pat.trace.play;
)

(
	~notes = Sdef(~name, \mynotes).pbind;
	~patt = ~notes <> Pdef(~name);
~patt.play
)

(
	~notes = Sdef(~name, \mynotes).pbind;
	~patt =  Pbind(

		//\midinote, Pkey(\event_key),
		\hein, Pfunc{ arg ev; ev.debug("quoi!!"); },
		\freq, Pfunc{ arg ev; 
			if(ev[\event_key].isNil) {
				"rest!!!".debug;
				50.midicps;
			} {
				ev[\event_key].debug("quoi!!").midicps;
			}
		},
	) <>  ~notes <> Pdef(~name);
~patt.play
)

(
	~notes = Sdef(~name, \mynotes).get(0).event_score.get_rel_notes;
	~patt =  Pbind(

		//\midinote, Pkey(\event_key),
		\hein, Pfunc{ arg ev; ev.debug("quoi!!"); },
		\freq, Pfunc{ arg ev; 
			if(ev[\event_key].isNil) {
				"rest!!!".debug;
				50.midicps;
			} {
				ev[\event_key].debug("quoi!!").midicps;
			}
		},
	) <>  Pseq(~notes) <> Pdef(~name);
~patt.play
)



s.latency = 0.2

(
	~ev = (
		freq: 120,
		type: \on,
		latency: \a,
	);
	~ev.play;
	
)


Event


(
MIDIdef.cc(\pianocontrol, { arg ... args;
	args.debug("args");
	
}, nil, nil, nil)
)
(
MIDIdef.noteOn(\pianocontrol, { arg ... args;
	args.debug("argsX");
	
}, nil, nil, nil)
)
