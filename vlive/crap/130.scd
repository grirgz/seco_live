//Can be very noisy, high pitched and aliases badly- ie great fun, but watch out for your ears, filter, try out odd param settings. I've turned all the amplitudes down in the following


//defaults, high pitched! WARNING
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(MouseX.kr(100,400),0,0.1)),0.0))}.play


{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(MouseX.kr(50,1000,'exponential'),0,0.1),0,1,1,MouseY.kr(50,1000,'exponential')),0.0))}.play


//with reset
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(MouseX.kr(50,1000,'exponential'),0,0.1),Impulse.kr(3),1,1,MouseY.kr(50,1000,'exponential'), LFNoise0.kr(1,0.4,0.5),LFNoise0.kr(1,10.4,10.5)),0.0))}.play


//MouseY controls input strength of forcing oscillator
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(Saw.ar(261.626,MouseY.kr(0.0001,1,'exponential')), freq:MouseX.kr(100,400)),0.0))}.play



//2 per second
(
{Out.ar(0,Pan2.ar(

CombN.ar(
Resonz.ar(WeaklyNonlinear.ar(Saw.ar(MouseX.kr(50,2000,'exponential'),0.5),0,1,1,MouseY.kr(100,4000,'exponential')),1000,0.1),
0.05,0.05,1
)
,0.0))}.play
)


//with non zero nonlinear term, van der Pol equation, acts to damp, so a rest is needed to hear many sounds
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(MouseX.kr(10,2000),0,0.1),Impulse.kr(MouseY.kr(0,100)),1,1,440,0,0,-0.01,2,-1,1),0.0))}.play

//Duffing equation
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(MouseX.kr(1,1000,'exponential'),0,0.1),0,1,1,MouseY.kr(1,1000,'exponential'),0,0,-0.001,3,0,0),0.0))}.play


//make one up... will last for a while then be lost- needs a Trigger control in reset, very aliased
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(MouseX.kr(1,100,'exponential'),0,0.1),Impulse.kr(0.5),1,1,MouseY.kr(1,1000,'exponential'),LFNoise0.kr(10,0.0),LFNoise0.kr(10,0.0),0.005,3,1,0.5),0.0))}.play

//highly aliased
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(0,0,0.1),0,1,1,MouseX.kr(110,880,'exponential'),0,0,MouseY.kr(0,1.0)),0.0))}.play


//anything happening? 
{Out.ar(0,Pan2.ar(0.1*WeaklyNonlinear.ar(SinOsc.ar(0,0,0.1),Impulse.kr(10),1,1,MouseX.kr(110,880,'exponential'),0,0,0.5,1,1,MouseY.kr(0,1.0)),0.0))}.play
