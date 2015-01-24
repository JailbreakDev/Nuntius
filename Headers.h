@class BBBulletin;
@interface SBLockScreenActionContext : NSObject
@property (nonatomic,retain) NSString * identifier;                      //@synthesize identifier=_identifier - In the implementation block
@property (nonatomic,retain) NSString * lockLabel;                       //@synthesize lockLabel=_lockLabel - In the implementation block
@property (nonatomic,retain) NSString * shortLockLabel;                  //@synthesize shortLockLabel=_shortLockLabel - In the implementation block
@property (nonatomic,copy) id action;                                    //@synthesize action=_action - In the implementation block
@property (assign,nonatomic) BOOL requiresUIUnlock;                      //@synthesize requiresUIUnlock=_requiresUIUnlock - In the implementation block
@property (assign,nonatomic) BOOL deactivateAwayController;              //@synthesize deactivateAwayController=_deactivateAwayController - In the implementation block
@property (assign,nonatomic) BOOL canBypassPinLock;                      //@synthesize canBypassPinLock=_canBypassPinLock - In the implementation block
@property (nonatomic,readonly) BOOL hasCustomUnlockLabel; 
@property (assign,nonatomic) BOOL requiresAuthentication;                //@synthesize requiresAuthentication=_requiresAuthentication - In the implementation block
@property (assign,nonatomic) BBBulletin * bulletin;                      //@synthesize bulletin=_bulletin - In the implementation block
-(id)initWithLockLabel:(id)arg1 shortLockLabel:(id)arg2 action:(/*^block*/id)arg3 identifier:(id)arg4 ;
@end

@interface SBLockScreenNotificationListController : UIViewController
-(void)handleLockScreenActionWithContext:(id)arg1 ;
@end

@interface SBLockScreenNotificationListView : UIView
@property (assign,nonatomic)  SBLockScreenNotificationListController *delegate;
@end

@interface SBMutableLockScreenActionContext : NSObject

@property (nonatomic,retain) NSString * identifier; 
@property (nonatomic,retain) NSString * lockLabel; 
@property (nonatomic,retain) NSString * shortLockLabel; 
@property (nonatomic,copy) id action; 
@property (assign,nonatomic) BOOL requiresUIUnlock; 
@property (assign,nonatomic) BOOL deactivateAwayController; 
@property (assign,nonatomic) BOOL canBypassPinLock; 
@property (assign,nonatomic) BOOL requiresAuthentication; 
@property (assign,nonatomic) BBBulletin * bulletin; 
@end

@class BBAppearance;
@interface BBAction : NSObject
+(BBAction *)actionWithIdentifier:(id)arg1 ;
+(id)actionWithCallblock:(/*^block*/id)arg1 ;
@property (assign,nonatomic) BOOL shouldDismissBulletin;
@property (assign,nonatomic) long long actionType;
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,copy) NSString * remoteViewControllerClassName;
@property (nonatomic,copy) NSString * remoteServiceBundleIdentifier;
@property (nonatomic,copy) BBAppearance * appearance; 
@property (assign,nonatomic) BOOL canBypassPinLock;
@property (assign,getter=isAuthenticationRequired,nonatomic) BOOL authenticationRequired;
@end

@class BBObserver;
@interface BBBulletin : NSObject
@property (nonatomic,retain) NSDictionary * context; //fill with any info
@property (nonatomic,copy) NSString * recordID; 
@property (nonatomic,copy) NSString * publisherBulletinID;
@property (assign,nonatomic) long long addressBookRecordID;
@property (nonatomic,copy) NSString * bulletinID;
@property (nonatomic,copy) NSString * sectionID;
@property (nonatomic,copy) NSMutableDictionary * actions;
@property (nonatomic,retain) NSMutableDictionary * supplementaryActionsByLayout;
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSString * subtitle; 
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSArray * buttons;
@property (assign,nonatomic) long long sectionSubtype;
@property (nonatomic,readonly) NSString * fullUnlockActionLabel; 
@property (nonatomic,readonly) NSString * unlockActionLabel;
-(BBObserver *)firstValidObserver;
@property (nonatomic,copy) BBAction * alternateAction; 
@end

@interface BBButton : NSObject
+(id)buttonWithTitle:(id)arg1 action:(id)arg2 identifier:(id)arg3 ;
@end

@interface BBColor : NSObject
+(id)colorWithRed:(CGFloat)arg1 green:(CGFloat)arg2 blue:(CGFloat)arg3 alpha:(CGFloat)arg4 ;
@end

@interface BBAppearance : NSObject
+(id)appearanceWithTitle:(id)arg1;
@property (nonatomic,copy) BBColor * titleColor;
@property (nonatomic,copy) BBColor * color; 
@property (nonatomic,copy) NSString * viewClassName;
@end

@interface BBSectionSubtypeParameters : NSObject
@property (assign,nonatomic) BOOL preservesUnlockActionCase;
@end

@interface BBSectionParameters : NSObject
@property (nonatomic,retain) BBSectionSubtypeParameters * defaultSubtypeParameters;
@property (nonatomic,retain) NSMutableDictionary * allSubtypeParameters;
-(BBSectionSubtypeParameters *)parametersForSubtype:(long long)arg1 ;
@end

@interface BBObserver : NSObject
-(BBSectionParameters *)parametersForSectionID:(id)arg1 ;
-(void)updateSectionParameters:(id)arg1 forSectionID:(id)arg2 ;
@end

@interface SBUIBannerItem : NSObject
-(BBBulletin *)pullDownNotification;
@end

@interface SBUIBannerContext : NSObject
@property (nonatomic,retain,readonly) SBUIBannerItem * item;
@property (nonatomic,retain,readonly) id source;
@property (nonatomic,retain,readonly) id target;
@property (assign,nonatomic) BOOL requestsModalPresentation;
@property (nonatomic,copy) NSString * presentingActionIdentifier;
-(id)initWithItem:(SBUIBannerItem *)arg1 source:(id)arg2 target:(id)arg3 presentingActionIdentifier:(id)arg4 requestModalPresentation:(BOOL)arg5 ;
-(void)setPresentingActionIdentifier:(NSString *)arg1 ;
@end

@interface SBBannerContainerViewController : UIViewController
-(void)setBannerContext:(id)arg1 withReplaceReason:(int)arg2 completion:(/*^block*/id)arg3 ;
@end

@interface SBBulletinBannerController : NSObject
-(SBUIBannerContext *)_bannerContextForBulletin:(BBBulletin *)bulletin;
@end

@interface SBBannerController : NSObject
@end

@interface SBNotificationRowActionFactory : NSObject
-(id)_rowActionWithBBAction:(id)arg1 button:(id)arg2 handler:(/*^block*/id)arg3 ;
@end

@interface _UITableViewCellActionButton : UIButton
+(id)actionButtonWithStyle:(unsigned long long)arg1 ;
@end