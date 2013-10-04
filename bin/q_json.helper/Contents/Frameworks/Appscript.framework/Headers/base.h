//
//  base.h
//  aem
//

#import "utils.h"


/**********************************************************************/
// AEM reference base (shared by specifiers and tests)

@interface AEMQuery : NSObject <AEMSelfPackingProtocol> {
	NSAppleEventDescriptor *cachedDesc;
	unsigned cachedHash;
}

// set cached descriptor; performance optimisation, used internally by AEMCodecs
- (void)setCachedDesc:(NSAppleEventDescriptor *)desc;

// walk reference
- (id)resolveWithObject:(id)object;

// pack reference
- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs;

// pack reference, caching result for efficiency
- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs;

@end


/**********************************************************************/

/*
 * Base class for objects to be passed to -[AEMQuery resolveWithObject:]
 * Each method simply returns self; subclasses can override some or all of 
 * these methods as needed.
 */
@interface AEMResolver : NSObject

- (id)property:(OSType)code;
- (id)elements:(OSType)code;

- (id)first;
- (id)middle;
- (id)last;
- (id)any;

- (id)byIndex:(id)index;
- (id)byName:(id)name;
- (id)byID:(id)id_;

- (id)previous:(OSType)class_;
- (id)next:(OSType)class_;

- (id)byRange:(id)fromObject to:(id)toObject;
- (id)byTest:(id)testReference;

- (id)beginning;
- (id)end;
- (id)before;
- (id)after;

- (id)greaterThan:(id)object;
- (id)greaterOrEquals:(id)object;
- (id)equals:(id)object;
- (id)notEquals:(id)object;
- (id)lessThan:(id)object;
- (id)lessOrEquals:(id)object;
- (id)beginsWith:(id)object;
- (id)endsWith:(id)object;
- (id)contains:(id)object;
- (id)isIn:(id)object;
- (id)AND:(id)remainingOperands;
- (id)OR:(id)remainingOperands;
- (id)NOT;

- (id)app;
- (id)con;
- (id)its;
- (id)customRoot:(id)rootObject;

@end

