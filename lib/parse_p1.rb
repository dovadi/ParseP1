$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'date'
require 'parse_p1/electricity'
require 'parse_p1/gas'
require 'parse_p1/base'
