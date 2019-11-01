//
//  Washu_s_CrabsView.m
//  Washu's Crabs
//
//  Created by Ryan on 10/8/09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import "NoNeedForCrabsView.h"


@implementation NoNeedForCrabsView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		NSOpenGLPixelFormatAttribute attributes[] = {
			NSOpenGLPFAAccelerated,
			NSOpenGLPFADepthSize, 32,
			NSOpenGLPFAMinimumPolicy,
			NSOpenGLPFAClosestPolicy,
			0 };
		
		NSOpenGLPixelFormat *format;
        format = [[[NSOpenGLPixelFormat alloc]
				  initWithAttributes:attributes]
				  autorelease];
		glView = [[MyOpenGLView alloc] initWithFrame:frame pixelFormat:format];
		if (!glView) {
			NSLog(@"Could not initialize OpenGL View");
			[self autorelease];
			return nil;
		}
		
		[self addSubview:glView];
		[self setUpOpenGL];
		
		positionX[0] = SSRandomIntBetween(0, 200);
		positionX[1] = SSRandomIntBetween(0, 200);
		positionY[0] = SSRandomIntBetween(0, 4) * 20;
		positionY[1] = SSRandomIntBetween(5, 9) * 20;
		flip[0] = -1;
		flip[1] = 1;
			
		[self setAnimationTimeInterval:1/24.0];
        [self setFrameSize:frame.size];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect]; [[glView openGLContext] makeCurrentContext];
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
	
	for(int i = 0; i < 2; i++) {
		glLoadIdentity();
		
		glColor3f(0.6, 0.0, 0.0);
		
		glTranslatef(positionX[i], positionY[i], 0);
		glScalef(flip[i], 1, 1);
		glTranslatef(-15.5, 0, 0);
		glEnableClientState(GL_VERTEX_ARRAY);
		glVertexPointer(2, GL_FLOAT, 0, geometry);
		glDrawArrays(GL_TRIANGLES, 0, 114);
		glEnable(GL_CULL_FACE);
		glDrawArrays(GL_TRIANGLES, 114, 12);
		glDisableClientState(GL_VERTEX_ARRAY);
		glDisable(GL_CULL_FACE);
	}
	
	glFlush();
}

- (void)animateOneFrame
{
    [super animateOneFrame];
	//Adjust our state
	positionX[0] += 1;
	positionX[1] -= 1;
	for(int i = 0; i < 2; i++) {
		if (positionX[i] % 4 == 0) {
			flip[i] *= -1;
		}
		if (positionX[i] > 200 * screenRatio + 15) {
			positionX[i] = -15;
			positionY[i] = SSRandomIntBetween(0, 9) * 20;
			if (i == 0) {
				while(positionY[0] == positionY[1]) {
					positionY[0] = SSRandomIntBetween(0, 9) * 20;
				}
			}
		}else if (positionX[i] < -15) {
			positionX[i] = 200 * screenRatio + 15;
			positionY[i] = SSRandomIntBetween(0, 9) * 20;
			if (i == 1) {
				while(positionY[1] == positionY[0]) {
					positionY[1] = SSRandomIntBetween(0, 9) * 20;
				}
			}
		}
	}
	
	//Redraw
    [self setNeedsDisplay:YES];
//    return;
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

- (void) defineACrab {
	vertex verticies[66];
	verticies[0].x = 4.0; verticies[0].y = 0.0;
	verticies[1].x = 5.5; verticies[1].y = 4.5;
	verticies[2].x = 6.5; verticies[2].y = 3.5;
	verticies[3].x = 9.0; verticies[3].y = 4.0;
	verticies[4].x = 0.5; verticies[4].y = 4.5;
	verticies[5].x = 4.5; verticies[5].y = 8.0;
	verticies[6].x = 4.5; verticies[6].y = 6.5;
	verticies[7].x = 8.0; verticies[7].y = 6.0;
	verticies[8].x = 0.0; verticies[8].y = 6.5;
	verticies[9].x = 3.5; verticies[9].y = 10.0;
	verticies[10].x = 4.0; verticies[10].y = 8.5;
	verticies[11].x = 8.0; verticies[11].y = 8.0;
	verticies[12].x = 3.5; verticies[12].y = 15.0;
	verticies[13].x = 3.5; verticies[13].y = 12.0;
	verticies[14].x = 5.0; verticies[14].y = 10.5;
	verticies[15].x = 7.5; verticies[15].y = 10.5;
	verticies[16].x = 9.5; verticies[16].y = 12.0;
	verticies[17].x = 9.5; verticies[17].y = 15.0;
	verticies[18].x = 8.0; verticies[18].y = 16.5;
	verticies[19].x = 6.0; verticies[19].y = 13.0;
	verticies[20].x = 5.0; verticies[20].y = 16.5;
	verticies[21].x = 12.0; verticies[21].y = 1.0;
	verticies[22].x = 9.0; verticies[22].y = 7.0;
	verticies[23].x = 11.0; verticies[23].y = 11.0;
	verticies[24].x = 11.0; verticies[24].y = 14.0;
	verticies[25].x = 10.0; verticies[25].y = 15.0;
	verticies[26].x = 11.0; verticies[26].y = 16.0;
	verticies[27].x = 12.0; verticies[27].y = 16.0;
	verticies[28].x = 13.0; verticies[28].y = 15.0;
	verticies[29].x = 12.0; verticies[29].y = 14.0;
	verticies[30].x = 12.0; verticies[30].y = 11.0;
	verticies[31].x = 19.0; verticies[31].y = 11.0;
	verticies[32].x = 19.0; verticies[32].y = 14.0;
	verticies[33].x = 18.0; verticies[33].y = 15.0;
	verticies[34].x = 19.0; verticies[34].y = 16.0;
	verticies[35].x = 20.0; verticies[35].y = 16.0;
	verticies[36].x = 21.0; verticies[36].y = 15.0;
	verticies[37].x = 20.0; verticies[37].y = 14.0;
	verticies[38].x = 20.0; verticies[38].y = 11.0;
	verticies[39].x = 22.0; verticies[39].y = 7.0;
	verticies[40].x = 19.0; verticies[40].y = 1.0;
	verticies[41].x = 12.0; verticies[41].y = 7.0;
	verticies[42].x = 11.0; verticies[42].y = 7.0;
	verticies[43].x = 19.0; verticies[43].y = 7.0;
	verticies[44].x = 20.0; verticies[44].y = 7.0;
	verticies[45].x = 23.0; verticies[45].y = 16.5;
	verticies[46].x = 21.5; verticies[46].y = 15.0;
	verticies[47].x = 21.5; verticies[47].y = 12.0;
	verticies[48].x = 23.5; verticies[48].y = 10.5;
	verticies[49].x = 26.0; verticies[49].y = 10.5;
	verticies[50].x = 27.5; verticies[50].y = 12.0;
	verticies[51].x = 27.5; verticies[51].y = 15.0;
	verticies[52].x = 25.0; verticies[52].y = 13.0;
	verticies[53].x = 26.0; verticies[53].y = 16.5;
	verticies[54].x = 23.0; verticies[54].y = 8.0;
	verticies[55].x = 27.0; verticies[55].y = 8.0;
	verticies[56].x = 28.0; verticies[56].y = 9.5;
	verticies[57].x = 31.0; verticies[57].y = 5.5;
	verticies[58].x = 23.0; verticies[58].y = 6.0;
	verticies[59].x = 26.0; verticies[59].y = 4.5;
	verticies[60].x = 27.0; verticies[60].y = 5.5;
	verticies[61].x = 28.0; verticies[61].y = 1.0;
	verticies[62].x = 22.0; verticies[62].y = 4.0;
	verticies[63].x = 24.5; verticies[63].y = 3.0;
	verticies[64].x = 25.5; verticies[64].y = 4.0;
	verticies[65].x = 26.0; verticies[65].y = 0.0;
	
	geometry[0].a = verticies[0];	geometry[0].b = verticies[2];	geometry[0].c = verticies[1];
	geometry[1].a = verticies[1];	geometry[1].b = verticies[2];	geometry[1].c = verticies[3];
	geometry[2].a = verticies[4];	geometry[2].b = verticies[6];	geometry[2].c = verticies[5];
	geometry[3].a = verticies[5];	geometry[3].b = verticies[6];	geometry[3].c = verticies[7];
	geometry[4].a = verticies[8];	geometry[4].b = verticies[10];	geometry[4].c = verticies[9];
	geometry[5].a = verticies[9];	geometry[5].b = verticies[10];	geometry[5].c = verticies[11];
	geometry[6].a = verticies[12];	geometry[6].b = verticies[13];	geometry[6].c = verticies[19];
	geometry[7].a = verticies[13];	geometry[7].b = verticies[14];	geometry[7].c = verticies[19];
	geometry[8].a = verticies[14];	geometry[8].b = verticies[15];	geometry[8].c = verticies[19];
	geometry[9].a = verticies[15];	geometry[9].b = verticies[16];	geometry[9].c = verticies[19];
	geometry[10].a = verticies[16];	geometry[10].b = verticies[17];	geometry[10].c = verticies[19];
	geometry[11].a = verticies[17];	geometry[11].b = verticies[18];	geometry[11].c = verticies[19];
	geometry[12].a = verticies[25];	geometry[12].b = verticies[24];	geometry[12].c = verticies[26];
	geometry[13].a = verticies[27];	geometry[13].b = verticies[29];	geometry[13].c = verticies[28];
	geometry[14].a = verticies[26];	geometry[14].b = verticies[42];	geometry[14].c = verticies[27];
	geometry[15].a = verticies[42];	geometry[15].b = verticies[41];	geometry[15].c = verticies[27];
	geometry[16].a = verticies[22];	geometry[16].b = verticies[42];	geometry[16].c = verticies[23];
	geometry[17].a = verticies[22];	geometry[17].b = verticies[21];	geometry[17].c = verticies[41];
	geometry[18].a = verticies[21];	geometry[18].b = verticies[31];	geometry[18].c = verticies[30];
	geometry[19].a = verticies[31];	geometry[19].b = verticies[21];	geometry[19].c = verticies[40];
	geometry[20].a = verticies[40];	geometry[20].b = verticies[39];	geometry[20].c = verticies[43];
	geometry[21].a = verticies[39];	geometry[21].b = verticies[38];	geometry[21].c = verticies[44];
	geometry[22].a = verticies[34];	geometry[22].b = verticies[43];	geometry[22].c = verticies[35];
	geometry[23].a = verticies[43];	geometry[23].b = verticies[44];	geometry[23].c = verticies[35];
	geometry[24].a = verticies[32];	geometry[24].b = verticies[34];	geometry[24].c = verticies[33];
	geometry[25].a = verticies[35];	geometry[25].b = verticies[37];	geometry[25].c = verticies[36];
	geometry[26].a = verticies[45];	geometry[26].b = verticies[46];	geometry[26].c = verticies[52];
	geometry[27].a = verticies[46];	geometry[27].b = verticies[47];	geometry[27].c = verticies[52];
	geometry[28].a = verticies[47];	geometry[28].b = verticies[48];	geometry[28].c = verticies[52];
	geometry[29].a = verticies[48];	geometry[29].b = verticies[49];	geometry[29].c = verticies[52];
	geometry[30].a = verticies[49];	geometry[30].b = verticies[50];	geometry[30].c = verticies[52];
	geometry[31].a = verticies[50];	geometry[31].b = verticies[51];	geometry[31].c = verticies[52];
	geometry[32].a = verticies[54];	geometry[32].b = verticies[55];	geometry[32].c = verticies[56];
	geometry[33].a = verticies[55];	geometry[33].b = verticies[57];	geometry[33].c = verticies[56];
	geometry[34].a = verticies[58];	geometry[34].b = verticies[59];	geometry[34].c = verticies[60];
	geometry[35].a = verticies[59];	geometry[35].b = verticies[61];	geometry[35].c = verticies[60];
	geometry[36].a = verticies[62];	geometry[36].b = verticies[63];	geometry[36].c = verticies[64];
	geometry[37].a = verticies[63];	geometry[37].b = verticies[65];	geometry[37].c = verticies[64];
	geometry[38].a = verticies[12];	geometry[38].b = verticies[19];	geometry[38].c = verticies[20];
	geometry[39].a = verticies[18];	geometry[39].b = verticies[20];	geometry[39].c = verticies[19];
	geometry[40].a = verticies[45];	geometry[40].b = verticies[52];	geometry[40].c = verticies[53];
	geometry[41].a = verticies[53];	geometry[41].b = verticies[52];	geometry[41].c = verticies[51];
}

- (void)setUpOpenGL
{
	[[glView openGLContext] makeCurrentContext];
	[self defineACrab];
    glClearColor( 0, 0, 0, 0 ) ;
}

- (void)setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
	[glView setFrameSize:newSize];
	screenRatio = newSize.width / newSize.height;
	[[glView openGLContext] makeCurrentContext];
	
	//reshape
	glMatrixMode( GL_PROJECTION ) ;
    glLoadIdentity() ;
    glOrtho( 0, 200 * screenRatio , 0, 200, -1, 1 ) ;
    glMatrixMode( GL_MODELVIEW ) ;
	
	[[glView openGLContext] update];
}
@end
