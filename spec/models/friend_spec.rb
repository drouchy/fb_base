require 'spec_helper'

describe Friend do
  describe 'unpack json' do
    before do
      @friends_json = JsonMock.mock_for_friends
    end

    it 'should unpack the json from FB to friends' do
      friends = Friend.unpack(@friends_json)

      friends.size.should == 3
    end

    it 'should parse the friend id' do
      friends = Friend.unpack(@friends_json)

      friends.first.id.should == 1234
    end

    it 'should parse the friend name' do
      friends = Friend.unpack(@friends_json)

      friends.first.name.should == "Friend 1"
    end
  end
end