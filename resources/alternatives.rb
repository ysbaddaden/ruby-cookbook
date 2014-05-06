# Cookbook Name:: ruby
# Resource:: alternatives

actions :add

def initialize(*args)
  super
  @action = :add
end

attribute :user, kind_of: String, name_attribute: true

