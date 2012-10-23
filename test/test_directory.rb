# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'directory'

class TestDirectory < Test::Unit::TestCase
  def test_mkdir
    testdir = Directory.new("testdir1", nil)
    newdir = testdir.mkdir("test/dir2") #should remove slashes
    assert_equal(newdir.getname, "testdir2", "mkdir: non-matching dir names")
    assert_equal(newdir.class, Directory, "mkdir: non-matching class")
    assert_equal(newdir.getparent, testdir, "mkdir: non-matching parent directory")
    assert_equal(newdir, testdir.getentry("testdir2"), "mkdir: non-matching directory entry")
  end
  
  def test_getparent
    testdir = Directory.new("testdir1", nil)
    newdir = testdir.mkdir("testdir2")
    assert_equal(testdir, testdir.getparent, "getparent: root directory is not it's own parent")
    assert_equal(testdir, newdir.getparent, "getparent: child directory does not reference parent")
  end
  
  def test_getname
    testdir = Directory.new("testdirectory", nil)
    assert_equal("testdirectory", testdir.getname, "getname: directory name does not match")
  end
  
  def test_get_addentry
    testdir = Directory.new("testdir1", nil)
    file = File.new("testfile", testdir)
    assert_equal(file, testdir.getentry("testfile"), "getentry: dir entry not found")
    testdir2 = Directory.new("testdir2", testdir)
    assert_equal(testdir2, testdir.getentry("testdir2"), "getentry: dir entry not found")
  end
  
  def test_createfile
    testdir = Directory.new("testdir1", nil)
    testdir.createfile("newfile")
    assert_equal("newfile", testdir.getentry("newfile").getname, "createfile: file not created")
  end
  
  def test_openfile
    testdir = Directory.new("testdir1", nil)
    file = File.new("testfile", testdir)
    assert_equal(file, testdir.openfile(file.getname), "openfile: file could not be opened")
    assert_equal("newfile", testdir.openfile("newfile").getname, "openfile: could not create new file")
  end
  
  def test_removecontents_allfiles
    dir = Directory.new("testdir", nil)
    file1 = File.new("file1", dir)
    file2 = File.new("file2", dir)
    assert_equal(file1, dir.getentry(file1.getname), "remove: file1 not found")
    assert_equal(file2, dir.getentry(file2.getname), "remove: file2 not found")
    dir.removecontents
    assert_equal(nil, dir.getentry(file1.getname), "remove: file1 found")
    assert_equal(nil, dir.getentry(file2.getname), "remove: file2 found")
  end
  
  def test_removecontents_filesndirs
    dir = Directory.new("testdir", nil)
    childdir = Directory.new("childdir", dir)
    file1 = File.new("file1", dir)
    file2 = File.new("file2", childdir)
    assert_equal(file1, dir.getentry(file1.getname), "remove: file1 not fuond")
    assert_equal(file2, childdir.getentry(file2.getname), "remove: file2 not found")
    dir.removecontents
    assert_equal(nil, dir.getentry(file1.getname), "remove: file1 found")
    assert_equal(nil, dir.getentry(childdir.getname), "remove: childdir found")
    assert_equal(nil, file2, "remove: file2 exists")
  end
end
