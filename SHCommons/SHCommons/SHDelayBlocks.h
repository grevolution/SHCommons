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

#import <Foundation/Foundation.h>

typedef void(^SHDelayedBlockHandle)(BOOL cancel);

static SHDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t block) {
	
	if (nil == block) {
		return nil;
	}
	
	// block is likely a literal defined on the stack, even though we are using __block to allow us to modify the variable 
	// we still need to move the block to the heap with a copy
	__block dispatch_block_t blockToExecute = [block copy];
	__block SHDelayedBlockHandle delayHandleCopy = nil;
	
	SHDelayedBlockHandle delayHandle = ^(BOOL cancel){
		if (NO == cancel && nil != blockToExecute) {
			dispatch_async(dispatch_get_main_queue(), blockToExecute);
		}
		
		// Once the handle block is executed, canceled or not, we free blockToExecute and the handle.
		// Doing this here means that if the block is canceled, we aren't holding onto retained objects for any longer than necessary.
		blockToExecute = nil;
		delayHandleCopy = nil;
	};
		
	// delayHandle also needs to be moved to the heap.
	delayHandleCopy = [delayHandle copy];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		if (nil != delayHandleCopy) {
			delayHandleCopy(NO);
		}
	});

	return delayHandleCopy;
};

static void cancel_delayed_block(TSDelayedBlockHandle delayedHandle) {
	if (nil == delayedHandle) {
		return;
	}
	
	delayedHandle(YES);
}