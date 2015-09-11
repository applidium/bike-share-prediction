require './lib/dump'

namespace :dump do
  desc "Dump station with ID given as an environment variable"
  task :station => :environment do
    dump = Dump.new(60)
    dump.station(Station.find_by(id: ENV['ID']))
  end

  desc "Dump all stations"
  task :all => :environment do
    puts "Dumping all stations..."

    stations = Station.all
    dump = Dump.new(60)
    stations.each { |st| dump.station(st) }

    puts "Dumped all stations."
  end
end
