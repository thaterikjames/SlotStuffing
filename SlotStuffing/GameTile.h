

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
-(void)setComboCallback:(SEL)theCallback forId:(id)theId;
-(id)initWithSprite:(CCSprite *)sprite;
-(CGRect)getRect;

-(NSString *)clicked;

@end
