require File.dirname(__FILE__) + '/../test_helper'
require 'slide_controller'

# Re-raise errors caught by the controller.
class SlideController; def rescue_action(e) raise e end; end

class SlideControllerTest < Test::Unit::TestCase
  def setup
    @controller = SlideController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
