module ProfanitySanitizer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def sanitize_profanity_in(*attributes)
      attributes.each do |attribute|
        sanitized_method, unsanitized_method = "#{attribute}_with_sanitization", "#{attribute}_without_sanitization"

        define_method sanitized_method do
          send(unsanitized_method).gsub("darn", "****")
        end
        alias_method unsanitized_method, attribute
        alias_method attribute, sanitized_method

        define_method "profane_#{attribute}?" do
          send(unsanitized_method) != send(sanitized_method)
        end
      end

      define_method :profane_attributes do
        attributes.select { |attribute| send("profane_#{attribute}?") }
      end
    end
  end
end