# use = 'stylesheet_to_use'
# if use = 'sass'
# file = 'file_to_write_import'
namespace :paginating_select do
  PLUGIN_PATH = "vendor/plugins/paginating_select"
  desc "Copy javascript and stylesheet(css) files to public directory"
  task :export do
    system "echo Exporting public files..."
    if ENV['use'] == 'sass'
      puts "Exporting sass files..."
      FileUtils.mkdir_p "public/stylesheets/sass"
      FileUtils.cp "#{PLUGIN_PATH}/public/stylesheets/sass/_paginating_select.sass", "public/stylesheets/sass"
      sass_file = "#{RAILS_ROOT}/public/stylesheets/sass/#{ENV['file']}"
      File.open(sass_file, 'a') do |f|
        f.write('@import paginating_select.sass')
      end
    else
      puts "Exporting css files..."
      FileUtils.cp  "#{PLUGIN_PATH}/public/stylesheets/paginating_select.css", "public/stylesheets"
    end
    puts "Exporting js files..."
    FileUtils.cp "#{PLUGIN_PATH}/public/javascripts/paginating_select.js", "public/javascripts"

    puts "Exporting image files..."
    FileUtils.mkdir_p "public/images/paginating_select"
    FileUtils.cp_r "#{PLUGIN_PATH}/public/images/.", "public/images/paginating_select"
    puts "Files exported successfully!"
  end
end
