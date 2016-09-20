

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject
{
}

+(UserDataManager *)sharedInstance;

-(void)setBank:(int)bank;
-(int)getBank;


-(void)setLines:(int)lines;
-(int)getLines;


-(void)setBet:(int)bet;
-(int)getBet;

@end
