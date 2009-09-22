require 'test/test_helper'

class SlideTest < Test::Unit::TestCase
  def setup
    @old_root = Slide.slide_root
    Slide.slide_root = File.join(File.dirname(__FILE__), '..', 'fixtures', 'slides')
  end

  def test_to_html
    @slide = Slide.find(1)
    @expected = "<h1>This is a Test</h1>"
    assert_equal(@expected, @slide.to_html)
  end

  def test_to_html__with_code
    @slide = Slide.find(2)
    @expected = %{<div class="code-window"><div class="code"><div class="line"><span class="constant">This</span> <span class="ident">is</span> <span class="ident">a</span> <span class="constant">Test</span></div></div></div>}
    assert_equal(@expected, @slide.to_html)
  end

  def teardown
    Slide.slide_root = @old_root
  end
end
