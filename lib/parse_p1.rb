# encoding: UTF-8

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

require 'date'
require 'awesome_print'
require 'parse_p1/electricity'
require 'parse_p1/gas'
require 'parse_p1/base'
