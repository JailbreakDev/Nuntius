@interface WAChatSession : NSObject
@end

@interface WAMessage : NSObject
@end

@interface WAChatStorage : NSObject
-(NSDictionary *)existingChatSessionsForJIDs:(id)arg1 prefetchingLastMessage:(BOOL)prefetch;
-(WAMessage *)messageWithText:(id)arg1 inChatSession:(id)arg2;
-(void)sendMessage:(WAMessage *)arg1 notify:(BOOL)arg2;
@end

@interface XMPPConnection : NSObject
-(BOOL)isConnected;
- (void)connect;
@end

@interface ChatManager : NSObject
+(id)sharedManager;
@property (nonatomic,copy) XMPPConnection* connection;
@property (nonatomic,copy) WAChatStorage* storage;
- (void)markChatSessionAsRead:(WAChatSession *)session;
@end

