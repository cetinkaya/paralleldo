# A simple ruby function to execute tasks in parallel through
# a number of threads.

# Copyright (C) 2013 Ahmet Cetinkaya

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "thread"

def parallel(n, args_arr, &blk)
  results = Array.new(args_arr.length, nil)
  results_access_mutex = Mutex.new
  
  job_index = 0
  job_index_access_mutex = Mutex.new
  
  threads = Array.new(n) {|i|
    Thread.new(i, args_arr.length, blk) do |thread_no, args_arr_len, blk|
      my_arg = nil
      my_index = -1
      while true
        job_index_access_mutex.synchronize do
          my_index = job_index
          job_index = job_index + 1
        end
        
        break if my_index >= args_arr_len 

        my_arg = args_arr[my_index]
                
        my_result = blk.call(thread_no, my_arg)
        results_access_mutex.synchronize do
          results[my_index] = my_result
        end
      end
    end
  }

  threads.each do |thread|
    thread.join
  end
  results
end


# Test code for calculating factorials of numbers 1 to 10
# in 5 threads
if __FILE__ == $0
  numbers = (1..10).to_a
  results = parallel(5, numbers) do |thread_no, number| 
    puts "Thread #{thread_no} is now calculating #{number}!"
    result = 1
    number.times do |i|
      result *= (i+1)
    end
    result
  end
  puts "Factorials of 1, 2, ... 10: #{results.join(", ")}"
end
