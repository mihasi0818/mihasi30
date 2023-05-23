# app/mailers/inquiry_mailer.rb

class InquiryMailer < ApplicationMailer
    def notify_admin(inquiry)
      @inquiry = inquiry
      mail(to: ENV['SENDER_ADDRESS'], from: ENV['SENDER_ADDRESS'], subject: 'お問い合わせがありました')
    end
  end
  