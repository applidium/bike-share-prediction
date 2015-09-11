class DateTime
  # http://stackoverflow.com/questions/15414831/ruby-determine-season-fall-winter-spring-or-summer#answer-15416170
  def season
    day_hash = month * 100 + mday
    case day_hash
      when 101..401 then :winter
      when 402..630 then :spring
      when 701..930 then :summer
      when 1001..1231 then :fall
    end
  end

  def week
    strftime("%U").to_i
  end

  def season_mapping
    mapping = {
      :winter => 0, :spring => 1, :summer => 2, :fall => 3
    }

    mapping[self.season] || mapping.values.max + 1
  end
end
