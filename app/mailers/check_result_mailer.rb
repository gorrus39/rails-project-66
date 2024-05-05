# frozen_string_literal: true

class CheckResultMailer < ApplicationMailer
  def failed_check_email
    mail(
      to: params[:email]
      # subject: 'Result before linting your repository'
    )
  end

  def passed_check_email
    mail(
      to: params[:email]
      # subject: 'Result before linting your repository'
    )
  end
end
