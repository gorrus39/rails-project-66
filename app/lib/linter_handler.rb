# frozen_string_literal: true

class LinterHandler
  def initialize(repository)
    @language = repository.language
    @repository_full_name = repository.full_name
  end

  def exec(dir_path)
    if @language.ruby?
      result_rubocop = rubocop_exec(dir_path)
      format_after_rubocop(result_rubocop)
    elsif @language.javascript?
      output_file_path = "#{dir_path}/eslint_result.json"
      `yarn eslint --no-config-lookup --format json --output-file #{output_file_path} #{dir_path}/**/*.js`
      sleep 1
      format_after_eslint(JSON.parse(File.read(output_file_path)))
    end
  end

  private

  def rubocop_exec(dir_path)
    rubocop_config_file = Rails.root.join('.rubocop.yml')
    # JSON.parse(`cd #{Rails.root} && \
    #                           bundle exec rubocop \
    #                           --format json \
    #                           --config #{rubocop_config_file} \
    #                           #{dir_path}/**/*.rb`)

    command = "cd #{Rails.root} && bundle exec rubocop --format json --config #{rubocop_config_file} #{dir_path}/**/*.rb"
    Rails.logger.debug { "Executing command: #{command}" }
    result_rubocop = JSON.parse(`#{command}`)
    Rails.logger.debug { "RuboCop result: #{result_rubocop.inspect}" }
    result_rubocop
  end

  def format_after_rubocop(json)
    files = json['files'].map do |file|
      offenses = map_rubocop_offenses(file['offenses'])
      { file_path: make_file_path_from_rubocop(file['path']), offenses: }
    end
    files.filter! { |file| file[:offenses].count.positive? }
    { files:, offense_count: json['summary']['offense_count'] }
  end

  def make_file_path_from_rubocop(file_path)
    format_file_path = file_path.split('/')[2..].join('/')
    "https://github.com/#{@repository_full_name}/#{format_file_path}"
  end

  def make_file_path_from_eslint(absolute_file_path)
    file_path = absolute_file_path.split('/')
    index = file_path.index('clone_app')

    file_path.slice((index + 2)..).join('/')
    # "https://github.com/#{@repository_full_name}/#{file_path.slice((index + 2)..).join('/')}"
  end

  def map_rubocop_offenses(offenses)
    offenses.map do |offense|
      {
        message: offense['message'],
        rule: offense['cop_name'],
        position: "#{offense['location']['line']}:#{offense['location']['column']}"
      }
    end
  end

  def format_after_eslint(json)
    offense_count = 0
    files = json.map do |file|
      offenses = file['messages'].map do |message|
        offense_count += 1
        { message: message['message'], rule: message['ruleId'], position: "#{message['line']}:#{message['column']}" }
      end
      { file_path: make_file_path_from_eslint(file['filePath']), offenses: }
    end
    { files:, offense_count: }
  end
end
