
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1);
~load_standard_quickpad.();

// END

Veco.main.fadeout_time = 16;


~pg = ParamGroup( ( Ndef('alpha1-1fx').asParamGroup ++ Veco('3').lib.macros ).reject(_.isNil) )
Veco('1').lib.macros
~midi_macro_manager
(

	~mac1 = Ndef('alpha1-1fx').asParamGroup.reject({arg x;x.property == \adsr}).do(_.postln);
	~pg = ParamGroup(~mac1 ++ Veco('3').lib.macros.reject(_.isNil))

)
Ndef('alpha1-1fx').sources
~pg.edit
Spec.add(\adsr, XEnvSpec.adsr)
Ndef('alpha1-1fx').unset(\adsr)

~pg.save(\p1)
~pg.save(\p2)

~pm = ParamMorpher(~pg, [\p1, \p2])
MIDIMap(\c1, { MIDIMap(\s1, ~pm) })

