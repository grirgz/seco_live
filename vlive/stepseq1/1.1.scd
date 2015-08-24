
(
Pdef(~name, DrumRack(~name+++\drumrack, StepSeq(~name+++\score)))
);

// END

DrumRack(~name+++\drumrack).edit
DrumRack(\test).edit
DrumRack(\test2).edit
DrumRack.lib_drumpad[\dr_kick] = nil
DrumRack.lib_drumpad[\dr_kick2] = nil
DrumRack.lib_drumpad[\dr_kick3] = nil
DrumRack.lib_drumpad[\DrumRack] = nil
DrumRack.lib_drumpad.save;
DrumRack.lib_drumpad[\DrumRack] = nil
Archive.global.put(\PresetDictionary, nil)
Archive.global.save
Archive.write

DrumRack(\test, StepSeq(\score)).edit
Pdef(\main, Pn(DrumRack(\test, StepSeq(\score).asCoinStep <> Pbind(\dur, 1/8))))

.edit
StepSeq(\score).edit
DrumRack(\test).edit
Color.newHex("63AFD0")
Color.constNames

(
	ParamView.color_ligth = Color.newHex("946BD6");
	ParamView.color_dark = Color.newHex("4C10AE");
	EventPrototype.initPrototypes;
StepSeq(\score).edit;
)
(
	ParamView.color_ligth = Color.newHex("5CCCCC");
	ParamView.color_dark = Color.newHex("009999");
	EventPrototype.initPrototypes;
StepSeq(\score).edit;
)


/////////////////


DrumRack.lib_drumrack[\x2_dr_kick]
DrumRack.lib_drumpad[\x2_dr_kick].list.first.params
DrumRack.lib_drumpad[\x2_dr_kick].asArchiveData.asCompileString
DrumRack.lib_drumpad[\x2_dr_kick].asArchiveData.load

Archive.global.at(\PresetDictionary, \lib_drumpad)[\x2_dr_kick].load
Archive.global.at(\PresetDictionary, \lib_drumpad)[\x_dr_kick].load
Archive.global.at(\PresetDictionary, \lib_drumpad)[\x_dr_kick].load.keys
Archive.global.at(\PresetDictionary, \lib_drumpad)[\x_dr_kick].load.play_preset



Pdef(\yaa).addHalo(\jaune,3)
Pbindef(\yaa).getHalo(\jaune)
Pbindef(\yaa).getHalo(\jaune)
