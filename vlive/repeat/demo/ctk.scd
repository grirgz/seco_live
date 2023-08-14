s.boot;
(
var scpn, score, grainfun, gliss;
scpn = CtkProtoNotes(
    SynthDef(\control, {arg outbus, rate, low, hi;
        Out.kr(outbus, LFNoise2.kr(rate).range(low, hi))
    }),
    SynthDef(\test, {arg freq, amp, dur;
        var env, envgen, src;
        env = Env([0, 1, 0], [0.5, 0.5], \sin);
        envgen = EnvGen.kr(env, timeScale: dur);
        src = BPF.ar(WhiteNoise.ar(amp), freq, 0.01, amp * envgen);
        Out.ar(0, Pan2.ar(src, Rand(-1.0, 1.0)));
    })
);

score = CtkScore.new;

//creates a granular gesture of duration. Each grain is 0.1 seconds long, new grain every 0.02 seconds
grainfun = {arg starttime, duration, ampenv, lowfreq, hifreq;
    var now, note, thisgroup;
    now = 0;
    ampenv.times = ampenv.times.normalizeSum * duration; // scale the Env's time to the gestures
    thisgroup = CtkGroup.new(starttime, duration + 2).addTo(score);
    while({
        // create a note... add it to the CtkScore
        note = scpn[\test].note(starttime + now, 0.1, target: thisgroup)
        .freq_(lowfreq.rrand(hifreq))
        .amp_(ampenv[now])
        .dur_(0.1).addTo(score);
        now = now + 0.02;
        now < duration;
    });
};

gliss = {arg starttime, duration, rate, lowfreq, hifreq;
    var cbus, control, note;
    cbus = CtkControl.new;
    control = scpn[\control].note(starttime, duration)
    .outbus_(cbus.bus)
    .rate_(rate)
    .low_(lowfreq)
    .hi_(hifreq)
    .addTo(score);
    note = scpn[\test].note(starttime, duration, \tail, 1)
    .freq_(cbus)
    .amp_(2)
    .dur_(duration)
    .addTo(score);
};

grainfun.value(1, 10, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 440, 880);
grainfun.value(4, 4, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 4400, 8800);
grainfun.value(6, 12, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 300, 400);
grainfun.value(3, 10, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 200, 200);
grainfun.value(1.5, 20, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 7000, 7100);

5.do({arg i;
    var j;
    j = i + 1;
    gliss.value(3 + (i + 4), 10.rrand(7), j.reciprocal, 440 * j, 880 * j);
});

// uncomment to play the CtkScore you have created
score.play(s);

// uncomment to write (render) the score to a soundfile
// score.write("~/Desktop/test.aiff".standardizePath, 22, options: ServerOptions.new.numOutputBusChannels_(2).blockSize_(1));

// uncomment to save the CtkScore as a file
// score.saveToFile("~/Desktop/test.sc".standardizePath);
)

// working with a 'parent' score - manipulating CtkScore objects
(
s.boot;
o = ServerOptions.new.numOutputBusChannels_(1);

// the 'parent' score
a = CtkScore.new;

b = CtkScore.new;

z = CtkSynthDef(\test, {arg freq, dur;
    Out.ar(0, SinOsc.ar(freq, 0, XLine.kr(0.1, 0.0001, dur)))
});

t = 0.0;

while({
    b.add(z.note(t, 0.1).freq_(440).dur_(0.1));
    t = t + 0.1;
    t < 5.0;
});

a.add(b);
a.saveToFile("~/Desktop/test.sc".standardizePath)
a.write("~/Desktop/test.aiff".standardizePath, options: o);
)

// p = Player.new("~/Desktop/test.aiff".standardizePath).gui; //seems not working currently
p = Buffer.read(s, "~/Desktop/test.aiff".standardizePath);
q = p.play; //play the rendered score
q.free; p.free; //free the buffer

(
var scpn, score, grainfun, gliss;
scpn = CtkProtoNotes(
    SynthDef(\control, {arg outbus, rate, low, hi;
        Out.kr(outbus, LFNoise2.kr(rate).range(low, hi))
        }),
    SynthDef(\test, {arg freq, amp, dur;
        var env, envgen, src;
        env = Env([0, 1, 0], [0.5, 0.5], \sin);
        envgen = EnvGen.kr(env, timeScale: dur);
        src = BPF.ar(WhiteNoise.ar(amp), freq, 0.01, amp * envgen);
        Out.ar(0, Pan2.ar(src, Rand(-1.0, 1.0)));
        })
    );

score = CtkScore.new;

//creates a granular gesture of duration. Each grain is 0.1 seconds long, new grain every 0.02 seconds
grainfun = {arg starttime, duration, ampenv, lowfreq, hifreq;
    var now, note, thisgroup;
    now = 0;
    ampenv.times = ampenv.times.normalizeSum * duration; // scale the Env's time to the gestures
    thisgroup = CtkGroup.new(starttime, duration + 2).addTo(score);
    while({
        // create a note... add it to the CtkScore
        note = scpn[\test].note(starttime + now, 0.1, target: thisgroup)
            .freq_(lowfreq.rrand(hifreq))
            .amp_(ampenv[now])
            .dur_(0.1).addTo(score);
        now = now + 0.02;
        now < duration;
        });
    };

gliss = {arg starttime, duration, rate, lowfreq, hifreq;
    var cbus, control, note;
    cbus = CtkControl.new;
    control = scpn[\control].note(starttime, duration)
        .outbus_(cbus.bus)
        .rate_(rate)
        .low_(lowfreq)
        .hi_(hifreq)
        .addTo(score);
    note = scpn[\test].note(starttime, duration, \tail, 1)
        .freq_(cbus)
        .amp_(2)
        .dur_(duration)
        .addTo(score);
    };

grainfun.value(1, 10, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 440, 880);
grainfun.value(4, 4, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 4400, 8800);
grainfun.value(6, 12, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 300, 400);
grainfun.value(3, 10, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 200, 200);
grainfun.value(1.5, 20, Env([0, 1, 0], [0.5, 0.5], [3, -5]), 7000, 7100);

5.do({arg i;
    var j;
    j = i + 1;
    gliss.value(3 + (i + 4), 10.rrand(7), j.reciprocal, 440 * j, 880 * j);
    });

// uncomment to play the CtkScore you have created
score.play(s);

// uncomment to write the score to a soundfile
// score.write("~/Desktop/test.aiff".standardizePath, 22, options: ServerOptions.new.numOutputBusChannels_(2).blockSize_(1));

// uncomment to save the CtkScore as a file
// score.saveToFile("~/Desktop/test.sc".standardizePath);
)



// working with a 'parent' score - manipulating CtkScore objects

(
s.boot;
o = ServerOptions.new.numOutputBusChannels_(1);

// the 'parent' score
a = CtkScore.new;

b = CtkScore.new;

z = CtkSynthDef(\test, {arg freq, dur;
    Out.ar(0, SinOsc.ar(freq, 0, XLine.kr(0.1, 0.0001, dur)))
});

t = 0.0;

while({
    b.add(z.note(t, 0.1).freq_(440).dur_(0.1));
    t = t + 0.1;
    t < 5.0;
});

a.add(b);
a.saveToFile("~/tmp/test.sc".standardizePath);
a.write("~/tmp/test.aiff".standardizePath, options: o);

)
// p = Player.new("~/Desktop/test.aiff".standardizePath).gui;
p = Buffer.read(s, "~/tmp/test.aiff".standardizePath);
q = p.play; //play the rendered score
q.free; p.free; //free the buffer

(
// make a copy of b with an offset of 2.05 seconds
c = b.copy;
c.offset(2.05);
// alter the freq , durations and the dur parameter of c's notes
c.notes.do({arg me;
    me.setDuration(0.11).dur_(0.11).freq_(me.freq * 2)
});

// add it to the score
a.add(c);

a.write("~/tmp/test.aiff".standardizePath, options: o);
)

// p = Player.new("~/Desktop/test.aiff".standardizePath).gui;
p = Buffer.read(s, "~/tmp/test.aiff".standardizePath);
q = p.play; //play the rendered score
q.free; p.free; //free the buffer


(
// let's alter the score 'c'...
c.notes.do({arg me;
    me.freq_(me.freq * (1 + 0.25.rand2));
});

// offset it another 0.123 seconds
c = c.offset(0.123);

a.write("~/tmp/test.aiff".standardizePath, options: o);
)

// p = Player.new("~/Desktop/test.aiff".standardizePath).gui;
p = Buffer.read(s, "~/tmp/test.aiff".standardizePath);
q = p.play; //play the rendered score
q.free; p.free; //free the buffer

(
// make a copy of b with an offset of 2.05 seconds
c = b.copy;
c.offset(2.05);
// alter the freq , durations and the dur parameter of c's notes
c.notes.do({arg me;
    me.setDuration(0.11).dur_(0.11).freq_(me.freq * 2)
});

// add it to the score
a.add(c);

a.write("~/tmp/test.aiff".standardizePath, options: o);
)

// p = Player.new("~/Desktop/test.aiff".standardizePath).gui;
p = Buffer.read(s, "~/tmp/test.aiff".standardizePath);
q = p.play; //play the rendered score
q.free; p.free; //free the buffer

// let's alter the score 'c'...
(
c.notes.do({arg me;
    me.freq_(me.freq * (1 + 0.25.rand2));
});

// offset it another 0.123 seconds
c = c.offset(0.123);

a.write("~/tmp/test.aiff".standardizePath, options: o);
)

// p = Player.new("~/Desktop/test.aiff".standardizePath).gui;
p = Buffer.read(s, "~/tmp/test.aiff".standardizePath);
q = p.play; //play the rendered score
q.free; p.free; //free the buffer
