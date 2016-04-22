class AnswersMailer < ApplicationMailer

  def notify_question_owner(answer)
    @answer = answer
    @question = answer.question
    @owner = @question.user
    # don't send e-mail unless owner exists
    return unless @owner
    mail(to: @owner.email, subject: "You got an answer!")
    #mail(to: "frankliu81@gmail.com", subject: "You got an answer!")
  end

end
