//
//  Washu_s_CrabsView.h
//  Washu's Crabs
//
//  Created by Ryan on 10/8/09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "MyOpenGLView.h"

typedef struct aVertex {
	float x, y;
} vertex;
typedef struct aTriangle {
	vertex a, b, c;
	
} triangle;

@interface NoNeedForCrabsView : ScreenSaverView 
{
	MyOpenGLView *glView;
	
	triangle geometry[42];
	int positionX[2];
	int positionY[2];
	int flip[2];
	float velocity[2];
	float screenRatio;
}

- (void)setUpOpenGL;

@end
