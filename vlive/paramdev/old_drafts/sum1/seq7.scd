
	~se = StepEvent.new;
	~se.freq = StepList[1233];
(
	//~se.freq = StepList
	Pdef(\pat, ~se.asPattern.loop <> Pbind(
		\instrument, \default,
		//\amp, 3,
		\dur, 1/4,
	)).play;
	~se.edit



)
	WindowDef(\yyy, { StepEventView(~se).asView }).front;
