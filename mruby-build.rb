#!/usr/bin/env ruby

require 'fileutils'
require 'rake'

mruby_root = "/mruby"
build_config = File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
build_dir = File.expand_path(ENV["MRUBY_BUILD_DIR"] || "build")
install_dir = File.expand_path(ENV["MRUBY_INSTALL_DIR"] || "build/bin")

ENV["MRUBY_CONFIG"] = build_config
ENV["MRUBY_BUILD_DIR"] = build_dir
ENV["INSTALL_DIR"] = install_dir

task = ARGV.first || "all"

load "#{mruby_root}/Rakefile"
Rake::Task[task].invoke
