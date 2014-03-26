#
# Note: You must create gems using the "rake build" command, or this spec won't work.
#
Gem::Specification.new do |s|
  s.name        = "ruby-core-docs"
  s.version     = File.read "VERSION"

  s.authors     = ["Chris Gahan"]
  s.email       = ["chris@ill-logic.com"]
  s.summary     = "YARD documentation for Ruby #{s.version}'s core"
  s.description = "Docs for all the C source code in Matz' Ruby Interpreter (MRI)."
  s.homepage    = "https://github.com/epitron/ruby-core-docs"
  s.license     = 'MIT'

  s.require_paths = ["lib"]
  s.files         = `find yardoc lib VERSION`.each_line.map(&:chomp)

  s.add_dependency 'yard', "~> 0.8"
  s.add_development_dependency 'latest_ruby'
end
