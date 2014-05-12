
(0..15).do { gT }

(
	Task({
		var clips;
		clips = (0..15);

		16.do ({ arg y;
			y = y + 32 - 16;
			Veco.main.clip.play_row(Point(0,y));
			8.wait;
		});
		"END TASK".postln;
	}).play;
)


