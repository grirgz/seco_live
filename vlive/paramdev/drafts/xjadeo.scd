
b = NetAddr.new("127.0.0.1", 7890);    // create the NetAddr
b.sendMsg("/jadeo/load", "/home/ggz/Vidéos/simplescreenrecorder-2023-07-21_02.02.55.mkv");    // send the application the message "hello" with the parameter "there"
b.sendMsg("/jadeo/load", "/home/ggz/Vidéos/854268-hd_1920_1080_30fps.mp4");    // send the application the message "hello" with the parameter "there"
b.sendMsg("/jadeo/cmd", "play", 1);    // send the application the message "hello" with the parameter "there"
b.sendMsg("/jadeo/cmd", "play 1");    // send the application the message "hello" with the parameter "there"
b.sendMsg("/jadeo/play", 1);    // send the application the message "hello" with the parameter "there"
b.sendMsg("/play", 1);    // send the application the message "hello" with the parameter "there"
b.sendMsg("/jadeo/seek", 0);    // send the application the message "hello" with the parameter "there"


(
Pdef(\xjadeo, 
	Pfset(
		{
			"send osc start".postln;
			TempoClock.default.beats.postln;
		},
		Pbind(
			\dur, 1/2, // send rate
			\time, Pseries(0,1/2), // 1/2 is also send rate
			\send, Pfunc({ arg ev;
				//ev.debug("ev");
				//ev.parent.debug("evp");
				"send osc time %".format(ev[\time]).postln;
			}),
		),
		{
			"send osc stop".postln;
			TempoClock.default.beats.postln;
		}
	)
).play;
);

ClipTimeline(\bla).edit

(
Pdef(\xjadeo, 
	Pfset(
		{
			"send osc start".postln;
			b.sendMsg("/jadeo/load", "/home/ggz/Vidéos/simplescreenrecorder-2023-07-21_02.02.55.mkv");    // send the application the message "hello" with the parameter "there"
		},
		Pbind(
			\type, \rest,
			\dur, 1/2, // send rate
			\time, Pseries(0,1/2), // 1/2 is also send rate
			\send, Pfunc({ arg ev;
				var tempo = TempoClock.default.tempo;
				var fps = 30075;
				var frame = fps * ev[\time] / tempo;
				//ev.debug("ev");
				//ev.parent.debug("evp");
				"echo play | jack_transport".unixCmd;
				"echo locate % | jack_transport".format(frame).unixCmd;
				"send osc time % %".format(ev[\time], frame).postln;
			}),
		),
		{
			"send osc stop".postln;
			"echo stop | jack_transport".unixCmd;
			TempoClock.default.beats.postln;
		}
	)
).play;
);

kk


ProtoClass(\xjadeo, (
	new: { arg self;
		self = ProtoClass((parent:self));
	
		self.pat
	
		self;
	},
))

(
ProtoTemplateDef(\xjadeo, (

	netAddr: { arg self;
		if(self[\netaddr_instance].isNil) {
			self[\netaddr_instance] = NetAddr.new("127.0.0.1", 7890);    // create the NetAddr
		};
		self[\netaddr_instance];
	},

	videoPath_: { arg self, path;
		self[\videoPath] = path;
		self.loadVideo;
	},

	loadVideo: { arg self;
		self.netAddr.sendMsg("/jadeo/load", self.videoPath);
	},

	play: { arg self, starttime=0;
		if(self[\isPlaying] == true) {
			// NOOP
		} {
			var tempo = TempoClock.default.tempo;
			var frame = starttime / tempo * Server.default.sampleRate;
			"echo play | jack_transport".unixCmd;
			"echo play | jack_transport".unixCmd;
			"echo locate % | jack_transport".format(frame).unixCmd;
			self[\isPlaying] = true;
		};
	},

	stop: { arg self;
		"stop".postln;
		"echo stop | jack_transport".unixCmd;
		self[\isPlaying] = false;
	},
));
ProtoDef(\video1, \xjadeo)
)

(
Pdef(\xjadeo, 
	Pfset(
		{
			"send osc start".postln;
			//ProtoDef(\video1).videoPath = "/home/ggz/Vidéos/simplescreenrecorder-2023-07-21_02.02.55.mkv";
			ProtoDef(\video1).loadVideo;
		},
		Pbind(
			\dur, 1/2, // send rate
			\time, Pseries(0,1/2), // 1/2 is also send rate
			\play, {
				ProtoDef(\video1).play(~time);
			}
		),
		{
			"send osc stop".postln;
			ProtoDef(\video1).stop;
		}
	)
).play;
);

(
Pdef(\video2, 
	Pfset(
		{
			"send osc start".postln;
			//ProtoDef(\video2).videoPath = "/home/ggz/Vidéos/simplescreenrecorder-2023-07-21_02.02.55.mkv";
			//ProtoDef(\video1).loadVideo;
		},
		Pbind(
			\dur, 1/2, // send rate
			\time, Pseries(0,1/2), // 1/2 is also send rate
			\play, {
				ProtoDef(\video2).play(~time);
			}
		),
		{
			"send osc stop".postln;
			ProtoDef(\video2).stop;
		}
	)
);
);

ProtoDef(\video1).play
ProtoDef(\video1).stop
ProtoDef(\video1).isPlaying
ProtoDef(\video2, \xjadeo).videoPath = "/home/ggz/Vidéos/simplescreenrecorder-2023-07-21_02.02.55.mkv";
ProtoDef(\video1).videoPath = "/home/ggz/Vidéos/854268-hd_1920_1080_30fps.mp4";


///////////////// goal: make the sound track of a video file


(
ProtoTemplateDef(\xjadeo, (

	netAddr: { arg self;
		if(self[\netaddr_instance].isNil) {
			self[\netaddr_instance] = NetAddr.new("127.0.0.1", 7890);    // create the NetAddr
		};
		self[\netaddr_instance];
	},

	videoPath_: { arg self, path;
		self[\videoPath] = path;
		self.loadVideo;
	},

	loadVideo: { arg self;
		self.netAddr.sendMsg("/jadeo/load", self.videoPath);
	},

	play: { arg self, starttime=0;
		if(self[\isPlaying] == true) {
			// NOOP
		} {
			var tempo = TempoClock.default.tempo;
			var frame = starttime / tempo * Server.default.sampleRate;
			"echo play | jack_transport".unixCmd;
			"echo play | jack_transport".unixCmd;
			"echo locate % | jack_transport".format(frame).unixCmd;
			self[\isPlaying] = true;
		};
	},

	stop: { arg self;
		"stop".postln;
		"echo stop | jack_transport".unixCmd;
		self[\isPlaying] = false;
	},
));
ProtoDef(\video1, \xjadeo);
ProtoDef(\video1).videoPath = "/home/ggz/Vidéos/854268-hd_1920_1080_30fps.mp4";
)

(
Pdef(\video1, 
	Pfset(
		{
			"send osc start".postln;
			if(ProtoDef(\video1).isPlaying) {
				ProtoDef(\video1)[\isPlaying] = false;
			};
			//ProtoDef(\video2).videoPath = "/home/ggz/Vidéos/simplescreenrecorder-2023-07-21_02.02.55.mkv";
			//ProtoDef(\video1).loadVideo;
		},
		Pbind(
			\dur, 1/2, // send rate
			\time, Pseries(0,1/2), // 1/2 is also send rate
			\play, {
				"play % (isPlaying: %)".format(~time, ProtoDef(\video1).isPlaying).postln;
				ProtoDef(\video1).play(~time);
			}
		),
		{
			"send osc stop".postln;
			ProtoDef(\video1).stop;
		}
	)
);
);

ClipTimeline(\vid).edit



(
Pdef(\testclean, Prout({ arg inval;
	var pat = Pbind(
		\dur, 1/2, // send rate
		\time, Pseries(0,1/2), // 1/2 is also send rate
		\play, {
			"play % (isPlaying: %)".format(~time, ProtoDef(\video1).isPlaying).postln;
			ProtoDef(\video1).play(~time);
		}
	);
	var stream = pat.asStream;
	var cleanup = EventStreamCleanup.new;
	var outval;
	cleanup.addFunction(inval, { "cleaip!!!".debug });
	"start".debug;
	outval = inval;
	1000.do { arg item, idx;
		cleanup.update(outval);
		inval = outval.yield;
	};
	"cleanup".debug;
	cleanup.exit(inval);
	
}))
)

ClipTimeline(\tc).edit

(
Pdef(\video1, Prout({ arg inval;
	var pat = Pbind(
		\dur, 1/2, // send rate
		\time, Pseries(0,1/2), // 1/2 is also send rate
		\play, {
			"play % (isPlaying: %)".format(~time, ProtoDef(\video1).isPlaying).postln;
			ProtoDef(\video1).play(~time);
		}
	);
	var stream = pat.asStream;
	var cleanup = EventStreamCleanup.new;
	var outval;
	cleanup.addFunction(inval, { 
		"cleaip!!!".debug;
		ProtoDef(\video1).stop;
	});
	"start".debug;
	if(ProtoDef(\video1).isPlaying) {
		ProtoDef(\video1)[\isPlaying] = false;
	};
	while {
		outval = stream.next(inval);
		outval.notNil;
	} {
		cleanup.update(outval);
		inval = outval.yield;
	};
	"cleanup".debug;
	cleanup.exit(inval);
	
}))
)

// why when starting from middle of pattern the cleanup is not called ?



(
Pdef(\cutter, 
	Prout({ arg ev;
		var pat, str;
		pat = Pfindur(2, Pdef(\video1));
		str = pat.asStream;

		str.next(ev); // drop some events
		str.next(ev); // drop some events
		str.next(ev); // drop some events
		str.next(ev); // drop some events
		100.do { arg item, idx;
			ev = str.next(ev).yield;
			ev.debug("ev");
		};
		"the end".debug;
	})
);
)


Pdef(\cutter).play


~str = Pfindur(2, Pbind()).asStream;
~str.next(Event.default)
~str.next(nil)
