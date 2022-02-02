
(
{ arg
	backColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ), // second border color
	font = ~gm.at( \mainFont ),
	fontColor = ~gm.at( \fontColor ),
	hasBorderInset = ~gm.at( \hasBorderInset ), // second border
	borderSize = ~gm.at( \borderSize ),
	text = "text";

	var view = UserView();

	//drawFunc
	view.drawFunc = { | view |
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
			Pen.fillColor_( backColor );
			Pen.fillRect(
				Rect(
					borderSize * 2,
					borderSize * 2,
					view.bounds.width - ( borderSize * 4 ),
					view.bounds.height - ( borderSize * 4 )
				)
			);
		}, { // if !hasBorderInset
			Pen.fillColor_( backColor );
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
			text,
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			),
			font,
			fontColor
		);
	}; // End of drawFunc

	// Methods
	view.addUniqueMethod( \setText, { | self, newText | text = newText; view.refresh } );
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setBackColor, { | self, newColor | backColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
	view.addUniqueMethod( \setFont, { | self, newFont | font = newFont; view.refresh } );
	view.addUniqueMethod( \setFontColor, { | self, newColor | fontColor = fontColor; view.refresh } );
	view.addUniqueMethod( \setInset, { | self, newValue | hasBorderInset = newValue; view.refresh } );
	view.addUniqueMethod( \bindFunction, { | self, function | view.mouseDownAction_( { function.value() } ) } );

	view
}
)