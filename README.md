# Ruby Cookbook

Installs ruby from debian or ubuntu packages. Optionally allows to install from my
[ppa:ysbaddaden/ruby-updates](https://launchpad.net/~ysbaddaden/+archive/ruby-updates)
PPA instead of the official repositories.

Supports any version from 1.8 to 2.1

## Usage

Just include the `ruby` recipe to your `run_list`:

```ruby
run_list "recipe[ruby]"
```

## Attributes

  - `default["ruby"]["versions"]` (required) — an array of ruby versions to install, eg: `["1.8", "1.9.3", "2.1"]`
  - `default["ruby"]["repository"]` – either `official` or `ppa`
  - `default["ruby"]["default_version"]` — eg: `"2.1"`
  - `default["ruby"]["rbenv"]` — also install and configure rbenv

