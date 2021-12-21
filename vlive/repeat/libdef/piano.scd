
(
ParamProto.init;
FileSystemProject.load("lib/piano.scd");
ProtoDef(\piano, (
	startControl: { arg self, target;
		if(target.isNil) {
			target = Pdef(\piano_player, Pbind(\instrument, \default));
			MIDIMap(\apk9,Param(Pdef(\piano_player), \amp).setBusMode);
		};
		self.pianoTarget = target;
		if(~apro_device_id.notNil) {
			self.apro(~seqPlayerGroup.new(target));
		};
		if(~nektar_device_id.notNil) {
			self.nektar(~seqPlayerGroup.new(target));
		};
		if(~nektar_device_id.isNil and: {~apro_device_id.isNil}) {
			"unable to find nektar or apro, try init midi".debug;
		}
	},

	edit: { arg self, target;
		target = target ? self.pianoTarget;
		WindowDef(\piano_pdef_editor, {
			VLayout (
				WindowDef(\PdefEditor).asView(target),
				WindowDef(\pianokeyboard).asView(target).minSize_(800@120),
			)
		}).front;
	},

	apro: { arg self, playergroup;
		~apro_device_id.debug("A-PRO device id");
		if(self.playergroup.notNil) {
			self.playergroup.stop;
		};
		self.playergroup = playergroup;
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			"on".debug(args);
			self.playergroup.elAt(midinote).play;
		}, srcID:~apro_device_id);
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			"off".debug(args);
			self.playergroup.elAt(midinote).stop;
		}, srcID:~apro_device_id);
		
		MIDIdef(\piano).permanent = self.permanent;
		MIDIdef(\piano_off).permanent = self.permanent;
	},

	stopControl: { arg self;
		MIDIdef.noteOn(\piano).clear;
		MIDIdef.noteOn(\piano_off).clear;
	},

	nektar: { arg self, playergroup;
		~nektar_device_id.debug("Nektar SE25 device id");
		if(self.playergroup.notNil) {
			self.playergroup.stop;
		};
		self.playergroup = playergroup;
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			"on".debug(args);
			self.playergroup.elAt(midinote).play;
		}, srcID:~nektar_device_id);
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			"off".debug(args);
			self.playergroup.elAt(midinote).stop;
		}, srcID:~nektar_device_id);
		
		MIDIdef(\piano).permanent = self.permanent;
		MIDIdef(\piano_off).permanent = self.permanent;
	},

	keyboard: { arg self, target;
		if(target.isNil) {
			target = Pdef(\piano_player, Pbind(\instrument, \default));
		};
		WindowDef(\pianokeyboard).front(target);
	},

	permanent: true,
));

WindowDef(\pianokeyboard, { arg def, target;
	var kb = MIDIKeyboardView.new;
	if(target.notNil) {
		var player = ~seqPlayerGroup.new(target);
		kb.keyDownAction = { arg midinote, old;
			if(old.notNil) {
				player.elAt(old).stop;
			};
			player.elAt(midinote).play;
		};
		kb.keyTrackAction = { arg midinote, old;
			player.elAt(old).stop;
			player.elAt(midinote).play;
		};
		kb.keyUpAction = { arg midinote;
			player.elAt(midinote).stop;
		};
	};
	def.windowDo { arg win;
		win.setInnerExtent(800,120)
	};
	kb.asView;
});

ProtoDef(\nektar, (
	parent: ProtoDef(\piano),
	startControl: { arg self, notetimeline;
		var playergroup = notetimeline.wrapper;
		self.nektar(playergroup);
	},
));
ProtoDef(\apro, (
	parent: ProtoDef(\piano),
	startControl: { arg self, notetimeline;
		var playergroup = notetimeline.wrapper;
		self.apro(playergroup);
	},
));
ProtoDef(\generic_piano, (
	// FIXME: should just be generic midi receiver
	parent: ProtoDef(\piano),
	startControl: { arg self, notetimeline;
		var playergroup = notetimeline.wrapper;
		notetimeline.keys.debug("kkjjkj");
		if(~apro_device_id.notNil) {
		notetimeline.keys.debug("kkjjk1j");
			self.apro(playergroup);
		};
		if(~nektar_device_id.notNil) {
		notetimeline.keys.debug("kkjjk3j");
			self.nektar(playergroup);
		};
	},
));
);


TagSpecDef(\NoteTimeline_controller).addUnique(\generic_piano, ProtoDef(\generic_piano));
TagSpecDef(\NoteTimeline_controller).addUnique(\nektar, ProtoDef(\nektar));
TagSpecDef(\NoteTimeline_controller).addUnique(\apro, ProtoDef(\apro));

