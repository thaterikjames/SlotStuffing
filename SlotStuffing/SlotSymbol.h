//
//  SlotSymbol.h
//  SlotStuffing
//
//  Created by Erik James on 11/24/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SlotSymbol : CCSprite {
    
}

+ (id)spriteWithSymbolNamed:(NSString*)symbolName;

-(void)bounce;

@property(atomic, retain)NSString *symbolName;

@end
