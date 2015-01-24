typedef NS_ENUM(NSUInteger, NSNotificationSuspensionBehavior) {
    NSNotificationSuspensionBehaviorDrop = 1,
    // The server will not queue any notifications with this name and object until setSuspended:NO is called.
    NSNotificationSuspensionBehaviorCoalesce = 2,
    // The server will only queue the last notification of the specified name and object; earlier notifications are dropped.  In cover methods for which suspension behavior is not an explicit argument, NSNotificationSuspensionBehaviorCoalesce is the default.
    NSNotificationSuspensionBehaviorHold = 3,
    // The server will hold all matching notifications until the queue has been filled (queue size determined by the server) at which point the server may flush queued notifications.
    NSNotificationSuspensionBehaviorDeliverImmediately = 4
    // The server will deliver notifications matching this registration irrespective of whether setSuspended:YES has been called.  When a notification with this suspension behavior is matched, it has the effect of first flushing
    // any queued notifications.  The effect is somewhat as if setSuspended:NO were first called if the app is suspended, followed by
    // the notification in question being delivered, followed by a transition back to the previous suspended or unsuspended state.
};

@interface NSDistributedNotificationCenter : NSNotificationCenter
@property (assign) BOOL suspended; 
+(id)notificationCenterForType:(id)arg1 ;
+(id)defaultCenter;
-(void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4 suspensionBehavior:(NSNotificationSuspensionBehavior)arg5 ;
-(id)addObserverForName:(id)arg1 object:(id)arg2 suspensionBehavior:(unsigned long long)arg3 queue:(id)arg4 usingBlock:(/*^block*/id)arg5 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 options:(unsigned long long)arg4 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 deliverImmediately:(BOOL)arg4 ;
-(BOOL)suspended;
-(void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4 ;
-(id)init;
-(void)removeObserver:(id)arg1 name:(id)arg2 object:(id)arg3 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 ;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 ;
-(id)addObserverForName:(id)arg1 object:(id)arg2 queue:(id)arg3 usingBlock:(/*^block*/id)arg4 ;
-(void)postNotification:(id)arg1 ;
-(void)setSuspended:(BOOL)arg1 ;
@end
