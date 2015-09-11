# Learn more: http://github.com/javan/whenever

every 10.minutes do
  rake "fetch", :environment => "development"
end

every 1.day, at: "11:20 pm" do
  rake "dump:all", :environment => "development"
  rake "predict:all", :environment => "development"
end
