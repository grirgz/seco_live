
~set_next_clip.(4*3, [2,1].choose.debug("hHEHEHEHEH---"));

// END

~set_next_clip.(4*3, 1);

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
