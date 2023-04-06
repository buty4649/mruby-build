#!/usr/bin/env ruby

mruby_root = "/mruby"
build_config = File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
build_dir = File.expand_path(ENV["MRUBY_BUILD_DIR"] || "build")
install_dir = File.expand_path(ENV["MRUBY_INSTALL_DIR"] || "build/bin")

ENV["MRUBY_CONFIG"] = build_config
ENV["MRUBY_BUILD_DIR"] = build_dir
ENV["INSTALL_DIR"] = install_dir

require "rake"
load "#{mruby_root}/Rakefile"
Rake::Task["all"].invoke
