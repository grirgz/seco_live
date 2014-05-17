
~target_channel = '1mixer';
~target_send = \send4;
~target_vol = \amp;
Ndef(~target_channel).set(~target_send, 1);
Ndef(~target_channel).set(~target_vol, 0);
Veco(~namex).response_off_hook = {
	Ndef(~target_channel).set(~target_vol, 1);
	Ndef(~target_channel).set(~target_send, 0);
};
