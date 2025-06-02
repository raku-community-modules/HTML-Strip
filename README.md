[![Actions Status](https://github.com/raku-community-modules/HTML-Strip/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/HTML-Strip/actions) [![Actions Status](https://github.com/raku-community-modules/HTML-Strip/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/HTML-Strip/actions) [![Actions Status](https://github.com/raku-community-modules/HTML-Strip/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/HTML-Strip/actions)

NAME
====

HTML::Strip - Strip HTML markup from text.

SYNOPSIS
========

```raku
use HTML::Strip;
my $html = q{<body>my <a href="http://">raku module</a></body>};
my $clean = html_strip($html);
# $clean: my raku module
```

DESCRIPTION
===========

HTML::Strip removes HTML tags and comments from given text.

This module is inspired by the Perl module HTML::Strip and provides the same functionality. However, both its interface and implementation differs. This module is implemented using Raku grammars.

Note that this module does no XML/HTML validation. Garbage in might give you garbage out.

`strip_html(Str)`
-----------------

Removes HTML tags and comments from given text.

This module will also decode HTML encoded text. For example &lt; will become < .

### `:emit_space`

By default all tags are replaced by space. Set this optional parameter to False if you want them to be replaced by nothing.

### `:decode_entities`

By default HTML entities will be decoded. For example &lt; becomes <

Set this to false if you do not want this.

AUTHORS
=======

  * Dagur Valberg Johannsson

  * Raku Community

COPYRIGHT AND LICENSE
=====================

Copyright 2013 - 2017 Dagur Valberg Johannsson.

Copyright 2024 - 2025 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

