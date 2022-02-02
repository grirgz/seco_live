
(
{ arg
	backColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ), // second border color
	hasBorderInset = ~gm.at( \hasBorderInset ), // second border
	borderSize = ~gm.at( \borderSize ),
	crossWidth = 6;

	var view = UserView();

	view.drawFunc = { | view |

		var crossHalfSize = view.bounds.width * 0.25;
		if( view.bounds.height * 0.25 < crossHalfSize, {
			crossHalfSize = view.bounds.height * 0.25 } );

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

		Pen.moveTo(
			Point( view.bounds.width / 2 - crossHalfSize, view.bounds.height / 2 - crossHalfSize ) );
		Pen.lineTo(
			Point( view.bounds.width / 2 + crossHalfSize, view.bounds.height / 2 + crossHalfSize ) );
		Pen.moveTo(
			Point( view.bounds.width / 2 - crossHalfSize, view.bounds.height / 2 + crossHalfSize ) );
		Pen.lineTo(
			Point( view.bounds.width / 2 + crossHalfSize, view.bounds.height / 2 - crossHalfSize ) );
		Pen.strokeColor_( backgroundColor );
		Pen.width_( crossWidth );
		Pen.stroke;
	}; // End of drawFunc

	// Methods
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setBackColor, { | self, newColor | backColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
		view.addUniqueMethod( \setCrossWidth, { | self, newWidth | crossWidth = newWidth; view.refresh } );
	view.addUniqueMethod( \setInset, { | self, newValue | hasBorderInset = newValue; view.refresh } );
	view.addUniqueMethod( \bindFunction, { | self, function | view.mouseDownAction_( { function.value() } ) } );

	view
}
)