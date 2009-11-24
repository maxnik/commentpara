module CustomFormBuilderHelper
  def custom_form_for(name, *args, &block)
    options = args.last.is_a?(Hash) ? args.pop : { }
    options[:html] ||= { }
    options[:html][:class] = 'custom-form'
    options.merge!(:builder => CustomFormBuilder)
    args << options
    form_for(name, *args, &block)
  end
end
