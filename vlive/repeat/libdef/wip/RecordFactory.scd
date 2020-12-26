
(
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

	addToRecordList: { arg self, path;
		Buffer.read(Server.default,path, action: { arg buf;
			var record = ProtoClass((
				name_: { arg self, val;
					self[\name] = val;
					BufDef(val, self.filePath ?? { self.buffer });
				},
				proxy: EventPatternProxy.new.source_(
					Pfindur(buf.numFrames/buf.sampleRate*self.tempoClock.tempo, Pmono(
						\playersec,
						\bufnum, buf,
						\dur, 1/4,
						\gain, Pfunc({ self.playGain }),
					)).loop
				),
				buffer: buf,
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

));
)

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
								WindowDef(\filedialog_save).front(record.filePath,{ arg path, file;
									file = path +/+ file;
									record.filePath = file;
									record.buffer.path = file;
									record.buffer.write(record.filePath);
									model.changed(\list);
								})
							}),
							Button.new.string_("Delete").action_({
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
		meter.bus = model.recBus;
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
			Param(Message(model), \playGain,\unipolar).asKnob.fixedSize_(30@30),
		),
		reclistview,
		nil,
	)
	
});
);

// END
WindowDef(\RecordFactory).front(ProtoDef(\RecordFactory));

ProtoDef(\RecordFactory).edit;
ProtoDef(\RecordFactory).recordList = List.new;
~buf = ProtoDef(\RecordFactory).recordList[0].buffer
~buf.numFrames*TempoClock.default.tempo/~buf.sampleRate

ProtoDef(\RecordFactory).isRecording
ProtoDef(\RecordFactory).recBus
ProtoDef(\RecordFactory).changed(\set, \isRecording)
