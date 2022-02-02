(
{ arg
	sliderColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	bottomLeftColor = ~gm.at( \secondaryColor ),
	topRightColor = ~gm.at( \backgroundColor ),
	borderSize = ~gm.at( \borderSize ),
	sliderHalfSize = 22,
	growthTypeX = \exp,
	minValX = 20,
	valueX = 440,
	maxValX = 20000,
	growthTypeY = \lin,
	minValY = 0,
	valueY = 0.5,
	maxValY = 1;

	var view = UserView();

	view.drawFunc = { | view |

		var sliderPos = Point( 0, 0 );

		if( growthTypeX == \lin, {
			sliderPos.x = valueX.linlin( minValX, maxValX, borderSize, view.bounds.width - borderSize )
		}, {
			sliderPos.x = valueX.explin( minValX, maxValX, borderSize, view.bounds.width - borderSize )
		} );

		if( growthTypeY == \lin, {
			sliderPos.y = valueY.linlin( minValY, maxValY, view.bounds.height - borderSize, borderSize )
		}, {
			sliderPos.y = valueY.explin( minValY, maxValY, view.bounds.height - borderSize, borderSize )
		} );

		// First, draw the background frame:
		Pen.addRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
		) );
		Pen.fillAxialGradient(
			view.bounds.width@0,
			0@view.bounds.height,
			bottomLeftColor,
			topRightColor );

		// Draw the slider
		Pen.moveTo( Point( 0, sliderPos.y ) );
		Pen.lineTo( Point( sliderPos.x - sliderHalfSize, sliderPos.y ) );
		Pen.lineTo( Point( sliderPos.x, sliderPos.y - sliderHalfSize ) );
		Pen.lineTo( Point( sliderPos.x, 0 ) );

		Pen.moveTo( Point( view.bounds.width, sliderPos.y ) );
		Pen.lineTo( Point( sliderPos.x + sliderHalfSize, sliderPos.y ) );
		Pen.lineTo( Point( sliderPos.x, sliderPos.y + sliderHalfSize ) );
		Pen.lineTo( Point( sliderPos.x, view.bounds.height ) );

		Pen.strokeColor_( sliderColor );
		Pen.width_( borderSize );
		Pen.stroke;

		Pen.moveTo( Point( sliderPos.x - ( sliderHalfSize / 2 ), sliderPos.y ) );
		Pen.lineTo( Point( sliderPos.x, sliderPos.y - ( sliderHalfSize / 2 ) ) );
		Pen.lineTo( Point( sliderPos.x + ( sliderHalfSize / 2 ), sliderPos.y ) );
		Pen.lineTo( Point( sliderPos.x, sliderPos.y + ( sliderHalfSize / 2 ) ) );
		Pen.lineTo( Point( sliderPos.x - ( sliderHalfSize / 2 ), sliderPos.y ) );

		Pen.fillColor_( sliderColor );
		Pen.fill;

		// Draw the border on top
		Pen.fillColor_( borderColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				borderSize,
				view.bounds.height
			)
		);

		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				borderSize
			)
		);

		Pen.fillRect(
			Rect(
				view.bounds.width - borderSize,
				0,
				borderSize,
				view.bounds.height
			)
		);

		Pen.fillRect(
			Rect(
				0,
				view.bounds.height - borderSize,
				view.bounds.width,
				borderSize
			)
		);
	};

	view.addUniqueMethod( \setSliderColor, { | self, newColor | sliderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBottomLeftColor, { | self, newColor | bottomLeftColor = newColor; view.refresh } );
	view.addUniqueMethod( \setTopRightColor, { | self, newColor | topRightColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setSliderSize, { | self, newSize | sliderHalfSize = newSize / 2; view.refresh } );

	view.addUniqueMethod( \setMinX, { | self, newValue |
		minValX = newValue;
		if( valueX < minValX, { valueX = minValX } );
		if( maxValX < minValX, { maxValX = minValX } );
		view.refresh } );
	view.addUniqueMethod( \setMaxX, { | self, newValue |
		maxValX = newValue;
		if( valueX > maxValX, { valueX = maxValX } );
		if( minValX > maxValX, { minValX = maxValX } );
		view.refresh } );
	view.addUniqueMethod( \setValueX, { | self, newValue |
		valueX = newValue;
		if( valueX < minValX, { valueX = minValX } );
		if( valueX > maxValX, { valueX = maxValX } );
		view.refresh } );
	view.addUniqueMethod( \setGrowthTypeX, { | self, newType |
		growthTypeX = newType;
		if( (growthTypeX != \lin )&&( growthTypeX != \exp ), { growthTypeX = \lin } );
		if( growthTypeX == \exp, {
			if( minValX == 0, {
				view.setMinX( 1 )
			} )
		} )
	} );

	view.addUniqueMethod( \setMinY, { | self, newValue |
		minValY = newValue;
		if( valueY < minValY, { valueY = minValY } );
		if( maxValY < minValY, { maxValY = minValY } );
		view.refresh } );
	view.addUniqueMethod( \setMaxY, { | self, newValue |
		maxValY = newValue;
		if( valueY > maxValY, { valueY = maxValY } );
		if( minValY > maxValY, { minValY = maxValY } );
		view.refresh } );
	view.addUniqueMethod( \setValueY, { | self, newValue |
		valueY = newValue;
		if( valueY < minValY, { valueY = minValY } );
		if( valueY > maxValY, { valueY = maxValY } );
		view.refresh } );
	view.addUniqueMethod( \setGrowthTypeY, { | self, newType |
		growthTypeY = newType;
		if( (growthTypeY != \lin )&&( growthTypeY != \exp ), { growthTypeY = \lin } );
		if( growthTypeY == \exp, {
			if( minValY == 0, {
				view.setMinY( 1 )
			} )
		} )
	} );

	view.addUniqueMethod( \bindFunction, { | self, function |
		view.mouseDownAction = { | view, x, y |

			if( growthTypeX == \lin, {
				valueX = x.linlin( borderSize, view.bounds.width - borderSize, minValX, maxValX, clip: \minmax )
			}, {
				valueX = x.linexp( borderSize, view.bounds.width - borderSize, minValX, maxValX, clip: \minmax )
			} );

			if( growthTypeY == \lin, {
				valueY = ( view.bounds.height - y ).linlin( borderSize, view.bounds.height - borderSize, minValY, maxValY, borderSize, clip: \minmax )
			}, {
				valueY = ( view.bounds.height - y ).linexp( borderSize, view.bounds.height - borderSize, minValY, maxValY, borderSize, clip: \minmax )
			} );

			function.value( [ valueX, valueY ] );
			view.refresh;
		};

		view.mouseMoveAction = view.mouseDownAction;
	} );

	view
}
)