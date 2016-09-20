//
//  ScrollingGradient.m
//  SlotStuffing
//
//  Created by Erik James on 11/26/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "ScrollingGradient.h"


@implementation ScrollingGradient
{
    CCSprite *part1;
    CCSprite *part2;
}

-(void)onEnter
{
    [super onEnter];
    
    part1 = [CCSprite spriteWithImageNamed:@"bg-gradient-animated.png"];
    part2 = [CCSprite spriteWithImageNamed:@"bg-gradient-animated.png"];
    
    [self resetPositions];
    [self addChild:part1];
    [self addChild:part2];
    
    [self schedule:@selector(updatePosition) interval:0.02f];
}

-(void)updatePosition
{
    [part1 setPosition:ccp(part1.position.x, part1.position.y - 2)];
    [part2 setPosition:ccp(part2.position.x, part2.position.y - 2)];
    
    if(part2.position.y <= 0){
        [self resetPositions];
    }
}

-(void)resetPositions
{
    [part1 setPosition:ccp(0, 0)];
    [part2 setPosition:ccp(0, 568)];
}

@end
