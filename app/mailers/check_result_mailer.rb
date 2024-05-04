# frozen_string_literal: true

class CheckResultMailer < ApplicationMailer
  def notify_when_linter_failed
    mail(
      to: 'gorrus100@gmail.com',
      subject: params[:subject],
      category: 'notify'
    )
  end
end
