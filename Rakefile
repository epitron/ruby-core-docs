###############################################################################

project_name = "ruby-core-docs"

###############################################################################

RUBIES_DIR = "rubies"
SRC_DIR    = "src"
YARD_DIR   = "yardoc"
CACHE_DIR  = "cache"

###############################################################################

require 'fileutils'
include FileUtils

###############################################################################

def ensure_removed(path)
  rm_r path if File.exists? path
end

def ensure_directory(path)
  if not File.exists? path
    mkdir path
  elsif not File.directory? path
    raise "Error: #{path} is a file. We need to make a directory here. Please fix."
  end
end

###############################################################################

desc "Remove everything: rubies, cache, yardocs, etc."
task :pristine do
  to_remove = [RUBIES_DIR, SRC_DIR, YARD_DIR, CACHE_DIR, "VERSION"] + Dir["*.gem"]

  to_remove.each do |path|
    ensure_removed path
  end
end

###############################################################################

desc "Build, then 'gem push' all the built gems"
task :release => :build do
  Dir["*.gem"].each { |gemfile| system "gem push #{gemfile}" }
end

###############################################################################

desc "Download all the rubies"
task :download do
  ensure_directory RUBIES_DIR

  require "latest_ruby"

  %w[ruby19 ruby20 ruby21].each do |ver|
    url = Latest.send(ver).link
    system "wget -c #{url} --directory-prefix=#{RUBIES_DIR}"
  end
end

###############################################################################

desc "Build all the YARD docs and all the gems for all the rubies in 'rubies/'"
task :build => :docs do
  Dir["cache/*"].each do |cachedir|
    version = cachedir.split("/").last

    ensure_removed YARD_DIR
    cp_r cachedir, YARD_DIR

    puts "Version: #{version}"
    File.write("VERSION", version)

    system "gem build .gemspec"
  end
end

###############################################################################

desc "Just build YARD docs for each ruby in 'rubies/', and store the results in 'cache/'"
task :docs do

  Dir["#{RUBIES_DIR}/*"].each do |tarball|

    puts "="*60
    puts " Building documentation for #{tarball}..."
    puts "-"*60
    puts

    ## Get version from tarball
    if tarball =~ /ruby-([\d\.]+)(-p\d+)?\.tar\.gz$/
      version = $1
    else
      raise "Couldn't parse version from: #{tarball}"
    end

    # Make sure 'cache/' exists
    ensure_directory CACHE_DIR

    # Skip this ruby version if it's already been generated
    cache_dir = "#{CACHE_DIR}/#{version}"
    if File.exists? cache_dir
      puts "Already built (#{cache_dir}); skipping..."
      puts
      next
    end

    # Make "src/"
    ensure_removed SRC_DIR
    ensure_directory SRC_DIR

    # Untar ruby source
    puts "* Extracting #{tarball}"
    unless system "tar zxf #{tarball} --directory=#{SRC_DIR}"
      raise "* Error! #{tarball.inspect} is broken. Skipping."
      next
    end

    # Find the name of the ruby source directory (eg: src/ruby-2.1.1)
    ruby_dir = Dir["#{SRC_DIR}/*"].first

    # Change into the ruby directory
    chdir ruby_dir do

      # Find all the source files
      files = `find . -maxdepth 1 -name '*.c'`.each_line.to_a + `find ext -name '*.c'`.each_line.to_a
      files.map!(&:chomp)

      # system %{bash -c "cat <(find . -maxdepth 1 -name '*.c') <(find ext -name '*.c') | xargs yardoc --no-output --markup markdown"}

      # Yard them!
      system "yardoc", "--no-output", *files   # "--markup", "markdown"
    end

    mv "#{ruby_dir}/.yardoc", cache_dir

    # Cleanup
    ensure_removed SRC_DIR
  end
end

###############################################################################
