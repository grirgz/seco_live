~buffer=Buffer.read(s,"/home/Skylex/SupercolliderExemples/musicradar-808-samples/musicradar-303-style-acid-samples/musicradar-303-style-acid-samples/Basslines/125bpm/AM_BaStatB_125B.wav")

~buffer.play(loop:true)
Ndef.clear
Ndef(\filtre).play

(
Ndef(\filtre,{
	var in,out,a0,a1,b1,omega0,tau;
	tau=1.0/s.sampleRate;
	omega0=2*pi*2000;
	a0=2.0/((tau*omega0)+2.0);
	a1=(-1.0)*a0;
	b1=(2-(tau*omega0))/((tau*omega0)+2.0);
	//in=PlayBuf.ar(1,~buffer,BufRateScale.ir(~buffer),loop:1);
	in=SinOsc.ar(440);
	out=FOS.ar(in,a0,a1,b1);
	2*out;
});
)
