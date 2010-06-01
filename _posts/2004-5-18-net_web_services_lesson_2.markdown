--- 
layout: post
title: ".Net Web Services Lesson #2"
---
Debugging SOAP isn't fun, but Simon Fell's "ProxyTrace tool":http://www.pocketsoap.com/tcptrace/pt.aspx makes the job a _lot_ easier.  I had used "TcpTrace":http://www.pocketsoap.com/tcptrace/ before, but this works without tweaking your SOAP application.  

To debug my WSDL-generated c# classes, I just had to set a proxy in the generated Service class.  Add the proxy line to the following output, and include a <code>using System.Net;</code> declaration at the top.

<pre><code>
public ExampleService() {
    this.Url = "http://server.com/example.asmx";
    this.Proxy = new WebProxy("http://localhost:8080");
}
</code></pre>
