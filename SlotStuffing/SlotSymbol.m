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
    SlotSymbol *slotSymbol = [[self alloc] initWithImageNamed:[NSString stringWithFormat:@"symbols-%@.png", symbolName]];
    [slotSymbol setSymbolName:symbolName];
    return slotSymbol;
}
@end
