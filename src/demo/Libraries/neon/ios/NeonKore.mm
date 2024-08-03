#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include "NeonKore.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nonatomic) NSWindow *window;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
		[NSApp activateIgnoringOtherApps:YES];

		self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 800, 600)
																							styleMask:(NSWindowStyleMaskTitled |
																												 NSWindowStyleMaskClosable |
																												 NSWindowStyleMaskResizable)
																								backing:NSBackingStoreBuffered
																									defer:NO];
		[self.window setTitle:@"Haxe App"];
		[self.window makeKeyAndOrderFront:nil];
		NSLog(@"Window created and displayed.");
}
@end

@interface CustomView : NSView
@end

@implementation CustomView
- (void)drawRect:(NSRect)dirtyRect {
		NSLog(@"CustomView drawRect called.");
		[[NSColor whiteColor] setFill];
		NSRectFill(dirtyRect);

		// Custom rendering logic
		[[NSColor blueColor] setFill];
		NSRect rectangle = NSMakeRect(10, 10, 100, 100);
		NSRectFill(rectangle);
}
@end

namespace NeonKore {
	static CustomView *customView = nullptr;

	const char* greet(const char* name) {
		@autoreleasepool {
				NSString *nameString = [NSString stringWithUTF8String:name];
				NSString *greeting = [NSString stringWithFormat:@"Hello, %@", nameString];
				return strdup([greeting UTF8String]);
		}
	}

	void createNSView(float x, float y, float width, float height) {
			NSLog(@"createNSView called with x: %f, y: %f, width: %f, height: %f", x, y, width, height);
			dispatch_async(dispatch_get_main_queue(), ^{
					AppDelegate *delegate = (AppDelegate *)[NSApp delegate];
					NSWindow *window = delegate.window;
					if (!window) {
							NSLog(@"No main window available.");
							return;
					}
					customView = [[CustomView alloc] initWithFrame:NSMakeRect(x, y, width, height)];
					[window.contentView addSubview:customView];
					[customView setNeedsDisplay:YES];
					NSLog(@"NSView created and added to window.");
			});
	}

	void setNSViewBackgroundColor(float red, float green, float blue, float alpha) {
			NSLog(@"setNSViewBackgroundColor called with red: %f, green: %f, blue: %f, alpha: %f", red, green, blue, alpha);
			if (customView) {
					dispatch_async(dispatch_get_main_queue(), ^{
							customView.wantsLayer = YES;
							customView.layer.backgroundColor = [[NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha] CGColor];
							[customView setNeedsDisplay:YES]; // Trigger a redraw
							NSLog(@"NSView background color set.");
					});
			} else {
					NSLog(@"CustomView is not initialized.");
			}
	}

	void initialize() {
		NSLog(@"initialize called.");
		@autoreleasepool {
			AppDelegate *delegate = [AppDelegate new];
			[NSApplication sharedApplication];
			[NSApp setDelegate:delegate];		
			[NSApp run];
		}
	}

	void run() {
		NSLog(@"running...");
		@autoreleasepool {
			[NSApp run];
		}
	}
}
