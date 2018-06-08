
(
MIDIMap.permanent = true;
MIDIMap.define([nil, ~apro_device_id], [
	//\left, \note -> 91,
	//\right, \note -> 92,

	//\stop, \note -> 93,
	//\play, \note -> 94,

	//\record, \note -> 95,
	//\loop, \note -> 86,

	\tk1, 0x30,
	\tk2, 0x31,
	\tk3, 0x32,
	\tk4, 0x33,
	\tk5, 0x34,
	\tk6, 0x35,
	\tk7, 0x36,
	\tk8, 0x37,

	\dk1, 0x10,
	\dk2, 0x11,
	\dk3, 0x12,
	\dk4, 0x13,
	\dk5, 0x14,
	\dk6, 0x15,
	\dk7, 0x16,
	\dk8, 0x17,

	\device_left, \note -> 0x3A,
	\device_right, \note -> 0x3B,
	\bank_left, \note -> 0x3C,
	\bank_right, \note -> 0x3D,


	//\s1, [13,0],
	//\s2, [13,1],
	//\s3, [13,2],
	//\s4, [13,3],
	//\s5, [13,4],
	//\s6, [13,5],
	//\s7, [13,6],
	//\s8, [13,7],
	//\s9, [13,8],

	//\a1, \note -> 16,
	//\a2, \note -> 17,
	//\a3, \note -> 18,
	//\a4, \note -> 19,
	//\a5, \note -> 20,
	//\a6, \note -> 21,
	//\a7, \note -> 22,
	//\a8, \note -> 23,
	//\a9, \note -> 48,

	//\c1, \note -> 8,
	//\c2, \note -> 9,
	//\c3, \note -> 10,
	//\c4, \note -> 11,
	//\c5, \note -> 12,
	//\c6, \note -> 13,
	//\c7, \note -> 14,
	//\c8, \note -> 15,
	//\c9, \note -> 49,

]);
MIDIMap.defaultBlockmode = true;
);
