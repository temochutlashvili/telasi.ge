# -*- encoding : utf-8 -*-
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :password_confirmation

  field :email, type: String
  field :salt, type: String
  field :hashed_password, type: String
  field :mobile, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :sys_admin, type: Boolean

  validates :email,      presence: { message: I18n.t('models.sys_user.errors.email_required') }
  validates :mobile,     presence: { message: I18n.t('models.sys_user.errors.password_required') }
  validates :first_name, presence: { message: I18n.t('models.sys_user.errors.first_name_required') }
  validates :last_name,  presence: { message: I18n.t('models.sys_user.errors.last_name_required') }

  before_create :before_user_create
  before_update :before_user_update

  index :email

  def self.authenticate(email, pwd)
    user = User.where(:email => email).first
    user if user and Digest::SHA1.hexdigest("#{pwd}dimitri#{user.salt}") == user.hashed_password
  end

  # def self.compact_mobile(mob)
  #   mob.scan(/[0-9]/).join('') if mob
  # end

  # def self.correct_mobile?(mob)
  #   not not (compact_mobile(mob) =~ /^[0-9]{9}$/)
  # end

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
  def to_s; self.full_name end

  # აგენერირებს აღდგენის კოდს ამ მომხამრებლისთვის.
  def prepeare_restore!
    self.new_password_hash = Digest::SHA1.hexdigest("#{self.email}#{rand 1000}dimitri#{Time.now}")
    self.save
  end

  private

  # def mobile_format
  #   if self.mobile and not User.correct_mobile?(self.mobile)
  #     errors.add(:mobile, 'არასწორი მობილური') 
  #   end
  # end

  # def email_format
  #   if self.email and not User.correct_email?(self.email)
  #     errors.add(:email, 'არასწორი ელ. ფოსტა')
  #   end
  # end

  # def password_presence
  #   if self.hashed_password.nil? and self.password.nil?
  #     errors.add(:password, 'ჩაწერეთ პაროლი')
  #   end
  # end

  # def before_user_create
  #   is_first = User.count == 0
  #   self.sys_admin = is_first if self.sys_admin.nil?
  #   self.email_confirmed = is_first if self.email_confirmed.nil?
  #   self.mobile_confirmed = false if self.mobile_confirmed.nil?
  #   self.mobile = User.compact_mobile(self.mobile)
  #   self.email_confirm_hash = Digest::SHA1.hexdigest("#{self.email}#{rand 100}#{Time.now}") unless self.email_confirmed
  #   true
  # end

  # def before_user_update
  #   self.mobile = User.compact_mobile(self.mobile)
  # end
end
