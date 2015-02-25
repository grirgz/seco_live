	

    (
    MIDIIn.connectAll;
     
    ~default= [ 0,0,1,1,0.01, (-pi),1,1,0.1,1,0.3,0.1,0.01,1,2,0.01,0.005,0.2,1,100,30,20,(-4),(-2),(-4)];
     
    ~spec1 = [ControlSpec(0,3,\lin,0,1),ControlSpec(0,3,\lin,0,1),ControlSpec(0.01,3,\lin,0.01,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,3,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1)];
    ~spec2 = [ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1)];
    ~spec3 = [ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0,1),ControlSpec(0,1,\lin,0.01,1),ControlSpec(20,120,\lin,0,1),ControlSpec(20,120,\exp,0,1),ControlSpec(20,120,\lin,0,1),ControlSpec(-4,4,\lin,0,1),ControlSpec(-4,4,\lin,0,1),ControlSpec(-4,4,\lin,0,1)];
     
    ~spec = [~spec1,~spec2,~spec3];
    ~names = [
            "ochoose","owhich2","fratio","noise","oamp","p1", "dc","amp",
            "aamp1","aamp2","aamp3","aamp4","famp1","famp2","famp3","famp4",
            "atk","decay","release","freq1","freq2","freq3","curve1","curve2","curve3"
    ];
     
    ~slider = [~slider1,~slider2,~slider3];
    ~sliders1 = [~slider4,~slider5,~slider6];
    ~sliders2 = [~slider7,~slider9,~slider9];
    ~windowname =[~snarewindow,~kickwindow,~hatswindow];
	~makewindow = {arg name,r,g,b,names,spec,slider,a;
		if(currentEnvironment[a].isNil){
			{~makegui.(name,r,g,b,names,spec,slider,a)}.defer;
		}{
			"lf".postln;
			currentEnvironment[a].close;
			{~makegui.(name,r,g,b,names,spec,slider,a)}.defer;
		};
	};
     
     
     
	~makegui = {arg x,red,green,blue,labels,specs,sliders,a;
		var name=x;
		var windowname= currentEnvironment[a];
		var slider = sliders;
		windowname = Window(name, Rect(0, 0, 500, 500)).front;
		windowname.view.decorator=FlowLayout(windowname.view.bounds);
		windowname.view.decorator.gap=2@2;
		windowname.view.background = Color(red,green,blue);
		slider[0] = Array.fill(8,{arg i;
			//currentEnvironment[(\knob1++i).asSymbol] =
			EZKnob(windowname, 50@100,labels[i], specs[0][i],
			0.01,initVal:1, labelWidth:60,layout: \vert)
			.setColors(Color.grey,Color.white)
			.font_(Font("Helvetica",15))
		});

		windowname.view.decorator.nextLine;




		slider[1] = Array.fill(8,{arg i;
			//currentEnvironment[(\knob2++i).asSymbol] =
			EZKnob(windowname, 50@100,labels[8+i], specs[1][i],
			initVal: 0, labelWidth:60,layout: \vert)
			.setColors(Color.grey,Color.white)
			.font_(Font("Helvetica",15));
		});

		windowname.view.decorator.nextLine;

		slider[2] = Array.fill(9,{arg i;
			//currentEnvironment[(\knob3++i).asSymbol] =
			EZSlider(windowname, 50@250,labels[16+i], specs[2][i],
			unitWidth:0.1,initVal:1, numberWidth:60,layout:\vert)
			.setColors(Color.grey,Color.white)
			.font_(Font("Helvetica",15));
		});
		currentEnvironment[a]=windowname;

	};
     
	~makecontroller = {arg name,cc,co,names,spec,slider,windowname;

		~boo =0;

		MIDIdef.cc(name, {arg val,num,chan,id; //
			case{~boo == 0}{
				//val.postln;
				Pdefn(\snares,Pn(\a,inf));
				{~makewindow.((name++1).asSymbol,0.1+co,0.5+co,0.5+co,names,spec,slider,windowname)}.defer;
				~boo =1;
			}
			{~boo == 1}
			{
				Pdefn(\snares,Pn(\a1,inf));
				{~makewindow.((name++2).asSymbol,0.1+co,0.1+co,0.2+co,names,spec,slider,windowname)}.defer;
				~boo =2;
			}
			{~boo == 2}
			{
				{~makewindow.((name++3).asSymbol,0.6+co,0.7+co,0.7+co,names,spec,slider,windowname)}.defer;
				~boo = 3;
			}
			{~boo == 3}
			{
				{~makewindow.((name++4).asSymbol,0.8+co,0.1+co,0+co,names,spec,slider,windowname)}.defer;
				~boo = 0;
			};
			~choice = cc-120;

			~choice.value.postln;
		},cc);//
	};
)
     ~makecontroller.("snare",120,0.3,~names,~spec,~slider,~w)
    ~makecontroller.("kick",121,0,~names,~spec,~sliders1,~w1 )
    ~makecontroller.("hats",122,0.1,~names,~spec,~sliders2,~w2 )
     
    ~makecontrols.(~slider,~sliders1,~sliders2);
    (
     
    ~slidercc = (11..35);
    ~min = [0,0,0,20,20,20,-8,-8,-8];
    ~max = [1,1,1,120,120,120,8,8,8];
    ~max1 = [3,3,3,1,1,1,1,1];
     
    ~makecontrols = {arg slider,slider1,slider2;
     
            8.do{arg r;
                    MIDIdef.cc(\line1++r, {arg val,num,chan,id;
                            case{~choice == 0 }{
                                    {slider[0][r].value = (val.linlin(0, 127, 0, ~max1[r]))}.defer;
                                    slider[0][r].value.postln;}
                            {~choice == 1}{
                                    {slider1[0][r].value = (val.linlin(0, 127, 0, ~max1[r]))}.defer;
                                    slider1[0][r].value.postln;}
                            {~choice == 2}{
                                    {slider2[0][r].value = (val.linlin(0, 127, 0, ~max1[r]))}.defer;
                                    slider2[0][r].value.postln;}
                            {~choice == 3}{}
     
     
                    },~slidercc[r+17]);
            };
     
            8.do{arg r;
                    MIDIdef.cc(\line2++r, {arg val,num,chan,id;
                            case{~choice == 0 }{
                                    {slider[1][r].value = (val.linlin(0, 127, 0, 1))}.defer;
                                    slider[1][r].value.postln;}
                            {~choice == 1}{
                                    {slider1[1][r].value = (val.linlin(0, 127, 0, 1))}.defer;
                                    slider1[1][r].value.postln;}
                            {~choice == 2}{
                                    {slider2[1][r].value = (val.linlin(0, 127, 0, 1))}.defer;
                                    slider2[1][r].value.postln;}
                            {~choice == 3}{}
                    },~slidercc[r+9]);
            };
     
            9.do{arg r;
                    MIDIdef.cc(\line3++r, {arg val,num,chan,id;
                            case{~choice == 0 }{
                                    {slider[2].value = (val.linlin(0, 127, ~min[r], ~max[r]))}.defer;
                                    slider[2].value.postln;}
                            {~choice == 1}{
                                    {slider1[2].value = (val.linlin(0, 127, ~min[r], ~max[r]))}.defer;
                                    slider1[2].value.postln;}
                            {~choice == 2}{
                                    {slider2[2].value = (val.linlin(0, 127, ~min[r], ~max[r]))}.defer;
                                    slider2[2].value.postln;}
                            {~choice == 3}{}
                    },~slidercc[r]);
            };
    }
    )
    s.plotTree;
    s.meter;
    MIDIdef.freeAll
    ~makewindow.("drum1",0,0.3,0.5,1,1,1,\a);


	(
	~makewindow = {arg name,r,g,b,names,spec,slider,a;
		if(currentEnvironment[a].isNil){
			currentEnvironment[a] = Window.new.front;
		}{
			"lf".postln;
			currentEnvironment[a].close;
			currentEnvironment[a] = Window.new.front;
		};
	};
	)





















	~makewindow.("drum1",0,0.3,0.5,1,1,1,\a);


	(
		~makewindow = {arg name,r,g,b,names,spec,slider,a;
			if(currentEnvironment[a].isNil){
				~makegui.(a)

			}{
				"lf".postln;
				currentEnvironment[a].close;
				~makegui.(a)
			};
		};


		~makegui = { arg a;
			currentEnvironment[a] = Window.new.front;
		};
	)




currentEnvironment[\slider] = [~slider1,~slider2,~slider3];
~sliders1 = [~slider4,~slider5,~slider6];
~sliders2 = [~slider7,~slider8,~slider9];
~windowname =[~snarewindow,~kickwindow,~hatswindow];
~makewindow = {arg name,r,g,b,names,spec,slider,a,pos;
        if(currentEnvironment[a].isNil){
 
 
                {~makegui.(name,r,g,b,names,spec,slider,a,pos)}.defer;
        }{
 
                        ~savepreset.(1,currentEnvironment[\slider]);
                                currentEnvironment[a].close;
                {~makegui.(name,r,g,b,names,spec,slider,a,pos)}.defer;
 
 
        };
};
