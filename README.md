# ai_error_clip

`ai_error_clip` is a small Rails plugin that replaces the default development
error page with an AI-friendly layout. The page gathers the request, parameters,
context, and the first ten lines of the backtrace into one screen with a single
button that copies the information for pasting into an AI assistant.

## Installation

Add the gem to your Rails application's `Gemfile`. When developing locally you
can use a `path:` reference:

```ruby
group :development do
  gem "ai_error_clip", path: "vendor/ai_error_clip"
end
```

Then install the dependencies inside your application (for example via Bundler):

```sh
bundle install
```

## Usage

Once the gem is loaded, it automatically attaches to `ActionController::Base`
in development mode. You do not need to change controller code manually.

When an exception occurs, Rails renders the gem's `Error Details` page instead
of the default stack trace. Use the **Copy details for AI** button to copy
everything required for a support conversation.

## Development

To modify the gem locally:

1. Adjust files under `lib/ai_error_clip` or `app/views/ai_error_clip`.
2. Run tests or manual checks in your Rails application.
3. Build the gem for distribution with:

   ```sh
   gem build ai_error_clip.gemspec
   ```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for
details.
