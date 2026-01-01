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

  def test_plain_html
    assert_equal 'Hello <strong>Friend</strong>!', @h.plain_html
  end

  def test_plain_html_using_image_alt_as_text
    h = RDoc::Markup::Heading.new 1, 'rdoc-image:foo.png:Hello World'

    assert_equal 'Hello World', h.plain_html
  end
end
