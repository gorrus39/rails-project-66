[![Actions Status](https://github.com/tovarish39/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/tovarish39/rails-project-66/actions)
![local tests and linter](https://github.com/tovarish39/rails-project-66/actions/workflows/rubyonrails.yml/badge.svg)

# Project "Repository Quality Analyzer"
The project displays the output of linters for its public repositories. Possible repositories for analysis are repositories for which github has determined the main language - ruby ​​or javascript. To view the result of the repository, you need to log in via github and select your repository from the list that you want to analyze. Also, when adding a repository, to monitor the quality of its code, a webhook is installed to automatically check the repository when adding a new commit to a “push” event.

## The project works on the  [ссылке](https://rails-project-66-p2vh.onrender.com/)
## The sample project works at the [ссылке](https://rails-github-quality-ru.hexlet.app)

## Technical specifications and requirements for the project
- ruby ​​-v => 3.2.2
- rails -v => 7.1.3
- ngrok for development environment so that hooks work
- CI - git actions - testing, linters rubocop, slim.
- CD - Render(auto-deploy)
- use of the slim template engine
- authentication via github
- bootstrap
- all text outputs are made via i18n technology
- postgres for production environment

# launching the project in development mode
    make install

fill in the .env file

- GITHUB_CLIENT_ID=
- GITHUB_CLIENT_SECRET=

  (optional)
  to install webhooks on the repository
  you need to run ngrok http 3000
  fill in the .env file with the result of the public address of ngrok's work
- BASE_URL=


      rails s