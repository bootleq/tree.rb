#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#require 'rubygems'

cwd = File.expand_path( File.join( File.dirname(__FILE__), "..", "lib" ) )
$:.unshift(cwd) unless $:.include?(cwd)
require 'tree_rb_cli'

include TreeRb
exit CliTree.run
