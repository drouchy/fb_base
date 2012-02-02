class Friend

  attr_reader :id
  attr_reader :name

  def initialize(args = {})
    @id = args[:id]
    @name = args[:name]
  end

  def self.unpack(json)
    JSON.parse(json)['data'].map { |friend| Friend.new(:id => friend["id"].to_i , :name => friend['name'])}
  end
end