
TempoClock.default.tempo = t = 1;
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~quick_project_a = "cirk1";
~quick_project_b = "v14b";
~load_standard_quickpad.();
//Veco(\1).execute;
Veco.load_file("synthpool.scd");

~get_mixer_group = {
	
	if(~mixer_group.isPlaying.not) {
		~mixer_group = Group.after;
		~mixer_group.register(true);
		~mixer_group.isPlaying;
	};
	~mixer_group;
};

~wobblefx = '1fx';
~twobble = '1';
~tfx1 = '1';
~tfx2 = '37';
~tfx3 = '38';
~tfx4 = '39';
~fx1 = BusDef(~tfx1+++'fx', \audio, 2);
~fx2 = BusDef(~tfx2+++'fx', \audio, 2);
~fx3 = BusDef(~tfx3+++'fx', \audio, 2);
~fx4 = BusDef(~tfx4+++'fx', \audio, 2);
"et l'init alors bordel".debug;


//~mixfx = { arg name, fx;
//	~name.debug("mixfx: name");
//	~newfx.(\fx);
//	Ndef(name+++\fx).isource = { arg send=0.2;
//		var in = InFeedback.ar(BusDef(name+++\fx), 2);
//		var sig;
//		sig = in;
//		Out.ar(fx, sig * send);
//		sig;
//	};
//};

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

~f = { arg pat;

	Prout({
		var str = pat.asStream;
		var ev = str.next(Event.default);
		
	});

}

Veco.main.fadeout_time = 16;

Pdef.defaultQuant = 1;
