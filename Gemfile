source "https://rubygems.org"

git_source :github do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include? "/"
  "https://github.com/#{repo_name}.git"
end

gem "bcrypt", "~> 3.1.7"
gem "bootstrap-sass"
gem "carrierwave", "1.1.0"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "faker"
gem "i18n-js"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "mini_magick", "4.7.0"
gem "mysql2", "~> 0.3.18"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.2"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
