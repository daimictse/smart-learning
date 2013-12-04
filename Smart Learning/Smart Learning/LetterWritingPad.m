//
//  LetterWritingPad.m
//  Smart Learning
//
//  Created by Doris Shum on 11/8/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "LetterWritingPad.h"

@implementation LetterWritingPad

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"pad init");
    strokeCount = 0;
    pathPointArray = [[NSMutableArray alloc]init];
    defaultPoints = [[NSMutableArray alloc] initWithCapacity: 26];
    if (self = [super initWithCoder:aDecoder]) {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor: [UIColor colorWithRed:225 green:225 blue:225 alpha:0.3]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:5.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    [path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"pad touchesbegan");
    strokeCount++;
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
    [pathPointArray addObject:[NSValue valueWithCGPoint:p]];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p];
    [self setNeedsDisplay];
    [pathPointArray addObject:[NSValue valueWithCGPoint:p]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (int) getStrokeCount {
    return strokeCount;
}

-(int) getLetterStrokeCount: (int)index {
    return strokeCountArray[index];
}

-(void)setStrokCountArray: (StrokeArray)tempArray {
    memcpy(strokeCountArray, tempArray, sizeof(strokeCountArray));
}

/*-(NSMutableArray *)getPathPoints {
    return pathPointArray;
}*/

-(NSMutableArray *) resample:(NSMutableArray *)points {
    int numPoints = 128;  // constant
    float pathLen = [self pathLength:points];
    float I = pathLen / (numPoints - 1);
    float D = 0.0f;
    
    NSMutableArray *thePoints = [points mutableCopy];
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    [newPoints addObject:[NSValue valueWithCGPoint:[points[0] CGPointValue]]];
    
    for (unsigned int i=1; i<[thePoints count]; i++) {
        CGPoint prevPoint = [thePoints[i-1] CGPointValue];
        CGPoint thisPoint = [thePoints[i] CGPointValue];
        float d = [self distanceFrom:prevPoint to:thisPoint];

        if ((D+d) >= I) {
            float qx = prevPoint.x + ((I - D) / d) * (thisPoint.x - prevPoint.x);
            float qy = prevPoint.y + ((I - D) / d) * (thisPoint.y - prevPoint.y);
            [newPoints addObject:[NSValue valueWithCGPoint:CGPointMake(qx, qy)]];
            [thePoints insertObject:[NSValue valueWithCGPoint:CGPointMake(qx, qy)] atIndex:i];
            D = 0.0f;
        } else {
            D += d;
        }
    }
    if ([newPoints count] == numPoints - 1) {
        int idx = [thePoints count] - 1;
        CGPoint lastPoint = [thePoints[idx] CGPointValue];
        [newPoints addObject:[NSValue valueWithCGPoint:CGPointMake(lastPoint.x, lastPoint.y)]];
    }
    return newPoints;
}

- (float)rateItWithTemplate:(char)letter {
    /*
    CGPoint point;
    unsigned int i;
//    NSMutableArray *thisPath;

    NSLog(@"%c", letter);
    for (i=0; i<[pathPointArray count]; i++) {
        point = [[pathPointArray objectAtIndex:i] CGPointValue];
        NSLog(@"[points addObject:[NSValue valueWithCGPoint:CGPointMake(%.2f, %.2f)]];", point.x, point.y);
    }
*/
    pathPointArray = [self resample:pathPointArray];
    
    //ascii code of A is 65
    int templateIdx = [[NSString stringWithFormat:@"%c",letter] characterAtIndex:0] - 65;
    
    // draw image from points and defaultPoints and compare the matrix of the drawing
    return [self drawAndComparePaths:pathPointArray template:defaultPoints[templateIdx]];
    //return [self comparePoints:defaultPoints[templateIdx] to:defaultPoints[templateIdx]];
}

- (void)resetDrawingPad {
    // erase path
    strokeCount = 0;
    [pathPointArray removeAllObjects];
    [path removeAllPoints];
    [self setNeedsDisplay];
}

- (CGContextRef)MyCreateBitmapContext:(int)pixelW height:(int)pixelH {
    CGContextRef context = nil;
    CGColorSpaceRef colorSpace;
    //int bitmapByteCount;
    int bitmapBytesPerRow;
    
    bitmapBytesPerRow = pixelW * 4;
    //bitmapByteCount = (bitmapBytesPerRow * pixelH);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(NULL, pixelW, pixelH, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

- (float) drawAndComparePaths:(NSMutableArray *)points template:(NSMutableArray *)templatePts {

    // draw path from user writing
    CGContextRef context = [self MyCreateBitmapContext:140 height:176];
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextSetLineWidth(context, 8.0);
    CGPoint s = [points[0] CGPointValue];
    CGContextMoveToPoint(context, s.x, s.y);
    for (int i=1; i<[points count]-1; i++) { // last control point would be second to the last point
        CGPoint cp1 = [points[i] CGPointValue];
        CGPoint cp2 = [points[i+1] CGPointValue];
        //CGPoint e = [points[i+2] CGPointValue];
        //CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
        CGContextAddQuadCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y);
    }
    CGContextStrokePath(context);
    
    // draw path from template
    CGContextRef templateCtx = [self MyCreateBitmapContext:140 height:176];
    CGContextSetRGBStrokeColor(templateCtx, 1, 0, 0, 1);
    CGContextSetLineWidth(templateCtx, 8.0);
    s = [templatePts[0] CGPointValue];
    CGContextMoveToPoint(templateCtx, s.x, s.y);
    for (int i=1; i<[templatePts count]-1; i++) { // last control point would be second to the last point
        CGPoint cp1 = [templatePts[i] CGPointValue];
        CGPoint cp2 = [templatePts[i+1] CGPointValue];
        //CGPoint e = [templatePts[i+2] CGPointValue];
        //CGContextAddCurveToPoint(templateCtx, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
        CGContextAddQuadCurveToPoint(templateCtx, cp1.x, cp1.y, cp2.x, cp2.y);
    }
    CGContextStrokePath(templateCtx);
    
    // reading rgb value from bitmap
    UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);

    UIImage *templateImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(templateCtx)];
    CFDataRef templatePixelData = CGDataProviderCopyData(CGImageGetDataProvider(templateImage.CGImage));
    const UInt8* templateData = CFDataGetBytePtr(templatePixelData);
    
    int numMustBeCorrect = 0;
    float grade=0;
    int numEasilyCorrect = 0;
    int numTemplateRed = 0;

    for (int x=0; x<140; x++) { //140
        for (int y=0; y<176; y++) { //176
            int pixelInfo = ((image.size.width  * y) + x ) * 4;
            UInt8 red = data[pixelInfo]; // the path was drawned in red
            int templatePixelInfo = ((templateImage.size.width  * y) + x ) * 4;
            UInt8 templateRed = templateData[templatePixelInfo];
            // score system is in the respect of correctness
            if (templateRed) {
                numTemplateRed++;
                if (red == templateRed) // user writing matches template
                    numMustBeCorrect++;
            }
            else if (!templateRed && (red == templateRed)) // matches on white spaces
                numEasilyCorrect++;
        }
    }
    
    CFRelease(pixelData);
    CFRelease(templatePixelData);

    if (numMustBeCorrect == 0)
        return 0;
    
    float weight = 7.5;
    float blankSpaceWeight = 2.5;
    int totalCount = (140 * 176) * blankSpaceWeight + (numTemplateRed * (weight-1));  // matches to template scores more
    grade = ((numMustBeCorrect * weight) + (numEasilyCorrect * blankSpaceWeight)) / (float)totalCount * 100;
    NSLog(@"%d * %0.1f + %d * %0.1f / %d = Grade: %0.2f", numMustBeCorrect, weight, numEasilyCorrect,blankSpaceWeight, totalCount, grade);
    return grade;
}

- (void) setDefaultPoints:(char)letter points:(NSMutableArray *)points {
    //ascii code of A is 65
    int i = [[NSString stringWithFormat:@"%c",letter] characterAtIndex:0] - 65;
    [defaultPoints insertObject:points atIndex:i];
    defaultPoints[i] = [self resample:defaultPoints[i]];
}

/*
- (float)comparePoints:(NSMutableArray *)points to:(NSMutableArray *)templatePts {
    float e = 0.5f;
    float step = floor(pow([points count], 1-e));
    float min = +INFINITY;
    
    for (int i=0; i<[points count]; i+=step) {
        float d1 = [self compareDistanceFrom:points to:templatePts start:i];
        float d2 = [self compareDistanceFrom:templatePts to:points start:i];
        min = MIN(min, MIN(d1, d2));
    }
    return min;
}
*/
- (float)pathLength:(NSMutableArray *)points {
    float d = 0.0f;
    
    for (unsigned int i=1; i<[points count]; i++) {
        CGPoint prevPoint = [points[i-1] CGPointValue];
        CGPoint thisPoint = [points[i] CGPointValue];
        d += [self distanceFrom:prevPoint to:thisPoint];
    }
    return d;
}
/*
- (float) compareDistanceFrom:(NSMutableArray *)points1 to:(NSMutableArray *)points2 start:(int)start {
    int numPoints1 = [points1 count];
    
    NSMutableArray *matched = [NSMutableArray arrayWithCapacity:numPoints1];
    for (int k=0; k<numPoints1; k++) {
        matched[k] = @NO;
    }
    
    float sum = 0.0f;
    int i = start;
    
    do {
        int index = -1;
        float min = +INFINITY;
        
        for (int j=0; j<[matched count]; j++) {
            if (![matched[j] boolValue]) {
                float d = [self distanceFrom:[points1[i] CGPointValue] to:[points2[j] CGPointValue]];
                if (d<min) {
                    min = d;
                    index = j;
                }
            }
        }
        matched[index] = @YES;
        float weight = 1 - ((i - start + numPoints1) % numPoints1) / numPoints1;
        sum += weight * min;
        i = (i+1) % numPoints1;
    } while (i != start);
    
    return sum;
}
*/
- (float) distanceFrom:(CGPoint)point1 to:(CGPoint)point2 {
    float deltaX = point2.x - point1.x;
    float deltaY = point2.y - point1.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}


@end
