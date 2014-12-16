
(

// s.volume.play; // not found in 3.7

//Veco.load_lib("piano.scd");
Veco.load_lib("icon.scd");
Veco.load_lib("midi.scd");
Veco.load_lib("specs.scd");
Veco.load_lib("launchers.scd");
//Veco.load_lib("trigpad.scd");

MIDIBoard.map(\s9, s.volume, \volume);
if(s.volume.volume == 0) {
	s.volume.volume = 0.0001;
};
);


(
	~legatorest = { arg use_isrest=0;
		if(use_isrest == 1) {
			Pfunc({ arg ev;
				(ev[\legato] == 0) or: { ev[\isRest] }
			});
		} {
			Pbinop('==', Pkey(\legato), 0)
		}
	};

	~timeline_do = { arg time, index_add, spawn_fun, quantnow_fun, after_fun;
		index_add = index_add ?? 1;

		Veco.do { arg name, namex, index;
			spawn_fun = spawn_fun ?? {
				~spawn_cliprow.(index, name);
			};
			Veco(name).lib.reset_tracks;
			spawn_fun.(name, namex, index);
			if(~timeline_enabled != false) {
				Tdef(name, {
					Veco.main.clip.update_display;
					quantnow_fun.(name, namex, index);
					(time-0.12).wait;
					after_fun.(name, namex, index);
					~spawnclip.(name, index+index_add);
					0.wait;
				});
			};
		};
	};
	~vim_replace_current_line = {

		//TODO
		"vim --servername scvim --remote-send '<Esc>ccmsg<Esc>'".unixCmd;
	};

	~pselectx = { arg mix, arr;
		Prout({ arg ev;
			var arrstr = arr.collect(_.asStream);
			var arrval;
			var mixstr = mix.asStream;
			var idx;
			10000.do {
				arrval = arrstr.collect({ arg x; x.next });
				idx = mixstr.next*arr.size;
				ev = arrval.blendAt(idx).yield;
			};

		});
	};

~frozzer = { arg pat, reppat;
	Prout({

		var oldval;
		pat = pat.asStream;
		reppat = reppat.asStream;
		10000.do {
			var val = pat.next;
			var repval = reppat.next;
			if(repval == 1 or: { repval == true }) {
				if(oldval.notNil) {
					oldval.yield;
				} {
					val.yield;
				}
			} {
				oldval = val;
				val.yield;
			};
		}
	})
};
~set_next_clip = { arg time, index;
	if(~enable_clip_automation != false) {
		Veco.do { arg name, namex;
			Tdef(name, {
				Veco.main.clip.update_display;
				//namex.debug("======================= init task1");
				(time-0.5).wait;
				//(Pdef.defaultQuant/2).wait;
				//[namex, index].debug("======================== play next row!!!");
				~spawn_cliprow.(index, name);
				0.wait; // to avoid bug
			});
		}
	}
};

~set_next_clip_standalone = { arg time, index;
	if(~enable_clip_automation != false) {
		Veco.do { arg name, namex;
			Task({
				Veco.main.clip.update_display;
				namex.debug("init task1");
				(time-0.5).wait;
				//(Pdef.defaultQuant/2).wait;
				[namex, index].debug("play next row!!!");
				~spawn_cliprow.(index, name);
				nil;
			}).play(quant:Pdef.defaultQuant);
		}
	}
};

~make_fx = {
	Ndef(~name+++\fx).put(0, { arg preamp=1;
		var sigin;
		sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
		sigin = sigin * preamp;
		sigin;
	});
};

~edit_fx = { arg self, suffix=\fx;
	Veco.do { arg name, namex;
		Veco(namex).response_mode = \exec;
		{
			Ndef(name+++suffix).edit;
		}.defer;
	}
};

~define_effects_OLD = { arg fxs;
	fxs.do { arg fx, x;
		x = x + 1;
		currentEnvironment[\tfx+++x] = Veco(fx).uname+++\fx;
		currentEnvironment[\fx+++x] = BusDef(Veco(fx).uname+++\fx,\audio);
	}

};

4.do { arg x; BusDef(Veco.main.name+++\fx+++x, \audio) };

~define_effects = { arg fxs, size=inf;
	fxs.do { arg fx, x;
		var uname;
		x = x + 1;
		uname = Veco(fx).uname;
		uname.debug("define_effectsa");
		if(x <= size) {
			var bus;
				uname.debug("define_effectsxVa");
				(Veco.main.name+++\fx+++x).debug("dkj");
			bus  = BusDef(Veco.main.name+++\fx+++x, \audio);
				uname.debug("define_effectsxta");
			currentEnvironment[\fx+++x] = bus;
			currentEnvironment[\tnfx+++x] = uname;
			currentEnvironment[\tfx+++x] = uname+++\fx;
				uname.debug("define_effectsyu");
			Ndef(uname+++\fx).set(\inbus, bus);
				uname.debug("define_effectsx");
		} {
		uname.debug("define_effects1");
			Ndef(uname).set(\inbus, BusDef(\zero));
		uname.debug("define_effects2");
		}
	}
};
~restbyfreq = { arg seq, repeat=inf, moffset = 0;
	Prout({
		repeat.do { arg x;
			x = x+1 + moffset;
			Pseq(
				seq.collect { arg val;
					var offset;
					offset = (val % 1) * 10;
					val = val.asInteger;
					val == 0 or: { (x+offset) % val != 0 }
				}
			).embedInStream;
		}
		
	})
};
~envNdefq = { arg name, env;
	Ndef(name).quant = Pdef.defaultQuant;
	Ndef(name, { arg val=1; EnvGen.kr(env.circle) * val });
};
~envNdef = { arg name, env;
	Ndef(name, { arg val=1; EnvGen.kr(env.circle) * val });
};
~switchsplit = { arg arr, split, size, repeat=inf;
	//Pswitch1(arr, prob*size)
	//[(split*size).floor, ( 1-split*size +0.5).floor, (split*size).floor+ ( 1-split*size +0.5).floor].debug("switchsplit");
	Pswitch1(arr, Pseq([Pn(0,(split*size).floor), Pn(1, (1-split*size +0.5).floor)],repeat))
};
~changetempo = { arg dur, tempo;
	Task({
		var times = dur.round * 2;
		var clock = TempoClock.default;
		var itempo = clock.tempo;
		times.do { arg x;
			var settempo = blend(itempo, tempo, x/times);
			clock.tempo = settempo;
			(dur/times).wait;
		}


	}).play(TempoClock.new)

};
	~patmod = { arg pat, size ... args;
		Prout({
			//var pat = pat.asStream;
			var arr;
			var str = pat.asStream.debug("PAT");
			loop {
				arr = str.nextN(size);
				args.clump(2).do { arg x;
					arr.overWrite(x[1], x[0])
				};
				Pseq(arr,1).embedInStream;
			}
		})
	};
~kill_nodes_by_name = { arg name;
	s.getQueryTree({ arg data; 
		//data.asCompileString.postln;
		data.keys.postln;
		data.children[0].children.postln;
		data.children[0].children.do { arg child;
			[name, child.defName, child.id].debug("free?");
			if(child.defName == name) {
				[name, child.defName, child.id].debug("free!!!!!");
				s.sendMsg("/n_free", child.id);
			}
		};
	})
	
};
	~set_out_bus = { arg name, bus;
		if(bus.class == Bus) {
			bus = bus.index;
		};
		Veco(name).master_bus = bus;
		Ndef(name+++\mixer).play(bus, 2);
	};
	~dPdef = { arg name ... argpairs;
		if(Pdef(name).source.isNil) {
			Pdef(name, Pbind())
		};
		if(argpairs.size % 2 != 0) {
			("Error: ~dPdef should have even number of args plus the Pdef name: " ++ name).postln;
		} {
			argpairs.clump(2).debug("argpair");
			argpairs.clump(2).do { arg pair;
				if(pair[0] == \instrument) {
					Pdef(name).addHalo(\instrument, pair[1])
				} {
					if(pair[1].notNil) {
						Pdef(name).addSpec(pair[0], pair[1]);
					};
					[name, pair, Pdef(name).get(pair[0])].debug("pair value1");
					if(Pdef(name).get(pair[0]).isNil) {
						if(Pdef(name).getSpec(pair[0]).default.notNil) {
							[name, pair, Pdef(name).get(pair[0]), Pdef(name).getSpec(pair[0]).default].debug("pair value2");
							Pdef(name).set(pair[0], Pdef(name).getSpec(pair[0]).default)
						}
					}
				};
			}
		};
		Pdef(name);
	}
);

(
~play_timeline = { arg timeline, quant=4;
	Task({
		var play_subtimeline;
		var clock = TempoClock.default;
		var start_time = clock.beats;
		block { arg break;
		
			"--start of timeline".debug;
			play_subtimeline = { arg timeline;
				var current_time = 0;
				var wait_time = 0;
				timeline.clump(2).do { arg part;
					var time, fun;
					#time, fun = part;
					wait_time = time - current_time;
					if(wait_time < 0) {
						"error in timing".postln;
						break.value;
					};
					wait_time.wait;
					if(fun.isSequenceableCollection) {
						play_subtimeline.(fun)
					} {
						[clock.beats - start_time, clock.beats].debug("TIMELINE");
						fun.value;
					};
					current_time = current_time + wait_time;
				}
			};
			play_subtimeline.(timeline);
			"------end of timeline".debug;
	
		}
	}).play(quant:Quant(quant, -1))
};
);

(
~present_nodes_do = { arg offset=54, len=8, fun;
	len.do { arg x;
		var node;
		var index;
		index = offset + x;
		node = Veco.main.get_node_by_index(index);
		if(node.is_present) {
			fun.(index, node, x);
		}
	
	}
};


		~matrix_ctrl.set_fxlist([
			BusDef('fx1'),
			BusDef('fx2'),
			BusDef('fx3'),
			//BusDef('fx4'),
		]);
	~load_fx_matrix_editor = {
		~matrix_view.activate_display(~matrix_ctrl);
	};
);

(

	~toggle_trig = { arg name, fun1, fun2;
		var env = currentEnvironment;
		if( env[name+++\toggle] == 1) {
			"fun2trig!".debug;
			fun2.(1);
			env[name+++\toggle] = 0;
		} {
			"fun1trig!".debug;
			fun1.(0);
			env[name+++\toggle] = 1;
		};
	};

);

//////////////////////////////////////////////////// Patterns and tricks

~seqmod = { arg arr ... args;
	var size;
	size = arr.size;
	args.clump(2).do { arg x;
		x[1].do { arg val, y;
			arr[x[0]+y] = val;
		}
	};
	args.postln;
	arr;
};

~overwrite_pattern = { arg inpat, prop, timesize, overpat;
	//Prout({ arg ev;
	//	inpat.asStream.do({ arg pat;
	//		pat.debug("overwrite_pattern");
	//		ev = pat.yield;
	//	});
	//});
	Pswitch1([inpat, overpat], Pstep(Pseq([0,1],inf), Pseq([prop*timesize, timesize * (1-prop)],inf)));
	//inpat.
};



//////////////////////////////////////////////////// Env mod

(
~kmul_release = { arg key, mulkey=\mul_release;
	Pfunc({ arg ev;
		var env;
		var times;
		var mul;
		if(ev[key].isNil) {
			ev.debug("kmul_release: ev");
			"Error: kmul_release: env not found".postln;
			nil;
		} {
			env = ev[key][0];
			times;
			mul = ev[mulkey];
			env = env.deepCopy;
			//env.asCompileString.debug("env1");
			times = env.times;
			times[env.times.size-1] = times[env.times.size-1] * mul;
			env.times = times;
			//env.asCompileString.debug("env2");
			[env];
		};
	})
};

~mul_release = { arg key, mul=1;
	Pfunc({ arg ev;
		var env = ev[key][0];
		var times;
		env = env.deepCopy;
		//env.asCompileString.debug("env1");
		times = env.times;
		times[env.times.size-1] = times[env.times.size-1] * mul;
		env.times = times;
		//env.asCompileString.debug("env2");
		[env];
	})
};
~emul_release = { arg key, mul;
	Pbind(
		key, ~mul_release.(key, mul)
	)
};
~penv = { arg env;
	Ptuple( env.asArray ).collect{ arg x; [x] }
};
);

//////////////////////////////////////////////////// Trigpads

(
~pkey1 = { arg key, repeat=1;
	Pfuncn({ arg ev; ev[key] },repeat)
};

~set_exec_zone = { arg rect;
	rect.width.debug("rect");
	rect.width.do { arg x;
		rect.height.do { arg y;
			[x,y].debug("set_exec_zone");
			Veco.main.clip.abspos_to_buf(Point(x,y)+rect.origin).response_mode = \exec;
		}
	}

};

~set_fake_clip_row = { arg row, fun, start=0, len=8;
	
	len.do { arg x;
		var pos = Point(x+start, row);
		var clip = Veco.main.clip.abspos_to_buf(pos);
		var name = clip.node_uname;
		var namex = clip.uname;
		var index = row;
		clip[\execute_hook] = { arg self;
			fun.(clip, name, namex, index, x);
		};
	}
};

~clear_fake_clip_row = { arg row, start=0, len=8;
	len.do { arg x;
		var pos = Point(x+start, row);
		var clip = Veco.main.clip.abspos_to_buf(pos);
		var name = clip.node_uname;
		var namex = clip.uname;
		var index = row;
		clip[\execute_hook] = nil;
	}

};

~clip_fx_gate = { arg buskey, clip, fxindex, xfadeon=1, xfadeoff=0.5;

	var index, name, namex;
	index = clip.get_index;
	name = clip.node_uname;
	namex = clip.uname;
	Ndef(name+++\mixer).put(fxindex, \filter -> { arg in; Out.ar(BusDef(buskey), in); in; });
	Ndef(name+++\mixer).set(\xfade, xfadeon);

	//[buskey,name, index,namex, ~namex, xfadeon,xfadeoff, offset].debug("delire!!!");
	Veco(namex).response_off_hook = {
		//var index = Veco.main.uname_to_index(name);
		Ndef(name+++\mixer).set(\xfade, xfadeoff);
		index.debug("remove!!");
		//Ndef(\mangle).removeAt(index)
		Ndef(name+++\mixer).removeAt(fxindex);
	};
	Veco(namex).response_mode = \exec;
};

~fx_gate = { arg buskey, name, index, namex, xfadeon=1, xfadeoff=0.5, offset=100;

	index = index ?? ~index;
	name = name ?? ~name;
	namex = namex ?? "%.%".format(name, index+1).asSymbol;
	index = index + offset;
	Ndef(name+++\mixer).put(index, \filter -> { arg in; Out.ar(BusDef(buskey), in); in; });
	Ndef(name+++\mixer).set(\xfade, xfadeon);

	//[buskey,name, index,namex, ~namex, xfadeon,xfadeoff, offset].debug("delire!!!");
	Veco(namex).response_off_hook = {
		//var index = Veco.main.uname_to_index(name);
		Ndef(name+++\mixer).set(\xfade, xfadeoff);
		index.debug("remove!!");
		//Ndef(\mangle).removeAt(index)
		Ndef(name+++\mixer).removeAt(index);
	};
	Veco(namex).response_mode = \exec;
};

~insert_beat = { arg key, namex;
	var env = currentEnvironment;
	var gate;
	namex = namex ?? ~namex;
	gate = key+++\gate +++ namex;
	env[gate] = 1;
	env[key] = Pbind(\isRest, Pseq([false],inf), \bla, Pfunc({ env[gate] }));
	Veco(namex).response_off_hook = { env[gate] = nil };
	Veco(namex).response_mode = \exec;
};

~insert_beat_quant = { arg key, quant=1;
	var env = currentEnvironment;
	var gate;
	var namex;
	namex = ~namex;
	gate = key+++\gate +++ namex;
	Veco(namex).response_mode = \exec;

	env[gate] = 1;
	TempoClock.default.play ({
		env[key] = Pbind(\isRest, Pseq([false],inf), \bla, Pfunc({ env[gate] }));
	},quant);

	Veco(namex).response_off_hook = { env[gate] = nil };
};

~patfx_gate = { arg key, pat, namex;
	var env = currentEnvironment;
	var gate;
	namex = namex ?? ~namex;
	gate = key+++\gate +++ namex;
	env[gate] = 1;
	env[key] = pat <> Pbind(\bla, Pfunc({ env[gate] }));
	Veco(namex).response_off_hook = { env[gate] = nil };
	Veco(namex).response_mode = \exec;
};

~patfx_insert = { arg key, pat, namex;
	var env = currentEnvironment;
	namex = namex ?? ~namex;
	env[key] = pat ;
	Veco(namex).response_mode = \exec;
};

~patfx_on = { arg key, pat, namex;
	var env = currentEnvironment;
	var gate;
	namex = namex ?? ~namex;
	gate = key+++\on +++ namex;
	env[gate] = 1;
	env[key] = pat <> Pbind(\bla, Pfunc({ env[gate] }));
	Veco(namex).response_mode = \exec;
};

~patfx_off = { arg key, namex;
	var env = currentEnvironment;
	var gate;
	namex = namex ?? ~namex;
	gate = key+++\on +++ namex;
	env[gate] = nil;
};

~patfx_mute = { arg key, namex;
	var env = currentEnvironment;
	var gate;
	gate = key+++\mute;
	env[gate] = 1;
	env[key] = Pbind(\isRest, true, \bla, Pfunc({ env[gate] }));
	if(namex.notNil) {
		Veco(namex).response_mode = \exec;
	}
};

~patfx_unmute = { arg key, namex;
	var env = currentEnvironment;
	var gate;
	gate = key+++\mute;
	env[gate] = nil;
	if(namex.notNil) {
		Veco(namex).response_mode = \exec;
	}
};

~patfx_toggle_mute = { arg key, namex;
	var env = currentEnvironment;
	var gate;
	gate = key+++\mute;
	if(env[gate].notNil) {
		env[gate] = nil;
		if(namex.notNil) {
			Veco(namex).response_mode = \exec;
		}
	} {
		env[gate] = 1;
		env[key] = Pbind(\isRest, true, \bla, Pfunc({ env[gate] }));
		if(namex.notNil) {
			Veco(namex).response_mode = \exec;
		}
	}
};


~addfx = { arg key, delta, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	TempoClock.default.sched(delta, {
		Ndef(key).removeAt(pos);
	})
};

~addnotefx = { arg key, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	Veco(~namex).response_off_hook = {
		Ndef(key).removeAt(pos);
	}
};

~addnotefx_delay = { arg key, delay, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	Veco(~namex).response_off_hook = {
		//Ndef(key).removeAt(pos);
		
		TempoClock.default.sched(delay, {
			Ndef(key).removeAt(pos);
		})
	}
};

~classic_patfx = { arg key;
    Prout { arg in;
		var pat;
		var ev, str;
		var chain = List.new;
		var get_ev = { arg input;
			var to_remove = List.new;
			chain.do { arg str, idx;
				var vinput;
				vinput = str.next(input);
				if(vinput.notNil) {
					input = vinput
				} {
					to_remove.add(idx);
				};
			};
			to_remove.reverse.do { arg idx;
				chain.removeAt(idx)
			};
			input;
		};
		inf.do {
			if(currentEnvironment[key].notNil) {
				str = currentEnvironment[key].asStream;
				chain.add(str);
				currentEnvironment[key] = nil;
			};
			//chain.debug("chain");
			ev = get_ev.(in);
			in = ev.yield;
        };
        nil;
    }
	<> Pbind(
		\time, Ptime(),
	)
};

~quant_patfx = { arg key;
    Prout { arg in;
		var pat;
		var ev, str;
		var chain = List.new;
		var get_ev = { arg input;
			var to_remove = List.new;
			chain.do { arg str, idx;
				var vinput;
				vinput = str.next(input);
				if(vinput.notNil) {
					input = vinput
				} {
					to_remove.add(idx);
				};
			};
			to_remove.reverse.do { arg idx;
				chain.removeAt(idx)
			};
			input;
		};
		inf.do {
			if(currentEnvironment[key].notNil) {
				var quant;
				var quant_key = key+++\quant;
				str = currentEnvironment[key].asStream;
				quant = currentEnvironment[quant_key];
				if(quant.notNil) {
					var time = in[\time];
					var target_time = time % quant;
					var trash;
					var trash_str;
					var current_time = 0;
					block { arg break;
						100.do {
							//trash_str = str.deepCopy;
							//trash = trash_str.next(in);
							trash = str.next(in);
							if(current_time >= target_time) {
								str = Pseq([trash, str]).asStream;
								break.value;
							};
							if(trash.isNil) {
								break.value;
							};
							//str = trash_str;
							current_time = current_time + trash[\dur];
						}
					}
				};
				chain.add(str);
				currentEnvironment[key] = nil;
				currentEnvironment[quant_key] = nil;
			};
			//chain.debug("chain");
			ev = get_ev.(in);
			in = ev.yield;
        };
        nil;
    }
	<> Pbind(
		\time, Ptime(),
	)
};

~patfx = ~quant_patfx;

~patfxref = { arg fx_inject;
    Prout { arg in;
		var pat;
		var ev, str;
		var chain = List.new;
		var get_ev = { arg input;
			var to_remove = List.new;
			chain.do { arg str, idx;
				var vinput;
				vinput = str.next(input);
				if(vinput.notNil) {
					input = vinput
				} {
					to_remove.add(idx);
				};
			};
			to_remove.reverse.do { arg idx;
				chain.removeAt(idx)
			};
			input;
		};
		inf.do {
			if(fx_inject.value.notNil) {
				pat = fx_inject.value;
				str = pat.asStream;
				chain.add(str);
				fx_inject.value = nil;
			};
			//chain.debug("chain");
			ev = get_ev.(in);
			in = ev.yield;
        };
        nil;
    };
};

);


//////////////////////////////////////////////////// Macros

(
~midi = { arg key, default, spec;
	var preset;
	spec = spec.asSpec;
	spec = spec ?? \widefreq.asSpec;
	spec.postln;
	preset = PresetDef.force(key, [\val, spec]);
	if(default.notNil) {
		preset.set_val(\val, default)
	};
	preset.vals[\val].set_bus_mode(true);
	~set_macro.(key, preset, \val, spec);
	preset.vals[\val];
};

~set_macro = { arg key, obj, member, spec, register=true;
	spec = spec.asSpec;
	if(obj.class == Ndef) {
		obj.addSpec(member, spec);
	};
	MIDIBoard.map(key, obj, member, spec);
	if(register == true) {
		if(Veco(~name).lib.macros.isNil) {
			Veco(~name).lib.macros = List.newClear(20);
		};
		if(Veco(~name).lib.macros.isSequenceableCollection and: {key.asString[0] == $k} ) {
			Veco(~name).lib.macros[ key.asString[1].digit -1 ] = [obj, member, spec];
		};
		if(Veco(~name).lib.macros.isSequenceableCollection and: {key.asString[0] == $s} ) {
			Veco(~name).lib.macros[ key.asString[1].digit -1 + 8 ] = [obj, member, spec];
		};
	}
	
};

~ndef_to_macros = { arg key;
	Ndef(key).controlNames.collect { arg con, x;
		[Ndef(key), con.name]
	}
};

~map_ndef_to_knobs = { arg key, bindings, exclude;
	bindings = bindings ?? (1..8).collect(\k+++_);
	block { arg break;
		var x = 0;
		Ndef(key).controlNames.collect { arg con;
			[exclude, con.name.dump,exclude.includes(con.name).not ].debug("exclude");
			if(exclude.includes(con.name).not) {
				MIDIBoard.map(bindings[x], *[Ndef(key), con.name]);
				x = x+1;
				if(x >= bindings.size) { break.value };
			};
		}
	}

};

);



////////////////////////////////////////////////////  clips

(

~spawnclip = { arg node_uname, clip_index;
	// accept node indexes too
	var tr = node_uname;
	[node_uname, clip_index].debug("spawnclip: node_uname, clip_index");
	if(tr.class != Symbol) {
		tr = Veco.main.get_node_by_index(tr).uname;
	};
	tr.debug("hian1");
	if(clip_index.isNil) {
		clip_index = \nil;
	};
	switch(clip_index,
		\nil, {
			// NOOP
	[node_uname, clip_index].debug("spawnclip: hian2: WTF: node_uname, clip_index");
	tr.debug("hian2");
		},
		\r, {
			Veco(tr).stop_node(true);
	tr.debug("hian3");
		}, 
		\rr, {
			Veco(tr).stop_node(false);
	tr.debug("hian3");
		}, 
		\p, {
			Veco(tr).play_node;
	tr.debug("hian4");
		}, 
		{
			if(clip_index.class == Symbol) {
				// NOOP
	tr.debug("hian5");
			} {
				if(Veco(tr).is_playing.not or: { Veco(tr).active_clip_index != clip_index }) {
					var clip = Veco(tr).get_clip_by_index(clip_index);
	tr.debug("hian6");
	[node_uname, clip_index, clip.uname].debug("hian6: clip_index");
					if(clip.is_present.not) {
						// TODO: make a mode where non existing clip continue playing
						Veco(tr).stop_node(true);
					} {
						if(clip.response_mode == \exec) {
							clip.response_on;
		tr.debug("hian7");
						} {
							clip.response_on_play;
		tr.debug("hian8");
						}
					}
				} {
	tr.debug("hian9");
					"already playing"
				}
			};
		}
	);
};

~clip_pspawner = 
	Pbind(
		\isRest, true,
		\clipspawner, Pfunc{ arg ev; 
			var tracks;
			ev.debug("clip_pspawner");
			tracks = ev[\track];
			tracks.debug("whatA");
			if(tracks.isNil) {
				"Error: clip_pspawner: track is nil".postln;
			} {
				if(tracks.class != Array) {
					tracks = [tracks]
				};
				tracks.do{ arg tr, x;
					var clip = ev[\clip];
					if(clip.class == Array) {
						clip = clip[x]
					};
					~spawnclip.(tr, clip);
				}; 
			};
			1;
		},
	);


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

~spawn_cliprow = { arg index, name, tracks;
	name = name ?? ~name;
	tracks = tracks ?? Veco(name).lib.tracks;
	if(index.isSequenceableCollection) {
		tracks.collect { arg uname, i;
			~spawnclip.(uname, index[i])
		}
	} {
		tracks.collect { arg uname;
			~spawnclip.(uname, index)
		}
	}

};

);

////////////////////////////////////////////////////  quickpad

(

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
	var qp = Veco.main.quickpad_controller;
	codepad = qp.get_codepad(Point(1,0));
	codepad.payload = { arg self;
		{
			~namex.debug("edit namex");
			Sdef(~namex, \mypreset).edit;
		}.defer;
	};

	codepad = qp.get_codepad(Point(1,1));
	codepad.payload = { arg self;
		//{
			//~load_fx_matrix_editor.();
		~matrix_view.skip_first_time = true;
		~matrix_view.activate_display(~matrix_ctrl);
		//}.defer(1);
	};

	codepad = qp.get_codepad(Point(1,2));
	codepad.payload = { arg self;
		var name = ~name;
		{
			Ndef(name+++\fx).edit;
		}.defer;
	};

	codepad = qp.get_codepad(Point(1,3));
	codepad.payload = { arg self;
		var name = ~name;
		{
			Ndef(name+++\mixer).edit;
		}.defer;
	};
	
};

~load_quick_mode_chooser = { arg self;
	var codepad;
	var qp = Veco.main.quickpad_controller;
	codepad = qp.get_codepad(Point(7,0));
	codepad.payload = { arg self;
		//{
			if(Veco.main.clip_response_mode == \toggle) {
				Veco.main.clip_response_mode = \play;
				debug("set Clip response mode = play");
			} {
				Veco.main.clip_response_mode = \toggle;
				debug("set Clip response mode = toggle");
			}
		//}.defer;
	};
	codepad = qp.get_codepad(Point(7,1));
	codepad.payload = { arg self;
		//{
			if(Veco.main.clip[\response_launcher_on_hook].isNil) {
				~load_standard_launchers.();
				debug("set Clip launcher mode = select page");
			} {
				Veco.main.clip[\response_launcher_on_hook] = nil;
				debug("set Clip launcher mode = launch row");
			}
		//}.defer;
	};
	
};

~load_quick_project_switcher_OLD = {
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

~load_quick_project_switcher = {
	var codepad;
	var qp = ~veco.quickpad_controller;
	8.do { arg slot;
		codepad = qp.get_codepad(Point(6,slot));
		codepad.payload = { arg self;
			slot.debug("switch_project_slot ============================= ------------------ =========================");
			Veco.switch_project_slot(slot);
		};
	}
};


~load_standard_quickpad = { arg self;
	~load_standard_launchers.();
	~load_quick_quant_chooser.();
	~load_quick_editors.();
	~load_quick_project_switcher.();
	~load_quick_mode_chooser.();
};

);

////////////////////////////////////////////////////  morph

(

// lag each key of a pattern
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


// pattern morphing and the key is a valuepattern
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
					//res_ev.debug("res_ev");
					in = res_ev.yield;
				}
			}
		}
	};
	rout
};

// pattern morphing with a list and the key is a valuepattern
~lmorphpat = { arg pat_list, mpat;
	var spat1, spat2, smpat;
	var ev1, ev2, morph;
	var res_ev;
	var rout;
	var exclu = Set[\dur, \instrument, \isRest];
	//var inclu = Set[\ffreq];
	var str_list;
	var val_list;
	var list;
	var size;
	str_list = pat_list.collect(_.asStream);
	size = pat_list.size - 1;
	smpat = mpat.asStream;
	rout = Prout { arg in;
		block { arg break;
			loop {
				in = in.deepCopy;
				morph = smpat.next;
				val_list = str_list.collect { arg spat; spat.next(in); };
				if(val_list.any({ arg x; x.isNil }) or: { morph.isNil }) { 
					break.value;
				} {
					ev1 = val_list[0];
					res_ev = in.deepCopy;
					ev1.keys.difference(exclu).do { arg key;
						list = val_list.collect { arg x; x[key] };
						if(ev1[key].isNumber or: {ev1[key].isSequenceableCollection}) {
							res_ev[key] = list.blendAt(morph*size)
						}
					};
					//res_ev.debug("res_ev");
					in = res_ev.yield;
				}
			}
		}
	};
	rout
};

// pattern morphing with a list and the key is in the input pattern
~ilmorphpat = { arg pat_list, inkey;
	var spat1, spat2, smpat;
	var ev1, ev2, morph;
	var res_ev;
	var rout;
	var exclu = Set[\dur, \instrument, \isRest];
	//var inclu = Set[\ffreq];
	var str_list;
	var val_list;
	var list;
	var size;
	str_list = pat_list.collect(_.asStream);
	size = pat_list.size - 1;
	rout = Prout { arg in;
		block { arg break;
			loop {
				in = in.deepCopy;
				morph = in[inkey];
				//morph.debug("ilmorphpat:morph");
				val_list = str_list.collect { arg spat; spat.next(in); };
				if(val_list.any({ arg x; x.isNil }) or: { morph.isNil }) { 
					break.value;
				} {
					ev1 = val_list[0];
					res_ev = in.deepCopy;
					ev1.keys.difference(exclu).do { arg key;
						list = val_list.collect { arg x; x[key] };
						if(ev1[key].isNumber or: {ev1[key].isSequenceableCollection}) {
							res_ev[key] = list.blendAt(morph*size)
						}
					};
					//res_ev.debug("ilmorphpat: res_ev");
					in = res_ev.yield;
				}
			}
		}
	};
	rout
};

// set ndef to a 3gt
~morph_to = { arg key, gen;
	Ndef(~name+++key, gen.value({Ndef(~name+++key).kr}));
};

);

//////////////////////////////////////////////////// 
//////////////////////////////////////////////////// 
//////////////////////////////////////////////////// 

//////////////////////////////////////////////////// channel modes

(

~tdef_channel = { arg suffix=\fx;
	var name = ~name;
	var fxname = ~name +++ suffix;
	Veco(name).add_play_node_hook(\fx, {
		Tdef(name).play;
	});

	Veco(name)[\is_playing] = { arg self;
		Tdef(name).isPlaying;
	};

	Veco(name).add_stop_node_hook(\fx, {
		Tdef(name).stop;
	});
	
};

~pdef_channel = { arg suffix=\fx;
	Veco(~name).make_mixer;
};

~stop_ndef = { arg fxname;
	var fadetime;
	fadetime = Ndef(fxname).getHalo(\fadeOut) ?? Ndef(fxname).fadeTime;
	[fxname, fadetime].debug("stop FX");
	Ndef(fxname).end(fadetime);
};

~pdef_fx_channel = { arg suffix=\fx;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);

	Veco(~name).make_mixer;

	~make_fx.();
	Ndef(fxname).set(\inbus, BusDef(fxname));
	// FIXME: should be suffix instead of \fx
	Veco(name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer, \audio).index);
	});

	Veco(name).add_stop_node_hook(\fx, {
		~stop_ndef.(fxname);
	});

};

~ndef_control_channel = { arg suffix=\fx;
	var name = ~name;
	var fxname = ~name +++ suffix;
	Veco(~name).make_mixer;
	Veco(~name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		debug("what");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer, \audio).index);
	});

	Veco(~name)[\is_playing] = { arg self;
		Ndef(fxname).isPlaying;
	};

	Veco(~name).add_stop_node_hook(\fx, {
		~stop_ndef.(fxname);
	});
	
};

~ndef_channel = { arg suffix=\fx;
	var name = ~name;
	var fxname = ~name +++ suffix;
	Veco(~name).make_mixer;
	Veco(~name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		debug("what");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer, \audio).index);
	});

	Veco(~name)[\is_playing] = { arg self;
		Ndef(fxname).isPlaying;
	};

	Veco(~name).set_amp_level_hook = { arg self, val;
		Ndef(fxname).set(\gain, val);
	};
	Ndef(fxname).set(\gain, Veco(~name).get_amp_level);

	Veco(~name).add_stop_node_hook(\fx, {
		~stop_ndef.(fxname);
	});
	
};

~fx_channel = { arg suffix=\fx;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);
	~ndef_channel.(suffix);

};



);

//////////////////////////////////////////////////// 
(

//~set_exec_zone.(Rect(0,32,8,32+8));

//(
//8.do { arg x;
//	8.do { arg y;
//		Veco.main.clip.abspos_to_buf(Point(x,y)+Point(0,32)).response_mode = \exec;
//	}
//}
//);

~pdegcps = { arg octave=5, root, scale, pat;
	pat.collect({ arg val; ~degcps.(val, octave, root, scale) });
};

~degcps = { arg deg, octave=5, root, scale; 
	root = root ?? 60.midicps;
	scale = scale ?? Scale.major;
	scale.degreeToFreq(deg, root, octave-5); 
};


~cdegcps = { arg tab, octave=5, root=(60.midicps), scale; 
	tab.collect { arg val;
		if(val >= 0) {
			~degcps.(val % 7, octave + (val/7).asInteger, root, scale)
		} {
			~degcps.(val % 7, octave + (val-7/7).asInteger, root, scale)
		}

	}
};

~swing = (1 + (0.06 * Pseq([-1,1],inf)));


~newfx = { arg suffix;
	var fxname = ~name+++suffix;
	BusDef(fxname, \audio);

	Veco(~name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		debug("what");
		//Ndef(fxname).send;
		Ndef(fxname).play;
	});

	Veco(~name).add_stop_node_hook(\fx, {
		~stop_ndef.(fxname);
	});
};

~newfxmix = { arg suffix;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);

	// FIXME: should be suffix instead of \fx
	Veco(name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer, \audio).index);
	});

	Veco(name).add_stop_node_hook(\fx, {
		~stop_ndef.(fxname);
	});
};

~newfxchannel = { arg suffix=\fx;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);
	Veco(~name).make_mixer;

	// FIXME: should be suffix instead of \fx
	Veco(name).add_play_node_hook(\fx, {
		fxname.debug("play FX");
		//Ndef(fxname).send;
		Ndef(fxname).play(BusDef(name+++\mixer, \audio).index);
	});

	Veco(~name)[\is_playing] = { arg self;
		Ndef(fxname).isPlaying;
	};

	Veco(name).add_stop_node_hook(\fx, {
		~stop_ndef.(fxname);
	});
};

~newlfo = { arg suffix;
	var name = ~name;
	var fxname = name+++suffix;
	BusDef(fxname, \audio);

	//Veco(name).add_play_node_hook(\fx, {
	//	fxname.debug("play LFO");
	//	//Ndef(fxname).send;
	//	//Ndef(fxname).play
	//});

	Veco(name).add_stop_node_hook(suffix, {
		~stop_ndef.(fxname);
	});
};

~isrest = { arg pat;
	pat.collect { arg x; if(x == 1) { false } { true } }
};


ControlSpec.specs[\spread] = \unipolar.asSpec;



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
