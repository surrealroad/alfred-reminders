//
//  command.h
//  Appscript
//

#import "event.h"
#import "constant.h"
#import "appdata.h"
#import "utils.h"


// used internally
#define kASNoDirectParameter ((void *)-1)


/**********************************************************************/
// Command base

@interface ASCommand : NSObject {
	AEMEvent *AS_event;
	AESendMode sendMode;
	long timeout;
	UInt32 considsAndIgnoresFlags;
	NSError *targetError;
}

+ (id)commandWithAppData:(id)appData
			  eventClass:(AEEventClass)classCode
				 eventID:(AEEventID)code
		 directParameter:(id)directParameter
		 parentReference:(id)parentReference;

- (id)initWithAppData:(id)appData
		   eventClass:(AEEventClass)classCode
			  eventID:(AEEventID)code
	  directParameter:(id)directParameter
	  parentReference:(id)parentReference;

// get underlying AEMEvent instance

- (AEMEvent *)AS_aemEvent;

// set attributes

/*
 * Set considering/ignoring attributes.
 *
 * kAECaseConsiderMask = 0x00000001
 * kAEDiacriticConsiderMask = 0x00000002
 * kAEWhiteSpaceConsiderMask = 0x00000004
 * kAEHyphensConsiderMask = 0x00000008
 * kAEExpansionConsiderMask = 0x00000010
 * kAEPunctuationConsiderMask = 0x00000020
 * kASNumericStringsConsiderMask = 0x00000080
 * 
 * kAECaseIgnoreMask = 0x00010000
 * kAEDiacriticIgnoreMask = 0x00020000
 * kAEWhiteSpaceIgnoreMask = 0x00040000
 * kAEHyphensIgnoreMask = 0x00080000
 * kAEExpansionIgnoreMask = 0x00100000
 * kAEPunctuationIgnoreMask = 0x00200000
 * kASNumericStringsIgnoreMask = 0x00800000
 */
- (id)considering:(UInt32)consideringFlags_;

/* Set send mode flags.
 *	kAENoReply = 0x00000001,
 *	kAEQueueReply = 0x00000002,
 *	kAEWaitReply = 0x00000003,
 *	kAEDontReconnect = 0x00000080,
 *	kAEWantReceipt = 0x00000200,
 *	kAENeverInteract = 0x00000010,
 *	kAECanInteract = 0x00000020,
 *	kAEAlwaysInteract = 0x00000030,
 *	kAECanSwitchLayer = 0x00000040,
 *	kAEDontRecord = 0x00001000,
 *	kAEDontExecute = 0x00002000,
 *	kAEProcessNonReplyEvents = 0x00008000
 *
 * Default is kAEWaitReply | kAECanSwitchLayer
 */
- (id)sendMode:(AESendMode)flags;

/*
 * Shortcut for setting kAEWaitReply send mode flag:
 */
- (id)waitForReply;

/*
 * Shortcut for setting kAENoReply send mode flag:
 */
- (id)ignoreReply;

/*
 * Shortcut for setting kAEQueueReply send mode flag:
 */
- (id)queueReply;

/*
 * Specify timeout in seconds (or kAEDefaultTimeout/kAENoTimeOut).
 *
 * Default is kAEDefaultTimeout (2 minutes)
 */
- (id)timeout:(long)timeout_;

/*
 * Specify the desired type for the return value. Where the application's event
 * handler supports this, it will attempt to coerce the event's result to this
 * type before returning it. May be a standard AE type (e.g. [ASConstant alias])
 * or, occasionally, an application-defined type.
 *
 * Note that most applications don't support this, and those that do usually
 * only support it for 'get' events (e.g. Finder).
 */
- (id)requestedClass:(ASConstant *)classConstant;
- (id)requestedType:(DescType)type;

/*
 * Specify the AE type that the returned AEDesc must be coerced to before unpacking.
 * Whereas the -requestedType: method adds a kAERequestedType parameter to the outgoing
 * event, this coercion is performed locally by the -sendWithError: method using a
 * built-in or user-installed AE coercion handler if one is available. Note that if
 * the coercion fails, -sendWithError: will return nil and the associated NSError's
 * error code will be -1700 (errAECoercionFail).
 *
 * If the specified type is typeWildCard (the default), no coercion is performed.
 */
- (id)returnClass:(ASConstant *)classConstant;
- (id)returnType:(DescType)type;

/*
 * Shortcut for [cmd returnType: typeAEList].
 */
- (id)returnList;

/*
 * Similar to -returnType:, except that the returned AEDesc is first coerced to
 * to typeAEList; each list item is then coerced to the specified type.
 */
- (id)returnListOfClass:(ASConstant *)classConstant;
- (id)returnListOfType:(DescType)type;

/*
 * Invoke -returnDescriptor to have -sendWithError: return the returned AEDesc as
 * an NSAppleEventDescriptor without unpacking it.
 *
 */
- (id)returnDescriptor;

// send events


/*
 * Send the event.
 *
 * error
 *    On return, an NSError object that describes an Apple Event Manager or application
 *    error if one has occurred, otherwise nil. Pass nil if not required.
 *
 * Return value
 *
 *    The value returned by the application, or an NSNull instance if no value was returned,
 *    or nil if an error occurred.
 *
 * Notes
 *
 *    A single event can be sent more than once if desired.
 */
- (id)sendWithError:(out NSError **)error;

/*
 * Send the event with minimal error reporting.
 *
 * Return value
 *
 *    The value returned by the application, or an NSNull instance if no value was returned,
 *    or nil if an error occurred.
 *
 * Notes
 *
 *    Convenience method; [evt send] is equivalent to [evt sendWithError: nil]
 */
- (id)send;


// display formatting; subclasses will override these

- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;

@end


/**********************************************************************/


@interface ASGetSetItemCommand : ASCommand
@end

