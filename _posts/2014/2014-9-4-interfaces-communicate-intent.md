---
layout: post
title: Go interfaces communicate intent
---

Interfaces are one of my favorite features of Go.  When used properly in
arguments, they tell you what a function is going to do with your object.

```go
// from io
func Copy(dst Writer, src Reader) (written int64, err error)
```

Right away, you know `Copy()` is going to call `dst.Write()` and `src.Read()`.

Interfaces in return types tell you what you can and should do with the object.

```go
// from os/exec
func (c *Cmd) StdoutPipe() (io.ReadCloser, error) {
```

It's unclear what type of object `StdoutPipe()` is returning, but I do know that
I can read it.  Since [it also implements `io.Closer`](http://golang.org/pkg/io/#ReadCloser),
I know that I should probably close it somewhere.

This brings up a good rule of thumb when designing Go APIs.  Prefer an
`io.Reader` over an `io.ReadCloser` for arguments.  Let the calling code handle
its own resource cleanup. Simple enough.  So what breaks this rule?  Oh, my
dumb [passthrough package](https://github.com/technoweenie/go-passthrough/blob/9b75ef991fd3ad93fe346aeb23980c84fb3635fc/passthrough.go#L22).

Here's the intended way to use it:

```go
func main() {
  fakeResWriter := pseudoCodeForExample()
  res, _ := http.Get("SOMETHING")
  passthrough.Pass(res, fakeResWriter, 200)
}
```

However, on a first glance without any knowledge of how the `passthrough`
package works, you may be inclined to close the body manually.

```go
func main() {
  fakeResWriter := pseudoCodeForExample()
  res, _ := http.Get("SOMETHING")
  // hopefully you're not ignoring this possible error :)

  // close body manually
  defer res.Body.Close()

  // passthrough also closes it???
  passthrough.Pass(res, fakeResWriter, 200)
}
```

Now, you're closing the Body twice.  That's not great.

Resource management is very important, so we commonly review code to ensure
everything is handled properly.  Helper functions that try to do too much like
`passthrough` have caused us enough issues that I've rethought how I design
Go packages.  Don't get in the way of idiomatic Go code.
