(
{ arg
	sliderColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ),
	borderSize = ~gm.at( \borderSize ),
	orientation = \horizontal,
	isFading = true,
	dotSize = 6,
	growthType = \lin,
	minVal = 0,
	maxVal = 1,
	values = [ 0.8, 0.7, 0.6, 0.55, 0.5, 0.45, 0.4, 0.35 ],
	origin = 0,
	end = 0,
	drawDots = true,
	drawExtremitiesDots = true,
	lineWidth = 1,
	drawLines = true,
	isLooping = false;

	var view = UserView();

	view.drawFunc = { | view |

		// Variables
		var caseSize;
		var pointPositions = List( 0 );

		// Draw frame
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

		// Calculate case size
		if( orientation == \horizontal, {
			caseSize = view.bounds.width - ( borderSize * 2 ) / values.size
		}, {
			caseSize = view.bounds.height - ( borderSize * 2 ) / values.size
		} );

		// We'll fetch every point position,
		// one for each value plus the origin and end points.
		if( orientation == \horizontal, {
			case
			{ origin == 0 } {
				pointPositions.add(
					Point( caseSize / 2, view.bounds.height - borderSize ) ) }
			{ origin == 1 } {
				var position;

				if( growthType == \lin, {
					position = values[ 0 ].linlin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				}, {
					position = values[ 0 ].explin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				} );

				pointPositions.add( Point( borderSize, position ) ) };
		}, { // if \vertical
			case
			{ origin == 0 } {
				pointPositions.add(
					Point( borderSize, caseSize / 2 ) ) }
			{ origin == 1 } {
				var position;

				if( growthType == \lin, {
					position = values[ 0 ].linlin(
						minVal, maxVal,
						borderSize, view.bounds.width - borderSize )
				}, {
					position = values[ 0 ].explin(
						minVal, maxVal,
						borderSize, view.bounds.width - borderSize )
				} );

				pointPositions.add(
					Point( position, borderSize ) ) };
		} );

		values.do( { | value, index |
			var pointPosition = Point();
			if( orientation == \vertical, {
				if( growthType == \lin, {
					pointPosition.x = value.linlin(
						minVal, maxVal, borderSize,
						view.bounds.width - borderSize )
				}, {
					pointPosition.x = value.explin(
						minVal, maxVal, borderSize,
						view.bounds.width - borderSize )
				} );
				pointPosition.y = borderSize + ( caseSize * ( index + 0.5 ) );
			}, {
				if( growthType == \lin, {
					pointPosition.y = value.linlin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				}, {
					pointPosition.y = value.explin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				} );
				pointPosition.x = borderSize + ( caseSize * ( index + 0.5 ) );
			} );
			pointPositions.add( pointPosition );
		} );

		if( orientation == \horizontal, {
			case
			{ end == 0 } {
				pointPositions.add(
					Point( view.bounds.width - borderSize - ( caseSize / 2 ), view.bounds.height - borderSize ) ) }
			{ end == 1 } {
				var position;

				if( growthType == \lin, {
					position = values[ values.size - 1 ].linlin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				}, {
					position = values[ values.size - 1 ].explin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				} );

				pointPositions.add( Point( view.bounds.width - borderSize, position ) ) };
		}, { // if \vertical
			case
			{ end == 0 } {
				pointPositions.add(
					Point( borderSize, view.bounds.height - borderSize - ( caseSize / 2 ) ) ) }
			{ end == 1 } {
				var position;

				if( growthType == \lin, {
					position = values[ values.size - 1 ].linlin(
						minVal, maxVal,
						borderSize, view.bounds.width - borderSize )
				}, {
					position = values[ values.size - 1 ].explin(
						minVal, maxVal,
						borderSize, view.bounds.width - borderSize )
				} );

				pointPositions.add(
					Point( position, view.bounds.height - borderSize ) ) };
		} );

		//

		// Draw points
		Pen.fillColor_( Color.white );

		if( drawExtremitiesDots, {
			Pen.addArc(
				pointPositions[ 0 ],
				dotSize / 2,
				0, 2pi
			);
			Pen.addArc(
				pointPositions[ pointPositions.size - 1 ],
				dotSize / 2,
				0, 2pi
			);
		} );

		if( drawDots, {
			( pointPositions.size - 2 ).do( { | index |
				Pen.addArc(
					pointPositions[ index + 1 ],
					dotSize / 2,
					0, 2pi
				);
			} );
		} );

		Pen.fill;

		/*
		var sliderPos;
		var caseSize;

		if( orientation == \horizontal, {
		caseSize = view.bounds.width - ( borderSize * 2 ) / values.size
		}, {
		caseSize = view.bounds.height - ( borderSize * 2 ) / values.size
		} );

		Pen.fillColor_( backgroundColor );
		Pen.fillRect(
		Rect(
		0,
		0,
		view.bounds.width,
		view.bounds.height
		)
		);


		values.do( { | value, index |

		if( orientation == \vertical, {
		if( growthType == \lin, {
		sliderPos = value.linlin(
		minVal, maxVal, borderSize,
		view.bounds.width - borderSize )
		}, {
		sliderPos = value.explin(
		minVal, maxVal, borderSize,
		view.bounds.width - borderSize )
		} );
		}, {
		if( growthType == \lin, {
		sliderPos = value.linlin(
		minVal, maxVal,
		view.bounds.height - borderSize, borderSize )
		}, {
		sliderPos = value.explin(
		minVal, maxVal,
		view.bounds.height - borderSize, borderSize )
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

		if( orientation == \vertical, {
		Pen.fillRect(
		Rect(
		0,
		borderSize + ( caseSize * index ) + ( caseSize * ( 1 - sliderWidthRatio / 2 ) ),
		sliderPos,
		caseSize * sliderWidthRatio
		)
		)
		}, {
		Pen.fillRect(
		Rect(
		borderSize + ( caseSize * index ) + ( caseSize * ( 1 - sliderWidthRatio / 2 ) ),
		sliderPos,
		caseSize * sliderWidthRatio,
		view.bounds.height - sliderPos
		)
		)
		} );
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
		);*/
	}; // End of drawFunc

	// Methods
	view.addUniqueMethod( \setSliderColor, { | self, newColor | sliderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setDotSize, { | self, newSize | dotSize = newSize; view.refresh } );
	view.addUniqueMethod( \setFading, { | self, bool | isFading = bool; view.refresh } );
	view.addUniqueMethod( \setMin, { | self, newValue |
		minVal = newValue;
		values.do( { | value, index | if( value < minVal, { values[ index ] = minVal } ) } );
		if( maxVal < minVal, { maxVal = minVal } );
		view.refresh } );
	view.addUniqueMethod( \setMax, { | self, newValue |
		maxVal = newValue;
		values.do( { | value, index | if( value > maxVal, { values[ index ] = maxVal } ) } );
		if( minVal > maxVal, { minVal = maxVal } );
		view.refresh } );
	view.addUniqueMethod( \setValues, { | self, newValues |
		values = newValues;
		values.do( { | value, index |
			if( value < minVal, { values[ index ] = minVal } );
			if( value > maxVal, { values[ index ] = maxVal } );
		} );
		view.refresh } );
	view.addUniqueMethod( \setGrowthType, { | self, newType |
		growthType = newType;
		if( (growthType != \lin )&&( growthType != \exp ), {
			growthType = \lin } );
		if( growthType == \exp, {
			if( minVal == 0, {
				view.setMin( 1 )
			} )
		} )
	} );
	view.addUniqueMethod( \bindFunction, { | self, function |
		view.mouseDownAction = { | view, x, y |

			var selectedIndex;

			if( orientation == \horizontal, {
				selectedIndex = x.linlin(
					borderSize, view.bounds.width - ( borderSize * 2 ),
					0, values.size ).asInteger;
			}, {
				selectedIndex = y.linlin(
					borderSize, view.bounds.height - ( borderSize * 2 ),
					0, values.size ).asInteger;
			} );

			// Safety check if user clicked on the right border
			if( selectedIndex == values.size, {
				selectedIndex = selectedIndex - 1 } );

			if( orientation == \vertical, {
				if( growthType == \lin, {
					values[ selectedIndex ] = x.linlin( borderSize, view.bounds.width - borderSize, minVal, maxVal, clip: \minmax )
				}, {
					values[ selectedIndex ] = x.linexp( borderSize, view.bounds.width - borderSize, minVal, maxVal, clip: \minmax )
				} );
			}, {
				if( growthType == \lin, {
					values[ selectedIndex ] = ( view.bounds.height - y ).linlin( borderSize, view.bounds.height - borderSize, minVal, maxVal, borderSize, clip: \minmax )
				}, {
					values[ selectedIndex ] = ( view.bounds.height - y ).linexp( borderSize, view.bounds.height - borderSize, minVal, maxVal, borderSize, clip: \minmax )
				} );
			} );

			function.value( values );
			view.refresh;
		};

		view.mouseMoveAction = view.mouseDownAction;
	} );

	view
}
)