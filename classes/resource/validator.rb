[
  'date'
].each {|resource| require resource}

class ValidationError < ArgumentError; end

module Validator
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def email_rule(value)
    unless value =~ VALID_EMAIL_REGEX
      raise ValidationError, 'Email is not valid'
    end 
  end

  def date_rule(value)
    begin
      Date.parse(value)
    rescue ArgumentError
      raise ValidationError, 'Date is not valid'
    end
  end

  def validate(rules={})
    rules.map do |key, value|
      begin
        self.public_send key, value
      rescue NoMethodError
        raise ArgumentError, "Rule <#{key}> is not supported"
      end
    end
  end
end