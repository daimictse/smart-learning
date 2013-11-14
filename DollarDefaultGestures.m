#import "DollarDefaultGestures.h"
#import "DollarPointCloud.h"
#import "DollarPoint.h"

DollarPointCloud * MakePointCloud(NSString *name, NSArray *points) {
    return [[DollarPointCloud alloc] initWithName:name points:points];
}

DollarPoint * MakePoint(float x, float y, int id) {
    return [[DollarPoint alloc] initWithId:@(id) x:x y:y];
}

@implementation DollarDefaultGestures

+ (id)defaultPointClouds {
    static NSArray *defaultPointClouds = nil;
    if (!defaultPointClouds) {
        defaultPointClouds = [self pointClouds];
    }
    return defaultPointClouds;
}

+ (NSMutableArray *)pointClouds {
    NSMutableArray *pointClouds = [NSMutableArray array];
    
        pointClouds[0] = MakePointCloud(@"T", @[
                                    MakePoint(30,7,1),
                                    MakePoint(103,7,1),
                      
                                    MakePoint(66,7,2),
                                    MakePoint(66,87,2)
                                    ]);
    
    
    return pointClouds;
}

@end