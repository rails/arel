# frozen_string_literal: true
$:.push File.expand_path("../lib", __FILE__)
require "arel"

Gem::Specification.new do |s|
  s.name        = "arel"
  s.version     = Arel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aaron Patterson", "Bryan Helmkamp", "Emilio Tagua", "Nick Kallen"]
  s.email       = ["aaron@tenderlovemaking.com", "bryan@brynary.com", "miloops@gmail.com"]
  s.homepage    = "https://github.com/rails/arel"
  s.description = "Arel Really Exasperates Logicians\n\nArel is a SQL AST manager for Ruby. It\n\n1. Simplifies the generation of complex SQL queries\n2. Adapts to various RDBMSes\n\nIt is intended to be a framework framework; that is, you can build your own ORM\nwith it, focusing on innovative object and collection modeling as opposed to\ndatabase compatibility and query generation."
  s.summary     = "Arel Really Exasperates Logicians  Arel is a SQL AST manager for Ruby"
  s.license     = %q{MIT}
  s.required_ruby_version = ">= 2.2.2"

  s.rdoc_options = ["--main", "README.md"]
  s.extra_rdoc_files = ["History.txt", "MIT-LICENSE.txt", "README.md"]

  s.files = Dir["History.txt", "MIT-LICENSE.txt", "README.md", "lib/**/*"]
  s.require_paths = ["lib"]

  s.add_development_dependency('minitest', '~> 5.4')
  s.add_development_dependency('rdoc', '~> 4.0')
  s.add_development_dependency('rake')
  s.add_development_dependency('concurrent-ruby', '~> 1.0')
end
