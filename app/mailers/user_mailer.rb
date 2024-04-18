# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    mail(
      to: 'gorrus100@gmail.com',
      subject: params[:subject],
      category: 'Test category',
      custom_variables: { test_variable: 'abc' }
    )
  end
end
