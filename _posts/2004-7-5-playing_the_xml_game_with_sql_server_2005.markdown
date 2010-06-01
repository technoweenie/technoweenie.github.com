--- 
layout: post
title: Playing the XML game with SQL Server 2005
---
With the "release of the Visual Studio Express betas":http://techno-weenie.net/blog/code/87/visual-studio-express, I've been wanting to sit down and get to know the new framework and IDE.  

The first major task for me was to insert XML into SQL Server 2005 Express and perform XPATH queries on it.  SQL Server 2005 has a new XML datatype for"raw XML data":http://msdn.microsoft.com/sql/default.aspx?pull=/msdnmag/issues/04/02/xmlinyukon/default.aspx.  With the wonderful XmlSerialization framework, I should be able to insert serialized .Net objects.  (With the CLR(Common Language Runtime) integration into SQL Server, I might be able to do more, but I'm taking _baby steps_ here)

First, I downloaded "Visual Web Developer 2005 Express":http://lab.msdn.microsoft.com/express/vwd/default.aspx, which also came with .Net 2.0 and SQL Server 2005 Express.  

The management tools that come with SQL Server Express were command-line based, but Visual WebDev Express has sufficient tools.  Create a new Website, and then a new Database inside the Data folder (this will create an MDF file).  This will add a new connection to the Database Explorer.  From here you should be able to add tables/stored procedures, functions, etc.

Create a new Table with two columns.  One Primary Key, and one field with the XML datatype.  Now, we're ready to insert some data.

In the codebehind of a web page (it doesn't matter where, I put mine in the <code>OnInit</code> event), we'll start with a new connection.  For the Initial Catalog parameter, put the full path of the MDF file.  For the DataSource, the Named Pipes connection is <code>.\sqlexpress</code>.

<pre><code>
SqlConnection conn = new SqlConnection(@"Initial Catalog=c:\websites\website1\Data\Database.mdf;Data Source=.\sqlexpress;Integrated Security=SSPI;");
conn.Open();
SqlCommand com = conn.CreateCommand();
com.CommandText = "INSERT INTO XmlTable (XmlData) VALUES (@XmlData);";
com.Parameters.Add("@XmlData", SqlDbType.Xml);
</code></pre>

Now we will have to use the XmlSerializer class to serialize an object for the XML datatype.  For this example, I'm assuming you'll have your own class and object to serialize.

<pre><code>
XmlSerializer xs = new XmlSerializer(typeof(MyClass));
StringWriter sw = new StringWriter();
xs.Serialize(sw, MyObject);
</code></pre>

<pre><code>
StringReader sr = new StringReader(sw.ToString());
XmlReader xr = XmlReader.Create((TextReader) sr);
com.Parameters["@XmlData"].Value = xr;
</code></pre>

<pre><code>
com.ExecuteNonQuery();
conn.Close();
</code></pre>

Now, we've got XML data in the database.  I just have to figure out some useful queries.
