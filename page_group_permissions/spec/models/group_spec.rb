require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  before(:each) do
    @group = Group.new
  end

  it "should be valid" do
    @group.should be_valid
  end
end
