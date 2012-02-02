require 'spec_helper'

describe FacebookHelper do

  describe '#options_from_friends' do
    before do
      @friends = [ {'id' => 1 , 'name' => 'F1'}, {'id' => 2, 'name' => 'A1'}, {'id' => 3, 'name' => 'E1'}]
    end

    it 'should put the id as the option value' do
      options = helper.options_from_friends(@friends)

      options.map{ |option| option.last}.should =~ [1,2,3]
    end

    it 'should put the name as the option text' do
      options = helper.options_from_friends(@friends)

      options.map{ |option| option.first}.should =~ ['F1', 'A1', 'E1']
    end

    it 'should order per friend name' do
      options = helper.options_from_friends(@friends)

      options.first.first.should == 'A1'
      options.second.first.should == 'E1'
      options.third.first.should == 'F1'
    end
  end
end