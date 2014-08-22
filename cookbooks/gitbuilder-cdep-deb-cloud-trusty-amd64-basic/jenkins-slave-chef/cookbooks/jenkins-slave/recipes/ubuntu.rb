
#Apt priority
file '/etc/apt/preferences.d/ceph.pref' do
  owner 'root'
  group 'root'
  mode '0644'
    content <<-EOH
Package: *
Pin: origin gitbuilder.ceph.com
Pin-Priority: 999
EOH
end

case node[:platform]
when "ubuntu"
  case node[:platform_version]
  when "12.04"
    cookbook_file '/etc/apt/sources.list' do
      source "sources.list.precise"
      mode 0644
      owner "root"
      group "root"
    end
  when "14.04"
    cookbook_file '/etc/apt/sources.list' do
      source "sources.list.trusty"
      mode 0644
      owner "root"
      group "root"
    end
  end
end

file '/etc/apt/sources.list.d/radosgw.list' do
  owner 'root'
  group 'root'
  mode '0644'

  if node[:platform_version] == "12.04"
    # pull from precise gitbuilder
    content <<-EOH
deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-precise-x86_64-basic/ref/master/ precise main
deb http://gitbuilder.ceph.com/apache2-deb-precise-x86_64-basic/ref/master/ precise main
EOH
  elsif node[:platform_version] == "14.04"
    # pull from oneiric gitbuilder
    content <<-EOH
deb http://gitbuilder.ceph.com/apache2-deb-trusty-x86_64-basic/ref/master/ trusty main
deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-trusty-x86_64-basic/ref/master/ trusty main
EOH
  else
    # hrm!
  end
end

execute "add autobuild gpg key to apt" do
  command <<-EOH
  wget -q -O- 'http://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/autobuild.asc;hb=HEAD' \
  | sudo apt-key add -
  EOH
end
execute "add release gpg key to apt" do
  command <<-EOH
  wget -q -O- 'http://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' \
  | sudo apt-key add -
  EOH
end


execute "apt-get update" do
  command "apt-get update"
end


# Packages needed for slaves
package 'automake'
package 'binutils-dev'
package 'bison'
package 'debhelper'
package 'devscripts'
package 'fakeroot'
package 'flex'
package 'gnupg'
package 'git'
package 'junit4'
package 'libaio-dev'
package 'libatomic-ops-dev'
package 'libapr1-dev'
package 'libaprutil1-dev'
package 'libblkid-dev'
package 'libboost-dev'
package 'libboost-program-options-dev'
package 'libboost-system-dev'
package 'libboost-thread-dev'
package 'libcap-dev'
package 'libcrypto++-dev'
package 'libcurl4-gnutls-dev'
package 'libdistro-info-perl'
package 'libdw-dev'
package 'libedit-dev'
package 'libexpat1-dev'
package 'libfcgi-dev'
package 'libfuse-dev'
package 'libgoogle-perftools-dev'
package 'libgtkmm-2.4-dev'
package 'libkeyutils-dev'
package 'libleveldb-dev'
package 'liblua5.2-dev'
package 'libnewt-dev'
package 'libnss3-dev'
package 'libsnappy-dev'
package 'libssl-dev'
package 'libtool'
package 'libudev-dev'
package 'libxml2-dev'
package 'lintian'
package 'pbuilder'
package 'pkg-config'
package 'python-argparse'
package 'python-nose'
package 'python-pip'
package 'python-support'
package 'python-virtualenv'
package 'reprepro'
package 'sharutils'
package 'uuid-dev'
package 'uuid-runtime'
package 'xfslibs-dev'
package 'yasm'


# Really just apache needed to rebuild mod_fastcgi packages
package 'apache2' do
  action :upgrade
end
package 'libapache2-mod-fastcgi' do
  action :upgrade
end
package 'libfcgi0ldbl'

service "apache2" do
  action [ :disable, :stop ]
end
