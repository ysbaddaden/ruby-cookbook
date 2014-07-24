case node["platform_family"]
when "debian", "ubuntu"

  include_recipe "apt"

  if node["ruby"]["repository"] == "ppa"
    apt_repository "ruby-updates" do
      uri "http://ppa.launchpad.net/ysbaddaden/ruby-updates/ubuntu"
      arch "amd64"
      distribution node["lsb"]["codename"]
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "0FE87EB3"
    end
  end

  node["ruby"]["versions"].each do |xx|
    package "libruby#{xx}"
    package "ruby#{xx}"
    package "ruby#{xx}-dev"
    package "rubygems" if xx == "1.8"
    package "ri#{xx}" if xx < "2.0"
    package "ruby#{xx}-doc" if xx >= "2.0"

    execute "install-gems" do
      command <<-EOV
      if [ "$(gem#{xx} list bundler | grep bundler)" ]; then
        gem#{xx} update bundler
      else
        gem#{xx} install bundler
      fi
      EOV
    end
  end

  if node["ruby"]["default_version"]
    # ubuntu precise and debian wheezy
    package "ruby-switch" do
      not_if { !File.symlink?("/etc/alternatives/ruby") }
    end

    execute "ruby-switch" do
      not_if { !File.symlink?("/etc/alternatives/ruby") }
      command "ruby-switch --set ruby#{node["ruby"]["default_version"]}"
    end

    # ubuntu trusty and next debian
    execute "ruby-set-version" do
      not_if { File.symlink?("/etc/alternatives/ruby") }
      command <<-BASH
      ln -sf /usr/bin/erb#{node["ruby"]["default_version"]} /usr/bin/erb
      ln -sf /usr/bin/gem#{node["ruby"]["default_version"]} /usr/bin/gem
      ln -sf /usr/bin/irb#{node["ruby"]["default_version"]} /usr/bin/irb
      ln -sf /usr/bin/rake#{node["ruby"]["default_version"]} /usr/bin/rake
      ln -sf /usr/bin/rdoc#{node["ruby"]["default_version"]} /usr/bin/rdoc
      ln -sf /usr/bin/ri#{node["ruby"]["default_version"]} /usr/bin/ri
      ln -sf /usr/bin/ruby#{node["ruby"]["default_version"]} /usr/bin/ruby
      ln -sf /usr/bin/testrb#{node["ruby"]["default_version"]} /usr/bin/testrb
      ln -sf /usr/share/man/man1/erb#{node["ruby"]["default_version"]} /usr/share/man/man1/erb
      ln -sf /usr/share/man/man1/irb#{node["ruby"]["default_version"]} /usr/share/man/man1/irb
      ln -sf /usr/share/man/man1/rake#{node["ruby"]["default_version"]} /usr/share/man/man1/rake
      ln -sf /usr/share/man/man1/ri#{node["ruby"]["default_version"]} /usr/share/man/man1/ri
      ln -sf /usr/share/man/man1/ruby#{node["ruby"]["default_version"]} /usr/share/man/man1/ruby
      BASH
    end
  end

  if node["ruby"]["rbenv"]
    package "rbenv"
    ruby_alternatives "vagrant"

    template "rbenv.sh" do
      path "/etc/profile.d/rbenv.sh"
      mode "0644"
    end
  end

else
  Chef::Log.error "Unsupported platform: use another method to install ruby."
  return
end
