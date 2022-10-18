# frozen_string_literal: true

namespace :ridgepole do
  desc 'Apply database schema'
  task apply: :environment do
    apply(Rails.env)
    apply('test') if Rails.env.development?
    Rake::Task['annotate_models'].invoke if Rails.env.development?
  end

  private

  def apply(rails_env)
    ridgepole(
      '--apply',
      "-f #{schema_file}",
      "-E #{rails_env}",
      "-c #{config_file}",
      '--drop-table'
    )
  end

  def schema_file
    Rails.root.join('Schemafile')
  end

  def config_file
    Rails.root.join('config/database.yml')
  end

  def ridgepole(*options)
    command = ['bundle exec ridgepole']
    system([command + options].join(' '))
  end
end
