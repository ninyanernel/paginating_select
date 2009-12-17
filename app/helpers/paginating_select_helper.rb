module PaginatingSelectHelper
  # text_field_with_paginating_select(object, method, tag_options = {}, partial, remote_options = {})
  # object, method and tag_options are default arguments for text_field
  # For partial_options, use the following:
  # :view - name of the partial
  # :object - the @object to be passed to the partial, use WillPaginate::Collection
  #           if you want pagination
  # If you want to have an event observer, include the following options
  # for remote_options:
  # :url - controller/action, include params
  # :partial - id of the div to update
  # :loading - while js is loading
  # :loaded - after js has loaded
  def text_field_with_paginating_select(object, method, tag_options = {}, partial_options = {}, remote_options = {})
    @object = object
    @method = method
    page = "document.onload=setBd();"
    page << "function setBd(){"
    page << "$('bd').style.position = 'static';"
    page << "}"
    
    content_tag("div", :class => 'paginating_select') do
      text_field(object, method, tag_options) +
      link_to_function(image_tag('paginating_select/arrowbullet.gif', :id => "#{method}_img", :class => 'tip-img'), "display_options('#{method}_div', '#{method}_img');setRadioButtons('#{method}_options', '#{object}_#{method}');") +
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

  def text_area_with_paginating_select(object, method, tag_options = {}, partial_options = {}, remote_options = {})
    @object = object
    @method = method
    page = "document.onload=setBd();"
    page << "function setBd(){"
    page << "$('bd').style.position = 'static';"
    page << "}"
    
    content_tag("div", :class => 'paginating_select') do
      text_area(object, method, tag_options) +
      link_to_function(image_tag('paginating_select/arrowbullet.gif', :id => "#{method}_img", :class => 'tip-img'), "display_options('#{method}_div', '#{method}_img');setRadioButtons('#{method}_options', '#{object}_#{method}');") +
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
  # collection - collection from controller, must be a WillPaginate::Collection
  #              if you want pagination
  # field - the value that will be displayed, 
  #         this can be a model attribute or a class method
  # For options:
  # :empty_text - The phrase that will be displayed if collection is empty,
  #               default will be "No Records Found"
  # :object - Pass the object if you'll be using pagination
  # :method - Pass the method if you'll be using pagination
  # :multiple - Set to 'true' if you want check boxes, set to 'false' if you
  #             want radio buttons
  # * object and method should be same as the one used in text_field
  # For paginating_options:
  # The required gem for pagination is mislav_will_paginate
  # :param_name - name of the page param, default is :page, must be unique
  # :page - params[:page]
  # :params - additional params you want to pass
  # and the following params from will_paginate
  # :inner_window, :outer_window, :method and :renderer
  #
  # If you want to have an event observer, include the following options
  # For remote_options:
  # :url - controller/action, include params
  # :partial - div id to update
  # :loading - while js is loading
  # :loaded - after js has loaded
  # For search_options:
  # :field_name - id of the text_field, defaults to #{method}_search
  # :url - url for the search action
  # :method - request method
  # :params - additional params needed
  #
  # Output
  # * It outputs params[:return] which is the display value of the chosen radio
  # button
  # * params[#{:field_name}] will contain the seach text
  def paginating_select_result(collection, field, options= {}, paginating_options= {}, remote_options={}, search_options= {})
    @object ||= options[:object]
    @method ||= options[:method]
    param_name = paginating_options[:param_name].to_sym
    add_close_button(@method) +
    if collection.empty?
        add_search_tag(@method, search_options, {param_name=>"1"}) +
        h(options[:empty_text] || "No Records Found")
    else
      add_search_tag(@method, search_options, {param_name=>"1"}) +
      add_radio_buttons(@object, @method, collection, field, options, paginating_options, remote_options, search_options) 
    end
  end
 
  def add_close_button(method)
    content_tag("div", :style => "float:right;") do
      link_to_function image_tag('paginating_select/close.gif', :plugin => 'paginating_select', :style => 'margin-top:0px;'), "Element.hide('#{method}_div');"
    end
  end

  def add_search_tag(method, options, page_param)
    if options.empty?
      return ""
    else
      field_name = options[:field_name] || "#{method}_search"
      options[:params].merge!(page_param)
      param = options[:params].map {|key, value| " + '&#{key}=#{value}'"}.join
      js_params = ["'#{field_name}=' + $F('#{field_name}').to_hex()", param].join
      content_tag("div", :class => "ps-search-field") do
        text_field_tag(field_name) +
        link_to_remote(image_tag('paginating_select/search.gif'), :url => options[:url], :method => options[:method], :with => js_params, :update => "#{method}_options", :loading => "Element.show('#{method}-ps-search-load');", :loaded => "Element.hide('#{method}-ps-search-load');") + 
        
        # Reload
        content_tag("div", :id => "#{method}-ps-reload") do
          link_to_remote(image_tag('paginating_select/reload.gif'), :url => options[:url], :method => options[:method], :with => ["'#{field_name}=' + ''", param].join, :update => "#{method}_options", :loading => "Element.show('#{method}-ps-search-load');", :loaded => "Element.hide('#{method}-ps-search-load');")  
        end +

        # Loader
        content_tag("div", :id => "#{method}-ps-search-load", :style => "display:none;") do
          image_tag('paginating_select/spinner.gif')
        end  
      end
    end
  end

  def add_radio_buttons(object, method, collection, field, options ={}, paginating_options={}, remote_options= {}, search_options= {})
    field_name = search_options[:field_name] || "#{method}_search" unless search_options.empty?
    type = options[:multiple].eql?('true') ? "checkbox" : "radio"
    event = type.eql?('radio') ? "$('#{object}_#{method}').value = this.value" : "updateTextMultiple('#{method}_options', '#{object}_#{method}')"
    radios = collection.map {|col| tag(:input, :type => type, :name => method, :value => "#{col[field.to_sym].nil? ? col.method(field).call : col[field.to_sym]}", :onclick => "#{event};#{remote_options.empty? ? '' : remote_function(:url => remote_options[:url].merge(:return => (col[field.to_sym].nil? ? col.method(field).call : col[field.to_sym])), :loading => "Element.hide('"+ remote_options[:partial] + "');" + remote_options[:loading], :loaded => "Element.show('"+ remote_options[:partial] + "');" + remote_options[:loaded])}") + (col[field.to_sym].nil? ? col.method(field).call : col[field.to_sym]) + tag("br")}
    content_tag("div", radios) +
    if collection.total_pages == 1
      add_button_setter(object, method, type) 
    else
      add_button_setter(object, method, type) + 
      add_pagination(collection, paginating_options, "#{method}_options", search_options.empty? ? {} : {field_name.to_sym => params[field_name.to_sym]}.merge(search_options[:params])) 
    end
  end

  def add_button_setter(object, method, type)
      if type.eql?("radio")
        function = "setRadioButtons("
      else
        function = "setCheckboxes("
      end
      function << "'#{method}_options', "
      function << "'#{object}_#{method}'"
      function << ");"
      
      javascript_tag(function)  
  end

  def add_pagination(collection, options, partial_id, search_params)
    param_name = options[:param_name].to_sym
    page = options[:page] 
    page_params = options[:params].nil? ? {param_name => page} : {param_name => page}.merge(options[:params])
    pagination_params = page_params.merge(search_params)
    inner_window = options[:inner_window] || 1
    outer_window = options[:outer_window] || 0
    renderer = options[:renderer] || 'RemoteLinkRenderer'
    method = options[:method] || :get

    will_paginate(collection, :inner_window => inner_window, :outer_window => outer_window, :renderer => renderer, :param_name => param_name, :params => pagination_params, :remote => {:update => partial_id}, :method => method)
  end

end
