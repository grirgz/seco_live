
(
        a = ["C", "C#", "D",  "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
        "event, midi, pitch, octave".postln;
        r = Task({
                inf.do { arg count;
                        var midi, oct, density;
                        density = 1.0;
                        midi = [0, 2, 4, 7, 9].choose;
                        oct = [48, 60, 72].choose;
                        if ( density.coin ) {
                                // true action
                                "".postln;
                                [midi + oct, a.wrapAt(midi), (oct/12).round(1)].post;
                                Synth("PMCrotale", [
                                        "midi", midi + oct, "tone", rrand(1, 7),
                                        "art", rrand(0.3, 2.0), "amp", rrand(0.3, 0.6), "pan", 1.0.rand2
                                ]);
                        } {
                                // false action
                                ["rest"].post
                        }; 
                        0.2.wait;
                };
        }).start
)
