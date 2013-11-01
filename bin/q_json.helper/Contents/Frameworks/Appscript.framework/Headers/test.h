//
//  test.h
//  aem
//


#import "base.h"
#import "specifier.h"
#import "utils.h"


/**********************************************************************/
// Forward declarations

@class AEMANDTest;
@class AEMORTest;
@class AEMNOTTest;


/**********************************************************************/
// initialise constants

void initTestModule(void); // called automatically

void disposeTestModule(void);


/**********************************************************************/
// Abstract base class for all comparison and logic test classes

@interface AEMTest : AEMQuery

- (AEMANDTest *)AND:(id)remainingOperands; // takes a single test clause or an NSArray of test clauses
- (AEMORTest  *)OR:(id)remainingOperands;
- (AEMNOTTest *)NOT;

- (NSString *)formatString;

@end


/**********************************************************************/
// Comparison tests

// Abstract base class for all comparison test classes
@interface AEMComparisonTest : AEMTest {
	id operand1, operand2;	
}

- (id)initWithOperand1:(id)operand1_ operand2:(id)operand2_;

- (id)operand1; // used by isEqual:
- (id)operand2; // used by isEqual:

@end

// comparison tests
// Note: clients should not instantiate these classes directly

@interface AEMGreaterThanTest : AEMComparisonTest
@end

@interface AEMGreaterOrEqualsTest : AEMComparisonTest
@end

@interface AEMEqualsTest : AEMComparisonTest
@end

@interface AEMNotEqualsTest : AEMComparisonTest
@end

@interface AEMLessThanTest : AEMComparisonTest
@end

@interface AEMLessOrEqualsTest : AEMComparisonTest
@end

@interface AEMBeginsWithTest : AEMComparisonTest
@end

@interface AEMEndsWithTest : AEMComparisonTest
@end

@interface AEMContainsTest : AEMComparisonTest
@end

@interface AEMIsInTest : AEMComparisonTest
@end


/**********************************************************************/
// Logical tests

// Abstract base class for all logical test classes
@interface AEMLogicalTest : AEMTest {
	NSArray *operands;	
}

- (id)initWithOperands:(NSArray *)operands_;

- (id)operands; // used by isEqual:

@end

// logical tests
// Note: clients should not instantiate these classes directly

@interface AEMANDTest : AEMLogicalTest
@end

@interface AEMORTest : AEMLogicalTest
@end

@interface AEMNOTTest : AEMLogicalTest
@end

