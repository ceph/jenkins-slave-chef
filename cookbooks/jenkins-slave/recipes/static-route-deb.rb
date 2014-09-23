#Static Route entry
file '/etc/network/if-up.d/script' do
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
#!/bin/bash
route add -net 10.0.0.0/8 gw 10.10.10.24 dev eth0
  EOH
end

