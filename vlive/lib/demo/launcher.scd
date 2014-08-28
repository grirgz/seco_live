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

//Veco.main.get_node_by_index(15).get_clip_by_index(0).response_on

(
		~set_exec_zone.(Rect(0,32, 32+16,64));
		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(8,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(16,Veco.main.clip_offset.y)},
				{Veco.main.clip_offset = Point(24,Veco.main.clip_offset.y)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				{ev.no_pane},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
);

(
	~load_standard_launchers = {

		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,0)},
				{Veco.main.clip_offset = Point(8,0)},
				{Veco.main.clip_offset = Point(16,0)},
				{Veco.main.clip_offset = Point(24,0)},

				{Veco.main.clip_offset = Point(0,8)},
				{Veco.main.clip_offset = Point(8,8)},
				{Veco.main.clip_offset = Point(16,8)},
				{Veco.main.clip_offset = Point(24,8)},

				//{Veco.main.clip_offset = Point(0,0)},
				//{Veco.main.clip_offset = Point(8,0)},
				//{ev.no_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,32)},
				//{ev.mid_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,0)},

				//{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				//{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				//{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				//{ev.no_pane},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
	};
);
