# frozen_string_literal: true

namespace :dev do
  desc 'Configuring the development environment'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Droping the database') { Rake::Task['db:drop'].invoke }
      show_spinner('Creating the database') { Rake::Task['db:create'].invoke }
      show_spinner('Migrating the database') { Rake::Task['db:migrate'].invoke }
      show_spinner('Adding the default admin') { Rake::Task['dev:add_default_admin'].invoke }
      show_spinner('Adding the default user') { Rake::Task['dev:add_default_user'].invoke }
    else
      puts 'This task is only available in development environment!'
    end
  end

  task add_default_admin: :environment do
    Admin.create!(
      email: "admin@admin.com",
      password: "123_456",
      password_confirmation: "123_456"
    )
  end

  task add_default_user: :environment do
    User.create!(
      email: "user@user.com",
      password: "123_456",
      password_confirmation: "123_456"
    )
  end

  private

  def show_spinner(msg_start, msg_end = 'Done!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
