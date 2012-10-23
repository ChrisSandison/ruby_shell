# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'file'

class TestFile < Test::Unit::TestCase
  def test_get_setname
    testfile = File.new("", nil)
    testfile.setname("testfile")
    assert_equal("testfile",testfile.getname,"get/set name: file name not matching")
  end
  
  def test_get_setdir
    testdir = Directory.new("testdir", nil)
    testfile = File.new("testfile", testdir)
    assert_equal(testdir, testfile.getdir, "getdir: file's dir not matching")
    newdir = Directory.new("newdir", nil)
    testfile.setdir(newdir)
    assert_equal(newdir, testfile.getdir, "setdir: new dir was not set")
  end
  
  def test_modifyfile
    testfile = File.new("testfile", nil)
    sleep(1.0)
    testfile.modifyfile
    assert_not_equal(testfile.modified.sec, testfile.created.sec, "modifyfile: seconds are equal")
  end
  
  def test_read_writetofile
    testfile = File.new("testfile", nil)
    testfile.writetofile("test")
    assert_equal("test", testfile.readfile, "writetotfile: contents not equal")
  end
end
