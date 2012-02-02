require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end

  describe 'retrieving likes' do
    before do
      @likes = [
        {
          "name" => "The Office",
          "category" => "Tv show",
          "id" => "6092929747",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Flight of the Conchords",
          "category" => "Tv show",
          "id" => "7585969235",
          "created_time" => "2010-08-22T06:33:56+0000"
        },
        {
          "name" => "Wildfire Interactive, Inc.",
          "category" => "Product/service",
          "id" => "36245452776",
          "created_time" => "2010-06-03T18:35:54+0000"
        },
        {
          "name" => "Facebook Platform",
          "category" => "Product/service",
          "id" => "19292868552",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Twitter",
          "category" => "Product/service",
          "id" => "20865246992",
          "created_time" => "2010-05-02T14:07:10+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'likes').once.and_return(@likes)
    end

    describe '#likes' do
      it 'should retrieve the likes via the graph api' do
        @user.likes.should == @likes
      end

      it 'should memoize the result after the first call' do
        likes1 = @user.likes
        likes2 = @user.likes
        likes2.should equal(likes1)
      end
    end

    describe '#likes_by_category' do
      it 'should group by category and sort categories and names' do
        @user.likes_by_category.should == [
          ["Product/service", [
            {
              "name" => "Facebook Platform",
              "category" => "Product/service",
              "id" => "19292868552",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Twitter",
              "category" => "Product/service",
              "id" => "20865246992",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Wildfire Interactive, Inc.",
              "category" => "Product/service",
              "id" => "36245452776",
              "created_time" => "2010-06-03T18:35:54+0000"
            }
          ]],
          ["Tv show", [
            {
              "name" => "Flight of the Conchords",
              "category" => "Tv show",
              "id" => "7585969235",
              "created_time" => "2010-08-22T06:33:56+0000"
            },
            {
              "name" => "The Office",
              "category" => "Tv show",
              "id" => "6092929747",
              "created_time" => "2010-05-02T14:07:10+0000"
            }
          ]]
        ]
      end
    end
  end

  describe 'retrieving friends' do
    before do
      @friends = [
         { 'id' => 1, 'name' => 'Friend 1' } ,
         { 'id' => 2, 'name' => 'A Friend' } ,
         { 'id' => 3, 'name' => 'Edouard' } ,
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)
    end

    describe '#friends' do
      it 'should retrieve the friends via the graph api' do
        @user.friends.should == @friends
      end

      it 'should memoize the result after the first call' do
        friends1 = @user.friends
        friends2 = @user.friends
        friends2.should equal(friends1)
      end
    end
  end

  describe 'ranking friends' do
    before do
      @wall = [
          {
            "comments" => {
              "data" =>[
                 {
                    "id" => "1313916041_3251080758583_4279193",
                    "from" => {
                       "name" => "F1",
                       "id" => "1313916041"
                    },
                    "message" => "....",
                    "created_time" => "2012-01-31T06:30:09+0000"
                 },
                 {
                    "id" => "1313916041_3251080758583_4279203",
                    "from" => {
                       "name" => "F2",
                       "id" => "1206550528"
                    },
                    "message" => "......",
                    "created_time" => "2012-01-31T06:33:36+0000"
                 }
              ],
              "count" => 2
           }
         } , {
            "comments" => {
              "data" =>[
                 {
                    "id" => "1313916041_3251080758583_4279193",
                    "from" => {
                       "name" => "F1",
                       "id" => "1313916041"
                    },
                    "message" => "....",
                    "created_time" => "2012-01-31T06:30:09+0000"
                 }
              ],
              "count" => 1
           }
         }
        ]
      @graph.should_receive(:get_connections).with(1, 'feed', {:limit => 100}).once.and_return(@wall)
      @ranking = @user.rank_friend(1)
    end

    it 'should add an entry for every member with a comment' do
      @ranking.keys.should =~ ['F1', 'F2']
    end

    it 'should count the number total of comments' do
      @ranking['F1'].should == 2
      @ranking['F2'].should == 1
    end

  end
end
