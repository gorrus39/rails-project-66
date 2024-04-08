# frozen_string_literal: true

namespace :lint do
  desc 'slim linting'.yellow
  task slim: :environment do
    system 'bundle exec slim-lint'
  end

  desc 'rubocop linting'.yellow
  task rubocop: :environment do
    system 'bundle exec rubocop -a'
  end
end
