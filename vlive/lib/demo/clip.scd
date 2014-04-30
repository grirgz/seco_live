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
	{
		Ndef(name+++\fx).edit;
	}.defer;
}
);

/////////// un/muting clips

[\g, \h, \i].do { arg name; ~patfx_unmute.(name+++'patfx'); }
[\g, \h, \i].do { arg name; ~patfx_mute.(name+++'patfx'); }

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
	TempoClock.default.sched(4, {
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
