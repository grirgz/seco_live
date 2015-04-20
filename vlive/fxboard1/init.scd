Veco.load_lib("main.scd");
//Veco.load_lib("synth.scd");

Veco.main.board_size = Point(8,64);
//~set_default_quant.(4);
//~set_project_tempo.(1);
~load_standard_quickpad.();



// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;


//// save all presets

(
~get_params = {
	var list = List.new;
	7.do { arg x;
		var node;
		node = Veco.main.get_node_by_index(x);
		list = list ++ node.lib.macros;
	};
	list = list.reject({ arg x; x.isNil});
	list;
}
)

~get_params.().do(_.postln);
ParamGroupDef(\yep, ~get_params.())
ParamGroupDef(\yep).edit
ParamGroupDef(\yep).group
ParamGroupDef(\yep).save(\p1)
ParamGroupDef(\yep).load(\p1)
ParamGroupDef(\yep).save(\p2)

ParamGroupDef(\yep).load(\p2)
~pm = ParamMorpher(\yep, [\p1, \p2])
~pm.edit
