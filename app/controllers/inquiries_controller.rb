# app/controllers/inquiries_controller.rb

class InquiriesController < ApplicationController
 
  def new
    @inquiry = Inquiry.new
  end
  
  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      # お問い合わせを保存した後、メールを送信する
      InquiryMailer.notify_admin(@inquiry).deliver_now
      redirect_to root_path, notice: "お問い合わせを送信しました。"
    else
      render :new
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :message)
  end
end
