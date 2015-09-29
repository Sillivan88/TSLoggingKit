//
//  TSLogging.h
//  TSLoggingKit
//
//  Created by Thomas Sillmann on 29.09.15.
//  Copyright (c) 2015 Thomas Sillmann. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The @c TSLogging class is used to create and save log messages within a local log file which is stored in the file system the app.
 */
@interface TSLogging : NSObject

enum {
    /**
     Option for indicating that no logging level is used.
     */
    TSLoggingLevelNone = 0,
    /**
     Logging level to log debug information.
     */
    TSLoggingLevelDebug = 1 << 0,
    /**
     Logging level to log general information.
     */
    TSLoggingLevelInfo = 1 << 1,
    /**
     Logging level to log warnings.
     */
    TSLoggingLevelWarning = 1 << 2,
    /**
     Logging level to log errors.
     */
    TSLoggingLevelError = 1 << 3
};
/**
 Options to define the logging level.
 */
typedef NSUInteger TSLoggingLevel;

/**
 Contains the URL to the log file within the file system of the app. The default log file URL is the documents directory of the app, the log file has the default name "Logging.txt". If this property is set to a new value, the framework will check if already a file called "Logging.txt" exists in the previous location. If so, the existing file will be moved to the new location.
 */
@property (strong, nonatomic) NSURL *logFileURL;

/**
 Returns a shared @c TSLogging object instance.
 @return The singleton instance of the @c TSLogging class.
 */
+ (TSLogging *)sharedLogging;

/**
 Logs a given message in the local log file depending on two factors:
 
 1. The parameter @c setLoggingLevel is not equal to @c TSLoggingLevelNone
 
 2. The parameter @c loggingLevel contains an appropriate value stored in @c setLoggingLevel
 
 Only if both checks are positive, the given message will be written into the local log file. If the parameter @c loggingLevel is not equal to @c TSLoggingLevelNone, a short logging description will be stored in the local log file in front of the given log message so that it is obvious to see the logging level of a log message while reading the log file.
 @param message The message to write into the local log file.
 @param loggingLevel The logging level of the log message.
 @param setLoggingLevel The logging level defined in the settings of the app to determine which logging level should be logged and written into the local log file and which not.
 */
- (void)logMessage:(NSString *)message withLoggingLevel:(TSLoggingLevel)loggingLevel forLoggingLevelSetting:(TSLoggingLevel)setLoggingLevel;

/**
 Removes the log file from the local file system of the app.
 */
- (void)deleteLogFile;

@end
