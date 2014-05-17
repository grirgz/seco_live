~name = \y;

8.do { arg x;

	Veco(~name).get_clip_by_index(x).response_mode = \play; // retrigger clip play it again instead of stopping it
}
