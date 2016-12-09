
FileSystemProject.load("lib/icon.scd");

(
~icon_map_rdn = { arg fx;

	[
		\fb,
		\distamp,
		\pitchmix,

		\pitchlag,
		\fbdistmix,
		\fbdistamp,

	].collect({ arg key, x;
		if(key.notNil) {
			MIDIMap(\k +++ ( x+1 ), Param(fx, key));
		}
	});

	[
		\delay,
		\delay2,
		\deltran1,
		\deltran2,

		\deltran3,
		\shift,
		\shift2,
		\postlpf,
	].collect({ arg key, x;
		MIDIMap(\s +++ ( x+1 ), Param(fx, key));
	});

	MIDIMap(\a1, {
		"clear!".debug;
		fx.set(\shift, 0);
		fx.set(\shift2, 0);
	});

};
~icon_map_rdn.(Ndef(\fx1));
)

Ndef(\fx1).edit
