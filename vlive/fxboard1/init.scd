Veco.load_lib("main.scd");
//Veco.load_lib("synth.scd");

Veco.main.board_size = Point(8,64);
//~set_default_quant.(4);
~set_project_tempo.(TempoClock.default.tempo);
~load_standard_quickpad.();


// END
{
	var c1 = Veco('y').uname;
	MIDIMap(\c1, { MIDIMap(\k9, PresetListMorpherDef(c1)) })
}.value;


TempoClock.default.tempo
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
ParamGroupDef(\yep).presets.keys
ParamGroupDef(\yep).loadArchive

ParamGroupDef(\yep).save(\p3)
ParamGroupDef(\yep).load(\p3)

ParamGroupDef(\yep).load(\p2)
~pm = ParamMorpher(\yep, [\p1, \p2])
~pm = ParamMorpher(\yep, [\p1, \p2, \p3])
~pm.edit
MIDIMap(\k9, ~pm)



(
MIDIMap(\c1, {
	MIDIMap(\k1, ParamMorpherDef(Veco.main.project_name.asSymbol+++'-1'));
	MIDIMap(\k2, ParamMorpherDef(Veco.main.project_name.asSymbol+++'-4'));
	MIDIMap(\k3, ParamMorpherDef(Veco.main.project_name.asSymbol+++'-6'));
})
)
ParamMorpherDef(Veco.main.project_name.asSymbol+++'-1')
Veco.main.project_name.asSymbol+++'-1'
Veco.main.project_name.asCompileString
(\dd+++\dd).asCompileString

Archive.write
