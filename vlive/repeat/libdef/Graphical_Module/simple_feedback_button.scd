
(
{ arg
	backColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ), // second border color
	feedbackColor = Color.black,
	font = ~gm.at( \mainFont ),
	fontColor = ~gm.at( \fontColor ),
	hasBorderInset = ~gm.at( \hasBorderInset ), // second border
	borderSize = ~gm.at( \borderSize ),
	text = "text",
	animationLength = 20; // In frames, at 60 fps

	var button = UserView.new();

	button.drawFunc = { | view |

		var currentBackColor = backColor.deepCopy;

		if( button.animate, {
			if( button.frame == animationLength, {
				button.animate = false
			}, {
				var frame_offset = 1.0 / animationLength * ( button.frame - 1 );
				currentBackColor.red = feedbackColor.red + ( backColor.red - feedbackColor.red * frame_offset );
				currentBackColor.green = feedbackColor.green + ( backColor.green - feedbackColor.green * frame_offset );
				currentBackColor.blue = feedbackColor.blue + ( backColor.blue - feedbackColor.blue * frame_offset );
			} );
		} );

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
			Pen.fillColor_( currentBackColor );
			Pen.fillRect(
				Rect(
					borderSize * 2,
					borderSize * 2,
					view.bounds.width - ( borderSize * 4 ),
					view.bounds.height - ( borderSize * 4 )
				)
			);
		}, { // if !hasBorderInset
			Pen.fillColor_( currentBackColor );
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
	};

	button.addUniqueMethod( \setText, { | self, newText | text = newText; button.refresh } );
	button.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; button.refresh } );
	button.addUniqueMethod( \setBackColor, { | self, newColor | backColor = newColor; button.refresh } );
	button.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; button.refresh } );
	button.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; button.refresh } );
	button.addUniqueMethod( \setFeedbackColor, { | self, newColor | feedbackColor = newColor; button.refresh } );
	button.addUniqueMethod( \setAnimationLength, { | self, newLength | animationLength = newLength } );
	button.addUniqueMethod( \setFont, { | self, newFont | font = newFont; button.refresh } );
	button.addUniqueMethod( \setFontColor, { | self, newColor | fontColor = fontColor; button.refresh } );
	button.addUniqueMethod( \setInset, { | self, newValue | hasBorderInset = newValue; button.refresh } );
	button.addUniqueMethod( \bindFunction, { | self, function | button.mouseDownAction_( {
		function.value();
		button.animate = false;
		button.animate = true;
	} ) } );

	button
}
)