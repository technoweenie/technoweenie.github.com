---
layout: post
title: Embedding Structs in Go
---

I've been toying with Go off and on for the last few months.  I'm finally at a
point where I'm using it in a real project at GitHub, so I've been exploring it
in more detail.  Yesterday I saw some duplicated code that could benefit from
class inheritance.  This isn't Ruby, so I eventually figured out that Go calls
this "embedding."  This is something I missed from my first run through the
[Effective Go book][effective].

[effective]: http://golang.org/doc/effective_go.html

Let's start with a basic struct that serves as the super class.

{% highlight go %}
type SuperStruct struct {
  PublicField string
  privateField string
}

func (s *SuperStruct) Foo() {
  fmt.Println(s.PublicField, s.privateField)
}
{% endhighlight %}

It's easy to tell what Foo() will do:

{% highlight go %}
func main() {
  sup := &SuperStruct{"public", "private"}
  sub.Foo()
  // prints "public private\n"
}
{% endhighlight %}

What happens when we embed `SuperStruct` into `SubStruct`?

{% highlight go %}
type SubStruct struct {
  CustomField string
  
  // Notice that we don't bother naming embedded struct field.
  *SuperStruct
}
{% endhighlight %}

At this point, `SuperStruct`'s two fields (`PublicField` and `privateField`) and
method (`Foo()`) are available in `SubStruct`.  `SubStruct` is initialized a
little differently though.

{% highlight go %}
func main() {
  sup := &SuperStruct{"public", "private"}
  sub := &SubStruct{"custom", sup}
  
  // you can also initialize with specific field names:
  sub := &SubStruct{CustomField: "custom", SuperStruct: sup}
}
{% endhighlight %}

From here, we can access the `SuperStruct` fields and methods as if they were
defined in `SubStruct`.

{% highlight go %}
func main() {
  sup := &SuperStruct{"public", "private"}
  sub := &SubStruct{"custom", sup}
  sub.Foo()
  // prints "public private\n"
}
{% endhighlight %}

We can also access the inner `SuperStruct` if needed.  You'd normally do this
if you wanted to override a behavior of an embedded method.

{% highlight go %}
func (s *SubStruct) Foo() {
  fmt.Println(s.CustomField, s.PublicField)
}

func main() {
  sup := &SuperStruct{"public", "private"}
  sub := &SubStruct{"custom", sup}
  sub.Foo()
  // prints "custom public\n"
}
{% endhighlight %}
