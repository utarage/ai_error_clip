require_relative "lib/ai_error_clip/version"

Gem::Specification.new do |spec|
  spec.name = "ai_error_clip"
  spec.version = AiErrorClip::VERSION
  spec.authors = ["utarage"]
  spec.summary = "AI-friendly Rails development error page with one-click copy"
  spec.description = "ai_error_clip replaces the Rails development exception page with an AI-focused layout that gathers request details, parameters, context, and a short backtrace in one place."
  spec.license = "MIT"
  spec.homepage = "https://www.utaroyano.com/"
  spec.required_ruby_version = ">= 3.3.6"
  spec.files = Dir["lib/**/*", "app/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end
