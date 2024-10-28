// http://sccode.org/1-5dg
(
SynthDef(\polyswingasym,{

	arg frqkick=45, frqtm=135, reskick=0.05, deckick=4, decsnr=4, speed=1, swing=0.5, div1=2, div2=3, div3=4, div4=6, div5=8, div6=3, out=0, kickv=86, snrv=74, hhv=110, tmv=70, clvv=30, wdv=100;

	var sig, master, master2, trig1, trig2, trig21, trig3, trig4, trig5, trig6,
	kick,envkick,snr,envsnr,hh,tm,clv,wd;

	master = LFSaw.ar(speed,pi,0.5,0.5).lincurve(0,1,0,1,swing);

	trig1 = (master%(1/div1))*div1;
	trig2 = (master%(1/div2))*div2;
	trig3 = (master%(1/div3))*div3;
	trig4 = (master%(1/div4))*div4;
	trig5 = (master%(1/div5))*div5;
	trig6 = (master%(1/div6))*div6;

	envkick = (((trig1.neg+1).lincurve(0,1,0,1,deckick).cubed*2)+1).lag(0.001);

	envsnr = ((trig2.neg+1).lincurve(0,1,0,1,decsnr).cubed).lag(0.001);

	kick= Resonz.ar(trig1,frqkick*envkick,0.005,kickv);
	snr=  (Resonz.ar(trig2,222,0.02,4)+WhiteNoise.ar(0.01)+Dust2.ar(123,0.01))*envsnr.tanh*snrv;
	hh= RHPF.ar(Mix.new(Resonz.ar(trig3,Array.linrand(11,4000,6500),0.0005)),2400,0.4,hhv);
	tm= Resonz.ar(trig4,frqtm,0.03,tmv);
	clv= HPF.ar(Mix.new(Resonz.ar(trig5,Array.linrand(9,500,3500),0.01,clvv)),700);
	wd= Resonz.ar(trig6,850,0.04,wdv);

	sig = kick+snr+hh+tm+clv+wd;

	Out.ar(out,LeakDC.ar(sig!2).tanh);
}).add;
)

Ndef(\demo, \polyswingasym).play
Ndef(\demo).set(\swing, 0)
Ndef(\demo).set(\frqkick, 67)
Ndef(\demo).set(\div1, 2)
Ndef(\demo).set(\div2, 4)
Ndef(\demo).set(\div3, 5)
Ndef(\demo).set(\div4, 6)
Ndef(\demo).set(\div5, 7)
Ndef(\demo).set(\div6, 3)
Ndef(\demo).set(\kickv, 72)
