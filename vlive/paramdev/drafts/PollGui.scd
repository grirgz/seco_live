
ProtoTemplateDef(\PollGui, (
	asV

))

(
~pollgui = { arg ugen, label;
	var key;
	label = label ?? { ugen.class.asString };
	key = ( '/PollGui/'++label ).asSymbol;
	TagSpecDef(\PollGui_inputs).addUnique(key);
	SendReply.kr(Impulse.kr(WindowDef(\PollGui).proto.refreshRate ? 3), key, ugen);
	//SendReply.kr(Impulse.kr(3), ( '/PollGui'++label ).asSymbol.postln, ugen);
	//SendReply.kr(Impulse.kr(3), ( '/PollGui/'++label ).asSymbol.postln, ugen);
	//SendReply.kr(Impulse.kr(3), [ '/PollGui', label.asSymbol ], ugen);
	ugen;
};
)

(
Ndef(\testpollgui, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * ( SinOsc.kr(1) * 1 + 1 );
	~pollgui.(freq, "freq");
	sig = SinOsc.ar(freq) * 0.01;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
WindowDef(\PollGui, (
	refreshRate: { arg self;
		~refreshRate;
	},
	refreshRate_: { arg self, val;
		~refreshRate = val;
	},
	activateOsc: { arg self;
		self.refreshRate = self.refreshRate ? 5;
		self.data = IdentityDictionary.new;
		self.osclist = TagSpecDef(\PollGui_inputs).valueList.collect { arg oscpath;
			
			OSCdef(oscpath, { 
				//arg ...data;
				arg msg, time, addr, port;
				var data;
				data = msg[3];
				//data = msg;
				//data.debug("hello");
				self.data[oscpath] = data;
				self.data.changed(\set);
			}, oscpath).permanent_(true)
		};
	},

	freeOsc: { arg self;
		self.osclist.do { arg item, idx;
			item.free;
		};
		self.osclist = []
	},
	asView: { arg self, def;
		self.activateOsc;
		def.windowDo { arg win;
			win.alwaysOnTop_(true);
			win.onClose_({
				"freeOsc".debug;
				self.freeOsc;
			})
		};
		VLayout(

			HLayout (
				BasicButton.new.string_("Refresh").action_({
					def.front;
				}),
				BasicButton.new.string_("Clear").action_({
					TagSpecDef(\PollGui_inputs).clear;
					def.front;
				}),
			),
			Param(Message(self), \refreshRate, ControlSpec(0,10,\lin)).asView,
			GridLayout.rows(
				*TagSpecDef(\PollGui_inputs).valueList.collect { arg oscpath, idx;
					[
						StaticText.new.string_(oscpath.asString.replace("/PollGui/", "")),
						Param(self.data, oscpath, ControlSpec(-100000,100000)).asTextField,
					]

				};
			),
			nil
		)
	},

));
//WindowDef(\PollGui).proto.activateOsc;
WindowDef(\PollGui).front
)

TagSpecDef(\PollGui_inputs).list

SendReply

(
{
    SendReply.kr(Impulse.kr(3),
        '/the_answer',
        values: [[40, 80], [41, 56], 42, [43, 100, 200]],
        replyID: [1905, 1906, 1907, 1908]
    );
}.play(s);
)

OSCdef(\test,{ |msg| msg.postln  }, '/PollGui');
OSCdef.newMatching(\test,{ |msg| msg.postln  }, '/PollGui/fr?q');
OSCdef.newMatching(\test,{ |msg| msg.postln  }, '/PollGui/freq');
OSCdef(\test,{ |msg| msg.postln  }, '/PollGui/freq');

