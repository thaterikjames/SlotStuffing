

#import "UserDataManager.h"

#define BANK_START  1000
#define BET_START    20
#define LINES_START  20

#define BANK_KEY     @"bank_key"
#define BET_KEY      @"bet_key"
#define LINES_KEY    @"lines_key"


@implementation UserDataManager

+(UserDataManager *)sharedInstance {
	static UserDataManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[UserDataManager alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if(self == [super init]){
        
    }
    
    return self;
}


-(void)setUserDefaultValue:(id)value forKey:(NSString*)key {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:value forKey:key];
    [defaults synchronize];
}

-(id)getUserDefaultValue:(NSString*)key {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	return [defaults valueForKey:key];
}


-(void)setBank:(int)bank {
	NSString* value = [NSString stringWithFormat:@"%i",bank];
	[self setUserDefaultValue:value forKey:BANK_KEY];
}

-(int)getBank {
	NSString* value = [self getUserDefaultValue:BANK_KEY];
	if (value == nil) {
		[self setBank:BANK_START];
		return BANK_START;
	}
	return [value intValue];
}


-(void)setBet:(int)bet {
	NSString* value = [NSString stringWithFormat:@"%i",bet];
	[self setUserDefaultValue:value forKey:BET_KEY];
}

-(int)getBet {
	NSString* value = [self getUserDefaultValue:BET_KEY];
	if (value == nil) {
		[self setBet:BET_START];
		return BET_START;
	}
	return [value intValue];
}


-(void)setLines:(int)lines {
	NSString* value = [NSString stringWithFormat:@"%i",lines];
	[self setUserDefaultValue:value forKey:LINES_KEY];
}

-(int)getLines {
	NSString* value = [self getUserDefaultValue:LINES_KEY];
	if (value == nil) {
		[self setLines:LINES_START];
		return LINES_START;
	}
	return [value intValue];
}

@end
