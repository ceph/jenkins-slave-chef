#Local Epel Mirror:
cookbook_file '/etc/yum.repos.d/epel.repo' do
  source "epel7.repo"
  mode 0755
  owner "root"
  group "root"
end

package 'yum-plugin-priorities'

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
