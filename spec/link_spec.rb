require 'link'

describe Link do
  describe '.all' do
    it 'returns all links' do
      links = Link.all
      urls = links.map(&:url)
      expect(urls).to include("http://www.makersacademy.com")
      expect(urls).to include("http://www.google.com")
      expect(urls).to include("http://www.facebook.com")
    end
  end

  describe '.create' do
    it 'creates a new link' do
      Link.create(url: "http://www.testlink.com")
      expect(Link.all.last.url).to include("http://www.testlink.com")
    end
  end

  describe '.checkup' do
    it "checks user input" do
      expect(Link.checkup('www.foo.com')).to eq true
    end
  end
end
