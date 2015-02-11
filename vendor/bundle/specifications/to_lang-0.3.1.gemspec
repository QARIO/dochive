# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "to_lang"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jimmy Cuadra"]
  s.date = "2011-09-15"
  s.description = "Adds language translation methods to strings and arrays, backed by the Google Translate API"
  s.email = ["jimmy@jimmycuadra.com"]
  s.executables = ["to_lang"]
  s.files = ["bin/to_lang"]
  s.homepage = "https://github.com/jimmycuadra/to_lang"
  s.require_paths = ["lib"]
  s.rubyforge_project = "to_lang"
  s.rubygems_version = "2.0.3"
  s.summary = "Translate strings with Google Translate"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["~> 0.8.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.5.3"])
      s.add_development_dependency(%q<RedCloth>, ["~> 4.2.8"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 0.4.5"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.4.3"])
      s.add_development_dependency(%q<growl_notify>, ["~> 0.0.1"])
    else
      s.add_dependency(%q<httparty>, ["~> 0.8.0"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.5.3"])
      s.add_dependency(%q<RedCloth>, ["~> 4.2.8"])
      s.add_dependency(%q<guard-rspec>, ["~> 0.4.5"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.4.3"])
      s.add_dependency(%q<growl_notify>, ["~> 0.0.1"])
    end
  else
    s.add_dependency(%q<httparty>, ["~> 0.8.0"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.5.3"])
    s.add_dependency(%q<RedCloth>, ["~> 4.2.8"])
    s.add_dependency(%q<guard-rspec>, ["~> 0.4.5"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.4.3"])
    s.add_dependency(%q<growl_notify>, ["~> 0.0.1"])
  end
end
