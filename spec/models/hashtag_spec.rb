require 'spec_helper'

describe Hashtag do

  before(:each) do
    @attr = {:name => "#mhealth"}
    hash = Hashtag.create(@attr)
  end
