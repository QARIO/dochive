# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "google-translate"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Shvets"]
  s.date = "2013-11-09"
  s.description = "Simple client for Google Translate API."
  s.email = "alexander.shvets@gmail.com"
  s.executables = ["translate", "t"]
  s.files = ["bin/translate", "bin/t"]
  s.homepage = "http://github.com/shvets/google-translate"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Simple client for Google Translate API."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<gemspec_deps_gen>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<gemspec_deps_gen>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<gemspec_deps_gen>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
  end
end
