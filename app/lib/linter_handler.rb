# frozen_string_literal: true

class LinterHandler
  def initialize(repository)
    @language = repository.language
    @repository_full_name = repository.full_name
  end

  def exec(dir_path)
    case @language
    when 'ruby'
      Linter::RubyCodeService.handle dir_path
    when 'javascript'
      Linter::JavascriptCodeService.handle dir_path
    else
      raise ArgumentError, "Unsupported language: #{@language}"
    end
  end
end
