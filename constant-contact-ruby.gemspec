# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{constant-contact-ruby}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Terlson"]
  s.date = %q{2009-04-01}
  s.email = %q{brian.terlson@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "lib/constant_contact_ruby", "lib/constant_contact_ruby/connection.rb", "lib/constant_contact_ruby/contact.rb", "lib/constant_contact_ruby/contacts.rb", "lib/constant_contact_ruby/session.rb", "lib/constant_contact_ruby.rb", "test/session_test.rb", "test/test_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/bterlson/constant-contact-ruby}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Interface with the Constant Contact api}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
