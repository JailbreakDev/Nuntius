#import "../NSDistributedNotificationCenter.h"
#import "../NotificationsUI.h"
#import "../ChatKit.h"
#import "../FrontBoard.h"
#include <notify.h>

int activate = 0;

@interface CKInlineReplyViewController : NCInteractiveNotificationViewController
@property (nonatomic,retain) CKMessageEntryView *entryView;
-(void)activateApplication; //new
@end

%group NotificationHooks
%subclass NTInlineWhatsAppReplyViewController : CKInlineReplyViewController

-(id)init {
	self = %orig;

	if (self) {
		notify_register_check("com.sharedroutine.nuntius.activate",&activate);
	}

	return self;
}

-(CKMessageEntryView *)entryView {
	CKMessageEntryView *entry = %orig;
	[[entry contentView] setPlaceholderText:@"WhatsApp Quick Reply"];
	return entry;
}

-(void)updateSendButton {
	[[[self entryView] sendButton] setEnabled:[[[self entryView] composition] hasContent]];
}

-(void)messageEntryViewDidBeginEditing:(id)msgView {
	%orig;
	int pid = [[%c(FBSSystemService) sharedService] pidForApplication:@"net.whatsapp.WhatsApp"];
	notify_set_state(activate,(uint64_t)pid);
	notify_post("com.sharedroutine.nuntius.activate");
}

-(void)messageEntryViewSendButtonHit:(id)btn {
	NSString *messageText = [[[[self entryView] composition] text] string];
	NSString *JID = [self context][@"JID"];
	if (JID) {
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.sharedroutine.nuntius.whatsapp.notification" object:nil userInfo:@{@"kMessage":messageText,@"kJID":JID}];
	}
	[self dismissWithContext:nil];
}

%end
%end

%ctor {
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if ([bundleID isEqualToString:@"com.apple.mobilesms.notification"]) {
		%init(NotificationHooks);
	}
}