(
SynthDef(\RecordFactoryPlayer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
FileSystemProject.loadOnce("libdef/synthplayrec.scd"); 
FileSystemProject.loadOnce("libdef/bufEditor.scd"); 
ProtoDef(\RecordFactory, (
	tempoClock: TempoClock.default,
	filename:"/tmp/supercollider_param_RecordFactory_tmp.wav",
	recBus: BusDef(\RecordFactoryIn, \audio),
	recBus_: { arg self, val;
		self[\recBus] = val;
		self.changed(\recBus)
	},

	recorder: { arg self;
		self[\recorder] = Recorder(Server.default);
		self[\recorder];
	}, 

	playGain: 1,
	isRecording: false,

	//recordLatency: Server.default.latency,
	recordLatency: 0,

	isRecording_: { arg self, val;
		if(val == true) {
			if(self[\isRecording] == false) {

				var numChannels = 2;
				self[\isRecording] = true;
				self.changed(\isRecording);
				self.changed(\set, \isRecording);
				Log(\Param).debug("RecordFactory: Start recording");

				Server.default.prepareForRecord(self.filename);

				self.tempoClock.schedAbs(self.tempoClock.nextTimeOnGrid(self.recordQuant ? 0, self.recordLatency * self.tempoClock.tempo), {
					self.startRecordingTime = self.tempoClock.beats; // NOTE: doesnt account for latency but is used to compute duration so not a problem for the moment
					self.recorder.record(path:self.filename, bus:self.recBus, numChannels:numChannels);
				});
				if(self.recordDur.notNil and: { self.recordDur > 0 }) {
					var nextTime = self.tempoClock.nextTimeOnGrid(self.recordQuant ? 0, self.recordLatency * self.tempoClock.tempo)+self.recordDur;
					self.tempoClock.schedAbs(nextTime, {
						self.endRecordingTime = self.tempoClock.beats; // NOTE: doesnt account for latency but is used to compute duration so not a problem for the moment
						self.recorder.stopRecording;
						self[\isRecording] = false;
						self.changed(\isRecording);
						self.changed(\set, \isRecording);
						{
							self.addToRecordList(self.filename);
						}.defer(1)
					});

				}
			} {
				Log(\Param).debug("RecordFactory: already recording");
			}
		} {
			if(self[\isRecording] == true) {
				Log(\Param).debug("RecordFactory: Stop recording");
				self.tempoClock.schedAbs(self.tempoClock.nextTimeOnGrid(self.recordQuant ? 0, self.recordLatency * self.tempoClock.tempo), {
					self.endRecordingTime = self.tempoClock.beats; // NOTE: doesnt account for latency but is used to compute duration so not a problem for the moment
					self.recorder.stopRecording;
					self[\isRecording] = false;
					self.changed(\isRecording);
					self.changed(\set, \isRecording);
					{
						self.addToRecordList(self.filename);
					}.defer(1)
				});
			} {
				Log(\Param).debug("RecordFactory: was not recording");
			};
		}
		
	},

	monitorProxy: { arg self;
		if(Pdef(\RecordFactoryPlayer).source.isNil) {
			Pdef(\RecordFactoryPlayer, Pbind(\type, \rest))
		};
		Pdef(\RecordFactoryMonitor);
	},

	isMonitoring: { arg self;
		self.monitorProxy.isPlaying
	},

	isMonitoring_: { arg self, val;
		if(self.monitorProxy.isPlaying == true) {
			self.monitorProxy.stop;
		} {
			self.monitorProxy.quant = 0;
			self.monitorProxy.source = Pmono(
				 \RecordFactoryPlayer,
				\inbus, self.recBus,
				\dur, 1/4,
				\gain, Pfunc({ self.playGain }),
			);
			self.monitorProxy.play;
		}
	},

	addToRecordList: { arg self, path;
		Buffer.read(Server.default,path, action: { arg buf;
			var record;
			record = ProtoClass((
				name_: { arg recself, val;
					recself[\name] = val;
					recself.buffer = BufDef(val, recself.filePath ?? { recself.buffer });
					recself.buffer.debug("recself.buffer");
					recself.updateProxy;
				},
				// filePath: is added when saved
				updateProxy: { arg recself;
					recself.proxy = EventPatternProxy.new.source_(
						Pfindur(recself.buffer.numFrames/recself.buffer.sampleRate*self.tempoClock.tempo, Pmono(
							\playersec,
							\bufnum, Pfunc({ recself.buffer }),
							\dur, 1/4,
							\gain, Pfunc({ self.playGain }),
						)).loop
					)
				},
				buffer: buf,
				isSaved: { arg recself;
					recself.buffer.path.notNil and: {
						recself.buffer.path != self.filename;
					}
				},
				presetCompileString: { arg recself;
			   		BufDef.presetCompileString(recself.buffer.key)
				},
			));
			record.name = "recfac_%".format(Date.localtime.stamp);
			self.recordList.add(record);
			self.changed(\list);
			
		})
		
	},

	edit: { arg self;
		WindowDef(\RecordFactory).front(self);
	},

	recordList: { arg self;
		self[\recordList] = List.new;
		self[\recordList];
	},

	presetCompileString: { arg self;
		self.recordList.select(_.isSaved).collect { arg record, idx;
			record.presetCompileString ++ ";\n";
		}.join;
	},

));
);

(
WindowDef(\RecordFactory, { arg def, model;
	var reclistview = View.new;
	var meter = SimpleServerMeterView(bus:model.recBus);
	reclistview.followChange(model, \list, {
		{
			reclistview.removeAll;
			reclistview.layout = VLayout(
				* model.recordList.collect({ arg record, idx;
					VLayout(
						HLayout (
							PlayerWrapper(record.proxy).asView,
							Param(Message(record), \name).asTextField,
						),
						HLayout (
							//StaticText.new.string_("name:"),
							StaticText.new.string_("quant:").minWidth_(50),
							Param(Message(record.proxy), \quant).asTextField,
							Button.new.string_("Edit").action_({
								WindowDef(\BufferEditor).front(record.buffer)
							}),
							Button.new.string_("Save").action_({
								WindowDef(\filedialog_save).front(record.filePath ? record.name,{ arg path, file;
									file = path +/+ file;
									record.filePath = file;
									record.buffer.path = file;
									record.buffer.write(record.filePath);
									model.changed(\list);
								})
							}),
							Button.new.string_("Delete").action_({
								// does not remove saved file
								record.buffer.free;
								record.proxy.stop;
								model.recordList.remove(record);
								model.changed(\list);
							}),
						),
						HLayout (
							StaticText.new.string_("path:").minWidth_(50),
							Param(Message(record), \filePath).asTextField,
						),
					).spacing_(2)
				})
			).spacing_(17)
		}.defer;
	});
	meter.followChange(model, \recBus, {
		meter.debug("beg followChange recBus");
		meter.bus = model.recBus;
		meter.debug("end followChange recBus");
	});

	VLayout (
		HLayout (
			Param(Message(model), \isRecording, ParamBoolSpec.new).asButton("rec"),
			Param(Message(model), \recBus).asBusPopUpMenu(TagSpecDef(\BusDef_object)),
			meter.fixedSize_(50@30),
			StaticText.new.string_("quant:"),
			Param(Message(model), \recordQuant).asTextField,
			StaticText.new.string_("dur:"),
			Param(Message(model), \recordDur).asTextField,
			Button.new.string_("Save").action_({
			}),
			Param(Message(model), \isMonitoring,ParamBoolSpec.new).asButton("Monitor"),
			Param(Message(model), \playGain,\unipolar).asKnob.fixedSize_(30@30),
		),
		reclistview,
		nil,
	)
	
});
);

// END
WindowDef(\RecordFactory).front(ProtoDef(\RecordFactory));
ProtoDef(\RecordFactory).recordDur = 1

ProtoDef(\RecordFactory).edit;
ProtoDef(\RecordFactory).recordList;
ProtoDef(\RecordFactory).recordList = List.new;
~buf = ProtoDef(\RecordFactory).recordList[0].buffer
~buf.numFrames*TempoClock.default.tempo/~buf.sampleRate

ProtoDef(\RecordFactory).isRecording
ProtoDef(\RecordFactory).recBus
ProtoDef(\RecordFactory).changed(\set, \isRecording)

ProtoDef(\RecordFactory).presetCompileString

(
Ndef(\testRec, { arg freq=400, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr(0.1) * 0.8 + 1 )) * ( SinOsc.kr(3) * 1 + 1 );
	sig = Pan2.ar(sig, pan, amp);
}).play(ProtoDef(\RecordFactory).recBus.index, 2);
);

BufDef(\amen, "vipere/amenbreak.wav").key
~b = Buffer.new(s, 100)
~b.name

BufDef(\nono).play
BufDef(\nono).presetCompileString
BufDef.presetCompileString(\nono)
BufDef.presetCompileString(\amen)
BufDef.presetCompileString(\bla)

BufDef(\bla, BufDef(\amen))
BufDef.all[\bla].path
BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
