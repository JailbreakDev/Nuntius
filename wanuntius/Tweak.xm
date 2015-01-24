#import "../NSDistributedNotificationCenter.h"
#import "WhatsApp.h"
#include <notify.h>

@interface NTWhatsAppListener : NSObject
+(void)startListening;
@end

@implementation NTWhatsAppListener

+(id)sharedInstance {
	static dispatch_once_t p = 0;
	static __strong NTWhatsAppListener *_sharedListener;
	dispatch_once(&p,^{
		_sharedListener = [[self alloc] init];
	});
	return _sharedListener;
}

-(void)notificationReceived:(NSNotification *)notification {
	NSString *JID = notification.userInfo[@"kJID"];
	NSString *message = notification.userInfo[@"kMessage"];
	if (!JID || !message) {
		NSLog(@"Can't live without a JID or without a Message");
		return;
	}

	ChatManager *chatManager = [%c(ChatManager) sharedManager];
	XMPPConnection *connection = chatManager.connection;
	if (![connection isConnected]) {
		[connection connect];
	}
	if (chatManager) {
		WAChatStorage *storage = chatManager.storage;
		if (storage) {
			NSDictionary *sessions = [storage existingChatSessionsForJIDs:@[JID] prefetchingLastMessage:YES];
			WAChatSession *chat = [sessions objectForKey:JID];
			if (chat) {
				WAMessage *waMessage = [storage messageWithText:message inChatSession:chat];
				if (waMessage) {
					[storage sendMessage:waMessage notify:YES];
					[chatManager markChatSessionAsRead:chat];
				}
			}
		}
	}
}

+(void)startListening {
	NTWhatsAppListener *listener = [self sharedInstance];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:listener selector:@selector(notificationReceived:) name:@"com.sharedroutine.nuntius.whatsapp.notification" object:nil];
}

@end

%hook UIApplication

- (void)wa_showLocalNotificationForJailbrokenPhoneAndTerminate {
}

%end

%ctor {
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if ([bundleID isEqualToString:@"net.whatsapp.WhatsApp"]) {
		%init;
		[NTWhatsAppListener startListening];
	}
}