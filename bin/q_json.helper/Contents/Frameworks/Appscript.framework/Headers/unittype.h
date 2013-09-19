//
//  unittype.h
//  aem
//

#import "types.h"
#import "utils.h"


/**********************************************************************/
// Unit type definition

@interface AEMUnitTypeDefinition : NSObject {
	NSString *name;
	DescType code;
}

+ (id)definitionWithName:(NSString *)name_ code:(DescType)code_;

- (id)initWithName:(NSString *)name_ code:(DescType)code_;

- (NSString *)name;

- (DescType)code;

/*
 * The default implementation packs and unpacks the descriptor's data
 * handle as a double. Override these methods to support other formats.
 */
- (NSAppleEventDescriptor *)pack:(ASUnits *)obj;

- (ASUnits *)unpack:(NSAppleEventDescriptor *)desc;

@end

/**********************************************************************/
// called by -[AEMCodecs init]

void AEMGetDefaultUnitTypeDefinitions(NSDictionary **definitionsByName,
									  NSDictionary **definitionsByCode);