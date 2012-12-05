GUID Convertion Tool Website
============================
A simple website to convert GUIDs between different representations: integer, hexadecimal, and base64. The site is available at the following URL:

 * http://guid-convert.appspot.com/

Downloadable Version
--------------------
A downloadable version of this program can be easily installed. If you have Python, simply run:

```bash
pip install guid-tool
```

You can then run the tool:

```bash
guid-tool [GUID]
```

Public API
----------
A public API is available. An HTTP POST can be sent to either create a new GUID or convert one to multiple formats:

```bash
curl -d "" http://guid-convert.appspot.com/new
curl -d "guid=..." http://guid-convert.appspot.com/query
```
