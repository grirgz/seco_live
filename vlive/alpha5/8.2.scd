~modStepTimeline.new(~namex+++\step).drumrack = DrumRack(~namex+++\rack);
Pdef(~name+++\mod,
	~modStepTimeline.new(~namex+++\step).xasPattern
)

// END

Pdef(~name+++\mod).quant = nil
Pdef(~name+++\mod).quant 
Pdef.defaultQuant

~modStepTimeline.new(~namex+++\step).edit

ParamProto.init(true)
