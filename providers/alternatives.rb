# Cookbook Name:: ruby
# Provider:: alternatives

action :add do
  bash "rbenv-alternatives" do
    user new_resource.user
    environment(
      "HOME" => "/home/#{new_resource.user}",
      "USER" => new_resource.user
    )
    code "rbenv alternatives"
  end
end

