
(
FileSystemProject.load("lib/piano.scd");
ProtoDef(\piano, (
	startControl: { arg self, target;
		~apro_device_id.debug("A-PRO device id");
		if(target.isNil) {
			target = Pdef(\piano_player, Pbind(\instrument, \default));
			MIDIMap(\apk9,Param(Pdef(\piano_player), \amp).setBusMode);
		};
		if(self.playergroup.notNil) {
			self.playergroup.stop;
		};
		self.playergroup = ~seqPlayerGroup.new(target);
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

	permanent: true,
))
);
