//
//  utils.h
//  Appscript
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

/**********************************************************************/
// Clang macros

#ifndef NSINTEGER_DEFINED

#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif


#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX

#define NSINTEGER_DEFINED 1

#endif



#ifndef __has_feature
#define __has_feature(x) 0
#endif

#ifndef NS_RETURNS_RETAINED

#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif

#endif


/**********************************************************************/

#define AEMIsDescriptorEqualToObject(desc, obj) ( \
		[obj isKindOfClass: [NSAppleEventDescriptor class]] \
		&& ([desc descriptorType] == [obj descriptorType]) \
		&& [[desc data] isEqualToData: [obj data]])


/**********************************************************************/
// supported by all self-packing objects

@protocol AEMSelfPackingProtocol

- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs;

@end


/**********************************************************************/

@protocol AEMCodecsProtocol

- (NSAppleEventDescriptor *)pack:(id)obj;

- (NSAppleEventDescriptor *)applicationRootDescriptor;

- (id)unpack:(NSAppleEventDescriptor *)desc;

- (id)fullyUnpackObjectSpecifier:(NSAppleEventDescriptor *)desc;

@end


/**********************************************************************/

typedef enum {
	kASRelaunchNever,
	kASRelaunchSpecial,
	kASRelaunchAlways
} ASRelaunchMode;


/**********************************************************************/

NSString *ASDescriptionForError(OSStatus err);