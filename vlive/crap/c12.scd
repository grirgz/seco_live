
b = Buffer.alloc(s, 44100, 1);

b.clear
b.zero
b.loadToFloatArray

(
SynthDef(\RecordBuf, { arg out = 0, bufnum = 0;
    var soundIn, soundOut, bufferPos, currentSound;
    soundIn = SoundIn.ar(0);
    bufferPos = Phasor.ar(0, 1, 0, 44100);
    currentSound = BufRd.ar(1, bufnum, bufferPos);
    BufWr.ar(currentSound + soundIn, bufnum, bufferPos);
    soundOut = BufRd.ar(1, bufnum, bufferPos);
    Out.ar(0, soundOut!2);
}).play(s, [\out, 0, \bufnum, b])
);

FileSystemProject.load("repeat/libdef/JackControl.scd");
WindowDef(\InputManager).edit
