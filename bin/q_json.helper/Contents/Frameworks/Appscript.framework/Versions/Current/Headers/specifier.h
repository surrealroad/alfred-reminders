//
//  specifier.h
//  aem
//

#import "base.h"
#import "test.h"
#import "utils.h"
#import "objectrenderer.h"


/**********************************************************************/


#define AEMApp [AEMApplicationRoot applicationRoot]
#define AEMCon [AEMCurrentContainerRoot currentContainerRoot]
#define AEMIts [AEMObjectBeingExaminedRoot objectBeingExaminedRoot]
#define AEMRoot(object) [AEMCustomRoot customRootWithObject: object]


/**********************************************************************/
// Forward declarations

@class AEMPropertySpecifier;
@class AEMUserPropertySpecifier;
@class AEMElementByNameSpecifier;
@class AEMElementByIndexSpecifier;
@class AEMElementByIDSpecifier;
@class AEMElementByOrdinalSpecifier;
@class AEMElementByRelativePositionSpecifier;
@class AEMElementsByRangeSpecifier;
@class AEMElementsByTestSpecifier;
@class AEMAllElementsSpecifier;

@class AEMGreaterThanTest;
@class AEMGreaterOrEqualsTest;
@class AEMEqualsTest;
@class AEMNotEqualsTest;
@class AEMLessThanTest;
@class AEMLessOrEqualsTest;
@class AEMBeginsWithTest;
@class AEMEndsWithTest;
@class AEMContainsTest;
@class AEMIsInTest;

@class AEMSpecifier;
@class AEMReferenceRootBase;
@class AEMApplicationRoot;
@class AEMCurrentContainerRoot;
@class AEMObjectBeingExaminedRoot;
@class AEMCustomRoot;

@class AEMTest;


/**********************************************************************/
// initialise constants

void initSpecifierModule(void); // called automatically

void disposeSpecifierModule(void);


/**********************************************************************/
// Specifier base

/*
 * Abstract base class for all object specifier classes.
 */
@interface AEMSpecifier : AEMQuery {
	AEMSpecifier *container;
	id key;
}

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_;

// reserved methods

- (id)key; // used by -isEqual:
- (id)container; // used by -isEqual:

- (AEMReferenceRootBase *)root;
- (AEMSpecifier *)trueSelf;

@end


/**********************************************************************/
// Performance optimisation used by -[AEMCodecs unpackObjectSpecifier:]


@interface AEMDeferredSpecifier : AEMSpecifier {
	id reference;
	NSAppleEventDescriptor *desc;
	id codecs;
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc_ codecs:(id)codecs_;

- (id)realReference;

@end


/**********************************************************************/
// Insertion location specifier

/*
 * A reference to an element insertion point.
 */
@interface AEMInsertionSpecifier : AEMSpecifier
@end


/**********************************************************************/
// Position specifier base

/*
 * All property and element reference forms inherit from this abstract class.
 */
@interface AEMObjectSpecifier : AEMSpecifier {
	OSType wantCode;
}

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_;

- (OSType)wantCode; // used by isEqual

// Comparison and logic tests

- (AEMGreaterThanTest		*)greaterThan:(id)object;
- (AEMGreaterOrEqualsTest	*)greaterOrEquals:(id)object;
- (AEMEqualsTest			*)equals:(id)object;
- (AEMNotEqualsTest			*)notEquals:(id)object;
- (AEMLessThanTest			*)lessThan:(id)object;
- (AEMLessOrEqualsTest		*)lessOrEquals:(id)object;
- (AEMBeginsWithTest		*)beginsWith:(id)object;
- (AEMEndsWithTest			*)endsWith:(id)object;
- (AEMContainsTest			*)contains:(id)object;
- (AEMIsInTest				*)isIn:(id)object;

// Insertion location selectors

- (AEMInsertionSpecifier *)beginning;
- (AEMInsertionSpecifier *)end;
- (AEMInsertionSpecifier *)before;
- (AEMInsertionSpecifier *)after;

// property and all-element specifiers

- (AEMPropertySpecifier		*)property:(OSType)propertyCode;
- (AEMUserPropertySpecifier	*)userProperty:(NSString *)propertyName;
- (AEMAllElementsSpecifier	*)elements:(OSType)classCode;

// by-relative-position selectors

- (AEMElementByRelativePositionSpecifier *)previous:(OSType)classCode;
- (AEMElementByRelativePositionSpecifier *)next:(OSType)classCode;

@end


/**********************************************************************/
// Properties

/*
 * Specifier identifying an application-defined property
 */
@interface AEMPropertySpecifier : AEMObjectSpecifier
@end


@interface AEMUserPropertySpecifier : AEMObjectSpecifier
@end


/**********************************************************************/
// Single elements

/*
 * Abstract base class for all single element specifiers
 */
@interface AEMSingleElementSpecifier : AEMObjectSpecifier
@end

/*
 * Specifiers identifying a single element by name, index, id or named ordinal
 */
@interface AEMElementByNameSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByIndexSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByIDSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByOrdinalSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByRelativePositionSpecifier : AEMObjectSpecifier
@end


/**********************************************************************/
// Multiple elements

/*
 * Base class for all multiple element specifiers.
 */
@interface AEMMultipleElementsSpecifier : AEMObjectSpecifier 

// ordinal selectors

- (AEMElementByOrdinalSpecifier *)first;
- (AEMElementByOrdinalSpecifier *)middle;
- (AEMElementByOrdinalSpecifier *)last;
- (AEMElementByOrdinalSpecifier *)any;

// by-index, by-name, by-id selectors
 
- (AEMElementByIndexSpecifier	*)at:(int)index;
- (AEMElementByIndexSpecifier	*)byIndex:(id)index; // normally NSNumber, but may occasionally be other types
- (AEMElementByNameSpecifier	*)byName:(id)name;
- (AEMElementByIDSpecifier		*)byID:(id)id_;

// by-range selector

- (AEMElementsByRangeSpecifier *)at:(int)startIndex to:(int)stopIndex;
- (AEMElementsByRangeSpecifier *)byRange:(id)startReference to:(id)stopReference; // takes two con-based references, with other values being expanded as necessary

// by-test selector

- (AEMElementsByTestSpecifier *)byTest:(AEMTest *)testReference;

@end


@interface AEMElementsByRangeSpecifier : AEMMultipleElementsSpecifier {
	id startReference, stopReference;
}

- (id)initWithContainer:(AEMSpecifier *)container_
				  start:(id)startReference_
				   stop:(id)stopReference_
			   wantCode:(OSType)wantCode_;

- (id)startReference; // used by isEqual:
- (id)stopReference; // used by isEqual:

@end


@interface AEMElementsByTestSpecifier : AEMMultipleElementsSpecifier
@end


@interface AEMAllElementsSpecifier : AEMMultipleElementsSpecifier
@end


/**********************************************************************/
// Multiple element shim

@interface AEMUnkeyedElementsShim : AEMSpecifier {
	OSType wantCode;
}

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_;

@end


/**********************************************************************/
// Reference roots

@interface AEMReferenceRootBase : AEMObjectSpecifier // abstract class

// note: clients should avoid initialising this class directly;
// use provided class methods or convenience macros instead

@end

@interface AEMApplicationRoot : AEMReferenceRootBase

+ (AEMApplicationRoot *)applicationRoot;

@end

@interface AEMCurrentContainerRoot : AEMReferenceRootBase

+ (AEMCurrentContainerRoot *)currentContainerRoot;

@end

@interface AEMObjectBeingExaminedRoot : AEMReferenceRootBase

+ (AEMObjectBeingExaminedRoot *)objectBeingExaminedRoot;

@end

@interface AEMCustomRoot : AEMReferenceRootBase {
	id rootObject;
}

+ (AEMCustomRoot *)customRootWithObject:(id)object;

- (id)initWithObject:(id)object;

- (id)rootObject; // used by isEqual

@end

