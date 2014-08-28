
(

	~launcher_lib = (
				no_pane: { arg self;
					debug("no_pane!");
					Veco.main.pane_rect = Rect(100,100,100,100);
				},
				mid_pane: { arg self;
					debug("mid_pane!");
					Veco.main.pane_rect = Rect(0,4,8,8);
				},
			);


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
	~load_launchers_relative_xjump = {

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

				{Veco.main.clip_offset = Point(0,8)},
				{Veco.main.clip_offset = Point(8,8)},
				{Veco.main.clip_offset = Point(16,8)},
				{Veco.main.clip_offset = Point(24,8)},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
	};
);
