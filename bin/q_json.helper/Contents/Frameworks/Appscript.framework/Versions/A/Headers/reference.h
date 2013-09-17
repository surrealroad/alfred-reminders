//
//  reference.h
//  appscript
//

#import "application.h"
#import "constant.h"
#import "specifier.h"
#import "command.h"
#import "utils.h"

/**********************************************************************/

#define ASInt(val) [NSNumber numberWithInt: (int)val]
#define ASLong(val) [NSNumber numberWithLong: (long)val]
#define ASDouble(val) [NSNumber numberWithDouble: (double)val]

/**********************************************************************/
// Reference base


@interface ASReference : NSObject {
	id AS_appData;
	id AS_aemReference;
}

+ (id)referenceWithAppData:(id)appData aemReference:(id)aemReference;

- (id)initWithAppData:(id)appData aemReference:(id)aemReference;

- (NSAppleEventDescriptor *)AS_packSelf:(id)codecs;

- (id)AS_appData;

- (id)AS_aemReference;

- (void)AS_setRelaunchMode:(ASRelaunchMode)relaunchMode_;
- (ASRelaunchMode)AS_relaunchMode;

// is target application running?
- (BOOL)isRunning;

// launch the target application without sending it the usual 'run' event;
// equivalent to 'launch' command in AppleScript.
- (BOOL)launchApplicationWithError:(out NSError **)error; // may be nil

- (BOOL)launchApplication; // convenience shortcut for the above


// restart local application and/or update AEAddressDesc if needed
// (typically used after application has quit; refreshes existing
// application object without the need to recreate it)
// note: only works for apps specified by name/path/bundle ID

- (BOOL)reconnectApplicationWithError:(out NSError **)error;

- (BOOL)reconnectApplication;


// transaction support

- (BOOL)beginTransactionWithError:(out NSError **)error;

- (BOOL)beginTransactionWithSession:(id)session error:(out NSError **)error;

- (BOOL)endTransactionWithError:(out NSError **)error;

- (BOOL)abortTransactionWithError:(out NSError **)error;

// get/set shortcuts

// shortcut for [[[ref set] to: value] send]
- (id)setItem:(id)data;
- (id)setItem:(id)data error:(out NSError **)error;

// shortcut for [[ref get] send]
- (id)getItem; 
- (id)getItemWithError:(out NSError **)error;

// shortcut for [[[ref get] returnList] send]
- (id)getList;
- (id)getListWithError:(out NSError **)error;

// shortcut for [[[[ref get] requestedType: descType] returnType: descType] send]
- (id)getItemOfType:(DescType)type;
- (id)getItemOfType:(DescType)type error:(out NSError **)error;

// shortcut for [[[[ref get] requestedType: descType] returnListOfType: descType] send]
- (id)getListOfType:(DescType)type;
- (id)getListOfType:(DescType)type error:(out NSError **)error;

/*
 * shortcuts for getting numerical property values as C primitives
 */

// shortcut for [[[[[ref get] requestedType: typeSInt32] returnType: typeSInt32] send] intValue]
- (int)getIntWithError:(out NSError **)error;

// shortcut for [[[[[ref get] requestedType: typeSInt32] returnType: typeSInt32] send] intValue] in 32-bit builds,
//          and [[[[[ref get] requestedType: typeSInt64] returnType: typeSInt64] send] longValue] in 64-bit builds
- (long)getLongWithError:(out NSError **)error;

// shortcut for [[[[[ref get] requestedType: typeIEEE64BitFloatingPoint] returnType: typeIEEE64BitFloatingPoint] send] doubleValue]
- (double)getDoubleWithError:(out NSError **)error;

@end


