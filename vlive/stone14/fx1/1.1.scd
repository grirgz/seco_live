(
~rabbit = ~name;
~name.debug("name xxxxxxxxxxxxxxxxxxxxxxx");
Veco.main.project_name.debug("proj");
Ndef(~rabbit+++\fx).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = InFeedback.ar(BusDef(\outfx1, \audio), 2);
	sig;
}).play;
);


// END

(
8.do { arg x;
	~set_out_bus.(Veco.main.get_node_by_index(x).uname, BusDef(\outfx1, \audio))
}
)
