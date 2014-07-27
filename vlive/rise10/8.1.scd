
"WTFFFFFFF!!!!".debug;
~set_next_clip.(4*3, [2,1].choose.debug("hHEHEHEHEH---"));
"WTFFFFNENDc:wFFF!!!!".debug;

// END

~set_next_clip.(4*3, 1);
Tdef(~name).isPlaying
Tdef(~name).defaultQuant

~set_next_clip.(4*3, [2,1].choose.debug("hHEHEHEHEH---"));

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

(
~set_next_clip = { arg time, index;
	if(~enable_clip_automation != false) {
		Veco.do { arg name, namex;
			Tdef(name, {
				Veco.main.clip.update_display;
				namex.debug("======================= init task1");
				(time-0.5).wait;
				//(Pdef.defaultQuant/2).wait;
				[namex, index].debug("======================== play next row!!!");
				~spawn_cliprow.(index, name);
				0.wait; // to avoid bug
			});
		}
	}
};

~tdef_channel = { arg suffix=\fx;
	var name = ~name;
	var fxname = ~name +++ suffix;
	Veco(~name).make_mixer;
	Veco(~name).add_play_node_hook(\fx, {
		Tdef(name).play;
	});

	Veco(~name)[\is_playing] = { arg self;
		Tdef(name).isPlaying;
	};

	Veco(~name).add_stop_node_hook(\fx, {
		Tdef(name).stop;
	});
	
};
)
