JNRestClient
============

A Dead simple rest client

Getting Started
============

1. Copy JNRestClient classes into your project.
2. `restClient = [[JNRestClient alloc] init];`
3. If you need to send data in a POST, add the data to: `restClient.data`
4. Start a request with `- (void)startWithURL:(NSURL *)url andCompletionHandler:(void(^)(NSData * result,NSError * error))handler` 



Options
============

If you need to ignore invalid certificates set: `restClient.ignoreCertificateValidation = YES`


Considerations
============

No data conversion to make it easy to parse JSON or XML or whatever...

The completion handler will be called in a background thread if you need to go back to the Main thread just call:
`
  dispatch_async(dispatch_get_main_queue(), ^{
    // DO SOMETHING WITH RESULT DATA
  });
        `
        
Licence
============
        
The MIT License (MIT)

Copyright (c) 2014 João Nunes

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
