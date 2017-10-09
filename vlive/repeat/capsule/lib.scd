(

SynthDef(\busgroup, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\playersec_fx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * SinOsc.ar(\amplfo.kr(8)).range(env1,1);
	sig = sig + FreqShift.ar(sig, SinOsc.kr(\shiftlfo.kr(4)).range(env2,1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
MenuSpecDef(\patkitdef_synthdefs).addUnique(\playersec_fx);

SynthDef(\playersec_hlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = LPF.ar(sig, \lpf.kr(19000));
	sig = HPF.ar(sig, \hpf.kr(40));
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\playersec_hlpf);
);


ParamProto.init;

FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");

FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("libdef/multifbdel.scd");
FileSystemProject.load("libdef/basicrecorder.scd");
FileSystemProject.load("libdef/rdngui.scd");
FileSystemProject.load("libdef/simplemixer.scd");
FileSystemProject.load("capsule/RDN_track1.scd");

///////////////////// control

(
	//~icon_map_param = { arg input, param;
		//var last = thisThread.beats;
		//input.action = { arg kn, val; 
			//var now = thisThread.beats;
			//if(now.isNil or: { ( now - last ).abs > 0.02 }) {
				//thisThread.beats.debug("beats");
				//param.normSet(kn.value);
				//last = now;
			//};
		//} 
	//};

	~icon_map_param = { arg input, param;
		input.action = { arg kn, val; 
			param.normSet(kn.value);
		} 
	};

	~startControl_mixer = {
		var k = MKtl('icon', "icon-icontrols");
		k[\sl].keep(8).do({ arg knob, idx; 
			~icon_map_param.(
				knob,
				ProtoDef(\simpleMixer).tracks[idx].asParam(\postfader)
			)
		});
		k[\kn].keep(8).do({ arg knob, idx; 
			~icon_map_param.(
				knob,
				ProtoDef(\simpleMixer).tracks[idx].asParam(\send1)
			)
		});

	};
	~startControl_rdn = {
		var k = MKtl('icon', "icon-icontrols");
		var params = [
			\fb,
			\delay,
			\delay2,
			\delay3,

			\distamp,
			\distamp2,
			\distamp3,
			\shiftmix,
			\shift,
		].collect({ arg key;
			Param(ProtoDef(\rdn).proxy, key)
		});
		//params = params ++ [ Param(s, \volume) ];
		params.do({ arg param, idx; 
			k[\sl][idx].action = { arg kn, val; 
				params[idx].normSet(kn.value)
			} 
		});
	};
	~startControl = {
		var k = MKtl('icon', "icon-icontrols");
		~startControl_mixer.();
		k[\tr][0][\on].action = {
			"Mixer mode".debug;
			~startControl_mixer.();
		};
		k[\tr][1][\on].action = {
			"Fx mode".debug;
			~startControl_rdn.();
		};
		k[\tr][3][\on].action = {
			"Edit mixer".debug;
			{ProtoDef(\simpleMixer).edit}.defer;
		};
		k[\tr][4][\on].action = {
			"Edit rdn".debug;
			{ProtoDef(\rdn).edit;}.defer;
		};

	};
);

// END

~startControl.();
