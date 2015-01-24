#import "Headers.h"

@protocol NCInteractiveNotificationHostDelegate <NSObject>
@optional
-(void)hostViewControllerDidChangePreferredContentSize:(id)arg1;
-(void)hostViewController:(id)arg1 didRequestDismissalWithContext:(SBUIBannerContext *)ctx;
@end

@interface NCInteractiveNotificationViewController : UIViewController
@property (nonatomic,copy) NSDictionary * context;
-(void)handleActionAtIndex:(unsigned long long)arg1 ;
-(void)dismissWithContext:(id)arg1 ;
-(void)setActionEnabled:(BOOL)arg1 atIndex:(unsigned long long)arg2 ;
-(void)handleActionIdentifier:(id)arg1 ;
-(void)requestPreferredContentHeight:(double)arg1;
@end

@interface NCViewServiceDescriptor : NSObject
@property (nonatomic,copy,readonly) NSString * viewControllerClassName;
@property (nonatomic,copy,readonly) NSString * bundleIdentifier;
+(id)descriptorWithViewControllerClassName:(id)arg1 bundleIdentifier:(id)arg2 ;
@end

@interface NCContentViewController : UIViewController
@property (nonatomic,copy) NSDictionary * context;
@end