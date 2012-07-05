[![Build Status](https://secure.travis-ci.org/wix/zpool.png)](http://travis-ci.org/wix/zpool)

Description
===========

Lightweight resource and provider to manage Solaris zpools. 

Currently, just creates or destroys simple zpools.


Requirements
============

Solaris, zpool.

Attributes
==========

    disks - Array of disks to put in the pool.

Usage
=====

    zpool "test" do
      disks [ "c0t2d0s0", "c0t3d0s0" ]
    end
  
  
    zpool "test2" do
      action :destroy
    end
  