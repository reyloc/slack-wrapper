module Slack
  class Errors
    def initialize(object)
      handle(object)
    end
    def handle(object)
      raise RuntimeError, message(object)
    end
    def message(object)
      case object['error']
        when nil
          error = "Undefined Error"
        when "not_authed"
          object['detail'] = "Invalid Token, check configuration"
        when String
          error = object['error']
      end
      case object['detail']
        when nil
          detail = "Details unknown"
        when String
          detail = object['detail']
      end
      "Error '#{error}' occured. Details: #{detail}"
    end
  end
end
