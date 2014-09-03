include Chef::Mixin::ShellOut

def load_current_resource
  @zpool = Chef::Resource::Zpool.new(new_resource.name)
  @zpool.name(new_resource.name)
  @zpool.disks(new_resource.disks)

  @zpool.info(info)
  @zpool.state(state)

end

action :create do
  if created?
    if online?
      @zpool.disks.each do |disk|
        short_disk = disk.split('/').last
        unless vdevs.include? short_disk
          Chef::Log.info("Adding #{disk} to pool #{@zpool.name}")
          shell_out!("zpool add #{args_from_resource(new_resource)} #{@zpool.name} #{disk}")
          new_resource.updated_by_last_action(true)
        end
      end
    else
      Chef::Log.warn("Zpool #{@zpool.name} is #{@zpool.state}")
    end
  else
    Chef::Log.info("Creating zpool #{@zpool.name}")
    shell_out!("zpool create #{args_from_resource(new_resource)} #{@zpool.name} #{@zpool.disks.join(' ')}")
    new_resource.updated_by_last_action(true)
  end
end

action :destroy do
  if created?
    Chef::Log.info("Destroying zpool #{@zpool.name}")
    system("zpool destroy #{args_from_resource(new_resource)} #{@zpool.name}")
    new_resource.updated_by_last_action(true)
  end
end

private

def args_from_resource(new_resource)
  args = Array.new
  if new_resource.force
    args << '-f'
  end
  if new_resource.recursive
    args << '-r'
  end

  # Properties
  args << '-o'
  args << 'ashift=%s' % [new_resource.ashift]

  args.join(' ')
end

def created?
  @zpool.info.exitstatus.zero?
end


def state
  @zpool.info.stdout.chomp
end

def info
  shell_out("zpool list -H -o health #{@zpool.name}")
end

def vdevs
  @vdevs ||= shell_out("zpool list -v -H #{@zpool.name}").stdout.lines.map do |line|
    next unless line.chomp =~ /^[\t]/
    line.chomp.split("\t")[1]
  end.compact
  @vdevs
end

def online?
  @zpool.state == "ONLINE"
end

