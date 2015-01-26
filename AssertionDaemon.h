@interface BKProcessAssertion : NSObject
-(id)initWithIdentifier:(id)identifier reason:(unsigned)reason name:(id)n;
@end

@interface BKNewProcess : NSObject
-(void)addAssertion:(BKProcessAssertion *)bkAssertion;
-(void)removeAssertion:(BKProcessAssertion *)bkAssertion;
-(BOOL)hasAssertionForReason:(unsigned)reason;
@end

@interface BKWorkspaceInfoServer : NSObject
+(id)sharedInstance;
-(BKNewProcess *)processForPID:(int)pid;
@end