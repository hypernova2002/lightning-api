# frozen_string_literal: true

Rake.add_rakelib 'lib/lightning-api/tasks'

task :code_analysis do
  sh 'bundle exec rubocop lib spec'
  sh 'bundle exec reek lib'
end
