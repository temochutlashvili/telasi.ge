# -*- encoding : utf-8 -*-
class Sys::User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Telasi::StandardPhoto
  # include Telasi::Queryable

  attr_accessor :password_confirmation
  field :email, type: String
  field :salt, type: String
  field :hashed_password, type: String
  field :mobile, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :sys_admin, type: Boolean

  validates :salt, presence: { message: 'empty password' }
  validates :hashed_password, presence: { message: 'empty password' }
  validates :email,  presence: { message: I18n.t('models.sys_user.errors.empty_email') }
  validates :mobile, presence: { message: I18n.t('models.sys_user.errors.empty_mobile') }
  validates :first_name, :message => 'ჩაწერეთ სახელი'
  validates :last_name, :message => 'ჩაწერეთ გვარი'
  validates :password, confirmation: { :message => 'პაროლი არ ემთხვევა' }
  validates :email, uniqueness: { :message => 'ეს მისამართი უკვე რეგისტრირებულია' }
  validate :mobile_format, :email_format, :password_presence

  before_create :before_user_create
  before_update :before_user_update

  # index :email
  # index :bs_login
  # index [[:email, Mongo::ASCENDING], [:mobile, Mongo::ASCENDING], [:first_name, Mongo::ASCENDING], [:last_name, Mongo::ASCENDING]]

  # მომხმარებლის ავტორიზაცია.
  def self.authenticate(email, pwd)
    user = User.where(:email => email).first
    user if user and Digest::SHA1.hexdigest("#{pwd}dimitri#{user.salt}") == user.hashed_password
  end

  # # მომხმარებლის ავტორიზაცია: ბილინგის მომხმარებლით.
  # def self.authenticate_bs(username, pwd)
  #   user = User.where(:bs_login => username).first
  #   user if user and Digest::SHA1.hexdigest("#{pwd}dimitri#{user.salt}") == user.hashed_password
  # end

  # # მობილურის "კომპაქტიზაცია": ტოვებს მხოლოდ ციფრებს.
  # def self.compact_mobile(mob)
  #   mob.scan(/[0-9]/).join('') if mob
  # end

  # # ამოწმებს მობილურის ნომრის კორექტულობას.
  # # კორექტული მობილურის ნომერი უნდა შეიცავდეს 9 ციფრს.
  # def self.correct_mobile?(mob)
  #   not not (compact_mobile(mob) =~ /^[0-9]{9}$/)
  # end

  # # ელ.ფოსტის შემოწმება.
  # def self.correct_email?(email)
  #   not not (email =~ /^\S+@\S+$/)
  # end

  # def self.by_q(q)
  #   self.search_by_q(q, :email, :mobile, :first_name, :last_name)
  # end

  def password=(pwd)
    @password = pwd
    unless pwd.nil? or pwd.strip.empty?
      self.salt = "salt#{rand 100}#{Time.now}"
      self.hashed_password = Digest::SHA1.hexdigest("#{pwd}dimitri#{salt}")
    end
  end

  def password; @password end
  def full_name; "#{self.first_name} #{self.last_name}" end

  # აგენერირებს აღდგენის კოდს ამ მომხამრებლისთვის.
  def prepeare_restore!
    self.new_password_hash = Digest::SHA1.hexdigest("#{self.email}#{rand 1000}dimitri#{Time.now}")
    self.save
  end

  # def has_role?(role)
  #   if role.is_a? Array
  #     role.each { |r| return true if self.has_role?(r) }
  #     false
  #   elsif role.to_sym == :all
  #     true
  #   else
  #     self.send(role.to_sym) if self.respond_to?(role.to_sym)
  #   end
  # end

  private

  def mobile_format
    if self.mobile and not User.correct_mobile?(self.mobile)
      errors.add(:mobile, 'არასწორი მობილური') 
    end
  end

  def email_format
    if self.email and not User.correct_email?(self.email)
      errors.add(:email, 'არასწორი ელ. ფოსტა')
    end
  end

  def password_presence
    if self.hashed_password.nil? and self.password.nil?
      errors.add(:password, 'ჩაწერეთ პაროლი')
    end
  end

  def before_user_create
    is_first = User.count == 0
    self.sys_admin = is_first if self.sys_admin.nil?
    self.email_confirmed = is_first if self.email_confirmed.nil?
    self.mobile_confirmed = false if self.mobile_confirmed.nil?
    self.mobile = User.compact_mobile(self.mobile)
    self.email_confirm_hash = Digest::SHA1.hexdigest("#{self.email}#{rand 100}#{Time.now}") unless self.email_confirmed
    true
  end

  def before_user_update
    self.mobile = User.compact_mobile(self.mobile)
  end

end