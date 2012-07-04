include Chef::Mixin::ShellOut

def load_current_resource
  @zpool = Chef::Resource::Zpool.new(new_resource.name)
  @zpool.name(new_resource.name)
  @zpool.disks(new_resource.disks)

  @zpool.info(info?)
  @zpool.state(state?)

end

action :create do
  unless created?
    Chef::Log.info("Creating zpool #{@zpool.name}")
    system("zpool create #{@zpool.name} #{@zpool.disks.join(' ')}")
    new_resource.updated_by_last_action(true)
  else
    unless online?
      Chef::Log.warn("Zpool #{@zpool.name} is #{@zpool.state}")
    end
  end
end

action :destroy do
  if created?
    Chef::Log.info("Destroying zpool #{@zpool.name}")
    system("zpool destroy -f  #{@zpool.name}")
    new_resource.updated_by_last_action(true)
  end
end

private

def created?
  @zpool.info.exitstatus.zero?
end


def state?
  @zpool.info.stdout.chomp
end

def info?
  shell_out("zpool list -H -o health #{@zpool.name}")
end

def online?
  @zpool.state == "ONLINE"
end

