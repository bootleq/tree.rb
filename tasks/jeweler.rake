#
# jeweler
#

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.name = "treevisitor"
    gem.summary = "Implementation of visitor design pattern"
    gem.description = <<-EOF
      Implementation of visitor design pattern. It contains a 'tree.rb'
      command line clone of the tree unix tool.
    EOF

    gem.authors = ["Tokiro"]
    gem.email = "tokiro.oyama@gmail.com"
    gem.homepage = "http://github.com/tokiro/treevisitor"

    #
    # dependecies
    #
    gem.add_development_dependency "rspec"

    #
    # bin
    #
    gem.executables = %w{ tree.rb }

    #
    # files
    #
    gem.files  = %w{LICENSE README.rdoc Rakefile VERSION.yml dircat.gemspec}
    gem.files.concat Dir['lib/**/*.rb']
    gem.files.concat Dir['examples/*.rb']


    #
    # test files
    #
    gem.test_files = Dir['spec/**/*.rb']
    gem.test_files.concat Dir['spec/fixtures/**/*']
    gem.test_files.concat Dir['spec/fixtures/**/.dir_with_dot/*']

    #
    # rubyforge
    #
    # gem.rubyforge_project = 'treevisitor'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end