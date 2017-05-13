
BufDef(\basicrecorder_buffer2, s.sampleRate*2);
BufDef(\basicrecorder_buffer4, s.sampleRate*4);
BufDef(\basicrecorder_buffer8, s.sampleRate*8);
BufDef(\basicrecorder_buffer16, s.sampleRate*16);
(
	ProtoDef(\basicrecorder, (
		init:{ arg self;
			self.inbus = self.inbus ?? { BusDef(\recbus, \audio) };
		},

		label: { arg self;
			self.key
		},

		edit: { arg self;
			WindowDef(\basicrecorder).front(self);
		},

		play: { arg self;
			self.startRecording;
		},

		isPlaying: { arg self;
			self.isRecording ? false;
		},

		stop: { arg self;
			//NOOP
		},

		outBus: { arg self;
			0
		},

		startRecording: { arg self;
			var model = self;
			model.recbuf = BufDef(model.recbufkey);
			model.recbuf.debug("recbuf");
			if(model.recbuf.notNil and: { self.isRecording != true }) {
				Pdef(\recorder,
					Pseq([
						Ptask({
							"start record!!!!!!!!!!!!!".debug;
							{ 
								s.latency.wait;
								self.isRecording = true;
								self.changed(\isRecording);
							}.fork;
						},0),
						Pbind(
							\instrument, \recorder,
							\sustain, model.recbuf.numFrames / model.recbuf.sampleRate,
							\dur, Pkey(\sustain) * TempoClock.default.tempo,
							\out, Pfunc({ model.outBus ? 0 }),
							\inbus, Pfunc({ arg ev;
								model.inbus
							}),
							\bufnum, Pn(model.recbuf,1),
						).trace,
						Ptask({
							"end record!!!!!!!!!!!!!".debug;
							{ 
								s.latency.wait;
								self.isRecording = false;
								self.changed(\isRecording);
							}.fork;
						},0)
					]),
				).play;
			};
		},
	)).init;

	WindowDef(\basicrecorder, { arg def, model;
		var recordbutton;
		var inbuspopup, bufferpopup;

		recordbutton = BasicButton.new.string_("Record").action_({ arg view;
			model.startRecording;
		})
		.onChange(model, \isRecording, { arg view;
			if(model.isRecording == true) {
				{
					view.background = Color.red;
					view.value = 1;
				}.defer;
			} {
				{
					view.background = Color.white;
					view.value = 0;
				}.defer;

			}
		})
		.value_(0);

		bufferpopup = Param(
			Message(model), \recbufkey, 
			MenuSpec(BufDef.all.keys.as(Array).sort.select({ arg x; BufDef.all[x].isKindOf(Buffer) }))
		).asPopUpMenu;

		inbuspopup = Param(
			Message(model), \inbus, 
			MenuSpec(BusDef.all.keys.as(Array).sort.collect({ arg k; k -> BusDef(k) }) )
		).asPopUpMenu;

		VLayout(
			inbuspopup,
			HLayout (
				recordbutton,
				BasicButton.new.string_("PlayBuf").action_({
					Pbind(
						\instrument, \player,
						\sustain, model.recbuf.numFrames / model.recbuf.sampleRate,
						\bufnum, BufDef(model.recbufkey),
						\dur, Pn(1,1),
					).play;
				}),
				BasicButton.new.string_("Save as").action_({
					model.recbuf.saveDialog(-1, 0, { arg file;
						BufDef(file.asSymbol, file)
					})
				}),
			),
			bufferpopup,
			nil,
		)

	});
);

// END


ProtoDef(\basicrecorder).edit
ProtoDef(\basicrecorder).recbuf.play

(
Ndef(\bla, {
	SinOsc.ar(230 * ( 1 + ( SinOsc.kr(1) * 1 ))) ! 2 * 0.1
	
}).play(BusDef(\sendbus1).index, 2)
)

BufDef(\tmp4).play
BufDef(\tmp4)

						(
						Pbind(
							\instrument, \recorder,
							\sustain, model.recbuf.numFrames / model.recbuf.sampleRate,
							\dur, Pkey(\sustain) * TempoClock.default.tempo,
							\inbus, Pfunc({ arg ev;
								model.inbus
							}),
							\bufnum, Pn(model.inbus,1),
						).trace,
						)
