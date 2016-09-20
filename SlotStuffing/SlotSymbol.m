//
//  SlotSymbol.m
//  SlotStuffing
//
//  Created by Erik James on 11/24/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "SlotSymbol.h"


@implementation SlotSymbol

+(id)spriteWithSymbolNamed:(NSString*)symbolName
{
    SlotSymbol *slotSymbol = [[self alloc] initWithImageNamed:[NSString stringWithFormat:@"symbol-%@.png", symbolName]];
    [slotSymbol setSymbolName:symbolName];
    return slotSymbol;
}

-(void)bounce
{
   
 CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:
                                     [CCActionSequence actionOne:[CCActionRotateTo actionWithDuration:0.25f angle:-5]
                                                             two:[CCActionRotateTo  actionWithDuration:0.25f angle:5]]];
    
    [self runAction:repeat];
}
@end
