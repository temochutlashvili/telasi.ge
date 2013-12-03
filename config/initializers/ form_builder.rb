# -*- encoding : utf-8 -*-
class ActionView::Helpers::FormBuilder
  def b_email_field(name, opts = {}); b_field('email',name,opts) end
  def b_text_field(name, opts = {}); b_field('text',name,opts) end
  def b_password_field(name, opts = {}); b_field('password',name,opts) end
  def b_date_field(name, opts = {}); b_field('date',name,opts) end

  private

  def b_errors(name); object.errors[name.to_sym] end

  def b_field(type, name, opts)
    clz = ['form-group']
    clz << 'has-error' if b_errors(name).present?
    %Q{<div class="#{clz.join(' ')}">#{label_tag(name,opts)}#{input_tag(type,name,opts)}#{error_span(name)}</div>}.html_safe
  end

  def label_tag(name, opts)
    unless opts[:label] == false
      label(name, opts.delete(:label))
    end
  end

  def error_span(name)
    errs = b_errors(name)
    %Q{<span class="text-danger">#{errs[0]}</span>} if errs.present?
  end

  def input_tag(type, name, opts)
    opts[:class] ||= []
    opts[:class] << 'form-control'
    case type
    when 'text' then text_field(name, opts)
    when 'password' then password_field(name, opts)
    when 'email' then email_field(name, opts)
    when 'date' then date_field(name, opts)
    end
  end
end
