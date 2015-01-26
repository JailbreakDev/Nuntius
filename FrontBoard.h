@interface FBSSystemService : NSObject
+(id)sharedService;
-(void)cleanupClientPort:(unsigned)arg1 ;
-(unsigned)createClientPort;
-(void)openApplication:(id)arg1 options:(id)arg2 clientPort:(unsigned)arg3 withResult:(/*^block*/id)arg4 ;
-(int)pidForApplication:(id)arg1 ;
-(void)setBadgeValue:(id)arg1 forBundleID:(id)arg2 ;
@end

@interface FBProcessManager : NSObject
+(id)sharedInstance;
-(id)createApplicationProcessForBundleID:(id)arg1 ;
@end