///
/// Search for an Eye.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Area.h"
#import "Photo.h"
#import "ExtractConnectedRegion.h"
#include <stack>

/**
 * ExtractConnectedRegion mutating algorithm.
 */
ExtractConnectedRegion::ExtractConnectedRegion(int x, int y, Dot::Vector& points) {
	_x = x;
	_y = y;
	_points = &points;
}


/**
 * Detect RGB Differences.
 * DetectRGBDifferences: Stretch the image brightness so that it takes the range 0-255
 */
void ExtractConnectedRegion::apply(Photo& photo, Area& area) {
	
	// remove the current point from the image
	photo.pixel(_x,_y, 0);
	(*_points).push_back(Dot(_x,_y));
	
	std::stack<Dot> myStack;
	std::stack<short> stackXpos;
	std::stack<short> stackYpos;
	myStack.push(Dot(_x,_y));
	while(myStack.size()>0) {
		// get the entry at the top of the stack
		_x=myStack.top().x();
		_y=myStack.top().y();
		myStack.pop();
		// check the surrounding region for other points
		for(int ypos=_y-1; ypos<=_y+1; ypos++) {
			for(int xpos=_x-1; xpos<=_x+1; xpos++) {
				if(xpos>=0 && ypos>=0 && xpos<photo.width() && ypos<photo.height() && photo.pixel(xpos, ypos)!=0) {
					// found a point - add it to the list of points and change the x and y to reflect this new point
					(*_points).push_back(Dot(xpos,ypos));
					photo.pixel(xpos, ypos, 0);
					// push the current x and y onto the stack
					myStack.push(Dot(_x,_y));
					// x and y are the new x and y
					_x=xpos;
					_y=ypos;
					// reset the loop counter
					ypos=_y-1;
					xpos=_x-1;
				}
			}
		}
	}
}


