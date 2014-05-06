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
    package "ruby-switch"

    execute "ruby-switch" do
      command "ruby-switch --set ruby#{node["ruby"]["default_version"]}"
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
