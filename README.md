# mruby-build
Useful mruby build tool

## Usage

```
docker run --rm -v $(pwd):/src buty4649/mruby-build:3.2.0
```

## example build_config.rb

### Use gcc

```ruby
def gem_config(conf)
  conf.gembox :default
end

def debug_config(conf)
  conf.enable_bintest
  conf.enable_test
  conf.enable_debug
end

MRuby::Build.new do |conf|
  toolchain: gcc

  gem_config(conf)
  debug_config(conf)
end
```

### Use zig

```ruby
MRuby::Build.new do |conf|
  [conf.cc, conf.linker].each do |cc|
    cc.command = 'zig cc'
  end
  conf.archiver.command = 'zig ar'

  gem_config(conf)
  debug_config(conf)
end
```

### Cross Compile

ref. https://k0kubun.hatenablog.com/entry/zig

```ruby
MRuby::CrossBuild.new('linux-armhf') do |conf|
  [conf.cc, conf.linker].each do |cc|
    cc.command = 'zig cc -target arm-linux-musleabihf'
  end
  conf.archiver.command = 'zig ar'
  conf.host_target = 'arm-linux-musleabihf'

  gem_config(conf)
  debug_config(conf)
end

# Cross-compiling to Windows is currently not supported
# MRuby::CrossBuild.new('windows-x86_64') do |conf|
# end

require 'shellwords'
MRuby::CrossBuild.new('darwin-x86_64') do |conf|
  macos_sdk = ENV.fetch('MACOSX_SDK_PATH')

  conf.cc.command = "zig cc -target x86_64-macos -mmacosx-version-min=10.14 -isysroot #{macos_sdk.shellescape} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks"
  conf.linker.command = "zig cc -target x86_64-macos -mmacosx-version-min=10.4 --sysroot #{macos_sdk.shellescape} -F/System/Library/Frameworks -L/usr/lib"
  conf.archiver.command = 'zig ar'
  ENV['RANLIB'] ||= 'zig ranlib'
  conf.host_target = 'x86_64-darwin'

  gem_config(conf)
  debug_config(conf)
end

MRuby::CrossBuild.new('darwin-aarch64') do |conf|
  macos_sdk = ENV.fetch('MACOSX_SDK_PATH')

  conf.cc.command = "zig cc -target aarch64-macos -mmacosx-version-min=11.1 -isysroot #{macos_sdk.shellescape} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks"
  conf.linker.command = "zig cc -target aarch64-macos -mmacosx-version-min=11.1 --sysroot #{macos_sdk.shellescape} -F/System/Library/Frameworks -L/usr/lib"
  conf.archiver.command = 'zig ar'
  ENV['RANLIB'] ||= 'zig ranlib'
  conf.host_target = 'aarch64-darwin'

  debug_config(conf)
  gem_config(conf)
end
```
