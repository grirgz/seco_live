// General structure to access a device
// Look for the devices that are attached:
GeneralHID.buildDeviceList;
// Get the list of devices:
d = GeneralHID.deviceList;
// Check which devices have been found:
GeneralHID.postDevices;
// Pick the 6th device and open it and create an instance of it:
a = GeneralHID.open( d[5] )
// Get info on the device:
a.info;
// if you want to automatically find the device when you restart you can use the GeneralHID.findBy method. To get the arguments you should use for this function, you can use:
a.info.findArgs;
// this outputs for my Impact gamepad:
[ 1973, 786, usb-0000:00:1d.0-1/input0, 272 ]
// close the device, as we will reopen it in the next lines
a.close;
// if we know which device we want, we can find it:
b = GeneralHID.findBy( 1973, 786, "usb-0000:00:1d.0-1/input0", 272 );
// if you do not care about the version or the location, you can also do:
b = GeneralHID.findBy( 1973, 786 );
// or if you do not even care about the productID
b = GeneralHID.findBy( 1973 );
// you can then open it by:
a = GeneralHID.open( b )
// Start eventloop:
GeneralHID.startEventLoop
// Get the capabilities of the device in a readable format:
a.caps;
// there are different types of slots:
// button (type 1), has only on/off (1/0) states
// relative (type 2), counts up or down (scrollwheel for example)
// absolute (type 3), continuous value between 0 and 1
// some other may show up on Linux ( Syn (type 0) and Miscellaneous (type 4), but these are generally not very useful).
// See if data is coming in:
a.debug_( true );
// Stop it:
a.debug_( false );
// Debugging can be turned on for each slot individually, if necessary:
//(IBM trackpoint)
a.slots[1].at( 272 ).debug_( true );
// (external mouse on macbook pro)
a.slots[3][1].debug_(true);
(external mouse on ibm thinkpad)
a.slots[2][1].debug_(true);
// Turn it off again: // (IBM trackpoint)
a.slots[1].at( 272 ).debug_( false );
//(external mouse on macbook pro)
a.slots[3][48].debug_(false);
//(external mouse on ibm thinkpad)
a.slots[3][1].debug_(false);

// You can also create a generic gui to see what is coming in:
a.makeGui;

// The current value of a slot can be checked:
a.slots[1].at( 272 ).value;
a.slots[2].at( 1 ).value;
a.slots[3][1].value
//If the slot is an LED, you can set the value:
a.slots[11][0].value = 1;
a.slots[11][0].value = 0;

// Actions can be mapped to each slot individually.
a.slots[1].at( 272 ).action_( { "hello".postln; } );
a.slots[1].at( 273 ).action_( { "hi".postln; } );
a.slots[3].at( 1 ).action_( { "hi".postln; } );
// with an input to the function
a.slots[3].at( 1 ).action_( { |v| "hi, my value is ".post; v.value.postln; } );
a.slots[1].at( 272 ).action_( { |v| "hi, my value is ".post; v.value.postln; } );

// To stop the action, assign it to an empty function.
a.slots[1].at( 272 ).action_( {} );
a.slots[1].at( 273 ).action_( {} );
a.slots[3].at( 1 ).action_( {} );

// you can access slots, by giving them a key:
a.add( \lx, [3,0] );
a[\lx].debug_( true );
// the last item in the output array, now shows the key
a[\lx].debug_( false );
// save the spec for future use:
a.spec.save( "Impact_help" );
// find a spec defined previously for this device:
c = a.findSpec;
// set it:
a.setSpec( c[0] );
// more info on this in the [GeneralHIDSpec] helpfile
// If the server is running you can create a control bus for the HID data to go to, so that a synth can immediately read the data:
s = Server.local.boot;
// To create the bus:
a.slots[1].at( 272 ).createBus( s ); a.slots[2].at( 8 ).createBus( s );

