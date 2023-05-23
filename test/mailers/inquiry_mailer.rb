# app/mailers/inquiry_mailer.rb
class InquiryMailer < ApplicationMailer
    def notify_admin(inquiry)
      @inquiry = inquiry
      mail to: 'admin@example.com', subject: 'お問い合わせがありました'
    end
  end
  