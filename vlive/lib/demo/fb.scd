BusDef(\input);
~buf = Buffer.alloc(s, s.sampleRate * 8.0, 2);

(
Ndef(\head, {
	var in = InFeedback.ar(BusDef(\input), 2);
	RecordBuf.ar(in, ~buf, 1, 1, 1, 1, 0, 0);
	PlayBuf.ar(2, ~buf, 1, loop:1);
})
)
