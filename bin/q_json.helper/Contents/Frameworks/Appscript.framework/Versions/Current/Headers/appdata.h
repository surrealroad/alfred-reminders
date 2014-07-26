//
//  appdata.h
//  Appscript
//


#import "application.h"
#import "codecs.h"
#import "reference.h"
#import "utils.h"


/**********************************************************************/
// typedefs

typedef enum {
	kASTargetCurrent = 1,
	kASTargetName,
	kASTargetBundleID,
	kASTargetURL,
	kASTargetPID,
	kASTargetDescriptor,
} ASTargetType;


/**********************************************************************/


@interface ASAppDataBase : AEMCodecs {
	Class aemApplicationClass;
	ASTargetType targetType;
	id targetData;
	AEMApplication *target;
	ASRelaunchMode relaunchMode;
}

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data;

// creates AEMApplication instance for target application; used internally
- (BOOL)connectWithError:(out NSError **)error;

// returns AEMApplication instance for target application
- (id)targetWithError:(out NSError **)error;

// is target application running?
- (BOOL)isRunning;

// launch the target application without sending it the usual 'run' event;
// equivalent to 'launch' command in AppleScript.
- (BOOL)launchApplicationWithError:(out NSError **)error;

// determines if an application specified by path should be relaunched if
// its AEAddressDesc is no longer valid (i.e. application has quit/restarted)
- (void)setRelaunchMode:(ASRelaunchMode)relaunchMode_;
- (ASRelaunchMode)relaunchMode;

@end


/**********************************************************************/


@interface ASAppData : ASAppDataBase {
	Class constantClass, referenceClass;
}

- (id)initWithApplicationClass:(Class)appClass
				 constantClass:(Class)constClass
				referenceClass:(Class)refClass
					targetType:(ASTargetType)type
					targetData:(id)data;

// AEMCodecs hook allowing extra typechecking to be performed here
- (id)unpackContainsCompDescriptorWithOperand1:(id)op1 operand2:(id)op2;

@end

