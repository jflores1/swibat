class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  protected
  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :p, "None provided yet...", class:"none-provided"
    end
  end


end