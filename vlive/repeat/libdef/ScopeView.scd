(
SynthDef(\ScopeView_mono, { arg bus, bufnum;
	var z;
	z = In.ar(bus, 1);

	ScopeOut2.ar(z, bufnum);
	//Out.ar(0, z);
}).add;
SynthDef(\ScopeView_stereo, { arg bus, bufnum;
	var z;
	z = In.ar(bus, 2);

	ScopeOut2.ar(z, bufnum);
	//Out.ar(0, z);
}).add;

WindowDef(\ScopeView, { arg def, bus;
	//var scope = ScopeView(def.window, Rect(0,0,100,100));
	var scope = ScopeView.new;
	var player;
	var runtask;
	var bufnum;
	var numChannels;
	var inBus;
	scope.server = Server.default;
	scope.onClose({
		scope.stop;
		player.free;
		bufnum.free;
	});
	//bufnum = Buffer.alloc(s,1024,numChannels);
	//s.sync;
	//bus.debug("scope initial bus");
	runtask = { arg ibus;
		Task({
			var instr;
			inBus = ibus ? inBus;
			//[ibus, inBus].debug("ibus inBus");
			//bufnum.debug("bufnum");
			if(inBus.numChannels != numChannels) {
				numChannels = inBus.numChannels;
				bufnum.free;
				bufnum = Buffer.alloc(s,1024,numChannels);
				s.sync;
			};
			//bufnum.debug("bufnum2");
			if(player.notNil) {
				//scope.stop;
				player.free;
				player = nil;
			};

			instr = if(numChannels == 1) {
				\ScopeView_mono
			} {
				\ScopeView_stereo
			};

			player = (
				instrument: instr, 
				bus:inBus, 
				bufnum: bufnum.bufnum, 
				addAction: \addToTail, 
				\sustain:inf
			).play;

			{ 
				scope.bufnum = bufnum.bufnum; 
				scope.start; 
			}.defer;
		}).play;
	};
	runtask.(bus);
	scope.addUniqueMethod(\inBus_, { arg view, abus;
		runtask.(abus)
	}).addUniqueMethod(\inBus, { arg view, abus;
		inBus;
	}).addUniqueMethod(\restart, { arg view, abus;
		runtask.();
	});
	
});
)
