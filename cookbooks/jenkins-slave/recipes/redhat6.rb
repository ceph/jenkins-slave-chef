include_recipe "jenkins-slave::static-route-rpm"

#Local Epel Mirror:
cookbook_file '/etc/yum.repos.d/epel.repo' do
  source "epel6.repo"
  mode 0644
  owner "root"
  group "root"
end
cookbook_file '/etc/yum.repos.d/epel-testing.repo' do
  source "epel6-testing.repo"
  mode 0644
  owner "root"
  group "root"
end

#Local Repo Mirror
file '/etc/yum.repos.d/rhel6.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[rhel-6-repo]
name=My Red Hat Enterprise Linux $releasever - $basearch
baseurl=http://apt-mirror.front.sepia.ceph.com/rhel6repo/
gpgcheck=0
enabled=1
  EOH
end

#Ceph/qemu Repo

#Local Repo
file '/etc/yum.repos.d/qemu-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[redhat6-qemu-ceph]
name=RHEL 6 Local Qemu Repo
baseurl=http://ceph.com/packages/ceph-extras/rpm/rhel6/x86_64/
gpgcheck=0
enabled=1
priority=2
  EOH
end


file '/etc/yum.repos.d/apache-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[redhat6-apache-ceph]
name=RHEL 6 Local apache Repo
baseurl=http://gitbuilder.ceph.com/apache2-rpm-rhel6-x86_64-basic/ref/master/
gpgcheck=0
enabled=1
priority=2
  EOH
end

file '/etc/yum.repos.d/fcgi-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[redhat6-fcgi-ceph]
name=RHEL 6 Local fastcgi Repo
baseurl=http://gitbuilder.ceph.com/mod_fastcgi-rpm-rhel6-x86_64-basic/ref/master/
gpgcheck=0
enabled=1
priority=2
  EOH
end

file '/etc/yum.repos.d/misc-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[redhat6-misc-ceph]
name=RHEL 6 Local misc Repo
baseurl=http://apt-mirror.front.sepia.ceph.com/misc-rpms/
gpgcheck=0
enabled=1
priority=2
  EOH
end

file '/etc/yum.repos.d/ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[redhat6-ceph]
name=RHEL 6 Local ceph Repo
baseurl=http://gitbuilder.ceph.com/ceph-rpm-centos6-x86_64-basic/ref/cuttlefish/x86_64/
gpgcheck=0
enabled=1
priority=2
  EOH
end

package 'yum-plugin-priorities'

execute "Clearing yum cache" do
  command "yum clean all"
end



# Packages needed for slave.
package 'asciidoc'
package 'autoconf'
package 'automake'
package 'binutils-devel'
package 'bison'
package 'boost'
package 'boost-devel'
package 'boost-program-options'
package 'ccache'
package 'createrepo'
package 'cryptopp-devel'
package 'expat'
package 'expat-devel'
package 'expect'
package 'fcgi'
package 'fcgi-devel'
package 'flex'
package 'fuse'
package 'fuse-devel'
package 'fuse-libs'
package 'gcc-c++'
package 'git'
package 'gnupg'
package 'gperftools-devel'
package 'gtk2-devel'
package 'gtkmm24'
package 'gtkmm24-devel'
package 'junit4' do
  action :upgrade
end
package 'keyutils-libs-devel'
package 'leveldb-devel'
package 'libaio'
package 'libaio-devel'
package 'libatomic_ops-devel'
package 'libblkid'
package 'libblkid-devel'
package 'libcurl'
package 'libcurl-devel'
package 'libedit'
package 'libedit-devel'
package 'libtool'
package 'libudev'
package 'libudev-devel'
package 'libuuid'
package 'libuuid-devel'
package 'libxml2-devel'
package 'logrotate'
package 'make'
package 'mock'
package 'mod_fcgid'
package 'nss-devel'
package 'ntp'
package 'pkgconfig'
package 'python-nose'
package 'python-devel'
package 'python-virtualenv'
package 'python-mock'
package 'python-tox'
package 'pytest'
package 'redhat-rpm-config'
package 'rpm-build'
package 'rsync'
package 'sharutils'
package 'snappy-devel'
package 'tar'
package 'xfsprogs'
package 'xfsprogs-devel'
package 'xmlto'
package 'yasm'
package 'zlib-devel'

# Remove requiretty, not visiblepw and set unlimited security/limits.conf soft core value
execute "Sudoers and security/lmits.conf changes" do
  command <<-'EOH'
    sed -i 's/ requiretty/ !requiretty/g' /etc/sudoers
    sed -i 's/ !visiblepw/ visiblepw/g' /etc/sudoers
    sed -i 's/^#\*.*soft.*core.*0/\*                soft    core            unlimited/g' /etc/security/limits.conf
  EOH
end

#Needed for building mod_fastcgi
package 'httpd' do
  action :remove
end
package 'http-devel' do
  action :remove
end
package 'httpd-tools' do
  action :remove
end
package 'mod_ssl' do
  version '2.2.22-1.ceph.el6'
end
package 'httpd' do
  version '2.2.22-1.ceph.el6'
end
package 'httpd-tools' do
  version '2.2.22-1.ceph.el6'
end
package 'httpd-devel' do
  version '2.2.22-1.ceph.el6'
end
service "httpd" do
  action [ :disable, :stop ]
end

