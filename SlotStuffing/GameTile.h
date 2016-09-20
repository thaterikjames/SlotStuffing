//
//  BlankTile.h
//  Dont Tap the Crack
//
//  Created by Erik James on 6/1/14.
//  Copyright 2014 Gangsta Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameTile : CCNode {
    SEL callback;
    id callBackObject;
    CCClippingNode *scissor;
}

@property (atomic, readwrite) CCSprite *view;
@property (atomic, readwrite) CCSprite *bonusSprite;
@property (atomic, readwrite) BOOL cracked;
@property (atomic, readwrite) BOOL hasBeenClicked;
@property (atomic, readwrite) BOOL goTile;
@property (atomic, readwrite) BOOL locked;
@property (atomic, readwrite) BOOL bonusStar;
@property (atomic, readwrite) unsigned long clickOrder;
@property (atomic, readwrite) NSString *bonusName;

@property (atomic, readwrite) int soundOrder;

-(void)bonusClicked;
-(void)setCrackCallback:(SEL)theCallback forId:(id)theId;
-(id)initWithSprite:(CCSprite *)sprite;
-(CGRect)getRect;

-(NSString *)clicked;

@end
