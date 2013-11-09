TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_quick_quant_chooser.();
~load_quick_editors.();
//Veco(\1).execute;
Veco.load_file("synthpool.scd");

~fx1 = BusDef('37fx', \audio, 2);
~fx2 = BusDef('38fx', \audio, 2);
~fx3 = BusDef('39fx', \audio, 2);
~fx4 = BusDef('fx4', \audio, 2);
"et l'init alors bordel".debug;


~mixfx = { arg name, fx;
	~name.debug("mixfx: name");
	~newfx.(\fx);
	Ndef(name+++\fx).isource = { arg send=0.2;
		var in = InFeedback.ar(BusDef(name+++\fx), 2);
		var sig;
		sig = in;
		Out.ar(fx, sig * send);
		sig;
	};
};

~set_dels = { arg array;
	var dels;
	//array = [0,1,0,1, 0,1,1,0];
	dels = array.collect { arg x, i; i = i + 1; [\del+++i, x] };
	dels = dels.flat;
	Ndef(~name+++\fx).set(*dels);
};


//~make_mixer = {
//	var name = ~name;
//	BusDef(name+++\mixer, \audio, 2);
//	Veco(~name).add_play_node_hook(\sender, { Ndef(name+++\sender).play });
//	Veco(~name).add_stop_node_hook(\sender, { Ndef(name+++\sender).stop });
//	Ndef(name+++\mixer).isource = { arg send1=0, send2=0, send3=0, send4=0;
//		var in = InFeedback.ar(BusDef(name+++\mixer), 2);
//		var sig;
//		sig = in;
//		Out.ar(~fx1, sig * send);
//		Out.ar(~fx2, sig * send);
//		Out.ar(~fx3, sig * send);
//		Out.ar(~fx4, sig * send);
//		sig;
//	};
//
//};
//
//~get_mixer = {
//	Pbind(
//		\out, BusDef(~name+++\mixer);
//	) <> Veco(~name).mixer
//};



// END

Veco.main.fadeout_time = 16;

Pdef.defaultQuant = 1;
