
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


~newfx = { arg suffix;
	var fxname = ~name+++suffix;
	BusDef(fxname, \audio);

	Veco(~name).play_node_hook = {
		Ndef(fxname).play;
	};

	Veco(~name).stop_node_hook = {
		Ndef(fxname).stop;
	};
};

~isrest = { arg pat;
	pat.collect { arg x; if(x == 1) { false } { true } }
};

);
