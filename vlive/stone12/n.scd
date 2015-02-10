

~ndef_control_channel.();

(
8.do { arg x;
	var clip = Veco(~name).get_clip_by_index(x);
	var node = Veco(~name);
	var scale = [0,1/8,1/4,1/2,1,2,4,8];
	node.lib.gate = 0;
	clip.is_present = true;
	clip[\execute] = { arg self;
		Ndef(~scratch1+++\speed).set(\speedfmamp, scale[clip.get_index]);
	};
}
);
