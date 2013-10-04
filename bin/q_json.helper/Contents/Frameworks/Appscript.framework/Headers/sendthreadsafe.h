/*
    File:       AESendThreadSafe.h

    Contains:   Code to send Apple events in a thread-safe manner.

    Written by: DTS

    Copyright:  Copyright (c) 2007 Apple Inc. All Rights Reserved.

    Disclaimer: IMPORTANT: This Apple software is supplied to you by Apple Inc.
                ("Apple") in consideration of your agreement to the following
                terms, and your use, installation, modification or
                redistribution of this Apple software constitutes acceptance of
                these terms.  If you do not agree with these terms, please do
                not use, install, modify or redistribute this Apple software.

                In consideration of your agreement to abide by the following
                terms, and subject to these terms, Apple grants you a personal,
                non-exclusive license, under Apple's copyrights in this
                original Apple software (the "Apple Software"), to use,
                reproduce, modify and redistribute the Apple Software, with or
                without modifications, in source and/or binary forms; provided
                that if you redistribute the Apple Software in its entirety and
                without modifications, you must retain this notice and the
                following text and disclaimers in all such redistributions of
                the Apple Software. Neither the name, trademarks, service marks
                or logos of Apple Inc. may be used to endorse or promote
                products derived from the Apple Software without specific prior
                written permission from Apple.  Except as expressly stated in
                this notice, no other rights or licenses, express or implied,
                are granted by Apple herein, including but not limited to any
                patent rights that may be infringed by your derivative works or
                by other works in which the Apple Software may be incorporated.

                The Apple Software is provided by Apple on an "AS IS" basis. 
                APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
                WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT,
                MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING
                THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
                COMBINATION WITH YOUR PRODUCTS.

                IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT,
                INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
                TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
                DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY
                OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
                OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY
                OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR
                OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF
                SUCH DAMAGE.

    Change History (most recent first):

$Log: AESendThreadSafe.h,v $
Revision 1.2  2007/02/12 11:58:43         
Corrected grammo in comment.

Revision 1.1  2007/02/09 10:55:27         
First checked in.


*/

/*

2007/06/24 -- Modified by HAS to make AESendMessageThreadSafeSynchronous API-compatible with AESendMessage; renamed AEMSendMessageThreadSafe.

*/

#ifndef _AESENDTHREADSAFE_H
#define _AESENDTHREADSAFE_H

#include <ApplicationServices/ApplicationServices.h>

/////////////////////////////////////////////////////////////////

/*
    Introduction
    ------------
    Since Mac OS X 10.2 it has been possible to synchronously send an Apple event 
    from a thread other than the main thread.  The technique for doing this is 
    documented in Technote 2053 "Mac OS X 10.2".
    
    <http://developer.apple.com/technotes/tn2002/tn2053.html>
    
    Unfortunately, this technique isn't quite right.  Specifically, due to a bug 
    in Apple Event Manager <rdar://problem/4976113>, it is not safe to dispose of 
    the Mach port (using mach_port_destroy, as documented in the technote, or, more 
    correctly, using mach_port_mod_refs) that you created to use as the reply port. 
    Doing this triggers a race condition that, very rarely, can cause the system 
    to destroy some other, completely unrelated, Mach port within your process.  
    This could cause all sorts of problems.  One common symptom is that, after 
    accidentally destroying the Mach port associated with a thread, your program 
    dies with the following message:
    
    /SourceCache/Libc/Libc-320.1.3/pthreads/pthread.c:897: failed assertion `ret == MACH_MSG_SUCCESS'
    
    The best workaround to this problem is to not dispose of the Mach port that 
    you use as the Apple event reply port.  If you have a limited number of 
    secondary threads from which you need to send Apple events, it's relatively 
    easy to allocate an Apple event reply port for each thread and then never 
    dispose it.  However, if you have general case code, it might be tricky 
    to track down all of the threads that send Apple events and make sure they 
    have reply ports.  This module was designed as a general case solution to 
    the problem.
    
    The module exports a single function, AESendMessageThreadSafeSynchronous, which, 
    as its name suggests, sends an Apple event and waits for the reply (that is, 
    a synchronous IPC) and is safe to call from an arbitrary thread.  It's basically 
    a wrapper around the system function AESendMessage, with added smarts to manage 
    a per-thread Apple event reply port.
    
    When <rdar://problem/4976113> is fixed, this module should be unnecessary but 
    benign.
    
    For information about how this works, see the comments in the implementation.
*/

/////////////////////////////////////////////////////////////////

#ifdef __cplusplus
    extern "C" {
#endif

OSStatus AEMSendMessageThreadSafe(
	AppleEvent *            eventPtr,
    AppleEvent *            replyPtr,
	AESendMode              sendMode,
    long                    timeOutInTicks
);
    // A thread-safe replacement for AESend.  This is very much like AESendMessage, 
    // except that it takes care of setting up the reply port when you use it 
    // from a thread other than the main thread.

#ifdef __cplusplus
}
#endif

#endif
