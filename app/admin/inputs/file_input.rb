class FileInput < Formtastic::Inputs::FileInput
  def to_html
    input_wrapping do
      label_html <<
        builder.file_field(method, input_html_options) <<
        image_preview_content
    end
  end

  private

  def image_preview_content
    image_preview? ? image_preview_html : ''
  end

  def image_preview?
    options[:image_preview] && @object.send(method).present?
  end

  def image_preview_html
    template.content_tag(
      :p,
      image_tag_or_text,
      class: builder.default_hint_class
    )
  end

  def image_tag_or_text
    template.image_tag(@object.send(method).url(:admin), class: 'image-preview')
  rescue
    @object.send(method).url(:admin)
  end
end
