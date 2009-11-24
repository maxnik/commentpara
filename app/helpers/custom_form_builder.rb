class CustomFormBuilder < ActionView::Helpers::FormBuilder

  %w(text_field password_field text_area).each do |field_type|
    define_method("#{field_type}_for") do |attr, *args|
      options = { }
      options.merge!(args.last) if args.last.is_a?(Hash)
      options[:default] ||= @object.send(attr) unless object.nil?
      options[:label] ||= @object.class.human_attribute_name(attr)
      options[:param_name] ||= "#{@object_name}[#{attr}]"
      error = case
              when @object.nil?
                options[:error]
              when @object.errors.on(attr).is_a?(Array)
                @object.errors.on(attr).last
              else
                @object.errors.on(attr)
              end
      if error
        options[:bottom] = error
        bottom_p_class = 'error'
      end
      
      @template.content_tag(:div, :class => 'custom-field') do
        fragment = @template.content_tag(:label, :for => "#{@object_name}_#{attr}") { options[:label] } +
                   @template.send("#{field_type}_tag".to_sym, options[:param_name], options[:default], 
                                  :class => options[:class])
        if error
          fragment += @template.content_tag(:p, :class => bottom_p_class) { options[:bottom] }
        end
        fragment
      end
    end
  end
end
