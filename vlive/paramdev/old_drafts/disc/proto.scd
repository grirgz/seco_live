(

~pdef = ProtoClass((
	startup: { arg self;
		self.proxy = EventPatternProxy.new;
	},

	source_: { arg self, val;
		self.proxy.source = val;
	},

	play: { arg self;
		self.proxy.play;
	},

	downAction: { arg self;
		
	},

	upAction: { arg self;
		
	},

))
)

~hello = ~pdef.copy;
~hello.startup
(
~hello.source = Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
);
)
~hello.play
