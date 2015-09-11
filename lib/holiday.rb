require 'net/http'
require 'nokogiri'
require 'time'

module Holiday

  class Holiday
    def initialize(from, to)
      @from = from
      @to = to
    end

    def holiday?(time)
      @from <= time and time <= @to
    end
  end

  class Holidays
    def initialize(holidays)
      @holidays = holidays
    end

    def holiday?(time)
      @holidays.any? { |h| h.holiday?(time) }
    end
  end

  def self.query
    url = "http://telechargement.index-education.com/vacances.xml"

    uri = URI.parse(url)
    response = Net::HTTP.get(uri)

    Nokogiri::XML(response)
  end

  def self.parse(document)
    zone = "C"  # Paris

    holidays = document.xpath("//zone[@libelle=\"#{zone}\"]//vacances")

    h = holidays.map do |holiday|
      Holiday.new(Time.strptime(holiday["debut"], "%Y/%m/%d"), Time.strptime(holiday["fin"], "%Y/%m/%d"))
    end

    Holidays.new(h)
  end

  def self.holidays
    parse(query)
  end

end
