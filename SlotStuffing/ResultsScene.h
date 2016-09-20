//
//  ResultsScene.h
//  SlotStuffing
//
//  Created by Erik James on 11/25/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface ResultsScene : CCScene {
    
}

+ (ResultsScene *)sceneWithResults:(NSArray *)results;
+(NSString *)returnFormattedDollarAmount:(int)amount;

@end
