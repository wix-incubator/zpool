name             "zpool"
maintainer       "Martha Greenberg"
maintainer_email "marthag@wix.com"
license          "Apache 2.0"
description      "Manages Solaris zpools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w[solaris2 ubuntu].each do |os|
  supports os
end
