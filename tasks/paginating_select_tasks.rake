# desc "Explaining what the task does"
# task :paginating_select do
#   # Task goes here
# end

namespace :paginating_select do
  desc "Copy javascript and stylesheet(css) files to public directory"
  task :export_js_css => :environment do
    system "echo Exporting public files..."
    system "cp vendor/plugins/paginating_select/public/stylesheets/paginating_select.css public/stylesheets/"
    system "cp vendor/plugins/paginating_select/public/javascripts/paginating_select.js public/javascripts/"
    system "echo Files exported successfully!"
  end

  desc "Copy javascript and stylesheet(sass) files to public directory"
  task :export_js_sass => :environment do
    system "echo Exporting public files..."
    system "cp vendor/plugins/paginating_select/public/stylesheets/sass/paginating_select.sass public/stylesheets/sass/"
    system "cp vendor/plugins/paginating_select/public/javascripts/paginating_select.js public/javascripts/"
    system "echo Files exported successfully!"
  end
end
