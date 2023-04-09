MRUBY_VERSION = ENV["MRUBY_VERSION"] || "3.2.0"
IMAGE_TAG = ENV["IMAGE_TAG"] || "buty4649/mruby-build:#{MRUBY_VERSION}"

desc "Build docker image"
task "build" do
  sh "docker buildx build -t #{IMAGE_TAG} --build-arg MRUBY_VERSION=#{MRUBY_VERSION} ."
end
