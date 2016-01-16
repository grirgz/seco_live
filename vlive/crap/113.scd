/*******************************************
*Dillon Bastan, 2015
*
*This is a basic Sampler with GUI
*
*cargocollective.com/integrate
*******************************************
*******************************************/


//BEGIN PROGRAM
(
//Boot Server
s = Server.internal;
Server.default = s;
s.boot;

s.waitForBoot({

	/*************************************
	*****Function Definitions
	*************************************/

	var globalSetup, guiControl,
	synthSetup, midiSetup, param, fxMixer;




	//***Initialize global classes, buses, groups, and buffers
	globalSetup = {
		var c_Parameters;

		//Buses
		~busMixer = Bus.audio(s, 2);
		~busPlugout = Bus.audio(s, 2);

		//Groups
		~grpSource = Group.new;
		~grpFx = Group.after(~grpSource);

		//Buffers
		~bufSound;

		//Parameter Class
		c_Parameters = {(
			root: 60,
			ampEnv: [0.02, 1, 0.5, 1],
			loopOn: 0,
			loopStart: 0,
			loopLength: 1,
			rev: 1,
			fade: 0.02,
			activeVoices: Array.newClear(128),
			fCut: 2500,
			fRes: 0.3,
			fType: \off,
			mixAmp: 1,
			mixPan: 0,
		)};

		//parameter object will hold global parameters for the Sampler
		param = c_Parameters.value;

	};//End (globalSetup)






	//***Initial GUI and GUI Event Handling
	guiControl = {

		var winMain, conMain,
		btnOpenSound, drgOpenSound,
		sfvWaveform, btnLoop, btnRev,
		knbRoot, knbMixAmp, knbMixPan, slFade,
		conAmpEnv, slAmpEnv = Array.newClear(4),
		conFilter, knbFCut, knbFRes,
		btnFTypes = Array.newClear(4),
		txtRoot, txtMixAmp, txtMixPan,
		txtFCut, txtFRes, txtAmpEnv, txtFade,
		f_openSound, f_envValues, f_filtTypes;


		//___________DECLARATIONS//
		{
			var winRect, conRect,
			genKnbRect, sfvHeight;

			//Rect Bound Vars
			winRect = [350, 350];
			conRect = [winRect[0] * 0.75, winRect[1] * 0.75];
			genKnbRect = [30, 30];
			sfvHeight = conRect[1] * 0.25;

			//Top-Level Section
			{
				winMain = Window(
					\scSampler,
					Rect(200, 200, winRect[0], winRect[1]),
					false
				).front;
				conMain = CompositeView(
					winMain, Rect(
						winRect[0] * 0.125, winRect[1] * 0.125,
						conRect[0], conRect[1]
				));
				sfvWaveform = SoundFileView(
					conMain, Rect(
						0, 0, winRect[0] * 0.75,
						sfvHeight
				));
				drgOpenSound = DragSink(
					conMain, Rect(
						conRect[0] - 60,
						sfvHeight + 50, 60, 20
				));
				btnOpenSound = Button(
					conMain, Rect(
						conRect[0] - 60,
						sfvHeight + 25, 60, 20
				));
				btnLoop = Button(
					conMain, Rect(
						genKnbRect[0] + 100,
						sfvHeight + 25, 60, 20
				));
				btnRev = Button(
					conMain, Rect(
						genKnbRect[0] + 100,
						sfvHeight + 50, 60, 20
				));
				txtRoot = StaticText(
					conMain, Rect(
						0, sfvHeight,
						100, 20
				));
				knbRoot = Knob(
					conMain, Rect(
						0, sfvHeight + 20,
						genKnbRect[0], genKnbRect[1]
				));
				txtMixAmp = StaticText(
					conMain, Rect(
						40, sfvHeight,
						100, 20
				));
				knbMixAmp = Knob(
					conMain, Rect(
						40, sfvHeight + 20,
						genKnbRect[0], genKnbRect[1]
				));
				txtMixPan = StaticText(
					conMain, Rect(
						80, sfvHeight,
						100, 20
				));
				knbMixPan = Knob(
					conMain, Rect(
						80, sfvHeight + 20,
						genKnbRect[0], genKnbRect[1]
				));
				txtFade = StaticText(
					conMain, Rect(
						93, sfvHeight + 54,
						100, 20
				));
				slFade = Slider(
					conMain, Rect(
						0, sfvHeight + 57,
						90, 15
				));
			}.value;

			//AmpEnv Section
			{
				var ampEnvConRect, ampEnvSlRect;
				ampEnvConRect = [150, 100];
				ampEnvSlRect = [ampEnvConRect[0] / 5, ampEnvConRect[1] - 5];

				txtAmpEnv = StaticText(
					conMain, Rect(
						35, sfvHeight + genKnbRect[0] + 45,
						100, 20
				));
				conAmpEnv = CompositeView(
					conMain, Rect(
						0, sfvHeight + genKnbRect[0] + 60,
						ampEnvConRect[0], ampEnvConRect[1]
				));
				conAmpEnv.decorator = FlowLayout(conAmpEnv.bounds);
				4.do({ |i|
					slAmpEnv[i] = Slider(conAmpEnv,
						Rect(0, 0, ampEnvSlRect[0], ampEnvSlRect[1])
					);
				});
			}.value;

			//Filter Section
			{
				var filtConRect, filtBtnRect;
				filtConRect = [100, 100];
				filtBtnRect = [filtConRect[0] / 2.3, 25];

				txtFCut = StaticText(
					conMain, Rect(
						conRect[0] - 65,
						sfvHeight + genKnbRect[0] + 50,
						100, 20
				));
				txtFRes = StaticText(
					conMain, Rect(
						conRect[0] - 18,
						sfvHeight + genKnbRect[0] + 50,
						100, 20
				));
				conFilter = CompositeView(
					conMain, Rect(
						conRect[0] - filtConRect[0],
						sfvHeight + genKnbRect[0] + 60,
						filtConRect[0], filtConRect[1]
				));
				conFilter.decorator = FlowLayout(conFilter.bounds);
				knbFCut = Knob(conFilter,
					Rect(0, 0, filtConRect[0] / 2.3, genKnbRect[1])
				);
				knbFRes = Knob(conFilter,
					Rect(0, 0, filtConRect[0] / 2.3, genKnbRect[1])
				);
				4.do({ |i|
					btnFTypes[i] = Button(conFilter,
						Rect(0, 0, filtBtnRect[0], filtBtnRect[1])
					);
				});
			}.value;

		}.value;//END (Declarations)


		//_____________STYLING//
		{
			var btnColors, txtFont;

			btnColors = [Color.black, Color.white, Color.white, Color.black];
			txtFont = Font(1, 10);

			//Top-Level Section
			{
				sfvWaveform.gridOn = false;
				drgOpenSound.string = "drop";
				txtRoot.font_(txtFont);
				txtRoot.string = "root";
				txtMixAmp.font_(txtFont);
				txtMixAmp.string = "amp";
				txtMixPan.font_(txtFont);
				txtMixPan.string = "pan";
				knbRoot.mode = \vert;
				knbMixAmp.mode = \vert;
				knbMixPan.mode = \vert;
				knbMixPan.centered = true;
				txtFade.font_(txtFont);
				txtFade.string = "fade";
				btnOpenSound.states = [
					["open", btnColors[0], btnColors[1]],
				];
				btnLoop.states = [
					["loop", btnColors[0], btnColors[1]],
					["loop", btnColors[2], btnColors[3]]
				];
				btnRev.states = [
					["reverse", btnColors[0], btnColors[1]],
					["reverse", btnColors[2], btnColors[3]]
				];
			}.value;


			//AmpEnv Section
			{
				txtAmpEnv.font_(txtFont);
				txtAmpEnv.string = "amp envelope";
			}.value;

			//Filter Section
			{
				var btnLabels = [\off, \lp, \hp, \bp];
				4.do({ |i|
					btnFTypes[i].states = [
						[btnLabels[i], btnColors[0], btnColors[1]],
						[btnLabels[i], btnColors[2], btnColors[3]]
					];
				});
				txtFCut.font_(txtFont);
				txtFCut.string = "cut";
				txtFRes.font_(txtFont);
				txtFRes.string = "res";
				knbFCut.mode = \vert;
				knbFRes.mode = \vert;

			}.value;

		}.value;//END (Styling)


		//_____________INITIATING VALUES
		{
			//
			knbRoot.value = 0.46875;
			knbMixAmp.value = param.mixAmp;
			knbMixPan.value = 0.5;
			slFade.value = 0.1;
			slAmpEnv[0].value = 0.01;
			slAmpEnv[1].value = 0.2;
			slAmpEnv[2].value = param.ampEnv[2];
			slAmpEnv[3].value = 0.2;
			btnFTypes[0].value = 1;
			knbFCut.value = 0.5;
			knbFRes.value = param.fRes;

		}.value;//END (Initiating Values)


		//_____________EVENTS//**********************

		//Open new Sound file
		f_openSound = { |path|
			var selectedSound = SoundFile.new;
			selectedSound.openRead(path);
			~bufSound = Buffer.read(s, path);
			sfvWaveform.soundfile = selectedSound;
			sfvWaveform.read.refresh;
			sfvWaveform.setSelectionStart(0, 0);
			sfvWaveform.setSelectionSize(0, selectedSound.numFrames);
			param.loopStart = 0;
			param.loopLength = selectedSound.numFrames;
		};
		btnOpenSound.action = {
			Dialog.openPanel(
				okFunc: { |path|
					f_openSound.value(path);
			});
		};
		drgOpenSound.receiveDragHandler = {
			f_openSound.value(View.currentDrag.value);
		};

		//Select new Loop
		sfvWaveform.mouseUpAction = { |obj|
			param.loopStart = obj.selection(0)[0];
			param.loopLength = obj.selection(0)[1];
		};

		//Activate Looping
		btnLoop.action = { |obj|
			param.loopOn = obj.value;
			synthSetup.value;
		};

		//Reverse
		btnRev.action = { |obj|
			param.rev = obj.value.linlin(0, 1, 1, -1);
			synthSetup.value;
		};

		//Change Root Note
		knbRoot.action = { |obj|
			param.root = 1 + ((1 - obj.value) * 126).round;
		};

		//Change Volume (mixAmp)
		knbMixAmp.action = { |obj|
			var val = obj.value;
			param.mixAmp = val;
			fxMixer.set(\amp, val);
		};

		//Change Pan
		knbMixPan.action = { |obj|
			var val = (obj.value * 2) - 1;
			param.mixPan = val;
			fxMixer.set(\pan, val);
		};

		//Change Fade
		slFade.action = { |obj|
			var val = (obj.value * 0.05);
			param.fade = val;
			~grpSource.set(\fade, val);
		};

		//Change Amp Envelope ADSR
		f_envValues = { |input, index|
			var val, ids = [
				\ampEnvA, \ampEnvD,
				\ampEnvS, \ampEnvR
			];
			val = ((input.pow(2.7) * 10) + 0.001);
			param.ampEnv[index] = val;
			~grpSource.set(ids[index], val);
		};
		slAmpEnv[0].action = { |obj|
			f_envValues.value(obj.value, 0).value;
		};
		slAmpEnv[1].action = { |obj|
			f_envValues.value(obj.value, 1).value;
		};
		slAmpEnv[2].action = { |obj|
			var val = obj.value.clip(0.001, 1);
			param.ampEnv[2] = val;
			~grpSource.set(\ampEnvS, val);
		};
		slAmpEnv[3].action = { |obj|
			f_envValues.value(obj.value, 3).value;
		};

		//Change Filter Cut
		knbFCut.action = { |obj|
			var val = (obj.value.pow(2.5) * 18000).clip(30, 18000);
			param.fCut = val;
			~grpSource.set(\fCut, val);
		};

		//Change Filter Res
		knbFRes.action = { |obj|
			var val = (1 - obj.value).clip(0.1, 1);
			param.fRes = val;
			~grpSource.set(\fRes, val);
		};

		//Change Filter Type
		f_filtTypes = { |index, type|
			if ( (btnFTypes[index].value == 1), {
				param.fType = type;
				4.do({ |i|
					if ( (i != index), {
						btnFTypes[i].value = 0;
					});
				});
			});
			synthSetup.value;
		};
		btnFTypes[0].action = {
			f_filtTypes.value(0, \off);
		};
		btnFTypes[1].action = {
			f_filtTypes.value(1, \lp);
		};
		btnFTypes[2].action = {
			f_filtTypes.value(2, \hp);
		};
		btnFTypes[3].action = {
			f_filtTypes.value(3, \bp);
		};

		//Close Main Window
		winMain.onClose = {
			s.freeAll;
			MIDIdef.freeAll;
		};

		//END (Events)

	};//END (guiControl)






	//**Initialize SynthDefs
	synthSetup = {

		//_________________________Sampler
		SynthDef(\synSampler, {
			|out, buf, transpose, vel = 0.5, fade,
			start, length, gate = 0, fCut, fRes,
			ampEnvA, ampEnvD, ampEnvS, ampEnvR|

			var sig, playback, ampEnv,
			rate, end, loop, rev, fType,
			ampWind = 1;

			loop = param.loopOn;
			rev = param.rev;
			fType = param.fType;
			transpose = transpose.midiratio;
			end = start + (length - 1);

			//One-shot or Loop
			if ( (loop == 0), {
				if( (rev == -1), {
					end = start;
					start = start + (length - 2);
				});
				rate = length / s.sampleRate / transpose;
				rate = BufRateScale.kr(buf) * rate;
				//Line for one-shot
				playback = Line.ar(start, end, rate);
			}, {
				rate = transpose;
				rate = BufRateScale.kr(buf) * rate * rev;
				//Phasor for loop
				playback = Phasor.ar(0, rate, start, end);

				//Window for stopping clicks
				rate = BufRateScale.kr(buf) * (length / s.sampleRate / transpose);
				ampWind = EnvGen.kr(
					Env.circle(
						[0, 1, 1, 0], [fade, rate - (fade * 2), fade], [-3, 0, 3]
				));
			});

			//ADSR Envelope
			ampEnv = EnvGen.kr(
				Env.adsr(ampEnvA, ampEnvD, ampEnvS, ampEnvR),
				gate, doneAction: 2
			);

			//Buffer playback
			sig = BufRd.ar(1, buf, playback, 0);
			sig = sig * ampEnv * ampWind * vel.linexp(1, 127, 0.01, 0.5);

			//Filter
			fCut = Ramp.kr(fCut, 0.1);
			fRes = Ramp.kr(fRes, 0.1);
			switch ( fType,
				\off, {"filterOff".postln;},
				\lp, {sig = RLPF.ar(sig, fCut, fRes);},
				\hp, {sig = RHPF.ar(sig, fCut, fRes);},
				\bp, {sig = Resonz.ar(sig, fCut, fRes);}
			);

			Out.ar(out, sig);

		}).add;//END (\synSampler)



		//________________________Mixer
		SynthDef(\fxMixer, {
			|in, out, amp, pan|
			var sig;

			sig = In.ar(in, 1);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);

		}).add;//END (\fxMixer)


	};//END (synthSetup)







	//**Initialize MIDIdefs
	midiSetup = {

		MIDIClient.init;
		MIDIIn.connectAll;

		//Note On
		MIDIdef.noteOn(\voiceOn, { |vel, note|

			//Make a Sample Playback
			param.activeVoices[note] = Synth(\synSampler, [
				\buf, ~bufSound,
				\gate, 1,
				\start, param.loopStart,
				\length, param.loopLength,
				\transpose, (note - param.root),
				\vel, vel,
				\fade, param.fade,
				\ampEnvA, param.ampEnv[0],
				\ampEnvD, param.ampEnv[1],
				\ampEnvS, param.ampEnv[2],
				\ampEnvR, param.ampEnv[3],
				\fCut, param.fCut,
				\fRes, param.fRes,
				\out, ~busMixer
			], ~grpSource);

		});//END (noteOn)


		//Note Off
		MIDIdef.noteOff(\voiceOff, { |vel, note|

			param.activeVoices[note].set(\gate, 0);
			param.activeVoices[note] = nil;

		});//END (noteOff)

	};//END (midiSetup)


	/*************************************
	*END (Function Definitions)
	*************************************/






	/*************************************
	*Function Evaluations
	*************************************/

	{
		globalSetup.value;
		guiControl.value;
		synthSetup.value;
		midiSetup.value;

		//Mixer Instance
		fxMixer = Synth(\fxMixer, [
			\in, ~busMixer,
			\out, 0,
			\amp, param.mixAmp,
			\pan, param.mixPan
		], ~grpFx);

	}.value;

	/*************************************
	*END (Function Evalutations)
	*************************************/


});//END (s.waitForBoot)

)
//END PROGRAM
