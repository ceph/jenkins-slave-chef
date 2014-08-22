
user "jenkins-build" do
  shell "/bin/bash"
  home "/home/jenkins-build"
  comment "Created by Chef"
  provider Chef::Provider::User::Useradd
  action :create
end

directory "/home/jenkins-build" do
  owner "jenkins-build"
  group "jenkins-build"
  mode 00751
  action :create
end

directory "/home/jenkins-build/.ssh" do
  owner "jenkins-build"
  group "jenkins-build"
  mode 00700
  action :create
end

cookbook_file '/home/jenkins-build/.ssh/authorized_keys' do
  source "authorized_keys2"
  mode 0700
  owner "jenkins-build"
  group "jenkins-build"
end

directory "/srv/" do
  owner "root"
  group "root"
  mode 00755
  action :create
end
execute "Checkout ceph-build" do
  command <<-EOH
  if [ ! -d /srv/ceph-build ]
  then
    git clone git://github.com/ceph/ceph-build /srv/ceph-build
  else
    cd /srv/ceph-build
    git pull
  fi
  EOH
end

directory "/home/jenkins-build/build" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

execute "Grab GNUPG keys" do
  command <<-EOH
  rsync --progress -av rsync://plana01.front.sepia.ceph.com/jenkins/gnupg/ /home/jenkins-build/build/
  EOH
end

execute "Grab SSH keys" do
  command <<-EOH
  rsync --progress -av rsync://plana01.front.sepia.ceph.com/jenkins/*id_rsa /home/jenkins-build/.ssh/
  chown -Rf jenkins-build /home/jenkins-build/.ssh
  chmod 700 /home/jenkins-build/.ssh/*id_rsa
  EOH
end

execute "chown build" do
  command "chown -R jenkins-build:jenkins-build /home/jenkins-build/build"
  user "root"
  action :run
end

if node[:languages][:ruby][:host_cpu] == "x86_64"
  execute "Grab debian-base (64-bit)" do
    command <<-EOH
    rsync --progress -av rsync://plana01.front.sepia.ceph.com/jenkins/debian-base-64/ /srv/debian-base/
    EOH
  end
else
  execute "Grab debian-base (32-bit)" do
    command <<-EOH
    rsync --progress -av rsync://plana01.front.sepia.ceph.com/jenkins/debian-base-32/ /srv/debian-base/
    EOH
  end
end


file '/etc/sudoers.d/100-jenkins' do
  owner 'root'
  group 'root'
  mode '0440'
  content <<-EOH
jenkins-build ALL=(ALL) NOPASSWD:ALL
EOH
end
