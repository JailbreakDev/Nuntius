@interface CKMessageEntryContentView : UIView
@property (nonatomic,copy) NSString * placeholderText; 
@end

@interface CKComposition : NSObject
@property (nonatomic,copy) NSAttributedString * text;
@property (nonatomic,readonly) BOOL hasContent;
@end

@interface CKMessageEntryView : UIView
@property (assign,nonatomic) BOOL shouldShowPhotoButton;
@property (nonatomic,retain) CKComposition * composition;
@property (nonatomic,retain) UIButton * sendButton; 
@property (nonatomic,retain) CKMessageEntryContentView * contentView;
@end