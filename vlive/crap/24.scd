	

     
     
     
    ~makePattern0 = {|e|
             Ppar(e.collect({|c, r| Pbind(
                \instrument, ~synthdef_list2[r],
                \freq, Pif(Pseq(e[r], inf).coin, 100+(e.size-100*r), \rest),
                \dur, 0.25
                                    )}), inf);
    };
     
    ~makePattern1 = {|e|
             Ppar(e.collect({|c, r| Pbind(
                \instrument, ~synthdef_list2[r],
                \freq, Pif(Pseq(e[r], inf).coin, 100+(e.size-100*r), \rest),
                \dur, 0.25
                                    )}), inf);
    };
     
     
        ~synthdef_list = [\kick, \snare, \hats, \peep];
        w = Window("sequencer", Rect(0, 0, 400, 200)).front;
        a = 0 ! 16 ! ~synthdef_list.size;
        a.do{ |rows, i|
                rows.do{ |cell, j|
                        Button(w, Rect(j*25, i*25, 25, 25))
                        .states_([
                                ["-", Color.black, Color.white],
                                ["O", Color.white, Color.black],
                        ])
                        .action_{ |v|
             
                            ~makePattern1.value(a[rows,cell]);
                    };
            };
     
    };
     
     ~synthdef_list2 = [\kick, \snare, \hats, \peep];
        z = Window("sequencer", Rect(0, 0, 400, 200)).front;
        e = 0 ! 16 ! ~synthdef_list2.size;
        e.do{ |rows, i|
                rows.do{ |cell, j|
                        Button(z, Rect(j*25, i*25, 25, 25))
                        .states_([
                                ["-", Color.black, Color.white],
                                ["O", Color.white, Color.black],
                        ])
                        .action_{ |v|
                                e[i][j] = v.value;
                            ~makePattern2.value(e[rows,cell]);
                   
            };
                    };
                };
     
        v = Window("sequencer", Rect(0, 0, 400, 200)).front;
        b= 0 ! 4 ! 4;
        b.do{ |rows, i|
                rows.do{ |cell, j|
                        Button(v, Rect(j*25, i*25, 25, 25))
                        .states_([
                                ["-", Color.black, Color.white],
                                ["O", Color.white, Color.black],
                        ])
                        .action_{ |v|
                              b[i][j] = v.value;
                            ~maketrack.value(b[0].sum);
     
                                    if (b[0].at(0) == 1){
                                            Pseq([g,h]).play;
                                                   
                                 };
                        if (b[0].at(1) == 1){
                           
                                    };
     
                                    if (b[0].at(0) == 0){
                                   
                                    };
                                if (b[0].at(1) == 0){
                           
                                    };
                        };
                };
                    };




Pspawn({ arg ps;

	ps.seq(pat)

})






~pat1.play

Pdef(\plop).clear
(

~pat1 = Pbind(\dur, 1/4, \degree, Pseq([0,2,4,2],1));
~pat2 = Pbind(\dur, 1/4, \degree, Pseq([0,2,4,2]+2,1));
~pat3 = Pbind(\dur, 1/4, \degree, Pseq([0,2,4,2]+4,1));
~pat4 = Pbind(\dur, 1/4, \degree, Pseq([0,2,4,2]+6,1));
~plist = [~pat1, ~pat2, ~pat3, ~pat4];

	Pdef(\plop, Pseq([Event.silent],inf)).play;

	w = Window("sequencer", Rect(0, 0, 400, 200)).front;
	~butlist = List.new;
	~layout = HLayout.new;
	~plist.do{ |cell, j|
		var but = Button.new;
		~layout.add(but);
		w.view.layout = ~layout;
		~butlist.add(but);
			but.states_([
				["-", Color.black, Color.white],
				["O", Color.white, Color.black],
			])
			.action_{ |v|
				var list;
				list = List.new;
				~butlist.do({ arg but, idx; 
					if(but.value == 1) {
						list.add(~plist[idx])
					} 
				});
				if(list.size == 0) {
					list = [Event.silent];
				};
				Pdef(\plop, Pseq( list ,inf))
			};

	};
	Pdef(\plop).play
)
