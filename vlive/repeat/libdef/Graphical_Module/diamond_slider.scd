(
{ arg
	sliderColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ),
	borderSize = ~gm.at( \borderSize ),
	orientation = \horizontal,
	drawEndLine = false,
	sliderRatio = 0.6,
	sliderMaxSize = 64,
	growthType = \exp,
	minVal = 55,
	value = 440,
	maxVal = 1760;

	var view = UserView();

	view.drawFunc = { | view |

		var sliderPos;
		var sliderHalfSize;

		if( orientation == \horizontal, {
			sliderHalfSize = view.bounds.height * sliderRatio / 2;
			if( growthType == \lin, {
				sliderPos = value.linlin( minVal, maxVal, borderSize, view.bounds.width - borderSize )
			}, {
				sliderPos = value.explin( minVal, maxVal, borderSize, view.bounds.width - borderSize )
			} );
		}, {
			sliderHalfSize = view.bounds.width * sliderRatio / 2;
			if( growthType == \lin, {
				sliderPos = value.linlin( minVal, maxVal, view.bounds.height - borderSize, borderSize )
			}, {
				sliderPos = value.explin( minVal, maxVal, view.bounds.height - borderSize, borderSize )
			} );
		} );

		if( sliderHalfSize > ( sliderMaxSize / 2 ), { sliderHalfSize = sliderMaxSize / 2 } );

		Pen.fillColor_( backgroundColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);

		if( orientation == \horizontal, {
			Pen.moveTo( Point( 0, view.bounds.height / 2 ) );
			Pen.lineTo( Point( sliderPos - sliderHalfSize, view.bounds.height / 2	) );
			Pen.lineTo( Point( sliderPos, view.bounds.height / 2 - sliderHalfSize	) );
			Pen.lineTo( Point( sliderPos + sliderHalfSize, view.bounds.height / 2  ) );
			Pen.lineTo( Point( sliderPos,	view.bounds.height / 2 + sliderHalfSize	) );
			Pen.lineTo( Point( sliderPos - sliderHalfSize,	view.bounds.height / 2	) );
			Pen.strokeColor_( sliderColor );
			Pen.width_( borderSize );
			Pen.stroke;

			if( drawEndLine, {
			Pen.moveTo( Point( sliderPos + sliderHalfSize, view.bounds.height / 2 ) );
			Pen.lineTo( Point( view.bounds.width,	view.bounds.height / 2	) );
				Pen.stroke;
			} );

			Pen.moveTo( Point( sliderPos - ( sliderHalfSize / 2 ), view.bounds.height / 2 ) );
			Pen.lineTo( Point( sliderPos, view.bounds.height / 2 - ( sliderHalfSize / 2 ) ) );
			Pen.lineTo( Point( sliderPos + ( sliderHalfSize / 2 ), view.bounds.height / 2 ) );
			Pen.lineTo( Point( sliderPos,	view.bounds.height / 2 + ( sliderHalfSize / 2 ) ) );
			Pen.lineTo( Point( sliderPos - ( sliderHalfSize / 2 ), view.bounds.height / 2 ) );
			Pen.fillColor_( sliderColor );
			Pen.fill;
		}, { // Vertical slider
			Pen.moveTo( Point( view.bounds.width / 2, sliderPos - sliderHalfSize ) );
			Pen.lineTo( Point( view.bounds.width / 2 - sliderHalfSize, sliderPos ) );
			Pen.lineTo( Point( view.bounds.width / 2, sliderPos + sliderHalfSize ) );
			Pen.lineTo( Point( view.bounds.width / 2 + sliderHalfSize	, sliderPos ) );
			Pen.lineTo( Point( view.bounds.width / 2, sliderPos - sliderHalfSize ) );
			Pen.moveTo( Point( view.bounds.width / 2, sliderPos + sliderHalfSize ) );
			Pen.lineTo( Point( view.bounds.width / 2,	view.bounds.height	) );
			Pen.strokeColor_( sliderColor );
			Pen.width_( borderSize );
			Pen.stroke;

			if( drawEndLine, {
				Pen.moveTo( Point( view.bounds.width / 2, 0 ) );
				Pen.lineTo( Point( view.bounds.width / 2, sliderPos - sliderHalfSize ) );
				Pen.stroke;
			} );

			Pen.moveTo( Point( view.bounds.width / 2, sliderPos - ( sliderHalfSize / 2 ) ) );
			Pen.lineTo( Point( view.bounds.width / 2 - ( sliderHalfSize / 2 ), sliderPos ) );
			Pen.lineTo( Point( view.bounds.width / 2, sliderPos + ( sliderHalfSize / 2 ) ) );
			Pen.lineTo( Point( view.bounds.width / 2 + ( sliderHalfSize / 2 ), sliderPos ) );
			Pen.lineTo( Point( view.bounds.width / 2, sliderPos - ( sliderHalfSize / 2 ) ) );
			Pen.fillColor_( sliderColor );
			Pen.fill;
		} );

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
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setDrawEndLine, { | self, bool | drawEndLine = bool; view.refresh } );
	view.addUniqueMethod( \setSliderRatio, { | self, newSize | sliderRatio = newSize; view.refresh } );
	view.addUniqueMethod( \setSliderMaxSize, { | self, newSize | sliderMaxSize = newSize; view.refresh } );
	view.addUniqueMethod( \setMin, { | self, newValue |
		minVal = newValue;
		if( value < minVal, { value = minVal } );
		if( maxVal < minVal, { maxVal = minVal } );
		view.refresh } );
	view.addUniqueMethod( \setMax, { | self, newValue |
		maxVal = newValue;
		if( value > maxVal, { value = maxVal } );
		if( minVal > maxVal, { minVal = maxVal } );
		view.refresh } );
	view.addUniqueMethod( \setValue, { | self, newValue |
		value = newValue;
		if( value < minVal, { value = minVal } );
		if( value > maxVal, { value = maxVal } );
		view.refresh } );
	view.addUniqueMethod( \setGrowthType, { | self, newType |
		growthType = newType;
		if( (growthType != \lin )&&( growthType != \exp ), { growthType = \lin } );
		if( growthType == \exp, {
			if( minVal == 0, {
				view.setMin( 1 )
			} )
		} )
	} );
	view.addUniqueMethod( \bindFunction, { | self, function |
		view.mouseDownAction = { | view, x, y |
			if( orientation == \horizontal, {
				if( growthType == \lin, {
					value = x.linlin( borderSize, view.bounds.width - borderSize, minVal, maxVal, clip: \minmax )
				}, {
					value = x.linexp( borderSize, view.bounds.width - borderSize, minVal, maxVal, clip: \minmax )
				} );
			}, {
				if( growthType == \lin, {
					value = ( view.bounds.height - y ).linlin( borderSize, view.bounds.height - borderSize, minVal, maxVal, borderSize, clip: \minmax )
				}, {
					value = ( view.bounds.height - y ).linexp( borderSize, view.bounds.height - borderSize, minVal, maxVal, borderSize, clip: \minmax )
				} );
			} );

			function.value( value );
			view.refresh;
		};

		view.mouseMoveAction = view.mouseDownAction;
	} );

	view
}
)