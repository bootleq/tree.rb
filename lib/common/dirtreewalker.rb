class DirTreeWalker

  def initialize( dirname )
    @dirname = dirname
    unless File.directory?( dirname )
      raise "#{dirname} is not a directory!"
    end

    @dirTreeVisitor = nil
    @ignore_dir_patterns = []
    @inspect_file_patterns = []
    @ignore_file_patterns = []
  end

  def run( dirTreeVisitor )
    @dirTreeVisitor = dirTreeVisitor
    process_directory( nil, File.expand_path( @dirname ) )
  end

  def add_ignore_dir( pattern )
    @ignore_dir_patterns << pattern
  end

  def add_ignore_file( pattern )
    @ignore_file_patterns << pattern
  end

  #
  # quali file bisogna prendere in considerazione
  # inspect opposto di ignore :-)
  #
  def add_inspect_file( pattern )
    @inspect_file_patterns << pattern
  end

  def ignore_dir?( dirname )
    basename = File.basename( dirname )
    @ignore_dir_patterns.find{ |pattern|
      basename == pattern
    }
  end

  def ignore_file?( filename )
    basename = File.basename( filename )
    @ignore_file_patterns.find{ |pattern|
      if pattern.kind_of? Regexp
        pattern =~ basename
      else
        pattern == basename
      end
    }
  end

  def inspect_file?( filename )
    return true if @inspect_file_patterns.empty?
    basename = File.basename( filename )
    @inspect_file_patterns.find{ |pattern|
      if pattern.kind_of? Regexp
        pattern =~ basename
      else
        pattern == basename
      end
    }
  end


  private

  #
  # recurse on other directories
  #
  def process_directory( parentNode, dirname )
    return nil if ignore_dir?( dirname )

    # puts dirname
    treeNode = @dirTreeVisitor.visit_dir( parentNode, dirname )

    Dir.entries( dirname ).each { |basename|
      next if basename == "." or basename == ".."
      pathname = File.join( dirname, basename )

      if File.directory?( pathname )

        # directory
        if ! ignore_dir?( basename )
          ret = process_directory( treeNode, pathname )
          if ! treeNode.nil? && ! ret.nil?
            @dirTreeVisitor.visited_dir( treeNode, ret )
          end
        end

      else

        # file
        if inspect_file?( basename ) && ! ignore_file?( basename )
          ret = @dirTreeVisitor.visit_file( treeNode, pathname )
          if ! treeNode.nil? && ! ret.nil?
            @dirTreeVisitor.visited_file( treeNode, ret )
          end
        end

      end
    }
    treeNode
  end
end