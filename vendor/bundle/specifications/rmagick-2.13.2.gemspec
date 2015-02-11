# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rmagick"
  s.version = "2.13.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Hunter", "Omer Bar-or", "Benjamin Thomas"]
  s.date = "2013-02-02"
  s.description = "RMagick is an interface between Ruby and ImageMagick."
  s.email = "rmagick@rubyforge.org"
  s.extensions = ["ext/RMagick/extconf.rb"]
  s.files = ["ext/RMagick/extconf.rb"]
  s.homepage = "http://rubyforge.org/projects/rmagick"
  s.require_paths = ["lib", "ext"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.5")
  s.requirements = ["ImageMagick 6.4.9 or later"]
  s.rubyforge_project = "rmagick"
  s.rubygems_version = "2.0.3"
  s.summary = "Ruby binding to ImageMagick"
end
