Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1);
~load_standard_quickpad.();

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

Veco.main.clip[\response_launcher_on_hook] = nil
Veco.main.clip[\response_launcher_on_hook] 
~launchers_manager.init

				~load_standard_launchers.asCompileString
