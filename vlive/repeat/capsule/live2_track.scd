
FileSystemProject.load("capsule/protolive.scd");

(
~t = 145/4/60; TempoClock.default.tempo = ~t;
TrackDef(\live2_project, (
	swing: -1/6,
	prefix:\live2_,
	trackkeys_: { arg self, keys;
		self.tracks = keys.collect { arg key;
			var track = TrackDef(self.prefix+++key);
			currentEnvironment[key] = track.new;
			track;
		};
	},
));



TrackTemplateDef(\live2_track, (
	project: TrackDef(\live2_project),
	parent: TrackTemplateDef(\protopat),
	swing: { arg self;
		self.project.swing;
	},
	init: { arg self;
		self.init_chain;
	},
	init_chain: { arg self, keylist;
		var chain;
		keylist = keylist ? [
			\pmono,
			\mute,
			\macro,
			\mix,
			\post,
			\pat,
			\pre,
		];
		self.chainkeys = keylist;
		chain = keylist.collect({ arg name;
			if( Pdef(self.key+++name).source.isNil ) {
				Pdef(self.key+++name, 
					Pbind()
				)
			};
			Pdef(self.key+++name)
		});
		Pdef(self.key, 
			Pchain(*chain),
		);
		Pdef(self.key+++\post, Pbind()); // clear custom keys
		Pdef(self.key+++\pre, Pbind()); // clear custom keys

		self;
	},
	send: { arg self, target;
		if(target == 0) {
			self.dependOn = nil;
			Pbindef(self.key+++\mix, 
				\out, 0;
			);
			self.promiseAtQuant;
		} {
			if(target.inbus.notNil) {
				self.dependOn = target;
				target.play;
				Pbindef(self.key+++\mix, 
					\out, target.inbus,
				);
				self.promiseAtQuant;
			} {
				"ERROR: no inbus found"
			};
		};

		self;
	},

	clean: { arg self;
		Pdef(self.key).clear;
		self.chainkeys.collect({ arg name;
			Pdef(self.key+++name).clear;
		});
		self;
	},

	neuter: { arg self;
		self.chainkeys.reject({ arg x; x == \pat }).collect({ arg name;
			name.debug("name");
			Pdef(self.key+++name, Pbind());
		});
		self;
	},

	mute: { arg self, muted=true;
		if(muted == true) {
			Pbindef(self.key+++\mute, 
				\muter, Rest(1),
			);
		} {
			Pdef(self.key+++\mute, 
				Pbind()
			);
			//Pbindef(self.key+++\mute).unset(\muter) 
		};
		self;
	},

	unmute: { arg self;
		self.mute(false)
	},

	pre: { arg self ...pairs;
		Pbindef(self.key+++\pre, *pairs);
		self;
	},

	ppost: { arg self ...pairs;
		Pbindef(self.key+++\post, *pairs);
		self;
	},

	unppost: { arg self;
		Pdef(self.key+++\post, Pbind());
		self;
	},

	pat: { arg self ...pairs;
		Pbindef(self.key+++\pat, *pairs);
		self;
	},

	////////// general tricks

	//fadein: { arg self, dur;
		//var argname = \amp;
		//dur = dur ? self.quant;
		//if(tracktype == \fx) {
			//argname = \gain;

		//};
		//Pbindef(self.key+++\mix, 
			//argname, ~pmodenv.(Pseq([0,1,1,4],inf), 8),
		
		//);
		
	//},

	line: { arg self, key, start, end, dur;
		dur = dur ? self.quant;
		Pbindef(self.key+++\post,
			key, Pseq([
				~pmodenv.(Pseq([start,end],1), dur),
				Pn(end,inf)
			],inf),
		);
		self.promiseAtQuant(dur);
		self;
	},


));

TrackTemplateDef(\live2_trackfx, (
	parent: TrackTemplateDef(\live2_track),
	tracktype: \fx,
	inbus: { arg self;
		BusDef(self.key+++\inbus, \audio, 2)
	},
	//mute: { arg self, muted=true;

		////if(muted == true) {
			////Pbindef(self.key+++\mute, 
				////\gain, 0,
			////);
		////} {
			////Pdef(self.key+++\mute, 
				////Pbind()
			////);
			//////Pbindef(self.key+++\mute).unset(\muter) 
		////};
		//self;
	//},

));

~at = TrackDef(\scheduler, (
	parent: ProtoDef(\live2_track),
));
)
