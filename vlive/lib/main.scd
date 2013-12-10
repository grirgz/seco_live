
(
~degcps = { arg deg, octave=5, root=(60.midicps); Scale.major.degreeToFreq(deg, 60.midicps, octave-5); };


~cdegcps = { arg tab, deg, octave=5, root=(60.midicps); 
	tab.collect { arg val;
		if(val >= 0) {
			~degcps.(val % 7, octave + (val/7).asInteger)
		} {
			~degcps.(val % 7, octave + (val-7/7).asInteger)
		}

	}
};

~swing = (1 + (0.06 * Pseq([-1,1],inf)));

~newfx = { arg suffix;
	var fxname = ~name+++suffix;
	BusDef(fxname, \audio);

	Veco(~name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play;
	});

	Veco(~name).add_stop_node_hook(\fx, {
		fxname.debug("stop FX");
		Ndef(fxname).end(Ndef(fxname).fadeTime);
	});
};

~newfxmix = { arg suffix;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);

	Veco(name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer));
	});

	Veco(name).add_stop_node_hook(\fx, {
		fxname.debug("stop FX");
		Ndef(fxname).end(Ndef(fxname).fadeTime);
	});
};

~newlfo = { arg suffix;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);

	Veco(name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer));
	});

	Veco(name).add_stop_node_hook(\fx, {
		fxname.debug("stop FX");
		Ndef(fxname).end(Ndef(fxname).fadeTime);
	});
};

~isrest = { arg pat;
	pat.collect { arg x; if(x == 1) { false } { true } }
};

~load_quick_quant_chooser = { arg quants;
	var codepad;
	var qp = ~veco.quickpad_controller;
	quants = quants ?? [1/8,1/4,1/2,1,  2,4,8,16];
	quants.do { arg quant, y;
		codepad = qp.get_codepad(Point(0,y));
		codepad.payload = { arg self;
			quant.debug("setting Pdef.defaultQuant to");
			Pdef.defaultQuant = quant;
		};
	}
};

~load_quick_editors = { arg self;
	var codepad;
	var qp = ~veco.quickpad_controller;
	codepad = qp.get_codepad(Point(1,0));
	codepad.payload = { arg self;
		{
			~namex.debug("edit namex");
			Sdef(~namex, \mypreset).edit;
		}.defer;
	};
	
};

~load_quick_project_switcher = {
	var codepad;
	var qp = ~veco.quickpad_controller;
	codepad = qp.get_codepad(Point(2,0));
	codepad.payload = { arg self;
		"loadprojectA".debug;
		if(~quick_project_a.notNil and: { ~last_loaded_quick_project != ~quick_project_a }) {
			~last_loaded_quick_project = ~quick_project_a;
			Veco.main.open_project_in_vim(~quick_project_a);
		};
	};
	codepad = qp.get_codepad(Point(2,1));
	codepad.payload = { arg self;
		"loadprojectB".debug;
		if(~quick_project_b.notNil and: { ~last_loaded_quick_project != ~quick_project_b }) {
			~last_loaded_quick_project = ~quick_project_b;
			Veco.main.open_project_in_vim(~quick_project_b);
		};
	};

};

~load_standard_quickpad = { arg self;
	~load_quick_quant_chooser.();
	~load_quick_editors.();
	~load_quick_project_switcher.();
};

ControlSpec.specs[\spread] = \unipolar.asSpec;

~spawnclip = { arg node_uname, clip_index;
	var tr = node_uname;
	switch(clip_index,
		nil, {
			// NOOP
		},
		\r, {
			Veco(tr).stop_node(true);
		}, 
		{
			if(clip_index.class == Symbol) {
				// NOOP
			} {
				Veco(tr).get_clip_by_index(clip_index).response_on;
			};
		}
	);
};

~clipspawner = {
	~add_stop_clipspawner.();
	Pbind(
		\clipspawner, Pfunc{ arg ev; 
			ev.postln; ev[\track].do{ arg tr, x;
				var clip = ev[\clip];
				if(clip.class == Array) {
					clip = clip[x]
				};
				~spawnclip.(tr, clip);
			}; 
			1;
		},
	)
};

~add_stop_clipspawner = {
	var name = ~name;
	[name].debug("XXX=========add_stop_clipspawner");
	Veco(name).add_stop_node_hook(\clipspawner, { 
		var tracks = Veco(name).lib.tracks;
		//topEnvironment[\tpercs].debug("add_stop_node_hook: tpercs");
		[name, tracks].debug("=========add_stop_clipspawner");
		tracks.do { arg track;
			Veco(track).stop_node;
		};
	});
};

~spawnclips = { arg clips;
	clips.pairsDo { arg tr,clip;
		~spawnclip.(tr, clip);
	}
};

~spawn_cliprow = { arg index;
	if(index.isSequenceableCollection) {
		Veco(~name).lib.tracks.collect { arg uname, i;
			~spawnclip.(uname, index[i])
		}
	} {
		Veco(~name).lib.tracks.collect { arg uname;
			~spawnclip.(uname, index)
		}
	}

};


~morph = { arg mainkey, lagtime, pat;
	var base = pat.asStream.next(());
	var bind = List.new;
	var proxy;
	var bus;
	base.keysValuesDo { arg key, val;
		var ndefkey = "%.%".format(mainkey, key).asSymbol;
		[key, val].debug("morph:val");
		if(val.isArray) {
			var asize;
			var aval;
			aval = val[0];
			aval = aval.asArray;
			asize = aval.size;
			Ndef(ndefkey, { 
				blend(Ndef(ndefkey).kr(asize), aval, Line.kr(0, 1, lagtime))
			});
			if(val[0].class == Env) {
				bus = val;
			} {
				proxy = Ndef(ndefkey);
				bus = [proxy.busArg];
			}
		} {
			Ndef(ndefkey, { 
				Line.kr(Ndef(ndefkey).kr, val, lagtime)
			});
			proxy = Ndef(ndefkey);
			bus = proxy.bus.asMap;
		};
		bind.add(key);
		bind.add(bus);
	};
	Pbind(*bind)
};


// pattern morphing
~morphpat = { arg pat1, pat2, mpat;
	var spat1, spat2, smpat;
	var ev1, ev2, morph;
	var res_ev;
	var rout;
	var exclu = Set[\dur, \instrument, \isRest];
	//var inclu = Set[\ffreq];
	spat1 = pat1.asStream;
	spat2 = pat2.asStream;
	smpat = mpat.asStream;
	rout = Prout { arg in;
		block { arg break;
			loop {
				in = in.deepCopy;
				ev1 = spat1.next(in);
				ev2 = spat2.next(in);
				morph = smpat.next;
				if(ev1.isNil or: { ev2.isNil or: { morph.isNil }}) { 
					break.value;
				} {
					res_ev = in.deepCopy;
					ev1.keys.difference(exclu).do { arg key;
					//ev1.keys.select({ arg x; inclu.includes(x) }).do { arg key;
						//res_ev[key] = (ev1[key] * morph) + (ev2[key] * (1 - morph));
						if(ev1[key].isNumber or: {ev1[key].isSequenceableCollection}) {
							res_ev[key] = blend(ev1[key], ev2[key], morph)
						}
					};
					res_ev.debug("res_ev");
					in = res_ev.yield;
				}
			}
		}
	};
	rout
};

~save_object = { arg name, object;
	if(object.notNil) {
		object.writeArchive(Veco.main.data_path +/+ name ++ ".obj");
	};
};
~load_object = { arg name;
	var res = Object.readArchive(Veco.main.data_path +/+ name ++ ".obj");
	if(res.isNil) { name.debug("load_object: nil!!!"); 1.cantLoadNilObject };
	res;
};

~get_mixer_group = {
	
	if(~mixer_group.isPlaying.not) {
		~mixer_group = Group.after;
		~mixer_group.register(true);
		~mixer_group.isPlaying;
	};
	~mixer_group;
};

);
