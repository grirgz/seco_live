
~toggle_trig.(~name,{
	(0..2).do { arg x; 
		var node = Veco.main.get_node_by_index(x);
		var bus = BusDef(~masterfx+++\fx).index; 
		bus = 0;
		node[\master_bus] = bus;
		Ndef(node.uname+++\mixer).play(bus);
	};
	}, {

	(0..2).do { arg x; 
		var node = Veco.main.get_node_by_index(x);
		var bus = BusDef(~masterfx+++\fx).index; 
		//bus = 0;
		node[\master_bus] = bus;
		Ndef(node.uname+++\mixer).play(bus);
	}
})

// END

(
(0..2).do { arg x; 
	var node = Veco.main.get_node_by_index(x);
	var bus = BusDef(~masterfx+++\fx).index; 
	bus = 0;
	node[\master_bus] = bus;
	Ndef(node.uname+++\mixer).play(bus);
}
)
