# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthManagement
  include Pundit::Authorization
end
