

(
	~load_quickpad = { arg name;
		var codepad;
		codepad = ~veco.quickpad_controller.get_codepad(Point(0,0));
		codepad.payload = { arg self;
			"my quickpad !!!!!! plop!!!!!!!".debug;
		};

	};
	~load_quickpad.();
)
