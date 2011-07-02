require 'spec_helper'

describe Hashtag do

  before(:each) do
    @attr = {:name => "#mhealth"}
  end

  it "should create a new instance given valid attributes" do
    Hashtag.create!(@attr)
  end

  describe "getting tweets" do

    before(:each)do
      hash = Hashtag.create(@attr)
    end

    it "should retrieve a tweet"
    end

