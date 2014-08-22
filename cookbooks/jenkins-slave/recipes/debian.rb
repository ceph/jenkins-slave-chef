#Apt priority

execute "add autobuild gpg key to apt" do
  command <<-EOH
  wget -q -O- 'http://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/autobuild.asc;hb=HEAD' \
  | sudo apt-key add -
  EOH
end

execute "add release gpg key to apt" do
  command <<-EOH
  wget -q -O- 'http://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc;hb=HEAD' \
  | sudo apt-key add -
  EOH
end

#Setup sources.list
if node[:platform_version] >= "6.0" and node[:platform_version] < "7.0"
  cookbook_file '/etc/apt/sources.list' do
    source "sources.list.squeeze"
    mode 0644
    owner "root"
    group "root"
  end
end
if node[:platform_version] >= "7.0" and node[:platform_version] < "8.0"
  cookbook_file '/etc/apt/sources.list' do
    source "sources.list.wheezy"
    mode 0644
    owner "root"
    group "root"
  end
end


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

#Ceph Extras:
file '/etc/apt/sources.list.d/ceph-extras.list' do
  owner 'root'
  group 'root'
  mode '0644'

  if node[:platform_version] >= "7.0" and node[:platform_version] < "8.0"
    # pull from wheezy gitbuilder
    content <<-EOH
deb http://ceph.com/packages/ceph-extras/debian/ wheezy main
EOH
  end
end



#Rados GW:
file '/etc/apt/sources.list.d/radosgw.list' do
  owner 'root'
  group 'root'
  mode '0644'

  if node[:platform_version] >= "7.0" and node[:platform_version] < "8.0"
    # pull from wheezy gitbuilder
    content <<-EOH
deb http://gitbuilder.ceph.com/apache2-deb-wheezy-x86_64-basic/ref/master/ wheezy main
deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-wheezy-x86_64-basic/ref/master/ wheezy main
EOH
  elsif node[:platform_version] >= "6.0" and node[:platform_version] < "7.0"
    # pull from squeeze gitbuilder
    content <<-EOH
deb http://gitbuilder.ceph.com/apache2-deb-squeeze-x86_64-basic/ref/master/ squeeze main
deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-squeeze-x86_64-basic/ref/master/ squeeze main
EOH
  else
    # hrm!
  end
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
package 'libblkid-dev'
package 'libboost-dev'
package 'libboost-program-options-dev'
package 'libboost-system-dev'
package 'libboost-thread-dev'
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

