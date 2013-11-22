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
    defaultPoints = [self setDefaultPoints];
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
    CGPoint point;
    unsigned int i;
//    NSMutableArray *thisPath;

    for (i=0; i<[pathPointArray count]; i++) {
        point = [[pathPointArray objectAtIndex:i] CGPointValue];
        NSLog(@"%.2f %.2f", point.x, point.y);
    }

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
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    bitmapBytesPerRow = pixelW * 4;
    bitmapByteCount = (bitmapBytesPerRow * pixelH);
    
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
    
    int numCorrect = 0;
    float numDiff=0;

    for (int x=0; x<140; x++) { //140
        for (int y=0; y<176; y++) { //176
            int pixelInfo = ((image.size.width  * y) + x ) * 4;
            UInt8 red = data[pixelInfo]; // the path was drawned in red
            int templatePixelInfo = ((templateImage.size.width  * y) + x ) * 4;
            UInt8 templateRed = templateData[templatePixelInfo];
            numDiff += abs(red - templateRed) / (float)255;
            if ((red || templateRed) && (red == templateRed))
                numCorrect++;
        }
    }
    
    CFRelease(pixelData);
    CFRelease(templatePixelData);

    numDiff = (numDiff * 100) / (140 * 176);
    NSLog(@"numDiff: %0.2f", numDiff);
    if (numCorrect == 0)
        return 0;
    else if (numDiff < 8)
        return 100.0;
    else if (numDiff < 16 && numDiff >= 8)
        return 90.0;
    else if (numDiff < 24 && numDiff >= 16)
        return 80.0;
    else
        return 70.0;
}

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

- (float)pathLength:(NSMutableArray *)points {
    float d = 0.0f;
    
    for (unsigned int i=1; i<[points count]; i++) {
        CGPoint prevPoint = [points[i-1] CGPointValue];
        CGPoint thisPoint = [points[i] CGPointValue];
        d += [self distanceFrom:prevPoint to:thisPoint];
    }
    return d;
}

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

- (float) distanceFrom:(CGPoint)point1 to:(CGPoint)point2 {
    float deltaX = point2.x - point1.x;
    float deltaY = point2.y - point1.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

- (NSMutableArray *) setDefaultPoints {
    int i=0;
    NSMutableArray *defpoints = [[NSMutableArray alloc] initWithCapacity: 26];
    
    // A
    NSMutableArray *points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.00, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.50, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 50.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 59.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 79.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 109.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.00, 129.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 153.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 154.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 127.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 113.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 31.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 120.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 146.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 151.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 142.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.00, 121.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 105.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.50, 93.00)]];
    [defpoints insertObject:points atIndex:i++];
 
    // B
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.50, 50.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.50, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.50, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 41.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.00, 45.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.00, 45.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 52.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.00, 63.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(124.00, 72.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.00, 79.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.50, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(112.50, 88.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 94.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 98.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 83.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 84.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.00, 92.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.00, 99.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 110.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 117.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.50, 123.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.50, 130.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 134.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 137.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.50, 139.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.00, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 136.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 124.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 121.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 122.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 120.00)]];
    [defpoints insertObject:points atIndex:i++];

    // C
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(118.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 37.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 49.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 57.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 49.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.00, 42.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(109.50, 32.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.00, 25.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(65.00, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 55.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 67.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 83.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 98.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 117.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 131.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 140.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 148.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 139.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(101.50, 125.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 118.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.50, 107.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(119.00, 96.50)]];
    [defpoints insertObject:points atIndex:i++];
    
    // D
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 135.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(26.50, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(15.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 123.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.00, 120.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.00, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.00, 126.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.50, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.00, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 144.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.00, 132.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(95.00, 119.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 106.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.50, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 72.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 42.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 31.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(84.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.50, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 42.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 50.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(79.50, 56.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 60.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(98.00, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.50, 48.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.00, 40.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(125.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.50, 26.50)]];
    [defpoints insertObject:points atIndex:i++];
    
    // E
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.00, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(97.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 43.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.00, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.50, 44.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 36.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.50, 28.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(80.50, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 26.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 30.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.00, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 46.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 56.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 67.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 91.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.50, 95.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(70.00, 93.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 87.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.00, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 80.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 82.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 87.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.00, 95.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(17.00, 104.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(16.50, 115.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.50, 126.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.50, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.50, 150.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 152.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.50, 153.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.50, 150.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 144.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 135.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(106.50, 119.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 93.50)]];
    [defpoints insertObject:points atIndex:i++];
    
    // F
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 28.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 62.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(48.00, 66.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 62.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 51.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(47.50, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 32.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 27.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 36.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(104.00, 35.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.00, 33.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 25.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(91.00, 34.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 57.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 99.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.50, 132.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 143.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 149.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(28.00, 145.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(9.00, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(31.50, 97.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 102.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 100.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 96.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 105.00)]];
    [defpoints insertObject:points atIndex:i++];
 
    // G
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(12.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(22.00, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 136.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.00, 124.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 105.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(71.50, 85.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(86.50, 60.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 50.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 38.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.00, 26.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 23.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.00, 23.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(74.00, 33.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 48.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 58.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 68.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 81.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(72.00, 88.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 91.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 89.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.00, 78.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.00, 52.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(100.00, 118.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(90.50, 138.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(82.50, 146.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(77.00, 152.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.50, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(60.00, 156.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 151.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.50, 138.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.00, 126.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 90.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 101.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(45.50, 110.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 116.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.50, 117.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(69.00, 118.00)]];
    [defpoints insertObject:points atIndex:i++];
    
    // H
    points = [[NSMutableArray alloc] init];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 23.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(39.00, 37.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(37.50, 48.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.50, 58.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.00, 63.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 55.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 39.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.50, 28.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(35.50, 22.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 27.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 38.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 54.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.50, 67.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.00, 159.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.50, 28.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(123.50, 25.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(116.50, 23.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.00, 28.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(102.50, 34.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.00, 44.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.00, 54.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.00, 160.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 119.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(67.50, 108.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(63.00, 98.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 98.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.00, 88.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.00, 87.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(41.00, 93.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 103.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 112.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(49.00, 119.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(56.50, 123.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 122.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.00, 122.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(92.50, 114.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 107.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(103.50, 100.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(108.50, 96.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(111.50, 89.50)]];
    [defpoints insertObject:points atIndex:i++];
    
    // I
    points = [[NSMutableArray alloc] init];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 156.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 145.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.00, 126.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.00, 106.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(85.50, 85.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.50, 70.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.50, 55.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(99.50, 43.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(107.50, 32.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(114.00, 29.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(122.00, 29.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(127.00, 34.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(129.00, 45.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(126.00, 56.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(121.50, 69.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(115.50, 85.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(105.50, 101.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(96.50, 117.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(87.00, 130.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(76.50, 139.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.50, 147.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(59.00, 153.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 156.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(46.50, 155.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(40.00, 153.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(34.00, 146.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(27.00, 139.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(18.00, 121.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(14.50, 108.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.50, 99.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(13.50, 93.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.00, 102.50)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(23.50, 108.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(24.50, 108.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(29.50, 113.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(36.50, 116.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(43.50, 116.00)]];
     [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.00, 116.00)]];
    [defpoints insertObject:points atIndex:i++];
    
    // J
    points = [[NSMutableArray alloc] init];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(68.00, 125.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(62.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 113.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(57.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.50, 96.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 85.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(53.50, 67.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(54.50, 51.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(61.00, 39.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(66.50, 27.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(73.50, 18.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(81.50, 15.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(89.50, 18.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.00, 22.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(93.50, 30.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(88.00, 40.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(83.50, 53.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(75.50, 74.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(64.00, 97.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(50.50, 133.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(42.00, 152.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(38.50, 160.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(33.00, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(25.50, 166.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(20.50, 163.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(19.50, 154.50)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(30.00, 147.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(44.00, 131.00)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(128.50, 64.50)]];
    [defpoints insertObject:points atIndex:i++];
    
//    points = [[NSMutableArray alloc] init];
//    [defpoints insertObject:points atIndex:i++];
    
    
    for (i=0; i<[defpoints count]; i++)
        defpoints[i] = [self resample:defpoints[i]];
    
    return defpoints;
}

@end
