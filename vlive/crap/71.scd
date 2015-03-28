play{Splay.ar(x=sin(Compander.ar(CombC.ar(BPF.ar(InFeedback.ar(20,99),300, 0.5),0.6,LFNoise1.kr(1e-20!12)+1.9/100,40))+Dust2.ar(0.0005!39)*1.5))++(0!3)++(x-x.rotate/4)}


{play{x=Impulse.ar(0.05);20.do{x=LPF.ar(AllpassL.ar(LeakDC.ar(x),4,8**kr(n=LFNoise2,0s)/2,8)*1.2,8**n.kr({0s.rand}!2)*2500,1).tanh};x*5}}!4
play{Splay.ar({Pluck.ar(BPF.ar(f=product({|i|product({LFPulse.ar(2**rrand(-9,1),2.rand/2)}!(i+2))/(1+i)+1}!8)*86,f).sin,Saw.ar,1,1/f,9)}!9)}
