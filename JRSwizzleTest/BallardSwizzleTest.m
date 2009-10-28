#import "BallardSwizzleTest.h"
#import "MethodSwizzle.h"

BOOL aFooCalled, bFooCalled, bAltFooCalled;

@interface A3 : NSObject {}
- (void)foo3;
+ (void)cfoo3;
@end
@implementation A3
- (void)foo3 {
	aFooCalled = YES;
}
+ (void)cfoo3 {
	aFooCalled = YES;
}
@end

@interface B3 : A3 {}
@end
@implementation B3
- (void)foo3 {
	bFooCalled = YES;
}
+ (void)cfoo3 {
	bFooCalled = YES;
}
@end

@interface B3 (altFoo3)
- (void)altFoo3;
+ (void)altCFoo3;
@end
@implementation B3 (altFoo3)
- (void)altFoo3 {
	bAltFooCalled = YES;
}
+ (void)altCFoo3 {
	bAltFooCalled = YES;
}
@end

@interface A4 : NSObject {}
- (void)foo4;
+ (void)cfoo4;
@end
@implementation A4
- (void)foo4 {
	aFooCalled = YES;
}
+ (void)cfoo4 {
	aFooCalled = YES;
}
@end

@interface B4 : A4 {}
@end
@implementation B4
@end

@interface B4 (altFoo4)
- (void)altFoo4;
+ (void)altCFoo4;
@end
@implementation B4 (altFoo4)
- (void)altFoo4 {
	bAltFooCalled = YES;
}
+ (void)altCFoo4 {
	bAltFooCalled = YES;
}
@end

@implementation BallardSwizzleTest

- (void)testBallardSwizzleOfDirectMethod {
	A3 *a = [[[A3 alloc] init] autorelease];
	B3 *b = [[[B3 alloc] init] autorelease];
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo3];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo3];
		STAssertFalse(aFooCalled, nil);
		STAssertTrue(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}
	
	MethodSwizzle([B3 class], @selector(foo3), @selector(altFoo3));
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo3];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo3];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

- (void)testBallardSwizzleOfInheritedMethod {
	A4 *a = [[[A4 alloc] init] autorelease];
	B4 *b = [[[B4 alloc] init] autorelease];
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo4];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo4];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}
	
	MethodSwizzle([B4 class], @selector(foo4), @selector(altFoo4));
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo4];
		STAssertTrue(aFooCalled, nil); // CORRECT BEHAVIOR
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo4];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

- (void)testBallardSwizzleOfDirectClassMethod {
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A3 cfoo3];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B3 cfoo3];
		STAssertFalse(aFooCalled, nil);
		STAssertTrue(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}
	
	ClassMethodSwizzle([B3 class], @selector(cfoo3), @selector(altCFoo3));
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A3 cfoo3];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B3 cfoo3];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

- (void)testBallardSwizzleOfInheritedClassMethod {
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A4 cfoo4];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B4 cfoo4];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}
	
	ClassMethodSwizzle([B4 class], @selector(cfoo4), @selector(altCFoo4));
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A4 cfoo4];
		STAssertTrue(aFooCalled, nil); // CORRECT BEHAVIOR
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B4 cfoo4];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

@end
