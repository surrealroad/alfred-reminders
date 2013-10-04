//
//  event.h
//  aem
//

#import "codecs.h"
#import "sendthreadsafe.h"
#import "utils.h"
#import "objectrenderer.h"


/**********************************************************************/
// NSError constants

extern NSString *const kASErrorDomain; // @"net.sourceforge.appscript.objc-appscript.ErrorDomain"; domain name for NSErrors returned by appscript

/*
 * -sendWithError: will return an NSError containing error code, localized description, and a userInfo dictionary
 * containing kASErrorNumberKey (this has the same value as -[NSError code]) and zero or more other keys:
 */

extern NSString *const kASErrorNumberKey;			// @"ErrorNumber"; error number returned by Apple Event Manager or application
extern NSString *const kASErrorStringKey;			// @"ErrorString"; error string returned by application, if given
extern NSString *const kASErrorBriefMessageKey;		// @"ErrorBriefMessage"; brief error string returned by application, if given
extern NSString *const kASErrorExpectedTypeKey;		// @"ErrorExpectedType"; AE type responsible for a coercion error (-1700), if given
extern NSString *const kASErrorOffendingObjectKey;	// @"ErrorOffendingObject"; value or object specifer responsible for error, if given
extern NSString *const kASErrorFailedEvent;			// @"ErrorFailedEvent"; the AEMEvent object that returned the error


/**********************************************************************/
// typedefs

typedef enum {
	kAEMDontUnpack,
	kAEMUnpackAsItem,
	kAEMUnpackAsList
} AEMUnpackFormat;


typedef OSErr(*AEMCreateProcPtr)(AEEventClass theAEEventClass,
							     AEEventID theAEEventID,
							     const AEAddressDesc *target,
							     AEReturnID returnID,
							     AETransactionID transactionID,
							     AppleEvent *result);


typedef OSStatus(*AEMSendProcPtr)(const AppleEvent *event,
								  AppleEvent *reply,
								  AESendMode sendMode,
								  long timeOutInTicks);


/**********************************************************************/
// Event class
/*
 * Note: clients shouldn't instantiate AEMEvent directly; instead use AEMApplication -eventWith... methods.
 */

@interface AEMEvent : NSObject {
	AppleEvent *event;
	id codecs;
	AEMSendProcPtr sendProc;
	// type to coerce returned value to before unpacking it
	DescType resultType;
	AEMUnpackFormat resultFormat;
}

/*
 * Note: new AEMEvent instances are constructed by AEMApplication objects; 
 * clients shouldn't instantiate this class directly.
 */

- (id)initWithEvent:(AppleEvent *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_;

/*
 * Get codecs object used by this AEMEvent instance
 */
 - (id)codecs;

/*
 * Get a pointer to the AEDesc contained by this AEMEvent instance
 */
- (const AppleEvent *)aeDesc;

/*
 * Get an NSAppleEventDescriptor instance containing a copy of this event
 */
- (NSAppleEventDescriptor *)descriptor;

// Pack event's attributes and parameters, if any.

- (void)setAttribute:(id)value forKeyword:(AEKeyword)key;

- (void)setParameter:(id)value forKeyword:(AEKeyword)key;

// Get event's attributes and parameters.

- (id)attributeForKeyword:(AEKeyword)key type:(DescType)type error:(out NSError **)error;

- (id)attributeForKeyword:(AEKeyword)key; // shortcut for above

- (id)parameterForKeyword:(AEKeyword)key type:(DescType)type error:(out NSError **)error;

- (id)parameterForKeyword:(AEKeyword)key; // shortcut for above

/*
 * Specify how the the reply descriptor should be unpacked.
 * (Default = kAEMUnpackAsItem of typeWildCard)
 */

- (void)setUnpackFormat:(AEMUnpackFormat)format_ type:(DescType)type_;

- (void)getUnpackFormat:(AEMUnpackFormat *)format_ type:(DescType *)type_;

/*
 * Send event.
 
 * Parameters
 *
 * sendMode
 *    kAEWaitReply
 *
 * timeoutInTicks
 *    kAEDefaultTimeout
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
 *
 */

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks error:(out NSError **)error;

// shortcuts for -sendWithMode:timeout:error:

- (id)sendWithError:(out NSError **)error;

- (id)send;

@end

