
(
{ arg
	labels = [ "Choice A", "Choice B", "Choice C" ],
	backColorSelected = ~gm.at( \mainColor ),

	borderSize = ~gm.at( \borderSize ),
	borderColor = ~gm.at( \borderColor ),

	backgroundColor = ~gm.at( \backgroundColor ), // second border color
	hasBackgroundBorder = true,
	backgroundBorderSize = borderSize * 2,

	font = ~gm.at( \mainFont ),
	fontColorSelected = ~gm.at( \fontColor ),
	fontColorUnselected = Color.white,

	backColorUnselected = Color( 0.25, 0.25, 0.25 ),
	unselectedRatio = 0.9,

	direction = \horizontal,
	currentState = 0;

	var view = UserView.new();

	view.drawFunc = { | view |

		var caseSize;
		var unselectedMargin;

		Pen.fillColor_( borderColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);

		Pen.fillColor_( backgroundColor );
		Pen.fillRect(
			Rect(
				borderSize,
				borderSize,
				view.bounds.width - ( borderSize * 2 ),
				view.bounds.height - ( borderSize * 2 )
			)
		);

		if( direction == \horizontal, {
			caseSize = Point(
				view.bounds.width - ( ( borderSize + backgroundBorderSize ) * 2 ) / labels.size,
				view.bounds.height - ( ( borderSize + backgroundBorderSize ) * 2 )
			);
			unselectedMargin = caseSize.y * ( 1 - unselectedRatio / 2 );
		}, {
			caseSize = Point(
				view.bounds.width - ( ( borderSize + backgroundBorderSize ) * 2 ),
				view.bounds.height - ( ( borderSize + backgroundBorderSize ) * 2 ) / labels.size
			);
			unselectedMargin = caseSize.x * ( 1 - unselectedRatio / 2 );
		} );

		labels.do( { | text, index |

			var buttonRect;
			var fontColor;

			( borderSize + backgroundBorderSize ).postln;

			if( index == currentState, {
				Pen.fillColor_( backColorSelected );
				fontColor = fontColorSelected;

				if( direction == \horizontal, {
					buttonRect = Rect(
						( borderSize + backgroundBorderSize ) + ( caseSize.x * index ),
						( borderSize + backgroundBorderSize ),
						caseSize.x,
						caseSize.y
					)
				}, {
					buttonRect = Rect(
						( borderSize + backgroundBorderSize ),
						( borderSize + backgroundBorderSize ) + ( caseSize.y * index ),
						caseSize.x,
						caseSize.y
					)
				} );

			}, {
				Pen.fillColor_( backColorUnselected );
				fontColor = fontColorUnselected;

				if( direction == \horizontal, {
					buttonRect = Rect(
						( borderSize + backgroundBorderSize ) + ( caseSize.x * index ) + unselectedMargin,
						( borderSize + backgroundBorderSize ) + unselectedMargin,
						caseSize.x  - ( unselectedMargin * 2 ),
						caseSize.y  - ( unselectedMargin * 2 ),
					)
				}, {
					buttonRect = Rect(
						( borderSize + backgroundBorderSize ) + unselectedMargin,
						( borderSize + backgroundBorderSize ) + ( caseSize.y * index ) + unselectedMargin,
						caseSize.x  - ( unselectedMargin * 2 ),
						caseSize.y  - ( unselectedMargin * 2 ),
					)
				} );

			} );

			Pen.fillRect( buttonRect );
			Pen.stringCenteredIn(
				text,
				buttonRect,
				font,
				fontColor,
			);
		} );
	};

	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
	view.addUniqueMethod( \setUnselectedRatio, { | self, newRatio | unselectedRatio = newRatio; view.refresh } );
	view.addUniqueMethod( \setDirection, { | self, newDirection | direction = newDirection; view.refresh } );
	view.addUniqueMethod( \setFont, { | self, newFont | font = newFont; view.refresh } );
	view.addUniqueMethod( \setState, { | self, newState |
		currentState = newState;
		if( currentState >= labels.size, { currentState = 0 } );
		view.refresh; } );
	view.addUniqueMethod( \setLabels, { | self, newLabels |
		labels = newLabels;
		currentState = 0;
		view.refresh } );
	view.addUniqueMethod( \bindFunction, { | self, function | view.mouseDownAction_( { | view, x, y |
		if( direction == \horizontal, {
			currentState = x.linlin( 0, view.bounds.width, 0, labels.size ).asInt
		}, {
			currentState = y.linlin( 0, view.bounds.height, 0, labels.size ).asInt
		} );
		function.value( currentState );
		view.refresh;
	} ) } );

	view
}
)