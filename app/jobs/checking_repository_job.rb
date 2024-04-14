class CheckingRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository, github_client)
    rep_check = repository.checks.new

    local_dir_path = Rails.root.join('tmp/clone_app/')
    latest_commit_sha = github_client.get_latest_commit_sha(repository.full_name)

    rep_check.commit_id = latest_commit_sha

    system("git clone #{repository.clone_url} #{local_dir_path}")

    # создаём check
    # получаем последний коммит, пишем в чек
    # клонируем реп, во временный адрес(check_id), чтоб потом удалить
    # делаем рубокоп
    # к каждому check прикреплён файл
  end
end

# require 'octokit'

# repo = 'rails/rails'
# local_path = '/путь/к/локальной/директории'

# client = Octokit::Client.new
# latest_commit_sha = client.commits(repo).first.sha

# git clone https://github.com/#{repo}.git #{local_path}
# Dir.chdir(local_path) do
#   git checkout #{latest_commit_sha}
# end

# puts "Репозиторий успешно склонирован в #{local_path}"
# puts "Хэш последнего коммита: #{latest_commit_sha}"
