class FakeUkttHttp
  def initialize(connection, service, version, format); end

  def self.build(host, version, format); end

  def retrieve(resource, _query_config = {})
    json = read(resource)

    JSON.parse(json)
  end

  def config
    {}
  end

  private

  def read(fixture)
    fixture_path = "#{::Rails.root}/spec/fixtures"
    path = File.join(fixture_path, fixture)

    File.read(path)
  end
end
