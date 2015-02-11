# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "easy_translate"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Crepezzi"]
  s.date = "2013-12-17"
  s.description = "easy_translate is a wrapper for the google translate API that makes sense programatically, and implements API keys"
  s.email = "john.crepezzi@gmail.com"
  s.homepage = "https://github.com/seejohnrun/easy_translate"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Google Translate API Wrapper for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<thread>, [">= 0"])
      s.add_runtime_dependency(%q<thread_safe>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<thread>, [">= 0"])
      s.add_dependency(%q<thread_safe>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<thread>, [">= 0"])
    s.add_dependency(%q<thread_safe>, [">= 0"])
  end
end
