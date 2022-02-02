
(
{ arg
	states = [
		(
			backColor: Color( 0, 0.5, 0 ),
			text: "ON",
			fontColor: Color.white
		),
		(
			backColor: Color( 0.5, 0, 0 ),
			text: "OFF",
			fontColor: Color.black
		)
	],
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ), // second border color
	font = ~gm.at( \mainFont ),
	hasBorderInset = ~gm.at( \hasBorderInset ), // second border
	borderSize = ~gm.at( \borderSize ),
	currentState = 0,
	text = "text";

	var button = UserView.new();

	button.drawFunc = { | view |
		Pen.fillColor_( borderColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);

		if( hasBorderInset, {
			Pen.fillColor_( backgroundColor );
			Pen.fillRect(
				Rect(
					borderSize,
					borderSize,
					view.bounds.width - ( borderSize * 2 ),
					view.bounds.height - ( borderSize * 2 )
				)
			);
			Pen.fillColor_( states[ currentState ].at( \backColor ) );
			Pen.fillRect(
				Rect(
					borderSize * 2,
					borderSize * 2,
					view.bounds.width - ( borderSize * 4 ),
					view.bounds.height - ( borderSize * 4 )
				)
			);
		}, { // if !hasBorderInset
			Pen.fillColor_( states[ currentState ].at( \backColor ) );
			Pen.fillRect(
				Rect(
					borderSize,
					borderSize,
					view.bounds.width - ( borderSize * 2 ),
					view.bounds.height - ( borderSize * 2 )
				)
			);
		} );

		Pen.stringCenteredIn(
			states[ currentState ].at( \text ),
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			),
			font,
			states[ currentState ].at( \fontColor ),
		);
	};

	button.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; button.refresh } );
	button.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; button.refresh } );
	button.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; button.refresh } );
	button.addUniqueMethod( \setFont, { | self, newFont | font = newFont; button.refresh } );
	button.addUniqueMethod( \setInset, { | self, newValue | hasBorderInset = newValue; button.refresh } );
	button.addUniqueMethod( \setState, { | self, newState |
		currentState = newState;
		if( currentState >= states.size, { currentState = 0 } );
		button.refresh; } );
	button.addUniqueMethod( \setStates, { | self, newStates |
		states = newStates;
		currentState = 0;
		button.refresh } );
	button.addUniqueMethod( \bindFunction, { | self, function | button.mouseDownAction_( {
		currentState = currentState + 1;
		if( currentState == states.size, { currentState = 0 } );
		function.value( currentState );
		button.refresh;
	} ) } );

	button
}
)