# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'ritex'
require 'matrix'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9ca2b52a1be8f09711f1bc945f693c5a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  after_filter :set_content_type
  before_filter :load_ritex
  
  private
    def load_ritex
      @math = Ritex::Parser.new
    end
  
    def set_content_type
      response.headers['Content-Type'] = 'application/xhtml+xml; charset=utf-8'
    end
end
