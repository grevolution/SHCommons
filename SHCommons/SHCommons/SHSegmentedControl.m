//
// Copyright (c) 2014 Shan Ul Haq (http://grevolution.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "SHSegmentedControl.h"

@implementation SHSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (BOOL)isIOS7 {
    static BOOL isIOS7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        if (deviceSystemMajorVersion >= 7) {
            isIOS7 = YES;
        }
        else {
            isIOS7 = NO;
        }
    });
    return isIOS7;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if (![[self class] isIOS7]) {
        // before iOS7 the segment is selected in touchesBegan
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            // if the selectedSegmentIndex before the selection process is equal to the selectedSegmentIndex
            // after the selection process the superclass won't send a UIControlEventValueChanged event.
            // So we have to do this ourselves.
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    if ([[self class] isIOS7]) {
        // on iOS7 the segment is selected in touchesEnded
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


@end
