//
//  ComboDisplay.h
//  SlotStuffing
//
//  Created by Erik James on 11/25/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ComboDisplay : CCSprite {
    
}


+(ComboDisplay *)comboWithNumber:(int)amount ofFruit:(NSString *)fruit;

@end
