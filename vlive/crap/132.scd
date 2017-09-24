(
SynthDef(\sfgrain, {
	arg bufnum1=0, bufnum2=1, pan=1.0, startPos=0.0, dur=0.04, amp1=0.5, amp2=0.5, lp=15000, hp=60, ap=1000, fb=0.0, main=0.5, fbmix=0.0, attack= 0.2, release=0.3, rate=0.5, bump1=200, rateG=20.0;
	var grain1, grain2, grain11, grain22, snd, snd2, local, trig, trig2, env, chain, rateV;
	env = (EnvGen.kr(Env.linen(attack,dur,release),doneAction:2)-0.001) * main;
	rateV=BufRateScale.kr(bufnum1)*rate;
	grain1= PlayBuf.ar(2,bufnum1, rateV, 1, BufFrames.ir(bufnum1)*startPos,1)* env;
	grain2= PlayBuf.ar(2,bufnum2, rateV, 1, BufFrames.ir(bufnum2)*startPos, 1)* env;
	grain11= PlayBuf.ar(2,bufnum1,rateV*2, 1, BufFrames.ir(bufnum1)*startPos,1)* env;
	grain22= PlayBuf.ar(2,bufnum2, rateV*2, 1, BufFrames.ir(bufnum2)*startPos, 1)* env;

	local=LocalIn.ar(2);

	trig=Amplitude.kr(local,0.05,0.05)+0.5;
	trig2=Impulse.kr(trig*170)+Impulse.kr(rateG);
	local=local*fb;
	local=Delay1.ar(local);
	local=BAllPass.ar(local, ap,1);

	snd = (grain1*amp1)+(grain2*amp2)+local+(grain11*amp1*0.7)+(grain22*amp2*0.7);
	snd = BLowPass.ar(snd, lp*trig, 3);
	snd = BHiPass.ar(snd, hp, 1);
	snd = BPeakEQ.ar(snd, bump1,1,4);

	snd2 = GrainIn.ar(2,trig2,dur*0.66,snd+local, pan,-1);
	snd2 = BHiPass.ar(snd2,lp*1.05);
	snd2= BLowPass.ar(snd2,lp*trig*0.9);//+lp*(trig*Decay.kr(trig2,0.3)*0.5));
	LocalOut.ar(snd);
	Out.ar(0,Pan2.ar((snd+snd2)*main, pan));
}).add;
)
(//1
~buf1 = Buffer.read(s, "C:/TERensko/prepih/sel/Tisina_jama1.wav");
~buf2 = Buffer.read(s, "C:/TERensko/prepih/sel/tery_poje2.wav");
)
(
Synth(\sfgrain, [\bufnum1, ~buf1.bufnum, \bufnum2, ~buf2.bufnum, \startPos,0.0, \amp1, 1.0, \amp2, 1.0, \pan, 0.5, \mix, 0.5, \dur, 1]);
)
(
var w, slid, slid2, slid3, slid4, slid5, slid6, slid7, slid8, slid9, lastval, lastval2, ampval1,ampval2, work, pan, jump, hop, jumpF, allpF, feed, rate;
lastval=0.2;
lastval2=0.0;
ampval1=0.5;
ampval2=0.0;
pan=0.0;
jump=0.0;
jumpF=2;
work=inf;
hop=1;
allpF=20;
feed=0.0;
w=Window("My Window", Rect(100,300,1000,600));
slid=Slider(w,Rect(10,10,400,40));
slid.value_(0.2);
~enac = ControlSpec(0,1,default:0.2);
slid2=Slider(w,Rect(10,60,400,40));
slid5=Slider(w,Rect(10,110,400,40));
~hc = ControlSpec(1,20, step:1);
h=slid6=Slider(w,Rect(10,160,400,40));
slid3=Slider(w,Rect(10, 210, 40, 300));
slid4=Slider(w,Rect(60, 210, 40, 300));
slid7=Slider(w,Rect(460, 10, 400, 40));
~apc = ControlSpec(10,20000,\exponential);
slid8=Slider(w,Rect(460, 60, 400, 40));
~fbc = ControlSpec(0,0.99);
slid9=Slider(w,Rect(460, 110, 400, 40));
~rc = ControlSpec(0.2,2);
a = StaticText(w, Rect(10, 510, 200, 20));
a.string = "amp1";
a = StaticText(w, Rect(60, 510, 200, 20));
a.string = "amp2";
a = StaticText(w, Rect(420, 110, 200, 20));
a.string = "hopAmt";
a = StaticText(w, Rect(420, 160, 200, 20));
a.string = "hopF";
a = StaticText(w, Rect(870, 10, 200, 20));
a.string = "apF";


slid.action_({lastval= ~enac.map(slid.value);});
slid2.action_({lastval2= slid2.value;});
slid3.action_({ampval1 = slid3.value;});
slid4.action_({ampval2 = slid4.value;});
slid5.action_({jump = slid5.value;});
slid6.action_({jumpF = ~hc.map(slid6.value);});
slid7.action_({allpF = ~apc.map(slid7.value);});
slid8.action_({feed = ~fbc.map(slid8.value);});
slid9.action_({rate = ~rc.map(slid9.value);});
~fura={
	block { |break|
		inf.do{arg i;
			var prop, timestart, timeend, num, hip, all;
			num=1100;
			prop= (i%num)/num;
			hip=i%jumpF;
			hop = (hop + if ( hip == 0,
				{ 1 },
				{ 0 }
			))%2;
			(jump*hop).postln;
			timestart= prop*0.7;
			timeend= prop*(0.7+(0.3*lastval*(jump*hop)));
			Synth(\sfgrain,[\bufnum1, ~buf1.bufnum,
				\bufnum2, ~buf2.bufnum,
				\startPos,timestart +(lastval2*(timeend-timestart)),
				\pan, 0.0,
				\dur, 0.3+(lastval2*1.5),
				\amp1, ampval1,
				\amp2, ampval2,
				\apf, all,
				\fb, feed,
				\fbmix, 0.5,
				\rate, rate
			]);
			(((lastval*0.3)+0.01).max(0.01)).wait;
			if(work==0, {break.value(1) } );
		};
}
};
w.front;
)
~fura.fork;
