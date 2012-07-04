actions :create, :destroy

attribute :name, :kind_of => String
attribute :disks, :kind_of => Array

attribute :info, :kind_of => Mixlib::ShellOut, :default => nil
attribute :state, :kind_of => String, :default => nil

def initialize(*args)
  super
  @action = :create
end
