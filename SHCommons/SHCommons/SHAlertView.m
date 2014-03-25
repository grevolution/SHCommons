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

#import "SHAlertView.h"

@implementation SHAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (SHAlertView *)alertViewWithTitle:(NSString *)title andMessage:(NSString *)message cancelButtonTitle:(NSString *)cancel handler:(TSAlertBlock)handler;
{
  SHAlertView *alert = [[SHAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
  [alert setDelegate:alert];
  [alert setCancelButtonHandler:handler];
  return alert;
}

- (void)setCancelButtonHandler:(TSAlertBlock) block;
{
  _block = [block copy];
}

- (NSInteger)addButtonWithTitle:(NSString *)title andHandler:(TSAlertBlock)handler;
{
  NSInteger i = [self addButtonWithTitle:title];
  if(handlers_ == nil) {
    handlers_ = [[NSMutableDictionary alloc] init];
  }
  [handlers_ setObject:handler forKey:[NSNumber numberWithInt:i]];
  return i;
}

#pragma mark UIAlertView delegate methods
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
  if(buttonIndex == [alertView cancelButtonIndex]) {
		if(_block){
			_block();
		}
  } else {
    NSNumber *n = [NSNumber numberWithInt:buttonIndex];
    TSAlertBlock block = [handlers_ objectForKey:n];
    if(block) {
      block();
    }
  }
}

@end
