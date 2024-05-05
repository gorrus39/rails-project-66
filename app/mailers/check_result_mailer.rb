# frozen_string_literal: true

class CheckResultMailer < ApplicationMailer
  before_action :set_vars

  def failed_check_email
    mail(
      to: @user.email,
      subject: t('.failed_check')
    )
  end

  def error_check_email
    mail(
      to: @user.email,
      subject: t('.error_check')
    )
  end

  def passed_check_email
    mail(
      to: @user.email,
      subject: t('.passed_check')
    )
  end

  private

  def set_vars
    @repository = ::Repository.find(params[:repository_id])
    @user = User.find(params[:user_id])
  end
end
