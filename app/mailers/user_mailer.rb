# -*- encoding : utf-8 -*-
class UserMailer < ActionMailer::Base
  default :from => "my.telasi.ge <sys@telasi.ge>"

  #
  # მომხმარებელზე დადასტურების კოდის გაგზავნა.
  #
  # დადასტურების მისამართის ფორმატია:
  #
  # <code>http://service.telasi.ge/confirm?c=confirm_code&id=user_id</code>
  #
  # სადაც, <code>confirm_code</code> არის მომხმარებლის დადასტურების კოდი,
  # ხოლო <code>user_id</code> არის მომხმარებლის საიდენტიფიკაციო ნომერი.
  #
  def email_confirmation(user)
    @user = user
    @url = confirm_url(:host => Telasi::HOST, :c => @user.email_confirm_hash, :id => @user.id)
    mail(:to => "#{@user.full_name} <#{@user.email}>", :subject => I18n.t('models.sys_user.actions.confirm_email'))
  end

  # #
  # # მომხმარებელზე აღდგენის პაროლის გაგზავნა.
  # #
  # def restore_password(user)
  #   @user = user
  #   @user.prepeare_restore!
  #   @url = new_password_url(:host => Telasi::HOST, :id => @user.id, :h => @user.new_password_hash)
  #   mail(:to => "#{@user.full_name} <#{@user.email}>", :subject => 'პაროლის აღდგენა')
  # end

end
