	

    //NEXT STEP:
    //Make a mixer on the panel that can mix between the Warped grains and the Normal grains
    //make warped grains listen to midi notes (prob freqscale argument)
    //Make busses more efficient
    s.boot;
    s.meter;
    s.plotTree;
    StageLimiter.activate;
    s.quit;
    s.reboot;
     
    Server.internal.options.inDevice = "Soundflower (2ch)";
    Server.local.options.inDevice = "Soundflower (2ch)";
    Server.internal.options.outDevice = "Soundflower (2ch)";
    Server.local.options.outDevice = "Soundflower (2ch)";
    Server.internal.options.outDevice = "MOTU 828mk3 Hybrid";
    Server.local.options.outDevice = "MOTU 828mk3 Hybrid";
    Server.internal.options.outDevice = "JackRouter";
    Server.local.options.outDevice = "JackRouter";
     
    //JORS AMAZING MIDI CC AWESOME BUFFER SYNTH
     
    //To load multiple samples use an array and iteration, this loads a whole folder
    //Stereo Buffer
     
    ~jorSamples = Array.fill(133,0);
    (
    ~jorSamples = Array.newClear(133);
    ~folder = PathName.new("/Volumes/Samples/Producing/Logic/Creative Files/Jorgalad Sounds/Ambient Sounds/");
     
    ~jorSamples = ~folder.entries.collect({
            arg path;
            Buffer.read(s, path.fullPath);
    });
     
    )
     
    s.boot;
    //Create Control Busses
     
    (
    //StageLimiter.activate;
     
    b = Bus.control(s); b.set(1); //Sample
    c = Bus.control(s); c.set(0); //FreqShift
    d = Bus.control(s); d.set(1); //Slider Rate (also controlled by MIDI notes)
    e = Bus.control(s); e.set(0); //Reverb Mix
    f = Bus.control(s);
    g = Bus.control(s); g.set(2000); //For Multislider (Filter cutoff)
    h = Bus.control(s); h.set(80); //BPM
     
     
    //MASTER SYNTH
    //WHERE EVERYTHING COMES TOGETHER
     
    SynthDef(\source, {
            arg bpm, amp=4, gate=0, rate=0.01, bufnum=~jorSamples[1],
            freqshift, sliderrate, reverb, cutoff = 2000, out;
     
            var impulsetrigger, env, sig;
     
            impulsetrigger = Impulse.ar(bpm/60);
     
            env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.5, 1, 1), gate,doneAction:2);
     
            sig = BufRd.ar(2, bufnum, Phasor.ar(impulsetrigger, BufRateScale.kr(bufnum) + rate + sliderrate, 0, BufFrames.kr(bufnum)));
     
            sig = FreqShift.ar(sig, freqshift ,0, 0.5);
     
            sig = FreeVerb.ar(sig, reverb, 0.8, 0.1);
     
            sig = LPF.ar(sig, cutoff);
     
            sig = Pan2.ar(sig, SinOsc.kr(2, 0, 0.2));
     
            Out.ar(out, sig * amp * env * 1);
     
    }).add;
     
    //EffectSynthDef, only for effects and stuff
     
    SynthDef(\effects, {
            arg amp=1, bpm, duration =1, graintrigger=60, in;
     
            var impulsetrigger, sig;
     
            impulsetrigger = Impulse.ar(bpm/60);
     
            sig = In.ar(in, 2);
     
            sig = GrainIn.ar(2, impulsetrigger, duration, sig);
     
            Out.ar([0,1], sig * amp);
     
    }).add;
    )
     
     
     
     
    (
     
    ~sourceGrp = Group.new;
    ~fxGrp = Group.after(~sourceGrp);
     
     
    ~fxBus = Bus.audio(s, 2);
     
     
    Synth(\source, [
            \amp, 3,
            \gate, 1,
            \bpm, h.asMap,
            \freqshift, c.asMap,
            \reverb, e.asMap,
            \bufnum, b.asMap,
            \cutoff, 20000,
            \rate, d.asMap,
            \out, ~fxBus;
     
    ],
    ~sourceGrp,
    \addToHead
     
    );
     
     
    Synth(\effects,
            [
            \amp, 1,
            \bpm, h.asMap,
            \in, ~fxBus,
            \duration, 1;
     
    ],
    ~fxGrp,
    \addToTail);
    )
     
    ~fxGrp.set(\graintrigger, );
     
    //MIDI
    /*
    (
    MIDIClient.init;
    MIDIIn.connectAll;
     
    ~notes = Array.newClear(128);
    MIDIdef.noteOn(\noteOn, {
            arg vel, nn, chan, src;
            [vel, nn].postln;
            ~notes[nn] = Synth.new(
                    \source,
                    [
                            \amp, vel.linexp(1,127, 0.5, 2.0),
                            \gate, 1,
                            \rate, [(nn.midiratio/12) ].postln,
                            \bpm, a.asMap,
                            \bufnum, b.asMap,
                            \freqshift, c.asMap,
                            \sliderrate, d.asMap,
                            \reverb, e.asMap,
                            \cutoff, g.asMap;
                    ]
            )
    }).permanent_(true);
     
    MIDIdef.noteOff(\noteOffTest, {
            arg vel, nn;
            [vel, nn].postln;
            ~notes[nn].set(\gate, 0);
            ~notes[nn] = nil;
    }).permanent_(true);
     
    )
    */
     
    //GUI------------------
     
     
    //SYNTH CONTROLLER
     
    Window.closeAll;
     
    (
    var name, a, server;
    w = Window("Jor Synth", Rect(750, 50, 800, 250))
    .front
    .alwaysOnTop_(true);
     
     
    //Start/Stop synth
     
    ~button1 = Button(w, Rect(740,10,50,30))
    .states_([
            ["Off", Color.black, Color.gray(0.8)],
            ["On", Color.white, Color(0.2,0.75,0.95)]
     
    ])
    .action_({
            arg obj;
            if(obj.value == 1,
                    {
                            x = Synth(
                                    \source,
                                    [
                                            \amp, 3,
                                            \gate, 1,
                                            \t_trig, 0,
                                            \bpm, a.asMap,
                                            \freqshift, c.asMap,
                                            \reverb, e.asMap,
                                            \bufnum, b.asMap,
                                            \cutoff, 20000,
                                            \rate, d.asMap;
     
                                    ]
                                    );
                    },
                    {x.free}
            );
    });
     
    //Other Controls
     
    ~multiSlider = MultiSliderView(w, Rect(300, 20, 350, 100))
    .value_(Array.fill(50/6, {0.01}))
    .background_(Color(0.17, 0.2, 0.08))
    .fillColor_(Color(0.2, 0.12, 0.87))
    .isFilled_(true)
    .indexThumbSize_(10.0)
    .gap_(12)
    .action_({
            arg mslider1;
            var cutoff;
            cutoff = mslider1.value.linlin(0, 1, 20, 2000).postln;
            g.set(cutoff)
    });
     
    StaticText(w, Rect(700, 33, 100, 30)).string_("bpm");
    ~numberBox = NumberBox(w, Rect(700, 10, 30, 30))
    .clipLo_(20)
    .clipHi_(800)
    .action_({
            arg nbox1;
            var bpm;
            bpm = nbox1.value().postln;
            h.set(bpm);
    });
     
    StaticText(w, Rect(180, 20, 150, 30)).string_("Select Sample");
    ~slider = Slider(w, Rect(20, 20, 150, 30))
    .background_(Color(0.2, 0.75, 0.95))
    .action_({
            arg slider1;
            var sample;
            sample = slider1.value.linexp(0,1, 1, 133).round.postln;
            b.set(sample);
    });
     
     
     
    StaticText(w, Rect(180, 60, 150, 30)).string_("FreqShift");
    ~slider2 = Slider(w, Rect(20, 60, 150, 30))
    .background_(Color(0.3, 0.75, 0.1))
    .action_({
            arg slider2;
            var freqshift;
            freqshift = slider2.value.linexp(0,1,0.01, 4000).postln;
            c.set(freqshift);
    });
     
    StaticText(w, Rect(180, 100, 150, 30)).string_("Pitch");
    ~slider3 = Slider(w, Rect(20, 100, 150, 30))
    .background_(Color(0.1, 0.5, 0.9))
    .action_({
            arg slider3;
            var sliderrate;
            sliderrate = slider3.value.linlin(0,1,-2, 2).postln;
            d.set(sliderrate);
    });
     
    StaticText(w, Rect(180, 140, 150, 30)).string_("Reverb Mix");
    ~slider4 = Slider(w, Rect(20, 140, 150, 30))
    .background_(Color(0.9, 0.57, 0.12))
    .action_({
            arg obj4;
            var reverb;
            reverb = obj4.value.linlin(0,1,0, 1).postln;
            e.set(reverb);
    });
     
    )
    StaticText(w, Rect(180, 180, 150, 30)).string_("FreqScale");
    ~slider4 = Slider(w, Rect(20, 180, 150, 30))
    .background_(Color(0.1, 0.7, 0.23))
    .action_({
            arg obj5;
            var freqscale;
            freqscale = obj5.value.linexp(0,1,-1, 2).postln;
            f.set(freqscale);
    });
     
    )


