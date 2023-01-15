require 'fileutils'

require_relative '../template'

module LightningApi
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Init < Dry::CLI::Command
        desc 'Create a new API respository'

        argument :name, required: true, desc: 'Project name'
        argument :dir, desc: 'Project directory. Same as project name if not specified'
        argument :port, desc: 'API port'

        @@mutex = Mutex.new

        def call(name:, dir: nil, port: 5550)
          @@mutex.synchronize do
            dir ||= name
            template = CLI::Template.new

            if Dir.exist?(dir)
              $stdout.puts "Project #{dir} already exists"
              exit
            end

            FileUtils.mkdir_p(dir)
            FileUtils.cd(dir) do |wd|
              template.write('Gemfile', file_dir: '.', content: template.read('gemfile'))
              template.write('README.md', file_dir: '.', content: template.read('readme'),
                                          app_name: name)
              template.write('LICENSE.txt', file_dir: '.', content: template.read('mit_license'),
                                            app_name: name)
              template.write('CODE_OF_CONDUCT.md', file_dir: '.',
                                                   content: template.read('code_of_conduct'))
              template.write('Guardfile', file_dir: '.', content: template.read('guardfile'),
                                          app_name: name, port:)
              template.write('pagy.rb', file_dir: '.', content: template.read('pagy'))
              template.write('Rakefile', file_dir: '.', content: template.read('rakefile'))
              template.write('config.ru', file_dir: '.', content: template.read('config_ru'),
                                          app_name: name)
              template.write('Dockerfile', file_dir: '.', content: template.read('dockerfile'),
                                           app_dir: wd)
              template.write('docker-compose.yml', file_dir: '.',
                                                   content: template.read('docker-compose'), app_name: name, app_dir: wd, port:)
              template.write('.gitignore', file_dir: '.', content: template.read('dot_gitignore'))
              template.write('.dockerignore', file_dir: '.',
                                              content: template.read('dot_dockerignore'))
              template.write('.reek.yml', file_dir: '.', content: template.read('dot_reek'))

              app_dir = 'app'
              FileUtils.mkdir_p(app_dir)
              FileUtils.cd(app_dir) do |_wd|
                template.write('app.rb', file_dir: '.', content: template.read('app'),
                                         app_name: name)

                home_dir = 'actions/home'
                FileUtils.mkdir_p(home_dir)
                FileUtils.cd(home_dir) do |_wd|
                  template.write('show.rb', file_dir: '.', content: template.read('home_show'),
                                            app_name: name)
                end
              end

              bin_dir = 'bin'
              FileUtils.mkdir_p(bin_dir)
              FileUtils.cd(bin_dir) do |_wd|
                unless File.exist?('setup')
                  template.write('setup', file_dir: '.',
                                          content: template.read('bin_setup'))
                end
                FileUtils.chmod('u=rx,g=rx', 'setup')

                unless File.exist?('server')
                  template.write('server', file_dir: '.',
                                           content: template.read('bin_server'))
                end
                FileUtils.chmod('u=rx,g=rx', 'server')
              end

              config_dir = 'config'
              FileUtils.mkdir_p(config_dir)
              FileUtils.mkdir_p(config_dir) do |_wd|
                template.write('database.rb', file_dir: '.',
                                              content: template.read('config_database'))
              end

              FileUtils.mkdir_p('db/migrations')

              system('bundle exec rspec --init')
              system('bundle exec rubocop --init')
            end
          end
        end
      end

      register 'new', Init
    end
  end
end

Dry::CLI.new(LightningApi::CLI::Commands).call
