require 'rake'

# Dir[File.join(__dir__ , "tasks", "**", "*.rake")].each {|file| require file }

Rake.add_rakelib File.join(__dir__ , 'tasks')
