
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
