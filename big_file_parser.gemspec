Gem::Specification.new do |s| 
  s.name = "big_file_parser" 
  s.version = "0.0.5" 
  s.author = "Dusty Doris" 
  s.email = "github@dusty.name" 
  s.homepage = "http://code.dusty.name" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Parser for HUGE XML files or CSV files" 
  s.files = Dir["{test,lib,examples}/**/*"]
  s.require_path = "lib" 
  s.has_rdoc = true 
  s.extra_rdoc_files = ["README.txt"]
  s.add_dependency('libxml-ruby')
  s.add_dependency('fastercsv') if RUBY_VERSION < "1.9"
  s.rubyforge_project = "none"
end
