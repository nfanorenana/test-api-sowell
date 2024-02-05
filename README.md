Boenvenue sur le test 
Pour installer ruby et son environement:

https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-22-04

- Après clone du projet
- Supprimer le fichier Gemfile.lock
- Lancer bundle install
- Lancé rails db:setup
prendre un ticket 
# SoWell API V2
## Rails coding rules
[Source](https://github.com/thoughtbot/guides/tree/main/rails)

- Avoid `member` and `collection` routes.
- Use private instead of protected when defining controller methods.
- Name date columns with `_on` suffixes.
- Name datetime columns with `_at` suffixes.
- Name time columns (referring to a time of day with no date) with `_time`
  suffixes.
- Name initializers for their gem name.
- Order ActiveRecord associations alphabetically by association type, then
  attribute name. [Example](/rails/sample.rb#L2-L4).
- Order ActiveRecord validations alphabetically by attribute name.
- Order ActiveRecord associations above ActiveRecord validations.
- Order controller contents: filters, public methods, private methods.
- Order i18n translations alphabetically by key name.
- Order model contents: constants, macros, public methods, private methods.
- Use `def self.method`, not the `scope :method` DSL.
- Use new-style `validates :name, presence: true` validations, and put all
  validations for a given column together. [Example](/rails/sample.rb#L6).
- Avoid bypassing validations with methods like `save(validate: false)`,
  `update_attribute`, and `toggle`.
- Avoid instantiating more than one object in controllers.
- Avoid naming methods after database columns in the same class.
- Don't reference a model class directly from a view.
- Don't return false from `ActiveModel` callbacks, but instead raise an
  exception.
- Don't use SQL or SQL fragments (`where('inviter_id IS NOT NULL')`) outside of
  models.
- Keep `db/schema.rb` or `db/development_structure.sql` under version control.
- Use the [`.ruby-version`] file convention to specify the Ruby version and
  patch level for a project.
- Use `_url` suffixes for named routes in mailer views and [redirects]. Use
  `_path` suffixes for named routes everywhere else.
- Validate the associated `belongs_to` object (`user`), not the database column
  (`user_id`).
- Use `db/seeds.rb` for data that is required in all environments.
- Use `dev:prime` rake task for development environment seed data.
- Prefer `Time.current` over `Time.now`
- Prefer `Date.current` over `Date.today`
- Prefer `Time.zone.parse("2014-07-04 16:05:37")` over `Time.parse("2014-07-04
  16:05:37")`
- Use `ENV.fetch` for environment variables instead of `ENV[]`so that unset
  environment variables are detected on deploy.
- [Use blocks](/ruby/sample_2.rb#L10) when declaring date and time attributes in
  FactoryBot factories.
- Use `touch: true` when declaring `belongs_to` relationships.

[`.ruby-version`]: https://gist.github.com/fnichol/1912050
[redirects]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.30
[prevent tampering]: http://blog.bigbinary.com/2013/03/19/cookies-on-rails.html

## Migrations

[Sample](migration.rb)

- Set an empty string as the default constraint for non-required string and text
  fields. [Example](migration.rb#L6).
- Set an explicit [`on_delete` behavior for foreign keys].
- Don't change a migration after it has been merged into `main` if the desired
  change can be solved with another migration.
- If there are default values, set them in migrations.
- Use SQL, not `ActiveRecord` models, in migrations.
- [Add foreign key constraints] in migrations.

[`on_delete` behavior for foreign keys]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_foreign_key
[add foreign key constraints]: http://robots.thoughtbot.com/referential-integrity-with-foreign-keys

## Routes

- Avoid the `:except` option in routes.
- Order resourceful routes alphabetically by name.
- Use the `:only` option to explicitly state exposed routes.

## Background Jobs

- Define a `PRIORITY` constant at the top of delayed job classes.
- Define two public methods: `self.enqueue` and `perform`.
- Put delayed job classes in `app/jobs`.

## Code Review

Follow the normal [Code Review guidelines](/code-review/). When reviewing
others' Rails work, look in particular for:

- Review data integrity closely, such as migrations that make irreversible
  changes to the data, and whether there is a related todo to make a database
  backup during the staging and production deploys.
- Review SQL queries for potential SQL injection.
- Review whether dependency upgrades include a reason in the commit message,
  such as a link to the dependency's `ChangeLog` or `NEWS` file.
- Review whether new database indexes are necessary if new columns or SQL
  queries were added.
- Review whether new scheduler (`cron`) tasks have been added and whether there
  is a related todo in the project management system to add it during the
  staging and production deploys.

## Asset Management

- Use [ActiveStorage] to manage file uploads that live on ActiveRecord objects.
- Don't use live storage backends like S3 or Azure in tests.

[ActiveStorage]: https://guides.rubyonrails.org/active_storage_overview.html

## How to...

- [Start a New Rails App](./how-to/start_a_new_rails_app.md)
- [Deploy a Rails App to Heroku](./how-to/deploy_a_rails_app_to_heroku.md)

# Ruby coding rules
[Source](https://github.com/thoughtbot/guides/blob/main/ruby/README.md)

- Use [standard]
- Avoid conditional modifiers (lines that end with conditionals). [36491dbb9]
- Avoid multiple assignments per line (`one, two = 1, 2`). [#109]
- Avoid organizational comments (`# Validations`). [#63]
- Avoid ternary operators (`boolean ? true : false`). Use multi-line `if`
  instead to emphasize code branches. [36491dbb9]
- Avoid bang (!) method names. Prefer descriptive names. [#122]
- Name variables created by a factory after the factory (`user_factory` creates
  `user`).
- Prefer nested class and module definitions over the shorthand version
  [Example](/ruby/sample_1.rb#L103) [#332]
- Prefer `detect` over `find`. [0d819844]
- Prefer `select` over `find_all`. [0d819844]
- Prefer `map` over `collect`. [0d819844]
- Prefer `reduce` over `inject`. [#237]
- Prefer `&:method_name` to `{ |item| item.method_name }` for simple method
  calls. [#183]
- Use `_` for unused block parameters. [0d819844]
- Prefix unused variables or parameters with underscore (`_`). [#335]
- Suffix variables holding a factory with `_factory` (`user_factory`).
- Use a leading underscore when defining instance variables for memoization.
  [#373]
- Use `%()` for single-line strings containing double-quotes that require
  interpolation. [36491dbb9]
- Use `?` suffix for predicate methods. [0d819844]
- Use `def self.method`, not `class << self`. [40090e22]
- Use `def` with parentheses when there are arguments. [36491dbb9]
- Use heredocs for multi-line strings. [36491dbb9]
- Order class methods above instance methods. [#320]
- Prefer method invocation over instance variables. [#331]
- Avoid optional parameters. Does the method do too much?
- Avoid monkey-patching.
- Generate necessary [Bundler binstubs] for the project, such as `rake` and
  `rspec`, and add them to version control.
- Prefer classes to modules when designing functionality that is shared by
  multiple models.
- Prefer `private` when indicating scope. Use `protected` only with comparison
  methods like `def ==(other)`, `def <(other)`, and `def >(other)`.

[standard]: https://github.com/testdouble/standard
[#63]: https://github.com/thoughtbot/guides/pull/63
[#109]: https://github.com/thoughtbot/guides/pull/109
[#122]: https://github.com/thoughtbot/guides/pull/122
[#183]: https://github.com/thoughtbot/guides/pull/183
[#237]: https://github.com/thoughtbot/guides/pull/237
[#320]: https://github.com/thoughtbot/guides/pull/320
[#331]: https://github.com/thoughtbot/guides/pull/331
[#332]: https://github.com/thoughtbot/guides/pull/332
[#335]: https://github.com/thoughtbot/guides/pull/335
[#373]: https://github.com/thoughtbot/guides/pull/373
[0d819844]: https://github.com/thoughtbot/guides/commit/0d819844
[36491dbb9]: https://github.com/thoughtbot/guides/commit/36491dbb9
[40090e22]: https://github.com/thoughtbot/guides/commit/40090e22
[bundler binstubs]: https://github.com/sstephenson/rbenv/wiki/Understanding-binstubs

## Bundler

- Specify the [Ruby version] to be used on the project in the `Gemfile`.
- Use a [pessimistic version] in the `Gemfile` for gems that follow semantic
  versioning, such as `rspec`, `factory_bot`, and `capybara`.
- Use a [versionless] `Gemfile` declarations for gems that are safe to update
  often, such as pg, thin, and debugger.
- Use an [exact version] in the `Gemfile` for fragile gems, such as Rails.

[ruby version]: http://bundler.io/v1.3/gemfile_ruby.html
[exact version]: http://robots.thoughtbot.com/post/35717411108/a-healthy-bundle
[pessimistic version]: http://robots.thoughtbot.com/post/35717411108/a-healthy-bundle
[versionless]: http://robots.thoughtbot.com/post/35717411108/a-healthy-bundle

## Ruby Gems

- Declare dependencies in the `<PROJECT_NAME>.gemspec` file.
- Reference the `gemspec` in the `Gemfile`.
- Use [Appraisal] to test the gem against multiple versions of gem dependencies
  (such as Rails in a Rails engine).
- Use [Bundler] to manage the gem's dependencies.
- Use continuous integration (CI) to show build status within the code review
  process and to test against multiple Ruby versions.

[appraisal]: https://github.com/thoughtbot/appraisal
[bundler]: http://bundler.io
