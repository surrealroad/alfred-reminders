//
//  formatter.m
//  appscript
//


@interface AEMObjectRenderer : NSObject

+(NSString *)formatOSType:(OSType)code;

+(void)formatObject:(id)obj indent:(NSString *)indent result:(NSMutableString *)result;

+(NSString *)formatObject:(id)obj;

@end

