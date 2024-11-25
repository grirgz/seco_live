(
SynthDef(\ScopeView_audio_mono, { arg bus, bufnum;
	var z;
	z = In.ar(bus, 1);

	ScopeOut2.ar(z, bufnum);
	//Out.ar(0, z);
}).add;
SynthDef(\ScopeView_audio_stereo, { arg bus, bufnum;
	var z;
	z = In.ar(bus, 2);

	ScopeOut2.ar(z, bufnum);
	//Out.ar(0, z);
}).add;
SynthDef(\ScopeView_control_mono, { arg bus, bufnum;
	// FIXME: control rate not working well, refresh is too slow
	var z;
	z = In.kr(bus, 1);

	ScopeOut2.kr(z, bufnum);
	//Out.ar(0, z);
}).add;
SynthDef(\ScopeView_control_stereo, { arg bus, bufnum;
	var z;
	z = In.kr(bus, 2);

	ScopeOut2.kr(z, bufnum);
	//Out.ar(0, z);
}).add;

WindowDef(\ScopeView, { arg def, bus;
	var scope = ScopeView.new;
	var player;
	var runtask;
	var bufnum;
	var numChannels;
	var inBus;
	scope.server = Server.default;
	scope.onClose_({
		//"scope closed".debug;
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
			var rate;
			inBus = ibus ? inBus;
			//[ibus, inBus].debug("ibus inBus");
			//bufnum.debug("bufnum");
			if(inBus.numChannels != numChannels) {
				numChannels = inBus.numChannels;
				bufnum.free;
				bufnum = Buffer.alloc(s,1024,numChannels);
				//bufnum = Buffer.alloc(s,10,numChannels);
				s.sync;
			};
			//bufnum.debug("bufnum2");
			if(player.notNil) {
				//scope.stop;
				player.free;
				player = nil;
			};

			rate = if(inBus.rate == \scalar) {
				// assume audio
				\audio
			} {
				inBus.rate
			};

			instr = "ScopeView_%_%".format(
				rate,
				if(numChannels == 1) {
					"mono"
				} {
					"stereo"
				}
			).asSymbol;

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

// END


/// kr
(
SynthDef(\ScopeView_control_mono, { arg bus, bufnum;
	var z;
	z = In.kr(bus, 1);
	z.poll;

	ScopeOut2.kr(z, bufnum); // kr works but refresh is very slow
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
				\ScopeView_control_mono
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
