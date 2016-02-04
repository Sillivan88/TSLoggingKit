//
//  TSLogging.m
//  TSLoggingKit
//
//  Created by Thomas Sillmann on 29.09.15.
//  Copyright (c) 2015 Thomas Sillmann. All rights reserved.
//

#import "TSLogging.h"

@interface TSLogging ()

/**
 A description string for the debug logging level.
 */
extern NSString *const LoggingLevelDescriptionDebug;

/**
 A description string for the info logging level.
 */
extern NSString *const LoggingLevelDescriptionInfo;

/**
 A description string for the warning logging level.
 */
extern NSString *const LoggingLevelDescriptionWarning;

/**
 A description string for the error logging level.
 */
extern NSString *const LoggingLevelDescriptionError;

/**
 Writes the given message into the local log file.
 @param logMessage The log message that has to be written into the local log file.
 */
- (void)writeLogMessageToFile:(NSString *)logMessage;

/**
 Returns a description string for the given logging level.
 @param loggingLevel The logging level for which a description is needed.
 @return The log description for the given logging level.
 */
- (NSString *)logDescriptionForLoggingLevel:(TSLoggingLevel)loggingLevel;

@end

@implementation TSLogging

@synthesize logFileURL = _logFileURL;

#pragma mark - Constants

NSString *const LoggingLevelDescriptionDebug = @"[DEBUG]";
NSString *const LoggingLevelDescriptionInfo = @"[INFO]";
NSString *const LoggingLevelDescriptionWarning = @"[WARNING]";
NSString *const LoggingLevelDescriptionError = @"[ERROR]";

#pragma mark - Properties

- (NSURL *)logFileURL {
    if (!_logFileURL) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        _logFileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"Logging.txt"];
    }
    return _logFileURL;
}

- (void)setLogFileURL:(NSURL *)logFileURL {
    if (_logFileURL == logFileURL) return;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_logFileURL.path]) {
        [[NSFileManager defaultManager] moveItemAtURL:_logFileURL toURL:logFileURL error:nil];
    }
    _logFileURL = logFileURL;
}

#pragma mark - Methods

+ (TSLogging *)sharedLogging {
    static TSLogging *sharedLogging;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogging = [[TSLogging alloc] init];
    });
    return sharedLogging;
}

- (void)logMessage:(NSString *)message withLoggingLevel:(TSLoggingLevel)loggingLevel forLoggingLevelSetting:(TSLoggingLevel)setLoggingLevel {
    if (setLoggingLevel == TSLoggingLevelNone) {
        return;
    }
    if (loggingLevel == TSLoggingLevelNone) {
        [self writeLogMessageToFile:message];
    } else if (loggingLevel & setLoggingLevel) {
        [self writeLogMessageToFile:[NSString stringWithFormat:@"%@: %@", [self logDescriptionForLoggingLevel:loggingLevel], message]];
    }
}

- (void)writeLogMessageToFile:(NSString *)logMessage {
    NSString *existingLogFileContent = [NSString stringWithContentsOfURL:self.logFileURL usedEncoding:nil error:nil];
    if (!existingLogFileContent) {
        existingLogFileContent = @"";
    }
    NSString *logMessageWithFollowingParagraph = [NSString stringWithFormat:@"%@%@\n", existingLogFileContent, logMessage];
    [logMessageWithFollowingParagraph writeToURL:self.logFileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)logDescriptionForLoggingLevel:(TSLoggingLevel)loggingLevel {
    NSMutableString *logDescription = [[NSMutableString alloc] initWithString:@""];
    if (loggingLevel & TSLoggingLevelDebug) {
        [logDescription appendString:LoggingLevelDescriptionDebug];
    }
    if (loggingLevel & TSLoggingLevelInfo) {
        [logDescription appendString:LoggingLevelDescriptionInfo];
    }
    if (loggingLevel & TSLoggingLevelWarning) {
        [logDescription appendString:LoggingLevelDescriptionWarning];
    }
    if (loggingLevel & TSLoggingLevelError) {
        [logDescription appendString:LoggingLevelDescriptionError];
    }
    return logDescription;
}

- (void)deleteLogFile {
    [[NSFileManager defaultManager] removeItemAtURL:self.logFileURL error:nil];
}

@end
