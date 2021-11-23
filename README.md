# README

To create a Rails API app:

```shell
  rails new appapi d --mysql -T --api
  rails db:create
  rails db:migrate
```

To install all the test gems inside the **Gemfile**:

```shell
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
```

After that, run on the command line:
```shell
  rails generate rspec:install
```

To test specs, we need to run:

```shell
bundle exec rspec
```

### SHOULDA-MATCHERS CONFIGURATION

After this, we need to open the **rails_helper** file (put the following code after line 9 -Rails 6-):

```ruby
  # app/spec/rails_helper.rb
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      # Choose a test framework:
      with.test_framework :rspec
      # Choose one or more libraries:
      with.library :active_record
      with.library :active_model
      with.library :action_controller
      # Or, choose all of the above:
      with.library :rails
    end
  end
```

### DATABASE-CLEANER CONFIGURATION

Inside the **rails_helper** we also have to add the following code inside the Rspec Configure (line 46 -Rails 6-):

```ruby
  # app/spec/rails_helper.rb
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example| # Example refers to each spec created
    DatabaseCleaner.cleaning do
      example.run
    end
  end
```

### FACTORY-BOT CONFIGURATION

Inside the **rails_helper** we also have to add the following code inside the Rspec Configure (line 46 -Rails 6-):

```ruby
  config.include FactoryBot::Syntax::Methods
```

### PRINT TEST LINES ARE RUNNING ON TESTS CONFIGURATION

```ruby
  ### app/spec/spec_helper
  config.color = true
  config.tty = true
  config.formatter = :documentation
```

### START WITH TESTS

```shell
  mkdir spec/requests
  mkdir spec/models
  touch spec/requests/health_spec.rb
```

### CREATE A SERIALIZER FOR A MODELS

```ruby
## On Gemfile
  gem 'active_model_serializers', '~> 0.10.12'
```

After that, we can generate the serializer to our models. We will create with the following command, a folder inside
the app folder where will be allocated our serializers.

```shell
  rails g serializer post
```

Inside the **Post** model serialzer, we need to add the following fields:

```ruby
  ## app/serializers/post_serializer.rb
  
  class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :published, :author

    def author
      user = self.object.user
      {
        name: user.name,
        email: user.email,
        id: user.id 
      }
    end
  end
```

### CREATE MODELS

```shell
  rails g model User email:string name:string auth_token:string
```

### TO ENABLE CACHE ON RAILS APP

Create the **Rails.cache.fetch** to create new Cache object.
```ruby
    def self.search(filtered_posts, search)
      posts_list = Rails.cache.fetch("posts_search/#{query}", expires_in: 1.hours) do
        filtered_posts.where("title like '%#{search}%'").map(&:id)
      end
      filtered_posts.where(id: posts_list)
    end
```

Change some lines on the environments which we will work:

```ruby
  # app/config/environments/development.rb
  # app/config/environments/test.rb
  config.cache_store = :null_store
  # TO
  config.cache_store = :memory_store
```

And to enable the caching to our app, we need to do the next on console:

```shell
  rails dev:cache
```

Testing on Rails Console:

```shell
  posts = FactoryBot.create_list(:post, 5, user_id: user_one.id)
  SearchPostsService.search(Post.all, "ut")
  # Post Load (0.3ms)  SELECT `posts`.* FROM `posts` WHERE (title like '%ut%')
  # Post Load (0.3ms)  SELECT `posts`.* FROM `posts` WHERE `posts`.`id` IN (4, 7, 9, 12, 1)
  SearchPostsService.search(Post.all, "ut")
  # Post Load (0.3ms)  SELECT `posts`.* FROM `posts` WHERE `posts`.`id` IN (4, 7, 9, 12, 1)
```


### GEMS GITHUB REPOSITORIES


[Rspec Rails](https://github.com/rspec/rspec-rails)

[FactoryBot Rails](https://github.com/thoughtbot/factory_bot_rails)

[Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner)

[Shoulda-Matchers](https://github.com/thoughtbot/shoulda-matchers)

[Faker](https://github.com/faker-ruby/faker)


### OTHER RELEVANT LINKS

[Null Store Cache](https://guides.rubyonrails.org/caching_with_rails.html#activesupport-cache-nullstore)

[Exceptions in Ruby](https://www.honeybadger.io/blog/a-beginner-s-guide-to-exceptions-in-ruby/)

[List of Rails Status Code Symbols](http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/)

