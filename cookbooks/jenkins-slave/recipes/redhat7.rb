#Local Epel Mirror:
cookbook_file '/etc/yum.repos.d/epel.repo' do
  source "epel7.repo"
  mode 0755
  owner "root"
  group "root"
end


#Local Repo Mirror
file '/etc/yum.repos.d/rhel7.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[rhel-7-repo]
name=My Red Hat Enterprise Linux $releasever - $basearch
baseurl=http://apt-mirror.front.sepia.ceph.com/rhel7repo/server
gpgcheck=0
enabled=1
  EOH
end
file '/etc/yum.repos.d/rhel7-optional.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[rhel-7-repo]
name=My Red Hat Enterprise Linux $releasever - $basearch
baseurl=http://apt-mirror.front.sepia.ceph.com/rhel7repo/server-optional
gpgcheck=0
enabled=1
  EOH
end

file '/etc/yum.repos.d/apache-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[rhel7-apache-ceph]
name=RHEL 7 Local apache Repo
baseurl=http://gitbuilder.ceph.com/apache2-rpm-rhel7-x86_64-basic/ref/master/
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
[rhel7-fcgi-ceph]
name=RHEL 7 Local fastcgi Repo
baseurl=http://gitbuilder.ceph.com/mod_fastcgi-rpm-rhel7-x86_64-basic/ref/master/
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
package 'junit4'
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
package 'libgudev1'
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
package 'rpm-sign'
package 'rsync'
package 'sharutils'
package 'snappy-devel'
package 'systemd-devel'
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
  version '2.4.6-17_ceph.el7'
end
package 'httpd' do
  version '2.4.6-17_ceph.el7'
end
package 'httpd-tools' do
  version '2.4.6-17_ceph.el7'
end
package 'httpd-devel' do
  version '2.4.6-17_ceph.el7'
end
service "httpd" do
  action [ :disable, :stop ]
end
