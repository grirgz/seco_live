TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.exec_file("trigpad.scd");
~load_standard_quickpad.();

Veco.main[\in_stop_execution_range] = { arg x; x.inclusivelyBetween(55,64) };


~masterfx = '56';
Veco.main.master_bus = BusDef(~masterfx+++\fx, \audio).index;

Veco.exec_file("masterfx.scd");

// END

Veco.main.fadeout_time = 16;
Veco.main.master_bus.index
Veco.main.master_bus = 0;
(0..2).do { arg x; Veco.main.get_node_by_index(x)[\master_bus] = 0 }
(
(0..2).do { arg x; 
	var node = Veco.main.get_node_by_index(x);
	var bus = BusDef(~masterfx+++\fx).index; 
	bus = 0;
	node[\master_bus] = bus;
	Ndef(node.uname+++\mixer).play(bus);
}
)
(
(0..2).do { arg x; 
	var node = Veco.main.get_node_by_index(x);
	var bus = BusDef(~masterfx+++\fx).index; 
	bus = 0;
	node[\master_bus] = bus;
	Ndef(node.uname+++\mixer).play(bus);
}
)
