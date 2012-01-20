source "http://rubygems.org"

gem "eventmachine", "~>1.0.0.beta.4"
gem "thin", "~>1.3.1"
gem "daemons", "~>1.1.6"

# Handles the installing of the gems in the Gemfiles of plugins
Dir.glob(File.join(File.dirname(__FILE__), 'plugins', '**', "Gemfile")) do |gemfile|
    self.send(:eval, File.open(gemfile, 'r').read)
end
