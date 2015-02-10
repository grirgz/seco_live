
~ndef_control_channel.();

(
8.do { arg x;
	var clip = Veco(~name).get_clip_by_index(x);
	var node = Veco(~name);
	var scale = [0,1/8,1/4,1/2,1,2,4,8];
	node.lib.gate = 0;
	clip.is_present = true;
	clip[\execute] = { arg self;
		node.lib.gate = node.lib.gate + 1;
		Ndef(~scratch1+++\speed).set(\xspeed, 1);
		Ndef(~scratch1+++\sfreq, {
			scale[clip.get_index];
		});
	};
	clip.response_off_hook = {
		clip.uname.debug("fuck off");
		node.lib.gate = node.lib.gate - 1;
		if(node.lib.gate < 1) {
			Ndef(~scratch1+++\speed).set(\xspeed, 0)
		};
	}
}
)
