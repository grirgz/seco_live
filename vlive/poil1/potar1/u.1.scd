
~target_channel = '1mixer';
Ndef(~target_channel).set(\send2, 1);
Veco(~namex).response_off_hook = {
	Ndef(~target_channel).set(\send2, 0);
};
