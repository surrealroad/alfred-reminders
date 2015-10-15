//
//  codecs.h
//  aem
//

#import "unittype.h"
#import "specifier.h"
#import "types.h"
#import "utils.h"


/**********************************************************************/
// AE types not defined in older OS versions

enum {
	AS_typeUTF16ExternalRepresentation = 'ut16',
	AS_typeUInt16 = 'ushr',
	AS_typeUInt64 = 'ucom'
};


/**********************************************************************/


@interface AEMCodecs : NSObject <NSCopying, AEMCodecsProtocol> {
	id applicationRootDescriptor;
	BOOL disableCache, disableUnicode, allowUInt64;
	DescType textType;
	NSMutableDictionary *unitTypeDefinitionByName, *unitTypeDefinitionByCode;
}

+ (id)defaultCodecs;


/**********************************************************************/
// compatibility options

/*
 * Some applications may define custom unit types in addition to those
 * normally recognised by AppleScript/appscript. Clients can add
 * definitions for these types to an AEMCodecs object so that these
 * types can be packed and unpacked automatically.
 */
- (void)addUnitTypeDefinition:(AEMUnitTypeDefinition *)definition;

/*
 * When unpacking object specifiers, unlike AppleScript, appscript caches
 * the original AEDesc for efficiency, allowing the resulting AEMQuery to
 * be re-packed much more quickly. Occasionally this causes compatibility
 * problems with applications that returned subtly malformed specifiers.
 * To force an AEMCodecs object to fully unpack and repack object specifiers,
 * call its -dontCacheUnpackedSpecifiers method.
 */
- (void)dontCacheUnpackedSpecifiers;

/*
 * Some older (pre-OS X) applications may require text to be passed as 
 * typeChar or typeIntlText rather than the usual typeUnicodeText. To force
 * an AEMCodecs object to pack strings as one of these older types, call 
 * its -packStringsAsType: method, specifying the type you want used instead.
 */
- (void)packStringsAsType:(DescType)type;

/*
 * For compatibility's sake, appscript packs integers between 2^62 and 2^63-1 as
 * doubles, with some potential loss of precision. Mac OS X 10.5 adds typeUInt64; 
 * to use this, call -allowUInt64.
 */
- (void)allowUInt64;


/**********************************************************************/
// main pack methods

/*
 * Converts a Cocoa object to an NSAppleEventDescriptor.
 * Calls -packUnknown: if object is of an unsupported class.
 */
- (NSAppleEventDescriptor *)pack:(id)anObject;

/*
 * Called by -pack: to process a Cocoa object of unsupported class.
 * Default implementation raises "CodecsError" NSException; subclasses
 * can override this method to provide alternative behaviours if desired.
 */
- (NSAppleEventDescriptor *)packUnknown:(id)anObject;


/**********************************************************************/
/*
 * The following methods will be called by -pack: as needed.
 * Subclasses can override the following methods to provide alternative 
 * behaviours if desired, although this is generally unnecessary.
 */
- (NSAppleEventDescriptor *)packArray:(NSArray *)anObject;
- (NSAppleEventDescriptor *)packDictionary:(NSDictionary *)anObject;

- (void)setApplicationRootDescriptor:(NSAppleEventDescriptor *)desc;
- (NSAppleEventDescriptor *)applicationRootDescriptor;


/**********************************************************************/
// main unpack methods; subclasses can override to process still-unconverted objects

/*
 * Converts an NSAppleEventDescriptor to a Cocoa object.
 * Calls -unpackUnknown: if descriptor is of an unsupported type.
 */
- (id)unpack:(NSAppleEventDescriptor *)desc;

/*
 * Called by -unpack: to process an NSAppleEventDescriptor of unsupported type.
 * Default implementation checks to see if the descriptor is a record-type structure
 * and unpacks it as an NSDictionary if it is, otherwise it returns the value as-is.
 * Subclasses can override this method to provide alternative behaviours if desired.
 */
- (id)unpackUnknown:(NSAppleEventDescriptor *)desc;


/**********************************************************************/
/*
 * The following methods will be called by -unpack: as needed.
 * Subclasses can override the following methods to provide alternative 
 * behaviours if desired, although this is generally unnecessary.
 */
- (id)unpackAEList:(NSAppleEventDescriptor *)desc;
- (id)unpackAERecord:(NSAppleEventDescriptor *)desc;
- (id)unpackAERecordKey:(AEKeyword)key;

- (id)unpackType:(NSAppleEventDescriptor *)desc;
- (id)unpackEnum:(NSAppleEventDescriptor *)desc;
- (id)unpackProperty:(NSAppleEventDescriptor *)desc;
- (id)unpackKeyword:(NSAppleEventDescriptor *)desc;

- (id)fullyUnpackObjectSpecifier:(NSAppleEventDescriptor *)desc;
- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc;
- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc;

- (id)app;
- (id)con;
- (id)its;
- (id)customRoot:(NSAppleEventDescriptor *)desc;

- (id)unpackCompDescriptor:(NSAppleEventDescriptor *)desc;
- (id)unpackLogicalDescriptor:(NSAppleEventDescriptor *)desc;

/*
 * Notes:
 *
 * kAEContains is also used to construct 'is in' tests, where test value is first operand and
 * reference being tested is second operand, so need to make sure first operand is an its-based ref;
 * if not, rearrange accordingly.
 *
 * Since type-checking is involved, this extra hook is provided so that appscript's ASAppData class
 * can override this method to add its own type checking.
 */
- (id)unpackContainsCompDescriptorWithOperand1:(id)op1 operand2:(id)op2;


/**********************************************************************/
/*
 * The following methods are not called by -unpack:, but are provided for benefit of
 * subclasses that may wish to use them.
 */

- (NSString *)unpackApplicationBundleID:(NSAppleEventDescriptor *)desc;

- (NSURL *)unpackApplicationURL:(NSAppleEventDescriptor *)desc;

- (OSType)unpackApplicationSignature:(NSAppleEventDescriptor *)desc;

- (pid_t)unpackProcessID:(NSAppleEventDescriptor *)desc;

- (pid_t)unpackProcessSerialNumber:(NSAppleEventDescriptor *)desc;

@end
