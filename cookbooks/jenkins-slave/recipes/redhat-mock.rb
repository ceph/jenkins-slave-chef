# On Red Hat-based systems, in order to run the "mock" command, you must be a
# member of the "mock" group. (This is because mock has special root-like
# powers to set up a chroot, etc.)

# This recipe puts Jenkins into the mock group so that it can run the mock
# command.

group "mock" do
  action :modify
  members "jenkins-build"
  append true
end

