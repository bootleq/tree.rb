# -*- encoding: utf-8; mode: ruby -*-
$:.push File.expand_path("../lib", __FILE__)
require "tree_rb/version"

Gem::Specification.new do |gem|
  gem.name = "tree.rb"
  gem.version = TreeRb::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.summary = "tree.rb is a 'clone' of tree unix command. The gem implements a library to mange tree structures."

  gem.description = <<-EOF
(This gem was named as treevisitor)
tree.rb is a 'clone' of tree unix command. The gem implements a library to mange tree structures.
The gem contains also a library to build tree with a dsl (domain specific language), and
an implementation of visitor design pattern.
An example of DSL to build tree:
<pre>
   tree = TreeNode.create do
     node "root" do
       leaf "l1"
       node "sub" do
         leaf "l3"
       end
       node "wo leaves"
     end
</pre>
  EOF

  gem.authors = ["Tokiro"]
  gem.email = "tokiro.oyama@gmail.com"
  gem.homepage = "http://github.com/tokiro/tree.rb"
  gem.require_paths = ["lib"]

  #
  # dependencies
  #

  gem.add_runtime_dependency(%q<json>, [">= 0"])
  gem.add_runtime_dependency(%q<ansi>, [">= 0"])

  gem.add_development_dependency(%q<rake>, [">= 0"])
  gem.add_development_dependency(%q<yard>, [">= 0"])
  gem.add_development_dependency(%q<bundler>, [">= 0"])
  gem.add_development_dependency(%q<rspec>, [">= 0"])

  #
  # files
  #
  # s.files         = `git ls-files`.split("\n")
  # gem.files         = `git ls-files`.split($\)
  gem.files = %w{LICENSE.txt README.md Rakefile tree.rb.gemspec .gemtest}
  gem.files.concat Dir['lib/**/*.rb']
  gem.files.concat Dir['tasks/**/*.rake']
  gem.files.concat Dir['examples/**/*']

  #
  # bin
  #
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.executables = %w{ tree.rb }


  #
  # test files
  #
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.test_files = Dir['spec/**/*.rb']
  gem.test_files.concat Dir['spec/fixtures/**/*']
  gem.test_files.concat Dir['spec/fixtures/**/.gitkeep']
  gem.test_files.concat Dir['spec/fixtures/**/.dir_with_dot/*']

end