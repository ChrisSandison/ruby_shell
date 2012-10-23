# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'investigate'
require 'directory'
require 'file'
require 'shell'

class TestInvestigate < Test::Unit::TestCase
  
  def test_gettype
    instance = Investigate.instance
    teststring = "test"
    assert_equal(String, instance.gettype(teststring), "gettype: types do not match")
  end
  
  def test_isof
    instance = Investigate.instance
    dir1 = Directory.new("dir1", nil)
    dir2 = Directory.new("dir2", nil)
    file = File.new("file", nil)
    assert_equal(true, instance.isof(dir1,dir2),"isof: types do not match")
    assert_equal(false, instance.isof(dir1,file), "isof: types match")
  end
  
  def test_isroot?
    instance = Investigate.instance
    shell = Shell.instance
    root = Directory.new("/", nil)
    assert_equal(true, instance.isroot?(root), "isroot: not root")
    newdir = Directory.new("newdir", root)
    assert_equal(false, instance.isroot?(newdir), "isroot: is root")
    file = File.new("fakefile", root)
    assert_equal(false, instance.isroot?(file), "isroot: is root")
  end
  
   def test_parseargs
    args = %w[some args]
    testline = "some args"
    instance = Investigate.instance
    assert_equal(args, instance.parseargs(testline, ' '), "parseargs: not matching")
  end
  
   def test_getflags
     instance = Investigate.instance
     string = "this -r is some test string with flags"
     testargs = instance.parseargs(string, ' ')
     assert_equal(%w[r], instance.getflags(testargs), "unequal flag arrays")
     string2 = "this -rAl is some test string with flags"
     testargs = instance.parseargs(string2, ' ')
     assert_equal(%w[r A l], instance.getflags(testargs), "unequal flag arrays 2")
     string3 = "this string has no flags"
     testargs = instance.parseargs(string3, ' ')
     assert_equal(nil, instance.getflags(testargs), "found array in nil")
   end
   
end
