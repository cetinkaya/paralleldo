# -*- coding: utf-8 -*-
require_relative "paralleldo"
require "open-uri"

days = (1..31).to_a
results = parallel(5, days) do |thread_no, day|
  url = "http://en.wikipedia.org/wiki/October_#{day}"

  # If wikipedia article in -url- mentions an event
  # for the day October -day-, 2000, return a string
  # which represents that event

  text = open(url).read
  pos = text.index("/wiki/2000")
  if pos
    # Event mentioned in Wikipedia without html tags
    text[text.index(" – ", pos)..
         text.index("</li>", pos)-1].gsub(" – ", "").gsub(/<[^>]+>/, "")
  end
end

puts "Events mentioned in Wikipedia: "
results.each.with_index do |event, index|
  day = days[index]

  if event
    puts "October #{day}, 2000: #{event}"
  end
end
