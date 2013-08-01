//  BWUtilities.h
//  Copyright 2010-2012 The BearHeart Group, LLC. All rights reserved.
//

static NSString * const kBWUtilitiesVersion = @"1.1.2";
static NSString * const kAlertTitle = @"BW RSS";
static BOOL const kMessageActive = YES;

// populated from loadDidView
UITextView * messageTextView;

void message ( NSString *format, ... );
void alertMessage ( NSString *format, ... );
NSString * flattenHTML ( NSString * html );
NSString * trimString ( NSString * string );
