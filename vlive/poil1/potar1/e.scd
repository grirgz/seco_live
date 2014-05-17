~name = \e;

(
8.do { arg x;
	var clip = Veco(~name).get_clip_by_index(x);
	clip.is_present = true;
	clip[\response_on] = { arg self;
		x.debug("resp!!!!!!!!!!!!!!!!!");
		Ndef('32fx').set(\randrate, (2**x))
	}
}
);
