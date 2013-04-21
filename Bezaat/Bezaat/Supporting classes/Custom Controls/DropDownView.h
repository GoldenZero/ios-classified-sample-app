//
//  DropDownView.h
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAXIMAGEX 20
#define MAXIMAGEY 20

typedef enum {
    BLENDIN,              
	GROW,
	BOTH
} AnimationType;


@protocol DropDownViewDelegate

@required

-(void)dropDownCellSelected:(NSInteger)returnIndex :(NSInteger)_tag;

@end


@interface DropDownView : UIViewController<UITableViewDelegate,UITableViewDataSource> {

	NSInteger tag;
	
	UITableView *uiTableView;
	
	NSMutableArray *selectedStates;
	
	NSArray *arrayData,*imageArray;
	
	CGFloat heightOfCell;
	
	CGFloat paddingLeft;
	
	CGFloat paddingRight;
	
	CGFloat paddingTop;
	
	CGFloat heightTableView;
	
	UIView *refView;
	
	id<DropDownViewDelegate> delegate;
	
	NSInteger animationType;
	
	CGFloat open;
	
	CGFloat close;
	
	BOOL areThereImages;
	
}

@property (strong) id<DropDownViewDelegate> delegate;

@property (nonatomic,retain)UITableView *uiTableView;

@property (nonatomic,retain) NSArray *arrayData,*imageArray;

@property (nonatomic,retain) NSMutableArray *selectedStates;

@property (nonatomic) CGFloat heightOfCell;

@property (nonatomic) CGFloat paddingLeft;

@property (nonatomic) CGFloat paddingRight;

@property (nonatomic) CGFloat paddingTop;

@property (nonatomic) CGFloat heightTableView;

@property (nonatomic,retain)UIView *refView;

@property (nonatomic) CGFloat open;

@property (nonatomic) CGFloat close;

@property (nonatomic) NSInteger tag;

- (id)initWithArrayData:(NSArray*)data imageData:(NSArray*)iData checkMarkData:(int)cData  cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation
  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration _tag: (NSInteger)thetag;

-(void)closeAnimation;

-(void)openAnimation;

-(void)adjustFrameToView;

-(void)adjustFrameToPoint:(CGPoint) p;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


@end
