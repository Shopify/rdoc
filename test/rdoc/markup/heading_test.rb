# frozen_string_literal: true
require_relative '../helper'

class RDocMarkupHeadingTest < RDoc::TestCase

  def setup
    super

    @h = RDoc::Markup::Heading.new 1, 'Hello *Friend*!'
  end

  def test_aref
    # GitHub-style: lowercase, spaces to hyphens, remove special chars, no label- prefix
    assert_equal 'hello-friend', @h.aref
  end

  def test_label
    # GitHub-style: lowercase, spaces to hyphens, remove special chars, no label- prefix
    assert_equal 'hello-friend', @h.label
    assert_equal 'hello-friend', @h.label(nil)

    context = RDoc::NormalClass.new 'Foo'

    assert_equal 'class-foo-hello-friend', @h.label(context)
  end

  def test_legacy_aref
    # Legacy style: label- prefix, original casing, + for spaces
    # Note: *Friend* markup is stripped, ! becomes %21 which becomes -21
    assert_equal 'label-Hello+Friend-21', @h.legacy_aref
  end

  def test_legacy_label
    # Legacy style without context
    assert_equal 'label-Hello+Friend-21', @h.legacy_label
    assert_equal 'label-Hello+Friend-21', @h.legacy_label(nil)

    # Legacy style with context - context should preserve original casing (class-Foo, not class-foo)
    context = RDoc::NormalClass.new 'Foo'
    assert_equal 'class-Foo-label-Hello+Friend-21', @h.legacy_label(context)
  end

  def test_legacy_label_preserves_context_casing
    # Verify that legacy_label uses legacy_aref for the context prefix (preserving original casing)
    # This is a regression test for a bug where legacy_label incorrectly lowercased the context prefix
    h = RDoc::Markup::Heading.new 1, 'Credits'
    context = RDoc::NormalModule.new 'RDoc'
    assert_equal 'module-RDoc-label-Credits', h.legacy_label(context)

    # Nested module example
    parent = RDoc::NormalModule.new 'Foo'
    context = RDoc::NormalClass.new 'Bar'
    context.parent = parent
    assert_equal 'class-Foo::Bar-label-Credits', h.legacy_label(context)
  end

  def test_plain_html
    assert_equal 'Hello <strong>Friend</strong>!', @h.plain_html
  end

  def test_plain_html_using_image_alt_as_text
    h = RDoc::Markup::Heading.new 1, 'rdoc-image:foo.png:Hello World'

    assert_equal 'Hello World', h.plain_html
  end
end
