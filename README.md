[![Actions Status](https://github.com/tovarish39/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/tovarish39/rails-project-66/actions)
![local tests and linter](https://github.com/tovarish39/rails-project-66/actions/workflows/rubyonrails.yml/badge.svg)

# Проект "Анализатор качества репозиториев"
Проект отображает результат работы линтеров для своих публичных репозиториев. Возможные репозитории для анализа - репозитории, у которых github определил основной язык  - ruby или javascript. Для просмотра результата репозитория необходимо залогинниться через github и выбрать из списка желаемый для анализа свой репозиторий. Так же при добавлении репозитория, для отслеживания качество его кода, устанавливается вебхук, для автоматической проверки репозитория, при добавлении нового коммита на "push" event. 

## Проект работает по [ссылке]()
## Проект-образец работает по [ссылке](https://rails-github-quality-ru.hexlet.app)


## Технические условия и требования к проекту
- ruby -v => 3.2.2
- rails -v => 7.1.3
- ngrok для development окружения, чтоб работали хуки 
- CI - git actions - тестирование, линтеры rubocop, slim.
- CD - Render(auto-deploy)
- использование шаблонизатора slim 
- аутентификация через github
- bootstrap
- все текстовые выводы выполнены через технологию i18n
- postgres для production среды

# запуск проекта в режиме development
    make install

заполнить в файле .env
- GITHUB_CLIENT_ID=
- GITHUB_CLIENT_SECRET=


  (опционально)
  для установки вебхуков на репозитории
  необходимо запустить ngrok http 3000
  заполнить в файле .env результат публичного адреса работы ngrok
- BASE_URL=


      rails s