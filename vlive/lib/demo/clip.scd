
~pdef_init.(Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1
));

~pdef_init = { arg pat;
	Pdef(~name, 
		Pdef(~name+++\patfx) <>
		Pdef(~name+++\mod) <>
		Pdef(~name+++\pre) <>
		pat
		<> Veco(~name).mixer;
	)
};

// prevent stopping when it's a special track like spawnclip which has a stop handler
Veco.main[\in_stop_exclusion_range] = { arg x; x.inclusivelyBetween(55,64) };

//////////// start and stop

// ndef

Ndef(~name+++\fx).setHalo(\fadeOut, 10); // the veco stop action will use this time to fadeOut the Ndef
Ndef(Veco('a').uname+++\fx).stop; // stop
Ndef(Veco('a').uname+++\fx).stop(fadeTime:8); // stop with fadeTime
Ndef(Veco(5).uname+++\fx).end(8); // stop with fadeTime and board show node not playing

// pdef

Pdef(Veco('a').uname).stop; // stop
Pdef(Veco('a').uname).xstop(8); // stop with fadeTime

// node

Veco(5).stop_node(false) // stop immediatly
Veco(5).stop_node(true) // stop with quant

Veco(Point(5,11)).play_node // like pushing button: start selected clip with quant, if already playing, play it again
Veco(5).fadeout(2) // fadeout the pattern in two seconds (not implemented for ndef currently)

Veco(5).response_on // like pushing button: start selected clip with quant, if already playing, stop it
Veco(5).active_clip_index // selected clip
Veco(Point(5,11)).response_on_play // like pushing button: start selected clip with quant, if already playing, play it again
Veco(Point(5,11)).response_off // like releasing button: do nothing unless there is a hook defined for this clip

//////////////////////////////////////////////////////
//////////// timeline clip (launch row then next row)

~tdef_channel.();

Veco(~name).lib.tracks = (0..30);
Tdef(~name).quant = Pdef.defaultQuant;

(
Veco.do { arg name;
	Veco(name).lib[\reset_tracks] = {
		//Ndef(~tfx1).put(60, nil);
		//Veco(name).lib.tracks.do { arg tr;
		//	Ndef(Veco(tr).uname+++\mixer).set(\amp, 1);
		//	Ndef(Veco(tr).uname+++\mixer).set(\send1, 0);
		//};
		//Veco(~tnfx1).play_node;
	};
	Veco(name).lib.reset_tracks;
};
);

(
	// in main lib

~timeline_do = { arg time, index_add, spawn_fun, quantnow_fun, after_fun;
	index_add = index_add ?? 1;
	Veco.do { arg name, namex, index;
		spawn_fun = spawn_fun ?? {
			~spawn_cliprow.(index, name);
		};
		Veco(name).lib.reset_tracks;
		spawn_fun.(name, namex, index);
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
)

// in clip

~timeline_do.(32);




//////////////////////////////////////////////////////
//////////// OLD timeline clip (launch row then next row)

// node

~tdef_channel.();

Veco(~name).lib.tracks = [1,2,3,4,5,6,7];
Tdef(~name).quant = Pdef.defaultQuant

(
Veco.do { arg name;
	Veco(name).lib[\reset_tracks] = {
		Ndef(~tfx1).put(60, nil);
		Veco(name).lib.tracks.do { arg tr;
			Ndef(Veco(tr).uname+++\mixer).set(\amp, 1);
			Ndef(Veco(tr).uname+++\mixer).set(\send1, 0);
		};
		Veco(~tnfx1).play_node;
	};
	Veco(name).lib.reset_tracks;
};
)

// clip

Veco.do { arg name, namex, index;
	Veco(name).lib.reset_tracks;
	~spawn_cliprow.(index);
	Tdef(name, {
		Veco.main.clip.update_display;
		4.wait;
		~spawnclip.(name, index+1);
		0.wait;
	});
};

////////////// channel fx track

// init
~define_effects.(['56','57','58','59']);

// node
~fx_channel.();
~make_fx.();

// clip


Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4),\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2)
	);

	sig;
})



////////////// ndef track

~ndef_channel.();

// clip

(
Ndef(~name+++\fx, { arg freq=500, pan=0, amp=0.1, spread=0.8;
	var sig;
	sig = LFSaw.ar(freq * SinOsc.kr([1,2,4]) + freq);
	sig = RLPF.ar(sig,  SinOsc.kr([1,2,4]*10.3) + 1 * freq * 1.4);
	sig = Impulse.ar(CuspN.ar(1) + 1 * 50);
	sig = Ringz.ar(sig,  CuspN.ar(4) * 0.1 + 1 * 1500, SinOsc.kr(1).range(0.3,1)/10);
	sig = sig * 0.6;
	sig = Splay.ar(sig, spread, amp, pan);
});
);

////////////// pdef track

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// clip

Pdef(~name +++ \pre, Pbind(
	\freq, 100,
));

/////////// start or stop clips with a pattern

(
Pdef(~name+++\cs, 
	~clip_pspawner <> Pbind(
		\track, (1..8),
		\track, (0..7)+8,
		//\clip, Pseq([
		//	[\r,\r,\r,\r],
		//	[\p,\p,\p,\p],
		//]),
		\clip, Pseq([\r,\p],inf),

		\clip, Prout({
			8.do { arg x;
				~wavearray.(\r, \p, x, 8).yield;
			};
		}),
		\dur, 4

	)
).play
)

/////////// start or stop clips
~spawnclip.(\a, 3); // play clip 3
~spawnclip.(8, 3); // accept indexes
~spawnclip.(8, \r); // accept indexes

(15..20).do { arg x; ~spawnclip.(x, \r) }; // stop (rest)
(8..10).do { arg x; ~spawnclip.(x, \p) }; // play


/////////// edit fx
(
Veco.do { arg name;
	Veco(~name).response_mode = \exec;
	{
		Ndef(name+++\fx).edit;
	}.defer;
}
);

//////////////////////////////////////////////////////////// patfx

/////////// un/muting clips

[\g, \h, \i].do { arg name; ~patfx_unmute.(name+++'patfx'); }
[\g, \h, \i].do { arg name; ~patfx_mute.(name+++'patfx'); }

/////////// insert beat

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, 
	~patfx.(~name+++\patfx) <>
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\fratio, 2,
	\dur, 1/8,
	\amp, 0.4 * Pkey(\amp),
) <> Veco(~name).mixer)
);

(
		~set_exec_zone.(Rect(0,32, 32+16,64));
		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(8,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(16,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(24,Veco.main.clip_offset.y)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				{ev.no_pane},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
);

(
1.do { arg x;
	var row = 32;
	~set_fake_clip_row.(row, { arg clip, name, namex, index;
		~insert_beat.(name+++\patfx)
	}, 0, 32);
	row = row + 1;
	~set_fake_clip_row.(row, { arg clip, name, namex, index;
		~patfx_toggle_mute.(name+++\patfx)
	}, 0, 32);
}
);


//////////////////////////////////////////////////////////// 

/////////// response mode
Veco(~namex).response_mode = \exec;

/////////// create fake clips


// column
8.do { arg x;
	var clip = Veco(~name).get_clip_by_index(x);
	clip.is_present = true;
	clip[\execute] = { arg self;
		x.debug("resp!!!!!!!!!!!!!!!!!");
		Ndef('32fx').set(\delay, 1/(2**x))
	};
	clip.response_mode = \exec;
}

// row
(
3.do { arg x;
	var row = 33;
	var node = Veco.main.clip.abspos_to_buf(Point(x, row));
	node[\execute] = { arg self;
		Ndef(~fxcomb+++\fx).set(\delay, 1/8*(2**x))
	};
	node.is_present = true;
	node.response_mode = \exec;
}
)

/////////// //////////////
~newfxmix.(\fx);
Veco(~name).make_mixer;
Veco(~name).add_stop_node_hook(\fx, { "rah".debug("rahxx") }); // disable stop fx
Veco(~name).add_stop_node_hook(\mixer, { "rah".debug("rahxx") }); // disable stop mixer
Veco(~name).get_clip_by_index(0).response_mode = \play; // retrigger clip play it again instead of stopping it

/////////// run action quantized

~quant = 1/2;
TempoClock.default.play ({
	Ndef(~wobblefx).set(\choose, 2);
	Ndef(~wobblefx).set(\stutter, 8);
	nil;
}, ~quant);

///////// remove the action after a delay

~addfx = { arg key, delta, fun;
	var pos;
	Ndef(key).add(fun);
	pos = Ndef(key).objects.lastIndex;
	TempoClock.default.sched(delta, {
		Ndef(key).removeAt(pos);
	})
}

///////// remove the action when note off

~quant = 1/2;
TempoClock.default.play ({
	Ndef(~wobblefx).set(\choose, 2);
	Ndef(~wobblefx).set(\stutter, 8);
	nil;
}, ~quant);

Veco(~namex).response_off_hook = {
	TempoClock.default.play ({
		//~quant.wait;
		Ndef(~wobblefx).set(\choose, 0);
		Ndef(~wobblefx).unset(\choose);
		nil;
	}, [~quant, 1/2]);
};

// caution: use Veco.do instead of ~name (because async)

Veco.do { arg name;
	Veco(~namex).response_off_hook = {
		Pdef(name).stop;
	};
};

// or

Veco(~namex).response_off_hook = { arg self, name, namex, index;
	Pdef(name+++\pre, Pbind());
};


// trigger a trigger in a ndef without getting it stuck

Ndef(~name+++\fx).set(\fxtrig, 1);
Veco.do { arg name;
	{
		Ndef(name+++\fx).set(\fxtrig, 0);
	}.defer
};
Veco(~namex).response_mode = \exec;
