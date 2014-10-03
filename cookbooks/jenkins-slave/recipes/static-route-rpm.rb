#Static Route entry
file '/etc/sysconfig/network-scripts/route-eth0' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
ADDRESS0=10.0.0.0
NETMASK0=255.0.0.0
GATEWAY0=10.10.10.24
  EOH
end

