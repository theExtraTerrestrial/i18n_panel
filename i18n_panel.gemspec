require_relative "lib/i18n_panel/version"

Gem::Specification.new do |spec|
  spec.name        = "i18n_panel"
  spec.version     = I18nPanel::VERSION
  spec.authors     = ["theExtraTerrestrial"]
  # spec.homepage    = "TODO"
  spec.summary     = "Manage I18n translations from an admin panel for Ruby on Rails."
  spec.description = "Edit existing and missing translations quickly and conviniently from an admin panel with restricted access."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = "https://github.com/theExtraTerrestrial/i18n_panel"
  spec.metadata["source_code_uri"] = "https://github.com/theExtraTerrestrial/i18n_panel"
  spec.metadata["changelog_uri"] = "https://github.com/theExtraTerrestrial/i18n_panel.git"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", '6.0.3.4'
  spec.add_dependency "slim", '4.1.0'
end
