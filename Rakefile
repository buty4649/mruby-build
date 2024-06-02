git_sha = `git rev-parse HEAD`.chomp
IMAGE_TAG = ENV["IMAGE_TAG"] || "buty4649/mruby-build:#{git_sha}"

def no_cache_flag
  "--no-cache" if ENV["NO_CAHE"]
end

desc "Build docker image"
task "build" do
  sh "docker buildx build -t #{IMAGE_TAG} #{no_cache_flag} docker/"
end
