
(
	~load_standard_launchers = {

		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			var launch_clip;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			launch_clip = { arg yyy;
				var x, y;
				var clip;
				x = (Veco.main.clip_offset.x / Veco.main.board_size.x).asInteger + Veco.main.board_size.x - 1;
				y = Veco.main.clip_offset.y + yyy;
				[x, y, yyy].debug("launcher!!!");
				clip = Veco.main.get_node_by_index(x).get_clip_by_index(y);
				clip.response_on;
			};
			launch_clip.(pos.y);
			Veco.main.clip.render_state;
		};
	};
);

Veco.exec_file("../init.scd");
