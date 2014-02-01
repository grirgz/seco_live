TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_file("proxychain.scd");
~load_standard_quickpad.();

//~tfx1 = '36';
~tfx1 = '34';
~tfx2 = '37';
//~tfx3 = '38';
~tfx3 = '33';
//~tfx4 = '39';
~tfx4 = '32';
~fx1 = BusDef(~tfx1+++'fx', \audio, 2);
~fx2 = BusDef(~tfx2+++'fx', \audio, 2);
~fx3 = BusDef(~tfx3+++'fx', \audio, 2);
~fx4 = BusDef(~tfx4+++'fx', \audio, 2);

// END

Veco.main.fadeout_time = 16;

Veco.load_file("midi.scd");
~fx4
