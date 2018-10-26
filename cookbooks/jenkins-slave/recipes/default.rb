# Check if burnupi/plana
if !node['hostname'].match(/^(gitbuilder|releasebuilder)/)
 raise "This recipe is only intended for Gitbuilder/Releasebuilder hosts"
end


# high max open files
file '/etc/security/limits.d/ubuntu.conf' do
  owner 'root'
  group 'root'
  mode '0755'
  content <<-EOH
    ubuntu hard nofile 16384
  EOH
end


if node[:platform] == "ubuntu"
  include_recipe "jenkins-slave::ubuntu"
end

if node[:platform] == "centos"
  if node[:platform_version] >= "6.0" and node[:platform_version] < "7.0"
    include_recipe "jenkins-slave::centos6"
  end
  if node[:platform_version] >= "7.0" and node[:platform_version] < "8.0"
    include_recipe "jenkins-slave::centos7"
  end
end

if node[:platform] == "redhat"
  if node[:platform_version] >= "6.0" and node[:platform_version] < "7.0"
    include_recipe "jenkins-slave::redhat6"
  end
  if node[:platform_version] >= "7.0" and node[:platform_version] < "8.0"
    include_recipe "jenkins-slave::redhat7"
  end
end

if node[:platform] == "debian"
  include_recipe "jenkins-slave::debian"
end

if node[:platform] == "fedora"
  include_recipe "jenkins-slave::fedora"
end

# Set up Timezone
include_recipe "jenkins-slave::timezone"

# Set up Jenkins user/keys/files
include_recipe "jenkins-slave::jenkins"

