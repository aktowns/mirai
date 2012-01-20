source "http://rubygems.org"

gem "eventmachine", "~>1.0.0.beta.4"
gem "thin", "~>1.3.1"
gem "daemons", "~>1.1.6"
gem "colorize", "~>0.5.8"

Dir.glob(File.join(File.dirname(__FILE__), 'plugins', '**', "Gemfile")) do |gemfile|
    self.send(:eval, File.open(gemfile, 'r').read)
end