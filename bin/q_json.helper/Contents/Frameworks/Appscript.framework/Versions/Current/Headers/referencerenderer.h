//
//  referencerenderer.h
//  appscript
//

#import "objectrenderer.h"
#import "reference.h"
#import "utils.h"

/**********************************************************************/
// reference renderer abstract base

@interface ASReferenceRenderer : AEMResolver {
	id appData;
	NSMutableString *result;
}

- (id)initWithAppData:(id)appData_;


/*******/
// private

- (NSString *)format:(id)object;
- (NSString *)result;

/*******/
// public
// application-specific subclasses should override this method to provide their own prefix codes

+ (NSString *)formatObject:(id)object appData:(id)appData_;

/*******/
// method stubs; application-specific subclasses will override to provide code->name translations

- (NSString *)propertyByCode:(OSType)code;
- (NSString *)elementByCode:(OSType)code;
- (NSString *)prefix;

@end

