
Mdef.main.samplekit_manager.parse_samplekit_dir;
Mdef.main.samplekit_manager.parse_samplekit_dir(~seco_root_path +/+ "hydrogenkits/");


Mdef.samplekit[\default][0]
Mdef.sample(\default,1)
Mdef.samplekit.keys

(
~codepads.get_codepad(Point(0,0)).payload = {
	"plop!!!!!!!".debug;
	(
		instrument: \stereosampler,
		bufnum: Mdef.sample(\default,1),
	).play;
}
)

(
	~load_samplekit = { arg name;
		Mdef.samplekit[name].size.do { arg idx;
			var x;
			x = idx % 8;
			y = (idx / 8).asInteger;
			~codepads.get_codepad(Point(x,y)).payload = {
				"plop!!!!!!!".debug;
				(
					instrument: \stereosampler,
					bufnum: Mdef.sample(name,idx),
					//sustain: 0.1,
					latency: 0.0,
				).play;
				//Synth(\stereosampler, [\bufnum, Mdef.sample(\default,idx)])
			}

		}
	};
	~load_samplekit.(\default);


)

(
	~load_samplekit = { arg name;
		Mdef.samplekit[name].size.do { arg idx;
			var x;
			var codepad;
			x = idx % 8;
			y = (idx / 8).asInteger;
			codepad = ~codepads.get_codepad(Point(x,y));
			codepad.mystream = 
				Pbind(
					\instrument, \stereosampler,
					\bufnum, Mdef.sample(name,idx),
					\speed, Pseq([1,0.9,0.8,1.1,1,1.2],inf),
					//sustain: 0.1,
					\latency, 0.0,
				).asStream;
			codepad.payload = { arg self;
				"plop!!!!!!!".debug;
				self.player = self.mystream.next(Event.default).play;
				self.player.debug("player");
				//Synth(\stereosampler, [\bufnum, Mdef.sample(\default,idx)])
			};
			codepad.payload_off = { arg self;
				"DSTOP".debug;
				//self.player[\type] = \off;
				//self.player[\latency] = 0;
				//self.player = self.player[\type] = \off;
				self.player.synth.stop;
				
			};

		};
		~scene_codepads.render_state;
	};
	~load_samplekit.(\default);


)

(
	~load_samplekit = { arg name;
		Mdef.samplekit[name].size.do { arg idx;
			var x;
			var codepad;
			x = idx % 8;
			y = (idx / 8).asInteger;
			codepad = ~codepads.get_codepad(Point(x,y));
			codepad.mypat = 
				Pbind(
					\instrument, \stereosampler,
					\bufnum, Mdef.sample(name,idx),
					\speed, Pwhite(0.95,1.05),
					//sustain: 0.1,
					\dur, 1/4,
					\latency, 0.0,
				);
			codepad.payload = { arg self;
				"plop!!!!!!!".debug;
				self.player = self.mypat.play(quant:1/4);
				self.player.debug("player");
				//Synth(\stereosampler, [\bufnum, Mdef.sample(\default,idx)])
			};
			codepad.payload_off = { arg self;
				"DSTOP".debug;
				//self.player[\type] = \off;
				//self.player[\latency] = 0;
				//self.player = self.player[\type] = \off;
				self.player.stop;
				
			};

		};
		~scene_codepads.render_state;
	};
	~load_samplekit.(\default);


)

(
	~load_samplekit = { arg name;
		Mdef.samplekit[name].size.do { arg idx;
			var x;
			var codepad;
			x = idx % 8;
			y = (idx / 8).asInteger;
			codepad = ~codepads.get_codepad(Point(x,y));
			codepad.mypat = 
				Pbind(
					\instrument, \stereosampler,
					\bufnum, Mdef.sample(name,idx),
					\speed, Pwhite(0.95,1.05),
					\isRest, ~isrest.(Pseq([1,0,1,0, 1,0,1,1],inf)),
					//sustain: 0.1,
					\dur, 1/8,
					\latency, 0.0,
				);
			codepad.payload = { arg self;
				"plop!!!!!!!".debug;
				self.player = self.mypat.play(quant:1/4);
				self.player.debug("player");
				//Synth(\stereosampler, [\bufnum, Mdef.sample(\default,idx)])
			};
			codepad.payload_off = { arg self;
				"DSTOP".debug;
				//self.player[\type] = \off;
				//self.player[\latency] = 0;
				//self.player = self.player[\type] = \off;
				self.player.stop;
				
			};

		};
		~scene_codepads.render_state;
	};
	~load_samplekit.(\default);


)

Mdef.samplekit.keys
~load_samplekit.(\TR808EmulationKit)
~load_samplekit.('HipHop-2')
~load_samplekit.('VariBreaks')
~load_samplekit.('UltraAcousticKit')
