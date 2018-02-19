
(
~streamPlayer = ProtoClass((
	new: { arg self, parent, x;
		self = self.deepCopy;
	
		
		self.parent_self = {parent};
		self.index = x;
	
		self;
	},

	target: { arg self;
		self.parent_self.targets[self.index];
	},

	target_: { arg self, val;
		self.parent_self.setTarget(self.index, val);
	},

	preChain: { arg self;
		self.parent_self.preChain
	},

	postChain: { arg self;
		self.parent_self.postChain
	},

	play: { arg self;
		if(self.target.notNil) {

			if(self.stream.isNil) {
				var pat = self.target.asPattern;
				if(self.preChain.notNil) {
					pat = self.target.asPattern <> self.preChain;
				};
				if(self.postChain.notNil) {
					pat = self.postChain <> self.target.asPattern;
				};
				self.stream = pat.asStream;
			};
			if(self.cur_ev.notNil) { // required for not overwriting player if already playing (too fast pushing)
				self.cur_ev.release;
				self.cur_ev = nil;
			};
			if(self.ev.isNil) {
				self.ev = Event.default;
			};
			self.ev.debug("play: before next: ev");
			self.ev = self.stream.next(self.ev);
			if(self.ev.notNil) {
				self.ev.debug("play: ev");
				self.raw_ev = self.ev.copy; // for recording, find better property name
				self.raw_ev[\kitIndex] = self.index;
				self.play_ev = self.ev.copy;
				self.play_ev[\isRest] = false;
				self.play_ev[\sustain] = inf;
				self.play_ev[\latency] = \;
				self.cur_ev = self.play_ev.play;
				self.changed(\play);
				self.parent_self.changed(\play, self.index);
			}
		} 
	},

	asPlayerEvent: { arg self; 
		// PlayerEvent == does not embed in stream
		// but asPlayerEvent is taken by PlayerWrapper
		self.raw_ev.debug("asPlayerEvent: raw_ev");
		self.raw_ev;
	},

	reboot: { arg self;
		self.stream = nil;
	},

	isPlaying: { arg self;
		if(self.cur_ev.isNil) {
			false;
		} {
			self.cur_ev.isPlaying;
		};
	},

	stop: { arg self;
		self.changed(\stop);
		self.parent_self.changed(\stop, self.index);
		self.cur_ev.release;
		self.cur_ev = nil;
	},

));
)

(
Pdef(\testpat, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);

~streamPlayer.new(( targets:[Pdef(\testpat)] ), 0).play

( 'instrument': \default, 'degree': 0, 'dur': 1, 'amp': 0.1, \sustain:inf , latency:\no).play
( 'instrument': \default, 'degree': (0..50).choose, \octave:3, 'dur': 1, 'amp': 0.1, \sustain:inf , latency:\no).play

{ GVerb.ar() }
