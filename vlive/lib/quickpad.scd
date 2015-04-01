
////////////////////////////////////////////////////  quickpad

(

~load_quick_quant_chooser = { arg quants;
	var codepad;
	var qp = ~veco.quickpad_controller;
	quants = quants ?? [1/8,1/4,1/2,1,  2,4,8,16];
	quants.do { arg quant, y;
		codepad = qp.get_codepad(Point(0,y));
		codepad.payload = { arg self;
			quant.debug("setting Pdef.defaultQuant to");
			~set_default_quant.(quant);
			//Pdef.defaultQuant = quant;
			//Ndef(\defaultQuant).proxyspace.quant = quant;
		};
	}
};

~load_quick_editors = { arg self;
	var codepad;
	var qp = Veco.main.quickpad_controller;
	codepad = qp.get_codepad(Point(1,0));
	codepad.payload = { arg self;
		{
			~namex.debug("edit namex");
			Sdef(~namex, \mypreset).edit;
		}.defer;
	};

	//codepad = qp.get_codepad(Point(1,1));
	//codepad.payload = { arg self;
	//	//{
	//		//~load_fx_matrix_editor.();
	//	~matrix_view.skip_first_time = true;
	//	~matrix_view.activate_display(~matrix_ctrl);
	//	//}.defer(1);
	//};

	codepad = qp.get_codepad(Point(1,2));
	codepad.payload = { arg self;
		var name = ~name;
		{
			Ndef(name+++\fx).edit;
		}.defer;
	};

	codepad = qp.get_codepad(Point(1,3));
	codepad.payload = { arg self;
		var name = ~name;
		{
			Ndef(name+++\mixer).edit;
		}.defer;
	};

	///////////////// column 3

	// sendpad

	// in
	codepad = qp.get_codepad(Point(2,0));
	codepad.payload = { arg self;
		//~scene_sendpad.skip_first_time = true;
		~scene_sendpad = ~launchpad_scene_sendpad.new(Veco.main);
		~scene_sendpad.set_model(~veco_sendpad, \in);
		~scene_sendpad.activate;
	};

	// send
	codepad = qp.get_codepad(Point(2,1));
	codepad.payload = { arg self;
		~scene_sendpad = ~launchpad_scene_sendpad.new(Veco.main);
		~scene_sendpad.skip_first_time = true;
		~scene_sendpad.set_model(~veco_sendpad, \send);
		~scene_sendpad.activate;
	};

};

~load_quick_mode_chooser = { arg self;
	var codepad;
	var qp = Veco.main.quickpad_controller;
	codepad = qp.get_codepad(Point(7,0));
	codepad.payload = { arg self;
		//{
			if(Veco.main.clip_response_mode == \toggle) {
				Veco.main.clip_response_mode = \play;
				debug("mode: set Clip response mode = play");
			} {
				Veco.main.clip_response_mode = \toggle;
				debug("mode: set Clip response mode = toggle");
			}
		//}.defer;
	};
	codepad = qp.get_codepad(Point(7,1));
	codepad.payload = { arg self;
		//{
			if(Veco.main.clip[\response_launcher_on_hook].isNil) {
				~load_standard_launchers.();
				debug("mode: set Clip launcher mode = select page");
			} {
				Veco.main.clip[\response_launcher_on_hook] = nil;
				debug("mode: set Clip launcher mode = launch row");
			}
		//}.defer;
	};
	codepad = qp.get_codepad(Point(7,2));
	codepad.payload = { arg self;
		//{
			if(Veco.main.pane_target_project.notNil) {
				Veco.activate_side_project(Veco.main.pane_target_project[\veco].project_path);
				debug("mode: activate side project");
			} {
				Veco.activate_project_by_env(Veco.previous_activated_project);
				debug("mode: return to previous project");
			}
		//}.defer;
	};
	
};

~load_quick_project_switcher_OLD = {
	var codepad;
	var qp = ~veco.quickpad_controller;
	codepad = qp.get_codepad(Point(2,0));
	codepad.payload = { arg self;
		"loadprojectA".debug;
		if(~quick_project_a.notNil and: { ~last_loaded_quick_project != ~quick_project_a }) {
			~last_loaded_quick_project = ~quick_project_a;
			Veco.main.open_project_in_vim(~quick_project_a);
		};
	};
	codepad = qp.get_codepad(Point(2,1));
	codepad.payload = { arg self;
		"loadprojectB".debug;
		if(~quick_project_b.notNil and: { ~last_loaded_quick_project != ~quick_project_b }) {
			~last_loaded_quick_project = ~quick_project_b;
			Veco.main.open_project_in_vim(~quick_project_b);
		};
	};

};

~load_quick_project_switcher = {
	var codepad;
	var qp = ~veco.quickpad_controller;
	8.do { arg slot;
		codepad = qp.get_codepad(Point(6,slot));
		codepad.payload = { arg self;
			slot.debug("switch_project_slot ============================= ------------------ =========================");
			Veco.switch_project_slot(slot);
		};
	}
};


~load_standard_quickpad = { arg self;
	~load_standard_launchers.();
	~load_quick_quant_chooser.();
	~load_quick_editors.();
	~load_quick_project_switcher.();
	~load_quick_mode_chooser.();
};

);
