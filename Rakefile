###############################################################################

project_name = "ruby-core-docs"

###############################################################################

RUBIES_DIR = "rubies"
SRC_DIR    = "src"
YARD_DIR   = "yardoc"
CACHE_DIR  = "cache"

###############################################################################

require 'fileutils'

task :build do
  Dir["cache/*"].each do |cachedir|
    version = cachedir.split("/").last

    FileUtils.rm_r YARD_DIR
    FileUtils.cp_r cachedir, YARD_DIR

    puts "Version: #{version}"
    File.write("VERSION", version)

    system "gem build .gemspec"
  end
end

task :release => :build do
  system "gem push #{project_name}-#{gem_version}.gem"
end

task :install => :build do
  system "gem install #{project_name}-#{gem_version}.gem"
end

###############################################################################

task :download do
  Dir.mkdir RUBIES_DIR unless File.directory? RUBIES_DIR

  require "latest_ruby"

  %w[ruby19  ruby20  ruby21].each do |ver|
    url = Latest.send(ver).link
    system "wget -c #{url} --directory-prefix=#{RUBIES_DIR}"
  end
end

###############################################################################

task :docs do

  Dir["#{RUBIES_DIR}/*"].each do |tarball|

    ## Get version from tarball

    if tarball =~ /ruby-([\d\.]+)(-p\d+)?\.tar\.gz$/
      version = $1
    else
      raise "Couldn't parse version from: #{tarball}"
    end

    # Make sure 'cache/' exists

    Dir.mkdir CACHE_DIR unless File.directory? CACHE_DIR

    # Skip this ruby version if it's already been generated
    cache_dir = "#{CACHE_DIR}/#{version}"

    if File.exists? cache_dir
      puts "Skipping #{cache_dir}"
      next
    end

    # Make "src/"

    FileUtils.rm_r SRC_DIR if File.directory? SRC_DIR
    Dir.mkdir SRC_DIR

    # Untar ruby source
    system "tar zxvf #{tarball} --directory=#{SRC_DIR}"

    # Change into the untarred directory
    ruby_dir = Dir["#{SRC_DIR}/*"].first
    Dir.chdir ruby_dir

    # Find all the source files
    files = `find . -maxdepth 1 -name '*.c'`.each_line.to_a + `find ext -name '*.c'`.each_line.to_a
    files.map!(&:chomp)

    # system %{bash -c "cat <(find . -maxdepth 1 -name '*.c') <(find ext -name '*.c') | xargs yardoc --no-output --markup markdown"}

    # Yard them!
    system "yardoc", "--no-output", *files   # "--markup", "markdown"

    # Move ruby/ruby-<verison>/.yardoc to cache_dir
    Dir.chdir "../.."
    FileUtils.mv "#{ruby_dir}/.yardoc", cache_dir

    # Cleanup
    FileUtils.rm_r SRC_DIR
  end
end

###############################################################################
