
//~icon_device_id
(
MIDIBoard.permanent = true;
MIDIBoard.define([0, ~icon_device_id], [
	\left, \note -> 91,
	\right, \note -> 92,

	\stop, \note -> 93,
	\play, \note -> 94,

	\record, \note -> 95,
	\loop, \note -> 86,

	\k1, 16,
	\k2, 17,
	\k3, 18,
	\k4, 19,
	\k5, 20,
	\k6, 21,
	\k7, 22,
	\k8, 23,
	\k9, 12,

	\s1, [13,0],
	\s2, [13,1],
	\s3, [13,2],
	\s4, [13,3],
	\s5, [13,4],
	\s6, [13,5],
	\s7, [13,6],
	\s8, [13,7],
	\s9, [13,8],

	\a1, \note -> 16,
	\a2, \note -> 17,
	\a3, \note -> 18,
	\a4, \note -> 19,
	\a5, \note -> 20,
	\a6, \note -> 21,
	\a7, \note -> 22,
	\a8, \note -> 23,
	\a9, \note -> 48,

	\c1, \note -> 8,
	\c2, \note -> 9,
	\c3, \note -> 10,
	\c4, \note -> 11,
	\c5, \note -> 12,
	\c6, \note -> 13,
	\c7, \note -> 14,
	\c8, \note -> 15,
	\c9, \note -> 49,

]);
);

(
MIDIMap.permanent = true;
MIDIMap.define([nil, ~icon_device_id], [
	\left, \note -> 91,
	\right, \note -> 92,

	\stop, \note -> 93,
	\play, \note -> 94,

	\record, \note -> 95,
	\loop, \note -> 86,

	\k1, 16,
	\k2, 17,
	\k3, 18,
	\k4, 19,
	\k5, 20,
	\k6, 21,
	\k7, 22,
	\k8, 23,
	\k9, 12,

	\s1, [13,0],
	\s2, [13,1],
	\s3, [13,2],
	\s4, [13,3],
	\s5, [13,4],
	\s6, [13,5],
	\s7, [13,6],
	\s8, [13,7],
	\s9, [13,8],

	\a1, \note -> 16,
	\a2, \note -> 17,
	\a3, \note -> 18,
	\a4, \note -> 19,
	\a5, \note -> 20,
	\a6, \note -> 21,
	\a7, \note -> 22,
	\a8, \note -> 23,
	\a9, \note -> 48,

	\c1, \note -> 8,
	\c2, \note -> 9,
	\c3, \note -> 10,
	\c4, \note -> 11,
	\c5, \note -> 12,
	\c6, \note -> 13,
	\c7, \note -> 14,
	\c8, \note -> 15,
	\c9, \note -> 49,

]);
);

//MIDIdef.noteOn(\test, { arg ... args; args.debug("plop note"); });
//MIDIdef.cc(\testcc, { arg ... args; args.debug("plop cc"); });
