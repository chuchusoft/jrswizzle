#import "JRSwizzleTest.h"
#import "JRSwizzle.h"

BOOL aFooCalled, bFooCalled, bAltFooCalled;

#pragma mark -
#pragma mark Scenario 7: Test JRSwizzle of Direct Implementation
#pragma mark -

@interface A7 : NSObject {}
- (void)foo7;
+ (void)cfoo7;
@end
@implementation A7
- (void)foo7 {
	aFooCalled = YES;
}
+ (void)cfoo7 {
	aFooCalled = YES;
}
@end

@interface B7 : A7 {}
@end
@implementation B7
- (void)foo7 {
	bFooCalled = YES;
}
+ (void)cfoo7 {
	bFooCalled = YES;
}
@end

@interface B7 (altFoo7)
- (void)altFoo7;
+ (void)altCFoo7;
@end
@implementation B7 (altFoo7)
- (void)altFoo7 {
	bAltFooCalled = YES;
}
+ (void)altCFoo7 {
	bAltFooCalled = YES;
}
@end

@interface JRSwizzleTest (testJRSwizzleOfDirectMethod)
- (void)testJRSwizzleOfDirectMethod;
- (void)testJRSwizzleOfDirectClassMethod;
@end
@implementation JRSwizzleTest (testJRSwizzleOfDirectMethod)

- (void)testJRSwizzleOfDirectMethod {
	A7 *a = [[[A7 alloc] init] autorelease];
	B7 *b = [[[B7 alloc] init] autorelease];
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo7];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo7];
		STAssertFalse(aFooCalled, nil);
		STAssertTrue(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}
	
	NSError *error = nil;
	[B7 jr_swizzleMethod:@selector(foo7)
			  withMethod:@selector(altFoo7)
				   error:&error];
	STAssertNil(error, nil);
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo7];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo7];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

- (void)testJRSwizzleOfDirectClassMethod {
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A7 cfoo7];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);

		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B7 cfoo7];
		STAssertFalse(aFooCalled, nil);
		STAssertTrue(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}

	NSError *error = nil;
	[B7 jr_swizzleClassMethod:@selector(cfoo7)
			  withClassMethod:@selector(altCFoo7)
						error:&error];
	STAssertNil(error, nil);

	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A7 cfoo7];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);

		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B7 cfoo7];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

@end

#pragma mark -
#pragma mark Scenario 8: Test JRSwizzle of Inherited Implementation
#pragma mark -

@interface A8 : NSObject {}
- (void)foo8;
+ (void)cfoo8;
@end
@implementation A8
- (void)foo8 {
	aFooCalled = YES;
}
+ (void)cfoo8 {
	aFooCalled = YES;
}
@end

@interface B8 : A8 {}
@end
@implementation B8
@end

@interface B8 (altFoo8)
- (void)altFoo8;
+ (void)altCFoo8;
@end
@implementation B8 (altFoo8)
- (void)altFoo8 {
	bAltFooCalled = YES;
}
+ (void)altCFoo8 {
	bAltFooCalled = YES;
}
@end

@interface JRSwizzleTest (testJRSwizzleOfInheritedMethod)
- (void)testJRSwizzleOfInheritedMethod;
- (void)testJRSwizzleOfInheritedClassMethod;
@end
@implementation JRSwizzleTest (testJRSwizzleOfInheritedMethod)

- (void)testJRSwizzleOfInheritedMethod {
	A8 *a = [[[A8 alloc] init] autorelease];
	B8 *b = [[[B8 alloc] init] autorelease];
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo8];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo8];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}
	
	NSError *error = nil;
	[B8 jr_swizzleMethod:@selector(foo8)
			  withMethod:@selector(altFoo8)
				   error:&error];
	STAssertNil(error, nil);
	
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[a foo8];
		STAssertTrue(aFooCalled, nil); // CORRECT BEHAVIOR
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
		
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[b foo8];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

- (void)testJRSwizzleOfInheritedClassMethod {
	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A8 cfoo8];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);

		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B8 cfoo8];
		STAssertTrue(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);
	}

	NSError *error = nil;
	[B8 jr_swizzleClassMethod:@selector(cfoo8)
			  withClassMethod:@selector(altCFoo8)
						error:&error];
	STAssertNil(error, nil);

	{
		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[A8 cfoo8];
		STAssertTrue(aFooCalled, nil); // CORRECT BEHAVIOR
		STAssertFalse(bFooCalled, nil);
		STAssertFalse(bAltFooCalled, nil);

		aFooCalled = bFooCalled = bAltFooCalled = NO;
		[B8 cfoo8];
		STAssertFalse(aFooCalled, nil);
		STAssertFalse(bFooCalled, nil);
		STAssertTrue(bAltFooCalled, nil);
	}
}

@end

@implementation JRSwizzleTest
@end