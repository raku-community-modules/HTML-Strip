use HTML::Entity::Fast:ver<0.0.5+>:auth<zef:lizmat>;

unit module HTML::Strip;

grammar HTML::Strip::Grammar {

    token TOP {
        (<comment_start> | <comment_end>
         | <closing_tag_start> | <tag_start>
         | <tag_quickend> | <tag_end>
         | <encoded_char> | <contents>)+
    }

    token tag_start {
        '<'
    }

    token closing_tag_start {
        '<' \s* '/'
    }

    token comment_start {
        '<' \s* '!' \s* '--'
    }

    token tag_quickend {
        '/' \s* '>'
    }

    token tag_end {
        '>'
    }

    token comment_end {
        '--' \s* '>'
    }

    token encoded_char {
        '&' '#'? \w+ ';'
    }

    token contents { . }
}

class HTML::Strip::Actions {

    has Str  $.out = "";
    has Bool $.emit_space is rw;
    has      @.strip_tags is rw;
    has Bool $.decode_entities is rw;

    has Bool $!inside_comment = False;
    has Bool $!ignore_contents = False;

    has Str  $!curr_tag = "";
    has Bool $!inside_tag = False;
    has Bool $!is_closing_tag = False;

    has Str  $!ignore_tag = "";


    method do_emit_space() {
        return if not $!out;

        $!out ~= q{ }
            if $!emit_space and $!out.comb[*-1] ne " ";
    }

    method tag_start($/) {
        $!inside_tag     = True;
        $!curr_tag       = "";
        $!is_closing_tag = False;
    }

    method tag_end($/) {
        $!curr_tag   = $!curr_tag.subst(/\s+ .* $/).subst(/^\s+/).lc;
        $!inside_tag = False;

        if $!ignore_contents and $!curr_tag ne $!ignore_tag {
            return;
        }

        my $strip_tag = ($!curr_tag eq any @!strip_tags).Bool;
        $!ignore_contents = $strip_tag;

        $!ignore_contents = False if $!is_closing_tag;

        $!ignore_tag = $!curr_tag if $!ignore_contents;

        self.do_emit_space() unless $strip_tag;
    }

    method tag_quickend($/) {
        $!inside_tag = False;
    }

    method comment_start($/) {
        $!inside_comment = True;
    }

    method comment_end($/) {
        $!inside_comment = False;
    }

    method contents($/) {
        #print $/;
        return if $!inside_comment;

        if $!inside_tag {
            $!curr_tag ~= $/;
            return;
        }
        return if $!ignore_contents;
        $!out ~= $/;
    }

    method closing_tag_start($/) {
        self.tag_start($/);
        $!is_closing_tag = True;
    }

    method encoded_char($/) {
        $!out ~= $!decode_entities
          ?? decode-html-entities($/.Str)
          !! $/;
    }
}

my constant @DEF_STRIP_TAGS = <title script style applet>;

my sub strip_html(
  Str:D   $html,
  Bool:D :$emit_space      = True,
  Bool:D :$decode_entities = True,
         :@strip_tags      = @DEF_STRIP_TAGS
) is export {

    my $actions := HTML::Strip::Actions.new(
      :$emit_space, :@strip_tags, :$decode_entities
    );

    HTML::Strip::Grammar.parse($html, :$actions);
    $actions.out
}

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

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
