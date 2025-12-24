
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

// END


ParamProto.init
Document.current.path
(
[
"ddwCommon",
"wslib",
"crucial-library",
"Feedback",
"Modality-toolkit",
"Log",
"JITLibExtensions",
"WindowViewRecall",
"https://github.com/muellmusik/EQui",
].do { arg quark;
	Quarks.install(quark);
}
)


////////////////////////////////////////////////////////////////////

FileSystemProject.load("sndlib/synthbasic.scd")

 
NoteTimeline('simpleProject_mainTrackList.0.0score').eventList.select({ arg x; x.type != nil })
NoteTimeline('simpleProject_mainTrackList.4.0score').eventList.select({ arg x; x.type != nil })
NoteTimeline('simpleProject_mainTrackList.4.0score').eventList.setEndPosition(8)

TagSpecDef(\TrackList).list
TrackDef('simpleProject_mainTrackList').existingSections
TrackDef('simpleProject_mainTrackList').edit

TrackDef(\bla, \PlayerGrid).edit
TrackDef(\bla, \TrackList).edit

(
Pdef(\gurt, 
	Pbind(
		\instrument, \sh101,
	)
);
);
NoteTimeline(\bla, Pdef(\gurt)).edit
NoteTimeline(\bla).presetCompileString.editorInsert
(
NoteTimeline('bla').param = Param(Pdef('gurt'), 'midinote');
NoteTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.5, \midinote: 52.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 0.625, \dur: 0.5, \midinote: 63.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 1.125, \dur: 0.875, \midinote: 54.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.625, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
NoteTimeline('bla').automationRack.paramList = [ Param(Pdef('gurt'), 'lpf') ];
ParamTimeline('AutomationRack_noteTimeline_bla_lpf').param = Param(Pdef('gurt'), 'lpf');
ParamTimeline('AutomationRack_noteTimeline_bla_lpf').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.75, \legato: 1, \level: 32.615151071926, \next_absTime: 0.75, \next_level: 267.54083821989, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 0.75, \curve: 0.015498486271589, \dur: 0.75, \legato: 1, \level: 267.54083821989, \next_absTime: 1.5, \next_level: 17.347152156778, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 1.5, \curve: 0.0, \dur: 0.5, \legato: 1, \level: 17.347152156778, \next_absTime: 2.25, \next_level: 55.196566934989, \playDur: 0.5, \relDur: 0.5, \sustain: 0.75, ),
	(\absTime: 2.0, \dur: 0.25, \playDur: 0.25, \relDur: 0.25, \type: 'end', ),
	(\absTime: 2.25, \dur: 0, \legato: 1, \level: 55.196566934989, \playDur: 0, \relDur: 0, ),
]);
);
(
NoteTimeline('bla').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.375, \midinote: 49.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.5, ),
	(\absTime: 0.375, \curve: 0, \dur: 0.75, \lpf: 263.08769454137, \midinote: 56.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 1.125, \curve: 0, \dur: 0.875, \lpf: 236.81107035674, \midinote: 50.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.5, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

NoteTimeline('glu1_mainTrackList.3.0score').presetCompileString.editorInsert
(
NoteTimeline('glu1_mainTrackList.3.0score').param = Param(Pdef('glu1_mainTrackList.3.instr'), 'midinote');
NoteTimeline('glu1_mainTrackList.3.0score').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \clockTime: 943.15948641567, \dur: 0.0, \legato: 0.8, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.13745840587478, \velocity: 70, ),
	(\absTime: 0.0, \dur: 0.375, \label: 'start', \playDur: 0.375, \relDur: 0.375, \sustain: 0, \type: 'start', ),
	(\absTime: 0.375, \clockTime: 947.15532337179, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11446849400011, \velocity: 90, ),
	(\absTime: 0.625, \amp: 0.012389857236233, \clockTime: 947.39224816567, \curve: 0, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14820406475019, \velocity: 87, ),
	(\absTime: 0.875, \clockTime: 947.65556744917, \dur: 0.5, \legato: 0.8, \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13601822324995, \velocity: 100, ),
	(\absTime: 1.375, \clockTime: 948.13931975142, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11511014199993, \velocity: 81, ),
	(\absTime: 1.625, \clockTime: 948.38105675042, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1243902896249, \velocity: 87, ),
	(\absTime: 1.875, \clockTime: 948.65295838217, \dur: 0.5, \legato: 0.8, \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13537703025008, \velocity: 106, ),
	(\absTime: 2.375, \clockTime: 949.13064882004, \dur: 0.25, \legato: 0.8, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12515698125003, \velocity: 75, ),
	(\absTime: 2.625, \amp: 0.04059163970821, \clockTime: 949.37965598929, \curve: 0, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12932428512499, \velocity: 81, ),
	(\absTime: 2.875, \clockTime: 949.63551165142, \dur: 0.5, \legato: 0.8, \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.14479650850012, \velocity: 107, ),
	(\absTime: 3.375, \clockTime: 950.12397797942, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12850275812514, \velocity: 87, ),
	(\absTime: 3.625, \clockTime: 950.37647103142, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14541670324991, \velocity: 82, ),
	(\absTime: 3.875, \clockTime: 950.62222175692, \dur: 0.125, \legato: 0.8, \midinote: 67.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.15858748412495, \velocity: 99, ),
	(\absTime: 4.0, \clockTime: 947.15532337179, \dur: 0.0, \legato: 0.8, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.11446849400011, \velocity: 90, ),
	(\absTime: 4.0, \dur: 0.25, \label: 'end', \playDur: 0.25, \relDur: 0.25, \type: 'end', ),
	(\absTime: 4.25, \amp: 0.012389857236233, \clockTime: 947.39224816567, \curve: 0, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14820406475019, \velocity: 87, ),
	(\absTime: 4.5, \clockTime: 947.65556744917, \dur: 0.5, \legato: 0.8, \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13601822324995, \velocity: 100, ),
	(\absTime: 5.0, \clockTime: 948.13931975142, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11511014199993, \velocity: 81, ),
	(\absTime: 5.25, \clockTime: 948.38105675042, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1243902896249, \velocity: 87, ),
	(\absTime: 5.5, \clockTime: 948.65295838217, \dur: 0.5, \legato: 0.8, \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13537703025008, \velocity: 106, ),
	(\absTime: 6.0, \clockTime: 949.13064882004, \dur: 0.25, \legato: 0.8, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12515698125003, \velocity: 75, ),
	(\absTime: 6.25, \amp: 0.04059163970821, \clockTime: 949.37965598929, \curve: 0, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12932428512499, \velocity: 81, ),
	(\absTime: 6.5, \clockTime: 949.63551165142, \dur: 0.5, \legato: 0.8, \midinote: 67.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.14479650850012, \velocity: 107, ),
	(\absTime: 7.0, \clockTime: 950.12397797942, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12850275812514, \velocity: 87, ),
	(\absTime: 7.25, \clockTime: 950.37647103142, \dur: 0.25, \legato: 0.8, \midinote: 69.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14541670324991, \velocity: 82, ),
	(\absTime: 7.5, \clockTime: 950.62222175692, \dur: 0, \legato: 0.8, \midinote: 67.0, \playDur: 0, \relDur: 0, \sustain: 0.15858748412495, \velocity: 99, ),
]);
NoteTimeline('glu1_mainTrackList.3.0score').automationRack.paramList = [ Param(Pdef('glu1_mainTrackList.3.instr'), ('envamt' -> 'source')), Param(Pdef('glu1_mainTrackList.3.instr'), 'envamt') ];
ParamTimeline('AutomationRack_noteTimeline_glu1_mainTrackList.3.0score_envamt').param = Param(Pdef('glu1_mainTrackList.3.instr'), ('envamt' -> 'source'));
ParamTimeline('AutomationRack_noteTimeline_glu1_mainTrackList.3.0score_envamt').eventList = TimelineEventList.newFrom([
	(\absTime: -0.16889975395816, \dur: 0.16889975395816, \level: 20000.0, \next_absTime: 0.0, \next_level: 16.974552410423, \playDur: 0.16889975395816, \relDur: 0.16889975395816, \sustain: 0.16889975395816, ),
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.625, \legato: 1, \level: 16.974552410423, \next_absTime: 0.625, \next_level: 79.973296429443, \playDur: 0.625, \relDur: 0.625, \sustain: 0.625, ),
	(\absTime: 0.625, \curve: 0.18465047420209, \dur: 1.0, \legato: 1, \level: 79.973296429443, \next_absTime: 1.625, \next_level: 5.8480354764255, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 1.625, \curve: 0, \dur: 2.125, \level: 5.8480354764255, \next_absTime: 3.75, \next_level: 106.94488000534, \playDur: 2.125, \relDur: 2.125, \sustain: 2.125, ),
	(\absTime: 3.75, \dur: 0.3829804974171, \legato: 1, \level: 106.94488000534, \next_absTime: 4.1329804974171, \next_level: 79.165657543303, \playDur: 0.3829804974171, \relDur: 0.3829804974171, \sustain: 0.3829804974171, ),
	(\absTime: 4.1329804974171, \dur: 0.011352530874699, \level: 79.165657543303, \next_absTime: 4.1443330282918, \next_level: 72.187473130449, \playDur: 0.011352530874699, \relDur: 0.011352530874699, \sustain: 0.011352530874699, ),
	(\absTime: 4.1443330282918, \dur: 0.0046291297504002, \level: 72.187473130449, \next_absTime: 4.1489621580422, \next_level: 68.891456768169, \playDur: 0.0046291297504002, \relDur: 0.0046291297504002, \sustain: 0.0046291297504002, ),
	(\absTime: 4.1489621580422, \dur: 0.0069034026245998, \level: 68.891456768169, \next_absTime: 4.1558655606668, \next_level: 65.722666806785, \playDur: 0.0069034026245998, \relDur: 0.0069034026245998, \sustain: 0.0069034026245998, ),
	(\absTime: 4.1558655606668, \dur: 0.0070309977500003, \level: 65.722666806785, \next_absTime: 4.1628965584168, \next_level: 62.679623490162, \playDur: 0.0070309977500003, \relDur: 0.0070309977500003, \sustain: 0.0070309977500003, ),
	(\absTime: 4.1628965584168, \dur: 0.0069970451249999, \level: 62.679623490162, \next_absTime: 4.1698936035418, \next_level: 59.760572471516, \playDur: 0.0069970451249999, \relDur: 0.0069970451249999, \sustain: 0.0069970451249999, ),
	(\absTime: 4.1698936035418, \dur: 0.0069713428752003, \level: 59.760572471516, \next_absTime: 4.176864946417, \next_level: 54.286147553682, \playDur: 0.0069713428752003, \relDur: 0.0069713428752003, \sustain: 0.0069713428752003, ),
	(\absTime: 4.176864946417, \dur: 0.0346272254997, \level: 54.286147553682, \next_absTime: 4.2114921719167, \next_level: 26.357172556456, \playDur: 0.0346272254997, \relDur: 0.0346272254997, \sustain: 0.0346272254997, ),
	(\absTime: 4.2114921719167, \dur: 0.033452923875299, \level: 26.357172556456, \next_absTime: 4.244945095792, \next_level: 15.174272798445, \playDur: 0.033452923875299, \relDur: 0.033452923875299, \sustain: 0.033452923875299, ),
	(\absTime: 4.244945095792, \dur: 0.046705176875101, \level: 15.174272798445, \next_absTime: 4.2916502726671, \next_level: 14.500663423673, \playDur: 0.046705176875101, \relDur: 0.046705176875101, \sustain: 0.046705176875101, ),
	(\absTime: 4.2916502726671, \dur: 0.025193842624899, \level: 14.500663423673, \next_absTime: 4.316844115292, \next_level: 14.075389746678, \playDur: 0.025193842624899, \relDur: 0.025193842624899, \sustain: 0.025193842624899, ),
	(\absTime: 4.316844115292, \dur: 0.0140786992502, \level: 14.075389746678, \next_absTime: 4.3309228145422, \next_level: 13.668131287236, \playDur: 0.0140786992502, \relDur: 0.0140786992502, \sustain: 0.0140786992502, ),
	(\absTime: 4.3309228145422, \dur: 0.051563313375, \level: 13.668131287236, \next_absTime: 4.3824861279172, \next_level: 12.904356446641, \playDur: 0.051563313375, \relDur: 0.051563313375, \sustain: 0.051563313375, ),
	(\absTime: 4.3824861279172, \dur: 0.0395494128748, \level: 12.904356446641, \next_absTime: 4.422035540792, \next_level: 12.546279181472, \playDur: 0.0395494128748, \relDur: 0.0395494128748, \sustain: 0.0395494128748, ),
	(\absTime: 4.422035540792, \dur: 0.0993491826248, \level: 12.546279181472, \next_absTime: 4.5213847234168, \next_level: 11.874103344497, \playDur: 0.0993491826248, \relDur: 0.0993491826248, \sustain: 0.0993491826248, ),
	(\absTime: 4.5213847234168, \dur: 0.010913419125201, \level: 11.874103344497, \next_absTime: 4.532298142542, \next_level: 11.558647395989, \playDur: 0.010913419125201, \relDur: 0.010913419125201, \sustain: 0.010913419125201, ),
	(\absTime: 4.532298142542, \dur: 0.0019747533746992, \level: 11.558647395989, \next_absTime: 4.5342728959167, \next_level: 11.256093535021, \playDur: 0.0019747533746992, \relDur: 0.0019747533746992, \sustain: 0.0019747533746992, ),
	(\absTime: 4.5342728959167, \dur: 0.0066615710003006, \level: 11.256093535021, \next_absTime: 4.540934466917, \next_level: 10.965839815933, \playDur: 0.0066615710003006, \relDur: 0.0066615710003006, \sustain: 0.0066615710003006, ),
	(\absTime: 4.540934466917, \dur: 0.0139882181251, \level: 10.965839815933, \next_absTime: 4.5549226850421, \next_level: 10.687312846719, \playDur: 0.0139882181251, \relDur: 0.0139882181251, \sustain: 0.0139882181251, ),
	(\absTime: 4.5549226850421, \dur: 0.0069439518748, \level: 10.687312846719, \next_absTime: 4.5618666369169, \next_level: 10.41996661764, \playDur: 0.0069439518748, \relDur: 0.0069439518748, \sustain: 0.0069439518748, ),
	(\absTime: 4.5618666369169, \dur: 0.0374047712498, \level: 10.41996661764, \next_absTime: 4.5992714081667, \next_level: 8.8541439137705, \playDur: 0.0374047712498, \relDur: 0.0374047712498, \sustain: 0.0374047712498, ),
	(\absTime: 4.5992714081667, \dur: 0.033881848875399, \level: 8.8541439137705, \next_absTime: 4.6331532570421, \next_level: 8.4891028186035, \playDur: 0.033881848875399, \relDur: 0.033881848875399, \sustain: 0.033881848875399, ),
	(\absTime: 4.6331532570421, \dur: 0.052871944999801, \level: 8.4891028186035, \next_absTime: 4.6860252020419, \next_level: 7.6011331642801, \playDur: 0.052871944999801, \relDur: 0.052871944999801, \sustain: 0.052871944999801, ),
	(\absTime: 4.6860252020419, \dur: 0.0159171512501, \level: 7.6011331642801, \next_absTime: 4.701942353292, \next_level: 7.4513101200712, \playDur: 0.0159171512501, \relDur: 0.0159171512501, \sustain: 0.0159171512501, ),
	(\absTime: 4.701942353292, \dur: 0.0723673877501, \level: 7.4513101200712, \next_absTime: 4.7743097410421, \next_level: 7.5937576483149, \playDur: 0.0723673877501, \relDur: 0.0723673877501, \sustain: 0.0723673877501, ),
	(\absTime: 4.7743097410421, \dur: 0.0539697707495, \level: 7.5937576483149, \next_absTime: 4.8282795117916, \next_level: 7.446566914326, \playDur: 0.0539697707495, \relDur: 0.0539697707495, \sustain: 0.0539697707495, ),
	(\absTime: 4.8282795117916, \dur: 0.0893776100002, \level: 7.446566914326, \next_absTime: 4.9176571217918, \next_level: 8.1198050796713, \playDur: 0.0893776100002, \relDur: 0.0893776100002, \sustain: 0.0893776100002, ),
	(\absTime: 4.9176571217918, \dur: 0.0361295340003, \level: 8.1198050796713, \next_absTime: 4.9537866557921, \next_level: 9.5515390257717, \playDur: 0.0361295340003, \relDur: 0.0361295340003, \sustain: 0.0361295340003, ),
	(\absTime: 4.9537866557921, \dur: 0.0022390322497001, \level: 9.5515390257717, \next_absTime: 4.9560256880418, \next_level: 9.9774651603155, \playDur: 0.0022390322497001, \relDur: 0.0022390322497001, \sustain: 0.0022390322497001, ),
	(\absTime: 4.9560256880418, \dur: 0.0048794007503004, \level: 9.9774651603155, \next_absTime: 4.9609050887921, \next_level: 10.49461023491, \playDur: 0.0048794007503004, \relDur: 0.0048794007503004, \sustain: 0.0048794007503004, ),
	(\absTime: 4.9609050887921, \dur: 0.0069119478747997, \level: 10.49461023491, \next_absTime: 4.9678170366669, \next_level: 10.965839815933, \playDur: 0.0069119478747997, \relDur: 0.0069119478747997, \sustain: 0.0069119478747997, ),
	(\absTime: 4.9678170366669, \dur: 0.0070249865003005, \level: 10.965839815933, \next_absTime: 4.9748420231672, \next_level: 12.079428138813, \playDur: 0.0070249865003005, \relDur: 0.0070249865003005, \sustain: 0.0070249865003005, ),
	(\absTime: 4.9748420231672, \dur: 0.035381635624599, \level: 12.079428138813, \next_absTime: 5.0102236587918, \next_level: 19.088726691105, \playDur: 0.035381635624599, \relDur: 0.035381635624599, \sustain: 0.035381635624599, ),
	(\absTime: 5.0102236587918, \dur: 0.041568518249701, \level: 19.088726691105, \next_absTime: 5.0517921770415, \next_level: 27.043850145713, \playDur: 0.041568518249701, \relDur: 0.041568518249701, \sustain: 0.041568518249701, ),
	(\absTime: 5.0517921770415, \dur: 0.050757296625299, \level: 27.043850145713, \next_absTime: 5.1025494736668, \next_level: 28.75286256552, \playDur: 0.050757296625299, \relDur: 0.050757296625299, \sustain: 0.050757296625299, ),
	(\absTime: 5.1025494736668, \dur: 0.0954050702503, \level: 28.75286256552, \next_absTime: 5.1979545439171, \next_level: 16.813230563351, \playDur: 0.0954050702503, \relDur: 0.0954050702503, \sustain: 0.0954050702503, ),
	(\absTime: 5.1979545439171, \dur: 0.0032265519995001, \level: 16.813230563351, \next_absTime: 5.2011810959166, \next_level: 13.668131287236, \playDur: 0.0032265519995001, \relDur: 0.0032265519995001, \sustain: 0.0032265519995001, ),
	(\absTime: 5.2011810959166, \dur: 0.0047565253753001, \level: 13.668131287236, \next_absTime: 5.2059376212919, \next_level: 10.176533423869, \playDur: 0.0047565253753001, \relDur: 0.0047565253753001, \sustain: 0.0047565253753001, ),
	(\absTime: 5.2059376212919, \dur: 0.0070057855001, \level: 10.176533423869, \next_absTime: 5.212943406792, \next_level: 7.8531337499563, \playDur: 0.0070057855001, \relDur: 0.0070057855001, \sustain: 0.0070057855001, ),
	(\absTime: 5.212943406792, \dur: 0.0069040019997999, \level: 7.8531337499563, \next_absTime: 5.2198474087918, \next_level: 5.7561330097126, \playDur: 0.0069040019997999, \relDur: 0.0069040019997999, \sustain: 0.0069040019997999, ),
	(\absTime: 5.2198474087918, \dur: 0.0132000049998, \level: 5.7561330097126, \next_absTime: 5.2330474137916, \next_level: 4.8275455662088, \playDur: 0.0132000049998, \relDur: 0.0132000049998, \sustain: 0.0132000049998, ),
	(\absTime: 5.2330474137916, \dur: 0.0424268250004, \level: 4.8275455662088, \next_absTime: 5.275474238792, \next_level: 3.5995619315518, \playDur: 0.0424268250004, \relDur: 0.0424268250004, \sustain: 0.0424268250004, ),
	(\absTime: 5.275474238792, \dur: 0.0403914621251, \level: 3.5995619315518, \next_absTime: 5.3158657009171, \next_level: 3.466918155831, \playDur: 0.0403914621251, \relDur: 0.0403914621251, \sustain: 0.0403914621251, ),
	(\absTime: 5.3158657009171, \dur: 0.0256586487499, \level: 3.466918155831, \next_absTime: 5.341524349667, \next_level: 3.4255184364491, \playDur: 0.0256586487499, \relDur: 0.0256586487499, \sustain: 0.0256586487499, ),
	(\absTime: 5.341524349667, \dur: 0.1758459596249, \level: 3.4255184364491, \next_absTime: 5.5173703092919, \next_level: 3.466918155831, \playDur: 0.1758459596249, \relDur: 0.1758459596249, \sustain: 0.1758459596249, ),
	(\absTime: 5.5173703092919, \dur: 0.039574031875, \level: 3.466918155831, \next_absTime: 5.5569443411669, \next_level: 3.5538753163083, \playDur: 0.039574031875, \relDur: 0.039574031875, \sustain: 0.039574031875, ),
	(\absTime: 5.5569443411669, \dur: 0.0246797827499, \level: 3.5538753163083, \next_absTime: 5.5816241239168, \next_level: 3.5130307643362, \playDur: 0.0246797827499, \relDur: 0.0246797827499, \sustain: 0.0246797827499, ),
	(\absTime: 5.5816241239168, \dur: 0.0028726827504002, \level: 3.5130307643362, \next_absTime: 5.5844968066672, \next_level: 3.5165640342252, \playDur: 0.0028726827504002, \relDur: 0.0028726827504002, \sustain: 0.0028726827504002, ),
	(\absTime: 5.5844968066672, \dur: 0.0063889647495001, \level: 3.5165640342252, \next_absTime: 5.5908857714167, \next_level: 3.5202984964923, \playDur: 0.0063889647495001, \relDur: 0.0063889647495001, \sustain: 0.0063889647495001, ),
	(\absTime: 5.5908857714167, \dur: 0.0070745797501992, \level: 3.5202984964923, \next_absTime: 5.5979603511669, \next_level: 3.5685255656597, \playDur: 0.0070745797501992, \relDur: 0.0070745797501992, \sustain: 0.0070745797501992, ),
	(\absTime: 5.5979603511669, \dur: 0.0069427417497003, \level: 3.5685255656597, \next_absTime: 5.6049030929166, \next_level: 3.5739919302533, \playDur: 0.0069427417497003, \relDur: 0.0069427417497003, \sustain: 0.0069427417497003, ),
	(\absTime: 5.6049030929166, \dur: 0.0571688512505, \level: 3.5739919302533, \next_absTime: 5.6620719441671, \next_level: 3.9809309639524, \playDur: 0.0571688512505, \relDur: 0.0571688512505, \sustain: 0.0571688512505, ),
	(\absTime: 5.6620719441671, \dur: 0.0516015771245, \level: 3.9809309639524, \next_absTime: 5.7136735212916, \next_level: 5.2257573315761, \playDur: 0.0516015771245, \relDur: 0.0516015771245, \sustain: 0.0516015771245, ),
	(\absTime: 5.7136735212916, \dur: 0.0110951986253, \level: 5.2257573315761, \next_absTime: 5.7247687199169, \next_level: 5.505590908469, \playDur: 0.0110951986253, \relDur: 0.0110951986253, \sustain: 0.0110951986253, ),
	(\absTime: 5.7247687199169, \dur: 0.0061016095000994, \level: 5.505590908469, \next_absTime: 5.730870329417, \next_level: 5.6363557213929, \playDur: 0.0061016095000994, \relDur: 0.0061016095000994, \sustain: 0.0061016095000994, ),
	(\absTime: 5.730870329417, \dur: 0.0103156366249, \level: 5.6363557213929, \next_absTime: 5.7411859660419, \next_level: 5.7736698325828, \playDur: 0.0103156366249, \relDur: 0.0103156366249, \sustain: 0.0103156366249, ),
	(\absTime: 5.7411859660419, \dur: 0.0617179281249, \level: 5.7736698325828, \next_absTime: 5.8029038941668, \next_level: 10.693516821635, \playDur: 0.0617179281249, \relDur: 0.0617179281249, \sustain: 0.0617179281249, ),
	(\absTime: 5.8029038941668, \dur: 0.048471948, \level: 10.693516821635, \next_absTime: 5.8513758421668, \next_level: 20.277183842325, \playDur: 0.048471948, \relDur: 0.048471948, \sustain: 0.048471948, ),
	(\absTime: 5.8513758421668, \dur: 0.0055013525001995, \level: 20.277183842325, \next_absTime: 5.856877194667, \next_level: 22.30016451205, \playDur: 0.0055013525001995, \relDur: 0.0055013525001995, \sustain: 0.0055013525001995, ),
	(\absTime: 5.856877194667, \dur: 0.015762954374701, \level: 22.30016451205, \next_absTime: 5.8726401490417, \next_level: 25.78309580675, \playDur: 0.015762954374701, \relDur: 0.015762954374701, \sustain: 0.015762954374701, ),
	(\absTime: 5.8726401490417, \dur: 0.0614170007502, \level: 25.78309580675, \next_absTime: 5.9340571497919, \next_level: 27.103858896994, \playDur: 0.0614170007502, \relDur: 0.0614170007502, \sustain: 0.0614170007502, ),
	(\absTime: 5.9340571497919, \dur: 0.0545444567497, \level: 27.103858896994, \next_absTime: 5.9886016065416, \next_level: 33.79980955135, \playDur: 0.0545444567497, \relDur: 0.0545444567497, \sustain: 0.0545444567497, ),
	(\absTime: 5.9886016065416, \dur: 0.0117587627501, \level: 33.79980955135, \next_absTime: 6.0003603692917, \next_level: 35.31096227035, \playDur: 0.0117587627501, \relDur: 0.0117587627501, \sustain: 0.0117587627501, ),
	(\absTime: 6.0003603692917, \dur: 0.1400096591251, \level: 35.31096227035, \next_absTime: 6.1403700284168, \next_level: 33.959087516333, \playDur: 0.1400096591251, \relDur: 0.1400096591251, \sustain: 0.1400096591251, ),
	(\absTime: 6.1403700284168, \dur: 0.04407427675, \level: 33.959087516333, \next_absTime: 6.1844443051668, \next_level: 25.491894869545, \playDur: 0.04407427675, \relDur: 0.04407427675, \sustain: 0.04407427675, ),
	(\absTime: 6.1844443051668, \dur: 0.0296811865001, \level: 25.491894869545, \next_absTime: 6.2141254916669, \next_level: 19.710811419868, \playDur: 0.0296811865001, \relDur: 0.0296811865001, \sustain: 0.0296811865001, ),
	(\absTime: 6.2141254916669, \dur: 0.0067970148751995, \level: 19.710811419868, \next_absTime: 6.2209225065421, \next_level: 18.419672846378, \playDur: 0.0067970148751995, \relDur: 0.0067970148751995, \sustain: 0.0067970148751995, ),
	(\absTime: 6.2209225065421, \dur: 0.0069648774997999, \level: 18.419672846378, \next_absTime: 6.2278873840419, \next_level: 16.443912941744, \playDur: 0.0069648774997999, \relDur: 0.0069648774997999, \sustain: 0.0069648774997999, ),
	(\absTime: 6.2278873840419, \dur: 0.0071063265000006, \level: 16.443912941744, \next_absTime: 6.2349937105419, \next_level: 14.937134834067, \playDur: 0.0071063265000006, \relDur: 0.0071063265000006, \sustain: 0.0071063265000006, ),
	(\absTime: 6.2349937105419, \dur: 0.064059534, \level: 14.937134834067, \next_absTime: 6.2990532445419, \next_level: 9.0420572030713, \playDur: 0.064059534, \relDur: 0.064059534, \sustain: 0.064059534, ),
	(\absTime: 6.2990532445419, \dur: 0.0550653022502, \level: 9.0420572030713, \next_absTime: 6.3541185467921, \next_level: 6.5850846448019, \playDur: 0.0550653022502, \relDur: 0.0550653022502, \sustain: 0.0550653022502, ),
	(\absTime: 6.3541185467921, \dur: 0.012107732, \level: 6.5850846448019, \next_absTime: 6.3662262787921, \next_level: 6.3266730721066, \playDur: 0.012107732, \relDur: 0.012107732, \sustain: 0.012107732, ),
	(\absTime: 6.3662262787921, \dur: 0.0021590773749001, \level: 6.3266730721066, \next_absTime: 6.368385356167, \next_level: 6.0873687794618, \playDur: 0.0021590773749001, \relDur: 0.0021590773749001, \sustain: 0.0021590773749001, ),
	(\absTime: 6.368385356167, \dur: 0.0772600438749, \level: 6.0873687794618, \next_absTime: 6.4456454000419, \next_level: 5.0141402220389, \playDur: 0.0772600438749, \relDur: 0.0772600438749, \sustain: 0.0772600438749, ),
	(\absTime: 6.4456454000419, \dur: 0.0563331860003, \level: 5.0141402220389, \next_absTime: 6.5019785860422, \next_level: 4.4307129802456, \playDur: 0.0563331860003, \relDur: 0.0563331860003, \sustain: 0.0563331860003, ),
	(\absTime: 6.5019785860422, \dur: 0.0128536493749, \level: 4.4307129802456, \next_absTime: 6.5148322354171, \next_level: 4.3383800321298, \playDur: 0.0128536493749, \relDur: 0.0128536493749, \sustain: 0.0128536493749, ),
	(\absTime: 6.5148322354171, \dur: 0.0071663252496998, \level: 4.3383800321298, \next_absTime: 6.5219985606668, \next_level: 4.2803926891956, \playDur: 0.0071663252496998, \relDur: 0.0071663252496998, \sustain: 0.0071663252496998, ),
	(\absTime: 6.5219985606668, \dur: 0.0692468253751, \level: 4.2803926891956, \next_absTime: 6.5912453860419, \next_level: 4.2241985241933, \playDur: 0.0692468253751, \relDur: 0.0692468253751, \sustain: 0.0692468253751, ),
	(\absTime: 6.5912453860419, \dur: 0.0528041902499, \level: 4.2241985241933, \next_absTime: 6.6440495762918, \next_level: 3.6447694480364, \playDur: 0.0528041902499, \relDur: 0.0528041902499, \sustain: 0.0528041902499, ),
	(\absTime: 6.6440495762918, \dur: 0.0561413387499, \level: 3.6447694480364, \next_absTime: 6.7001909150417, \next_level: 3.6935420758714, \playDur: 0.0561413387499, \relDur: 0.0561413387499, \sustain: 0.0561413387499, ),
	(\absTime: 6.7001909150417, \dur: 0.0511941202504, \level: 3.6935420758714, \next_absTime: 6.7513850352921, \next_level: 4.0855226203102, \playDur: 0.0511941202504, \relDur: 0.0511941202504, \sustain: 0.0511941202504, ),
	(\absTime: 6.7513850352921, \dur: 0.0118684711246, \level: 4.0855226203102, \next_absTime: 6.7632535064167, \next_level: 4.4229856764816, \playDur: 0.0118684711246, \relDur: 0.0118684711246, \sustain: 0.0118684711246, ),
	(\absTime: 6.7632535064167, \dur: 0.0035818930000993, \level: 4.4229856764816, \next_absTime: 6.7668353994168, \next_level: 4.4896768212763, \playDur: 0.0035818930000993, \relDur: 0.0035818930000993, \sustain: 0.0035818930000993, ),
	(\absTime: 6.7668353994168, \dur: 0.0687650888749, \level: 4.4896768212763, \next_absTime: 6.8356004882917, \next_level: 5.3907277707901, \playDur: 0.0687650888749, \relDur: 0.0687650888749, \sustain: 0.0687650888749, ),
	(\absTime: 6.8356004882917, \dur: 0.057851024875101, \level: 5.3907277707901, \next_absTime: 6.8934515131668, \next_level: 7.6333750281207, \playDur: 0.057851024875101, \relDur: 0.057851024875101, \sustain: 0.057851024875101, ),
	(\absTime: 6.8934515131668, \dur: 0.1604075410001, \level: 7.6333750281207, \next_absTime: 7.0538590541669, \next_level: 7.4720117162532, \playDur: 0.1604075410001, \relDur: 0.1604075410001, \sustain: 0.1604075410001, ),
	(\absTime: 7.0538590541669, \dur: 0.053621560124999, \level: 7.4720117162532, \next_absTime: 7.1074806142919, \next_level: 7.6248736318065, \playDur: 0.053621560124999, \relDur: 0.053621560124999, \sustain: 0.053621560124999, ),
	(\absTime: 7.1074806142919, \dur: 0.0619254256253, \level: 7.6248736318065, \next_absTime: 7.1694060399172, \next_level: 7.4665584410976, \playDur: 0.0619254256253, \relDur: 0.0619254256253, \sustain: 0.0619254256253, ),
	(\absTime: 7.1694060399172, \dur: 0.0732263717496, \level: 7.4665584410976, \next_absTime: 7.2426324116668, \next_level: 6.7649449096799, \playDur: 0.0732263717496, \relDur: 0.0732263717496, \sustain: 0.0732263717496, ),
	(\absTime: 7.2426324116668, \dur: 0.0568832057497, \level: 6.7649449096799, \next_absTime: 7.2995156174165, \next_level: 4.4307129802456, \playDur: 0.0568832057497, \relDur: 0.0568832057497, \sustain: 0.0568832057497, ),
	(\absTime: 7.2995156174165, \dur: 0.0143463302502, \level: 4.4307129802456, \next_absTime: 7.3138619476667, \next_level: 4.2570410385727, \playDur: 0.0143463302502, \relDur: 0.0143463302502, \sustain: 0.0143463302502, ),
	(\absTime: 7.3138619476667, \dur: 0.0691224476255, \level: 4.2570410385727, \next_absTime: 7.3829843952922, \next_level: 3.920803841116, \playDur: 0.0691224476255, \relDur: 0.0691224476255, \sustain: 0.0691224476255, ),
	(\absTime: 7.3829843952922, \dur: 0.0627914332494, \level: 3.920803841116, \next_absTime: 7.4457758285416, \next_level: 3.1620523262648, \playDur: 0.0627914332494, \relDur: 0.0627914332494, \sustain: 0.0627914332494, ),
	(\absTime: 7.4457758285416, \dur: 0.0082792193753001, \level: 3.1620523262648, \next_absTime: 7.4540550479169, \next_level: 3.0452683948439, \playDur: 0.0082792193753001, \relDur: 0.0082792193753001, \sustain: 0.0082792193753001, ),
	(\absTime: 7.4540550479169, \dur: 0.0715590435002, \level: 3.0452683948439, \next_absTime: 7.5256140914171, \next_level: 2.7889394440798, \playDur: 0.0715590435002, \relDur: 0.0715590435002, \sustain: 0.0715590435002, ),
	(\absTime: 7.5256140914171, \dur: 0.062027202124701, \level: 2.7889394440798, \next_absTime: 7.5876412935418, \next_level: 2.7155612171917, \playDur: 0.062027202124701, \relDur: 0.062027202124701, \sustain: 0.062027202124701, ),
	(\absTime: 7.5876412935418, \dur: 0.1063279875002, \level: 2.7155612171917, \next_absTime: 7.693969281042, \next_level: 4.1129764943707, \playDur: 0.1063279875002, \relDur: 0.1063279875002, \sustain: 0.1063279875002, ),
	(\absTime: 7.693969281042, \dur: 0.0117826546247, \level: 4.1129764943707, \next_absTime: 7.7057519356667, \next_level: 4.4667909598569, \playDur: 0.0117826546247, \relDur: 0.0117826546247, \sustain: 0.0117826546247, ),
	(\absTime: 7.7057519356667, \dur: 0.05365403925, \level: 4.4667909598569, \next_absTime: 7.7594059749167, \next_level: 5.6229913450515, \playDur: 0.05365403925, \relDur: 0.05365403925, \sustain: 0.05365403925, ),
	(\absTime: 7.7594059749167, \dur: 0.05625101125, \level: 5.6229913450515, \next_absTime: 7.8156569861667, \next_level: 6.5574830951939, \playDur: 0.05625101125, \relDur: 0.05625101125, \sustain: 0.05625101125, ),
	(\absTime: 7.8156569861667, \dur: 0.0675484538751, \level: 6.5574830951939, \next_absTime: 7.8832054400418, \next_level: 7.4332426046093, \playDur: 0.0675484538751, \relDur: 0.0675484538751, \sustain: 0.0675484538751, ),
	(\absTime: 7.8832054400418, \dur: 0.079081889250101, \level: 7.4332426046093, \next_absTime: 7.9622873292919, \next_level: 7.573062405163, \playDur: 0.079081889250101, \relDur: 0.079081889250101, \sustain: 0.079081889250101, ),
	(\absTime: 7.9622873292919, \dur: 0.0377126707081, \level: 7.573062405163, \next_absTime: 8.031983055917, \next_level: 8.3289001944633, \playDur: 0.0377126707081, \relDur: 0.0377126707081, \sustain: 0.069695726625099, ),
	(\absTime: 8.0, \dur: 0.031983055916999, \label: 'end', \playDur: 0.031983055916999, \relDur: 0.031983055916999, \type: 'end', ),
	(\absTime: 8.031983055917, \dur: 0.1428135983751, \level: 8.3289001944633, \next_absTime: 8.1747966542921, \next_level: 8.165767014055, \playDur: 0.1428135983751, \relDur: 0.1428135983751, \sustain: 0.1428135983751, ),
	(\absTime: 8.1747966542921, \dur: 0.0570879382499, \level: 8.165767014055, \next_absTime: 8.231884592542, \next_level: 7.8559563832373, \playDur: 0.0570879382499, \relDur: 0.0570879382499, \sustain: 0.0570879382499, ),
	(\absTime: 8.231884592542, \dur: 0.0400933881246, \level: 7.8559563832373, \next_absTime: 8.2719779806666, \next_level: 7.2960661310086, \playDur: 0.0400933881246, \relDur: 0.0400933881246, \sustain: 0.0400933881246, ),
	(\absTime: 8.2719779806666, \dur: 0.078804499375099, \level: 7.2960661310086, \next_absTime: 8.3507824800417, \next_level: 4.6432746128987, \playDur: 0.078804499375099, \relDur: 0.078804499375099, \sustain: 0.078804499375099, ),
	(\absTime: 8.3507824800417, \dur: 0.066197306875001, \level: 4.6432746128987, \next_absTime: 8.4169797869167, \next_level: 3.9277899199377, \playDur: 0.066197306875001, \relDur: 0.066197306875001, \sustain: 0.066197306875001, ),
	(\absTime: 8.4169797869167, \dur: 0.115876579875, \level: 3.9277899199377, \next_absTime: 8.5328563667917, \next_level: 3.323850227923, \playDur: 0.115876579875, \relDur: 0.115876579875, \sustain: 0.115876579875, ),
	(\absTime: 8.5328563667917, \dur: 0.0362344692499, \level: 3.323850227923, \next_absTime: 8.5690908360416, \next_level: 3.1211193252004, \playDur: 0.0362344692499, \relDur: 0.0362344692499, \sustain: 0.0362344692499, ),
	(\absTime: 8.5690908360416, \dur: 0.1374832523752, \level: 3.1211193252004, \next_absTime: 8.7065740884168, \next_level: 3.1707276284123, \playDur: 0.1374832523752, \relDur: 0.1374832523752, \sustain: 0.1374832523752, ),
	(\absTime: 8.7065740884168, \dur: 0.0063338003751987, \level: 3.1707276284123, \next_absTime: 8.712907888792, \next_level: 3.1990770076156, \playDur: 0.0063338003751987, \relDur: 0.0063338003751987, \sustain: 0.0063338003751987, ),
	(\absTime: 8.712907888792, \dur: 0.0561085603749, \level: 3.1990770076156, \next_absTime: 8.7690164491669, \next_level: 3.4881260425874, \playDur: 0.0561085603749, \relDur: 0.0561085603749, \sustain: 0.0561085603749, ),
	(\absTime: 8.7690164491669, \dur: 0.0552276838753, \level: 3.4881260425874, \next_absTime: 8.8242441330422, \next_level: 4.6991388887251, \playDur: 0.0552276838753, \relDur: 0.0552276838753, \sustain: 0.0552276838753, ),
	(\absTime: 8.8242441330422, \dur: 0.07129381, \level: 4.6991388887251, \next_absTime: 8.8955379430422, \next_level: 5.2450747038106, \playDur: 0.07129381, \relDur: 0.07129381, \sustain: 0.07129381, ),
	(\absTime: 8.8955379430422, \dur: 0.1249025417496, \level: 5.2450747038106, \next_absTime: 9.0204404847918, \next_level: 6.8253352492452, \playDur: 0.1249025417496, \relDur: 0.1249025417496, \sustain: 0.1249025417496, ),
	(\absTime: 9.0204404847918, \dur: 0.031115588874899, \level: 6.8253352492452, \next_absTime: 9.0515560736667, \next_level: 7.1673811220216, \playDur: 0.031115588874899, \relDur: 0.031115588874899, \sustain: 0.031115588874899, ),
	(\absTime: 9.0515560736667, \dur: 0.043792609875201, \level: 7.1673811220216, \next_absTime: 9.0953486835419, \next_level: 7.286864218198, \playDur: 0.043792609875201, \relDur: 0.043792609875201, \sustain: 0.043792609875201, ),
	(\absTime: 9.0953486835419, \dur: 0.0790064642497, \level: 7.286864218198, \next_absTime: 9.1743551477916, \next_level: 7.7847909757777, \playDur: 0.0790064642497, \relDur: 0.0790064642497, \sustain: 0.0790064642497, ),
	(\absTime: 9.1743551477916, \dur: 0.074490552500301, \level: 7.7847909757777, \next_absTime: 9.2488457002919, \next_level: 7.9199690336067, \playDur: 0.074490552500301, \relDur: 0.074490552500301, \sustain: 0.074490552500301, ),
	(\absTime: 9.2488457002919, \dur: 0.081334683499799, \level: 7.9199690336067, \next_absTime: 9.3301803837917, \next_level: 8.0594007414777, \playDur: 0.081334683499799, \relDur: 0.081334683499799, \sustain: 0.081334683499799, ),
	(\absTime: 9.3301803837917, \dur: 0.1770843550002, \level: 8.0594007414777, \next_absTime: 9.5072647387919, \next_level: 5.8188029614992, \playDur: 0.1770843550002, \relDur: 0.1770843550002, \sustain: 0.1770843550002, ),
	(\absTime: 9.5072647387919, \dur: 0.0990588068753, \level: 5.8188029614992, \next_absTime: 9.6063235456672, \next_level: 4.7448718862075, \playDur: 0.0990588068753, \relDur: 0.0990588068753, \sustain: 0.0990588068753, ),
	(\absTime: 9.6063235456672, \dur: 0.0581821974998, \level: 4.7448718862075, \next_absTime: 9.664505743167, \next_level: 4.5769369458935, \playDur: 0.0581821974998, \relDur: 0.0581821974998, \sustain: 0.0581821974998, ),
	(\absTime: 9.664505743167, \dur: 0.043396614624699, \level: 4.5769369458935, \next_absTime: 9.7079023577917, \next_level: 3.8823868389027, \playDur: 0.043396614624699, \relDur: 0.043396614624699, \sustain: 0.043396614624699, ),
	(\absTime: 9.7079023577917, \dur: 0.0798424121253, \level: 3.8823868389027, \next_absTime: 9.787744769917, \next_level: 2.9815682297201, \playDur: 0.0798424121253, \relDur: 0.0798424121253, \sustain: 0.0798424121253, ),
	(\absTime: 9.787744769917, \dur: 0.077875589750001, \level: 2.9815682297201, \next_absTime: 9.865620359667, \next_level: 2.5434350116485, \playDur: 0.077875589750001, \relDur: 0.077875589750001, \sustain: 0.077875589750001, ),
	(\absTime: 9.865620359667, \dur: 0.084102452, \level: 2.5434350116485, \next_absTime: 9.949722811667, \next_level: 2.3415950017859, \playDur: 0.084102452, \relDur: 0.084102452, \sustain: 0.084102452, ),
	(\absTime: 9.949722811667, \dur: 0.078167271, \level: 2.3415950017859, \next_absTime: 10.027890082667, \next_level: 2.0334234358548, \playDur: 0.078167271, \relDur: 0.078167271, \sustain: 0.078167271, ),
	(\absTime: 10.027890082667, \dur: 0.084055894125001, \level: 2.0334234358548, \next_absTime: 10.111945976792, \next_level: 1.9490463948011, \playDur: 0.084055894125001, \relDur: 0.084055894125001, \sustain: 0.084055894125001, ),
	(\absTime: 10.111945976792, \dur: 0.078800098124999, \level: 1.9490463948011, \next_absTime: 10.190746074917, \next_level: 1.6964364317214, \playDur: 0.078800098124999, \relDur: 0.078800098124999, \sustain: 0.078800098124999, ),
	(\absTime: 10.190746074917, \dur: 0.11652775225, \level: 1.6964364317214, \next_absTime: 10.307273827167, \next_level: 1.6414253801979, \playDur: 0.11652775225, \relDur: 0.11652775225, \sustain: 0.11652775225, ),
	(\absTime: 10.307273827167, \dur: 0.037057750624999, \level: 1.6414253801979, \next_absTime: 10.344331577792, \next_level: 1.5699797738238, \playDur: 0.037057750624999, \relDur: 0.037057750624999, \sustain: 0.037057750624999, ),
	(\absTime: 10.344331577792, \dur: 0.041547755375001, \level: 1.5699797738238, \next_absTime: 10.385879333167, \next_level: 1.5396328804973, \playDur: 0.041547755375001, \relDur: 0.041547755375001, \sustain: 0.041547755375001, ),
	(\absTime: 10.385879333167, \dur: 0.083479356624999, \level: 1.5396328804973, \next_absTime: 10.469358689792, \next_level: 1.5798369967593, \playDur: 0.083479356624999, \relDur: 0.083479356624999, \sustain: 0.083479356624999, ),
	(\absTime: 10.469358689792, \dur: 0.078324036000001, \level: 1.5798369967593, \next_absTime: 10.547682725792, \next_level: 1.8513561459916, \playDur: 0.078324036000001, \relDur: 0.078324036000001, \sustain: 0.078324036000001, ),
	(\absTime: 10.547682725792, \dur: 0.13234300975, \level: 1.8513561459916, \next_absTime: 10.680025735542, \next_level: 2.2213709612372, \playDur: 0.13234300975, \relDur: 0.13234300975, \sustain: 0.13234300975, ),
	(\absTime: 10.680025735542, \dur: 0.03465101325, \level: 2.2213709612372, \next_absTime: 10.714676748792, \next_level: 2.2661221429384, \playDur: 0.03465101325, \relDur: 0.03465101325, \sustain: 0.03465101325, ),
	(\absTime: 10.714676748792, \dur: 0.044786738500001, \level: 2.2661221429384, \next_absTime: 10.759463487292, \next_level: 2.3104997899106, \playDur: 0.044786738500001, \relDur: 0.044786738500001, \sustain: 0.044786738500001, ),
	(\absTime: 10.759463487292, \dur: 0.086659048874999, \level: 2.3104997899106, \next_absTime: 10.846122536167, \next_level: 2.3695337712273, \playDur: 0.086659048874999, \relDur: 0.086659048874999, \sustain: 0.086659048874999, ),
	(\absTime: 10.846122536167, \dur: 0.07743839075, \level: 2.3695337712273, \next_absTime: 10.923560926917, \next_level: 2.3795332310013, \playDur: 0.07743839075, \relDur: 0.07743839075, \sustain: 0.07743839075, ),
	(\absTime: 10.923560926917, \dur: 0.087062094, \level: 2.3795332310013, \next_absTime: 11.010623020917, \next_level: 2.574747632612, \playDur: 0.087062094, \relDur: 0.087062094, \sustain: 0.087062094, ),
	(\absTime: 11.010623020917, \dur: 0.08045100875, \level: 2.574747632612, \next_absTime: 11.091074029667, \next_level: 2.8553886125228, \playDur: 0.08045100875, \relDur: 0.08045100875, \sustain: 0.08045100875, ),
	(\absTime: 11.091074029667, \dur: 0.122192268625, \level: 2.8553886125228, \next_absTime: 11.213266298292, \next_level: 2.9798427305949, \playDur: 0.122192268625, \relDur: 0.122192268625, \sustain: 0.122192268625, ),
	(\absTime: 11.213266298292, \dur: 0.034619641000001, \level: 2.9798427305949, \next_absTime: 11.247885939292, \next_level: 3.1129377891381, \playDur: 0.034619641000001, \relDur: 0.034619641000001, \sustain: 0.034619641000001, ),
	(\absTime: 11.247885939292, \dur: 0.047495920499999, \level: 3.1129377891381, \next_absTime: 11.295381859792, \next_level: 3.1953385233806, \playDur: 0.047495920499999, \relDur: 0.047495920499999, \sustain: 0.047495920499999, ),
	(\absTime: 11.295381859792, \dur: 0.08836117675, \level: 3.1953385233806, \next_absTime: 11.383743036542, \next_level: 3.3636931468591, \playDur: 0.08836117675, \relDur: 0.08836117675, \sustain: 0.08836117675, ),
	(\absTime: 11.383743036542, \dur: 0.07411399275, \level: 3.3636931468591, \next_absTime: 11.457857029292, \next_level: 3.6878712818026, \playDur: 0.07411399275, \relDur: 0.07411399275, \sustain: 0.07411399275, ),
	(\absTime: 11.457857029292, \dur: 0.132130912375, \level: 3.6878712818026, \next_absTime: 11.589987941667, \next_level: 4.3152523028922, \playDur: 0.132130912375, \relDur: 0.132130912375, \sustain: 0.132130912375, ),
	(\absTime: 11.589987941667, \dur: 0.036828143625002, \level: 4.3152523028922, \next_absTime: 11.626816085292, \next_level: 5.2174860439982, \playDur: 0.036828143625002, \relDur: 0.036828143625002, \sustain: 0.036828143625002, ),
	(\absTime: 11.626816085292, \dur: 0.047129350624999, \level: 5.2174860439982, \next_absTime: 11.673945435917, \next_level: 5.8925675921252, \playDur: 0.047129350624999, \relDur: 0.047129350624999, \sustain: 0.047129350624999, ),
	(\absTime: 11.673945435917, \dur: 0.087582184375, \level: 5.8925675921252, \next_absTime: 11.761527620292, \next_level: 7.9402457312694, \playDur: 0.087582184375, \relDur: 0.087582184375, \sustain: 0.087582184375, ),
	(\absTime: 11.761527620292, \dur: 0.08401916425, \level: 7.9402457312694, \next_absTime: 11.845546784542, \next_level: 10.55624659837, \playDur: 0.08401916425, \relDur: 0.08401916425, \sustain: 0.08401916425, ),
	(\absTime: 11.845546784542, \dur: 0.089213576375, \level: 10.55624659837, \next_absTime: 11.934760360917, \next_level: 12.038462875703, \playDur: 0.089213576375, \relDur: 0.089213576375, \sustain: 0.089213576375, ),
	(\absTime: 11.934760360917, \dur: 0.076686271374999, \level: 12.038462875703, \next_absTime: 12.011446632292, \next_level: 16.344265276051, \playDur: 0.076686271374999, \relDur: 0.076686271374999, \sustain: 0.076686271374999, ),
	(\absTime: 12.011446632292, \dur: 0.135039564625, \level: 16.344265276051, \next_absTime: 12.146486196917, \next_level: 16.68815464649, \playDur: 0.135039564625, \relDur: 0.135039564625, \sustain: 0.135039564625, ),
	(\absTime: 12.146486196917, \dur: 0.039993545375001, \level: 16.68815464649, \next_absTime: 12.186479742292, \next_level: 16.513262987395, \playDur: 0.039993545375001, \relDur: 0.039993545375001, \sustain: 0.039993545375001, ),
	(\absTime: 12.186479742292, \dur: 0.044538090625, \level: 16.513262987395, \next_absTime: 12.231017832917, \next_level: 15.312540604632, \playDur: 0.044538090625, \relDur: 0.044538090625, \sustain: 0.044538090625, ),
	(\absTime: 12.231017832917, \dur: 0.092322138124999, \level: 15.312540604632, \next_absTime: 12.323339971042, \next_level: 13.0581221838, \playDur: 0.092322138124999, \relDur: 0.092322138124999, \sustain: 0.092322138124999, ),
	(\absTime: 12.323339971042, \dur: 0.082135855374, \level: 13.0581221838, \next_absTime: 12.405475826416, \next_level: 10.405431316043, \playDur: 0.082135855374, \relDur: 0.082135855374, \sustain: 0.082135855374, ),
	(\absTime: 12.405475826416, \dur: 0.139228498501, \level: 10.405431316043, \next_absTime: 12.544704324917, \next_level: 8.6334055959171, \playDur: 0.139228498501, \relDur: 0.139228498501, \sustain: 0.139228498501, ),
	(\absTime: 12.544704324917, \dur: 0.037342984, \level: 8.6334055959171, \next_absTime: 12.582047308917, \next_level: 8.0254363529018, \playDur: 0.037342984, \relDur: 0.037342984, \sustain: 0.037342984, ),
	(\absTime: 12.582047308917, \dur: 0.048978106625, \level: 8.0254363529018, \next_absTime: 12.631025415542, \next_level: 7.2455174172123, \playDur: 0.048978106625, \relDur: 0.048978106625, \sustain: 0.048978106625, ),
	(\absTime: 12.631025415542, \dur: 0.093741463375, \level: 7.2455174172123, \next_absTime: 12.724766878917, \next_level: 6.3959297042265, \playDur: 0.093741463375, \relDur: 0.093741463375, \sustain: 0.093741463375, ),
	(\absTime: 12.724766878917, \dur: 0.0857120705, \level: 6.3959297042265, \next_absTime: 12.810478949417, \next_level: 5.8754140931863, \playDur: 0.0857120705, \relDur: 0.0857120705, \sustain: 0.0857120705, ),
	(\absTime: 12.810478949417, \dur: 0.137117283625, \level: 5.8754140931863, \next_absTime: 12.947596233042, \next_level: 5.7710405934845, \playDur: 0.137117283625, \relDur: 0.137117283625, \sustain: 0.137117283625, ),
	(\absTime: 12.947596233042, \dur: 0.039100123124999, \level: 5.7710405934845, \next_absTime: 12.986696356167, \next_level: 5.5732369046908, \playDur: 0.039100123124999, \relDur: 0.039100123124999, \sustain: 0.039100123124999, ),
	(\absTime: 12.986696356167, \dur: 0.04672339875, \level: 5.5732369046908, \next_absTime: 13.033419754917, \next_level: 5.4673407574819, \playDur: 0.04672339875, \relDur: 0.04672339875, \sustain: 0.04672339875, ),
	(\absTime: 13.033419754917, \dur: 0.134107411375, \level: 5.4673407574819, \next_absTime: 13.167527166292, \next_level: 5.938581952821, \playDur: 0.134107411375, \relDur: 0.134107411375, \sustain: 0.134107411375, ),
	(\absTime: 13.167527166292, \dur: 0.044132477374999, \level: 5.938581952821, \next_absTime: 13.211659643667, \next_level: 6.7515990437724, \playDur: 0.044132477374999, \relDur: 0.044132477374999, \sustain: 0.044132477374999, ),
	(\absTime: 13.211659643667, \dur: 0.095737136249999, \level: 6.7515990437724, \next_absTime: 13.307396779917, \next_level: 7.3876803986935, \playDur: 0.095737136249999, \relDur: 0.095737136249999, \sustain: 0.095737136249999, ),
	(\absTime: 13.307396779917, \dur: 0.082477128125001, \level: 7.3876803986935, \next_absTime: 13.389873908042, \next_level: 7.9314236423195, \playDur: 0.082477128125001, \relDur: 0.082477128125001, \sustain: 0.082477128125001, ),
	(\absTime: 13.389873908042, \dur: 0.093653168874999, \level: 7.9314236423195, \next_absTime: 13.483527076917, \next_level: 9.0696772231138, \playDur: 0.093653168874999, \relDur: 0.093653168874999, \sustain: 0.093653168874999, ),
	(\absTime: 13.483527076917, \dur: 0.085867712875, \level: 9.0696772231138, \next_absTime: 13.569394789792, \next_level: 9.6635122439078, \playDur: 0.085867712875, \relDur: 0.085867712875, \sustain: 0.085867712875, ),
	(\absTime: 13.569394789792, \dur: 0.12831337925, \level: 9.6635122439078, \next_absTime: 13.697708169042, \next_level: 11.170003993029, \playDur: 0.12831337925, \relDur: 0.12831337925, \sustain: 0.12831337925, ),
	(\absTime: 13.697708169042, \dur: 0.042392343874999, \level: 11.170003993029, \next_absTime: 13.740100512917, \next_level: 13.712518874376, \playDur: 0.042392343874999, \relDur: 0.042392343874999, \sustain: 0.042392343874999, ),
	(\absTime: 13.740100512917, \dur: 0.0768148255, \level: 13.712518874376, \next_absTime: 13.816915338417, \next_level: 15.598708969924, \playDur: 0.0768148255, \relDur: 0.0768148255, \sustain: 0.0768148255, ),
	(\absTime: 13.816915338417, \dur: 0.045807899375001, \level: 15.598708969924, \next_absTime: 13.862723237792, \next_level: 17.223043612618, \playDur: 0.045807899375001, \relDur: 0.045807899375001, \sustain: 0.045807899375001, ),
	(\absTime: 13.862723237792, \dur: 0.113031107875, \level: 17.223043612618, \next_absTime: 13.975754345667, \next_level: 18.309618291562, \playDur: 0.113031107875, \relDur: 0.113031107875, \sustain: 0.113031107875, ),
	(\absTime: 13.975754345667, \dur: 0.048561579500001, \level: 18.309618291562, \next_absTime: 14.024315925167, \next_level: 32.22498243029, \playDur: 0.048561579500001, \relDur: 0.048561579500001, \sustain: 0.048561579500001, ),
	(\absTime: 14.024315925167, \dur: 0.10032948625, \level: 32.22498243029, \next_absTime: 14.124645411417, \next_level: 45.881759930106, \playDur: 0.10032948625, \relDur: 0.10032948625, \sustain: 0.10032948625, ),
	(\absTime: 14.124645411417, \dur: 0.040729659250001, \level: 45.881759930106, \next_absTime: 14.165375070667, \next_level: 45.964791791151, \playDur: 0.040729659250001, \relDur: 0.040729659250001, \sustain: 0.040729659250001, ),
	(\absTime: 14.165375070667, \dur: 0.077901729499999, \level: 45.964791791151, \next_absTime: 14.243276800167, \next_level: 34.552794382258, \playDur: 0.077901729499999, \relDur: 0.077901729499999, \sustain: 0.077901729499999, ),
	(\absTime: 14.243276800167, \dur: 0.039396945875001, \level: 34.552794382258, \next_absTime: 14.282673746042, \next_level: 23.560808224571, \playDur: 0.039396945875001, \relDur: 0.039396945875001, \sustain: 0.039396945875001, ),
	(\absTime: 14.282673746042, \dur: 0.07959871325, \level: 23.560808224571, \next_absTime: 14.362272459292, \next_level: 16.964377625486, \playDur: 0.07959871325, \relDur: 0.07959871325, \sustain: 0.07959871325, ),
	(\absTime: 14.362272459292, \dur: 0.040583281375, \level: 16.964377625486, \next_absTime: 14.402855740667, \next_level: 10.030107631971, \playDur: 0.040583281375, \relDur: 0.040583281375, \sustain: 0.040583281375, ),
	(\absTime: 14.402855740667, \dur: 0.084368088874999, \level: 10.030107631971, \next_absTime: 14.487223829542, \next_level: 6.4769396346717, \playDur: 0.084368088874999, \relDur: 0.084368088874999, \sustain: 0.084368088874999, ),
	(\absTime: 14.487223829542, \dur: 0.048411681500001, \level: 6.4769396346717, \next_absTime: 14.535635511042, \next_level: 4.1678751285469, \playDur: 0.048411681500001, \relDur: 0.048411681500001, \sustain: 0.048411681500001, ),
	(\absTime: 14.535635511042, \dur: 0.098264779374999, \level: 4.1678751285469, \next_absTime: 14.633900290417, \next_level: 3.7463104057641, \playDur: 0.098264779374999, \relDur: 0.098264779374999, \sustain: 0.098264779374999, ),
	(\absTime: 14.633900290417, \dur: 0.047849048625, \level: 3.7463104057641, \next_absTime: 14.681749339042, \next_level: 3.1240345488512, \playDur: 0.047849048625, \relDur: 0.047849048625, \sustain: 0.047849048625, ),
	(\absTime: 14.681749339042, \dur: 0.079922887625001, \level: 3.1240345488512, \next_absTime: 14.761672226667, \next_level: 3.0344822328617, \playDur: 0.079922887625001, \relDur: 0.079922887625001, \sustain: 0.079922887625001, ),
	(\absTime: 14.761672226667, \dur: 0.12093444825, \level: 3.0344822328617, \next_absTime: 14.882606674917, \next_level: 3.1717649192277, \playDur: 0.12093444825, \relDur: 0.12093444825, \sustain: 0.12093444825, ),
	(\absTime: 14.882606674917, \dur: 0.039736662875001, \level: 3.1717649192277, \next_absTime: 14.922343337792, \next_level: 3.5057371276229, \playDur: 0.039736662875001, \relDur: 0.039736662875001, \sustain: 0.039736662875001, ),
	(\absTime: 14.922343337792, \dur: 0.079587095875, \level: 3.5057371276229, \next_absTime: 15.001930433667, \next_level: 3.6331487824515, \playDur: 0.079587095875, \relDur: 0.079587095875, \sustain: 0.079587095875, ),
	(\absTime: 15.001930433667, \dur: 0.039264393, \level: 3.6331487824515, \next_absTime: 15.041194826667, \next_level: 4.3729034751466, \playDur: 0.039264393, \relDur: 0.039264393, \sustain: 0.039264393, ),
	(\absTime: 15.041194826667, \dur: 0.08153336625, \level: 4.3729034751466, \next_absTime: 15.122728192917, \next_level: 5.4195976713269, \playDur: 0.08153336625, \relDur: 0.08153336625, \sustain: 0.08153336625, ),
	(\absTime: 15.122728192917, \dur: 0.042973612499999, \level: 5.4195976713269, \next_absTime: 15.165701805417, \next_level: 6.1254918586551, \playDur: 0.042973612499999, \relDur: 0.042973612499999, \sustain: 0.042973612499999, ),
	(\absTime: 15.165701805417, \dur: 0.081648763875, \level: 6.1254918586551, \next_absTime: 15.247350569292, \next_level: 6.2187597431516, \playDur: 0.081648763875, \relDur: 0.081648763875, \sustain: 0.081648763875, ),
	(\absTime: 15.247350569292, \dur: 0.082995812375001, \level: 6.2187597431516, \next_absTime: 15.330346381667, \next_level: 7.4630300876063, \playDur: 0.082995812375001, \relDur: 0.082995812375001, \sustain: 0.082995812375001, ),
	(\absTime: 15.330346381667, \dur: 0.19076779225, \level: 7.4630300876063, \next_absTime: 15.521114173917, \next_level: 6.9778876827257, \playDur: 0.19076779225, \relDur: 0.19076779225, \sustain: 0.19076779225, ),
	(\absTime: 15.521114173917, \dur: 0.117557300875, \level: 6.9778876827257, \next_absTime: 15.638671474792, \next_level: 3.8858787954641, \playDur: 0.117557300875, \relDur: 0.117557300875, \sustain: 0.117557300875, ),
	(\absTime: 15.638671474792, \dur: 0.071555929375, \level: 3.8858787954641, \next_absTime: 15.710227404167, \next_level: 3.1224524393393, \playDur: 0.071555929375, \relDur: 0.071555929375, \sustain: 0.071555929375, ),
	(\absTime: 15.710227404167, \dur: 0.052320772874999, \level: 3.1224524393393, \next_absTime: 15.762548177042, \next_level: 2.8478996387564, \playDur: 0.052320772874999, \relDur: 0.052320772874999, \sustain: 0.052320772874999, ),
	(\absTime: 15.762548177042, \dur: 0.105892418624, \level: 2.8478996387564, \next_absTime: 15.868440595666, \next_level: 2.1586472556698, \playDur: 0.105892418624, \relDur: 0.105892418624, \sustain: 0.105892418624, ),
	(\absTime: 15.868440595666, \dur: 0.118769245876, \level: 2.1586472556698, \next_absTime: 15.987209841542, \next_level: 2.1049792677687, \playDur: 0.118769245876, \relDur: 0.118769245876, \sustain: 0.118769245876, ),
	(\absTime: 15.987209841542, \dur: 0, \level: 2.1049792677687, \playDur: 0, \relDur: 0, ),
]);ParamTimeline('AutomationRack_noteTimeline_glu1_mainTrackList.3.0score_envamt').param = Param(Pdef('glu1_mainTrackList.3.instr'), ('envamt' -> 'source'));
ParamTimeline('AutomationRack_noteTimeline_glu1_mainTrackList.3.0score_envamt').eventList = TimelineEventList.newFrom([
	(\absTime: -0.16889975395816, \dur: 0.16889975395816, \level: 20000.0, \next_absTime: 0.0, \next_level: 16.974552410423, \playDur: 0.16889975395816, \relDur: 0.16889975395816, \sustain: 0.16889975395816, ),
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.625, \legato: 1, \level: 16.974552410423, \next_absTime: 0.625, \next_level: 79.973296429443, \playDur: 0.625, \relDur: 0.625, \sustain: 0.625, ),
	(\absTime: 0.625, \curve: 0.18465047420209, \dur: 1.0, \legato: 1, \level: 79.973296429443, \next_absTime: 1.625, \next_level: 5.8480354764255, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 1.625, \curve: 0, \dur: 2.125, \level: 5.8480354764255, \next_absTime: 3.75, \next_level: 106.94488000534, \playDur: 2.125, \relDur: 2.125, \sustain: 2.125, ),
	(\absTime: 3.75, \dur: 0.3829804974171, \legato: 1, \level: 106.94488000534, \next_absTime: 4.1329804974171, \next_level: 79.165657543303, \playDur: 0.3829804974171, \relDur: 0.3829804974171, \sustain: 0.3829804974171, ),
	(\absTime: 4.1329804974171, \dur: 0.011352530874699, \level: 79.165657543303, \next_absTime: 4.1443330282918, \next_level: 72.187473130449, \playDur: 0.011352530874699, \relDur: 0.011352530874699, \sustain: 0.011352530874699, ),
	(\absTime: 4.1443330282918, \dur: 0.0046291297504002, \level: 72.187473130449, \next_absTime: 4.1489621580422, \next_level: 68.891456768169, \playDur: 0.0046291297504002, \relDur: 0.0046291297504002, \sustain: 0.0046291297504002, ),
	(\absTime: 4.1489621580422, \dur: 0.0069034026245998, \level: 68.891456768169, \next_absTime: 4.1558655606668, \next_level: 65.722666806785, \playDur: 0.0069034026245998, \relDur: 0.0069034026245998, \sustain: 0.0069034026245998, ),
	(\absTime: 4.1558655606668, \dur: 0.0070309977500003, \level: 65.722666806785, \next_absTime: 4.1628965584168, \next_level: 62.679623490162, \playDur: 0.0070309977500003, \relDur: 0.0070309977500003, \sustain: 0.0070309977500003, ),
	(\absTime: 4.1628965584168, \dur: 0.0069970451249999, \level: 62.679623490162, \next_absTime: 4.1698936035418, \next_level: 59.760572471516, \playDur: 0.0069970451249999, \relDur: 0.0069970451249999, \sustain: 0.0069970451249999, ),
	(\absTime: 4.1698936035418, \dur: 0.0069713428752003, \level: 59.760572471516, \next_absTime: 4.176864946417, \next_level: 54.286147553682, \playDur: 0.0069713428752003, \relDur: 0.0069713428752003, \sustain: 0.0069713428752003, ),
	(\absTime: 4.176864946417, \dur: 0.0346272254997, \level: 54.286147553682, \next_absTime: 4.2114921719167, \next_level: 26.357172556456, \playDur: 0.0346272254997, \relDur: 0.0346272254997, \sustain: 0.0346272254997, ),
	(\absTime: 4.2114921719167, \dur: 0.033452923875299, \level: 26.357172556456, \next_absTime: 4.244945095792, \next_level: 15.174272798445, \playDur: 0.033452923875299, \relDur: 0.033452923875299, \sustain: 0.033452923875299, ),
	(\absTime: 4.244945095792, \dur: 0.046705176875101, \level: 15.174272798445, \next_absTime: 4.2916502726671, \next_level: 14.500663423673, \playDur: 0.046705176875101, \relDur: 0.046705176875101, \sustain: 0.046705176875101, ),
	(\absTime: 4.2916502726671, \dur: 0.025193842624899, \level: 14.500663423673, \next_absTime: 4.316844115292, \next_level: 14.075389746678, \playDur: 0.025193842624899, \relDur: 0.025193842624899, \sustain: 0.025193842624899, ),
	(\absTime: 4.316844115292, \dur: 0.0140786992502, \level: 14.075389746678, \next_absTime: 4.3309228145422, \next_level: 13.668131287236, \playDur: 0.0140786992502, \relDur: 0.0140786992502, \sustain: 0.0140786992502, ),
	(\absTime: 4.3309228145422, \dur: 0.051563313375, \level: 13.668131287236, \next_absTime: 4.3824861279172, \next_level: 12.904356446641, \playDur: 0.051563313375, \relDur: 0.051563313375, \sustain: 0.051563313375, ),
	(\absTime: 4.3824861279172, \dur: 0.0395494128748, \level: 12.904356446641, \next_absTime: 4.422035540792, \next_level: 12.546279181472, \playDur: 0.0395494128748, \relDur: 0.0395494128748, \sustain: 0.0395494128748, ),
	(\absTime: 4.422035540792, \dur: 0.0993491826248, \level: 12.546279181472, \next_absTime: 4.5213847234168, \next_level: 11.874103344497, \playDur: 0.0993491826248, \relDur: 0.0993491826248, \sustain: 0.0993491826248, ),
	(\absTime: 4.5213847234168, \dur: 0.010913419125201, \level: 11.874103344497, \next_absTime: 4.532298142542, \next_level: 11.558647395989, \playDur: 0.010913419125201, \relDur: 0.010913419125201, \sustain: 0.010913419125201, ),
	(\absTime: 4.532298142542, \dur: 0.0019747533746992, \level: 11.558647395989, \next_absTime: 4.5342728959167, \next_level: 11.256093535021, \playDur: 0.0019747533746992, \relDur: 0.0019747533746992, \sustain: 0.0019747533746992, ),
	(\absTime: 4.5342728959167, \dur: 0.0066615710003006, \level: 11.256093535021, \next_absTime: 4.540934466917, \next_level: 10.965839815933, \playDur: 0.0066615710003006, \relDur: 0.0066615710003006, \sustain: 0.0066615710003006, ),
	(\absTime: 4.540934466917, \dur: 0.0139882181251, \level: 10.965839815933, \next_absTime: 4.5549226850421, \next_level: 10.687312846719, \playDur: 0.0139882181251, \relDur: 0.0139882181251, \sustain: 0.0139882181251, ),
	(\absTime: 4.5549226850421, \dur: 0.0069439518748, \level: 10.687312846719, \next_absTime: 4.5618666369169, \next_level: 10.41996661764, \playDur: 0.0069439518748, \relDur: 0.0069439518748, \sustain: 0.0069439518748, ),
	(\absTime: 4.5618666369169, \dur: 0.0374047712498, \level: 10.41996661764, \next_absTime: 4.5992714081667, \next_level: 8.8541439137705, \playDur: 0.0374047712498, \relDur: 0.0374047712498, \sustain: 0.0374047712498, ),
	(\absTime: 4.5992714081667, \dur: 0.033881848875399, \level: 8.8541439137705, \next_absTime: 4.6331532570421, \next_level: 8.4891028186035, \playDur: 0.033881848875399, \relDur: 0.033881848875399, \sustain: 0.033881848875399, ),
	(\absTime: 4.6331532570421, \dur: 0.052871944999801, \level: 8.4891028186035, \next_absTime: 4.6860252020419, \next_level: 7.6011331642801, \playDur: 0.052871944999801, \relDur: 0.052871944999801, \sustain: 0.052871944999801, ),
	(\absTime: 4.6860252020419, \dur: 0.0159171512501, \level: 7.6011331642801, \next_absTime: 4.701942353292, \next_level: 7.4513101200712, \playDur: 0.0159171512501, \relDur: 0.0159171512501, \sustain: 0.0159171512501, ),
	(\absTime: 4.701942353292, \dur: 0.0723673877501, \level: 7.4513101200712, \next_absTime: 4.7743097410421, \next_level: 7.5937576483149, \playDur: 0.0723673877501, \relDur: 0.0723673877501, \sustain: 0.0723673877501, ),
	(\absTime: 4.7743097410421, \dur: 0.0539697707495, \level: 7.5937576483149, \next_absTime: 4.8282795117916, \next_level: 7.446566914326, \playDur: 0.0539697707495, \relDur: 0.0539697707495, \sustain: 0.0539697707495, ),
	(\absTime: 4.8282795117916, \dur: 0.0893776100002, \level: 7.446566914326, \next_absTime: 4.9176571217918, \next_level: 8.1198050796713, \playDur: 0.0893776100002, \relDur: 0.0893776100002, \sustain: 0.0893776100002, ),
	(\absTime: 4.9176571217918, \dur: 0.0361295340003, \level: 8.1198050796713, \next_absTime: 4.9537866557921, \next_level: 9.5515390257717, \playDur: 0.0361295340003, \relDur: 0.0361295340003, \sustain: 0.0361295340003, ),
	(\absTime: 4.9537866557921, \dur: 0.0022390322497001, \level: 9.5515390257717, \next_absTime: 4.9560256880418, \next_level: 9.9774651603155, \playDur: 0.0022390322497001, \relDur: 0.0022390322497001, \sustain: 0.0022390322497001, ),
	(\absTime: 4.9560256880418, \dur: 0.0048794007503004, \level: 9.9774651603155, \next_absTime: 4.9609050887921, \next_level: 10.49461023491, \playDur: 0.0048794007503004, \relDur: 0.0048794007503004, \sustain: 0.0048794007503004, ),
	(\absTime: 4.9609050887921, \dur: 0.0069119478747997, \level: 10.49461023491, \next_absTime: 4.9678170366669, \next_level: 10.965839815933, \playDur: 0.0069119478747997, \relDur: 0.0069119478747997, \sustain: 0.0069119478747997, ),
	(\absTime: 4.9678170366669, \dur: 0.0070249865003005, \level: 10.965839815933, \next_absTime: 4.9748420231672, \next_level: 12.079428138813, \playDur: 0.0070249865003005, \relDur: 0.0070249865003005, \sustain: 0.0070249865003005, ),
	(\absTime: 4.9748420231672, \dur: 0.035381635624599, \level: 12.079428138813, \next_absTime: 5.0102236587918, \next_level: 19.088726691105, \playDur: 0.035381635624599, \relDur: 0.035381635624599, \sustain: 0.035381635624599, ),
	(\absTime: 5.0102236587918, \dur: 0.041568518249701, \level: 19.088726691105, \next_absTime: 5.0517921770415, \next_level: 27.043850145713, \playDur: 0.041568518249701, \relDur: 0.041568518249701, \sustain: 0.041568518249701, ),
	(\absTime: 5.0517921770415, \dur: 0.050757296625299, \level: 27.043850145713, \next_absTime: 5.1025494736668, \next_level: 28.75286256552, \playDur: 0.050757296625299, \relDur: 0.050757296625299, \sustain: 0.050757296625299, ),
	(\absTime: 5.1025494736668, \dur: 0.0954050702503, \level: 28.75286256552, \next_absTime: 5.1979545439171, \next_level: 16.813230563351, \playDur: 0.0954050702503, \relDur: 0.0954050702503, \sustain: 0.0954050702503, ),
	(\absTime: 5.1979545439171, \dur: 0.0032265519995001, \level: 16.813230563351, \next_absTime: 5.2011810959166, \next_level: 13.668131287236, \playDur: 0.0032265519995001, \relDur: 0.0032265519995001, \sustain: 0.0032265519995001, ),
	(\absTime: 5.2011810959166, \dur: 0.0047565253753001, \level: 13.668131287236, \next_absTime: 5.2059376212919, \next_level: 10.176533423869, \playDur: 0.0047565253753001, \relDur: 0.0047565253753001, \sustain: 0.0047565253753001, ),
	(\absTime: 5.2059376212919, \dur: 0.0070057855001, \level: 10.176533423869, \next_absTime: 5.212943406792, \next_level: 7.8531337499563, \playDur: 0.0070057855001, \relDur: 0.0070057855001, \sustain: 0.0070057855001, ),
	(\absTime: 5.212943406792, \dur: 0.0069040019997999, \level: 7.8531337499563, \next_absTime: 5.2198474087918, \next_level: 5.7561330097126, \playDur: 0.0069040019997999, \relDur: 0.0069040019997999, \sustain: 0.0069040019997999, ),
	(\absTime: 5.2198474087918, \dur: 0.0132000049998, \level: 5.7561330097126, \next_absTime: 5.2330474137916, \next_level: 4.8275455662088, \playDur: 0.0132000049998, \relDur: 0.0132000049998, \sustain: 0.0132000049998, ),
	(\absTime: 5.2330474137916, \dur: 0.0424268250004, \level: 4.8275455662088, \next_absTime: 5.275474238792, \next_level: 3.5995619315518, \playDur: 0.0424268250004, \relDur: 0.0424268250004, \sustain: 0.0424268250004, ),
	(\absTime: 5.275474238792, \dur: 0.0403914621251, \level: 3.5995619315518, \next_absTime: 5.3158657009171, \next_level: 3.466918155831, \playDur: 0.0403914621251, \relDur: 0.0403914621251, \sustain: 0.0403914621251, ),
	(\absTime: 5.3158657009171, \dur: 0.0256586487499, \level: 3.466918155831, \next_absTime: 5.341524349667, \next_level: 3.4255184364491, \playDur: 0.0256586487499, \relDur: 0.0256586487499, \sustain: 0.0256586487499, ),
	(\absTime: 5.341524349667, \dur: 0.1758459596249, \level: 3.4255184364491, \next_absTime: 5.5173703092919, \next_level: 3.466918155831, \playDur: 0.1758459596249, \relDur: 0.1758459596249, \sustain: 0.1758459596249, ),
	(\absTime: 5.5173703092919, \dur: 0.039574031875, \level: 3.466918155831, \next_absTime: 5.5569443411669, \next_level: 3.5538753163083, \playDur: 0.039574031875, \relDur: 0.039574031875, \sustain: 0.039574031875, ),
	(\absTime: 5.5569443411669, \dur: 0.0246797827499, \level: 3.5538753163083, \next_absTime: 5.5816241239168, \next_level: 3.5130307643362, \playDur: 0.0246797827499, \relDur: 0.0246797827499, \sustain: 0.0246797827499, ),
	(\absTime: 5.5816241239168, \dur: 0.0028726827504002, \level: 3.5130307643362, \next_absTime: 5.5844968066672, \next_level: 3.5165640342252, \playDur: 0.0028726827504002, \relDur: 0.0028726827504002, \sustain: 0.0028726827504002, ),
	(\absTime: 5.5844968066672, \dur: 0.0063889647495001, \level: 3.5165640342252, \next_absTime: 5.5908857714167, \next_level: 3.5202984964923, \playDur: 0.0063889647495001, \relDur: 0.0063889647495001, \sustain: 0.0063889647495001, ),
	(\absTime: 5.5908857714167, \dur: 0.0070745797501992, \level: 3.5202984964923, \next_absTime: 5.5979603511669, \next_level: 3.5685255656597, \playDur: 0.0070745797501992, \relDur: 0.0070745797501992, \sustain: 0.0070745797501992, ),
	(\absTime: 5.5979603511669, \dur: 0.0069427417497003, \level: 3.5685255656597, \next_absTime: 5.6049030929166, \next_level: 3.5739919302533, \playDur: 0.0069427417497003, \relDur: 0.0069427417497003, \sustain: 0.0069427417497003, ),
	(\absTime: 5.6049030929166, \dur: 0.0571688512505, \level: 3.5739919302533, \next_absTime: 5.6620719441671, \next_level: 3.9809309639524, \playDur: 0.0571688512505, \relDur: 0.0571688512505, \sustain: 0.0571688512505, ),
	(\absTime: 5.6620719441671, \dur: 0.0516015771245, \level: 3.9809309639524, \next_absTime: 5.7136735212916, \next_level: 5.2257573315761, \playDur: 0.0516015771245, \relDur: 0.0516015771245, \sustain: 0.0516015771245, ),
	(\absTime: 5.7136735212916, \dur: 0.0110951986253, \level: 5.2257573315761, \next_absTime: 5.7247687199169, \next_level: 5.505590908469, \playDur: 0.0110951986253, \relDur: 0.0110951986253, \sustain: 0.0110951986253, ),
	(\absTime: 5.7247687199169, \dur: 0.0061016095000994, \level: 5.505590908469, \next_absTime: 5.730870329417, \next_level: 5.6363557213929, \playDur: 0.0061016095000994, \relDur: 0.0061016095000994, \sustain: 0.0061016095000994, ),
	(\absTime: 5.730870329417, \dur: 0.0103156366249, \level: 5.6363557213929, \next_absTime: 5.7411859660419, \next_level: 5.7736698325828, \playDur: 0.0103156366249, \relDur: 0.0103156366249, \sustain: 0.0103156366249, ),
	(\absTime: 5.7411859660419, \dur: 0.0617179281249, \level: 5.7736698325828, \next_absTime: 5.8029038941668, \next_level: 10.693516821635, \playDur: 0.0617179281249, \relDur: 0.0617179281249, \sustain: 0.0617179281249, ),
	(\absTime: 5.8029038941668, \dur: 0.048471948, \level: 10.693516821635, \next_absTime: 5.8513758421668, \next_level: 20.277183842325, \playDur: 0.048471948, \relDur: 0.048471948, \sustain: 0.048471948, ),
	(\absTime: 5.8513758421668, \dur: 0.0055013525001995, \level: 20.277183842325, \next_absTime: 5.856877194667, \next_level: 22.30016451205, \playDur: 0.0055013525001995, \relDur: 0.0055013525001995, \sustain: 0.0055013525001995, ),
	(\absTime: 5.856877194667, \dur: 0.015762954374701, \level: 22.30016451205, \next_absTime: 5.8726401490417, \next_level: 25.78309580675, \playDur: 0.015762954374701, \relDur: 0.015762954374701, \sustain: 0.015762954374701, ),
	(\absTime: 5.8726401490417, \dur: 0.0614170007502, \level: 25.78309580675, \next_absTime: 5.9340571497919, \next_level: 27.103858896994, \playDur: 0.0614170007502, \relDur: 0.0614170007502, \sustain: 0.0614170007502, ),
	(\absTime: 5.9340571497919, \dur: 0.0545444567497, \level: 27.103858896994, \next_absTime: 5.9886016065416, \next_level: 33.79980955135, \playDur: 0.0545444567497, \relDur: 0.0545444567497, \sustain: 0.0545444567497, ),
	(\absTime: 5.9886016065416, \dur: 0.0117587627501, \level: 33.79980955135, \next_absTime: 6.0003603692917, \next_level: 35.31096227035, \playDur: 0.0117587627501, \relDur: 0.0117587627501, \sustain: 0.0117587627501, ),
	(\absTime: 6.0003603692917, \dur: 0.1400096591251, \level: 35.31096227035, \next_absTime: 6.1403700284168, \next_level: 33.959087516333, \playDur: 0.1400096591251, \relDur: 0.1400096591251, \sustain: 0.1400096591251, ),
	(\absTime: 6.1403700284168, \dur: 0.04407427675, \level: 33.959087516333, \next_absTime: 6.1844443051668, \next_level: 25.491894869545, \playDur: 0.04407427675, \relDur: 0.04407427675, \sustain: 0.04407427675, ),
	(\absTime: 6.1844443051668, \dur: 0.0296811865001, \level: 25.491894869545, \next_absTime: 6.2141254916669, \next_level: 19.710811419868, \playDur: 0.0296811865001, \relDur: 0.0296811865001, \sustain: 0.0296811865001, ),
	(\absTime: 6.2141254916669, \dur: 0.0067970148751995, \level: 19.710811419868, \next_absTime: 6.2209225065421, \next_level: 18.419672846378, \playDur: 0.0067970148751995, \relDur: 0.0067970148751995, \sustain: 0.0067970148751995, ),
	(\absTime: 6.2209225065421, \dur: 0.0069648774997999, \level: 18.419672846378, \next_absTime: 6.2278873840419, \next_level: 16.443912941744, \playDur: 0.0069648774997999, \relDur: 0.0069648774997999, \sustain: 0.0069648774997999, ),
	(\absTime: 6.2278873840419, \dur: 0.0071063265000006, \level: 16.443912941744, \next_absTime: 6.2349937105419, \next_level: 14.937134834067, \playDur: 0.0071063265000006, \relDur: 0.0071063265000006, \sustain: 0.0071063265000006, ),
	(\absTime: 6.2349937105419, \dur: 0.064059534, \level: 14.937134834067, \next_absTime: 6.2990532445419, \next_level: 9.0420572030713, \playDur: 0.064059534, \relDur: 0.064059534, \sustain: 0.064059534, ),
	(\absTime: 6.2990532445419, \dur: 0.0550653022502, \level: 9.0420572030713, \next_absTime: 6.3541185467921, \next_level: 6.5850846448019, \playDur: 0.0550653022502, \relDur: 0.0550653022502, \sustain: 0.0550653022502, ),
	(\absTime: 6.3541185467921, \dur: 0.012107732, \level: 6.5850846448019, \next_absTime: 6.3662262787921, \next_level: 6.3266730721066, \playDur: 0.012107732, \relDur: 0.012107732, \sustain: 0.012107732, ),
	(\absTime: 6.3662262787921, \dur: 0.0021590773749001, \level: 6.3266730721066, \next_absTime: 6.368385356167, \next_level: 6.0873687794618, \playDur: 0.0021590773749001, \relDur: 0.0021590773749001, \sustain: 0.0021590773749001, ),
	(\absTime: 6.368385356167, \dur: 0.0772600438749, \level: 6.0873687794618, \next_absTime: 6.4456454000419, \next_level: 5.0141402220389, \playDur: 0.0772600438749, \relDur: 0.0772600438749, \sustain: 0.0772600438749, ),
	(\absTime: 6.4456454000419, \dur: 0.0563331860003, \level: 5.0141402220389, \next_absTime: 6.5019785860422, \next_level: 4.4307129802456, \playDur: 0.0563331860003, \relDur: 0.0563331860003, \sustain: 0.0563331860003, ),
	(\absTime: 6.5019785860422, \dur: 0.0128536493749, \level: 4.4307129802456, \next_absTime: 6.5148322354171, \next_level: 4.3383800321298, \playDur: 0.0128536493749, \relDur: 0.0128536493749, \sustain: 0.0128536493749, ),
	(\absTime: 6.5148322354171, \dur: 0.0071663252496998, \level: 4.3383800321298, \next_absTime: 6.5219985606668, \next_level: 4.2803926891956, \playDur: 0.0071663252496998, \relDur: 0.0071663252496998, \sustain: 0.0071663252496998, ),
	(\absTime: 6.5219985606668, \dur: 0.0692468253751, \level: 4.2803926891956, \next_absTime: 6.5912453860419, \next_level: 4.2241985241933, \playDur: 0.0692468253751, \relDur: 0.0692468253751, \sustain: 0.0692468253751, ),
	(\absTime: 6.5912453860419, \dur: 0.0528041902499, \level: 4.2241985241933, \next_absTime: 6.6440495762918, \next_level: 3.6447694480364, \playDur: 0.0528041902499, \relDur: 0.0528041902499, \sustain: 0.0528041902499, ),
	(\absTime: 6.6440495762918, \dur: 0.0561413387499, \level: 3.6447694480364, \next_absTime: 6.7001909150417, \next_level: 3.6935420758714, \playDur: 0.0561413387499, \relDur: 0.0561413387499, \sustain: 0.0561413387499, ),
	(\absTime: 6.7001909150417, \dur: 0.0511941202504, \level: 3.6935420758714, \next_absTime: 6.7513850352921, \next_level: 4.0855226203102, \playDur: 0.0511941202504, \relDur: 0.0511941202504, \sustain: 0.0511941202504, ),
	(\absTime: 6.7513850352921, \dur: 0.0118684711246, \level: 4.0855226203102, \next_absTime: 6.7632535064167, \next_level: 4.4229856764816, \playDur: 0.0118684711246, \relDur: 0.0118684711246, \sustain: 0.0118684711246, ),
	(\absTime: 6.7632535064167, \dur: 0.0035818930000993, \level: 4.4229856764816, \next_absTime: 6.7668353994168, \next_level: 4.4896768212763, \playDur: 0.0035818930000993, \relDur: 0.0035818930000993, \sustain: 0.0035818930000993, ),
	(\absTime: 6.7668353994168, \dur: 0.0687650888749, \level: 4.4896768212763, \next_absTime: 6.8356004882917, \next_level: 5.3907277707901, \playDur: 0.0687650888749, \relDur: 0.0687650888749, \sustain: 0.0687650888749, ),
	(\absTime: 6.8356004882917, \dur: 0.057851024875101, \level: 5.3907277707901, \next_absTime: 6.8934515131668, \next_level: 7.6333750281207, \playDur: 0.057851024875101, \relDur: 0.057851024875101, \sustain: 0.057851024875101, ),
	(\absTime: 6.8934515131668, \dur: 0.1604075410001, \level: 7.6333750281207, \next_absTime: 7.0538590541669, \next_level: 7.4720117162532, \playDur: 0.1604075410001, \relDur: 0.1604075410001, \sustain: 0.1604075410001, ),
	(\absTime: 7.0538590541669, \dur: 0.053621560124999, \level: 7.4720117162532, \next_absTime: 7.1074806142919, \next_level: 7.6248736318065, \playDur: 0.053621560124999, \relDur: 0.053621560124999, \sustain: 0.053621560124999, ),
	(\absTime: 7.1074806142919, \dur: 0.0619254256253, \level: 7.6248736318065, \next_absTime: 7.1694060399172, \next_level: 7.4665584410976, \playDur: 0.0619254256253, \relDur: 0.0619254256253, \sustain: 0.0619254256253, ),
	(\absTime: 7.1694060399172, \dur: 0.0732263717496, \level: 7.4665584410976, \next_absTime: 7.2426324116668, \next_level: 6.7649449096799, \playDur: 0.0732263717496, \relDur: 0.0732263717496, \sustain: 0.0732263717496, ),
	(\absTime: 7.2426324116668, \dur: 0.0568832057497, \level: 6.7649449096799, \next_absTime: 7.2995156174165, \next_level: 4.4307129802456, \playDur: 0.0568832057497, \relDur: 0.0568832057497, \sustain: 0.0568832057497, ),
	(\absTime: 7.2995156174165, \dur: 0.0143463302502, \level: 4.4307129802456, \next_absTime: 7.3138619476667, \next_level: 4.2570410385727, \playDur: 0.0143463302502, \relDur: 0.0143463302502, \sustain: 0.0143463302502, ),
	(\absTime: 7.3138619476667, \dur: 0.0691224476255, \level: 4.2570410385727, \next_absTime: 7.3829843952922, \next_level: 3.920803841116, \playDur: 0.0691224476255, \relDur: 0.0691224476255, \sustain: 0.0691224476255, ),
	(\absTime: 7.3829843952922, \dur: 0.0627914332494, \level: 3.920803841116, \next_absTime: 7.4457758285416, \next_level: 3.1620523262648, \playDur: 0.0627914332494, \relDur: 0.0627914332494, \sustain: 0.0627914332494, ),
	(\absTime: 7.4457758285416, \dur: 0.0082792193753001, \level: 3.1620523262648, \next_absTime: 7.4540550479169, \next_level: 3.0452683948439, \playDur: 0.0082792193753001, \relDur: 0.0082792193753001, \sustain: 0.0082792193753001, ),
	(\absTime: 7.4540550479169, \dur: 0.0715590435002, \level: 3.0452683948439, \next_absTime: 7.5256140914171, \next_level: 2.7889394440798, \playDur: 0.0715590435002, \relDur: 0.0715590435002, \sustain: 0.0715590435002, ),
	(\absTime: 7.5256140914171, \dur: 0.062027202124701, \level: 2.7889394440798, \next_absTime: 7.5876412935418, \next_level: 2.7155612171917, \playDur: 0.062027202124701, \relDur: 0.062027202124701, \sustain: 0.062027202124701, ),
	(\absTime: 7.5876412935418, \dur: 0.1063279875002, \level: 2.7155612171917, \next_absTime: 7.693969281042, \next_level: 4.1129764943707, \playDur: 0.1063279875002, \relDur: 0.1063279875002, \sustain: 0.1063279875002, ),
	(\absTime: 7.693969281042, \dur: 0.0117826546247, \level: 4.1129764943707, \next_absTime: 7.7057519356667, \next_level: 4.4667909598569, \playDur: 0.0117826546247, \relDur: 0.0117826546247, \sustain: 0.0117826546247, ),
	(\absTime: 7.7057519356667, \dur: 0.05365403925, \level: 4.4667909598569, \next_absTime: 7.7594059749167, \next_level: 5.6229913450515, \playDur: 0.05365403925, \relDur: 0.05365403925, \sustain: 0.05365403925, ),
	(\absTime: 7.7594059749167, \dur: 0.05625101125, \level: 5.6229913450515, \next_absTime: 7.8156569861667, \next_level: 6.5574830951939, \playDur: 0.05625101125, \relDur: 0.05625101125, \sustain: 0.05625101125, ),
	(\absTime: 7.8156569861667, \dur: 0.0675484538751, \level: 6.5574830951939, \next_absTime: 7.8832054400418, \next_level: 7.4332426046093, \playDur: 0.0675484538751, \relDur: 0.0675484538751, \sustain: 0.0675484538751, ),
	(\absTime: 7.8832054400418, \dur: 0.079081889250101, \level: 7.4332426046093, \next_absTime: 7.9622873292919, \next_level: 7.573062405163, \playDur: 0.079081889250101, \relDur: 0.079081889250101, \sustain: 0.079081889250101, ),
	(\absTime: 7.9622873292919, \dur: 0.0377126707081, \level: 7.573062405163, \next_absTime: 8.031983055917, \next_level: 8.3289001944633, \playDur: 0.0377126707081, \relDur: 0.0377126707081, \sustain: 0.069695726625099, ),
	(\absTime: 8.0, \dur: 0.031983055916999, \label: 'end', \playDur: 0.031983055916999, \relDur: 0.031983055916999, \type: 'end', ),
	(\absTime: 8.031983055917, \dur: 0.1428135983751, \level: 8.3289001944633, \next_absTime: 8.1747966542921, \next_level: 8.165767014055, \playDur: 0.1428135983751, \relDur: 0.1428135983751, \sustain: 0.1428135983751, ),
	(\absTime: 8.1747966542921, \dur: 0.0570879382499, \level: 8.165767014055, \next_absTime: 8.231884592542, \next_level: 7.8559563832373, \playDur: 0.0570879382499, \relDur: 0.0570879382499, \sustain: 0.0570879382499, ),
	(\absTime: 8.231884592542, \dur: 0.0400933881246, \level: 7.8559563832373, \next_absTime: 8.2719779806666, \next_level: 7.2960661310086, \playDur: 0.0400933881246, \relDur: 0.0400933881246, \sustain: 0.0400933881246, ),
	(\absTime: 8.2719779806666, \dur: 0.078804499375099, \level: 7.2960661310086, \next_absTime: 8.3507824800417, \next_level: 4.6432746128987, \playDur: 0.078804499375099, \relDur: 0.078804499375099, \sustain: 0.078804499375099, ),
	(\absTime: 8.3507824800417, \dur: 0.066197306875001, \level: 4.6432746128987, \next_absTime: 8.4169797869167, \next_level: 3.9277899199377, \playDur: 0.066197306875001, \relDur: 0.066197306875001, \sustain: 0.066197306875001, ),
	(\absTime: 8.4169797869167, \dur: 0.115876579875, \level: 3.9277899199377, \next_absTime: 8.5328563667917, \next_level: 3.323850227923, \playDur: 0.115876579875, \relDur: 0.115876579875, \sustain: 0.115876579875, ),
	(\absTime: 8.5328563667917, \dur: 0.0362344692499, \level: 3.323850227923, \next_absTime: 8.5690908360416, \next_level: 3.1211193252004, \playDur: 0.0362344692499, \relDur: 0.0362344692499, \sustain: 0.0362344692499, ),
	(\absTime: 8.5690908360416, \dur: 0.1374832523752, \level: 3.1211193252004, \next_absTime: 8.7065740884168, \next_level: 3.1707276284123, \playDur: 0.1374832523752, \relDur: 0.1374832523752, \sustain: 0.1374832523752, ),
	(\absTime: 8.7065740884168, \dur: 0.0063338003751987, \level: 3.1707276284123, \next_absTime: 8.712907888792, \next_level: 3.1990770076156, \playDur: 0.0063338003751987, \relDur: 0.0063338003751987, \sustain: 0.0063338003751987, ),
	(\absTime: 8.712907888792, \dur: 0.0561085603749, \level: 3.1990770076156, \next_absTime: 8.7690164491669, \next_level: 3.4881260425874, \playDur: 0.0561085603749, \relDur: 0.0561085603749, \sustain: 0.0561085603749, ),
	(\absTime: 8.7690164491669, \dur: 0.0552276838753, \level: 3.4881260425874, \next_absTime: 8.8242441330422, \next_level: 4.6991388887251, \playDur: 0.0552276838753, \relDur: 0.0552276838753, \sustain: 0.0552276838753, ),
	(\absTime: 8.8242441330422, \dur: 0.07129381, \level: 4.6991388887251, \next_absTime: 8.8955379430422, \next_level: 5.2450747038106, \playDur: 0.07129381, \relDur: 0.07129381, \sustain: 0.07129381, ),
	(\absTime: 8.8955379430422, \dur: 0.1249025417496, \level: 5.2450747038106, \next_absTime: 9.0204404847918, \next_level: 6.8253352492452, \playDur: 0.1249025417496, \relDur: 0.1249025417496, \sustain: 0.1249025417496, ),
	(\absTime: 9.0204404847918, \dur: 0.031115588874899, \level: 6.8253352492452, \next_absTime: 9.0515560736667, \next_level: 7.1673811220216, \playDur: 0.031115588874899, \relDur: 0.031115588874899, \sustain: 0.031115588874899, ),
	(\absTime: 9.0515560736667, \dur: 0.043792609875201, \level: 7.1673811220216, \next_absTime: 9.0953486835419, \next_level: 7.286864218198, \playDur: 0.043792609875201, \relDur: 0.043792609875201, \sustain: 0.043792609875201, ),
	(\absTime: 9.0953486835419, \dur: 0.0790064642497, \level: 7.286864218198, \next_absTime: 9.1743551477916, \next_level: 7.7847909757777, \playDur: 0.0790064642497, \relDur: 0.0790064642497, \sustain: 0.0790064642497, ),
	(\absTime: 9.1743551477916, \dur: 0.074490552500301, \level: 7.7847909757777, \next_absTime: 9.2488457002919, \next_level: 7.9199690336067, \playDur: 0.074490552500301, \relDur: 0.074490552500301, \sustain: 0.074490552500301, ),
	(\absTime: 9.2488457002919, \dur: 0.081334683499799, \level: 7.9199690336067, \next_absTime: 9.3301803837917, \next_level: 8.0594007414777, \playDur: 0.081334683499799, \relDur: 0.081334683499799, \sustain: 0.081334683499799, ),
	(\absTime: 9.3301803837917, \dur: 0.1770843550002, \level: 8.0594007414777, \next_absTime: 9.5072647387919, \next_level: 5.8188029614992, \playDur: 0.1770843550002, \relDur: 0.1770843550002, \sustain: 0.1770843550002, ),
	(\absTime: 9.5072647387919, \dur: 0.0990588068753, \level: 5.8188029614992, \next_absTime: 9.6063235456672, \next_level: 4.7448718862075, \playDur: 0.0990588068753, \relDur: 0.0990588068753, \sustain: 0.0990588068753, ),
	(\absTime: 9.6063235456672, \dur: 0.0581821974998, \level: 4.7448718862075, \next_absTime: 9.664505743167, \next_level: 4.5769369458935, \playDur: 0.0581821974998, \relDur: 0.0581821974998, \sustain: 0.0581821974998, ),
	(\absTime: 9.664505743167, \dur: 0.043396614624699, \level: 4.5769369458935, \next_absTime: 9.7079023577917, \next_level: 3.8823868389027, \playDur: 0.043396614624699, \relDur: 0.043396614624699, \sustain: 0.043396614624699, ),
	(\absTime: 9.7079023577917, \dur: 0.0798424121253, \level: 3.8823868389027, \next_absTime: 9.787744769917, \next_level: 2.9815682297201, \playDur: 0.0798424121253, \relDur: 0.0798424121253, \sustain: 0.0798424121253, ),
	(\absTime: 9.787744769917, \dur: 0.077875589750001, \level: 2.9815682297201, \next_absTime: 9.865620359667, \next_level: 2.5434350116485, \playDur: 0.077875589750001, \relDur: 0.077875589750001, \sustain: 0.077875589750001, ),
	(\absTime: 9.865620359667, \dur: 0.084102452, \level: 2.5434350116485, \next_absTime: 9.949722811667, \next_level: 2.3415950017859, \playDur: 0.084102452, \relDur: 0.084102452, \sustain: 0.084102452, ),
	(\absTime: 9.949722811667, \dur: 0.078167271, \level: 2.3415950017859, \next_absTime: 10.027890082667, \next_level: 2.0334234358548, \playDur: 0.078167271, \relDur: 0.078167271, \sustain: 0.078167271, ),
	(\absTime: 10.027890082667, \dur: 0.084055894125001, \level: 2.0334234358548, \next_absTime: 10.111945976792, \next_level: 1.9490463948011, \playDur: 0.084055894125001, \relDur: 0.084055894125001, \sustain: 0.084055894125001, ),
	(\absTime: 10.111945976792, \dur: 0.078800098124999, \level: 1.9490463948011, \next_absTime: 10.190746074917, \next_level: 1.6964364317214, \playDur: 0.078800098124999, \relDur: 0.078800098124999, \sustain: 0.078800098124999, ),
	(\absTime: 10.190746074917, \dur: 0.11652775225, \level: 1.6964364317214, \next_absTime: 10.307273827167, \next_level: 1.6414253801979, \playDur: 0.11652775225, \relDur: 0.11652775225, \sustain: 0.11652775225, ),
	(\absTime: 10.307273827167, \dur: 0.037057750624999, \level: 1.6414253801979, \next_absTime: 10.344331577792, \next_level: 1.5699797738238, \playDur: 0.037057750624999, \relDur: 0.037057750624999, \sustain: 0.037057750624999, ),
	(\absTime: 10.344331577792, \dur: 0.041547755375001, \level: 1.5699797738238, \next_absTime: 10.385879333167, \next_level: 1.5396328804973, \playDur: 0.041547755375001, \relDur: 0.041547755375001, \sustain: 0.041547755375001, ),
	(\absTime: 10.385879333167, \dur: 0.083479356624999, \level: 1.5396328804973, \next_absTime: 10.469358689792, \next_level: 1.5798369967593, \playDur: 0.083479356624999, \relDur: 0.083479356624999, \sustain: 0.083479356624999, ),
	(\absTime: 10.469358689792, \dur: 0.078324036000001, \level: 1.5798369967593, \next_absTime: 10.547682725792, \next_level: 1.8513561459916, \playDur: 0.078324036000001, \relDur: 0.078324036000001, \sustain: 0.078324036000001, ),
	(\absTime: 10.547682725792, \dur: 0.13234300975, \level: 1.8513561459916, \next_absTime: 10.680025735542, \next_level: 2.2213709612372, \playDur: 0.13234300975, \relDur: 0.13234300975, \sustain: 0.13234300975, ),
	(\absTime: 10.680025735542, \dur: 0.03465101325, \level: 2.2213709612372, \next_absTime: 10.714676748792, \next_level: 2.2661221429384, \playDur: 0.03465101325, \relDur: 0.03465101325, \sustain: 0.03465101325, ),
	(\absTime: 10.714676748792, \dur: 0.044786738500001, \level: 2.2661221429384, \next_absTime: 10.759463487292, \next_level: 2.3104997899106, \playDur: 0.044786738500001, \relDur: 0.044786738500001, \sustain: 0.044786738500001, ),
	(\absTime: 10.759463487292, \dur: 0.086659048874999, \level: 2.3104997899106, \next_absTime: 10.846122536167, \next_level: 2.3695337712273, \playDur: 0.086659048874999, \relDur: 0.086659048874999, \sustain: 0.086659048874999, ),
	(\absTime: 10.846122536167, \dur: 0.07743839075, \level: 2.3695337712273, \next_absTime: 10.923560926917, \next_level: 2.3795332310013, \playDur: 0.07743839075, \relDur: 0.07743839075, \sustain: 0.07743839075, ),
	(\absTime: 10.923560926917, \dur: 0.087062094, \level: 2.3795332310013, \next_absTime: 11.010623020917, \next_level: 2.574747632612, \playDur: 0.087062094, \relDur: 0.087062094, \sustain: 0.087062094, ),
	(\absTime: 11.010623020917, \dur: 0.08045100875, \level: 2.574747632612, \next_absTime: 11.091074029667, \next_level: 2.8553886125228, \playDur: 0.08045100875, \relDur: 0.08045100875, \sustain: 0.08045100875, ),
	(\absTime: 11.091074029667, \dur: 0.122192268625, \level: 2.8553886125228, \next_absTime: 11.213266298292, \next_level: 2.9798427305949, \playDur: 0.122192268625, \relDur: 0.122192268625, \sustain: 0.122192268625, ),
	(\absTime: 11.213266298292, \dur: 0.034619641000001, \level: 2.9798427305949, \next_absTime: 11.247885939292, \next_level: 3.1129377891381, \playDur: 0.034619641000001, \relDur: 0.034619641000001, \sustain: 0.034619641000001, ),
	(\absTime: 11.247885939292, \dur: 0.047495920499999, \level: 3.1129377891381, \next_absTime: 11.295381859792, \next_level: 3.1953385233806, \playDur: 0.047495920499999, \relDur: 0.047495920499999, \sustain: 0.047495920499999, ),
	(\absTime: 11.295381859792, \dur: 0.08836117675, \level: 3.1953385233806, \next_absTime: 11.383743036542, \next_level: 3.3636931468591, \playDur: 0.08836117675, \relDur: 0.08836117675, \sustain: 0.08836117675, ),
	(\absTime: 11.383743036542, \dur: 0.07411399275, \level: 3.3636931468591, \next_absTime: 11.457857029292, \next_level: 3.6878712818026, \playDur: 0.07411399275, \relDur: 0.07411399275, \sustain: 0.07411399275, ),
	(\absTime: 11.457857029292, \dur: 0.132130912375, \level: 3.6878712818026, \next_absTime: 11.589987941667, \next_level: 4.3152523028922, \playDur: 0.132130912375, \relDur: 0.132130912375, \sustain: 0.132130912375, ),
	(\absTime: 11.589987941667, \dur: 0.036828143625002, \level: 4.3152523028922, \next_absTime: 11.626816085292, \next_level: 5.2174860439982, \playDur: 0.036828143625002, \relDur: 0.036828143625002, \sustain: 0.036828143625002, ),
	(\absTime: 11.626816085292, \dur: 0.047129350624999, \level: 5.2174860439982, \next_absTime: 11.673945435917, \next_level: 5.8925675921252, \playDur: 0.047129350624999, \relDur: 0.047129350624999, \sustain: 0.047129350624999, ),
	(\absTime: 11.673945435917, \dur: 0.087582184375, \level: 5.8925675921252, \next_absTime: 11.761527620292, \next_level: 7.9402457312694, \playDur: 0.087582184375, \relDur: 0.087582184375, \sustain: 0.087582184375, ),
	(\absTime: 11.761527620292, \dur: 0.08401916425, \level: 7.9402457312694, \next_absTime: 11.845546784542, \next_level: 10.55624659837, \playDur: 0.08401916425, \relDur: 0.08401916425, \sustain: 0.08401916425, ),
	(\absTime: 11.845546784542, \dur: 0.089213576375, \level: 10.55624659837, \next_absTime: 11.934760360917, \next_level: 12.038462875703, \playDur: 0.089213576375, \relDur: 0.089213576375, \sustain: 0.089213576375, ),
	(\absTime: 11.934760360917, \dur: 0.076686271374999, \level: 12.038462875703, \next_absTime: 12.011446632292, \next_level: 16.344265276051, \playDur: 0.076686271374999, \relDur: 0.076686271374999, \sustain: 0.076686271374999, ),
	(\absTime: 12.011446632292, \dur: 0.135039564625, \level: 16.344265276051, \next_absTime: 12.146486196917, \next_level: 16.68815464649, \playDur: 0.135039564625, \relDur: 0.135039564625, \sustain: 0.135039564625, ),
	(\absTime: 12.146486196917, \dur: 0.039993545375001, \level: 16.68815464649, \next_absTime: 12.186479742292, \next_level: 16.513262987395, \playDur: 0.039993545375001, \relDur: 0.039993545375001, \sustain: 0.039993545375001, ),
	(\absTime: 12.186479742292, \dur: 0.044538090625, \level: 16.513262987395, \next_absTime: 12.231017832917, \next_level: 15.312540604632, \playDur: 0.044538090625, \relDur: 0.044538090625, \sustain: 0.044538090625, ),
	(\absTime: 12.231017832917, \dur: 0.092322138124999, \level: 15.312540604632, \next_absTime: 12.323339971042, \next_level: 13.0581221838, \playDur: 0.092322138124999, \relDur: 0.092322138124999, \sustain: 0.092322138124999, ),
	(\absTime: 12.323339971042, \dur: 0.082135855374, \level: 13.0581221838, \next_absTime: 12.405475826416, \next_level: 10.405431316043, \playDur: 0.082135855374, \relDur: 0.082135855374, \sustain: 0.082135855374, ),
	(\absTime: 12.405475826416, \dur: 0.139228498501, \level: 10.405431316043, \next_absTime: 12.544704324917, \next_level: 8.6334055959171, \playDur: 0.139228498501, \relDur: 0.139228498501, \sustain: 0.139228498501, ),
	(\absTime: 12.544704324917, \dur: 0.037342984, \level: 8.6334055959171, \next_absTime: 12.582047308917, \next_level: 8.0254363529018, \playDur: 0.037342984, \relDur: 0.037342984, \sustain: 0.037342984, ),
	(\absTime: 12.582047308917, \dur: 0.048978106625, \level: 8.0254363529018, \next_absTime: 12.631025415542, \next_level: 7.2455174172123, \playDur: 0.048978106625, \relDur: 0.048978106625, \sustain: 0.048978106625, ),
	(\absTime: 12.631025415542, \dur: 0.093741463375, \level: 7.2455174172123, \next_absTime: 12.724766878917, \next_level: 6.3959297042265, \playDur: 0.093741463375, \relDur: 0.093741463375, \sustain: 0.093741463375, ),
	(\absTime: 12.724766878917, \dur: 0.0857120705, \level: 6.3959297042265, \next_absTime: 12.810478949417, \next_level: 5.8754140931863, \playDur: 0.0857120705, \relDur: 0.0857120705, \sustain: 0.0857120705, ),
	(\absTime: 12.810478949417, \dur: 0.137117283625, \level: 5.8754140931863, \next_absTime: 12.947596233042, \next_level: 5.7710405934845, \playDur: 0.137117283625, \relDur: 0.137117283625, \sustain: 0.137117283625, ),
	(\absTime: 12.947596233042, \dur: 0.039100123124999, \level: 5.7710405934845, \next_absTime: 12.986696356167, \next_level: 5.5732369046908, \playDur: 0.039100123124999, \relDur: 0.039100123124999, \sustain: 0.039100123124999, ),
	(\absTime: 12.986696356167, \dur: 0.04672339875, \level: 5.5732369046908, \next_absTime: 13.033419754917, \next_level: 5.4673407574819, \playDur: 0.04672339875, \relDur: 0.04672339875, \sustain: 0.04672339875, ),
	(\absTime: 13.033419754917, \dur: 0.134107411375, \level: 5.4673407574819, \next_absTime: 13.167527166292, \next_level: 5.938581952821, \playDur: 0.134107411375, \relDur: 0.134107411375, \sustain: 0.134107411375, ),
	(\absTime: 13.167527166292, \dur: 0.044132477374999, \level: 5.938581952821, \next_absTime: 13.211659643667, \next_level: 6.7515990437724, \playDur: 0.044132477374999, \relDur: 0.044132477374999, \sustain: 0.044132477374999, ),
	(\absTime: 13.211659643667, \dur: 0.095737136249999, \level: 6.7515990437724, \next_absTime: 13.307396779917, \next_level: 7.3876803986935, \playDur: 0.095737136249999, \relDur: 0.095737136249999, \sustain: 0.095737136249999, ),
	(\absTime: 13.307396779917, \dur: 0.082477128125001, \level: 7.3876803986935, \next_absTime: 13.389873908042, \next_level: 7.9314236423195, \playDur: 0.082477128125001, \relDur: 0.082477128125001, \sustain: 0.082477128125001, ),
	(\absTime: 13.389873908042, \dur: 0.093653168874999, \level: 7.9314236423195, \next_absTime: 13.483527076917, \next_level: 9.0696772231138, \playDur: 0.093653168874999, \relDur: 0.093653168874999, \sustain: 0.093653168874999, ),
	(\absTime: 13.483527076917, \dur: 0.085867712875, \level: 9.0696772231138, \next_absTime: 13.569394789792, \next_level: 9.6635122439078, \playDur: 0.085867712875, \relDur: 0.085867712875, \sustain: 0.085867712875, ),
	(\absTime: 13.569394789792, \dur: 0.12831337925, \level: 9.6635122439078, \next_absTime: 13.697708169042, \next_level: 11.170003993029, \playDur: 0.12831337925, \relDur: 0.12831337925, \sustain: 0.12831337925, ),
	(\absTime: 13.697708169042, \dur: 0.042392343874999, \level: 11.170003993029, \next_absTime: 13.740100512917, \next_level: 13.712518874376, \playDur: 0.042392343874999, \relDur: 0.042392343874999, \sustain: 0.042392343874999, ),
	(\absTime: 13.740100512917, \dur: 0.0768148255, \level: 13.712518874376, \next_absTime: 13.816915338417, \next_level: 15.598708969924, \playDur: 0.0768148255, \relDur: 0.0768148255, \sustain: 0.0768148255, ),
	(\absTime: 13.816915338417, \dur: 0.045807899375001, \level: 15.598708969924, \next_absTime: 13.862723237792, \next_level: 17.223043612618, \playDur: 0.045807899375001, \relDur: 0.045807899375001, \sustain: 0.045807899375001, ),
	(\absTime: 13.862723237792, \dur: 0.113031107875, \level: 17.223043612618, \next_absTime: 13.975754345667, \next_level: 18.309618291562, \playDur: 0.113031107875, \relDur: 0.113031107875, \sustain: 0.113031107875, ),
	(\absTime: 13.975754345667, \dur: 0.048561579500001, \level: 18.309618291562, \next_absTime: 14.024315925167, \next_level: 32.22498243029, \playDur: 0.048561579500001, \relDur: 0.048561579500001, \sustain: 0.048561579500001, ),
	(\absTime: 14.024315925167, \dur: 0.10032948625, \level: 32.22498243029, \next_absTime: 14.124645411417, \next_level: 45.881759930106, \playDur: 0.10032948625, \relDur: 0.10032948625, \sustain: 0.10032948625, ),
	(\absTime: 14.124645411417, \dur: 0.040729659250001, \level: 45.881759930106, \next_absTime: 14.165375070667, \next_level: 45.964791791151, \playDur: 0.040729659250001, \relDur: 0.040729659250001, \sustain: 0.040729659250001, ),
	(\absTime: 14.165375070667, \dur: 0.077901729499999, \level: 45.964791791151, \next_absTime: 14.243276800167, \next_level: 34.552794382258, \playDur: 0.077901729499999, \relDur: 0.077901729499999, \sustain: 0.077901729499999, ),
	(\absTime: 14.243276800167, \dur: 0.039396945875001, \level: 34.552794382258, \next_absTime: 14.282673746042, \next_level: 23.560808224571, \playDur: 0.039396945875001, \relDur: 0.039396945875001, \sustain: 0.039396945875001, ),
	(\absTime: 14.282673746042, \dur: 0.07959871325, \level: 23.560808224571, \next_absTime: 14.362272459292, \next_level: 16.964377625486, \playDur: 0.07959871325, \relDur: 0.07959871325, \sustain: 0.07959871325, ),
	(\absTime: 14.362272459292, \dur: 0.040583281375, \level: 16.964377625486, \next_absTime: 14.402855740667, \next_level: 10.030107631971, \playDur: 0.040583281375, \relDur: 0.040583281375, \sustain: 0.040583281375, ),
	(\absTime: 14.402855740667, \dur: 0.084368088874999, \level: 10.030107631971, \next_absTime: 14.487223829542, \next_level: 6.4769396346717, \playDur: 0.084368088874999, \relDur: 0.084368088874999, \sustain: 0.084368088874999, ),
	(\absTime: 14.487223829542, \dur: 0.048411681500001, \level: 6.4769396346717, \next_absTime: 14.535635511042, \next_level: 4.1678751285469, \playDur: 0.048411681500001, \relDur: 0.048411681500001, \sustain: 0.048411681500001, ),
	(\absTime: 14.535635511042, \dur: 0.098264779374999, \level: 4.1678751285469, \next_absTime: 14.633900290417, \next_level: 3.7463104057641, \playDur: 0.098264779374999, \relDur: 0.098264779374999, \sustain: 0.098264779374999, ),
	(\absTime: 14.633900290417, \dur: 0.047849048625, \level: 3.7463104057641, \next_absTime: 14.681749339042, \next_level: 3.1240345488512, \playDur: 0.047849048625, \relDur: 0.047849048625, \sustain: 0.047849048625, ),
	(\absTime: 14.681749339042, \dur: 0.079922887625001, \level: 3.1240345488512, \next_absTime: 14.761672226667, \next_level: 3.0344822328617, \playDur: 0.079922887625001, \relDur: 0.079922887625001, \sustain: 0.079922887625001, ),
	(\absTime: 14.761672226667, \dur: 0.12093444825, \level: 3.0344822328617, \next_absTime: 14.882606674917, \next_level: 3.1717649192277, \playDur: 0.12093444825, \relDur: 0.12093444825, \sustain: 0.12093444825, ),
	(\absTime: 14.882606674917, \dur: 0.039736662875001, \level: 3.1717649192277, \next_absTime: 14.922343337792, \next_level: 3.5057371276229, \playDur: 0.039736662875001, \relDur: 0.039736662875001, \sustain: 0.039736662875001, ),
	(\absTime: 14.922343337792, \dur: 0.079587095875, \level: 3.5057371276229, \next_absTime: 15.001930433667, \next_level: 3.6331487824515, \playDur: 0.079587095875, \relDur: 0.079587095875, \sustain: 0.079587095875, ),
	(\absTime: 15.001930433667, \dur: 0.039264393, \level: 3.6331487824515, \next_absTime: 15.041194826667, \next_level: 4.3729034751466, \playDur: 0.039264393, \relDur: 0.039264393, \sustain: 0.039264393, ),
	(\absTime: 15.041194826667, \dur: 0.08153336625, \level: 4.3729034751466, \next_absTime: 15.122728192917, \next_level: 5.4195976713269, \playDur: 0.08153336625, \relDur: 0.08153336625, \sustain: 0.08153336625, ),
	(\absTime: 15.122728192917, \dur: 0.042973612499999, \level: 5.4195976713269, \next_absTime: 15.165701805417, \next_level: 6.1254918586551, \playDur: 0.042973612499999, \relDur: 0.042973612499999, \sustain: 0.042973612499999, ),
	(\absTime: 15.165701805417, \dur: 0.081648763875, \level: 6.1254918586551, \next_absTime: 15.247350569292, \next_level: 6.2187597431516, \playDur: 0.081648763875, \relDur: 0.081648763875, \sustain: 0.081648763875, ),
	(\absTime: 15.247350569292, \dur: 0.082995812375001, \level: 6.2187597431516, \next_absTime: 15.330346381667, \next_level: 7.4630300876063, \playDur: 0.082995812375001, \relDur: 0.082995812375001, \sustain: 0.082995812375001, ),
	(\absTime: 15.330346381667, \dur: 0.19076779225, \level: 7.4630300876063, \next_absTime: 15.521114173917, \next_level: 6.9778876827257, \playDur: 0.19076779225, \relDur: 0.19076779225, \sustain: 0.19076779225, ),
	(\absTime: 15.521114173917, \dur: 0.117557300875, \level: 6.9778876827257, \next_absTime: 15.638671474792, \next_level: 3.8858787954641, \playDur: 0.117557300875, \relDur: 0.117557300875, \sustain: 0.117557300875, ),
	(\absTime: 15.638671474792, \dur: 0.071555929375, \level: 3.8858787954641, \next_absTime: 15.710227404167, \next_level: 3.1224524393393, \playDur: 0.071555929375, \relDur: 0.071555929375, \sustain: 0.071555929375, ),
	(\absTime: 15.710227404167, \dur: 0.052320772874999, \level: 3.1224524393393, \next_absTime: 15.762548177042, \next_level: 2.8478996387564, \playDur: 0.052320772874999, \relDur: 0.052320772874999, \sustain: 0.052320772874999, ),
	(\absTime: 15.762548177042, \dur: 0.105892418624, \level: 2.8478996387564, \next_absTime: 15.868440595666, \next_level: 2.1586472556698, \playDur: 0.105892418624, \relDur: 0.105892418624, \sustain: 0.105892418624, ),
	(\absTime: 15.868440595666, \dur: 0.118769245876, \level: 2.1586472556698, \next_absTime: 15.987209841542, \next_level: 2.1049792677687, \playDur: 0.118769245876, \relDur: 0.118769245876, \sustain: 0.118769245876, ),
	(\absTime: 15.987209841542, \dur: 0, \level: 2.1049792677687, \playDur: 0, \relDur: 0, ),
]);
);



 (
{
    var sigL, sigR;

    // Left channel
    sigL = FreeVerb.ar(
        RLPF.ar(
            (Saw.ar(110 * SinOsc.kr(110) * LFNoise0.kr(6.875)) +
             SinOsc.ar(110 * LFNoise0.kr(880)))
            * SinOsc.kr(110), 
            2000, 0.01),
        0.3, 0.1, 0.8
    );

    // Right channel with slightly offset modulation rates
    sigR = FreeVerb.ar(
        RLPF.ar(
            (Saw.ar(111 * SinOsc.kr(111) * LFNoise0.kr(7.1)) +
             SinOsc.ar(111 * LFNoise0.kr(900)))
            * SinOsc.kr(109), 
            2100, 0.01),
        0.3, 0.1, 0.8
    );

    // Output stereo pair
    [sigL, sigR] * 0.05
}.play;
) 

(
{
    var sigL, sigR;

    sigL = FreeVerb.ar(
        RLPF.ar(
            (Saw.ar(110 * SinOsc.kr(110) * LFNoise0.kr(6.875))
            +
            SinOsc.ar(110 * LFNoise0.kr(880)))
            *
            SinOsc.kr(110), 2000, 0.01), 0.3, 0.1, 0.8
    );
    
    sigL = sigL * SinOsc.kr(200);
 

    sigR = FreeVerb.ar(
        RLPF.ar(
            (Saw.ar(111 * SinOsc.kr(111) * LFNoise0.kr(7.1))
            +
            SinOsc.ar(111 * LFNoise0.kr(900)))
            *
            SinOsc.kr(109), 2100, 0.005), 0.3, 0.1, 0.8
    );
    
    sigR = sigR * SinOsc.kr(300);

    [sigL, sigR] * 0.1
}.play;

{
	var freqs = [74, 82, 91, 110];  
	var osc = Saw.ar(freqs);  
	var lfo = SinOsc.kr(0.05, 0, 0.3);  
	var filtered = RLPF.ar(osc, freqs * 16, 0.02);  
	var mixed = Mix(filtered); 
	
	var reverb = FreeVerb.ar(mixed, 0.9, 0.9, 0.3);
	
	Out.ar(0, reverb * lfo * 0.2 ! 2);
}.play;
{
	var freqs = [220, 246.94, 261.63, 293.66, 329.63, 293.66, 261.63, 246.94];
	var trig = Impulse.kr(0.2);
	var index = Stepper.kr(trig, 0, 0, freqs.size - 1);
	var freq = Select.kr(index, freqs);

	var env = EnvGen.kr(Env.perc(2, 2), trig);

	var modFreq = freq * 0.7; 
	var modIndex = 300; 
	var mod = SinOsc.ar(modFreq, 0, modIndex); 
	var sig = SinOsc.ar(freq + mod, 0, env); 
	sig = sig * FreeVerb.ar(sig, 0.7, 0.9, 0.2);

	sig ! 2 * 0.2
}.play;
)


TrackDef(\house1, \TrackList).edit
TrackDef(\house1, \TrackList).childAt(0,1).presetCompileString
TrackDef(\house1, \TrackList).childAt(4).presetCompileString
TrackDef(\house1, \TrackList).childAt(4,0).outBus = BusDef(\fx2)
TrackDef(\house1, \TrackList).childAt(4).outBus 
TrackDef(\house1, \TrackList).childAt(0,0).outBus 
TrackDef(\house1, \TrackList).childAt(0,0).cloneScore.outBus
TrackDef(\house1, \TrackList).childAt(4,2).outBus 
TrackDef(\house1, \TrackList).childAt(0,2).outBus 
TrackDef(\house1, \TrackList).childAt(0,2).presetCompileString
NoteTimeline(\tyy).edit
NoteTimeline(\tyy).outBus

Pdef(\fqr).get(\out)
(
( Pmono(\default,
	\dur, 1,
) <> Pbind(\freq, Pseq([100,300],inf))).play
)
(
	( 
		PmonoArtic(\default, \dur, 1,) 
		<> Pbind(\freq, Pseq([100,300],inf), \legato, Pseq([1,0.5],inf)) 
	).play
)

~t = 120/2/60; TempoClock.default.tempo = ~t;


(
Pdef(\hpfrise, 
	Pmono(\fx_rhpf,
		\inbus, BusDef(\fx1, \audio),
		\hpf, PmodEnv(Pseq([10,700,14000],1), 8).loop,
		\addAction, \addToTail,
		\lag, 0.0009,
		\dur, 1,
	),
).play;
);

ProtoInst(\FxTimeline, \roh).edit
ProtoInst(\FxTimeline, \roh).edit


(
Pbind(
    \dur, 0.5, 
    \test, Pseq([\fb1]),
).trace.play(t);
)
\fb1.asPattern.asStream.next
\c4.asPattern.asStream.next
\c4.asStream.next

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				\c,\d,\e,
			],inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

/////////


// allocate and fill the buffers to be used by VOsc
(
s.waitForBoot({

    var numBufs = 8;

    // allocate table of consecutive buffers
    ~bufs = Buffer.allocConsecutive(numBufs, s, 1024, 1);
    s.sync;

    ~bufs.do({ arg buf, i;
        var n, a;

        // generate array of harmonic amplitudes
        n = (i+1)**2;
        a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });

        // fill table
        // argument '7': flag for the \sine1 wave fill method
        // see "Wave Fill Commands" in the Server Command Reference
        s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);

        s.sync;
    });
    "Buffers prepared.".postln;
})
)

// play the synth, indexing into the buffers with MouseX
(
x = SynthDef("help-VOsc",{ arg out = 0, bufoffset = 0;
    // mouse x controls the wavetable position
    var bufindex = MouseX.kr(0, ~bufs.size+5) + bufoffset;

    Out.ar(out,
        VOsc.ar(bufindex.poll, [120, 121], 0, 0.3)
    )
}).play(s,[\out, 0, \bufoffset, ~bufs.first.bufnum]);
)

// fill the buffers with new harmonics on-the-fly
(
~bufs.do({ arg buf, i;
    var a;
    a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
    s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)

// new harmonics...
(
~bufs.do({ arg buf, i;
    var a = Array.fill(32,0);
    12.do({ arg i; a.put(32.rand, 1) });
    s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)

// new harmonics...
(
~bufs.do({ arg buf, i;
    var a = Array.fill((i+1)**2, { arg j; 1.0.rand2 });
    s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)

// cleanup
(
x.free;
~bufs.do(_.free);
)



(
Routine({
var tableMovements, signals;

~tablesBuffers.do { arg bu; bu.free; };
~tableBuffers = nil;
s.sync;
tableMovements = [Array.interpolation(16, 0.5, 0.8), Array.interpolation(16, 0.7, 0), Array.interpolation(16, 0.1, 1)];

signals = 16.collect{|i|Signal.sineFill(1025, [tableMovements[0][i], tableMovements[1][i], tableMovements[2][i]])};
s.sync;
~tablesBuffers = Buffer.allocConsecutive(16, s, 1024, 1, bufnum:0);
s.sync;
~tablesBuffers = signals.size.collect{|i|Buffer.loadCollection(s, signals[i].asWavetableNoWrap)};
"hh".debug;
}).play;
)
{VOsc.ar(SinOsc.ar(0.1).range(0, 15-0.01), 200) * -12.dbamp !2}.play;
{VOsc.ar(SinOsc.ar(0.1).range(0, 15)+ ~tablesBuffers.first.bufnum, 200)  * -12.dbamp !2}.play;
{VOsc.ar(SinOsc.kr(0.1).range(0, 15)+ ~tablesBuffers.first.bufnum, 200) * -12.dbamp !2}.play;

~tablesBuffers


(   // snare drumsss
{
    var harm = LFNoise2.kr(0.5).range(0,0.5);
    var timbre = 0.173;
    var morph = 0.827;
    var trigger = Impulse.kr(8);
    var lev = TRand.kr(trig: trigger).squared;
    MiPlaits.ar(47, 14, harm, timbre, morph, trigger, lev, fm_mod: 0.2, timb_mod: 0.43, decay: 0.4)
}.play
)



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq).linexp(-1,1,0.01,2) - 1;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq).linexp(-1,1,0.01,2) - 1;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

ClipTimeline(\bla).edit
ParamProto.init

Constraint
trim

editorInsert


Ndef(\f1,{SinOscFB.ar(freq:142, feedback:Saw.ar(20 * SinOsc.ar(20)) + SinOsc.ar(0.1)).dup * 0.1}).play;

(
Ndef(\f2,{
    var freq = MouseX.kr(100, 400);
    var input = SinOsc.ar(freq, 0, 0.1);
    var response = WeaklyNonlinear.ar(input);
    var filt = RLPF.ar(response, XLine.kr(500, 5000, 10), 0.3);
    Pan2.ar(0.1 * filt, 0);
}).play;
)

Ndef(\f3,{WeaklyNonlinear.ar(SinOsc.ar(70), Impulse.kr(20), ratex:0.1, ratey:20, freq:440, initx:10 + SinOsc.kr(40), inity:20 + SinOsc.kr(20), alpha:SinOsc.kr(1), xexponent:0, beta:0, yexponent:0).dup * 0.1}).play;

(
ClipTimeline('azzz').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('azzz').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.0, \dur: 4.0, \legato: 1, \midinote: 0.0, \playDur: 4.0, \receiver: PlayerWrapper(Ndef('f1')), \relDur: 4.0, \sustain: 4.0, \type: 'player', )),
	PlayerEvent((\absTime: 4.0, \dur: 4.0, \legato: 1, \midinote: 1.0, \playDur: 4.0, \receiver: PlayerWrapper(Ndef('f2')), \relDur: 4.0, \sustain: 4.0, \type: 'player', )),
	PlayerEvent((\absTime: 8.0, \dur: 4.0, \legato: 1, \midinote: 2.0, \playDur: 4.0, \receiver: PlayerWrapper(Ndef('f3')), \relDur: 4.0, \sustain: 4.0, \type: 'player', )),
	(\absTime: 12.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
);

ClipTimeline(\azzz).edit
ClipTimeline(\azzz).presetCompileString.editorInsert
(
ClipTimeline('azzz').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('azzz').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);
ScIDE 
ClipTimeline(\azzz).play
Platform.ideName == "scvim"

PatKitDef(\eeee).edit
KitTimeline(\azzz).edit
ClipTimeline(\aaa).edit
NoteTimeline(\bla2).edit

TrackDef(\hello, \TrackList).edit

ParamProto.init;
TrackDef(\hello2, \TrackList).edit;



(
Pbind(
	\instrument, \saw,
	\lpf, 400,
) <>
Pseq([
(midinote: 60, dur: 1/2),
(midinote: 72, dur: 1),
])
).play


~datatree = (
	new: { arg self; (parent: self) },
	setData: { arg self, key, val;
		self.data = self.data ?? { IdentityDictionary.new };
		self.data[key] = val;
	},
	add: { "hello".postln }
	set: { "xhello".postln }
);
~dt = ~datatree.new;
~dt.setData(\hello, 123);
~dt.data
~dt.play
~dt.add
~dt.set

Klank
{ Klank.ar(`[[800, 1071, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;

s.options.bindAddress
s.options.protocol
s.options.maxLogins


s.options.bindAddress ="0.0.0.0"; //accept from anywhere
s.options.protocol = \tcp;
s.options.maxLogins = 8;
s.boot;
s.reboot;
Server.killAll
s.quit


s.boot
{ SinOsc.ar(500) ! 2 * 0.1}.play;
oting server 'localhost' on address 127.0.0.1:57110.
NetAddr-Connect failed with exception: connect: Connexion refusée [system:111 at /home/ggz/build/sc_boost_1.80.0/external_libraries/boost/boost/asio/detail/reactive_socket_service.hpp:587 in function 'connect']
Found 267 LADSPA plugins
NetAddr-Connect failed with exception: connect: Connexion refusée [system:111 at /home/ggz/build/sc_boost_1.80.0/external_libraries/boost/boost/asio/detail/reactive_socket_service.hpp:587 in function 'connect']
JackDriver: client name is 'SuperCollider'
SC_AudioDriver: sample rate = 44100.000000, driver's block size = 512
JackDriver: connected  system:capture_1 to SuperCollider:in_1
JackDriver: connected  system:capture_2 to SuperCollider:in_2
JackDriver: connected  SuperCollider:out_1 to system:playback_1
JackDriver: connected  SuperCollider:out_2 to system:playback_2
SuperCollider 3 server ready.
JackDriver: max output latency 46.4 ms
Requested notification messages from server 'localhost'
localhost: server process's maxLogins (8) matches with my options.
localhost: keeping clientID (0) as confirmed by server process.
Shared memory server interface initialized
/notify : already registered






(
Ndef(\hey, {
    var n = 32;
    var mix = Mix.fill(n, {
        var osc1, osc2, osc3, freqS, freqE, line, fx;

        // Random frequency parameters with wider range
        freqS = 1000;
        freqE = rrand(100, 4000);

        // Frequency line with slower movement and more variation
        line = Line.kr(freqS, freqE, rrand(240.0, 480.0)/8) *
            LFNoise1.kr(rrand(0.05, 0.2), mul: 0.1, add: 1);

        // Oscillators with more detuning and varied waveforms
        osc1 = SinOsc.ar(line * rrand(0.95, 1.05),
            phase: LFNoise1.kr(0.1) * 2pi,
            mul: 0.15);

        osc2 = Saw.ar(line * rrand(0.9, 1.1),
            mul: 0.1 * LFNoise1.kr(0.05, add: 0.9));

        osc3 = Pulse.ar(line * rrand(0.85, 1.15),
            width: SinOsc.kr(rrand(0.01, 0.1), mul: 0.2, add: 0.5),
            mul: 0.1);

        // Mix with amplitude modulation
        mix = (osc1 + osc2 + osc3) * LFNoise1.kr(rrand(0.03, 0.1), mul: 0.2, add: 0.8);

        // More elaborate effects chain
		fx = mix;
        //fx = CombC.ar(
            //in: mix,
            //maxdelaytime: 1.0,
            //delaytime: [rrand(0.08, 0.15), rrand(0.15, 0.22)],
            //decaytime: rrand(3.0, 6.0)
        //).sum;

        //fx = FreeVerb.ar(
            //in: fx,
            //mix: rrand(0.3, 0.5),
            //room: rrand(0.7, 0.95),
            //damp: rrand(0.2, 0.5),
            //mul: 0.8
        //);

        // Panning with slower, more irregular movement
        Pan2.ar(
            in: fx,
            pos: LFNoise2.kr(rrand(0.02, 0.1), mul: 0.8),
            level: 1/n.sqrt
        );
    });

    // Master processing
    mix = LPF.ar(
        in: mix,
        freq: LFNoise2.kr(0.1, mul: 2000, add: 3000)
    );

    mix = MoogFF.ar(
        in: mix,
        freq: LFNoise2.kr(0.1, mul: 1000, add: 2000),
        gain: 2.0
    );

	mix.debug("mix");
	mix = mix * 1.9;
    //mix = Mix(mix) * 0.5; // prevent clipping

    Out.ar(0, mix);
}).play(fadeTime: 10); // smooth fade in
)


s.options.sampleRate = 44100
s.reboot


"nil".interpret
"dkjfkd".compile


(
SynthDef(\test, {
    var env;
    env = \env.ir([0.0001!4, 0.0002!3, 0.0003!3]);
    env.poll;
    Out.ar(0, SinOsc.ar *
        EnvGen.ar(
            Env.new(
                env[0],
                env[1],
                env[2]
            ),
        doneAction:2
        )
    );
}).add;
)

(
Synth(\test, [
    \env: [
        [0, 1, 1, 0],
        [0.05, 0.1, 0.2],
        [-4, 0, 4]
    ]
]);
)

(
SynthDef(\test, {
    var env;
    env = \env.ir(Env(0.0001!4, 0.0002!3, 0.0003!3));
    env.poll;
    Out.ar(0, SinOsc.ar * EnvGen.ar(env, doneAction:2));
}).add;
)
(
Synth(\test, [
    \env: Env(
        [0, 1, 1, 0],
        [0.05, 0.1, 0.2],
        [-4, 0, 4]
    )
]);
)


/////////

(
// --- This is the path to the SC built-in test image ---
var path = SCDoc.helpSourceDir +/+ "images/Swamp.png";
var img = Image.open(path);
~img = img;

[ "Image loaded:", img ].postln; // <-- This posts correctly! "Image(Swamp.png, 128, 128)"

// 1. THIS WORKS:
 //img.plot;

// 2. THIS FAILS (shows an empty 128x128 window):

)

(
	var w, v;
	w = Window.new("Test", Rect(200, 200, 128, 128)).front;
	v = View(w, Rect(0, 0, 128, 128));
	v.backgroundImage = ~img;
	// v.refresh; // <-- I already tried .refresh, it didn't help.
)
