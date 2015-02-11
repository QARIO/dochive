# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cocaine"
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Yurek"]
  s.date = "2013-10-22"
  s.description = "A small library for doing (command) lines"
  s.email = "jyurek@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/cocaine"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "A small library for doing (command) lines"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<climate_control>, ["< 1.0", ">= 0.0.3"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bourne>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, ["< 5.0", ">= 3.0.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<climate_control>, ["< 1.0", ">= 0.0.3"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bourne>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activesupport>, ["< 5.0", ">= 3.0.0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<climate_control>, ["< 1.0", ">= 0.0.3"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bourne>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activesupport>, ["< 5.0", ">= 3.0.0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
