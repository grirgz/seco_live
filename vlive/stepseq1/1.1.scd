
(
Pdef(~name, DrumRack(~name+++\drumrack, StepSeq(~name+++\score)))
);

// END

(
Pdef(\main,DrumRack(\test, Pbind(
	\midinote, 2,
	\dur, 2,
))).play;
)

(
Pdef(\main,DrumRack(\test, 
	Ppar([
		Pbind(
			\midinote, 2,
			\dur, 2,
		),
		Pbind(
			\midinote, 4,
			\dur, 1/2,
		),
		Pbind(
			\midinote, 5,
			\dur, 8,
		),
		Pbind(
			\midinote, 6,
			\isRest, Pseq([1,0.8,1,0.4, 0.9,0.3,0.9,0.2],inf).coin.not,
			\dur, 1/8,
		)
	])
)).play;
)

(
Pdef(\main,
	DrumRack(\test, StepSeq(\score).asCoinStep <> Pbind(\dur, 1/8))
).play;
)

//-------
StepSeq(\score).edit;
DrumRack(\test).edit;
//-------
StepSeq(\score).stepseq.playerWrapper.target = Pdef(\main)

StepSeq(\score).stepseq.set_track_count(8)

QKeyModifiers.alt ^ 524288
QKeyModifiers.control ^ 262144
QKeyModifiers.control 
StepSeq(\score2).edit;
(
EventPrototype.initPrototypes(true);
//StepSeq(\scoretest).clear;
StepSeq(\scoretest).edit;
)
StepSeq(\scoretest).stepseq.changed(\set)
StepSeq(\scoretest).stepseq.current_step_count

StepSeq(\scoretest).banks;
StepSeq(\scoretest).stepseq.respondTo(\banks)

StepSeq(\score).stepseq.playerWrapper.target = Pdef(\main)
StepSeq(\score).stepseq.playerWrapper.edit

$c.asUnicode
(3.asAscii.ascii + 96).asAscii
~a = 3.asAscii
~a.ascii.dump
Char

StepSeq(\score).current_step_count = 16
~s = StepSeq(\score).stepseq
~a = List.newFrom([1,5,9,2,5])
~a.wrapExtend(10)
~a

StepSeq(\score).stepseq.current_score
~s.current_score
~s.keys
		~s.banks.do { arg bank;
			bank[~s.current_score] = bank[self.current_score].wrapExtend(val);
		};

Pdef(\main).quant = 8
DrumRack(\test).edit
DrumRack(\test).scoreproxy.quant = 4


	EventPrototype.initPrototypes(true);
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
StepSeq(\score).banks.size
StepSeq(\score).set_track_count(8)
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

Archive.global.at(\PresetDictionary).keys
Archive.global.at(\PresetDictionary, \lib_drumrack).keys
Archive.global.at(\PresetDictionary, \DrumRack).keys
Archive.global.put(\PresetDictionary, \DrumRack, nil)
Archive.global.put(\PresetDictionary, \lib_drumrack, nil)
Archive.write

DrumRack.lib_drumrack
DrumRack.lib_drumrack.keys
DrumRack.lib_drumrack.save
DrumRack.lib_drumrack.load
Archive.global.at(\PresetDictionary, \lib_drumrack).keys
DrumRack(\test).edit
DrumRack(\test)

(
	File.use("/home/ggz/.local/share/SuperCollider/PresetDictionary/lib_drumrack", "w", { arg file;
		file << (0..300000).asCompileString;
	})
)

"/home/ggz/.local/share/SuperCollider/PresetDictionary/lib_drumrack".load


Pdef(\yaa).addHalo(\jaune,3)
Pbindef(\yaa).getHalo(\jaune)
Pbindef(\yaa).getHalo(\jaune)

Archive.global.put(\PresetDictionary, nil); /////////// WARNING ERASE ALL DATA LOST /////////////
Archive.write

Archive.global.at(\PresetDictionary, \lib_drumpad).keys
Archive.global.at(\PresetDictionary, \lib_drumpad)[\dr_oscsampler_table]
Archive.global.at(\PresetDictionary, \lib_drumpad)[\dr_oscsampler_table].params.getHalo(\spec)
Pdef(\dr_oscsampler_table).getHalo(\spec)
Pdef(\dr_oscsampler_table).getHalo(\params)
Pdef(\dr_oscsampler_table).getHalo(\instrument)
Halo

Archive.global.at(\PresetDictionary, \lib_drumrack).keys
Archive.global.at(\PresetDictionary, \lib_drumrack).keys
Archive.global.at(\PresetDictionary, \lib_drumrack)[\niaw].load.list.first.params
Archive.global.at(\PresetDictionary, \lib_drumrack)[\niaw].list.first.params
Archive.global.at(\PresetDictionary, \lib_drumrack)[\niaw].list.first.asCompileString
Archive.global.at(\PresetDictionary, \lib_drumrack)[\niaw].list.first.params.bufnum
DrumRack.lib_drumpad[\niaw].list.first.params
DrumRack.lib_drumrack[\merci].get_pad(1).list.first.params
DrumRack.lib_drumrack[\merci].get_pad(1).list.first.asArchiveData
DrumRack.lib_drumrack[\merci].get_pad(1).list.first.asArchiveData.params.bufnum.path
DrumRack.lib_drumrack[\merci].get_pad(1).list.first.asArchiveData.params.bufnum
DrumRack.lib_drumrack[\merci].get_pad(1).list.first.asArchiveData.load

XSamplePlaceholder.new("plop").path
XSamplePlaceholder.new("plop").asCompileString
XSamplePlaceholder.new("plop")

DrumRack.lib_drumrack[\default].get_pad(1).list.first.asArchiveData.load
DrumRack.lib_drumrack[\default].get_pad(1).list.first
DrumRack.lib_drumrack[\default].get_pad(1).play_preset
DrumRack.lib_drumrack[\default].get_pad(1).list

XSamplePlaceholder("pathhhhh").writeArchive("plop")
Object.readArchive("plop").path

Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].pads[1].list.first.params
Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].pads[1].list.first.params.bufnum.path
Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].
Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].
Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].
Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].drumrack.browse
Archive.global.at(\PresetDictionary, \lib_drumrack)[\default].inspect
Archive.global.at(\PresetDictionary)

~a = List.new;
~a add: "kk"

(

	~a add: (\plop -> (
		a:4,
		b:55,

	)
)


(
		{
		var window = Window.new;
		var layout;
		var field = TextField.new;
		~field = field;
		window.view.keyDownAction = { arg me, key, modifiers, unicode, keycode;
			[me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
			field.string = [me, key, modifiers, unicode, keycode].asCompileString;
			true;
		};
		field.keyDownAction = window.view.keyDownAction;
		layout = VLayout(
			field
		);
		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;

	}.value
)
~field.string = "plop"




(



var quant=0.5, tol=0.5, strenght=0.5;



Window.closeAll;

w=Window.new.alwaysOnTop_(true).front;



f={

	b.value=a.value.collect(_.quantize(quant, tol, strenght))

};



w.layout_(

	VLayout([

		HLayout(

			StaticText().string_("quantum"),

			Slider().value_(quant).action_({arg self; quant=self.value.postln; f.()}),

			StaticText().string_("tolerance"),

			Slider().value_(tol).action_({arg self; tol=self.value.postln; f.()}),

			StaticText().string_("strength"),

			Slider().value_(strenght).action_({arg self; strenght=self.value.postln; f.()})

		),stretch:1],

		[VLayout(

			HLayout(

				a=MultiSliderView()

				.elasticMode_(true)

				.value_((0..100)/100)

				.action_(f),

				Button().action_({

					a.value=(0..100)/100;

					f.();

				})

			),

			b=MultiSliderView()

			.editable_(false)

			.elasticMode_(true)

			.value_(a.value)

		),stretch:1]

	)

);

)


MultiEQGUI.new(MultiEQ.new)
MultiEQ
\plop.isSymbol
