
TempoClock.default.tempo = 1;
Pdef.defaultQuant = 1;
Veco.main.board_size = Point(16,64);
Veco.load_lib("main.scd");

(
~load_standard_quickpad.();
);

//Veco(\1).execute;
Veco.load_file("synthpool.scd");
