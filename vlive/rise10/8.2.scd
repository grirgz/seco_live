
"huiiiii".debug;
~set_next_clip.(4, [0,3].choose);
"ENDhuiiiii".debug;

// END

~set_next_clip.(4, 0);

TempoClock.play(Task({
	"task1".debug;
	11.wait;
	"task2".debug;
	~spawn_cliprow.(1);
	nil;
}), Pdef.defaultQuant);
//~spawnclips.([0,1,2,3])
~spawn_cliprow.(0)
Veco('3').get_clip_by_index(1).is_present

Tdef(~name).quant = [Pdef.defaultQuant]
Tdef(~name).quant = [Pdef.defaultQuant]


(
Tdef(\plop).play;
Tdef(\plop, {
	"one".debug;
	4.wait;
	"two".debug;
	nil;
	//1.wait;
})
)

(
	
	~plop = { arg x=0;
		x.debug("GN");
		//Tdef(\plop).play;
		Tdef(\plop, {
			x.debug("one");
			0.4.wait;
			x.debug("two");
			~plop.(x+1);
			nil;
			0.4;
			//1.wait;
		})

	};
)
~plop.()
Tdef(\plop).quant = 10
Tdef(\plop).isPlaying

Pdef.defaultQuant

(
	
	~plop = { arg x=0;
		x.debug("GN");
		Tdef(\plop).play;
		Tdef(\plop, {
			x.debug("one");
			TempoClock.default.beats.debug("beats");
			1.0.wait;
			x.debug("two");
			TempoClock.default.beats.debug("beats");
			~plop.(x+1);
			TempoClock.default.beats.debug("beats");
			0.wait;
		})

	};
)
