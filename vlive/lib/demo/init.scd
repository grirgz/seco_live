
TempoClock.default.tempo = t = 160/60*0.5;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.exec_file("trigpad.scd");
~load_standard_quickpad.();

~swing = (1 + (0.19 * Pseq([-1,1],inf)));
~swingamp = 0.37;
~swingspin = [1,0,-1, 0];
~swingspin = [0,0,0, 0];
~swing1 = Pn(Plazy({(1 + (~swingamp * Pseq(~swingspin,1)));}));


[\1,\2,\3].do { arg name; ~set_out_bus.(name, ~fx1) };


Veco.main[\in_stop_exclusion_range] = { arg x; x.inclusivelyBetween(55,64) };


~masterfx = '56';
Veco.main.master_bus = BusDef(~masterfx+++\fx, \audio).index;

Veco.exec_file("masterfx.scd");

// new fx way
~define_effects.(['56','57','58','59']);


// old fx way

~tfx1 = '56';
~tfx2 = '37';
~tfx3 = '38';
~tfx4 = '39';
~fx1 = BusDef(~tfx1+++'fx', \audio, 2);
~fx2 = BusDef(~tfx2+++'fx', \audio, 2);
~fx3 = BusDef(~tfx3+++'fx', \audio, 2);
~fx4 = BusDef(~tfx4+++'fx', \audio, 2);
