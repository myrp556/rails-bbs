module CustomHelper
  def make_error_message(model)
    if !model.errors.messages.nil?
      I18n.t(model.errors.messages.keys()[0]) + model.errors.messages[model.errors.messages.keys()[0]][0]
    else
      'rua'
    end
  end
end
