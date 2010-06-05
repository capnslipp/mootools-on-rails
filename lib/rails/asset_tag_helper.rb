module ActionView::Helpers::AssetTagHelper
  alias_method :rails_javascript_include_tag, :javascript_include_tag
  
  MOOTOOLS_CORE_SOURCE = 'mootools-1.2.4-core'
  MOOTOOLS_MORE_SOURCE = 'mootools-1.2.4.4-more'
    
  def javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys
    @sources = sources
    @min  = options.delete('min')
    
    replace_source(
      :defaults,
      [:mootools, 'application', :behaviours]
    )
    
    replace_source(
      :mootools,
      [minifiable(MOOTOOLS_CORE_SOURCE), minifiable(MOOTOOLS_MORE_SOURCE), 'mootools_patch']
    )
    
    replace_source(
      :behaviours,
      [behaviours_url]
    )
    
    rails_javascript_include_tag(*@sources)
  ensure
    @sources, @min = nil
  end
  
  protected
    def replace_source(original_source, replacement_sources)
      replace_index = @sources.index(original_source)
      unless replace_index.nil?
        # insert after, preserving the index of the source we're replacing
        @sources.insert(replace_index + 1, *replacement_sources)
        @sources.delete_at(replace_index)
      end
      @sources
    end
    
    def minifiable(source)
      source += '.min' if @min
      source
    end
    
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