//
//  bridgedata.h
//  Appscript
//

#import "appdata.h"
#import "parser.h"
#import "terminology.h"
#import "utils.h"

@interface ASBridgeData : ASAppDataBase {
	id terms;
	ASTerminology *defaultTerms;
	id converter;
}

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data
				   terminology:(id)terms_
				  defaultTerms:(ASTerminology *)defaultTerms_
			  keywordConverter:(id)converter_;

- (ASTargetType)targetType;

- (id)targetData;

- (ASTerminology *)terminology;

@end
