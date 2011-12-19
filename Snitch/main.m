//
//  main.m
//  Snitch
//
//  Created by Petar Shomov on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


void SaveDesktop(NSString *filename) {
    CGImageRef screenshot = CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    CIImage *image = [CIImage imageWithCGImage:screenshot];
    NSBitmapImageRep *bitmap =  [[NSBitmapImageRep alloc] initWithCIImage:image];
    
    NSData *blob = [bitmap representationUsingType:NSJPEGFileType properties:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:TRUE] , NSImageProgressive, [NSNumber numberWithFloat:0.3], NSImageCompressionFactor, nil]];
    [blob writeToFile:filename atomically:TRUE];
    [bitmap release];
    CGImageRelease(screenshot);
}

int main(int argc, char *argv[])
{
    while(TRUE) {
        NSAutoreleasePool *loopPool;
        loopPool = [[NSAutoreleasePool alloc] init];
        int idletime = CGEventSourceSecondsSinceLastEventType(1,NX_KEYDOWN | NX_LMOUSEDOWN | NX_LMOUSEUP | NX_RMOUSEDOWN | NX_RMOUSEUP | NX_MOUSEMOVED | NX_LMOUSEDRAGGED | NX_RMOUSEDRAGGED | NX_KEYUP | NX_SCROLLWHEELMOVED);
        if (idletime < 60) {
            NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
            NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
            [format1 setDateFormat:@"yyyyMMdd/yyyyMMdd-HHmmss"];
            [format2 setDateFormat:@"yyyyMMdd"];
            
            NSDate *now = [[NSDate alloc] init];
            
            NSString *fileNameString = [format1 stringFromDate:now];
            NSString *folderNameString = [format2 stringFromDate:now];
            [[NSFileManager defaultManager] createDirectoryAtPath:folderNameString withIntermediateDirectories:TRUE attributes:nil error:NULL];
            [format1 release];
            [format2 release];
            [now release];
            SaveDesktop([fileNameString stringByAppendingString:@".jpg"]);
            [loopPool drain];
            
            sleep(15);
        }
        
    }
}