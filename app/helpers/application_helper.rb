module ApplicationHelper
  def javascript(files, options = {})
    if options[:plugin]
      javascript_include_tag files.map {|f| "vendor/plugins/#{options[:plugin].to_s}/#{f}"}, options
    else
      javascript_include_tag files, options
    end
  end
end
