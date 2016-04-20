class User < ActiveRecord::Base
  # has_secure_password does the following:
  # 1 - it adds attribute accessors: password and password_confirmation
  # 2 - It adds validation: password must be present on creation
  # 3 - If password confirmation is present, it will make sure it's equal to password
  # 4 - Password length should be less than or equal to 72 characters
  # 5 - It will has the password using BCrypt and stores the hash
  # digest in the password_digest field
  has_secure_password

  # this was to show that you can add attr_accessor to the ActiveRecord
  # object, even though it will just exist in memory, and not be saved to the db
  # attr_accessor :abc

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify


  validates :first_name, presence: true
  validates :last_name, presence: true
  #validates :email, uniqueness: true, presence: true
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, uniqueness: true, presence: true, format: VALID_EMAIL_REGEX

  def full_name
    # if one of them is nil, it will throw exception
    # string interpolation also more efficient
    # first_name + " " + last_name
    "#{first_name} #{last_name}"
  end

end
