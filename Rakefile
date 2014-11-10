#!/usr/bin/env rake

require 'foodcritic'

desc 'Runs foodcritic linter'
task :foodcritic do
  files = Dir.glob('./cookbooks/**/*.rb')

  files.each do |file|
    puts "Checking #{file}"
    review, status = FoodCritic::Linter.new.check({'cookbook_paths' => file})
    printer = FoodCritic::SummaryOutput.new
    printer.output(review)
  end

end


desc 'Runs Ruby syntax check'
task :syntax do
  files = Dir.glob('./**/*.rb')

  files.each do |file|
    puts "Checking #{file}"
    catch :dont_execute_anything do
      eval("throw :dont_execute_anything\n" + File.read(file), nil, file, 0)
    end
  end

end

task :default => 'syntax'
