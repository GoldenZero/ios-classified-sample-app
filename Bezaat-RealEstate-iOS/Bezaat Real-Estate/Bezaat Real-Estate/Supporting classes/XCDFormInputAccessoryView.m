//
//  XCDFormInputAccessoryView.m
//
//  Created by Cédric Luthi on 2012-11-10
//  Copyright (c) 2012 Cédric Luthi. All rights reserved.
//

#import "XCDFormInputAccessoryView.h"

static NSString * UIKitLocalizedString(NSString *string)
{
	NSBundle *UIKitBundle = [NSBundle bundleForClass:[UIApplication class]];
	return UIKitBundle ? [UIKitBundle localizedStringForKey:string value:string table:nil] : string;
}

static NSArray * EditableTextInputsInView(UIView *view)
{
	NSMutableArray *textInputs = [NSMutableArray new];
	for (UIView *subview in view.subviews)
	{
		BOOL isTextField = [subview isKindOfClass:[UITextField class]];
		BOOL isEditableTextView = [subview isKindOfClass:[UITextView class]] && [(UITextView *)subview isEditable];
		if (isTextField || isEditableTextView)
			[textInputs addObject:subview];
		else
			[textInputs addObjectsFromArray:EditableTextInputsInView(subview)];
	}
	return textInputs;
}

@implementation XCDFormInputAccessoryView
{
	UIToolbar *_toolbar;
}

- (id) initWithFrame:(CGRect)frame
{
	return [self initWithResponders:nil];
}

- (id) initWithResponders:(NSArray *)responders
{
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
	
	_responders = responders;
	
	_toolbar = [[UIToolbar alloc] init];
	_toolbar.tintColor = nil;
    _toolbar.tintColor =[UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1.0f];
	_toolbar.barStyle = UIBarStyleDefault;
	_toolbar.translucent = YES;
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIImage* ig1 = [UIImage imageNamed:@"Accessory_left"];
    UIImage* ig2 = [UIImage imageNamed:@"Accessory_right"];
	
    UIView* segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 102, 25)];
    segmentView.backgroundColor = [UIColor clearColor];
    
    UIButton* segment0 = [UIButton buttonWithType:UIButtonTypeCustom];
    segment0.frame = CGRectMake(0, 0, 51, 25);
    [segment0 setImage:ig1 forState:UIControlStateNormal];
    segment0.tag = 0;
    [segment0 setAdjustsImageWhenHighlighted:NO];
    [segment0 addTarget:self action:@selector(selectAdjacentResponder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* segment1 = [UIButton buttonWithType:UIButtonTypeCustom];
    segment1.frame = CGRectMake(51, 0, 51, 25);
    [segment1 setImage:ig2 forState:UIControlStateNormal];
    segment1.tag = 1;
    [segment1 setAdjustsImageWhenHighlighted:NO];
    [segment1 addTarget:self action:@selector(selectAdjacentResponder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [segmentView addSubview:segment0];
    [segmentView addSubview:segment1];
    
	UIBarButtonItem *segmentedControlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	_toolbar.items = @[ segmentedControlBarButtonItem, flexibleSpace ];
	self.hasDoneButton = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
	
	[self addSubview:_toolbar];
	
	self.frame = _toolbar.frame = (CGRect){CGPointZero, [_toolbar sizeThatFits:CGSizeZero]};
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
	
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateSegmentedControl
{
	NSArray *responders = self.responders;
	if ([responders count] == 0)
		return;
	
	UIView *CurrentView = (UIView *)[_toolbar.items[0] customView];
    UIButton* segmentedControl1;
    UIButton* segmentedControl2;
    for (UIButton* temp in CurrentView.subviews) {
        NSLog(@"segment tag is :%i",temp.tag);
         if (temp.tag == 0)
             segmentedControl1 = temp;
        else if (temp.tag == 1)
            segmentedControl2 = temp;
    }
    
	BOOL isFirst = [[responders objectAtIndex:0] isFirstResponder];
	BOOL isLast = [[responders lastObject] isFirstResponder];
    if (segmentedControl1) {
        [segmentedControl1 setEnabled:!isFirst];
        [segmentedControl2 setEnabled:!isLast];
    }else if (segmentedControl2)
    {
        [segmentedControl1 setEnabled:!isFirst];
        [segmentedControl2 setEnabled:!isLast];
    }
	//[segmentedControl setEnabled:!isFirst forSegmentAtIndex:0];
	//[segmentedControl setEnabled:!isLast forSegmentAtIndex:1];
}

- (void) willMoveToWindow:(UIWindow *)window
{
	if (!window)
		return;
	
	[self updateSegmentedControl];
}

- (void) textInputDidBeginEditing:(NSNotification *)notification
{
	[self updateSegmentedControl];
}

- (NSArray *) responders
{
	if (_responders)
		return _responders;
	
	NSArray *textInputs = EditableTextInputsInView([[UIApplication sharedApplication] keyWindow]);
	return [textInputs sortedArrayUsingComparator:^NSComparisonResult(UIView *textInput1, UIView *textInput2) {
		UIView *commonAncestorView = textInput1.superview;
		while (commonAncestorView && ![textInput2 isDescendantOfView:commonAncestorView])
			commonAncestorView = commonAncestorView.superview;
		
		CGRect frame1 = [textInput1 convertRect:textInput1.bounds toView:commonAncestorView];
		CGRect frame2 = [textInput2 convertRect:textInput2.bounds toView:commonAncestorView];
		return [@(CGRectGetMinY(frame1)) compare:@(CGRectGetMinY(frame2))];
	}];
}

- (void) setHasDoneButton:(BOOL)hasDoneButton
{
	[self setHasDoneButton:hasDoneButton animated:NO];
}

- (void) setHasDoneButton:(BOOL)hasDoneButton animated:(BOOL)animated
{
	if (_hasDoneButton == hasDoneButton)
		return;
	
	[self willChangeValueForKey:@"hasDoneButton"];
	_hasDoneButton = hasDoneButton;
	[self didChangeValueForKey:@"hasDoneButton"];
	UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"تم" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    sendItem.tintColor = [UIColor blackColor];
    
	NSArray *items;
	if (hasDoneButton)
		items = [_toolbar.items arrayByAddingObject:sendItem];
	else
		items = [_toolbar.items subarrayWithRange:NSMakeRange(0, 2)];
	
	[_toolbar setItems:items animated:animated];
}

#pragma mark - Actions

- (void) selectAdjacentResponder:(UIButton *)sender
{
	NSArray *firstResponders = [self.responders filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIResponder *responder, NSDictionary *bindings) {
		return [responder isFirstResponder];
	}]];
	UIResponder *firstResponder = [firstResponders lastObject];
	NSInteger offset = sender.tag == 0 ? -1 : +1;
	NSInteger firstResponderIndex = [self.responders indexOfObject:firstResponder];
	NSInteger adjacentResponderIndex = firstResponderIndex != NSNotFound ? firstResponderIndex + offset : NSNotFound;
	UIResponder *adjacentResponder = nil;
	if (adjacentResponderIndex >= 0 && adjacentResponderIndex < (NSInteger)[self.responders count])
		adjacentResponder = [self.responders objectAtIndex:adjacentResponderIndex];
	
	[adjacentResponder becomeFirstResponder];
}

- (void) done
{
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
