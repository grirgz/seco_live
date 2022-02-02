(
{ arg
	sliderColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ),
	borderSize = ~gm.at( \borderSize ),
	orientation = \vertical,
	isFading = true,
	sliderWidthRatio = 0.75,
	growthType = \exp,
	minVal = 55,
	value = 440,
	maxVal = 1760;

	var view = UserView();

	view.drawFunc = { | view |

		var sliderPos;

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
			if( growthType == \lin, {
				sliderPos = value.linlin( minVal, maxVal, borderSize, view.bounds.width - borderSize )
			}, {
				sliderPos = value.explin( minVal, maxVal, borderSize, view.bounds.width - borderSize )
			} );
		}, {
			if( growthType == \lin, {
				sliderPos = value.linlin( minVal, maxVal, view.bounds.height - borderSize, borderSize )
			}, {
				sliderPos = value.explin( minVal, maxVal, view.bounds.height - borderSize, borderSize )
			} );
		} );

		if( isFading, {

			var alpha;

			if( growthType == \lin, {
				alpha = value.linlin( minVal, maxVal, 0, 1 )
			}, {
				alpha = value.explin( minVal, maxVal, 0, 1 )
			} );

			Pen.fillColor_(
				Color(
					sliderColor.red,
					sliderColor.green,
					sliderColor.blue,
					alpha
				)
			)
		}, {
			Pen.fillColor_( sliderColor )
		} );

		if( orientation == \horizontal, {
			Pen.fillRect(
				Rect(
					0,
					view.bounds.height * ( 1 - sliderWidthRatio / 2 ),
					sliderPos,
					view.bounds.height * sliderWidthRatio
				)
			)
		}, {
			Pen.fillRect(
				Rect(
					view.bounds.width * ( 1 - sliderWidthRatio / 2 ),
					sliderPos,
					view.bounds.width * sliderWidthRatio,
					view.bounds.height - sliderPos
				)
			)
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
	view.addUniqueMethod( \setSliderWidthRatio, { | self, newSize | sliderWidthRatio = newSize; view.refresh } );
	view.addUniqueMethod( \setFading, { | self, bool | isFading = bool; view.refresh } );
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