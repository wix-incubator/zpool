actions :create, :destroy

attribute :name, :kind_of => String
attribute :disks, :kind_of => Array

attribute :info, :kind_of => Mixlib::ShellOut, :default => nil
attribute :state, :kind_of => String, :default => nil

# Optional attributes
attribute :force, :kind_of => [TrueClass, FalseClass], :default => false
attribute :recursive, :kind_of => [TrueClass, FalseClass], :default => false
attribute :ashift, :kind_of => Integer, :default => 0

def initialize(*args)
  super
  @action = :create
end
