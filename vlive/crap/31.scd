(
var size = 512, real, imag, cosTable, complex, ifft;

real = Signal.newClear(size);
        // some harmonics
//real.sineFill2([[8], [13, 0.5], [21, 0.25], [55, 0.125, 0.5pi]]);
real.sineFill2([[8]]);
        // add a little noise
//real.overDub(Signal.fill(size, { 0.2.bilinrand }));

imag = Signal.newClear(size);
cosTable = Signal.fftCosTable(size);

complex = fft(real, imag, cosTable).postln;
ifft = complex.real.ifft(complex.imag, cosTable);

//[real, ifft.real].flop.flat.plot("fft and back", Rect(0, 0, 512 + 8, 500), numChannels: 2);
//[complex.real, complex.imag].flop.flat.plot("fft and back", Rect(0, 0, 512 + 8, 500), numChannels: 2);
complex.real.plot("fft and back", Rect(0, 0, 512 + 8, 500), numChannels: 1);
~complex = complex;
)
~complex


(
a = Signal.newClear(512*2);
a.waveFill({ arg x, i; sin(x*10).max(0) }, 0, 3pi);
a.plot;
a.play(loop:true)
)

d = Signal.sineFill(128*16, [1,128,256]);
d.plot
d.do{arg val,x; [val, x].postln}

a = d.fft(Signal.newClear(d.size), Signal.fftCosTable(d.size));

r = a.rho;  // magnitudes -- note r[1] ~= 40, r[2] ~= 40/2, r[3] ~= 40/3 etc.
t = a.theta;  // phases -- note t[1] == t[2] == t[3] == t[4] == t[5] == -0.5pi
// A cosine with phase -0.5pi is the same as a sine with phase 0, matching sineFill
128*16*1/6
a.real.plot
a.rho.plot
a.real.do ({ arg val, x; [val,x].postln; })
a.rho.do ({ arg val, x; [val,x].postln; })
(
~ifft = a.real.ifft(a.imag, Signal.fftCosTable(d.size));
~ifft.real.plot;
)

(
b = Signal.newClear(d.size);
r.do { |mag, i|
        var freq = i,  // 'i' cycles per 'd.size' samples
        phase = t[i],
        increment = (2pi * freq / d.size),
        sine = Signal.fill(d.size, { |j| mag * cos(phase + (increment * j)) });
		[freq, mag, phase, increment].debug("f, mag, phase, incr");
        b = b + sine;
};
b = b / d.size;
)

b.plot;  // looks familiar!
b.play(true)
