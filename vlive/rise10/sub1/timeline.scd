
(
MIDIBoard.map(\play, { Tdef(\timeline).play; });
MIDIBoard.map(\stop, { 
	Tdef(\timeline).stop; 
	8.do { arg x;
		Veco.main.clip.set_led(Point(8,x), \off);
	}
});
)

(
Tdef(\timeline, {
	var tracks = (0..7);
	var len = 8;
	var offset = 4;
	(offset..len).do { arg x;
		~spawn_cliprow.(x, nil, tracks);
		Veco.main.clip.update_display;
		//Task({
		//	Veco.main.clip.update_display;
		//}).play(quant:Pdef.defaultQuant);
		Veco.main.clip.set_led(Point(8,x), \green);
		Veco.main.clip.set_led(Point(8,(x-1).wrap(0,len-1).debug("Hey")), \off);
		16.wait;
	};
});
)
