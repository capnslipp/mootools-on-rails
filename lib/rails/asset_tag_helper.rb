module ActionView::Helpers::AssetTagHelper
  alias_method :rails_javascript_include_tag, :javascript_include_tag
  
  MOOTOOLS_CORE_SOURCE = 'mootools-1.2.4-core'
  MOOTOOLS_MORE_SOURCE = 'mootools-1.2.4.4-more'
  JAVASCRIPT_DEFAULT_SOURCES = [MOOTOOLS_CORE_SOURCE, MOOTOOLS_MORE_SOURCE, 'application', 'mootools_patch']
  @@javascript_default_sources = JAVASCRIPT_DEFAULT_SOURCES.dup
    
  def javascript_include_tag(*sources)
    if sources.delete :mootools
      sources = sources.concat(
        [MOOTOOLS_CORE_SOURCE, MOOTOOLS_MORE_SOURCE, 'application', behaviours_url]
      ).uniq
    elsif sources.delete :defaults
      sources = [MOOTOOLS_CORE_SOURCE, MOOTOOLS_MORE_SOURCE, 'mootools_patch', 'application', behaviours_url].concat(sources)
    end
    
    
    rails_javascript_include_tag(*sources)
  end
  
  protected  
    def behaviours_url
      action_path = case @controller.request.path
        when '', '/'
          '/index'
        else
          @controller.request.path
      end
      "/behaviours#{action_path}.js"
    end
end