
file '/etc/yum.repos.d/apache-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[fedora-apache-ceph]
name=Fedora Local apache Repo
baseurl=http://gitbuilder.ceph.com/apache2-rpm-fedora#{node.platform_version}-x86_64-basic/ref/master/
priority=0
pgcheck=0
enabled=1
  EOH
end
  
file '/etc/yum.repos.d/fcgi-ceph.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[fedora-fcgi-ceph]
name=Fedora Local fastcgi Repo
baseurl=http://gitbuilder.ceph.com/mod_fastcgi-rpm-fedora#{node.platform_version}-x86_64-basic/ref/master/
priority=0
gpgcheck=0
enabled=1
  EOH
end

file '/etc/yum.repos.d/ceph-extras.repo' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[ceph-extras]
name=Fedora ceph extras
baseurl=http://ceph.com/packages/ceph-extras/rpm/fedora#{node.platform_version}/x86_64/
priority=0
gpgcheck=0
enabled=1
  EOH
end


execute "Installing GPG keys" do
  command <<-'EOH'
rpm --import 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc'
rpm --import 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/autobuild.asc'
  EOH
end

package 'yum-plugin-priorities'

execute "Clearing yum cache" do
  command "yum clean all"
end

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

# Needed for building mod_fastcgi
package 'httpd' do
  action :remove
end
package 'http-devel' do
  action :remove
end
package 'httpd-tools' do
  action :remove
end

if node[:platform_version] == "19"
  package 'mod_ssl' do
    version '2.2.22-1.ceph.fc19'
  end
  package 'httpd' do
    version '2.2.22-1.ceph.fc19'
  end
  package 'httpd-tools' do
    version '2.2.22-1.ceph.fc19'
  end
  package 'httpd-devel' do
    version '2.2.22-1.ceph.fc19'
  end
end

if node[:platform_version] == "20"
  package 'mod_ssl' do
    version '2.4.6-17_ceph.fc20'
  end
  package 'httpd' do
    version '2.4.6-17_ceph.fc20'
  end
  package 'httpd-tools' do
    version '2.4.6-17_ceph.fc20'
  end
  package 'httpd-devel' do
    version '2.4.6-17_ceph.fc20'
  end
end

service "httpd" do
  action [ :disable, :stop ]
end
