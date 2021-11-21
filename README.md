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
