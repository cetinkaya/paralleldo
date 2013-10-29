paralleldo
==========

Paralleldo provides a simple ruby function named "parallel" to execute tasks in parallel (?) through a number of threads. (? : Execution may or may not be actually in parallel depending on the type of threads in the ruby implementation you use.)


Usage
-----

```
require_relative "paralleldo"
array_of_results = parallel(number_of_threads, array_of_things) do |thread_no, thing|
  # do stuff with thing in thread numbered thread_no
  # return a result 
end
```

Example
-------

Suppose we want to list some events that happened in October 2000. We can get a list of events from Wikipedia page http://en.wikipedia.org/wiki/October_2000 or we can compile events ourselves from pages http://en.wikipedia.org/wiki/October_1 , http://en.wikipedia.org/wiki/October_2 , ...

Let's follow the second approach where we access 31 wikipedia pages corresponding to each day of October. (It seems like we can get more events that way.) Below is a code to do this with 5 threads using paralleldo. 

```ruby
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
```

