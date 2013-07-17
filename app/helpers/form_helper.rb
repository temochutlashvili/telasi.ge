# -*- encoding : utf-8 -*-
module FormHelper
  def rich_form(model, h = {})
    h.symbolize_keys!
    h[:auth_token] = form_authenticity_token
    form = RichForm.new(model, h)
    yield form if block_given?
    form.html
  end

  private

  class RichForm
    include Forma::Html

    def initialize(model, h)
      @model = model
      @auth_token = h[:auth_token]
      @fields = []
    end

    def text_field(name, h = {}); @fields << TextField.new(name, @model, h) end
    def password_field(name, h = {}); @fields << TextField.new(name, @model, h.merge(password: true)) end
    def submit(text); @submit = text end
    def cancel_url(url); @cancel_url = url end

    def html
      def form_method; (@model.respond_to?(:new_record?) and not @model.new_record?) ? 'put' : 'post' end
      el('form',
        attrs: { method: 'post', 'accept-charset' => 'UTF-8', class: 'rich-form' },
        children: [
          el('ul',
            children:
              [ el('input', attrs: { type: 'hidden', name: 'authenticity_token', value: @auth_token }) ] +
              [ el('input', attrs: { type: 'hidden', name: '_method', value: form_method }) ] +
              @fields.map { |f| el('li', children: [ f.to_e ] ) } +
              [ el('li', attrs: { class: 'bottom-actions' }, children: [
                el('button', attrs: { type: 'submit' }, text: @submit),
                ( el('a', attrs: { href: @cancel_url }, text: I18n.t('models.general.actions.cancel')) if @cancel_url.present? )
              ])
          ])
        ]
      )
    end
  end

  class Field
    include Forma::Html

    def initialize(name, model, h)
      @model = model
      @model = @model.symbolize_keys if @model.is_a?(Hash)
      @name = name
      @label = h[:label]
      @autofocus = h[:autofocus]
    end

    def names_chain
      if @model.respond_to?(:table_name) then [ @model.table_name, @name ]
      elsif @model.respond_to?(:model_name) then [ @model.model_name.singular_route_key, @name ]
      else [ @name ] end
    end
    def field_name; names = names_chain; if names.length == 1 then names[0] elsif names.length == 2 then "#{names[0]}[#{names[1]}]" end end
    def field_id; "field_#{names_chain.join('_')}" end
    def field_value; if @model.is_a?(Hash) then @model[@name.to_sym] else @model.send(@name) end end
    def errors
      if @model.respond_to?(:errors)
        errors = @model.errors[@name.to_sym]
        errors.join('; ') if errors.present?
      end
    end
  end

  class TextField < Field
    include Forma::Html

    def initialize(name, model, h)
      super
      @password = h[:password] || false
    end

    def to_e
      def field_type; @password ? 'password' : 'text' end
      def label_text; @label ? @label : I18n.t("models.#{names_chain.join('.')}") end
      def field_class; if self.errors.present? then [ 'field', 'field-error' ] else [ 'field-error' ] end end
      error_message = self.errors
      el('div', attrs: { class: 'field' }, children: [
        el('label', attrs: { for: field_id }, text: label_text),
        el('input', attrs: { id: field_id, name: field_name, type: field_type, value: field_value, autofocus: @autofocus }),
        (el('div', attrs: { class: 'errors' }, text: error_message) if error_message.present?)
      ])
    end
  end
end
