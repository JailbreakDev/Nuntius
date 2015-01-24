#import "Headers.h"
#include <notify.h>

@interface SBApplication : NSObject
-(id)bundleIdentifier;
-(void)resumeToQuit;
-(void)resumeForContentAvailable;
-(void)setBadge:(id)arg1 ;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(SBApplication *)applicationWithPid:(NSInteger)pid;
@end

%group SpringBoardHooks
%hook SBBulletinBannerController

-(void)observer:(BBObserver *)obs addBulletin:(BBBulletin *)bulletin forFeed:(unsigned long long)feed {
	NSLog(@"Bulletin: %@",bulletin);
	
	if (bulletin.sectionID && [bulletin.sectionID isEqualToString:@"net.whatsapp.WhatsApp"]) { //check for whatsapp
		//section parameters
		BBObserver *observer = bulletin.firstValidObserver;
		BBSectionParameters *parameters = [observer parametersForSectionID:bulletin.sectionID];
		BBSectionSubtypeParameters *subParameters = [parameters parametersForSubtype:bulletin.sectionSubtype];
		[subParameters setPreservesUnlockActionCase:YES];
		[parameters.defaultSubtypeParameters setPreservesUnlockActionCase:YES];
		[parameters.allSubtypeParameters setObject:subParameters forKey:@(0)];
		[observer updateSectionParameters:parameters forSectionID:bulletin.sectionID];

		//actions	
		BBAction *replyAction = [%c(BBAction) actionWithIdentifier:@"NuntiusWhatsAppQuickReplyAction"]; //create an action with an identifier
		[replyAction setRemoteViewControllerClassName:@"NTInlineWhatsAppReplyViewController"]; //set classname
		[replyAction setRemoteServiceBundleIdentifier:@"com.apple.mobilesms.notification"]; //set bundle id
		[replyAction setActionType:2];
		BBAppearance *appearance = [%c(BBAppearance) appearanceWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"REPLY" value:@"Reply" table:@"SpringBoard"]];
		[appearance setColor:(BBColor *)[%c(BBColor) colorWithRed:99.f/255.f green:235.f/255.f blue:31.f/255.f alpha:1.0]];
		[appearance setViewClassName:@"NTInlineWhatsAppReplyViewController"];
		[replyAction setAppearance:appearance];
		[replyAction setAuthenticationRequired:FALSE];
		[replyAction setShouldDismissBulletin:YES];
		BBAction *closeAction = [%c(BBAction) actionWithIdentifier:@"NuntiusWhatsAppCloseAction"];
		[closeAction setActionType:3];
		NSMutableDictionary *bbActions = bulletin.actions ? [bulletin.actions mutableCopy] : [NSMutableDictionary dictionary];
		[bbActions setObject:closeAction forKey:@"acknowledge"];
		[bbActions setObject:replyAction forKey:@"alternate"];
		[bulletin setActions:[bbActions copy]]; //save actions to bulletin

		//sub actions
		NSMutableDictionary *supplementaryActions = bulletin.supplementaryActionsByLayout;
		NSMutableArray *subActions = [supplementaryActions objectForKey:@(0)] ? [[supplementaryActions objectForKey:@(0)] mutableCopy] : [NSMutableArray array];
		[subActions addObject:replyAction];
		[supplementaryActions setObject:[subActions copy] forKey:@(0)];
		[bulletin setSupplementaryActionsByLayout:supplementaryActions];
		
		//buttons
		NSMutableArray *bbButtons = bulletin.buttons ? [bulletin.buttons mutableCopy] : [NSMutableArray array];
		BBButton *closeButton = [%c(BBButton) buttonWithTitle:@"Close" action:closeAction identifier:@"NuntiusWhatsAppCloseAction"];
		BBButton *qrButton = [%c(BBButton) buttonWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"REPLY" value:@"Reply" table:@"SpringBoard"] action:replyAction identifier:@"NuntiusWhatsAppQuickReplyAction"];
		[bbButtons addObject:closeButton];
		[bbButtons addObject:qrButton];
		[bulletin setButtons:[bbButtons copy]];

		NSDictionary *context = bulletin.context ?: [NSDictionary dictionary];
		NSString *JID = @"not_set";
		BOOL isRunning = FALSE;
		if (context[@"remoteNotification"]) {
			JID = context[@"remoteNotification"][@"aps"][@"u"];
			JID = [JID stringByAppendingString:@"@s.whatsapp.net"];
		} else if (context[@"localNotification"]) { //local notification
			isRunning = TRUE;
			NSData *localNotificationData = context[@"localNotification"];
			UILocalNotification *localNotification = [NSKeyedUnarchiver unarchiveObjectWithData:localNotificationData];
			JID = [localNotification userInfo][@"jid"];
		}
		@try {
			[bulletin setContext:@{@"body":bulletin.message ?: @"empty",
									@"recordID":bulletin.recordID ?: @"empty",
									@"bulletinID":bulletin.bulletinID ?: @"empty",
									@"publisherBulletinID":bulletin.publisherBulletinID ?: @"empty",
									@"JID":JID,
									@"isRunning":@(isRunning)
									}];
		} @catch (NSException *e) {
			NSLog(@"[NT][SBBulletinBannerController] CAUGHT EXCEPTION: %@",e);
		}
		//change presenting action to our action
		[[self _bannerContextForBulletin:bulletin] setPresentingActionIdentifier:@"NuntiusWhatsAppQuickReplyAction"];
	}
	//call original method with modified banner context
	%orig(obs,bulletin,feed);	
}

%end
%hook SBLockScreenActionContextFactory

-(id)lockScreenActionContextForBulletin:(BBBulletin *)bulletin action:(id)arg2 origin:(int)arg3 pluginActionsAllowed:(BOOL)arg4 context:(id)arg5 completion:(/*^block*/id)arg6 {
	SBMutableLockScreenActionContext *ctx = %orig;
	if ([bulletin.sectionID isEqualToString:@"net.whatsapp.WhatsApp"]) {
		[ctx setRequiresUIUnlock:NO];
	}

	return ctx;
}

%end
%end

void nt_initializeSpringBoard() {
	static int activationToken = 0;
	notify_register_dispatch("com.sharedroutine.nuntius.activate", &activationToken, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(int token) {
		uint64_t pid = -1;
		notify_get_state(token,&pid);
		SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithPid:pid];
		if (app) {
			dispatch_async(dispatch_get_main_queue(),^{
				[app setBadge:@""];
			});
			[app resumeForContentAvailable];
		}
    });
}

%ctor {
	NSString *processName = [[NSProcessInfo processInfo] processName];
	if ([processName isEqualToString:@"SpringBoard"]) {
		nt_initializeSpringBoard();
		%init(SpringBoardHooks);
	}
}