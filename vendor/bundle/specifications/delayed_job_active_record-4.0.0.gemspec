# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "delayed_job_active_record"
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Ryckbost", "Matt Griffin", "Erik Michaels-Ober"]
  s.date = "2013-07-30"
  s.description = "ActiveRecord backend for Delayed::Job, originally authored by Tobias L\u{fc}tke"
  s.email = ["bryckbost@gmail.com", "matt@griffinonline.org", "sferik@gmail.com"]
  s.homepage = "http://github.com/collectiveidea/delayed_job_active_record"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "ActiveRecord backend for DelayedJob"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 4.1", ">= 3.0"])
      s.add_runtime_dependency(%q<delayed_job>, ["< 4.1", ">= 3.0"])
    else
      s.add_dependency(%q<activerecord>, ["< 4.1", ">= 3.0"])
      s.add_dependency(%q<delayed_job>, ["< 4.1", ">= 3.0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 4.1", ">= 3.0"])
    s.add_dependency(%q<delayed_job>, ["< 4.1", ">= 3.0"])
  end
end
