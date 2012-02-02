class FileMock

  @@root_path = File.join(Rails.root, 'spec', 'fixtures')

  def self.method_missing(method)
    if method.to_s =~ /mock_for_(.*)/
      filename = "#{$1}.#{ext}"
      if File.exist?(file_path(filename))
        return mock_for("#{filename}")
      else
        raise Exception.new("#{$1} fixture not found")
      end
    end
    super.method_missing(method, args, block)
  end

  def self.mock_for(filename)
    xml = open(file_path(filename), 'r')

    xml.readlines.join
  end

private
  def self.file_path(filename)
    File.join(@@root_path, filename)
  end
end

class JsonMock < FileMock
  def self.ext
    :json
  end
end


class XmlMock < FileMock
  def self.ext
    :xml
  end
end