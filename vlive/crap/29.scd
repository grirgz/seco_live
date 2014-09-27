//Example02a - higher is bigger

(

s.latency= 0.05;

s.waitForBoot{


        //--window setup

        var width= 640, height= 480;

        var w= Window("Example02a - higher is bigger", Rect(99, 99, width, height), false);

        var u= UserView(w, Rect(0, 0, width, height));

        

        //--variables

        var pat= Pn(Pshuf(#[0, 0, 0, 0, 0.1, 0.25, 0.5, 0.75, 1, 1], 8), inf).asStream;

        var syn= SynthDef(\av, {|scaleFreq= 0|

                var z= LPF.ar(LFSaw.ar(#[300, 301, 80, 81]*(scaleFreq+0.5)).mean, 2000);

                Out.ar(0, Pan2.ar(z));

        }, #[0.05]).play(s);            //short lag time to avoid clipping

        var fre= 0;

        

        //--interface

        ~radius= 100;

        ~fps= 10;

        

        //--main loop

        u.drawFunc= {

                if(u.frame%(~fps/60).reciprocal==0, {

                        fre= pat.next;                                          //get the next value from the stream

                        syn.set(\scaleFreq, fre);                               //send to the synth

                });

                Pen.translate(width*0.5, height*0.5);                   //offset drawing to the centre

                Pen.fillColor= Color.white;                                     //always fill with white color

                Pen.fillOval(Rect.aboutPoint(Point(0, 0), ~radius*fre, ~radius*fre));

        };

        

        //--window management

        u.clearOnRefresh= true;

        u.background= Color.black;

        w.onClose= {syn.free};

        w.front;

        u.animate= true;

        CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});

};

)


//change these while the program is running

~radius= 200;

~radius= 300;

~fps= 30;

~fps= 15;

~fps= 5;

~radius= 15;


//close the window to stop or press cmd+.
(
s.waitForBoot({
        var point, red, green, blue, win, view, colorTask, redChange, greenChange,
blueChange;

        SynthDef(\note, {
                arg freq=440, width=0.5, pan=0, amp=1, length=1;
                var sig, env;
                env = EnvGen.kr(Env([0,1,0],[0.012,0.012]*length, \linear), doneAction:2);
                sig = VarSaw.ar(freq, 0, width);
                sig = Pan2.ar(sig, pan, amp);
                sig = sig * env;
                Out.ar(0, sig);
        }).add;


        //initial color values and increments
        red=0; green=0.33; blue=0.67;
        redChange=0.01;
        greenChange=0.015;
        blueChange=0.02;

        //update RGB color values 20x per sec
        colorTask = Task({
                {
                        red = (red + redChange)%2;
                        green = (green + greenChange)%2;
                        blue = (blue + blueChange)%2;
                        0.05.wait;
                }.loop
        });

        //gui
        win = Window("SKETCH PAD",
Rect(0,0,Window.screenBounds.width,Window.screenBounds.height),
border:true);
        win.onClose = {
                if(
                        colorTask.isPlaying,
                        {colorTask.stop},{});
        };

        view = UserView(win, Window.screenBounds);
        view.clearOnRefresh = false;
        view.background = Color.black;

        //right click to clear sketch pad
        view.mouseDownAction = {
                |v, x, y, mod, butNum|
                point = [x,y];
                if(
                        butNum == 1,
                        {
                                v.drawFunc_({nil});
                                v.clearDrawing;
                                v.refresh
                        }, {}
                );
        };

        //draw lines with Pen and create Synths according to mouse movement
        view.mouseMoveAction = {
                |v, x, y|
                var penWidth=30;
                v.drawFunc = {
                        Pen.strokeColor = Color.new(
                                red.fold(0,1),
                                green.fold(0,1),
                                blue.fold(0,1)
                        );
                        Pen.width = penWidth;
                        Pen.line(point.asPoint, x@y);
                        point = [x,y];
                        Pen.stroke;
                };
                win.refresh;

                Synth(\note, [
                        //              \freq, ((x/(Window.screenBounds.width)).linlin(0,1,32,100)).midicps,
                        //              \freq, exprand(40.0,2000.0),
                        \freq, ((x/(Window.screenBounds.width)).linlin(0,1,32,90).round(5) +
[0,3,7].choose).midicps,
                        \width, ((y/(Window.screenBounds.height)).linlin(0,1,0.001,0.5)),
                        //              \pan, x.linlin(0,Window.screenBounds.width, -1, 1),
                        \pan, rrand(-1.0,1.0),
                        \length, penWidth
                ]);
        };

        colorTask.start;
        win.front;
})
)




//Simple Animation and Sound
s.boot;

//read a sound file
b = Buffer.read(s, Platform.resourceDir++"/sounds/a11wlk01.wav");

//Define a UGen function (or SynthDef) to control the animation
(
~sound = {
        arg amp=1;
        var sig, ampTrack, sendTrig;

        //play the sound file
        sig = PlayBuf.ar(1, b.bufnum, loop:1) * amp;

        //track the amplitude
        ampTrack = Amplitude.kr(sig);

        //smooth out the signal a bit
        ampTrack = Lag.kr(ampTrack, 0.05);

        //query the tracked amplitude 50 times per second
        sendTrig = Impulse.kr(50);

        //send the amplitude back to the language so it can be incorporated into the animation
        SendReply.kr(sendTrig, '/level', ampTrack);

        sig = sig * EnvGate.new;
        Out.ar(0, sig);
};
)

//receive amplitude data from the server
(
OSCdef.new(\getLevel, {
        arg msg, time, addr, recvPort;

        //amplitude controls Pen width
        ~penWidth = msg[3].linlin(0.05, 0.5, 1, 200);

        }, '/level'
);
)

//Create GUI
(
var uv, color;

color = Color.rand;
~penWidth = 3;

w = Window.new("animation", Rect(128,128,650,550)).front;
uv = UserView.new(w, w.view.bounds)
.background_(Color.white);
w.onClose_({uv.animate = false});

uv.drawFunc_({
        |n|
        Pen.line(200@200, 500@(400*n));
        Pen.width = ~penWidth;
        Pen.strokeColor = color;
        Pen.stroke;
});
uv.frameRate = 60;
uv.animate = true;
)

//start sound and watch the GUI window
~playSound = ~sound.play;

//amplitude adjustment (affects animation)
~playSound.set(\amp, 0.3);

//fade out
~playSound.set(\fadeTime, 5, \gate, 0);

//close the window
w.close;
