# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'shell'

class TestShell < Test::Unit::TestCase
  def test_getinstance
    instance = Shell.instance
    assert_equal(Shell, instance.class)
  end
  
  def test_get_setcurrentdir
    instance = Shell.instance
    dir = Directory.new("test", nil)
    instance.currentdir(dir)
    assert_equal(dir, instance.getcurrentdir, "currentdir: current dir not matching")
  end
  
  def test_cd_rootparent
    instance = Shell.instance
    root = Directory.new("/", nil)
    child = Directory.new("child", root)
    instance.currentdir(child)
    instance.cd("..")
    assert_equal(root, instance.getcurrentdir, "cd: not in root")
  end
  
  def test_cd_otherparent
    instance = Shell.instance
    root = Directory.new("/", nil)
    child = Directory.new("child", root)
    instance.currentdir(root)
    instance.cd("child")
    assert_equal(child, instance.getcurrentdir, "cd: not in child")
  end
  
  def test_pwd
    instance = Shell.instance
    root = Directory.new("/", nil)
    child = Directory.new("child", root)
    child2 = Directory.new("child2", child)
    child3 = Directory.new("child3", child2)
    instance.currentdir(child3)
    assert_equal("/child/child2/child3",instance.pwd,"pwd: not correct")
  end
  
  def test_copy
    instance = Shell.instance
    root = Directory.new("/", nil)
    
  end
end
