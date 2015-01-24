#import "../NSDistributedNotificationCenter.h"
#import "../NotificationsUI.h"
#import "../ChatKit.h"
#import "../FrontBoard.h"
#include <notify.h>

@interface UIApplication(ActivateSuspended)
-(BOOL)launchApplicationWithIdentifier:(id)identifier suspended:(BOOL)s;
@end

int activate = 0;

@interface CKInlineReplyViewController : NCInteractiveNotificationViewController
@property (nonatomic,retain) CKMessageEntryView *entryView;
-(void)activateApplication; //new
@end

%group NotificationHooks
%subclass NTInlineWhatsAppReplyViewController : CKInlineReplyViewController

-(CKMessageEntryView *)entryView {
	CKMessageEntryView *entry = %orig;
	[[entry contentView] setPlaceholderText:@"WhatsApp Quick Reply"];
	return entry;
}

-(void)updateSendButton {
	[[[self entryView] sendButton] setEnabled:[[[self entryView] composition] hasContent]];
}

-(void)interactiveNotificationDidAppear {
	%orig;
	[self activateApplication];
}

-(void)messageEntryViewSendButtonHit:(id)btn {
	NSString *messageText = [[[[self entryView] composition] text] string];
	NSString *JID = [self context][@"JID"];
	if (JID) {
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.sharedroutine.nuntius.whatsapp.notification" object:nil userInfo:@{@"kMessage":messageText,@"kJID":JID}];
	}
	[self dismissWithContext:nil];
}

%new

-(void)activateApplication {
	notify_register_check("com.sharedroutine.nuntius.activate",&activate);
	int pid = [[%c(FBSSystemService) sharedService] pidForApplication:@"net.whatsapp.WhatsApp"];
	BOOL running = (pid != 0);
	if (!running) {
		[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:YES];

		static int launchToken = 0;
		notify_register_dispatch("net.whatsapp.WhatsApp-launched", &launchToken, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(int token) {
			int pid = [[%c(FBSSystemService) sharedService] pidForApplication:@"net.whatsapp.WhatsApp"];
			notify_set_state(activate,(uint64_t)pid);
			notify_post("com.sharedroutine.nuntius.activate");
	    });

	} else {
		int pid = [[%c(FBSSystemService) sharedService] pidForApplication:@"net.whatsapp.WhatsApp"];
		notify_set_state(activate,(uint64_t)pid);
		notify_post("com.sharedroutine.nuntius.activate");
	}
}

%end
%end

%ctor {
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if ([bundleID isEqualToString:@"com.apple.mobilesms.notification"]) {
		%init(NotificationHooks);
	}
}