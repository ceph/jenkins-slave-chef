execute "Set Los Angeles Timezone" do
  command <<-EOH
  if [ -e  /usr/share/zoneinfo/America/Los_Angeles ]
  then
    rm -vf /etc/localtime
    ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
  fi
  EOH
end

