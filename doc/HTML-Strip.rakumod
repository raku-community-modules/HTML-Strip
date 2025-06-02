=begin pod

=head1 NAME

HTML::Strip - Strip HTML markup from text.

=head1 SYNOPSIS

=begin code :lang<raku>

use HTML::Strip;
my $html = q{<body>my <a href="http://">raku module</a></body>};
my $clean = html_strip($html);
# $clean: my raku module

=end code

=head1 DESCRIPTION

HTML::Strip removes HTML tags and comments from given text.

This module is inspired by the Perl module HTML::Strip and provides
the same functionality. However, both its interface and implementation
differs. This module is implemented using Raku grammars.

Note that this module does no XML/HTML validation. Garbage in might
give you garbage out.

=head2 C<strip_html(Str)>

Removes HTML tags and comments from given text.

This module will also decode HTML encoded text. For example &lt; will become < .

=head3 C<:emit_space>

By default all tags are replaced by space. Set this optional parameter to
False if you want them to be replaced by nothing.

=head3 C<:decode_entities>

By default HTML entities will be decoded. For example &lt; becomes <

Set this to false if you do not want this.

=head1 AUTHORS

=item Dagur Valberg Johannsson
=item Raku Community

=head1 COPYRIGHT AND LICENSE

Copyright 2013 - 2017 Dagur Valberg Johannsson.

Copyright 2024 - 2025 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
