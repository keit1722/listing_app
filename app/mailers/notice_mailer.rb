class NoticeMailer < ApplicationMailer
  def post
    @user_to = params[:user_to]
    @post = params[:post]

    mail(
      to: @user_to.email,
      subject: "#{@post.postable.name} が新しく投稿をしました"
    )
  end
end
