module PaginatingSelectHelper
  # text_field_with_paginating_select(object, method, tag_options = {}, partial, remote_options = {})
  # object, method and tag_options are default arguments for text_field
  # For partial_options, use the following:
  # :view - name of the partial
  # :object - the @object to be passed to the partial, use Pagination Collection
  #           if you want pagination
  # If you want to have an event observer, include the following options
  # for remote_options:
  # :url - controller/action, include params
  # :partial - id of the div to update
  # :loading - while js is loading
  # :loaded - after js has loaded
  #
  # Example:
  #
  def text_field_with_paginating_select(object, method, tag_options = {}, partial_options = {}, remote_options = {})
    @object = object
    @method = method
    page = "document.onload=setBd();"
    page << "function setBd(){"
    page << "$('bd').style.position = 'static';"
    page << "}"
    
    content_tag("div", :class => 'paginating_select') do
      text_field(object, method, tag_options) +
      link_to_function(image_tag('arrowbullet.gif', :plugin => 'paginating_select', :id => "#{method}_img", :class => 'tip-img'), "display_options('#{method}_div', '#{method}_img');setRadioButtons('#{method}_options', '#{object}_#{method}');") +
      content_tag("div", :id => "#{method}_div", :class => "tip-div", :style => "display:none;") do
        content_tag("div", :class => "tip-border") do
          content_tag("div", :id => "#{method}_options") do
            render :partial => partial_options[:view], @object => partial_options[:object] 
          end
        end
      end +
      
      unless remote_options.empty?
        javascript_tag(page) +
        observe_field("#{object}_#{method}", :url => remote_options[:url], :with => 'return', :loading => "Element.hide('"+ remote_options[:partial] + "');" + remote_options[:loading], :loaded => "Element.show('"+ remote_options[:partial] + "');" + remote_options[:loaded])  
      else
        javascript_tag(page)
      end
    end
  end

  # Put this in the partial
  # Arguments:
  # collection - collection from controller, must be a Paginating 
  #              Collection if you want pagination
  # field - the value that will be displayed, 
  #         this can be a model attribute or a class method
  # Options:
  # :empty_text - The phrase that will be displayed if collection is empty,
  #               default will be "No Records Found"
  # :object - Pass the object if you'll be using pagination
  # :method - Pass the method if you'll be using pagination
  # * object and method should be same as the one used in text_field
  # For paginating_options:
  # The required gem for pagination is mislav_will_paginate
  # :param_name - name of the page param, default is :page
  # :page - params[:page]
  # :params - additional params you want to pass
  # and the following params from will_paginate
  # :inner_window, :outer_window and :renderer
  # 
  # If you want to have an event observer, include the following options
  # For remote_options:
  # :url - controller/action, include params
  # :partial - partial to update
  # :loading - while js is loading
  # :loaded - after js has loaded
  # Output
  # It outputs params[:return] which is the display value of the chosen radio
  # button
  # Example:
  #
  def paginating_select_result(collection, field, options= {}, paginating_options= {}, remote_options={})
    if collection.empty?
      h options[:empty_text] || "No Records Found"
    else
      @object ||= options[:object]
      @method ||= options[:method]

      radios = collection.map {|col| tag(:input, :type => "radio", :name => @method, :value => "#{col[field.to_sym].nil? ? col.method(field).call : col[field.to_sym]}", :onclick => "$('#{@object}_#{@method}').value = this.value;#{remote_options.empty? ? '' : remote_function(:url => remote_options[:url].merge(:return => (col[field.to_sym].nil? ? col.method(field).call : col[field.to_sym])), :loading => "Element.hide('"+ remote_options[:partial] + "');" + remote_options[:loading], :loaded => "Element.show('"+ remote_options[:partial] + "');" + remote_options[:loaded])}") + (col[field.to_sym].nil? ? col.method(field).call : col[field.to_sym]) + tag("br")}

      content_tag("div", :style => "float:right;") do
        link_to_function image_tag('close.gif', :plugin => 'paginating_select', :style => 'margin-top:0px;'), "Element.hide('#{@method}_div');"
      end +

      content_tag("div", radios) +
      add_radio_button_setter(@object, @method) + 
      add_pagination(collection, paginating_options, "#{@method}_options")
    end
  end

  def add_radio_button_setter(object, method)
      function = "setRadioButtons("
      function << "'#{method}_options', "
      function << "'#{object}_#{method}'"
      function << ");"
      
      javascript_tag(function)  
  end

  def add_pagination(collection, options, partial_id)
      param_name = options[:param_name].to_sym
      page = options[:page]
      pagination_params = options[:params].nil? ? {param_name => page} : {param_name => page}.merge(options[:params])
      inner_window = options[:inner_window] || 1
      outer_window = options[:outer_window] || 0
      renderer = options[:renderer] || 'RemoteLinkRenderer'

      will_paginate(collection, :inner_window => inner_window, :outer_window => outer_window, :renderer => renderer, :param_name => param_name, :params => pagination_params, :remote => {:update => partial_id})
  end
end
