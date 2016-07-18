

k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\bt).action = { "blalla".postln }
k.elAt(\pad).elAt(0).elAt(0).action = { "0 on pushed".postln; }
k.elAt(\pad).elAt(0).elAt(0).value = 0xd4.linlin(0,127,0,1)
k.elAt(\pad).elAt(2).elAt(0).value = 0x1b/127
k.elAt(\pad).elAt(2).elAt(0).value = 0xb0.linlin(0,127,0,1)
k.elAt(\pad).value = 0x0b.linlin(0,127,0,1)
k.elAt(\bt).flat.do({ arg x; x.value = 0x00.linlin(0,127,0,1)})
k.elAt(\arr).flat.do({ arg x; x.value = 0x00.linlin(0,127,0,1)})
k.elAt(\pad).elAt(0).elAt(0).value = 0.05
k.elAt(\pad).elAt(0).elAt(0).value 
k.postElements
0x3c

m= MIDIOut(0)
m.sysex(Int8Array[ 0xb0,0,0 ]); // clear grid
m.sysex(Int8Array[ 0xb0,0,0x7f ]); // full test
m.sysex(Int8Array[ 0xb0,0,0x28 ]); // turn on flashing mode
m.sysex(Int8Array[ 0xb0,0,0x20 ]); // manual flash on
m.sysex(Int8Array[ 0xb0,0,0x21 ]); // manual flash off


////////////////////////////////////////////////

MKtlDesc.writeCache;
MKtlDesc("*launchpad")
MKtl(\lp).rebuild("*launchpad")
MKtl(\lp, "*launchpad")
k = MKtl(\lp)
k.postElements
k.elAt(\bt).action = { "hello".postln; }
MKtl.find(\midi)
MKtl('midi_2_launch', 'midi_2_launchpad_s').adaptDesc("novation-launchapd");
MKtl('midi_2_launch').rebuild('midi_2_launchpad_s');
MKtl('midi_2_launch', 'midi_2_launchpad_s').device;
MKtl.all['midi_2_launch'] = nil
MKtl.all['lp'] = nil

k = MKtl('midi_2_launch', "novation-launchpad-s");
k.postElements

k.elAt(\bt).action = { "blalla".postln }

MKtlLookup.all['midi_2_launchpad_s'].filenames
MKtlLookup.all['midi_3_icon_icontrols_v2_00_port_1'].filenames

MKtl('midi_3_icon_i', 'midi_3_icon_icontrols_v2_00_port_1').device.dump;
MKtl('midi_3_launch', 'midi_3_launchpad_s');

"kk""kk"
"kk"


~m = MIDIOut(0)
~m.connect(0)
MIDIIn.connect(0, ~launchpad_id)
MIDIIn.connect(0, ~launchpad_device_id)
MIDIOut(0).connect(0, )
~m.noteOn(16+4)
	MIDIOut.connect(0,0)
	MIDIOut(0).connect(
		MIDIClient.destinations.detectIndex { arg x; x.device == "Launchpad S" }
	);

MIDIdef.noteOn(\bla, { arg ... ar; ar.debug("ar") })
MIDIdef.trace
@"kk"}}]]"kk""kk"]]"kk"

Shared memory server interface initialized
MIDI Sources:
        MIDIEndPoint("System", "Timer", 0)
        MIDIEndPoint("System", "Announce", 1)
        MIDIEndPoint("Midi Through", "Midi Through Port-0", 917504)
        MIDIEndPoint("Launchpad S", "Launchpad S MIDI 1", 1572864)
        MIDIEndPoint("SuperCollider", "out0", 8454148)
        MIDIEndPoint("SuperCollider", "out1", 8454149)
MIDI Destinations:
        MIDIEndPoint("Midi Through", "Midi Through Port-0", 917504)
        MIDIEndPoint("Launchpad S", "Launchpad S MIDI 1", 1572864)
        MIDIEndPoint("SuperCollider", "in0", 8454144)
        MIDIEndPoint("SuperCollider", "in1", 8454145)
        MIDIEndPoint("SuperCollider", "in2", 8454146)
        MIDIEndPoint("SuperCollider", "in3", 8454147)
destdev: MIDIEndPoint("SuperCollider", "in0", 8454144), count: 5, lookupName: midi_5_supercollider_port_1, idInfo: ( 'destPortIndex': 0, 'deviceName': SuperCollider )
destdev: MIDIEndPoint("SuperCollider", "in1", 8454145), count: 6, lookupName: midi_6_supercollider_port_2, idInfo: ( 'destPortIndex': 1, 'deviceName': SuperCollider )
destdev: MIDIEndPoint("SuperCollider", "in2", 8454146), count: 7, lookupName: midi_7_supercollider_port_3, idInfo: ( 'destPortIndex': 2, 'deviceName': SuperCollider )
Jack: JackClient::ClientNotify ref = 5 name = SuperCollider notify = 18
destdev: MIDIEndPoint("SuperCollider", "in3", 8454147), count: 8, lookupName: midi_8_supercollider_port_4, idInfo: ( 'destPortIndex': 3, 'deviceName': SuperCollider )

-----------------------------------------------------

/*** Possible MKtls for MIDI devices: ***/
        // [ midi device, portname, uid]

// [ [ "Midi Through", "Midi Through Port-0", 917504 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_1_midi_t', 'midi_1_midi_through');

// [ [ "System", "Timer", 0 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_1_system', 'midi_1_system_port_1');

// [ [ "Launchpad S", "Launchpad S MIDI 1", 1572864 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_2_launch', 'midi_2_launchpad_s');

// [ [ "System", "Announce", 1 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_2_system', 'midi_2_system_port_2');

// [ [ "SuperCollider", "in0", 8454144 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_5_superc', 'midi_5_supercollider_port_1');

// [ [ "SuperCollider", "in1", 8454145 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_6_superc', 'midi_6_supercollider_port_2');

// [ [ "SuperCollider", "in2", 8454146 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_7_superc', 'midi_7_supercollider_port_3');

// [ [ "SuperCollider", "in3", 8454147 ] ]
        // Unknown - Create from lookupName and explore:
MKtl('midi_8_superc', 'midi_8_supercollider_port_4');


-----------------------------------------------------
-> MKtl
Jack: JackClient::ClientNotify ref = 5 name = SuperCollider notify = 18
Jack: JackClient::ClientNotify ref = 5 name = SuperCollider notify = 4
Jack: JackClient::kGraphOrderCallback
Jack: WaitGraphChange...
Jack: JackClient::ClientNotify ref = 5 name = SuperCollider notify = 18
Jack: JackClient::ClientNotify ref = 5 name = SuperCollider notify = 18
Jack: JackClient::ClientNotify ref = 5 name = SuperCollider notify = 4
Jack: JackClient::kGraphOrderCallback
MKtl( 'midi_2_launch' ) - desc not valid: nil.
MKtl:finishInit: no desc given, cannot create elements...
HID: found 3 devices.
multiple devices found for 'USB Keyboard_Logitech'.

/* OSC devices not found automagically yet. Use OSCMon: */
o = OSCMon.new.enable.show;
WARNING: MKtl('midi_2_launch') .elementsDict has no elements:
 nil
ERROR: Message 'elements' not understood.
RECEIVER:
Instance of MIDIEndPoint {    (0xc85ffb0, gc=D8, fmt=00, flg=00, set=03)
  instance variables [3]
    device : "Launchpad S"
    name : "Launchpad S MIDI 1"
    uid : Integer 1572864
}
ARGS:
CALL STACK:
        DoesNotUnderstandError:reportError   0xbf9d790
                arg this = <instance of DoesNotUnderstandError>
        Nil:handleError   0xbf9d850
                arg this = nil
                arg error = <instance of DoesNotUnderstandError>
        Thread:handleError   0xbf9e330
                arg this = <instance of Thread>
                arg error = <instance of DoesNotUnderstandError>
        Object:throw   0xbf9d6d0
                arg this = <instance of DoesNotUnderstandError>
        Object:doesNotUnderstand   0xbf9eb10
                arg this = <instance of MIDIEndPoint>
                arg selector = 'elements'
                arg args = [*0]
        Meta_MKtlDesc:findGenericFor   0xc810eb0
                arg this = <instance of Meta_MKtlDesc>
                arg hid = <instance of MIDIEndPoint>
                arg rateForMatch = 0.5
                var numHidElems = nil
                var candList = nil
                var candidate = nil
        MKtl:openDevice   0xc89ef50
                arg this = <instance of MKtl>
                arg lookAgain = false
                arg multiIndex = nil
                var protocol = nil
                var foundMatchingDesc = nil
        MKtl:finishInit   0xc3502f0
                arg this = <instance of MKtl>
                arg lookForNew = false
                arg multiIndex = nil
        MKtl:init   0xc898950
                arg this = <instance of MKtl>
                arg argDesc = nil
                arg argLookupName = 'midi_2_launchpad_s'
                arg argLookupInfo = <instance of Event>
                arg lookForNew = false
                arg multiIndex = nil
                var specsFromDesc = nil
        Interpreter:interpretPrintCmdLine   0xbf86390
                arg this = <instance of Interpreter>
                var res = nil
                var func = <instance of Function>
                var code = "
MKtl('midi_2_launch', 'midi..."
                var doc = nil
                var ideClass = nil
        Process:interpretPrintCmdLine   0xc2960f0
                arg this = <instance of Main>
^^ The preceding error dump is for ERROR: Message 'elements' not understood.
RECEIVER: MIDIEndPoint("Launchpad S", "Launchpad S MIDI 1", 1572864)


(\bla:rah)

(isPlaying:true).isPlaying
(isPlaying:false).isPlaying
Event
^false
0 ^ 0
^"jj"
^-1
33

(bla: { ^1 }).bla
(
c = 0;
~a = (bla: { "hello a".postln; ^1 });
~b = (bla: { c=c+1; "hello b".postln; nil });
~ra = ~a.bla;
~rb = ~b.bla;
~rb = ~b.bla;
"bla";
)
c
~a.bla
~c
"kk"



Ndef(\lfo1, { SinOsc.kr(1).range(50,100)  });
Archive.global.put(\testndef, Ndef(\lfo1))
// reboot SC
Archive.global.at(\testndef); // error because server is nil in Ndef:printOn


(nhello: \workd)
MK
o




MIDI (ALSA): connect failed (Périphérique ou ressource occupé)
ERROR: Primitive '_ConnectMIDIOut' failed.
Failed.
RECEIVER:
class MIDIOut (0xb6036a0) {
  instance variables [19]
    name : Symbol 'MIDIOut'
    nextclass : instance of Meta_MIDIPlayer (0xa49c860, size=19, set=5)
    superclass : Symbol 'Object'
    subclasses : nil
    methods : instance of Array (0xb603760, size=28, set=5)
    instVarNames : instance of SymbolArray (0xb6038a0, size=3, set=3)
    classVarNames : nil
    iprototype : instance of Array (0xb603920, size=3, set=3)
    cprototype : nil
    constNames : nil
    constValues : nil
    instanceFormat : Integer 0
    instanceFlags : Integer 0
    classIndex : Integer 337
    classFlags : Integer 0
    maxSubclassIndex : Integer 337
    filenameSymbol : Symbol '/usr/local/share/SuperCollider/SCClassLibrary/Common/Control/MIDIOut.sc'
    charPos : Integer 9481
    classVarIndex : Integer 925
}
CALL STACK:
        MethodError:reportError   0xe8ccd70
                arg this = <instance of PrimitiveFailedError>
        Nil:handleError   0xe8ccef0
                arg this = nil
                arg error = <instance of PrimitiveFailedError>
        Thread:handleError   0xe8cd070
                arg this = <instance of Thread>
                arg error = <instance of PrimitiveFailedError>
        Object:throw   0xe8ccdd0
                arg this = <instance of PrimitiveFailedError>
        Object:primitiveFailed   0xe8ccfb0
                arg this = <instance of Meta_MIDIOut>
        Meta_MIDIOut:connect   0xa4b8add0
                arg this = <instance of Meta_MIDIOut>
                arg outport = 0
                arg device = 0
                var uid = 917504
                var dest = <instance of MIDIEndPoint>
        Interpreter:interpretPrintCmdLine   0xa4b8af10
                arg this = <instance of Interpreter>
                var res = nil
                var func = <instance of Function>
                var code = "
        MIDIOut.connect(0,0)
"
                var doc = nil
                var ideClass = nil
        Process:interpretPrintCmdLine   0xe8ce1b0
                arg this = <instance of Main>
^^ The preceding error dump is for ERROR: Primitive '_ConnectMIDIOut' failed.
Failed.
RECEIVER: MIDIOut


MIDIIn.connect(0, ~launchpad_device_id);



  MIDI (ALSA): connect failed (Périphérique ou ressource occupé)
ERROR: Primitive '_ConnectMIDIIn' failed.
Failed.
RECEIVER:
class MIDIIn (0xa9b3de0) {
  instance variables [19]
    name : Symbol 'MIDIIn'
    nextclass : instance of Meta_MIDIKey (0xb348620, size=19, set=5)
    superclass : Symbol 'Object'
    subclasses : nil
    methods : nil
    instVarNames : instance of SymbolArray (0xa9b3ea0, size=1, set=3)
    classVarNames : instance of SymbolArray (0xa9b3fa0, size=21, set=4)
    iprototype : instance of Array (0xa9b3f20, size=1, set=3)
    cprototype : instance of Array (0xa9b4060, size=21, set=5)
    constNames : nil
    constValues : nil
    instanceFormat : Integer 0
    instanceFlags : Integer 0
    classIndex : Integer 1144
    classFlags : Integer 0
    maxSubclassIndex : Integer 1144
    filenameSymbol : Symbol '/usr/local/share/SuperCollider/SCClassLibrary/Common/Control/MIDIOut.sc'
    charPos : Integer 2982
    classVarIndex : Integer 421
}
CALL STACK:
        MethodError:reportError   0xebd86b0
                arg this = <instance of PrimitiveFailedError>
        Nil:handleError   0xebd8bf0
                arg this = nil
                arg error = <instance of PrimitiveFailedError>
        Thread:handleError   0xebd9130
                arg this = <instance of Thread>
                arg error = <instance of PrimitiveFailedError>
        Object:throw   0xebd9190
                arg this = <instance of PrimitiveFailedError>
        Object:primitiveFailed   0xebdc550
                arg this = <instance of Meta_MIDIIn>
        Meta_MIDIIn:connect   0xdec3f10
                arg this = <instance of Meta_MIDIIn>
                arg inport = 0
                arg device = 1572864
                var uid = 1572864
                var source = <instance of MIDIEndPoint>
        Interpreter:interpretPrintCmdLine   0xdeb70b0
                arg this = <instance of Interpreter>
                var res = nil
                var func = <instance of Function>
                var code = "
MIDIIn.connect(0, ~launchpa..."
                var doc = nil
                var ideClass = nil
        Process:interpretPrintCmdLine   0xebdbbf0
                arg this = <instance of Main>
^^ The preceding error dump is for ERROR: Primitive '_ConnectMIDIIn' failed.
Failed.
RECEIVER: MIDIIn

