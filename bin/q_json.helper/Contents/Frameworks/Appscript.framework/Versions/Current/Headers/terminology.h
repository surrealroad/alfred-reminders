//
//  terminology.h
//  appscript
//

#import "types.h"
#import "parser.h"
#import "utils.h"
#import "objectrenderer.h"


/**********************************************************************/


@interface ASNullConverter : NSObject

- (NSString *)convert:(NSString *)name;

- (NSString *)escape:(NSString *)name;

@end


/**********************************************************************/


@interface ASCommandDef : NSObject {
	NSString *name;
	OSType eventClass, eventID;
	NSMutableDictionary *parameters;
}

- (id)initWithName:(NSString *)name_ eventClass:(OSType)eventClass_ eventID:(OSType)eventID_;

- (void)addParameterWithName:(NSString *)name_ code:(OSType)code_;

// PUBLIC

- (NSString *)name;

- (OSType)eventClass;

- (OSType)eventID;

- (AEMType *)parameterForName:(NSString *)name_;

@end


/**********************************************************************/


@interface ASTerminology : NSObject {
	NSMutableDictionary *typeByName,
						*typeByCode,
						*propertyByName,
						*propertyByCode,
						*elementByName, 
						*elementByCode,
						*commandByName;
	id converter;
	NSMutableDictionary *keywordCache;
	ASTerminology *defaultTerms;
}

// PUBLIC

/*
 * converter : AS keyword string to C identifer string converter; should implement:
 *		-(NSString *)convert:(NSString *)name
 *		-(NSString *)escape:(NSString *)name
 *
 * defaultTerms may be nil
 */
- (id)initWithKeywordConverter:(id)converter_
			defaultTerminology:(ASTerminology *)defaultTerms_;

/*
 * add data from ASParser or equivalent
 */
- (void)addClasses:(NSArray *)classes
	   enumerators:(NSArray *)enumerators
		properties:(NSArray *)properties
		  elements:(NSArray *)elements
		  commands:(NSArray *)commands;

// PRIVATE; used by addClasses:...commands: method

- (void)addTypeTableDefinitions:(NSArray *)definitions ofType:(OSType)descType;

- (void)addReferenceTableDefinitions:(NSArray *)definitions
						 toNameTable:(NSMutableDictionary *)nameTable
						   codeTable:(NSMutableDictionary *)codeTable;

- (void)addCommandTableDefinitions:(NSArray *)commands;

// PUBLIC
// Get conversion tables (no copy)

- (NSMutableDictionary *)typeByNameTable;
- (NSMutableDictionary *)typeByCodeTable;
- (NSMutableDictionary *)propertyByNameTable;
- (NSMutableDictionary *)propertyByCodeTable;
- (NSMutableDictionary *)elementByNameTable;
- (NSMutableDictionary *)elementByCodeTable;
- (NSMutableDictionary *)commandByNameTable;

@end

